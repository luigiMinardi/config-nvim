vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Making :m amazing
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Don't move the cursor while using J
vim.keymap.set("n", "J", "mzJ`z")

-- Don't move the cursor while jumping up and down the page
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Don't move the cursor while searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Making able to paste without loosing the yank | greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Beign able to yank to your clipboard | next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Don't yank the deletion
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Don't yank the selection
vim.keymap.set({ "n", "v" }, "<leader>ci", [["_ci]])

-- Replace current word globally
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Turn file into executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>-x", "<cmd>!chmod -x %<CR>", { silent = true })

-- Remove NetrwRefresh <C-l> bind and dont rebind it since we dont use it

vim.api.nvim_create_autocmd("FileType", {
    pattern = 'netrw',
    callback = function()
        vim.schedule(function()
            vim.keymap.set("n", "<C-l>", function() end, {
                buffer = true
            })
            vim.keymap.del("n", "<C-l>", {
                buffer = true
            })
            --[[ Rebinding if needed
            vim.keymap.set("n", "<C-9>", "<Plug>NetrwRefresh", {
                buffer = true,
                silent = true,
                noremap = true,
                -- unique = true
            })
            ]] --
        end)
    end
})


-- Modify Goto Definition for TS/JS to be able to jump correctly to import function
local function ts_js_smart_definition()
    local params = vim.lsp.util.make_position_params(0, "utf-8")

    vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result)
        if err then
            vim.notify('LSP error: ' .. err.message, vim.log.levels.ERROR)
            return
        end

        if not result or vim.tbl_isempty(result) then
            vim.notify('No definition found', vim.log.levels.INFO)
            return
        end

        -- Jump to the first result
        local target = type(result) == 'table' and result[1] or result
        vim.lsp.util.show_document(target, 'utf-8', { focus = true })

        -- If we land on an import line, jump again
        local current_line = vim.api.nvim_get_current_line()
        if current_line:match('^%s*import') then
            vim.defer_fn(function()
                vim.lsp.buf.definition({ reuse_win = true })
            end, 50)
        end
    end)
end
-- Making the remap so that we use the modified Goto definition
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    callback = function()
        vim.keymap.set('n', 'gd', ts_js_smart_definition, { buffer = true, desc = '[TS/JS] Smart [G]oto [D]efinition' })
    end,
})
