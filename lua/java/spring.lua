-- Spring Boot Support Module
-- Provides Spring Boot specific functionality

local M = {}

function M.run_spring_boot()
  local build_tool = nil
  if vim.fn.filereadable("pom.xml") == 1 then
    build_tool = "maven"
  elseif vim.fn.filereadable("build.gradle") == 1 or vim.fn.filereadable("build.gradle.kts") == 1 then
    build_tool = "gradle"
  end

  if build_tool == "maven" then
    vim.cmd("!mvn spring-boot:run")
  elseif build_tool == "gradle" then
    vim.cmd("!./gradlew bootRun")
  else
    vim.notify("No Spring Boot project detected", vim.log.levels.WARN)
  end
end

function M.debug_spring_boot()
  local jdtls = require("jdtls")

  -- Find the main class with @SpringBootApplication
  jdtls.resolve_classname(vim.fn.expand("%:p"), function(err, classname)
    if err then
      vim.notify("Error resolving classname: " .. err, vim.log.levels.ERROR)
      return
    end

    local dap = require("dap")
    dap.run({
      type = "java",
      request = "launch",
      name = "Debug Spring Boot App",
      mainClass = classname,
      projectName = vim.fn.fnamemodify(vim.fn.getcwd(), ":t"),
      cwd = vim.fn.getcwd(),
      console = "integratedTerminal",
      stopOnEntry = false,
      vmArgs = "-Dspring-boot.run.jvmArguments=\"-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=5005\"",
    })
  end)
end

function M.generate_spring_boot_project()
  vim.ui.input({ prompt = "Enter Spring Boot project name: " }, function(name)
    if not name or name == "" then
      return
    end

    vim.ui.select({ "maven", "gradle" }, { prompt = "Select build tool:" }, function(build_tool)
      if not build_tool then
        return
      end

      local cmd = string.format(
        "curl https://start.spring.io/starter.zip -d type=%s-project -d name=%s -d artifactId=%s -o %s.zip",
        build_tool,
        name,
        name,
        name
      )

      vim.fn.jobstart(cmd, {
        on_exit = function(_, exit_code)
          if exit_code == 0 then
            vim.notify("Spring Boot project generated: " .. name .. ".zip", vim.log.levels.INFO)
          else
            vim.notify("Failed to generate Spring Boot project", vim.log.levels.ERROR)
          end
        end,
      })
    end)
  end)
end

return M
