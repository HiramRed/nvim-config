local function my_on_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.map.on_attach.default(bufnr)

    -- custom mappings
    -- vim.keymap.set("n", "P", api.fs.paste(), opts("Paste"))
    -- vim.keymap.set("n", "p", api.node.navigate.parent(), opts("Parent"))
    -- vim.keymap.set("n", "?",     api.tree.toggle_help,                  opts("Help"))
end

return {
    -- nvim-tree - file tree
    { "kyazdani42/nvim-web-devicons" },
    {
      "kyazdani42/nvim-tree.lua",
      lazy = false,
      requires = "kyazdani42/nvim-web-devicons",
      -- enabled = not vim.g.vscode,
      enabled = false,
      config = function(_, opts)
        -- NvimTree keymap
        require('nvim-tree').setup(opts)
        vim.keymap.set('n', '<leader>e', ':NvimTreeOpen<cr>', { silent = true })
        vim.keymap.set('n', '<leader>ss', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })
      end,
      opts = {
          auto_reload_on_write = true,
          disable_netrw = false,
          hijack_cursor = false,
          hijack_netrw = true,
          hijack_unnamed_buffer_when_opening = false,
          -- ignore_buffer_on_setup = false,
          -- open_on_setup = false,
          -- open_on_setup_file = false,
          open_on_tab = false,
          on_attach = my_on_attach,
          sort_by = "name",
          update_cwd = false,
          view = {
            width = 40,
            -- height = 30,
            -- hide_root_folder = false,
            side = "left",
            preserve_window_proportions = false,
            number = false,
            relativenumber = false,
            signcolumn = "yes",
          },
          update_focused_file = {
            enable = false,
            update_cwd = false,
            ignore_list = {},
          },
          -- ignore_ft_on_setup = {},
          -- system_open = {
          --   cmd = "",
          --   args = {},
          -- },
          diagnostics = {
            enable = true,
            show_on_dirs = false,
            icons = {
              hint = "",
              info = "",
              warning = "",
              error = "",
            },
          },
          filters = {
            dotfiles = false,
            custom = {},
            exclude = {},
          },
          git = {
            enable = true,
            ignore = false,
            timeout = 400,
          },
          actions = {
            use_system_clipboard = true,
            change_dir = {
              enable = true,
              global = false,
              restrict_above_cwd = false,
            },
            open_file = {
              quit_on_open = false,
              resize_window = false,
              window_picker = {
                enable = false,
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                exclude = {
                  filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                  buftype = { "nofile", "terminal", "help" },
                },
              },
            },
          },
          trash = {
            cmd = "trash",
            require_confirm = true,
          },
          log = {
            enable = false,
            truncate = false,
            types = {
              all = false,
              config = false,
              copy_paste = false,
              diagnostics = false,
              git = false,
              profile = false,
            },
          },
      },
    },
}
