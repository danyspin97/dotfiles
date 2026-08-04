vim.g.mapleader = " "
vim.g.maplocalleader = "-"
-- Remove the default statuts line by using cmdheight=0
vim.opt.cmdheight = 0
vim.opt.number = true
vim.wo.relativenumber = true
vim.opt.termguicolors = true

vim.opt.guifont = "Victor Mono:h12"

vim.keymap.set({ "i", "c" }, "<S-Insert>", "<C-R>+", { remap = true })

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

require("crates").setup({
	completion = {
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

vim.keymap.set("", "<Leader>ll", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostic lines" })

require("monokai-pro").setup({
	filter = "spectrum",
	-- override = function(colors) end,
	overrideScheme = function(cs, p, config, hp)
		local cs_override = {}
		cs_override.editor = {
			background = "#1A1A1A",
		}
		return cs_override
	end,
})

-- vim.cmd.colorscheme("monokai-pro")
vim.cmd.colorscheme("monet")
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
vim.opt.cursorline = true
vim.opt.tabstop = 4
vim.opt.writebackup = false
vim.opt.swapfile = false
--vim.opt.autochdir = true
vim.opt.cursorcolumn = false
--vim.opt.colorcolumn = "100"
vim.opt.undofile = true
vim.opt.expandtab = true

vim.g.markdown_fenced_languages = {
	"ts=typescript",
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
local language_servers = { "denols", "pyright", "clangd", "bashls", "marksman" }
for _, ls in ipairs(language_servers) do
	vim.lsp.config(ls, {
		capabilities = capabilities,
		-- you can add other fields for setting up lsp server in this table
	})
	vim.lsp.enable(ls)
end
vim.lsp.config("texlab", {
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
vim.lsp.config("lua_ls", {
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
vim.lsp.config("harper_ls", {
	settings = {
		["harper-ls"] = {
			linters = {
				SentenceCapitalization = false,
			},
		},
	},
})
local telescope = require("telescope")
local open_with_trouble = require("trouble.sources.telescope").open
telescope.setup({
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case"
			-- the default case_mode is "smart_case"
		},
	},
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

telescope.load_extension("recent-files")
telescope.load_extension("jj")
telescope.load_extension("fzf")
telescope.load_extension("undo")
local builtin = require("telescope.builtin")
local vcs_picker = function(opts)
	local jj_pick_status, jj_res = pcall(telescope.extensions.jj.files, opts)
	if jj_pick_status then
		return
	end

	local git_files_status, git_res = pcall(builtin.git_files, opts)
	if git_files_status then
		return
	end
	pcall(telescope.extensions["recent-files"].recent_files)
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
vim.keymap.set("n", "<leader>fu", telescope.extensions["undo"].undo, { desc = "Search through the undotree" })

--vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, {})

vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99

-- vim.opt.foldenable = true
-- vim.o.fillchars = "eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:"

vim.keymap.set({ "n", "v" }, "<space>a", vim.lsp.buf.code_action)

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
vim.opt.winborder = "rounded"
require("vim._core.ui2").enable()
require("tiny-cmdline").setup({
	on_reposition = require("tiny-cmdline").adapters.blink,
})

require("nvim-web-devicons").setup({})

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

require("virt-column").setup({
	virtcolumn = "100",
	char = "┊",
	highlight = "Whitespace",
})

-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
-- 	callback = function()
-- 		require("lint").try_lint()
-- 	end,
-- })

local neotest = require("neotest")
neotest.setup({
	diagnostic = { enabled = true },
	status = { enabled = true },
	watch = { enabled = true },
	adapters = {
		require("rustaceanvim.neotest"),
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

-- vim.diagnostic.config({
-- 	virtual_lines = true,
-- 	signs = {
-- 		text = {
-- 			[vim.diagnostic.severity.ERROR] = " ",
-- 			[vim.diagnostic.severity.WARN] = " ",
-- 			[vim.diagnostic.severity.INFO] = " ",
-- 			[vim.diagnostic.severity.HINT] = " ",
-- 		},
-- 	},
-- })

require("origami").setup()

require("hlargs").setup()

require("luasnip.loaders.from_vscode").lazy_load()

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

-- vim.filetype.add({
-- 	extension = {
-- 		ysh = "ysh",
-- 	},
-- })

vim.keymap.set("n", "<leader>qx", function()
	require("trouble").toggle()
end, { desc = "Toggle Trouble plugin" })
vim.keymap.set("n", "<leader>qw", function()
	require("trouble").open("lsp")
end, { desc = "Show workspace diagnostics" })
vim.keymap.set("n", "<leader>qd", function()
	require("trouble").open("diagnostics")
end, { desc = "Show document diagnostics" })
vim.keymap.set("n", "<leader>qs", function()
	require("trouble").open("symbols")
end, { desc = "Show workspace diagnostics" })
vim.keymap.set("n", "<leader>qq", function()
	require("trouble").open("quickfix")
end, { desc = "Show quickfix" })
vim.keymap.set("n", "<leader>ql", function()
	require("trouble").open("loclist")
end, { desc = "Show loclist" })
vim.keymap.set("n", "<leader>qt", function()
	require("trouble").open("telescope")
end, { desc = "Show telescope results" })
vim.keymap.set("n", "gR", function()
	require("trouble").open("lsp_references")
end, { desc = "Show lsp references" })

vim.keymap.set("n", "<leader>qn", function()
	-- jump to the next item, skipping the groups
	require("trouble").next({ skip_groups = true, jump = true })
end, { desc = "Next item in quickfix" })

vim.keymap.set("n", "<leader>qp", function()
	-- jump to the previous item, skipping the groups
	require("trouble").previous({ skip_groups = true, jump = true })
end, { desc = "Previous item in quickfix" })

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	callback = function()
		vim.cmd([[Trouble qflist open]])
	end,
})

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

require("hlslens").setup({
	calm_down = true,
})

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
vim.keymap.set({ "n", "x", "o" }, "b", hops.backward_start)
vim.keymap.set({ "n", "x", "o" }, "ge", hops.backward_end)

local bigword_hops = neowords.get_word_hops(p.any_word, p.number, p.hex_color)

vim.keymap.set({ "n", "x", "o" }, "W", bigword_hops.forward_start)
vim.keymap.set({ "n", "x", "o" }, "E", bigword_hops.forward_end)
vim.keymap.set({ "n", "x", "o" }, "B", bigword_hops.backward_start)

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

-- require("hlchunk").setup({
-- 	chunk = {
-- 		enable = true,
-- 		chars = {
-- 			horizontal_line = "─",
-- 			vertical_line = "│",
-- 			left_top = "╭",
-- 			left_bottom = "╰",
-- 			right_arrow = ">",
-- 		},
-- 		style = "#806d9c",
-- 	},
-- 	indent = {
-- 		enable = true,
-- 		chars = {
-- 			"│",
-- 			"¦",
-- 			"┆",
-- 			"┊",
-- 		},
-- 		style = {
-- 			vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("Whitespace")), "fg", "gui"),
-- 		},
-- 	},
-- })

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
	},
	format_after_save = function(bufnr)
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		-- check if the workspace root folder is a codebase managed by quilt
		local series_file = vim.fn.getcwd() .. "/series"
		if vim.fn.filereadable(series_file) ~= 0 then
			return
		end
		local handle = io.popen("timeout 1 jj git remote list 2> /dev/null | rg upstream")
		if handle ~= not nil then
			local result = handle:read("*a")
			handle:close()
			if result ~= "" then
				return
			end
		end

		return { timeout_ms = 500, lsp_format = "fallback" }
	end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		-- FormatDisable! will disable formatting just for this buffer
		vim.b.disable_autoformat = true
	else
		vim.g.disable_autoformat = true
	end
end, {
	desc = "Disable autoformat-on-save",
	bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
	vim.b.disable_autoformat = false
	vim.g.disable_autoformat = false
end, {
	desc = "Re-enable autoformat-on-save",
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

require("barbecue").setup({})

require("barbar").setup()

require("inlay-hints").setup()

require("render-markdown").setup()

require("neodim").setup({})

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

require("incline").setup({
	window = {
		padding = 0,
		margin = { horizontal = 0 },
	},
	render = function(props)
		local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
		if filename == "" then
			filename = "[No Name]"
		end
		local modified = vim.bo[props.buf].modified
		return {
			" ",
			{ filename, gui = modified and "bold,italic" or "bold" },
			" ",
			guibg = "#44406e",
		}
	end,
})

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

-- vim.api.nvim_create_autocmd("VimEnter", {
-- 	callback = function()
-- 		if vim.fn.argc() == 0 then
-- 			require("telescope").extensions["recent-files"].recent_files({})
-- 		end
-- 	end,
-- })

require("visual-whitespace").setup()
require("blink.cmp").setup({
	cmdline = {
		keymap = {
			preset = "cmdline",
		},
		completion = { menu = { auto_show = true } },
	},
	completion = {
		list = {
			selection = {
				preselect = true,
				auto_insert = true,
			},
		},
		ghost_text = { enabled = true },
		keyword = {
			range = "full",
		},
		documentation = {
			auto_show = true,
			window = { border = "single" },
		},
		menu = {
			draw = {
				treesitter = { "lsp" },
				components = {
					kind_icon = {
						text = function(ctx)
							local icon = ctx.kind_icon
							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then
									icon = dev_icon
								end
							else
								icon = require("lspkind").symbolic(ctx.kind, {
									mode = "symbol",
								})
							end

							return icon .. ctx.icon_gap
						end,

						-- Optionally, use the highlight groups from nvim-web-devicons
						-- You can also add the same function for `kind.highlight` if you want to
						-- keep the highlight groups in sync with the icons.
						highlight = function(ctx)
							local hl = ctx.kind_hl
							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then
									hl = dev_hl
								end
							end
							return hl
						end,
					},
					kind = {
						highlight = function(ctx)
							local hl = ctx.kind_hl
							if vim.tbl_contains({ "Path" }, ctx.source_name) then
								local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
								if dev_icon then
									hl = dev_hl
								end
							end
							return hl
						end,
					},
				},
			},
			direction_priority = function()
				local ctx = require("blink.cmp").get_context()
				local item = require("blink.cmp").get_selected_item()
				if ctx == nil or item == nil then
					return { "s", "n" }
				end

				local item_text = item.textEdit ~= nil and item.textEdit.newText or item.insertText or item.label
				local is_multi_line = item_text:find("\n") ~= nil

				-- after showing the menu upwards, we want to maintain that direction
				-- until we re-open the menu, so store the context id in a global variable
				if is_multi_line or vim.g.blink_cmp_upwards_ctx_id == ctx.id then
					vim.g.blink_cmp_upwards_ctx_id = ctx.id
					return { "n", "s" }
				end
				return { "s", "n" }
			end,
		},
		-- trigger = {
		-- 	show_on_blocked_trigger_characters = {},
		-- },
	},
	signature = {
		enabled = true,
		window = { border = "single" },
	},
	keymap = {
		preset = "enter",
	},
	snippets = {
		preset = "luasnip",
	},
	sources = {
		default = function(ctx)
			local success, node = pcall(vim.treesitter.get_node)
			if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
				return { "buffer", "markdown" }
			elseif vim.bo.filetype == "lua" then
				return { "lazydev", "lsp", "path" }
			elseif vim.bo.filetype == "git" then
				return { "git", "lsp", "path" }
			else
				return { "lsp", "path", "snippets", "buffer" }
			end
		end,
		providers = {
			-- copilot = {
			-- 	name = "copilot",
			-- 	module = "blink-cmp-copilot",
			-- 	score_offset = 100,
			-- 	async = true,
			-- 	transform_items = function(_, items)
			-- 		local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
			-- 		local kind_idx = #CompletionItemKind + 1
			-- 		CompletionItemKind[kind_idx] = "Copilot"
			-- 		for _, item in ipairs(items) do
			-- 			item.kind = kind_idx
			-- 		end
			-- 		return items
			-- 	end,
			-- },
			lsp = {
				module = "blink.cmp.sources.lsp",
				override = {
					get_trigger_characters = function(self)
						local trigger_characters = self:get_trigger_characters()
						vim.list_extend(trigger_characters, { "\n", "\t", " " })
						return trigger_characters
					end,
				},
				transform_items = function(_, items)
					return vim.tbl_filter(function(item)
						return item.kind ~= require("blink.cmp.types").CompletionItemKind.Keyword
					end, items)
				end,
			},
			markdown = {
				name = "RenderMarkdown",
				module = "render-markdown.integ.blink",
				fallbacks = { "lsp" },
			},
			lazydev = {
				name = "LazyDev",
				module = "lazydev.integrations.blink",
				-- make lazydev completions top priority (see `:h blink.cmp`)
				score_offset = 100,
			},
			git = {
				module = "blink-cmp-git",
				name = "Git",
				enabled = function()
					return vim.tbl_contains({ "octo", "gitcommit", "markdown" }, vim.bo.filetype)
				end,
				opts = {
					-- options for the blink-cmp-git
				},
				score_offset = -10,
			},
		},
	},
})

vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = "#c1c0c0" })

require("blink.pairs").build():pwait(60000)
require("blink.pairs").setup({})

vim.api.nvim_set_hl(0, "BlinkPairsOrange", { fg = "#fc9867" })
vim.api.nvim_set_hl(0, "BlinkPairsPurple", { fg = "#ab9df2" })
vim.api.nvim_set_hl(0, "BlinkPairsBlue", { fg = "#78dce8" })

-- require("scrollview.contrib.gitsigns").setup()

require("notify").setup()

-- require("bar")

require("fidget").setup({})

require("textcase").setup({})

-- require("copilot").setup({
-- 	suggestion = { enabled = false },
-- 	panel = { enabled = false },
-- })
--
-- require("CopilotChat").setup({})

local baleia = require("baleia").setup({})

vim.api.nvim_create_user_command("BaleiaColorize", function()
	local buffer = vim.api.nvim_get_current_buf()
	vim.api.nvim_set_option_value("modifiable", true, { buf = buffer })
	baleia.once(buffer)
	vim.api.nvim_set_option_value("modified", false, { buf = buffer })
	vim.api.nvim_set_option_value("modifiable", false, { buf = buffer })
end, { bang = true })

require("terminal").setup()

require("modes").setup()
require("git-link").setup()
vim.keymap.set("n", "<leader>gu", function()
	require("git-link.main").copy_line_url()
end)
vim.keymap.set("n", "<leader>go", function()
	require("git-link.main").open_line_url()
end)
vim.keymap.set("x", "<leader>gu", function()
	require("git-link.main").copy_line_url()
end)
vim.keymap.set("x", "<leader>go", function()
	require("git-link.main").open_line_url()
end)

require("octo").setup()

require("blink.indent").setup()

require("grug-far").setup()

require("tiny-inline-diagnostic").setup({
	options = {
		add_messages = {
			display_count = true,
		},
		multilines = {
			enabled = true,
		},
	},
})

require("jj").setup({
	diff = {
		backend = "native",
	},
})

require("wrapping").setup()
