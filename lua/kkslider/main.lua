local _0_0 = nil
do
  local name_0_ = "kkslider.main"
  local loaded_0_ = package.loaded[name_0_]
  local module_0_ = nil
  if ("table" == type(loaded_0_)) then
    module_0_ = loaded_0_
  else
    module_0_ = {}
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = (module_0_["aniseed/locals"] or {})
  module_0_["aniseed/local-fns"] = (module_0_["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _1_(...)
  _0_0["aniseed/local-fns"] = {require = {a = "kkslider.aniseed.core", nvim = "kkslider.aniseed.nvim", str = "kkslider.aniseed.string"}}
  return {require("kkslider.aniseed.core"), require("kkslider.aniseed.nvim"), require("kkslider.aniseed.string")}
end
local _2_ = _1_(...)
local a = _2_[1]
local nvim = _2_[2]
local str = _2_[3]
do local _ = ({nil, _0_0, {{}, nil}})[2] end
local state = nil
do
  local v_0_ = nil
  do
    local v_0_0 = (_0_0.state or {current = nil, slides = {}})
    _0_0["state"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["state"] = v_0_
  state = v_0_
end
local echoerr = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function echoerr0(...)
      return nvim.err_write((str.join(" ", {"KKSlider:", ...}) .. "\n"))
    end
    v_0_0 = echoerr0
    _0_0["echoerr"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["echoerr"] = v_0_
  echoerr = v_0_
end
local upsert_buf = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function upsert_buf0()
      nvim.ex.edit_(("/tmp/kkslider-" .. nvim.fn.getpid() .. ".adoc"))
      nvim.ex.setlocal("buftype=nofile")
      nvim.ex.setlocal("bufhidden=hide")
      nvim.ex.setlocal("noswapfile")
      nvim.ex.setlocal("nobuflisted")
      nvim.buf_set_keymap(0, "n", "<left>", ":lua require('kkslider.main')['prev-slide']()<cr>", {})
      nvim.buf_set_keymap(0, "n", "<right>", ":lua require('kkslider.main')['next-slide']()<cr>", {})
      return nvim.win_get_buf(0)
    end
    v_0_0 = upsert_buf0
    _0_0["upsert-buf"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["upsert-buf"] = v_0_
  upsert_buf = v_0_
end
local display = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function display0(lines)
      return nvim.buf_set_lines(upsert_buf(), 0, -1, false, lines)
    end
    v_0_0 = display0
    _0_0["display"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["display"] = v_0_
  display = v_0_
end
local parse_slides = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function parse_slides0(src)
      local current = nil
      local acc = {}
      local function _3_(line)
        if line:find("^= ") then
          if current then
            table.insert(acc, current)
          end
          current = {line}
          return nil
        else
          return table.insert(current, line)
        end
      end
      a["run!"](_3_, str.split(src, "\n"))
      table.insert(acc, current)
      return acc
    end
    v_0_0 = parse_slides0
    _0_0["parse-slides"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["parse-slides"] = v_0_
  parse_slides = v_0_
end
local update_slide = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function update_slide0(f)
      if not state.current then
        a.assoc(state, "current", 1)
      else
        a.update(state, "current", f)
      end
      do
        local n = state.current
        local min = 1
        local max = a.count(state.slides)
        if (n > max) then
          a.assoc(state, "current", max)
        elseif (n < min) then
          a.assoc(state, "current", min)
        end
      end
      local _4_0 = a["get-in"](state, {"slides", state.current})
      if _4_0 then
        return display(_4_0)
      else
        return _4_0
      end
    end
    v_0_0 = update_slide0
    _0_0["update-slide"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["update-slide"] = v_0_
  update_slide = v_0_
end
local next_slide = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function next_slide0()
      return update_slide(a.inc)
    end
    v_0_0 = next_slide0
    _0_0["next-slide"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["next-slide"] = v_0_
  next_slide = v_0_
end
local prev_slide = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function prev_slide0()
      return update_slide(a.dec)
    end
    v_0_0 = prev_slide0
    _0_0["prev-slide"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["prev-slide"] = v_0_
  prev_slide = v_0_
end
local open_slides = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function open_slides0(file)
      local src = a.slurp(file)
      if src then
        a.assoc(state, "slides", parse_slides(src))
        return next_slide()
      else
        return echoerr("Couldn't load", file)
      end
    end
    v_0_0 = open_slides0
    _0_0["open-slides"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["open-slides"] = v_0_
  open_slides = v_0_
end
local init = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function init0()
      return nvim.ex.command_("-nargs=1", "-complete=file", "KKSlider", "lua", "require('kkslider.main')['open-slides'](<q-args>)")
    end
    v_0_0 = init0
    _0_0["init"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["init"] = v_0_
  init = v_0_
end
return nil