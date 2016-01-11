-- Override session menu
defmenu("sessionmenu", {
    menuentry("Restart",        "ioncore.restart()"),
    menuentry("Exit",           "ioncore.shutdown()"),
})
