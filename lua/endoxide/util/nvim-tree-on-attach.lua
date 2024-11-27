--
-- This function has been generated from your
--   view.mappings.list
--   view.mappings.custom_only
--   remove_keymaps
--
-- You should add this function to your configuration and set on_attach = on_attach in the nvim-tree setup call.
local nnoremap = require("endoxide.keymap").nnoremap


local function on_attach(bufnr)
  local api = require('nvim-tree.api')
  -- local tree = require("nvim-tree")

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end


  local tree = api.tree
  local node = api.node
  local fs = api.fs
  local marks = api.marks

  local function open_action()
    local marked_nodes = marks.list()

    -- If no marked nodes open hovered one
    if next(marked_nodes) == nil then
      node.open.edit()
      return
    end

    for _, marked_node in ipairs(marked_nodes) do
      node.open.drop(marked_node)
      marks.clear()
    end
  end


  nnoremap('<C-]>', tree.change_root_to_node,          opts('CD'))
  nnoremap('<C-e>', node.open.replace_tree_buffer,     opts('Open: In Place'))
  nnoremap('<C-k>', node.show_info_popup,              opts('Info'))
  nnoremap('<C-r>', fs.rename_sub,                     opts('Rename: Omit Filename'))
  nnoremap('<C-t>', node.open.tab,                     opts('Open: New Tab'))
  nnoremap('<C-v>', node.open.vertical,                opts('Open: Vertical Split'))
  nnoremap('<C-x>', node.open.horizontal,              opts('Open: Horizontal Split'))
  nnoremap('<BS>',  node.navigate.parent_close,        opts('Close Directory'))
  nnoremap('<CR>',  open_action,                    opts('Open'))
  nnoremap('<Tab>', node.open.preview,                 opts('Open Preview'))
  nnoremap('>',     node.navigate.sibling.next,        opts('Next Sibling'))
  nnoremap('<',     node.navigate.sibling.prev,        opts('Previous Sibling'))
  nnoremap('.',     node.run.cmd,                      opts('Run Command'))
  nnoremap('-',     tree.change_root_to_parent,        opts('Up'))
  nnoremap('a',     fs.create,                         opts('Create'))
  nnoremap('bd',    api.marks.bulk.delete,                 opts('Delete Bookmarked'))
  nnoremap('bmv',   api.marks.bulk.move,                   opts('Move Bookmarked'))
  nnoremap('B',     tree.toggle_no_buffer_filter,      opts('Toggle Filter: No Buffer'))
  nnoremap('c',     fs.copy.node,                      opts('Copy'))
  nnoremap('C',     tree.toggle_git_clean_filter,      opts('Toggle Filter: Git Clean'))
  nnoremap('[c',    node.navigate.git.prev,            opts('Prev Git'))
  nnoremap(']c',    node.navigate.git.next,            opts('Next Git'))
  nnoremap('d',     fs.remove,                         opts('Delete'))
  nnoremap('D',     fs.trash,                          opts('Trash'))
  nnoremap('E',     tree.expand_all,                   opts('Expand All'))
  nnoremap('e',     fs.rename_basename,                opts('Rename: Basename'))
  nnoremap(']e',    node.navigate.diagnostics.next,    opts('Next Diagnostic'))
  nnoremap('[e',    node.navigate.diagnostics.prev,    opts('Prev Diagnostic'))
  nnoremap('F',     api.live_filter.clear,                 opts('Clean Filter'))
  nnoremap('f',     api.live_filter.start,                 opts('Filter'))
  nnoremap('g?',    tree.toggle_help,                  opts('Help'))
  nnoremap('gy',    fs.copy.absolute_path,             opts('Copy Absolute Path'))
  nnoremap('h', node.navigate.parent_close, opts('Close Directory'))
  nnoremap('H',     tree.toggle_hidden_filter,         opts('Toggle Filter: Dotfiles'))
  nnoremap('I',     tree.toggle_gitignore_filter,      opts('Toggle Filter: Git Ignore'))
  nnoremap('J',     node.navigate.sibling.last,        opts('Last Sibling'))
  nnoremap('K',     node.navigate.sibling.first,       opts('First Sibling'))
  nnoremap('l', open_action, opts('Open'))
  nnoremap('o',     open_action,                    opts('Open'))
  nnoremap('O',     node.open.no_window_picker,        opts('Open: No Window Picker'))
  nnoremap('p',     fs.paste,                          opts('Paste'))
  nnoremap('P',     node.navigate.parent,              opts('Parent Directory'))
  nnoremap('q',     tree.close,                        opts('Close'))
  nnoremap('r',     fs.rename,                         opts('Rename'))
  nnoremap('R',     tree.reload,                       opts('Refresh'))
  nnoremap('s',     api.marks.toggle,                      opts('Toggle Bookmark'))
  nnoremap('S',     api.marks.clear,                      opts('Clear All Bookmarks'))
  -- nnoremap('S',     tree.search_node,                  opts('Search'))
  nnoremap('U',     tree.toggle_custom_filter,         opts('Toggle Filter: Hidden'))
  nnoremap('v', node.open.vertical, opts('Open: Vertical Split'))
  nnoremap('W',     tree.collapse_all,                 opts('Collapse'))
  nnoremap('x',     fs.cut,                            opts('Cut'))
  nnoremap('y',     fs.copy.filename,                  opts('Copy Name'))
  nnoremap('Y',     fs.copy.relative_path,             opts('Copy Relative Path'))
  nnoremap('z',     node.run.system,                   opts('Run System'))
  nnoremap('<2-LeftMouse>',  node.open.edit,           opts('Open'))
  nnoremap('<2-RightMouse>', tree.change_root_to_node, opts('CD'))
end

return on_attach
