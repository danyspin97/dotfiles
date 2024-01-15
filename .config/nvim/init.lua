local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
                "git",
                "clone",
                "--filter=blob:none",
                "https://github.com/folke/lazy.nvim.git",
                "--branch=stable", -- latest stable release
                lazypath,
        })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
-- Remove the default statuts line by using cmdheight=0
vim.opt.cmdheight = 0

 -- autocmd TermOpen term://* startinsert
 --    autocmd TermEnter term://* startinsert
 --    autocmd BufEnter term://* startinsert

local proj_config = {
        auto_format = false
}
-- Read the project configuration (usually enabling the formatter)
local localconfpath = vim.fn.getcwd() .. "./.nvimrc.lua"
if vim.fn.filereadable(localconfpath) then
        vim.secure.read(localconfpath)
end

local function misc()
        return
        {
                "folke/which-key.nvim",
                event = "VeryLazy",
                init = function()
                        vim.o.timeout = true
                        vim.o.timeoutlen = 300
                end,
                opts = {
                        key_labels = {
                                ["<Leader>"] = "SPC",
                        },
                },
        }
end

require("lazy").setup({
        misc(),
        { "folke/neoconf.nvim",              cmd = "Neoconf" },
        "folke/neodev.nvim",
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
        --	"hrsh7th/cmp-nvim-lsp-signature-help",
        {
                "L3MON4D3/LuaSnip",
                -- follow latest release.
                version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
                -- install jsregexp (optional!).
                build = "make install_jsregexp",
                dependencies = { "rafamadriz/friendly-snippets" },
        },
        "nvim-tree/nvim-web-devicons", -- optional
        {
                "nvim-telescope/telescope.nvim",
                dependencies = {
                        "nvim-lua/plenary.nvim",
                        "debugloop/telescope-undo.nvim",
                },
        },
        {
                "kevinhwang91/nvim-ufo",
                dependencies = { "kevinhwang91/promise-async" },
                event = "BufReadPost",
        },
        {
                "j-hui/fidget.nvim",
                event = "LspAttach",
        },
        "kevinhwang91/nvim-hlslens",
        { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
        { "ms-jpq/chadtree",                 build = ":CHADdeps" },
        {
                "zbirenbaum/copilot.lua",
                cmd = "Copilot",
                build = ":Copilot auth",
                opts = {
                        suggestion = { enabled = false },
                        panel = { enabled = false },
                        filetypes = {
                                rust = true,
                                lua = true,
                                markdown = false,
                                help = false,
                                ["*"] = false,
                        },
                },
        },
        {
                "zbirenbaum/copilot-cmp",
                dependencies = "copilot.lua",
                opts = {},
                config = function(_, opts)
                        local copilot_cmp = require("copilot_cmp")
                        copilot_cmp.setup(opts)
                        -- attach cmp source whenever copilot attaches
                        -- fixes lazy-loading issues with the copilot cmp source
                        vim.api.nvim_create_autocmd("LspAttach", {
                                callback = function(args)
                                        local client = vim.lsp.get_client_by_id(args.data.client_id)
                                        if client ~= nil and client.name == "copilot" then
                                                copilot_cmp._on_insert_enter({})
                                        end
                                end,
                        })
                end,
        },
        --"nvim-lualine/lualine.nvim",
        {
                "MunifTanjim/nougat.nvim",
        },
        -- {
        -- 	"utilyre/barbecue.nvim",
        -- 	name = "barbecue",
        -- 	version = "*",
        -- 	dependencies = {
        -- 		"SmiteshP/nvim-navic",
        -- 		"nvim-tree/nvim-web-devicons", -- optional dependency
        -- 	},
        -- },
        {
                "neovim/nvim-lspconfig",
                dependencies = {
                        {
                                "SmiteshP/nvim-navbuddy",
                                dependencies = {
                                        "SmiteshP/nvim-navic",
                                        "MunifTanjim/nui.nvim",
                                },
                                opts = { lsp = { auto_attach = true } },
                        },
                },
        },
        "code-biscuits/nvim-biscuits",
        {
                "folke/noice.nvim",
                event = "VeryLazy",
                dependencies = {
                        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
                        "MunifTanjim/nui.nvim",
                        -- OPTIONAL:
                        --   `nvim-notify` is only needed, if you want to use the notification view.
                        --   If not available, we use `mini` as the fallback
                        "rcarriga/nvim-notify",
                },
        },
        "jghauser/mkdir.nvim",
        "nkakouros-original/numbers.nvim",
        "lewis6991/gitsigns.nvim",
        "lewis6991/satellite.nvim",
        {
                "windwp/nvim-autopairs",
                event = "InsertEnter",
                opts = {}, -- this is equalent to setup({}) function
        },
        "HiPhish/rainbow-delimiters.nvim",
        {
                "shellRaining/hlchunk.nvim",
                event = { "UIEnter" },
                config = function()
                        require("hlchunk").setup({
                                indent = {
                                        use_treesitter = true,
                                },
                                line_num = {
                                        use_treesitter = true,
                                },
                        })
                end,
        },
        {
                "stevearc/conform.nvim",
                opts = {
                        formatters_by_ft = {
                                lua = { "stylua" },
                        },
                },
        },
        "gennaro-tedesco/nvim-commaround",
        {
                "numToStr/Comment.nvim",
                opts = {
                        -- add any options here
                },
                lazy = false,
        },
        {
                "okuuva/auto-save.nvim",
                cmd = "ASToggle",                         -- optional for lazy loading on command
                event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
                opts = {
                        -- your config goes here
                        -- or just leave it empty :)
                },
        },
        -- Lua
        {
                "gbprod/cutlass.nvim",
                opts = {
                        exclude = { "ns", "nS" },
                        cut_key = "x",
                        -- your configuration comes here
                        -- or don't set opts to use the default settings
                        -- refer to the configuration section below
                },
        },
        {
                "gbprod/yanky.nvim",
                dependencies = { "kkharji/sqlite.lua" }
        },
        {
                "chrisgrieser/cmp_yanky"
        },
        {
                "saecki/crates.nvim",
                event = { "BufRead Cargo.toml" },
                dependencies = { "nvim-lua/plenary.nvim" },
                config = function()
                        require("crates").setup({
                                src = {
                                        cmp = {
                                                enabled = true,
                                        },
                                },
                        })
                end,
        },
        {
                "luukvbaal/statuscol.nvim",
                config = function()
                        local builtin = require("statuscol.builtin")
                        require("statuscol").setup({
                                relculright = true,
                                segments = {
                                        { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
                                        { text = { "%s" },                  click = "v:lua.ScSa" },
                                        { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
                                },
                        })
                end,
        },
        "NvChad/nvim-colorizer.lua",
        "RRethy/vim-illuminate",
        "yamatsum/nvim-cursorline",
        { "lukas-reineke/virt-column.nvim",           opts = {} },
        "onsails/lspkind.nvim",
        "mfussenegger/nvim-lint",
        {
                "nvim-neotest/neotest",
                dependencies = {
                        "nvim-lua/plenary.nvim",
                        "nvim-treesitter/nvim-treesitter",
                        "antoinemadec/FixCursorHold.nvim",
                        "rouge8/neotest-rust",
                },
        },
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        {
                "NeogitOrg/neogit",
                dependencies = {
                        "nvim-lua/plenary.nvim",         -- required
                        "nvim-telescope/telescope.nvim", -- optional
                        "sindrets/diffview.nvim",        -- optional
                        "ibhagwan/fzf-lua",              -- optional
                },
                config = true,
                branch = "nightly",
        },
        {
                "brenton-leighton/multiple-cursors.nvim",
                config = true,
                keys = {
                        { "<C-Down>",      "<Cmd>MultipleCursorsAddDown<CR>",              mode = { "n", "i" } },
                        { "<C-Up>",        "<Cmd>MultipleCursorsAddUp<CR>",                mode = { "n", "i" } },
                        { "<C-LeftMouse>", "<Cmd>MultipleCursorsMouseAddDelete<CR>",       mode = { "n", "i" } },
                        { "<Leader>a",     "<Cmd>MultipleCursorsAddToWordUnderCursor<CR>", mode = { "n", "v" } },
                },
        },
        -- {
        -- 	"nvim-orgmode/orgmode",
        -- 	dependencies = {
        -- 		{ "nvim-treesitter/nvim-treesitter", lazy = true },
        -- 	},
        -- 	event = "VeryLazy",
        -- 	config = function()
        -- 		-- Load treesitter grammar for org
        -- 		require("orgmode").setup_ts_grammar()
        --
        -- 		-- Setup treesitter
        -- 		require("nvim-treesitter.configs").setup({
        -- 			highlight = {
        -- 				enable = true,
        -- 				additional_vim_regex_highlighting = { "org" },
        -- 			},
        -- 			ensure_installed = { "org" },
        -- 		})
        --
        -- 		-- Setup orgmode
        -- 		require("orgmode").setup({
        -- 			org_agenda_files = "~/orgfiles/**/*",
        -- 			org_default_notes_file = "~/orgfiles/work.org",
        -- 		})
        -- 	end,
        -- },
        -- "akinsho/org-bullets.nvim",
        -- {
        -- 	"lukas-reineke/headlines.nvim",
        -- 	dependencies = "nvim-treesitter/nvim-treesitter",
        -- 	config = true, -- or `opts = {}`
        -- },
        --"ray-x/cmp-treesitter",
        --{ "romgrk/fzy-lua-native", build = "make" },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        { "tzachar/cmp-fuzzy-path",                   dependencies = { "hrsh7th/nvim-cmp", "tzachar/fuzzy.nvim" } },
        { "tzachar/cmp-fuzzy-buffer",                 dependencies = { "hrsh7th/nvim-cmp", "tzachar/fuzzy.nvim" } },
        {
                "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
                config = function()
                        require("lsp_lines").setup()
                end,
        },
        { "m-demare/hlargs.nvim" },
        --	"AckslD/nvim-FeMaco.lua",
        {
                "Shatur/neovim-ayu",
                lazy = false,
                priority = 1000,
                dependencies = { "rktjmp/lush.nvim" },
                config = function()
                        local colors = require("ayu.colors")
                        colors.generate({})
                        require("ayu").setup({
                                mirage = true,
                                overrides = {
                                        -- not working
                                        LspSignatureActiveParameter = { bg = "#000000", fg = "#ff88aa" },
                                        ["@text.diff.add"] = { fg = colors.vcs_added },
                                        ["@text.diff.delete"] = { fg = colors.vcs_removed },
                                        ["@attribute.diff"] = { fg = colors.constant },
                                        ["@neorg.anchors"] = { fg = colors.accent },
                                        ["@neorg.todo_items.cancelled"] = { fg = colors.comment },
                                        WildMenu = { fg = colors.markup, bg = nil },
                                        NvimInternalError = { fg = colors.error, bg = nil },
                                        DapUIFloatBorder = { fg = colors.comment },
                                        NvimTreeIndentMarker = { fg = colors.comment },
                                        HLIndent1 = { fg = colors.comment },
                                        SatelliteCursor = { fg = colors.comment },
                                        LspInlayHint = { fg = colors.comment },
                                        -- Whitespace = { bold = true },
                                },
                        })
                end,
                init = function()
                        vim.cmd.colorscheme("ayu")
                end,
        },
        -- {
        --         'uloco/bluloco.nvim',
        --         lazy = false,
        --         priority = 1000,
        --         dependencies = { 'rktjmp/lush.nvim' },
        --         config = function()
        --                 -- your optional config goes here, see below.
        --         end,
        --         init = function()
        --                 vim.cmd.colorscheme("bluloco-dark")
        --         end,
        -- },
        {
                "ray-x/lsp_signature.nvim",
                event = "VeryLazy",
        },
        {
                "nvim-neorg/neorg",
                build = ":Neorg sync-parsers",
                dependencies = { "nvim-lua/plenary.nvim" },
        },
        {
                "michaelb/sniprun",
                branch = "master",
                build = "sh install.sh 1",
                -- do 'sh install.sh 1' if you want to force compile locally
                -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

                config = function()
                        require("sniprun").setup({
                                selected_interpreters = { "Generic" },
                                interpreter_options = {
                                        Generic = {
                                                ysh = {
                                                        -- any key name is ok
                                                        supported_filetypes = { "ysh" }, -- mandatory
                                                        extension = ".ysh",              -- recommended, but not mandatory. Sniprun use this to create temporary files
                                                        interpreter = "ysh",             -- interpreter or compiler (+ options if any)
                                                        compiler = "",                   -- one of those MUST be non-empty
                                                },
                                        },
                                },
                        })
                end,
        },
        {
                "folke/trouble.nvim",
                dependencies = { "nvim-tree/nvim-web-devicons" },
                opts = {
                        -- your configuration comes here
                        -- or leave it empty to use the default settings
                        -- refer to the configuration section below
                },
        },
        "smjonas/inc-rename.nvim",
        {
                "andrewferrier/wrapping.nvim",
                config = function()
                        require("wrapping").setup({
                                auto_set_mode_filetype_allowlist = {},
                        })
                end,
        },
        {
                "stevearc/overseer.nvim",
                opts = {},
        },
        "doums/suit.nvim",
        "cmp-cmdline-history",
        {
                "Wansmer/symbol-usage.nvim",
                event = "BufReadPre", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
        },
        {
                "Bekaboo/dropbar.nvim",
                -- optional, but required for fuzzy finder support
                dependencies = {
                        "nvim-telescope/telescope-fzf-native.nvim",
                },
        },
        "https://git.sr.ht/~soywod/himalaya-vim",
        "nvim-telescope/telescope-symbols.nvim",
        "ggandor/leap.nvim",
        "ggandor/leap-spooky.nvim",
        "ggandor/flit.nvim",
        "backdround/neowords.nvim",
        "LudoPinelli/comment-box.nvim"
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

require("neoconf").setup({})

local luasnip = require("luasnip")
local cmp = require("cmp")

-- https://github.com/zbirenbaum/copilot-cmp
local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local lspkind = require("lspkind")

local compare = require("cmp.config.compare")

cmp.setup({
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
                        elseif has_words_before() then
                                cmp.complete()
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
                { name = "luasnip" },
                { name = "nvim_lsp" },
                --{ name = "treesitter" },
                --{ name = "fuzzy_buffer" },
                { name = "fuzzy_path" },
                { name = "cmp_yanky" },
                { name = "crates" },
                -- { name = "beancount", option = {
                -- 	account = "~/account.bean",
                -- } },
                { name = "neorg" },
        }),
        formatting = {
                format = lspkind.cmp_format({
                        mode = "symbol_text", -- show only symbol annotations
                        -- maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        symbol_map = {
                                Copilot = " ",
                        },
                }),
        },
        sorting = {
                priority_weight = 2,
                comparators = {
                        require("cmp_fuzzy_path.compare"),
                        require("cmp_fuzzy_buffer.compare"),
                        compare.offset,
                        compare.exact,
                        compare.score,
                        compare.recently_used,
                        compare.kind,
                        compare.sort_text,
                        compare.length,
                        compare.order,
                },
        },
        matching = {
                disallow_partial_fuzzy_matching = false,
        },
        experimental = {
                ghost_text = {
                        hl_group = "CmpGhostText",
                },
        },
})

cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
                {
                        name = "fuzzy_path",
                },
        }, {
                { name = "cmdline" },
        }, {
                { name = "cmdline_history" },
        }),
})

