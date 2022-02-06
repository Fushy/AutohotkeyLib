; Should work with all current AHK versions/builds
#NoEnv
SetBatchLines, -1 ; For speed in general
SetWinDelay, -1   ; For speed of WinMove
#Include <Image>

selection_click()
{
	; !^LButton::
	SetBatchLines, -1
	BW := 1           ; Border width (and height) in pixels
	BC := "Blue"       ; Border color
	; ______________________________________________________________________________________________________________________
	FirstCall := True
	CoordMode, Mouse, Screen
	Gui, -Caption +ToolWindow +LastFound +AlwaysOnTop
	Gui, Color, %BC%
	MouseGetPos, OriginX, OriginY
	while (GetKeyState("alt", P) || GetKeyState("LButton", P)) {
		MouseGetPos, X2, Y2
		; Has the mouse moved?
		If (XO = X2) And (YO = Y2)
		  ; Return
		Gui, +LastFound
		XO := X2, YO := Y2
		; Allow dragging to the left of the click point.
		If (X2 < OriginX)
		  X1 := X2, X2 := OriginX
		Else
		  X1 := OriginX
		; Allow dragging above the click point.
		If (Y2 < OriginY)
		  Y1 := Y2, Y2 := OriginY
		Else
		  Y1 := OriginY
		; Draw the rectangle
		W1 := X2 - X1, H1 := Y2 - Y1
		W2 := W1 - BW, H2 := H1 - BW
		WinSet, Region, 0-0 %W1%-0 %W1%-%H1% 0-%H1% 0-0  %BW%-%BW% %W2%-%BW% %W2%-%H2% %BW%-%H2% %BW%-%BW%
		If (FirstCall) {
		  Gui, Show, NA x%X1% y%Y1% w%W1% h%H1%
		  FirstCall := False
		}
		WinMove, , , X1, Y1, W1, H1
	}
   FirstCall := True
   Gui, Cancel
   ToolTip
   ; MsgBox, 0, Coordinates, X = %X1%  -  Y = %Y1%  -  W = %W1%  -  H = %H1%
   X2 := X1 + W1
   Y2 := Y1 + H1
   ; MsgBox, 0, Coordinates, X1 = %X1%  -  Y1 = %Y1%  -  W = %W1%  -  H = %H1%
   ; MsgBox, 0, Coordinates, X1 = %X1%    Y1 = %Y1%    X2 = %X2%    Y2 = %Y2%
   return [X1, Y1, X2, Y2]
}

; creates a click-and-drag selection box to specify an area
selection_getCoords() {
	;Mask Screen
	Gui, Color, FFFFFF
	Gui +LastFound
	WinSet, Transparent, 100
	Gui, -Caption 
	Gui, +AlwaysOnTop
	Gui, Show, x0 y0 h%A_ScreenHeight% w%A_ScreenWidth%,"AutoHotkeySnapshotApp"  
	
	;Drag Mouse
	CoordMode, Mouse, Screen
	CoordMode, Tooltip, Screen
	WinGet, hw_frame_m,ID,"AutoHotkeySnapshotApp"
	hdc_frame_m := DllCall( "GetDC", "uint", hw_frame_m)
	KeyWait, LButton, D 
	MouseGetPos, scan_x_start, scan_y_start 
	Loop
	{
		Sleep, 10   
		KeyIsDown := GetKeyState("LButton")
		if (KeyIsDown = 1)
		{
			MouseGetPos, scan_x, scan_y 
			DllCall( "gdi32.dll\Rectangle", "uint", hdc_frame_m, "int", 0,"int",0,"int", A_ScreenWidth,"int",A_ScreenWidth)
			DllCall( "gdi32.dll\Rectangle", "uint", hdc_frame_m, "int", scan_x_start,"int",scan_y_start,"int", scan_x,"int",scan_y)
		} else {
			break
		}
	}

	;KeyWait, LButton, U
	MouseGetPos, scan_x_end, scan_y_end
	Gui Destroy
	
	if (scan_x_start < scan_x_end)
	{
		x_start := scan_x_start
		x_end := scan_x_end
	} else {
		x_start := scan_x_end
		x_end := scan_x_start
	}
	
	if (scan_y_start < scan_y_end)
	{
		y_start := scan_y_start
		y_end := scan_y_end
	} else {
		y_start := scan_y_end
		y_end := scan_y_start
	}
   return [x_start, x_end, y_start, y_end]
}

