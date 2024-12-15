vim.g.mapleader = " "
-- Remove the default statuts line by using cmdheight=0
vim.opt.cmdheight = 0
vim.opt.number = true
vim.wo.relativenumber = true

-- Copied from installer.lua
local rocks_config = {
	rocks_path = vim.fn.stdpath("data") .. "/rocks",
	luarocks_binary = "luarocks",
}

vim.g.rocks_nvim = rocks_config

local luarocks_path = {
	vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?.lua"),
	vim.fs.joinpath(rocks_config.rocks_path, "share", "lua", "5.1", "?", "init.lua"),
}
package.path = package.path .. ";" .. table.concat(luarocks_path, ";")

local luarocks_cpath = {
	vim.fs.joinpath(rocks_config.rocks_path, "lib", "lua", "5.1", "?.so"),
	vim.fs.joinpath(rocks_config.rocks_path, "lib64", "lua", "5.1", "?.so"),
}
package.cpath = package.cpath .. ";" .. table.concat(luarocks_cpath, ";")

vim.opt.runtimepath:append(vim.fs.joinpath(rocks_config.rocks_path, "lib", "luarocks", "rocks-5.1", "rocks.nvim", "*"))

-- autocmd TermOpen term://* startinsert
--    autocmd TermEnter term://* startinsert
--    autocmd BufEnter term://* startinsert

local proj_config = {
	auto_format = false,
}
-- Read the project configuration (usually enabling the formatter)
-- local localconfpath = vim.fn.getcwd() .. "./.nvimrc.lua"
-- if vim.fn.filereadable(localconfpath) then
-- 	vim.secure.read(localconfpath)
-- end

vim.o.autowriteall = true

-- Used for which-key
vim.o.timeout = true
vim.o.timeoutlen = 300
-- which-key config
-- key_labels = {
-- 	["<Leader>"] = "SPC",
-- },

-- Use 4 spaces as tab
vim.o.shiftwidth = 4
vim.o.tabstop = 4

require("which-key").setup()
require("cutlass").setup({
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
	exclude = { "ns", "nS" },
	cut_key = "x",
})
-- require("nvim-biscuits").setup({})

require("crates").setup({
	src = {
		cmp = {
			enabled = true,
		},
	},
})

local builtin = require("statuscol.builtin")
require("statuscol").setup({
	relculright = true,
	segments = {
		{ text = { builtin.foldfunc }, click = "v:lua.ScFa" },
		{ text = { "%s" }, click = "v:lua.ScSa" },
		{ text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
	},
})
require("virt-column").setup()
require("neogit").setup({
	disable_signs = true,
	graph_style = "unicode",
	integrations = {
		diffview = true,
	},
})
require("diffview").setup({})

require("lsp_lines").setup()
vim.keymap.set("", "<Leader>ll", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })

require("monokai-pro").setup({
	filter = "spectrum",
	background_clear = { "float_win" },
	-- override = function(colors) end,
	overrideScheme = function(cs, p, config, hp)
		local cs_override = {}
		cs_override.editor = {
			background = "#1A1A1A",
		}
		return cs_override
	end,
})

vim.cmd.colorscheme("monokai-pro")
require("trouble").setup({
	modes = {
		preview_float = {
			mode = "diagnostics",
			preview = {
				type = "float",
				relative = "editor",
				border = "rounded",
				title = "Preview",
				title_pos = "center",
				position = { 0, -2 },
				size = { width = 0.3, height = 0.3 },
				zindex = 200,
			},
		},
		cascade = {
			mode = "diagnostics", -- inherit from diagnostics mode
			filter = function(items)
				local severity = vim.diagnostic.severity.HINT
				for _, item in ipairs(items) do
					severity = math.min(severity, item.severity)
				end
				return vim.tbl_filter(function(item)
					return item.severity == severity
				end, items)
			end,
		},
	},
})
require("full_visual_line").setup({})
vim.opt.cursorline = true
vim.opt.tabstop = 4
vim.opt.writebackup = false
vim.opt.swapfile = false
--vim.opt.autochdir = true
vim.opt.cursorcolumn = false
--vim.opt.colorcolumn = "100"
vim.opt.undofile = true
vim.opt.expandtab = true

