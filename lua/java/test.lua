-- Java Test Runner Module
-- Provides VSCode-like test execution capabilities

local M = {}

function M.run_test(method_name)
  local jdtls = require("jdtls")
  local dap = require("dap")

  -- Run test using DAP
  dap.run({
    type = "java",
    request = "launch",
    name = "Run Test: " .. method_name,
    mainClass = method_name,
    projectName = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
    cwd = vim.fn.getcwd(),
    console = "integratedTerminal",
    stopOnEntry = false,
    testKind = "junit",
    testMethods = { method_name },
  })
end

function M.run_all_tests_in_class()
  local jdtls = require("jdtls")

  -- Run all tests in the current class
  jdtls.test_class({
    after_test = function(result)
      vim.notify("Test completed: " .. result.summary, vim.log.levels.INFO)
    end,
  })
end

function M.run_test_under_cursor()
  local jdtls = require("jdtls")

  -- Run the test method under cursor
  jdtls.test_nearest_method({
    after_test = function(result)
      vim.notify("Test completed: " .. result.summary, vim.log.levels.INFO)
    end,
  })
end

function M.debug_test_under_cursor()
  local jdtls = require("jdtls")

  -- Debug the test method under cursor
  jdtls.test_nearest_method({
    config = {
      console = "integratedTerminal",
      stopOnEntry = true,
    },
  })
end

return M
