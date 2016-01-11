--Main config file

META="Mod4+"
ALTMETA=""

XTERM="xterm"

--Basic settings
ioncore.set {
  -- Opaque resize
  opaque_resize=false,

  -- Movement commands warp the pointer to the frames instead of just changing
  -- focus.
  warp=true,

  -- Automatically save layout on restart and exit
  autosave_layout=false,

  -- Mouse focu mode; set to "sloppy" if you want the focus to follow the mouse,
  -- and to "disabled" otherwise.
  mousefocus="disabled",
}

-- Load configuration of the Notion 'core'. Most bindings are here.
dopath("cfg_notioncore")
dopath("cfg_notioncore_custom")

-- Load some kludges to make apps behave better.
dopath("cfg_kludges")

-- Define some layouts.
dopath("cfg_layouts")

-- Load some modules. Bindings and other configuration specific to modules
-- are in the files cfg_modulename.lua.
dopath("mod_query")
dopath("mod_menu")
dopath("mod_tiling")
dopath("mod_statusbar")
dopath("mod_dock")
dopath("mod_sp")
dopath("mod_notionflux")
dopath("mod_xrandr")
