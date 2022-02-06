#Include <Image>

SetBatchLines, -1
; cree_rectangle(100, 100, 200, 200)


; F1::MouseGetPos, , , win_id, control, 
; F2::Msgbox, control %control%`r`nwin_id %win_id%
; F3::ControlSend , %Control%, {enter}, ahk_id %win_id%


;;; ImageSearch
util_DetectImage(x1, y1, x2, y2, image, p:=50)
{
	size := image_size(image)
	image_delete()
	loop {
		if GetKeyState("NumpadAdd", "P") {
			p += 5
			tooltip, %p% |%x% %y%|
			while GetKeyState("NumpadAdd", "P") {
			}
		}
		if GetKeyState("NumpadSub", "P") {
			p -= 5
			tooltip, %p% |%x% %y%|
			while GetKeyState("NumpadSub", "P") {
			}
		}
		image_rectangle(x1, y1, x2, y2, 1)
		ImageSearch, x, y, x1, y1, x2, y2, *%p% %image%
		tooltip, %p% |%x% %y%|
		if (x) {
			image_rectangle(x-1, y-1, x+size[1]+1, y+size[2]+1, 1)
			
		}
		else {
			image_delete(2)
		}
	}
}

util_ImageSearch(x1, y1, x2, y2, image, title:="A", rouge:="ff", vert:="00", bleu:="00")
{
	image_rectangle(x1-1, y1-1, x2+1, y2+1, 1, title, "00", "00", "ff")
	ImageSearch, x, y, x1, y1, x2, y2, %image%
	size := image_size(SubStr(image, util_InStrLast(image)+1))
	if (x && y) {
		; mousemove, x, y
		image_rectangle(x-1, y-1, x+size[1]+1, y+size[2]+1, 1, title, rouge, vert, bleu)
		return [x, y]
	}
}

; util_waitImage(x1, y1, x2, y2, image, fun)
util_waitImage(x1, y1, x2, y2, image)
{
	while (!x || !y) {
		ImageSearch, x, y, x1, y1, x2, y2, %image%
		; fun()
	}
	return [x, y]
}

;;; Math
util_max(a, b) {
	return (a > b) ? a : b
}

util_min(a, b) {
	return (a < b) ? a : b
}

rng(min, max) {
	Random, value, min, max
	return value
}
;;;

;;; String
util_InStrLast(str)
{
	index := 0
	while ((i := InStr(str, " ",, i+1)) != 0) {
		index := i
	}
	return index
}

util_StrReverse(str)
{
	Loop, Parse, str
	{
		value := A_LoopField . value
	}
	return value
}
;;;

util_CopyClipboard(str:="")
{
	beforClip := clipboard
	if (str = "") {
		send ^c
		if (beforClip != clipboard)
			str := clipboard
	}
	else {
		clipboard := str
	}
	start := A_tickcount
	deb:
	while ((str == beforClip) && ((A_tickcount - start) < 300)) {
		if  (A_tickcount - start > 100) {
			str := 
			goto, deb
		}
	}
	return clipboard
}

/*
util_array_rec(array, rec:=0)
{
	string := texte_mult("-", rec) . ">"
	for i, o in array
	{
		if (o.Length() > 0) {
			string .= "`n" . util_array_rec(o, rec+1)
		}
		if (StrLen(o) > 0) {
			; if (i == 1)
				; string .= separateur . " "
			string .= o . "[" . i . "]"
		}
	}
	; msgbox % "|" . string . "|"
	return "." . string
}
*/

util_chronometre(msg:="")
{
	start := A_Tickcount
	loop {
		tooltip, % util_affiche_date(A_Tickcount - start, true) . "`n" . msg, 0, 0
	}
}


util_contains(haystack, needle) {
	if !(IsObject(haystack)) || (haystack.Length() = 0)
		return 0
	for index, value in haystack
		if (value = needle)
			return index
	return 0
}

util_msgbox(texte, timeout:=0)
{
	MsgBox, 0, util_msgbox, %texte%, % timeout / 1000
}

util_array(array, separateur:="`n")
{
	string := ""
	for i, o in array
	{
		string .= o . separateur
	}
	return string
}

util_array2D(array, separateur:="`n")
{
	string := ""
	for i, o in array
	{
		string .= i . "  "
		for ii, oo in o
		{
			string .= oo . "[" . ii . "]" . " "
		}
		string .= separateur
	}
	return string
}