require("lazydev").setup({})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local configs = require("lspconfig.configs")
configs.rpmspec = {
	default_config = {
		cmd = { "python3", "-mrpm_spec_language_server", "--stdio" },
		filetypes = { "spec" },
		single_file_support = true,
		root_dir = util.find_git_ancestor,
		settings = {},
	},
	docs = {
		description = [[
  https://github.com/dcermak/rpm-spec-language-server

  Language server protocol (LSP) support for RPM Spec files.
  ]],
	},
}
local language_servers = { "pyright", "clangd", "rpmspec", "bashls" }
for _, ls in ipairs(language_servers) do
	lspconfig[ls].setup({
		capabilities = capabilities,
		-- you can add other fields for setting up lsp server in this table
	})
end
lspconfig.rust_analyzer.setup({
	cmd = vim.lsp.rpc.connect("127.0.0.1", 27631),
	init_options = {
		lspMux = {
			version = "1",
			method = "connect",
			server = "rust-analyzer",
		},
	},
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				enable = true,
			},
			inlayHints = {
				bindingModeHints = {
					enable = false,
				},
				chainingHints = {
					enable = true,
				},
				closingBraceHints = {
					enable = true,
					minLines = 25,
				},
				closureReturnTypeHints = {
					enable = "never",
				},
				lifetimeElisionHints = {
					enable = "never",
					useParameterNames = false,
				},
				maxLength = 25,
				parameterHints = {
					enable = true,
				},
				reborrowHints = {
					enable = "never",
				},
				renderColons = true,
				typeHints = {
					enable = true,
					hideClosureInitialization = false,
					hideNamedConstructor = false,
				},
			},
			check = {
				command = "clippy",
				extraArgs = { "--all", "--", "-W", "clippy::all" },
			},
		},
	},
	capabilities = capabilities,
})
lspconfig.texlab.setup({
	settings = {
		["texlab"] = {
			build = {
				executable = "tectonic",
				args = { "%f" },
				onSave = true,
			},
		},
	},
	capabilities = capabilities,
})
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			hint = {
				enable = true,
			},
			workspace = {
				checkThirdParty = false,
			},
		},
	},
	capabilities = capabilities,
})
lspconfig.ltex.setup({
	filetypes = { "gitcommit", "markdown", "norg", "plaintex", "rst", "tex", "pandoc" },
	settings = {
		ltex = {
			language = "en-US",
		},
	},
})

-- require("codeium").setup({})

local luasnip = require("luasnip")
local cmp = require("cmp")

local lspkind = require("lspkind")

local compare = require("cmp.config.compare")
compare.locality.lines_count = 300

local cmp_lsp_rs = require("cmp_lsp_rs")
cmp_lsp_rs.setup()
local comparators = cmp_lsp_rs.comparators

local has_words_before = function()
	if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local cmp_opts = {
	completion = {
		completeopt = "menuone,noselect,preview",
	},
	preselect = cmp.PreselectMode.None,
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = {
		-- ... Your other mappings ...

		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() and has_words_before() then
				cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
				-- that way you will only jump inside the snippet region
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		["<CR>"] = cmp.mapping({
			i = function(fallback)
				-- check if the completion menu is visible and if an entry is selected
				if cmp.visible() and cmp.get_active_entry() then
					cmp.confirm()
				else
					fallback()
				end
			end,
			s = cmp.mapping.confirm({ select = true }),
			c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
		}),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
		["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
		-- ... Your other mappings ...
	},
	sources = cmp.config.sources({
		-- Other Sources
		{ name = "copilot" },
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "codeium" },
		{ name = "luasnip" },
		{ name = "crates" },
		-- { name = "neorg" },
		{
			name = "lazydev",
			group_index = 0, -- set group index to 0 to skip loading LuaLS completions
		},
		-- { name = "fuzzy_path" },
		-- { name = "fuzzy_buffer" },
	}),
	sorting = {
		comparators = {
			compare.offset,
			compare.exact,
			comparators.inscope_inherent_import,
			comparators.sort_by_label_but_underscore_last,
			-- compare.score,
			compare.recently_used,
			compare.locality,
			compare.kind,
			compare.sort_text,
		},
	},
	matching = {
		-- disallow_partial_fuzzy_matching = false,
		disallow_fuzzy_matching = true,
		disallow_fullfuzzy_matching = true,
		disallow_partial_fuzzy_matching = true,
		disallow_partial_matching = false,
		disallow_prefix_unmatching = true,
	},
	formatting = {
		format = lspkind.cmp_format({
			mode = "symbol_text",
			maxwidth = 50,
			ellipsis_char = "...",
			symbol_map = {
				Copilot = "",
			},
		}),
	},
	experimental = {
		ghost_text = {
			hl_group = "CmpGhostText",
		},
	},
}

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

