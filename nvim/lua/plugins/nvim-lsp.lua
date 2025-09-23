return {
	"neovim/nvim-lspconfig",
	event = "BufReadPre",
	dependencies = {
		"mason.nvim",
		{ "mason-org/mason-lspconfig.nvim", config = function() end },
		"saghen/blink.cmp", -- you said you use blink.cmp
	},
	config = function()
		-- Mason setup
		require("mason").setup()
		require("mason-lspconfig").setup({
			ensure_installed = { "lua_ls" }, -- add more servers you want
		})

		-- Capabilities (from blink.cmp)
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		local blink_ok, blink = pcall(require, "blink.cmp")
		if blink_ok and blink.get_lsp_capabilities then
			capabilities = blink.get_lsp_capabilities(capabilities)
		end

		-- On attach (keymaps, etc.)
		local on_attach = function(client, bufnr)
			local bufmap = function(mode, lhs, rhs, desc)
				vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
			end

			bufmap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
			bufmap("n", "K", vim.lsp.buf.hover, "Hover Docs")
			bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
			bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")

			-- Inlay hints (if supported)
			if client.server_capabilities.inlayHintProvider then
				vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
			end
		end

		-- 🔴 Turn off all inlay hints globally
		vim.lsp.handlers["textDocument/inlayHint"] = function() end

		-- Diagnostics UI
		vim.diagnostic.config({
			float = { border = "rounded", source = "if_many", focusable = false },
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "",
					[vim.diagnostic.severity.WARN] = "",
					[vim.diagnostic.severity.HINT] = "",
					[vim.diagnostic.severity.INFO] = "",
				},
			},
		})

		-- Server configs (using new API)
		vim.lsp.config("lua_ls", {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					workspace = { checkThirdParty = false },
					hint = { enable = true },
					completion = { callSnippet = "Replace" },
				},
			},
		})

		-- Enable servers (from mason ensure_installed list)
		for _, server in ipairs(require("mason-lspconfig").get_installed_servers()) do
			vim.lsp.enable(server)
		end
	end,
}