-- setup nvim-cmp plugin for the cmdline / cmp
cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
                { name = "fuzzy_buffer" },
        }, {
                { name = "cmdline_history" },
        }),
})

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

local telescope = require("telescope")
local trouble = require("trouble.providers.telescope")
telescope.setup({
        defaults = {
                mappings = {
                        i = {
                                ["<C-t>"] = trouble.open_with_trouble,
                        },
                        n = {
                                ["<C-t>"] = trouble.open_with_trouble,
                        },
                },
        },
})

telescope.load_extension("undo")
telescope.load_extension("yank_history")
telescope.load_extension("noice")
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files in all subdirectories" })
vim.keymap.set("n", "<leader>f/", builtin.live_grep, { desc = "Search through all files content" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
vim.keymap.set("n", "<leader>fc", builtin.commands, {})
vim.keymap.set("n", "<leader>fm", builtin.man_pages, {})
vim.keymap.set("n", "<leader>fu", telescope.extensions.undo.undo, {})
vim.keymap.set("n", "<leader>fy", telescope.extensions.yank_history.yank_history, { desc = "Open the yank history" })
vim.keymap.set("n", "<leader>fk", builtin.keymaps, {})
vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Search through the workspace diagnostics" })
vim.keymap.set("n", "<leader>lg", builtin.lsp_definitions, { desc = "Search (or go to) the LSP definitions" })
vim.keymap.set("n", "<leader>ls", builtin.lsp_document_symbols, { desc = "Search through the LSP document symbols" })
vim.keymap.set("n", "<leader>lr", builtin.lsp_references, { desc = "Search through the LSP references" })
vim.keymap.set("n", "<leader>lw", builtin.lsp_workspace_symbols, { desc = "Search through the LSP workspace symbols" })

--vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, {})

vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99   -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.opt.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

require("neodev").setup({
        -- library = { plugins = { "neotest", "nvim-dap-ui", "neogit" }, types = true },
})

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
}
local lspconfig = require("lspconfig")
local util = require("lspconfig.util")
local configs = require("lspconfig.configs")
configs.rpmspec = {
        default_config = {
                cmd = { 'python3', '-mrpm_spec_language_server', '--stdio' },
                filetypes = { 'spec' },
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
local language_servers = { "pyright", "clangd", "rpmspec" } -- or list servers manually like {'gopls', 'clangd'}
for _, ls in ipairs(language_servers) do
        lspconfig[ls].setup({
                capabilities = capabilities,
                -- you can add other fields for setting up lsp server in this table
        })
end
lspconfig.rust_analyzer.setup({
        settings = {
                ["rust-analyzer"] = {
                        diagnostics = {
                                enable = true,
                        },
                        inlayHints = {
                                enable = true,
                        }
                        -- check = {
                        -- 	command = "clippy",
                        -- extraArgs = { "--all", "--", "-W", "clippy::all" },
                        -- },
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

require("fidget").setup()

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

vim.keymap.set({ 'n', 'x' }, '<Leader>L', function()
        vim.schedule(function()
                if require('hlslens').exportLastSearchToQuickfix() then
                        vim.cmd('cw')
                end
        end)
        return ':noh<CR>'
end, { expr = true })
require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
})

--require("copilot_cmp").setup()
-- require("lualine").setup({
-- 	extensions = { "chadtree", "trouble", "nvim-dap-ui", "lazy", "man", "overseer" },
-- 	sections = {
-- 		lualine_x = { "overseer", "encoding", "require('wrapping').get_current_mode()", "fileformat", "filetype" },
-- 	},
-- 	options = {
-- 		theme = "ayu",
-- 	},
-- })
--require('slanted-gaps')
-- require("barbecue").setup()

vim.keymap.set("n", "<Leader>n", require("nvim-navbuddy").open, {})

-- require("nvim-biscuits").setup({})

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
                bottom_search = true,         -- use a classic bottom cmdline for search
                command_palette = true,       -- position the cmdline and popupmenu together
                long_message_to_split = true, -- long messages will be sent to a split
                inc_rename = true,            -- enables an input dialog for inc-rename.nvim
                lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
        messages = {
                enabled = false,
        },
})

require("numbers").setup({})
require("nvim-web-devicons").setup({})
require("gitsigns").setup({})
require("satellite").setup({})

require("conform").setup({
        format_on_save = {timeout_ms = 500, lsp_fallback = true }
})
vim.keymap.set("n", "<leader>F", require("conform").format, { desc = "Format the current buffer" })

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
require("nvim-treesitter.configs").setup({
        auto_install = true,
})

require("colorizer").setup({})
require("nvim-cursorline").setup({
        cursorword = { enable = false },
})

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

-- Required to make which-key load
require("which-key").show("<Leader>", {})

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
                                            finder = finders.new_oneshot_job(
                                                    { "fd", "--hidden", "--no-ignore", "--type", "x" }, {}),
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
                        return vim.split(args_string, " ")
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

local neogit = require("neogit")
neogit.setup({})
vim.keymap.set("n", "<leader>G", neogit.open)

require("yanky").setup({
        ring = {
                storage = "sqlite"
        }
})
vim.keymap.set({ "n", "x" }, "y", "<Plug>(YankyYank)")
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")
vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set({ "n", "v" }, "Y", function()
        return require("yanky").yank({ register = "+" })
end, { expr = true })

vim.diagnostic.config({
        virtual_lines = { only_current_line = true },
        virtual_text = false,
        signs = {
                text = {
                        [vim.diagnostic.severity.ERROR] = ' ',
                        [vim.diagnostic.severity.WARN] = ' ',
                        [vim.diagnostic.severity.INFO] = ' ',
                        [vim.diagnostic.severity.HINT] = ' ',
                }
        }
})

-- require("lsp-lens").setup({})

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

require("neorg").setup({
        load = {
                ["core.defaults"] = {},
                ["core.esupports.metagen"] = { config = { type = "auto", update_date = true } },
                ["core.qol.toc"] = {},
                ["core.qol.todo_items"] = {},
                ["core.concealer"] = {}, -- Adds pretty icons to your documents
                ["core.dirman"] = {
                        config = {
                                workspaces = {
                                        work = "~/notes/work",
                                        home = "~/notes/home",
                                },
                        },
                },
                ["core.journal"] = {
                        config = {
                                journal_folder = "report",
                                workspace = "work",
                                strategy = "flat",
                        },
                },
                ["core.completion"] = {
                        config = {
                                engine = "nvim-cmp",
                        },
                },
                ["core.export"] = {},
        },
})

local sniprun = require("sniprun")
vim.keymap.set("v", "f", function()
        sniprun.run("v")
end)
vim.keymap.set("n", "<Leader>xx", function()
        sniprun.run("n")
end, { silent = true })
--vim.keymap.set("n", "<Leader>xx", sniprun.run, { silent = true })
vim.keymap.set(
        "n",
        "<Leader>xf",
        ":let b:caret=winsaveview() <CR> | :%SnipRun <CR>| :call winrestview(b:caret) <CR>",
        {}
)

local function get_next_friday()
        local today_time = os.time()
        local today = os.date("*t", today_time)
        local friday_wday = (6 - today.wday)
        local friday = os.date("%Y-%m-%d", today_time + friday_wday * 24 * 60 * 60)
        return friday
end
-- add a keymap that create a new journal for the next friday, using Neorg journal custom command
vim.keymap.set("n", "<Leader>wr", function()
        local friday = get_next_friday()
        vim.cmd("Neorg journal custom " .. friday)
end)

vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("InlayHints", {}),
        callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client.server_capabilities.inlayHintProvider then
                        vim.lsp.inlay_hint.enable(0, true)
                end
        end,
})

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
        require("trouble").toggle("document_diagnostics")
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
        require("trouble").next({ skip_groups = true, jump = true });