for _, source in ipairs(cmp_opts.sources) do
	cmp_lsp_rs.filter_out.entry_filter(source)
end

cmp.setup(cmp_opts)

cmp.setup.cmdline(":", {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "cmdline" },
	}, {
		{ name = "cmdline_history" },
	}),
})

-- setup nvim-cmp plugin for the cmdline / cmp
cmp.setup.cmdline({ "/", "?" }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources({
		{ name = "cmdline_history" },
	}),
})

require("nvim-autopairs").setup({})
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

local telescope = require("telescope")
local open_with_trouble = require("trouble.sources.telescope").open
telescope.setup({
	defaults = {
		mappings = {
			i = {
				["<C-t>"] = open_with_trouble,
			},
			n = {
				["<C-t>"] = open_with_trouble,
			},
		},
	},
})

vim.keymap.set("n", "<leader>G", require("neogit").open, { desc = "Open Neogit interface" })

telescope.load_extension("noice")
telescope.load_extension("recent-files")
telescope.load_extension("jj")
local builtin = require("telescope.builtin")
local vcs_picker = function(opts)
	local jj_pick_status, jj_res = pcall(telescope.extensions.jj.files, opts)
	if jj_pick_status then
		return
	end

	local git_files_status, git_res = pcall(builtin.git_files, opts)
	if not git_files_status then
		error("Could not launch jj/git files: \n" .. jj_res .. "\n" .. git_res)
	end
