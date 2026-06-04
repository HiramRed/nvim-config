-- Java Development Health Check Plugin Spec
-- Run :JavaHealth to verify your Java development environment

local function check_java_health()
  local health = vim.health or require("health")
  health.start("Java Development Environment")

  -- Check Java
  local java_version = vim.fn.systemlist("java -version 2>&1")[1]
  if vim.v.shell_error == 0 then
    health.ok("Java installed: " .. java_version)
  else
    health.error("Java not found. Please install Java JDK 11+")
  end

  -- Check Mason packages
  local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
  local packages = { "jdtls", "java-debug-adapter", "java-test" }

  for _, pkg in ipairs(packages) do
    local pkg_path = mason_path .. "/" .. pkg
    if vim.fn.isdirectory(pkg_path) == 1 then
      health.ok("Mason package installed: " .. pkg)
    else
      health.error("Mason package missing: " .. pkg .. ". Run :Mason and install it.")
    end
  end

  -- Check workspace directory
  local workspace_base = vim.fn.stdpath("data") .. "/jdtls/workspaces"
  if vim.fn.isdirectory(workspace_base) == 1 then
    health.ok("JDTLS workspace directory exists")
  else
    health.info("JDTLS workspace directory will be created when needed")
  end

  -- Check Java formatter config
  local formatter_path = vim.fn.stdpath("config") .. "/java-formatter.xml"
  if vim.fn.filereadable(formatter_path) == 1 then
    health.ok("Java formatter config found")
  else
    health.warn("Java formatter config not found at: " .. formatter_path)
  end
end

return {
  "mfussenegger/nvim-jdtls",
  optional = true,
  config = function()
    -- Register health check command
    vim.api.nvim_create_user_command("JavaHealth", function()
      check_java_health()
    end, { desc = "Check Java development environment health" })

    -- Add to health checks
    vim.api.nvim_create_autocmd("User", {
      pattern = "HealthCheck",
      callback = function()
        check_java_health()
      end,
    })
  end,
}
