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
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Don't yank the deletion
vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

-- Replace current word globally
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

-- Turn file into executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })
vim.keymap.set("n", "<leader>-x", "<cmd>!chmod -x %<CR>", { silent = true })

