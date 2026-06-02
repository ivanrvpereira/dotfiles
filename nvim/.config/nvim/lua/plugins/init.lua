-- Add plugin specs as new .lua files in this directory,
-- or add them to this file's return table.
-- See: https://lazy.folke.io/spec
return {
  {
    "christoomey/vim-tmux-navigator",
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      local map = vim.keymap.set
      local opts = { silent = true }

      map("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", vim.tbl_extend("force", opts, { desc = "Go to Left Window" }))
      map("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", vim.tbl_extend("force", opts, { desc = "Go to Lower Window" }))
      map("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", vim.tbl_extend("force", opts, { desc = "Go to Upper Window" }))
      map("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", vim.tbl_extend("force", opts, { desc = "Go to Right Window" }))

      map("t", "<C-h>", [[<C-w>:<C-U>TmuxNavigateLeft<cr>]], opts)
      map("t", "<C-j>", [[<C-w>:<C-U>TmuxNavigateDown<cr>]], opts)
      map("t", "<C-k>", [[<C-w>:<C-U>TmuxNavigateUp<cr>]], opts)
      map("t", "<C-l>", [[<C-w>:<C-U>TmuxNavigateRight<cr>]], opts)
    end,
  },
}
