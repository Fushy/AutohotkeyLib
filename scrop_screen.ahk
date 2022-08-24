SetBatchLines, -1

init_gui_scrop(screenshot_x0, screenshot_y0, screenshot_x1, screenshot_y1, start_x0, start_y0, transparent, size_ratio:=1) {
    global
    img_width := (screenshot_x1 - screenshot_x0) * size_ratio
    img_height := (screenshot_y1 - screenshot_y0) * size_ratio
    Gui +LastFound +AlwaysOnTop
    Gui, Color, FFFFFF
    WinSet, Transcolor, FFFFFF
    WinSet, Transparent, %transparent%
    WinSet, ExStyle, ^0x20 ;Click trough (WS_EX_TRANSPARENT = 0x00000020)
    Gui -Caption
    Gui, Show, x%start_x0% y%start_y0% NoActivate
    WinMove, ahk_class AutoHotkeyGUI,,,, img_width - 5, img_height - 5	; taille de la fenetre
    Gui, Add, Picture, x0 y0 w%img_width% h%img_height% vImg
}

scrop(screenshot_x0, screenshot_y0, screenshot_x1, screenshot_y1, start_x0, start_y0, size_ratio:=1) {
    ; runwait, screenshots.pyw %screenshot_x0% %screenshot_y0% %screenshot_x1% %screenshot_y1%
    runwait, screenshots.pyw
    GuiControl,, Img, out.png
    Gui, Show, NoActivate
}

unscrop() {
    Gui, Cancel
    Gui, Hide
}

screenshot(screenshot_x0, screenshot_y0, screenshot_x1, screenshot_y1) {
    commands=python "aaa" "aa"
    Run, cmd /c %commands%
    return
}