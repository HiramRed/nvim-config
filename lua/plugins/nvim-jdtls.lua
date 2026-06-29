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

local function write_launch_json(filepath, configurations)
  local vscode_dir = vim.fn.getcwd() .. "/.vscode"
  if vim.fn.isdirectory(vscode_dir) == 0 then
    vim.fn.mkdir(vscode_dir, "p")
  end
  local launch_json = {
    version = "0.2.0",
    configurations = configurations,
  }
  local json_str = vim.json.encode(launch_json, { indent = "  " })
  vim.fn.writefile(vim.split(json_str, "\n"), filepath)
end

local function generate_launch_json()
  local clients = vim.lsp.get_active_clients({ name = "jdtls" })
  if #clients == 0 then
    vim.notify("JDTLS is not running. Enable it with :JdtlsToggle first.", vim.log.levels.ERROR)
    return
  end

  local params = {
    command = "vscode.java.resolveMainClass",
  }
  clients[1]:request("workspace/executeCommand", params, function(err, mainclasses)
    if err then
      vim.notify("Failed to resolve main classes: " .. (err.message or vim.inspect(err)), vim.log.levels.ERROR)
      return
    end
    if not mainclasses or #mainclasses == 0 then
      vim.notify("No executable main classes found in this project.", vim.log.levels.WARN)
      return
    end

    local function to_config(mc)
      return {
        type = "java",
        request = "launch",
        name = mc.mainClass,
        mainClass = mc.mainClass,
        projectName = mc.projectName,
      }
    end

    -- Build items: simple strings for labels, use index to look up mainclasses
    -- "ALL" at index 0 means sync all
    local items = { "[All] Add all (" .. #mainclasses .. " classes)" }
    for _, mc in ipairs(mainclasses) do
      table.insert(items, string.format("%-10s %s", mc.projectName or "", mc.mainClass))
    end

    vim.ui.select(items, {
      prompt = "Select main class to add to launch.json:",
    }, function(choice, idx)
      if not choice or not idx then
        return -- cancelled
      end

      local filepath = vim.fn.getcwd() .. "/.vscode/launch.json"
      local existing_configs = {}

      if vim.fn.filereadable(filepath) == 1 then
        local ok, existing = pcall(vim.fn.json_decode, vim.fn.readfile(filepath))
        if ok and existing and existing.configurations then
          existing_configs = existing.configurations
        end
      end

      if idx == 1 then
        -- [All]: sync all jdtls configs, preserve manual entries
        local jdtls_mc = {}
        local new_configs = {}
        for _, mc in ipairs(mainclasses) do
          jdtls_mc[mc.mainClass] = true
          table.insert(new_configs, to_config(mc))
        end
        local preserved = 0
        for _, cfg in ipairs(existing_configs) do
          if cfg.mainClass and not jdtls_mc[cfg.mainClass] then
            table.insert(new_configs, cfg)
            preserved = preserved + 1
          end
        end
        write_launch_json(filepath, new_configs)
        vim.notify(string.format("Synced %d main class(es)%s to .vscode/launch.json",
          #mainclasses, preserved > 0 and string.format(" (+ %d preserved)", preserved) or ""), vim.log.levels.INFO)
      else
        -- Single class: idx 2..N maps to mainclasses[1..]
        local mc = mainclasses[idx - 1]
        local new_config = to_config(mc)
        local found = false
        for i, cfg in ipairs(existing_configs) do
          if cfg.mainClass and cfg.mainClass == mc.mainClass then
            existing_configs[i] = new_config
            found = true
            break
          end
        end
        if not found then
          table.insert(existing_configs, new_config)
          vim.notify(string.format("Added %s to .vscode/launch.json", mc.mainClass), vim.log.levels.INFO)
        else
          vim.notify(string.format("Updated %s in .vscode/launch.json", mc.mainClass), vim.log.levels.INFO)
        end
        write_launch_json(filepath, existing_configs)
      end
    end)
  end)
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
      vim.api.nvim_create_user_command("JdtGenLaunchJson", generate_launch_json, { desc = "Generate .vscode/launch.json from main classes" })

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

          -- Generate .vscode/launch.json from discovered main classes
          vim.keymap.set("n", "<leader>dg", generate_launch_json, vim.tbl_extend("force", opts, { desc = "Generate launch.json" }))

          -- -- Jdtls commands
          -- vim.keymap.set("n", "<leader>jc", function()
          --   jdtls.compile()
          -- end, opts)
          -- vim.keymap.set("n", "<leader>jr", function()
          --   jdtls.update_project_config()
          -- end, opts)
          --
          vim.keymap.set("n", "gx", function()
            local line = vim.api.nvim_get_current_line()

            local file, row = line:match("([%w_]+%.java):(%d+)")

            if file and row then
              vim.cmd("find " .. file)
              vim.api.nvim_win_set_cursor(0, { tonumber(row), 0 })
            end
          end, { buffer = true })
        end,
      })
    end,
  },
}
