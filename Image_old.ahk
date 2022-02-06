#Include <Gdip>
SetBatchLines, -1

image_nombre_ecran_milieu := 2
image_Width := A_ScreenWidth * image_nombre_ecran_milieu
image_Height := A_ScreenHeight

If !pToken := Gdip_Startup()
{
	MsgBox, 48, gdiplus error!, Gdiplus failed to start. Please ensure you have gdiplus on your system
	ExitApp
}
Gui, 1: -Caption +E0x80000 +LastFound +AlwaysOnTop +ToolWindow +OwnDialogs
Gui, 1: Show, NA, Gui_title
image_hwnd1 := WinExist()
image_hbm := CreateDIBSection(image_Width, image_Height)
image_hdc := CreateCompatibleDC()
image_obm := SelectObject(image_hdc, image_hbm)
image_img := Gdip_GraphicsFromHDC(image_hdc)
image_tableau := Object()


image_carre(100, 100, 200, 200, "A", rouge:="ff", vert:="00", bleu:="00", transparence:="ff", epaisseur:=1)
; pause
image_carre(100, 100, 300, 400, "A", rouge:="ff", vert:="00", bleu:="ff", transparence:="ff", epaisseur:=1)
image_carre(542, 472, 896, 784, "A", rouge:="ff", vert:="ff", bleu:="00", transparence:="ff", epaisseur:=1)
; pause
image_efface(index)
; image_efface(index)
pause
image_efface(index=0, thickness=1)
{
	global image_tableau, image_img, image_hwnd1, image_hdc, image_Width, image_Height
	pen_gomme := Gdip_CreatePen(0x00000000, thickness)
	Gdip_SetCompositingMode(image_img, 1)
	if (index) {
		carre := image_tableau.RemoveAt(index)
	}
	else {
		carre := image_tableau.Pop()
	}
	Gdip_DrawRectangle(image_img, pen_gomme, carre[1], carre[2], carre[3], carre[4])	
	Gdip_SetCompositingMode(image_img, 0)

	UpdateLayeredWindow(image_hwnd1, image_hdc, -A_ScreenWidth, 0, image_Width, image_Height)
	; Gdip_GraphicsClear(image_img)
	; WinClose, ahk_id %image_hwnd1%
}

image_milieu_ecran()
{
	WinGetPos, title_X, title_Y, title_Width, title_Height, A
	image_carre(title_Width / 2, title_Height / 2, title_Width / 2, title_Height / 2, A)
}

image_carre(x1, y1, x2, y2, title, rouge:="ff", vert:="00", bleu:="00", transparence:="ff", epaisseur:=1)
{
	global image_hbm, image_hdc, image_obm, image_img, image_hwnd1, image_Width, image_Height, image_tableau
	
	; while (image_tableau.Length()) { ; supprime toute les formes
		; image_efface()
	; }
	
	WinGetPos, title_X, title_Y, title_Width, title_Height, % title
	color = 0x%transparence%%rouge%%vert%%bleu%
	pen := Gdip_CreatePen(color, epaisseur)
	if (x2 < x1) {
		tmp := x1
		x1 := x2
		x2 := tmp
	}
	if (y2 < y1) {
		tmp := y1
		y1 := y2
		y2 := tmp
	}
	; msgbox % x1
	x1 += title_X + A_ScreenWidth
	; msgbox % x1
	x2 += title_X + A_ScreenWidth
	y1 += title_Y
	y2 += title_Y
	x1--
	y1--
	x2++
	y2++
	image_tableau.Push([x1, y1, x2-x1, y2-y1])
	Gdip_DrawRectangle(image_img, pen, x1, y1, x2-x1, y2-y1)
	UpdateLayeredWindow(image_hwnd1, image_hdc, -A_ScreenWidth, 0, image_Width, image_Height)
	; SelectObject(image_hdc, image_obm)
	; DeleteObject(image_hbm)
	; DeleteDC(image_hdc)
	; Gdip_DeleteGraphics(image_img)
}

image_pixelsearch(x1, y1, x2, y2, title, pixel, variation:=0, debug:=false, fast:=true)
{
	start := A_Tickcount
	image_carre(x1, y1, x2, y2, title, "00", "00", "ff")
	if (x1 > x2) {
		fast := false
		; msgbox x1 > x2
	}
	if (y1 > y2) {
		fast := false
		; msgbox y1 > y2
	}
	if (debug) {
		sleep, 500
	}
	if (fast) {
		PixelSearch, trouve_X, trouve_Y, x1, y1, x2, y2, pixel, variation, fast
	}
	else {
		PixelSearch, trouve_X, trouve_Y, x1, y1, x2, y2, pixel, variation
	}
	if (trouve_X || trouve_Y) {
		image_carre(trouve_X, trouve_Y, trouve_X, trouve_Y, title, "00", "ff")
	}
	if (debug) {
		pause
	}
	return [trouve_X, trouve_Y]
}

image_imagesearch(x1, y1, x2, y2, title, image, variation:=0, debug:=false)
{
	start := A_Tickcount
	sizeImg := GetImageSize(image)
	width := sizeImg[1]
	height := sizeImg[2]
	image_carre(x1, y1, x2, y2, title, "00", "00", "ff")
	if (x1 > x2) {
		msgbox x1 > x2
	}
	if (y1 > y2) {
		msgbox y1 > y2
	}
	if (variation) {
		variation = *%variation%
	}
	
	ImageSearch, trouve_X, trouve_Y, x1, y1, x2, y2, %variation% %image%
	if (trouve_X || trouve_Y) {
		if (debug) {
			tooltip, % util_affiche_date(A_Tickcount - start, true)
			sleep, 500
		}
		image_carre(trouve_X, trouve_Y, trouve_X + width, trouve_Y + height, title, "00", "ff")
	}
	if (debug) {
		pause
		tooltip
	}
	return [trouve_X, trouve_Y]
}

GetImageSize(image) {
	Gdip_GetDimensions(pBitmap := Gdip_CreateBitmapFromFile(image), w, h)
	return [w, h]
}