util_wait_release_key()
{
	if (GetKeyState("Alt", "P") || GetKeyState("Alt", "T")) {
		KeyWait, Alt
	}
	if (GetKeyState("Ctrl", "P") || GetKeyState("Ctrl", "T")) {
		KeyWait, Ctrl
	}
	if (GetKeyState("Shift", "P") || GetKeyState("Shift", "T")) {
		KeyWait, Shift
	}
	if (GetKeyState("LWin", "P") || GetKeyState("Win", "T")) {
		KeyWait, LWin
	}
	if (GetKeyState("RWin", "P") || GetKeyState("Win", "T")) {
		KeyWait, RWin
	}
	if (GetKeyState("LButton", "P") || GetKeyState("LButton", "T")) {
		KeyWait, LButton
	}
	if (GetKeyState("RButton", "P" || GetKeyState("RButton", "T"))) {
		KeyWait, RButton
	}
	if (GetKeyState("a", "P") || GetKeyState("a", "T")) {
		KeyWait, a
	}
	if (GetKeyState("z", "P") || GetKeyState("z", "T")) {
		KeyWait, z
	}
	if (GetKeyState("e", "P") || GetKeyState("e", "T")) {
		KeyWait, e
	}
	if (GetKeyState("q", "P") || GetKeyState("q", "T")) {
		KeyWait, q
	}
	if (GetKeyState("s", "P") || GetKeyState("s", "T")) {
		KeyWait, s
	}
	if (GetKeyState("d", "P") || GetKeyState("d", "T")) {
		KeyWait, d
	}
	if (GetKeyState("w", "P") || GetKeyState("w", "T")) {
		KeyWait, w
	}
	if (GetKeyState("x", "P") || GetKeyState("x", "T")) {
		KeyWait, x
	}
	if (GetKeyState("c", "P") || GetKeyState("c", "T")) {
		KeyWait, c
	}
	if (GetKeyState("AppsKey", "P") || GetKeyState("AppsKey", "T")) {
		KeyWait, AppsKey
	}
	if (GetKeyState("RControl", "P") || GetKeyState("RControl", "T")) {
		KeyWait, RControl
	}
}

util_release_key()
{
	if (GetKeyState("Alt", "P") || GetKeyState("Alt", "T")) {
		send, {Alt Up}
	}
	if (GetKeyState("Ctrl", "P") || GetKeyState("Ctrl", "T")) {
		send, {Ctrl Up}
	}
	if (GetKeyState("Shift", "P") || GetKeyState("Shift", "T")) {
		send, {Shift Up}
	}
	if (GetKeyState("LWin", "P") || GetKeyState("Win", "T")) {
		send, {LWin Up}
	}
	if (GetKeyState("RWin", "P") || GetKeyState("Win", "T")) {
		send, {RWin Up}
	}
	if (GetKeyState("LButton", "P") || GetKeyState("LButton", "T")) {
		send, {LButton Up}
	}
	if (GetKeyState("RButton", "P" || GetKeyState("RButton", "T"))) {
		send, {RButton Up}
	}
	if (GetKeyState("a", "P") || GetKeyState("a", "T")) {
		send, {a Up}
	}
	if (GetKeyState("z", "P") || GetKeyState("z", "T")) {
		send, {z Up}
	}         
	if (GetKeyState("e", "P") || GetKeyState("e", "T")) {
		send, {e Up}
	}
	if (GetKeyState("q", "P") || GetKeyState("q", "T")) {
		send, {q Up}
	}
	if (GetKeyState("s", "P") || GetKeyState("s", "T")) {
		send, {s Up}
	}
	if (GetKeyState("d", "P") || GetKeyState("d", "T")) {
		send, {d Up}
	}
	if (GetKeyState("w", "P") || GetKeyState("w", "T")) {
		send, {w Up}
	}
	if (GetKeyState("x", "P") || GetKeyState("x", "T")) {
		send, {x Up}
	}
	if (GetKeyState("c", "P") || GetKeyState("c", "T")) {
		send, {c Up}
	}
	if (GetKeyState("AppsKey", "P") || GetKeyState("AppsKey", "T")) {
		send, {AppsKey Up}
	}
	if (GetKeyState("RControl", "P") || GetKeyState("RControl", "T")) {
		send, {RControl Up}
	}
}

; ahk_class tooltips_class32
; ahk_exe AutoHotkey.exe

util_dict_maxValue(dict)
{
	max := 0
	for i,o in dict {
		if (o > max) {
			max := o
		}
	}
	return max
}

