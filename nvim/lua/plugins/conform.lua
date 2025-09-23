return {
	"stevearc/conform.nvim",
	dependencies = { "mason.nvim" },
	event = { "BufWritePre" },
	cmd = "ConformInfo",
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ timeout_ms = 3000 })
			end,
			mode = { "n", "v" },
			desc = "Format file or range",
		},
		{
			"<leader>cF",
			function()
				require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
			end,
			mode = { "n", "v" },
			desc = "Format Injected Langs",
		},
	},
	opts = {
		default_format_opts = {
			timeout_ms = 3000,
			async = false, -- keep blocking for reliable results
			quiet = false,
			lsp_format = "fallback", -- use LSP if no formatter available
		},
		format_on_save = { timeout_ms = 500 },
		formatters_by_ft = {
			c = { "clang-format" },
			cpp = { "clang-format" },
			lua = { "stylua" },
			fish = { "fish_indent" },
			sh = { "shfmt" },
			javascript = { "prettier" },
			python = { "black" },
			typescript = { "prettier" },
			html = { "prettier" },
			css = { "prettier" },
			json = { "prettier" },
			java = { "google-java-format" },
			kotlin = { "ktlint" },
			go = { "gofmt" },
			rust = { "rustfmt" },
			markdown = { "prettier" },
			yaml = { "prettier" },
			toml = { "taplo" },
			-- add more here, like:
		},
		formatters = {
			injected = { options = { ignore_errors = true } },
		},
	},
	config = function(_, opts)
		require("conform").setup(opts)

		-- optional: format on save
		-- vim.api.nvim_create_autocmd("BufWritePre", {
		-- 	pattern = "*",
		-- 	callback = function(args)
		-- 		require("conform").format({ bufnr = args.buf, lsp_fallback = true })
		-- 	end,
		-- })
	end,
}
