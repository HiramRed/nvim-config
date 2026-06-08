-- Java Development Environment
-- Includes: nvim-jdtls, nvim-dap, nvim-dap-ui, java-debug, vscode-java-test

local function get_jdtls_workspace_dir()
  local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
  local project_path = vim.fn.getcwd()
  -- Create a hash based on the full project path to distinguish different projects
  local hash = vim.fn.sha256(project_path)
  local workspace_dir = vim.fn.stdpath("data") .. "/jdtls/workspaces/" .. project_name .. "_" .. string.sub(hash, 1, 8)
  return workspace_dir
end

vim.api.nvim_create_user_command("JdtlsCleanWorkspace", function()
  local workspace = get_jdtls_workspace_dir()

  if vim.fn.isdirectory(workspace) == 1 then
    vim.fn.delete(workspace, "rf")
    print("Cleaned jdtls workspace: " .. workspace)
  else
    print("Workspace not found: " .. workspace)
  end
end, { desc = "Clean jdtls workspace for current project" })

-- Global state for JDTLS toggle
_G.jdtls_enabled = false

local function get_jdtls_bundles()
  local bundles = {}

  -- debug
  vim.list_extend(
    bundles,
    vim.split(
      vim.fn.glob(
        vim.fn.stdpath("data")
        .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"
      ),
      "\n"
    )
  )

  -- 添加 spring-boot jdtls 扩展 jar 包
  vim.list_extend(bundles, require("spring_boot").java_extensions())

  return bundles
end