end, { desc = "Next item in quickfix" })

vim.keymap.set("n", "<leader>qp", function()
        -- jump to the previous item, skipping the groups
        require("trouble").previous({ skip_groups = true, jump = true });
end, { desc = "Previous item in quickfix" })

require("inc_rename").setup()
vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })

require("dap.ext.vscode").json_decode = require("overseer.json").decode
require("overseer").setup({})

require("suit").setup({})

local api = vim.api
local keymap_restore = {}
dap.listeners.after["event_initialized"]["me"] = function()
        for _, buf in pairs(api.nvim_list_bufs()) do
                local keymaps = api.nvim_buf_get_keymap(buf, "n")
                for _, keymap in pairs(keymaps) do
                        if keymap.lhs == "K" then
                                table.insert(keymap_restore, keymap)
                                api.nvim_buf_del_keymap(buf, "n", "K")
                        end
                end
        end
        api.nvim_set_keymap("n", "K", '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
end

dap.listeners.after["event_terminated"]["me"] = function()
        for _, keymap in pairs(keymap_restore) do
                api.nvim_buf_set_keymap(keymap.buffer, keymap.mode, keymap.lhs, keymap.rhs,
                        { silent = keymap.silent == 1 })
        end
        keymap_restore = {}
end

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

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

require("symbol-usage").setup({
        text_format = text_format,
})

require("hlslens").setup({
})
require("slanty")

require('leap').add_default_mappings()
-- Hide the (real) cursor when leaping, and restore it afterwards.
vim.api.nvim_create_autocmd('User', {
        pattern = 'LeapEnter',
        callback = function()
                vim.cmd.hi('Cursor', 'blend=100')
                vim.opt.guicursor:append { 'a:Cursor/lCursor' }
        end,
}
)
vim.api.nvim_create_autocmd('User', {
        pattern = 'LeapLeave',
        callback = function()
                vim.cmd.hi('Cursor', 'blend=0')
                vim.opt.guicursor:remove { 'a:Cursor/lCursor' }
        end,
}
)

require("leap-spooky").setup()
require("flit").setup()

local neowords = require("neowords")
local p = neowords.pattern_presets

-- Subwords with dots and commas
local hops = neowords.get_word_hops(
        p.snake_case,
        p.camel_case,
        p.upper_case,
        p.number,
        p.hex_color,
        "\\v\\.+",
        "\\v,+"
)

vim.keymap.set({ "n", "x", "o" }, "w", hops.forward_start)
vim.keymap.set({ "n", "x", "o" }, "e", hops.forward_end)
vim.keymap.set({ "n", "x", "o" }, "q", hops.backward_start)
vim.keymap.set({ "n", "x", "o" }, "ge", hops.backward_end)

local bigword_hops = neowords.get_word_hops(
        p.any_word,
        p.number,
        p.hex_color
)

vim.keymap.set({ "n", "x", "o" }, "W", bigword_hops.forward_start)
vim.keymap.set({ "n", "x", "o" }, "E", bigword_hops.forward_end)
vim.keymap.set({ "n", "x", "o" }, "Q", bigword_hops.backward_start)
vim.keymap.set({ "n", "x", "o" }, "Q", bigword_hops.backward_start)

vim.opt.list = true

-- local space = "·"
-- vim.opt.listchars:append {
--         tab = "│─",
--         multispace = space,
--         lead = space,
--         trail = space,
--         nbsp = space
-- }
