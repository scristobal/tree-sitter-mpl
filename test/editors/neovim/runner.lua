local runtime = assert(vim.env.MPL_NVIM_RUNTIME, "MPL_NVIM_RUNTIME is not set")
local fixtures = assert(vim.env.MPL_NVIM_FIXTURES, "MPL_NVIM_FIXTURES is not set")

vim.opt.runtimepath:prepend(runtime)

local parser_files = vim.api.nvim_get_runtime_file("parser/mpl.*", false)
assert(#parser_files == 1, "expected exactly one MPL parser in the test runtime")
assert(vim.treesitter.language.add("mpl"), "failed to load the MPL parser")
assert(vim.treesitter.query.get("mpl", "highlights"), "failed to load the MPL highlight query")

local function assertion(line)
  local caret = line:find("^", 1, true)
  if caret and not line:sub(1, caret - 1):find("[A-Za-z0-9]") then
    local finish = caret
    while line:sub(finish + 1, finish + 1) == "^" do
      finish = finish + 1
    end
    local expected = line:sub(finish + 1):match("^%s*!?@?([%w_.-]+)")
    return caret - 1, finish - caret + 1, expected
  end

  local arrow = line:find("<-", 1, true)
  if arrow and not line:sub(1, arrow - 1):find("[A-Za-z0-9]") then
    local expected = line:sub(arrow + 2):match("^%s*!?@?([%w_.-]+)")
    return 0, 1, expected
  end
end

local function capture_at(buf, row, col)
  local captures = vim.treesitter.get_captures_at_pos(buf, row, col)
  local capture = captures[#captures]
  return capture and capture.capture or nil
end

local files = vim.fn.globpath(fixtures, "*.mpl", false, true)
table.sort(files)
assert(#files > 0, "no Neovim highlight fixtures found")

local checks = 0
local failures = {}

for _, path in ipairs(files) do
  local lines = vim.fn.readfile(path)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].filetype = "mpl"

  vim.treesitter.start(buf, "mpl")
  vim.treesitter.get_parser(buf, "mpl"):parse(true)
  vim.cmd.redraw()

  local base
  for index, line in ipairs(lines) do
    local col, width, expected = assertion(line)
    if expected then
      assert(base, string.format("%s:%d: assertion has no source line", path, index))
      local source = lines[base]
      for offset = 0, width - 1 do
        local target = col + offset
        local byte = source:byte(target + 1)
        if byte and not string.char(byte):match("%s") then
          checks = checks + 1
          local actual = capture_at(buf, base - 1, target)
          if actual ~= expected then
            failures[#failures + 1] = string.format(
              "%s:%d:%d: expected @%s but got %s",
              path,
              base,
              target + 1,
              expected,
              actual and ("@" .. actual) or "<unhighlighted>"
            )
          end
        end
      end
    elseif line:match("%S") then
      base = index
    end
  end

  vim.treesitter.stop(buf)
  vim.api.nvim_buf_delete(buf, { force = true })
end

if #failures > 0 then
  error(table.concat(failures, "\n"), 0)
end

print(string.format("Neovim highlight check succeeded (%d assertions)", checks))
