if has("nvim")
  lua require("kkslider.main").init()
else
  echoerr "KKSlider: Requires Neovim for it's Lua integration and floating window API."
endif