end
vim.keymap.set(
	"n",
	"<leader>fF",
	telescope.extensions["recent-files"].recent_files,
	{ desc = "Find files in all subdirectories" }
)
vim.keymap.set("n", "<leader>ff", vcs_picker, { desc = "Find all tracked files in all subdirectories" })
vim.keymap.set(
	"n",
	"<leader>f*",
	builtin.grep_string,
	{ desc = "Search the word under the cursor in the current working directory" }
)
vim.keymap.set("n", "<leader>f/", builtin.live_grep, { desc = "Search through all files content" })
vim.keymap.set("n", "<leader>f.", builtin.current_buffer_fuzzy_find, { desc = "Search through the current file" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Search through buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search through help tags" })
vim.keymap.set("n", "<leader>fc", builtin.commands, { desc = "Search through commands" })
vim.keymap.set("n", "<leader>fm", builtin.man_pages, { desc = "Search through man pages" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Search through keymaps" })
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Search through the workspace diagnostics" })
vim.keymap.set("n", "<leader>lg", builtin.lsp_definitions, { desc = "Search (or go to) the LSP definitions" })
vim.keymap.set("n", "<leader>li", builtin.lsp_implementations, { desc = "Search (or go to) the LSP implementations" })
vim.keymap.set("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "Search through the LSP document symbols" })
vim.keymap.set("n", "<leader>lr", builtin.lsp_references, { desc = "Search through the LSP references" })
vim.keymap.set("n", "<leader>lw", builtin.lsp_workspace_symbols, { desc = "Search through the LSP workspace symbols" })

--vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, {})

vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.opt.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

vim.keymap.set({ "n", "v" }, "<space>a", vim.lsp.buf.code_action)

local handler = function(virtText, lnum, endLnum, width, truncate)
	local newVirtText = {}
	local suffix = (" 󰁂 %d "):format(endLnum - lnum)
	local sufWidth = vim.fn.strdisplaywidth(suffix)
	local targetWidth = width - sufWidth
	local curWidth = 0
	for _, chunk in ipairs(virtText) do
		local chunkText = chunk[1]
		local chunkWidth = vim.fn.strdisplaywidth(chunkText)
		if targetWidth > curWidth + chunkWidth then
			table.insert(newVirtText, chunk)
		else
			chunkText = truncate(chunkText, targetWidth - curWidth)
			local hlGroup = chunk[2]
			table.insert(newVirtText, { chunkText, hlGroup })
			chunkWidth = vim.fn.strdisplaywidth(chunkText)
			-- str width returned from truncate() may less than 2nd argument, need padding
			if curWidth + chunkWidth < targetWidth then
				suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
			end
			break
		end
		curWidth = curWidth + chunkWidth
	end
	table.insert(newVirtText, { suffix, "MoreMsg" })
	return newVirtText
end

require("ufo").setup({
	fold_virt_text_handler = handler,
})
vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)

vim.keymap.set("n", "K", function()
	local winid = require("ufo").peekFoldedLinesUnderCursor()
	if not winid then
		-- choose one of coc.nvim and nvim lsp
		vim.lsp.buf.hover()
	end
end)

require("fidget").setup({})

local kopts = { noremap = true, silent = true }

vim.api.nvim_set_keymap(
	"n",
	"n",
	[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
	kopts
)
vim.api.nvim_set_keymap(
	"n",
	"N",
	[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
	kopts
)
vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)

vim.api.nvim_set_keymap("n", "<Leader>l", "<Cmd>noh<CR>", kopts)

require("noice").setup({
	lsp = {
		-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
		signature = {
			enabled = false,
		},
		hover = {
			enabled = false,
		},
	},
	-- you can enable a preset for easier configuration
	presets = {
		bottom_search = true, -- use a classic bottom cmdline for search
		command_palette = true, -- position the cmdline and popupmenu together
		long_message_to_split = true, -- long messages will be sent to a split
		inc_rename = true, -- enables an input dialog for inc-rename.nvim
		lsp_doc_border = false, -- add a border to hover docs and signature help
	},
	messages = {
		enabled = true,
		view = "notify",
	},
	notify = {
		-- Noice can be used as `vim.notify` so you can route any notification like other messages
		-- Notification messages have their level and other properties set.
		-- event is always "notify" and kind can be any log level as a string
		-- The default routes will forward notifications to nvim-notify
		-- Benefit of using Noice for this is the routing and consistent history view
		enabled = true,
		view = "notify",
	},
})

require("nvim-web-devicons").setup({})

-- vim.keymap.set("n", "<leader>F", require("conform").format, { desc = "Format the current buffer" })

local crates = require("crates")
local function show_documentation()
	local filetype = vim.bo.filetype
	if vim.tbl_contains({ "vim", "help" }, filetype) then
		vim.cmd("h " .. vim.fn.expand("<cword>"))
	elseif vim.tbl_contains({ "man" }, filetype) then
		vim.cmd("Man " .. vim.fn.expand("<cword>"))
	elseif vim.fn.expand("%:t") == "Cargo.toml" and crates.popup_available() then
		crates.show_popup()
	else
		vim.lsp.buf.hover()
	end
end

vim.keymap.set("n", "<leader>rc", show_documentation, { silent = true })
vim.keymap.set("n", "<leader>rC", function()
	show_documentation()
	crates.focus_popup()
end, { silent = true })
vim.keymap.set("n", "<leader>ru", crates.update_all_crates, { desc = "Update all crates in the buffer" })
vim.keymap.set("n", "<leader>rU", crates.upgrade_all_crates, { desc = "Update all crates in the buffer" })
vim.keymap.set("n", "<leader>rf", crates.focus_popup, { desc = "Focus the crates popup" })
vim.keymap.set("n", "<leader>rF", crates.show_features_popup, { desc = "Update all crates in the buffer" })
vim.keymap.set("n", "<leader>ro", crates.open_crates_io, { desc = "Open the crates.io page" })

-- require("nvim-treesitter").setup({})
-- require("nvim-treesitter.configs").setup({
-- 	auto_install = true,
-- })

require("virt-column").setup({
	virtcolumn = "100",
	char = "┊",
	highlight = "Whitespace",
})

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

local neotest = require("neotest")
neotest.setup({
	diagnostic = { enabled = true },
	status = { enabled = true },
	watch = { enabled = true },
	adapters = {
		require("neotest-rust"),
	},
	-- consumers = {
	-- 	overseer = require("neotest.consumers.overseer"),
	-- },
})
vim.keymap.set("n", "<Leader>tc", neotest.run.run)
vim.keymap.set("n", "<Leader>tf", function()
	neotest.run.run(vim.fn.expand("%"))
end)
vim.keymap.set("n", "<Leader>tw", function()
	neotest.watch.toggle(vim.fn.expand("%"))
end)

local dap = require("dap")

dap.defaults.fallback.external_terminal = {
	command = "/usr/bin/alacritty",
	args = { "-e" },
}

dap.adapters.lldb = {
	type = "executable",
	command = "/usr/bin/lldb-vscode", -- adjust as needed, must be absolute path
	name = "lldb",
}

dap.adapters.codelldb = {
	name = "codelldb",
	type = "server",
	port = "${port}",
	executable = {
		-- CHANGE THIS to your path!
		command = "/home/danyspin97/proj/coding/codelldb_extension/adapter/codelldb",
		args = { "--port", "${port}" },
	},
}

-- Get the variables needed to select a program using telescope
local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local conf = require("telescope.config").values

dap.configurations.rust = {
	{
		name = "Launch",
		type = "codelldb",
		request = "launch",
		program = function()
			return coroutine.create(function(coro)
				local opts = {}
				pickers
					.new(opts, {
						prompt_title = "Path to executable",
						finder = finders.new_oneshot_job({ "fd", "--hidden", "--no-ignore", "--type", "x" }, {}),
						sorter = conf.generic_sorter(opts),
						attach_mappings = function(buffer_number)
							actions.select_default:replace(function()
								actions.close(buffer_number)
								coroutine.resume(coro, action_state.get_selected_entry()[1])
							end)
							return true
						end,
					})
					:find()
			end)
		end,
		-- program = function()
		-- 	return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		-- end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = function()
			local args_string = vim.fn.input("Arguments: ")
			if args_string == "" then
				return {}
			else
				return vim.split(args_string, " ")
			end
		end,
		-- 		initCommands = function()
		-- 			-- Find out where to look for the pretty printer Python module
		-- 			local rustc_sysroot = vim.fn.trim(vim.fn.system("rustc --print sysroot"))
		--
		-- 			local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
		-- 			local commands_file = rustc_sysroot .. "/lib/rustlib/etc/lldb_commands"
		--
		-- 			local commands = {}
		-- 			local file = io.open(commands_file, "r")
		-- 			if file then
		-- 				for line in file:lines() do
		-- 					table.insert(commands, line)
		-- 				end
		-- 				file:close()
		-- 			end
		-- 			table.insert(commands, 1, script_import)
		--
		-- 			return commands
		-- 		end,
		-- 		env = function()
		-- 			local variables = {}
		-- 			for k, v in pairs(vim.fn.environ()) do
		-- 				table.insert(variables, string.format("%s=%s", k, v))
		-- 			end
		-- 			return variables
		-- 		end,
	},
}

local dapui = require("dapui")
dapui.setup({})

vim.keymap.set("n", "<leader>db", function()
	dap.set_breakpoint("", "", "")
end, { desc = "Toggle breakpoint" })
vim.keymap.set("n", "<leader>dc", function()
	dap.continue()
end, { desc = "Continue the execution or start a debug session" })
vim.keymap.set("n", "<leader>dS", function()
	dap.continue({ new = true })
	dapui.open()
end, { desc = "Start a debug session" })
vim.keymap.set("n", "<leader>dt", function()
	dap.terminate(nil, nil, nil)
	dapui.close()
end, { desc = "Terminate the debugging session" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into a function or method" })
vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step out of a function or method" })
vim.keymap.set("n", "<leader>dB", dap.step_back, { desc = "Steps one step back" })
vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Request the debugee to run again" })
vim.keymap.set("n", "<leader>dC", dap.run_to_cursor, { desc = "Continue execution to the current cursor" })
vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Restart the current session" })

require("nvim-dap-virtual-text").setup({
	commented = false,
})

vim.cmd([[autocmd FileType * set formatoptions-=ro]])

vim.diagnostic.config({
	virtual_lines = {
		-- only_current_line = true,
		highlight_whole_line = false,
	},
	virtual_text = false,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.INFO] = " ",
			[vim.diagnostic.severity.HINT] = " ",
		},
	},
})

require("lsp-lens").setup({})

require("hlargs").setup()

require("lsp_signature").setup({
	bind = true, -- This is mandatory, otherwise border config won't get registered.
	noice = true,
	handler_opts = {
		border = "rounded",
	},
	hint_enable = false,
	hint_inline = function()
		return true
	end,
})

-- require("org-bullets").setup()

require("luasnip.loaders.from_vscode").lazy_load()

-- require("neorg").setup({
-- 	load = {
-- 		["core.defaults"] = {},
-- 		["core.esupports.metagen"] = { config = { type = "auto", update_date = true } },
-- 		["core.qol.toc"] = {},
-- 		["core.qol.todo_items"] = {},
-- 		["core.concealer"] = {}, -- Adds pretty icons to your documents
-- 		["core.dirman"] = {
-- 			config = {
-- 				workspaces = {
-- 					work = "~/notes/work",
-- 					home = "~/notes/home",
-- 				},
-- 			},
-- 		},
-- 		["core.journal"] = {
-- 			config = {
-- 				journal_folder = "report",
-- 				workspace = "work",
-- 				strategy = "flat",
-- 			},
-- 		},
-- 		["core.completion"] = {
-- 			config = {
-- 				engine = "nvim-cmp",
-- 			},
-- 		},
-- 		["core.export"] = {},
-- 	},
-- })
--
local function get_next_friday()
	local today_time = os.time()
	local today = os.date("*t", today_time)
	local friday_wday = (6 - today.wday)
	local friday = os.date("%Y-%m-%d", today_time + friday_wday * 24 * 60 * 60)
	return friday
end
-- add a keymap that create a new journal for the next friday, using Neorg journal custom command
-- vim.keymap.set("n", "<Leader>wr", function()
-- 	local friday = get_next_friday()
-- 	vim.cmd("Neorg journal custom " .. friday)
-- end)

-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	group = vim.api.nvim_create_augroup("InlayHints", {}),
-- 	callback = function(args)
-- 		local client = vim.lsp.get_client_by_id(args.data.client_id)
-- 		if client.server_capabilities.inlayHintProvider then
-- 			vim.lsp.inlay_hint.enable(0, true)
-- 		end
-- 	end,
-- })

vim.keymap.set("n", "<Leader>w", "<cmd>update<cr><esc>", { desc = "Save file" })

vim.filetype.add({
	extension = {
		ysh = "ysh",
	},
})

vim.keymap.set("n", "<leader>qx", function()
	require("trouble").toggle()
end, { desc = "Toggle Trouble plugin" })
vim.keymap.set("n", "<leader>qw", function()
	require("trouble").toggle("workspace_diagnostics")
end, { desc = "Show workspace diagnostics" })
vim.keymap.set("n", "<leader>qd", function()
	require("trouble").toggle("diagnostics")
end, { desc = "Show document diagnostics" })
vim.keymap.set("n", "<leader>qq", function()
	require("trouble").toggle("quickfix")
end, { desc = "Show quickfix" })
vim.keymap.set("n", "<leader>ql", function()
	require("trouble").toggle("loclist")
end, { desc = "Show loclist" })
vim.keymap.set("n", "gR", function()
	require("trouble").toggle("lsp_references")
end, { desc = "Show lsp references" })

vim.keymap.set("n", "<leader>qn", function()
	-- jump to the next item, skipping the groups
	require("trouble").next({ skip_groups = true, jump = true })
end, { desc = "Next item in quickfix" })

vim.keymap.set("n", "<leader>qp", function()
	-- jump to the previous item, skipping the groups
	require("trouble").previous({ skip_groups = true, jump = true })
end, { desc = "Previous item in quickfix" })

require("inc_rename").setup()
vim.keymap.set("n", "<leader>rn", function()
	return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })

