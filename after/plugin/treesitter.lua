require('nvim-treesitter').setup {
    -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
    install_dir = vim.fn.stdpath('data') .. '/site',
}
-- A list of parser names, or "all" (the five listed parsers should always be installed)
require('nvim-treesitter').install { "javascript", "typescript", "python", "c", "lua", "vim", "vimdoc", "query", "rust", "templ" }

require 'treesitter-context'.setup {
    enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
    multiwindow = false,      -- Enable multiwindow support.
    max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to show for a single context
    trim_scope = 'outer',     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = 'cursor',          -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20,     -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
}

-- add templ support
vim.filetype.add({
    extension = {
        templ = "templ",
    },
})

-- script from https://github.com/nvim-treesitter/nvim-treesitter/discussions/8546#discussioncomment-16411757
-- thx to https://github.com/shushtain
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "*" },
    callback = function(args)
        local ft = vim.bo[args.buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)

        if lang ~= nil then
            if not vim.treesitter.language.add(lang) then
                local available = vim.g.ts_available
                    or require("nvim-treesitter").get_available()
                if not vim.g.ts_available then
                    vim.g.ts_available = available
                end
                if vim.tbl_contains(available, lang) then
                    require("nvim-treesitter").install(lang)
                end
            end

            if vim.treesitter.language.add(lang) then
                vim.treesitter.start(args.buf, lang)
                vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                -- vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                -- vim.wo[0][0].foldmethod = "expr"
            end
        end
    end,
})
