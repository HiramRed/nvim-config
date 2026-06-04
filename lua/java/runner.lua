-- Java Application Runner Module
-- Provides VSCode-like run/debug functionality

local M = {}

function M.run_main()
  local jdtls = require("jdtls")
  local path = vim.fn.expand("%:p")

  -- Find and run main method
  jdtls.resolve_classname(path, function(err, classname)
    if err then
      vim.notify("Error resolving classname: " .. err, vim.log.levels.ERROR)
      return
    end

    local dap = require("dap")
    dap.run({
      type = "java",
      request = "launch",
      name = "Run Main",
      mainClass = classname,
      projectName = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
      cwd = vim.fn.getcwd(),
      console = "integratedTerminal",
      stopOnEntry = false,
    })
  end)
end

function M.debug_main()
  local jdtls = require("jdtls")
  local path = vim.fn.expand("%:p")

  -- Find and debug main method
  jdtls.resolve_classname(path, function(err, classname)
    if err then
      vim.notify("Error resolving classname: " .. err, vim.log.levels.ERROR)
      return
    end

    local dap = require("dap")
    dap.run({
      type = "java",
      request = "launch",
      name = "Debug Main",
      mainClass = classname,
      projectName = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
      cwd = vim.fn.getcwd(),
      console = "integratedTerminal",
      stopOnEntry = true,
    })
  end)
end

function M.run_with_args()
  local args = vim.fn.input("Arguments: ")
  if args == "" then
    return
  end

  local jdtls = require("jdtls")
  local path = vim.fn.expand("%:p")

  jdtls.resolve_classname(path, function(err, classname)
    if err then
      vim.notify("Error resolving classname: " .. err, vim.log.levels.ERROR)
      return
    end

    local dap = require("dap")
    dap.run({
      type = "java",
      request = "launch",
      name = "Run with Args",
      mainClass = classname,
      projectName = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
      cwd = vim.fn.getcwd(),
      console = "integratedTerminal",
      stopOnEntry = false,
      args = args,
    })
  end)
end

function M.compile_project()
  local build_tool = nil
  if vim.fn.filereadable("pom.xml") == 1 then
    build_tool = "maven"
  elseif vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
    build_tool = "gradle"
  end

  if build_tool == "maven" then
    vim.cmd("!mvn clean compile")
  elseif build_tool == "gradle" then
    vim.cmd("!./gradlew clean compileJava")
  else
    vim.notify("No build tool found (Maven/Gradle)", vim.log.levels.WARN)
  end
end

function M.build_project()
  local build_tool = nil
  if vim.fn.filereadable("pom.xml") == 1 then
    build_tool = "maven"
  elseif vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
    build_tool = "gradle"
  end

  if build_tool == "maven" then
    vim.cmd("!mvn clean package")
  elseif build_tool == "gradle" then
    vim.cmd("!./gradlew clean build")
  else
    vim.notify("No build tool found (Maven/Gradle)", vim.log.levels.WARN)
  end
end

return M