require("suit").setup({})

local api = vim.api
local keymap_restore = {}
-- dap.listeners.after["event_initialized"]["me"] = function()
-- 	for _, buf in pairs(api.nvim_list_bufs()) do
-- 		local keymaps = api.nvim_buf_get_keymap(buf, "n")
-- 		for _, keymap in pairs(keymaps) do
-- 			if keymap.lhs == "K" then
-- 				table.insert(keymap_restore, keymap)
-- 				api.nvim_buf_del_keymap(buf, "n", "K")
-- 			end
-- 		end
-- 	end
-- 	api.nvim_set_keymap("n", "K", '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
-- end

dap.listeners.after["event_terminated"]["me"] = function()
	for _, keymap in pairs(keymap_restore) do
		api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs, { silent = keymap.silent == 1 })
	end
	keymap_restore = {}
end

local function h(name)
	return vim.api.nvim_get_hl(0, { name = name })
end

-- hl-groups can have any name
vim.api.nvim_set_hl(0, "SymbolUsageRounding", { fg = h("CursorLine").bg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageContent", { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageRef", { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageDef", { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true })
vim.api.nvim_set_hl(0, "SymbolUsageImpl", { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true })

local function text_format(symbol)
	local res = {}

	local round_start = { "", "SymbolUsageRounding" }
	local round_end = { "", "SymbolUsageRounding" }

	if symbol.references then
		local usage = symbol.references <= 1 and "usage" or "usages"
		local num = symbol.references == 0 and "no" or symbol.references
		table.insert(res, round_start)
		table.insert(res, { "󰌹 ", "SymbolUsageRef" })
		table.insert(res, { ("%s %s"):format(num, usage), "SymbolUsageContent" })
		table.insert(res, round_end)
	end

	if symbol.definition then
		if #res > 0 then
			table.insert(res, { " ", "NonText" })
		end
		table.insert(res, round_start)
		table.insert(res, { "󰳽 ", "SymbolUsageDef" })
		table.insert(res, { symbol.definition .. " defs", "SymbolUsageContent" })
		table.insert(res, round_end)
	end

	if symbol.implementation then
		if #res > 0 then
			table.insert(res, { " ", "NonText" })
		end
		table.insert(res, round_start)
		table.insert(res, { "󰡱 ", "SymbolUsageImpl" })
		table.insert(res, { symbol.implementation .. " impls", "SymbolUsageContent" })
		table.insert(res, round_end)
	end

	return res
end

require("hlslens").setup({})
require("slanty")

require("leap").add_default_mappings()
-- Hide the (real) cursor when leaping, and restore it afterwards.
vim.api.nvim_create_autocmd("User", {
	pattern = "LeapEnter",
	callback = function()
		vim.cmd.hi("Cursor", "blend=100")
		vim.opt.guicursor:append({ "a:Cursor/lCursor" })
	end,
})
vim.api.nvim_create_autocmd("User", {
	pattern = "LeapLeave",
	callback = function()
		vim.cmd.hi("Cursor", "blend=0")
		vim.opt.guicursor:remove({ "a:Cursor/lCursor" })
	end,
})

require("flit").setup()

local neowords = require("neowords")
local p = neowords.pattern_presets

-- Subwords with dots and commas
local hops = neowords.get_word_hops(p.snake_case, p.camel_case, p.upper_case, p.number, p.hex_color, "\\v\\.+", "\\v,+")

vim.keymap.set({ "n", "x", "o" }, "w", hops.forward_start)
vim.keymap.set({ "n", "x", "o" }, "e", hops.forward_end)
vim.keymap.set({ "n", "x", "o" }, "q", hops.backward_start)
vim.keymap.set({ "n", "x", "o" }, "ge", hops.backward_end)

local bigword_hops = neowords.get_word_hops(p.any_word, p.number, p.hex_color)

vim.keymap.set({ "n", "x", "o" }, "W", bigword_hops.forward_start)
vim.keymap.set({ "n", "x", "o" }, "E", bigword_hops.forward_end)
vim.keymap.set({ "n", "x", "o" }, "Q", bigword_hops.backward_start)
vim.keymap.set({ "n", "x", "o" }, "Q", bigword_hops.backward_start)

vim.opt.list = true

local space = "·"
-- vim.opt.list = true
vim.opt.listchars:append({
	-- tab = "│─",
	multispace = space,
	lead = space,
	trail = space,
	nbsp = space,
	eol = "¬",
})

require("hlchunk").setup({
	chunk = {
		enable = true,
		chars = {
			horizontal_line = "─",
			vertical_line = "│",
			left_top = "╭",
			left_bottom = "╰",
			right_arrow = ">",
		},
		style = "#806d9c",
	},
	indent = {
		enable = true,
		chars = {
			"│",
			"¦",
			"┆",
			"┊",
		},
		style = {
			vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"),
		},
	},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		timeout_ms = 500,
		lsp_fallback = true,
	},
})

-- highlight yanked text
vim.cmd([[
augroup highlight_yank
autocmd!
au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Search", timeout=500})
augroup END
]])

require("gitsigns").setup({})

-- triggers CursorHold event faster
vim.opt.updatetime = 200

-- require("barbecue").setup({
-- 	create_autocmd = false, -- prevent barbecue from updating itself automatically
-- })
--
-- vim.api.nvim_create_autocmd({
-- 	"WinResized", -- or WinResized on NVIM-v0.9 and higher
-- 	"BufWinEnter",
-- 	"CursorHold",
-- 	"InsertLeave",
--
-- 	-- include this if you have set `show_modified` to `true`
-- 	"BufModifiedSet",
-- }, {
-- 	group = vim.api.nvim_create_augroup("barbecue.updater", {}),
-- 	callback = function()
-- 		require("barbecue.ui").update()
-- 	end,
-- })

require("barbar").setup()

require("inlay-hints").setup()

require("render-markdown").setup()

require("neodim").setup({
	alpha = 0.75,
	blend_color = "#000000",
	hide = {
		underline = true,
		virtual_text = true,
		signs = true,
	},
	regex = {
		"[uU]nused",
		"[nN]ever [rR]ead",
		"[nN]ot [rR]ead",
		rust = {},
	},
	priority = 128,
	disable = {},
})

require("git-conflict").setup()

require("hardtime").setup({
	disabled_keys = {
		["<Up>"] = {},
		["<Left>"] = {},
		["<Right>"] = {},
		["<Down>"] = {},
	},
})

local navic = require("nvim-navic")
navic.setup({
	lsp = {
		auto_attach = true,
	},
})

local devicons = require("nvim-web-devicons")
-- require("incline").setup({
-- 	---@class InclineRenderProps
-- 	---@field buf number
-- 	---@field win number
-- 	---@field focused boolean
--
-- 	---@param props InclineRenderProps
-- 	render = function(props)
-- 		if not props.focused then
-- 			return ""
-- 		end
--
-- 		local count = vim.fn.searchcount({ recompute = 1, maxcount = -1 })
-- 		local contents = vim.fn.getreg("/")
-- 		if string.len(contents) == 0 then
-- 			return ""
-- 		end
--
-- 		return {
-- 			{
-- 				" ? ",
-- 				group = "dkoStatusKey",
-- 			},
-- 			{
-- 				(" %s "):format(contents),
-- 				group = "IncSearch",
-- 			},
-- 			{
-- 				(" %d/%d "):format(count.current, count.total),
-- 				group = "dkoStatusValue",
-- 			},
-- 		}
-- 	end,
--
-- 	window = {
-- 		margin = { horizontal = 0 },
-- 		padding = 0,
-- 	},
-- })
--
require("deferred-clipboard").setup({
	fallback = "unnamedplus", -- or your preferred setting for clipboard
})

require("tiny-code-action").setup({
	--- The backend to use, currently only "vim", "delta" and "difftastic" are supported
	backend = "delta",
	backend_opts = {
		delta = {
			-- The arguments to pass to delta
			-- If you have a custom configuration file, you can set the path to it like so:
			-- args = {
			--     "--config" .. os.getenv("HOME") .. "/.config/delta/config.yml",
			-- }
			args = {
				"--line-numbers",
			},
		},
	},
})

vim.keymap.set("n", "<leader>a", function()
	require("tiny-code-action").code_action()
end, { noremap = true, silent = true })

require("render-markdown").setup({
	render_modes = true,
})

-- Don't load Coqtail
vim.cmd([[
let g:loaded_coqtail = 1
let g:coqtail#supported = 0
]])

require("coq-lsp").setup()

require("copilot").setup({
	suggestion = { enabled = false },
	panel = { enabled = false },
})

require("copilot_cmp").setup()

require("colorizer").setup()

-- Restore the cursor position when opening a file
-- https://github.com/neovim/neovim/issues/16339#issuecomment-1457394370
vim.api.nvim_create_autocmd("BufRead", {
	callback = function(opts)
		vim.api.nvim_create_autocmd("BufWinEnter", {
			once = true,
			buffer = opts.buf,
			callback = function()
				local ft = vim.bo[opts.buf].filetype
				local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
				if
					not (ft:match("commit") and ft:match("rebase"))
					and last_known_line > 1
					and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
				then
					vim.api.nvim_feedkeys([[g`"]], "nx", false)
				end
			end,
		})
	end,
})

local flash = require("flash")

flash.setup({
	moparse_pathdes = {
		search = {
			enabled = true,
		},
	},
})

vim.keymap.set({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash" })
vim.keymap.set({ "n", "x", "o" }, "S", flash.treesitter, { desc = "Flash Treesitter" })
-- vim.keymap.set("r", "o", require("flash").remote(), { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", flash.treesitter_search, { desc = "Treesitter Search" })
vim.keymap.set({ "c" }, "<c-s>", flash.toggle, { desc = "Toggle Flash Search" })

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argc() == 0 then
			require("telescope").extensions["recent-files"].recent_files({})
		end
	end,
})

require("visual-whitespace").setup()