local function get_jdtls_config()
  -- Java 23 home (only for JDTLS, won't affect global JAVA_HOME)
  local java_home = "/opt/homebrew/Cellar/openjdk/23.0.2/libexec/openjdk.jdk/Contents/Home"

  local java_version = "JavaSE-23"

  -- JDTLS installation directory
  local jdtls_home = vim.fn.expand("~/tool/jdt-language-server-1.54.0-202511200503")

  -- Find the correct launcher jar
  local launcher_jar = jdtls_home .. "/plugins/org.eclipse.equinox.launcher_1.7.100.v20251111-0406.jar"

  local workspace_dir = get_jdtls_workspace_dir()

  -- Lombok jar path (assumes lombok.jar is in ~/tool/)
  -- Download lombok from: https://projectlombok.org/downloads/lombok.jar
  local lombok_jar = vim.fn.expand("~/tool/lombok/lombok.jar")

  -- VM args including Lombok support
  local vmargs = {
    "-javaagent:" .. lombok_jar,
    "-Xbootclasspath/a:" .. lombok_jar,
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Djdt.ls.core.preferLinkedResources=true",
    "-Xmx4g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
  }

  local bundles = get_jdtls_bundles()

  local config = {
    cmd = {
      java_home .. "/bin/java",
      "-Declipse.application=org.eclipse.jdt.ls.core.id1",
      "-Dosgi.bundles.defaultStartLevel=4",
      "-Declipse.product=org.eclipse.jdt.ls.core.product",
      unpack(vmargs),
      "-jar", launcher_jar,
      "-configuration", jdtls_home .. "/config_mac_arm",
      "-data", workspace_dir,
    },
    root_dir = vim.fs.root(0, { ".git", "pom.xml", "mvnw", "gradlew", "build.gradle" }),
    settings = {
      dap = {
        console = "integratedTerminal",
      },
      java = {
        home = java_home,
        saveAction = {
          organizeImports = false,
        },
        project = {
          preferLinkedResources = true,
          outputPath = "bin",
          sourcePaths = { "src" },
          referencedLibraries = {},
          importHint = true,
        },
        eclipse = {
          downloadSources = true,
          preference = {
            createJavaSourceFoldersAtRoot = false,
          },
        },
        configuration = {
          updateBuildConfiguration = "automatic",
          runtimes = {
            {
              name = java_version,
              path = java_home,
            }
          }
        },
        maven = {
          downloadSources = true,
        },
        implementationsCodeLens = {
          enabled = true,
        },
        referencesCodeLens = {
          enabled = true,
        },
        references = {
          includeDecompiledSources = true,
        },
        inlayHints = {
          parameterNames = {
            enabled = "all",
          },
        },
        format = {
          enabled = true,
          settings = {
            url = vim.fn.stdpath("config") .. "/java-formatter.xml",
            profile = "GoogleStyle",
          },
        },
        signatureHelp = {
          enabled = true,
        },
        completion = {
          favoriteStaticMembers = {
            "org.hamcrest.MatcherAssert.assertThat",
            "org.hamcrest.Matchers.*",
            "org.hamcrest.CoreMatchers.*",
            "org.junit.jupiter.api.Assertions.*",
            "java.util.Collections.*",
            "java.util.Objects.*",
            "java.util.Arrays.*",
            "org.assertj.core.api.Assertions.*",
            "org.assertj.core.api.Assumptions.*",
            "org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*",
            "org.springframework.test.web.servlet.result.MockMvcResultMatchers.*",
          },
        },
        contentProvider = {
          preferred = "fernflower",
        },
        extendedClientCapabilities = {
          progressReportProvider = false,
        },
        sources = {
          organizeImports = {
            starThreshold = 9999,
            staticStarThreshold = 9999,
          },
        },
        codeGeneration = {
          toString = {
            template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
          },
          useBlocks = true,
        },
        annotationProcessing = {
          enabled = true,
        },
      },
    },
    init_options = {
      bundles = bundles,
    },
    handlers = {
      ["language/status"] = function(_, result)
        vim.notify("JDTLS: " .. result.message, vim.log.levels.INFO)
      end,
    },
  }

  return config
end

local function toggle_jdtls()
  _G.jdtls_enabled = not _G.jdtls_enabled
  if _G.jdtls_enabled then
    local jdtls = require("jdtls")
    local config = get_jdtls_config()
    jdtls.setup_dap({
      hotcodereplace = "auto",
    })

    -- require("jdtls.dap").setup_dap_main_class_configs()
    jdtls.start_or_attach(config)
    vim.notify("JDTLS enabled", vim.log.levels.INFO)
  else
    local clients = vim.lsp.get_active_clients({ name = "jdtls" })
    for _, client in ipairs(clients) do
      client.stop()
    end
    vim.notify("JDTLS disabled", vim.log.levels.INFO)
  end
end

return {
  -- nvim-jdtls: Java LSP client
  {
    "mfussenegger/nvim-jdtls",
    ft = "java",
    dependencies = {
      "nvim-dap",
      "nvim-dap-ui",
    },
    config = function()
      local jdtls = require("jdtls")

      -- Create command to toggle JDTLS
      vim.api.nvim_create_user_command("JdtlsToggle", toggle_jdtls, { desc = "Toggle JDTLS" })

      -- Autostart jdtls for Java files (only when enabled)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          if _G.jdtls_enabled then
            local config = get_jdtls_config()
            jdtls.start_or_attach(config)
          end
        end,
      })

      -- Key mappings for Java-specific features
      vim.api.nvim_create_autocmd("LspAttach", {
        pattern = "*.java",
        callback = function(event)
          local opts = { buffer = event.buf, noremap = true, silent = true }

          -- Use vim.lsp.buf functions instead of jdtls specific ones

          -- Organize imports (jdtls specific)
          vim.keymap.set("n", "<leader>co", function()
            jdtls.organize_imports()
          end, opts)

          -- Extract variables/methods (jdtls specific)
          vim.keymap.set("n", "<leader>cv", function()
            jdtls.extract_variable()
          end, opts)
          vim.keymap.set("v", "<leader>cv", function()
            jdtls.extract_variable(true)
          end, opts)
          vim.keymap.set("n", "<leader>cm", function()
            jdtls.extract_method()
          end, opts)
          vim.keymap.set("v", "<leader>cm", function()
            jdtls.extract_method(true)
          end, opts)

          -- Go to test/implementation (jdtls specific)
          vim.keymap.set("n", "<leader>gt", function()
            jdtls.go_to_test()
          end, opts)
          -- vim.keymap.set("n", "<leader>i", function()
          --   jdtls.go_to_implementation()
          -- end, opts)

          -- Super implementation (jdtls specific)
          vim.keymap.set("n", "<leader>u", function()
            jdtls.super_implementation()
          end, opts)

          -- -- Jdtls commands
          -- vim.keymap.set("n", "<leader>jc", function()
          --   jdtls.compile()
          -- end, opts)
          -- vim.keymap.set("n", "<leader>jr", function()
          --   jdtls.update_project_config()
          -- end, opts)
        end,
      })
    end,
  },

  -- nvim-dap: Debug Adapter Protocol
  {
    "mfussenegger/nvim-dap",
    ft = "java",
    config = function()
      local dap = require("dap")

      -- _G.dap_status = function()
      --   if dap.session() then
      --     return " 🐞 DAP"
      --   end
      --   return ""
      -- end

      -- vim.o.statusline = "%f%m%r%h%w %= %{v:lua.dap_status()} %y %l:%c"

      -- 配置终端行为
      dap.defaults.fallback.terminal_win_cmd = function()
        -- 在新垂直分割窗口中打开终端
        return "botright 15new term://zsh"
      end

      vim.fn.sign_define("DapBreakpoint", {
        text = "",
        texthl = "DiagnosticSignError",
      })

      vim.fn.sign_define("DapStopped", {
        text = "",
        texthl = "DiagnosticSignWarn",
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()
          vim.defer_fn(function()
            if dap.configurations.java then
              for _, config in ipairs(dap.configurations.java) do
                config.console = "integratedTerminal"
              end
            end
          end, 1000)
        end,
      })

      -- Java debug configuration
      dap.configurations.java = {
        {
          type = "java",
          request = "launch",
          name = "Launch Current File",
          mainClass = function()
            local path = vim.fn.expand("%:p")
            local classname = vim.fn.fnamemodify(path, ":t:r")
            return classname
          end,
          projectName = function()
            return vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
          end,
          cwd = vim.fn.getcwd(),
          console = "integratedTerminal",
          stopOnEntry = false,
          args = "",
        },
        {
          type = "java",
          request = "attach",
          name = "Attach to Remote Debug",
          hostName = "127.0.0.1",
          port = 5005,
        },
      }

      -- Key mappings for debugging
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
      -- vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run Last" })
      vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "Terminate" })

      -- Debug UI controls
      vim.keymap.set("n", "<leader>ds", function()
        require("dapui").toggle()
      end, { desc = "Toggle Debug UI" })
    end,
  },

  -- nvim-dap-ui: Debug UI
  {
    "rcarriga/nvim-dap-ui",
    ft = "java",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-dap",
    },
    config = function()
      local dapui = require("dapui")

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.5 },
              { id = "breakpoints", size = 0.5 },
              -- { id = "stacks", size = 0.25 },
              -- { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              -- { id = "repl", size = 0.2 },
              { id = "console", size = 1 },
            },
            size = 15,
            position = "bottom",
          },
          {
            elements = {
              { id = "repl", size = 1 },
            },
            size = 1,
            position = "top",
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "single",
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil,
          max_value_lines = 100,
        },
      })

      vim.keymap.set("n", "<leader>dh", function()
        require("dap.ui.widgets").hover()
      end)

      -- Auto open/close dapui
      local dap = require("dap")
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        -- dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        -- dapui.close()
      end
    end,
  },

  -- nvim-nio: Required for dap-ui
  {
    "nvim-neotest/nvim-nio",
    ft = "java",
  },
}