util_sleep(n, fun_name:="", wait:=0, msg:="")
{
	start := A_Tickcount
	while (A_Tickcount - start < n) {
		tooltip, % util_affiche_date(n - (A_Tickcount - start), false) . "`n" . msg, 0, 0
		if (fun_name != "") {
			res := %fun_name%()
			if (res) {
				break
			}
		}
		sleep, % wait
	}
	tooltip,
}

util_tooltip(texte:="ok", x:="", y:="", millisecodds:=100)
{
	start := A_tickcount
	tooltip, % texte, x, y
	while (A_tickcount - start < millisecodds) {
	}
	tooltip
}


util_tooltip_transparent(texte, x, y, transparence:=255)
{
	if (!texte)
		return
	tooltip, %texte%, x, y
	winwait, ahk_class tooltips_class32 ahk_exe AutoHotkey.exe
	title := "ahk_id " . WinExist(ahk_class tooltips_class32  ahk_exe AutoHotkey.exe)
	sleep, 100
	WinSet, Transparent, %transparence%, %title%
}

util_WinActivate(title)
{
	start := A_tickcount
	while (!WinActive(title)) {
		WinActivate, % title
		if (A_tickcount - start > 1000) {
			tooltip La fenetre %title% n'a pas été activé en moins d'une 1s
			if (!WinExist(title)) {
				return
			}
		}
		sleep, 22
	}
	return
}

util_somme_tableau(tableau)
{
	somme := 0
	for i,o in tableau {
		somme += o
	}
	return somme
}

is_numeric(var)
{
	; static number := "number"
	if var is number
		return true
	return false
}

util_affiche_date(millisecondes, affiche_millisecondes:=false)
{
	annee_origine := millisecondes / 1000 / 60 / 60 / 24 / 30 / 12
	mois_origine := millisecondes / 1000 / 60 / 60 / 24 / 30
	jours_origine := millisecondes / 1000 / 60 / 60 / 24
	heures_origine := millisecondes / 1000 / 60 / 60
	minutes_origine := millisecondes / 1000 / 60
	secondes_origine := millisecondes / 1000
	millisecondes_origine := millisecondes
	
	annee := millisecondes / 1000 / 60 / 60 / 24 / 30 / 12
	if (annee >= 1) {
		annee_ecrit := Floor(annee)
		millisecondes -= 1000 * 60 * 60 * 24 * 30 * 12 * annee_ecrit
	}
	mois := millisecondes / 1000 / 60 / 60 / 24 / 30
	if (mois >= 1) {
		mois_ecrit := Floor(mois)
		millisecondes -= 1000 * 60 * 60 * 24 * 30 * mois_ecrit
	}
	jours := millisecondes / 1000 / 60 / 60 / 24
	if (jours >= 1) {
		jours_ecrit := Floor(jours)
		millisecondes -= 1000 * 60 * 60 * 24 * jours_ecrit
	}
	heures := millisecondes / 1000 / 60 / 60
	if (heures >= 1) {
		heures_ecrit := Floor(heures)
		millisecondes -= 1000 * 60 * 60 * heures_ecrit
	}
	minutes := millisecondes / 1000 / 60
	if (minutes >= 1) {
		minutes_ecrit := Floor(minutes)
		millisecondes -= 1000 * 60 * minutes_ecrit
	}
	secondes := millisecondes / 1000
	if (secondes >= 1) {
		secondes_ecrit := Floor(secondes)
		millisecondes -= 1000 * secondes_ecrit
	}
	
	format := ""
	
	if (affiche_millisecondes) {
		format := ":" . millisecondes
	}
	if (secondes_ecrit) {
		format := secondes_ecrit . format
	}
	if (minutes_ecrit) {
		format := minutes_ecrit . ":" . format
	}
	if (heures_ecrit) {
		format := heures_ecrit . ":" . format
	}
	if (jours_ecrit) {
		format := jours_ecrit . "j " . format
	}
	if (mois_ecrit) {
		format := mois_ecrit . "m " . format
	}
	if (annee_ecrit) {
		format := annee_ecrit . "a " . format
	}
	
	; id := annee mois jours heures minutes secondes
	; msgbox % annee_origine . " " . annee . " " . annee_ecrit . " annee"
	; msgbox % mois_origine . " " . mois . " " . mois_ecrit . " mois"
	; msgbox % jours_origine . " " . jours . " " . jours_ecrit . " jours"
	; msgbox % heures_origine . " " . heures . " " . heures_ecrit . " heures"
	; msgbox % minutes_origine . " " . minutes . " " . minutes_ecrit . " minutes"
	; msgbox % secondes_origine . " " . secondes . " " . secondes_ecrit . " secondes"
	; msgbox % millisecondes_origine . " " . millisecondes . " millisecondes"
	; msgbox % id
	; msgbox % format
	
	return format
}

