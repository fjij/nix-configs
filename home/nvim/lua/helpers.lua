local Path = require("plenary.path")

helpers = {}

--- Author: https://github.com/b0o/
--- Given a path, return a shortened version of it.
--- @param path string an absolute or relative path
--- @param opts table
--- @return string | table
---
--- The tail of the path (the last n components, where n is the value of
--- opts.tail_count) is kept unshortened.
---
--- Each component in the head of the path (the first components up to the tail)
--- is shortened to opts.short_len characters.
---
--- If opts.head_max is non-zero, the number of components in the head
--- is limited to opts.head_max. Excess components are trimmed from left to right.
--- If opts.head_max is zero, all components are kept.
---
--- opts is a table with the following keys:
---   short_len: int - the number of chars to shorten each head component to (default: 1)
---   tail_count: int - the number of tail components to keep unshortened (default: 2)
---   head_max: int - the max number of components to keep, including the tail
---     components. If 0, keep all components. Excess components are
---     trimmed starting from the head. (default: 0)
---   relative: bool - if true, make the path relative to the current working
---     directory (default: true)
---   return_table: bool - if true, return a table of { head, tail } instead
---     of a string (default: false)
---
--- Example: get_short_path_fancy('foo/bar/qux/baz.txt', {
---   short_len = 1,
---   tail_count = 2,
---   head_max = 0,
--- }) -> 'f/b/qux/baz.txt'
---
--- Example: get_short_path_fancy('foo/bar/qux/baz.txt', {
---   short_len = 2,
---   tail_count = 2,
---   head_max = 1,
--- }) -> 'ba/baz.txt'
---
function helpers.shorten_path(path, opts)
  opts = opts or {}
  local short_len = opts.short_len or 1
  local tail_count = opts.tail_count or 2
  local head_max = opts.head_max or 0
  local relative = opts.relative == nil or opts.relative
  local return_table = opts.return_table or false
  if relative then
    path = vim.fn.fnamemodify(path, ":.")
  end
  local components = vim.split(path, Path.path.sep)
  if #components == 1 then
    if return_table then
      return { nil, path }
    end
    return path
  end
  local tail = { unpack(components, #components - tail_count + 1) }
  local head = { unpack(components, 1, #components - tail_count) }
  if head_max > 0 and #head > head_max then
    head = { unpack(head, #head - head_max + 1) }
  end
  local result = {
    #head > 0 and Path.new(unpack(head)):shorten(short_len, {}) or nil,
    table.concat(tail, Path.path.sep),
  }
  if return_table then
    return result
  end
  return table.concat(result, Path.path.sep)
end

--- Author: https://github.com/b0o/
--- Given a path, return a shortened version of it, with additional styling.
--- @param path string an absolute or relative path
--- @param opts table see below
--- @return table
---
--- The arguments are the same as for shorten_path, with the following additional options:
---   head_style: table - a table of highlight groups to apply to the head (see
---      :help incline-render) (default: nil)
---   tail_style: table - a table of highlight groups to apply to the tail (default: nil)
---
--- Example: get_short_path_fancy('foo/bar/qux/baz.txt', {
---   short_len = 1,
---   tail_count = 2,
---   head_max = 0,
---   head_style = { guibg = '#555555' },
--- }) -> { 'f/b/', guibg = '#555555' }, { 'qux/baz.txt' }
---
function helpers.shorten_path_styled(path, opts)
  opts = opts or {}
  local head_style = opts.head_style or {}
  local tail_style = opts.tail_style or {}
  local result = helpers.shorten_path(
    path,
    vim.tbl_extend("force", opts, {
      return_table = true,
    })
  )
  return {
    result[1] and vim.list_extend(head_style, { result[1], "/" }) or "",
    vim.list_extend(tail_style, { result[2] }),
  }
end
--- </Quote>

return helpers
