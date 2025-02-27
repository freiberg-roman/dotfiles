local llm = require('llm')

llm.setup({
  backend = "huggingface",
  enable_suggestions_on_startup = false,
})

vim.api.nvim_set_keymap("n", "<leader>ll", ":LLMSuggestion<CR>", { silent = true, noremap=true })
vim.keymap.set("i", "<Tab>", function ()
	local llm = require('llm.completion')

	if llm.shown_suggestion ~= nil then
		llm.complete()
	else 
		local keys = vim.api.nvim_replace_termcodes('<Tab>', true, false, true)
		vim.api.nvim_feedkeys(keys, 'n', false)
	end
end,
{ noremap = true, silent = true})