util_url_decode(str) {
	Loop
		If RegExMatch(str, "i)(?<=%)[\da-f]{1,2}", hex)
			StringReplace, str, str, `%%hex%, % Chr("0x" . hex), All
		Else Break
	Return, str
}

util_url_encode(str) {
	f = %A_FormatInteger%
	SetFormat, Integer, Hex
	If RegExMatch(str, "^\w+:/{0,2}", pr)
		StringTrimLeft, str, str, StrLen(pr)
	StringReplace, str, str, `%, `%25, All
	Loop
		If RegExMatch(str, "i)[^\w\.~%]", char)
			StringReplace, str, str, %char%, % "%" . Asc(char), All
		Else Break
	SetFormat, Integer, %f%
	Return, pr . str
}

util_sort_var(var)
{
	value := util_CopyClipboard()
	Sort value, F StringSort
	return value
}

StringSort(a1, a2)
{
    return a1 > a2 ? 1 : a1 < a2 ? -1 : 0  ; Sorts alphabetically based on the setting of StringCaseSense.
}

util_MouseClick(X, Y, title:="", btn:="LButton", count:="1", speed:=0, offset_x:=0, offset_y:=0, sleep_time:=0)
{	; absolute coord or relatif if title
	util_release_key()
	blockinput, on
	MouseGetPos, save_X, save_Y
	if (title) {
		WinGetPos, fenetre_X, fenetre_Y, Width, Height, % title
		X += fenetre_X
		Y += fenetre_Y
	}
	mousemove, X+offset_x, Y+offset_y, 0
	loop % count {
		send, {%btn% Down}
		sleep, % sleep_time
		send, {%btn% Up}
	}
	; MouseClick, %left%, X+offset_x, Y+offset_y, count, speed
	mousemove, save_X, save_Y, 0
	blockinput, off
}

util_sendMagic(msg, WinTitle="", X="", Y="", param:=0, WinText="", ExcludeTitle="", ExcludeText="")  
{ ; https://wiki.winehq.org/List_Of_Windows_Messages
	if (X) {
		ControlFocus, control, %WinTitle%
		WinGetPos, fenetre_X, fenetre_Y, Width, Height, % WinTitle
		X -= fenetre_X
		Y -= fenetre_Y
	}
	hwnd:=ControlFromPoint(X, Y, WinTitle, WinText, cX, cY, ExcludeTitle, ExcludeText)  
	; PostMessage, %msg%, param, cX&0xFFFF | cY<<16, %control%, ahk_id %hwnd%
	; SendMessage, 0x115, 120 << 16, ( X << 16 )|Y,, ahk_id %hwnd%
	; PostMessage, 0x115, 120 << 16, ( X << 16 )|Y,, ahk_id %hwnd%
	; PostMessage, 0x20A, 0x780000, (X<<16)|Y,, ahk_id %hwnd%
	; MouseGetPos, mX, mY, TWinID, TCon
	; PostMessage, 0x20A, -120 << 16, (mY << 16) | (mX & 0xFFFF), %TCon%, ahk_id%TWinID%
}

util_click_absolute_magic(X, Y, WinTitle="", sleep_time:=0, WinText="", ExcludeTitle="", ExcludeText="")  
{
	mousemove, X, Y
	; pause
	; blockinput, On
	; if (WinTitle != "") {
		ControlFocus,, %WinTitle%
		WinGetPos, fenetre_X, fenetre_Y, Width, Height, % WinTitle
		X -= fenetre_X
		Y -= fenetre_Y
	; }
	hwnd:=ControlFromPoint(X, Y, WinTitle, WinText, cX, cY, ExcludeTitle, ExcludeText)  
	PostMessage, 0x200, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_MOUSEMOVE
	PostMessage, 0x201, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_LBUTTONDOWN  
	; sleep, % sleep_time
	PostMessage, 0x202, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_LBUTTONUP  
	; pause
	; blockinput, Off
}

util_click_absolute_magic_2(X, Y, WinTitle="", sleep_time:=0, WinText="", ExcludeTitle="", ExcludeText="")  
{
	; mousemove, X, Y
	; pause
	; msgbox % X
	; msgbox % Y
	; SetControlDelay -1  ; May improve reliability and reduce side effects.
	; ControlClick, Toolbar321, Some Window Title,,,, NA x1297 y2744
	ControlFocus,, %WinTitle%
	WinGetPos, fenetre_X, fenetre_Y, Width, Height, % WinTitle
	X -= fenetre_X
	Y -= fenetre_Y
	ControlClick, "x" . X . " y" . Y
	ControlClick, x1297 y2744
}

util_click_rng_absolute_magic(X1, Y1, X2, Y2, WinTitle="", sleep_time:=0, WinText="", ExcludeTitle="", ExcludeText="")  
{
	x := rng(X1, X2)
	y := rng(Y1, Y2)
	util_click_absolute_magic(x, y, WinTitle, sleep_time, WinText, ExcludeTitle, ExcludeText)
}

;;;;;;;; lib ;;;;;;

; Retrieves the control at the specified point.
; X         [in]    X-coordinate relative to the top-left of the window.
; Y         [in]    Y-coordinate relative to the top-left of the window.
; WinTitle  [in]    Title of the window whose controls will be searched.
; WinText   [in]
; cX        [out]   X-coordinate relative to the top-left of the control.
; cY        [out]   Y-coordinate relative to the top-left of the control.
; ExcludeTitle [in]
; ExcludeText  [in]
; Return Value:     The hwnd of the control if found, otherwise the hwnd of the window.
ControlFromPoint(X, Y, WinTitle="", WinText="", ByRef cX="", ByRef cY="", ExcludeTitle="", ExcludeText="")
{
    static EnumChildFindPointProc=0
    if !EnumChildFindPointProc
        EnumChildFindPointProc := RegisterCallback("EnumChildFindPoint","Fast")
    
    if !(target_window := WinExist(WinTitle, WinText, ExcludeTitle, ExcludeText))
        return false
    
    VarSetCapacity(rect, 16)
    DllCall("GetWindowRect","uint",target_window,"uint",&rect)
    VarSetCapacity(pah, 36, 0)
    NumPut(X + NumGet(rect,0,"int"), pah,0,"int")
    NumPut(Y + NumGet(rect,4,"int"), pah,4,"int")
    DllCall("EnumChildWindows","uint",target_window,"uint",EnumChildFindPointProc,"uint",&pah)
    control_window := NumGet(pah,24) ? NumGet(pah,24) : target_window
    DllCall("ScreenToClient","uint",control_window,"uint",&pah)
    cX:=NumGet(pah,0,"int"), cY:=NumGet(pah,4,"int")
    return control_window
}

EnumChildFindPoint(aWnd, lParam)
{
    if !DllCall("IsWindowVisible","uint",aWnd)
        return true
    VarSetCapacity(rect, 16)
    if !DllCall("GetWindowRect","uint",aWnd,"uint",&rect)
        return true
    pt_x:=NumGet(lParam+0,0,"int"), pt_y:=NumGet(lParam+0,4,"int")
    rect_left:=NumGet(rect,0,"int"), rect_right:=NumGet(rect,8,"int")
    rect_top:=NumGet(rect,4,"int"), rect_bottom:=NumGet(rect,12,"int")
    if (pt_x >= rect_left && pt_x <= rect_right && pt_y >= rect_top && pt_y <= rect_bottom)
    {
        center_x := rect_left + (rect_right - rect_left) / 2
        center_y := rect_top + (rect_bottom - rect_top) / 2
        distance := Sqrt((pt_x-center_x)**2 + (pt_y-center_y)**2)
        update_it := !NumGet(lParam+24)
        if (!update_it)
        {
            rect_found_left:=NumGet(lParam+8,0,"int"), rect_found_right:=NumGet(lParam+8,8,"int")
            rect_found_top:=NumGet(lParam+8,4,"int"), rect_found_bottom:=NumGet(lParam+8,12,"int")
            if (rect_left >= rect_found_left && rect_right <= rect_found_right
                && rect_top >= rect_found_top && rect_bottom <= rect_found_bottom)
                update_it := true
            else if (distance < NumGet(lParam+28,0,"double")
                && (rect_found_left < rect_left || rect_found_right > rect_right
                 || rect_found_top < rect_top || rect_found_bottom > rect_bottom))
                 update_it := true
        }
        if (update_it)
        {
            NumPut(aWnd, lParam+24)
            DllCall("RtlMoveMemory","uint",lParam+8,"uint",&rect,"uint",16)
            NumPut(distance, lParam+28, 0, "double")
        }
    }
    return true
}