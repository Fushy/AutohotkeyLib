#Include <Gdip>

; On 4k screens ?-?, window spy is not accurate, use ShareX

SetBatchLines, -1
screens_X_min := 
screens_X_max := 
screens_Y_min := 
screens_Y_max := 

SysGet, MonitorCount, MonitorCount
SysGet, MonitorPrimary, MonitorPrimary
Loop, %MonitorCount%
{
    SysGet, MonitorName, MonitorName, %A_Index%
    SysGet, Monitor, Monitor, %A_Index%
    SysGet, MonitorWorkArea, MonitorWorkArea, %A_Index%
	if (!screens_X_min || MonitorLeft < screens_X_min)
		screens_X_min := MonitorLeft
	if (!screens_Y_min || MonitorTop < screens_Y_min)
		screens_Y_min := MonitorTop
	if (!screens_X_max || MonitorRight > screens_X_max)
		screens_X_max := MonitorRight
	if (!screens_Y_max || MonitorBottom > screens_Y_max)
		screens_Y_max := MonitorBottom
	; MsgBox, Monitor:`t#%A_Index%`nName:`t%MonitorName%`nLeft:`t%MonitorLeft% (%MonitorWorkAreaLeft% work)`nTop:`t%MonitorTop% (%MonitorWorkAreaTop% work)`nRight:`t%MonitorRight% (%MonitorWorkAreaRight% work)`nBottom:`t%MonitorBottom% (%MonitorWorkAreaBottom% work)

}
; msgbox % screens_X_min . " " . screens_Y_min . " " . screens_X_max . " " . screens_Y_max
screensWidth := abs(screens_X_min) + abs(screens_X_max)
screensHeight := abs(screens_Y_min) + abs(screens_Y_max)

image_config := {"screens_X_min": screens_X_min, "screens_X_max": screens_X_max, "screens_Y_min": screens_Y_min, "screens_Y_max": screens_Y_max, "screensWidth": screensWidth, "screensHeight": screensHeight, "screen0_X": screen0_X, "screen0_Y": screen0_Y, "screen1_X": screen1_X, "screen1_Y": screen1_Y, "screen2_X": screen2_X, "screen2_Y": screen2_Y}

image_rectangle(x1, y1, x2, y2, title, id:=1, rouge:="ff", vert:="00", bleu:="00", transparence:="ff", thickness:=1, fill:=false) ; ARGB, thickness ; id:=0 ne supprime pas les anciens id qui vallent 0.
{
	; x y en absolute
	global image_config, draw_pattern
	WinGetPos, fenetre_X, fenetre_Y, Width, Height, % title
	if (x2 < x1) {
		tmp := x1
		x1 := x2
		x2 := tmp
		; msgbox x2 < x1
	}
	if (y2 < y1) {
		; msgbox y2 < y1
		tmp := y1
		y1 := y2
		y2 := tmp
	}
	; if (!winactive(title)) {
		; return
	; }
	; screens_X_min := image_config["screens_X_min"]
	; screens_Y_min := image_config["screens_Y_min"]
	image_config["screensWidth"] := Width
	image_config["screensHeight"] := Height
	screensWidth := Width
	screensHeight := Height
	
	color = 0x%transparence%%rouge%%vert%%bleu%
	x1 -= fenetre_X
	x2 -= fenetre_X
	y1 -= fenetre_Y
	y2 -= fenetre_Y
	if (fenetre_X == image_config["fenetre_X"]) && (fenetre_Y == image_config["fenetre_Y"]) {
		for id, pen in draw_pattern {
			if (x1 == pen[2] && y1 == pen[3] && (x2-x1) == pen[4] && (y2-y1) == pen[5] && X == pen[6] && Y == pen[7]) {
				return
			}
			if (id == 0) {
				for id0, pen0 in pen {
					if (x1 == pen0[2] && y1 == pen0[3] && (x2-x1) == pen0[4] && (y2-y1) == pen0[5] && X == pen0[6] && Y == pen0[7]) {
						return
					}
				}
			}
		}
	}
	; pause
	if (!draw_pattern.Count()) {
		if (!pToken := Gdip_Startup()) {
			MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
			msgbox exit
			ExitApp
		}
		Gui, 1: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs
		Gui, 1: Show, NA
		draw_pattern := {0:[]}
		hwn := WinExist()
		hbm := CreateDIBSection(screensWidth, screensHeight)
		hdc := CreateCompatibleDC()
		obm := SelectObject(hdc, hbm)
		G := Gdip_GraphicsFromHDC(hdc)
		Gdip_SetSmoothingMode(G, 4) ; 0 <= x <= 5
		if fill
			pPen := Gdip_BrushCreateSolid(color) ; fill
		else
			pPen := Gdip_CreatePen(color, thickness)
		image_config["hwn"] := hwn
		image_config["hbm"] := hbm
		image_config["obm"] := obm
		image_config["hdc"] := hdc
		image_config["G"] := G
	}
	else {
		if (id != 0) {
			image_delete(id)
		}
		hwn := image_config["hwn"]
		hbm := image_config["hbm"]
		obm := image_config["obm"]
		hdc := image_config["hdc"]
		G := image_config["G"]
		if fill
			pPen := Gdip_BrushCreateSolid(color) ; fill
		else
			pPen := Gdip_CreatePen(color, thickness)
	}
	; msgbox % "(" . x1 . ", " . y1 . ") (" . x2 - x1 . ", " . y2 - y1 . ")"
	if fill
		Gdip_FillRectangle(G, pPen, x1, y1, x2 - x1, y2 - y1)
	else
		Gdip_DrawRectangle(G, pPen, x1, y1, x2 - x1, y2 - y1) ; x, y, width, hight
	UpdateLayeredWindow(hwn, hdc, fenetre_X, fenetre_Y, screensWidth, screensHeight)	; l'air sur la quelle les dessins seront dessiné
	if (id == 0) {
		draw_pattern[0].Push([pPen, x1, y1, x2 - x1, y2 - y1, X, Y])
	}
	else {
		draw_pattern[id] := [pPen, x1, y1, x2 - x1, y2 - y1, X, Y]
	}
	image_config["fenetre_X"] := fenetre_X
	image_config["fenetre_Y"] := fenetre_Y
	; pause
}

image_delete(id:="")
{
	global image_config, draw_pattern
	fenetre_X := image_config["fenetre_X"]
	fenetre_Y :=  image_config["fenetre_Y"]
	screensWidth := image_config["screensWidth"]
	screensHeight :=  image_config["screensHeight"]
	hwn := image_config["hwn"]
	hbm := image_config["hbm"]
	obm := image_config["obm"]
	hdc := image_config["hdc"]
	G := image_config["G"]
	if (id == "") {
		pen := draw_pattern[draw_pattern.Count()]
		Gdip_DeletePen(pen)
		draw_pattern.Delete(draw_pattern.Count()) ; on supprime le dernier carré ajouté au dict
	}
	else {
		pen := draw_pattern[id]
		Gdip_DeletePen(pen)
		draw_pattern.Delete(id)
	}
	Gdip_GraphicsClear(G)	
	for id, pen in draw_pattern {
		if (id == 0) {
			for id0, pen0 in pen {
				Gdip_DrawRectangle(G, pen0[1], pen0[2], pen0[3], pen0[4], pen0[5])
			}
		}
		Gdip_DrawRectangle(G, pen[1], pen[2], pen[3], pen[4], pen[5])
	}
	UpdateLayeredWindow(hwn, hdc, fenetre_X, fenetre_Y, screensWidth, screensHeight)	; l'air sur la quelle les dessins seront dessiné
}

image_clear()
{
	global image_config, draw_pattern
	screens_X_min := image_config["screens_X_min"]
	screens_Y_min := image_config["screens_Y_min"]
	screensWidth := image_config["screensWidth"]
	screensHeight := image_config["screensHeight"]
	hwn := image_config["hwn"]
	hbm := image_config["hbm"]
	obm := image_config["obm"]
	hdc := image_config["hdc"]
	G := image_config["G"]
	
	Gdip_GraphicsClear(G)
	for id, pen in draw_pattern {
		if (id == 0) {
			for id0, pen0 in pen {
				Gdip_DeletePen(pen0[1])
			}
		}
		Gdip_DeletePen(pen[1])
	}
	UpdateLayeredWindow(hwn, hdc, screens_X_min, screens_Y_min, screensWidth, screensHeight)
	draw_pattern := Object()
	shapesss := Object()
	SelectObject(hdc, obm)
	DeleteObject(hbm)
	DeleteDC(hdc)
	Gdip_DeleteGraphics(G)
}

image_size(image)
{
	GDIPToken := Gdip_Startup()                             
	pBM := Gdip_CreateBitmapFromFile(image)                 
	W := Gdip_GetImageWidth(pBM)
	H := Gdip_GetImageHeight(pBM)   
	Gdip_DisposeImage(pBM)
	Gdip_Shutdown(GDIPToken)
	return [W, H]
}

image_search_debug(x1, y1, x2, y2, title, img)
{
	image_rectangle(x1, y1, x2, y2, title)
	ImageSearch, x_find, y_find, x1, y1, x2, y2, % img
	return [x_find, y_find]
}
