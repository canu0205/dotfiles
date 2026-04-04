-- gitsigns recommended keymaps (extends base gitsigns config in init.lua)

return {
  "lewis6991/gitsigns.nvim",
  opts = {
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- navigation
      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, { desc = "next git change" })

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, { desc = "prev git change" })

      -- actions
      map("v", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "stage hunk" })
      map("v", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, { desc = "reset hunk" })
      map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "stage hunk" })
      map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "reset hunk" })
      map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "stage buffer" })
      map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "reset buffer" })
      map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "preview hunk" })
      map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "preview hunk inline" })
      map("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end, { desc = "blame line" })
      map("n", "<leader>hd", gitsigns.diffthis, { desc = "diff against index" })
      map("n", "<leader>hD", function() gitsigns.diffthis("@") end, { desc = "diff against last commit" })

      -- toggles
      map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "toggle blame line" })

      -- text object
      map({ "o", "x" }, "ih", gitsigns.select_hunk)
    end,
  },
}
