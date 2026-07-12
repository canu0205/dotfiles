-- debug adapter protocol (DAP) for Go and other languages

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mason-org/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "leoluz/nvim-dap-go",
  },
  keys = {
    { "<F5>", function() require("dap").continue() end, desc = "debug: start/continue" },
    { "<F1>", function() require("dap").step_into() end, desc = "debug: step into" },
    { "<F2>", function() require("dap").step_over() end, desc = "debug: step over" },
    { "<F3>", function() require("dap").step_out() end, desc = "debug: step out" },
    { "<leader>b", function() require("dap").toggle_breakpoint() end, desc = "debug: toggle breakpoint" },
    { "<leader>B", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "debug: conditional breakpoint" },
    { "<F7>", function() require("dapui").toggle() end, desc = "debug: toggle ui" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("mason-nvim-dap").setup({
      automatic_installation = true,
      handlers = {},
      ensure_installed = { "delve" },
    })

    dapui.setup({
      icons = { expanded = "v", collapsed = ">", current_frame = "*" },
      controls = {
        icons = {
          pause = "||",
          play = ">",
          step_into = "->",
          step_over = "=>",
          step_out = "<-",
          step_back = "b",
          run_last = ">>",
          terminate = "x",
          disconnect = "dc",
        },
      },
    })

    dap.listeners.after.event_initialized["dapui_config"] = dapui.open
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close

    require("dap-go").setup({
      delve = {
        detached = vim.fn.has("win32") == 0,
      },
    })
  end,
}
