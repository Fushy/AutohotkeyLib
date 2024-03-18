#Include <Image>
#Include <Texte>

SetBatchLines, -1
; cree_rectangle(100, 100, 200, 200)


; F1::MouseGetPos, , , win_id, control, 
; F2::Msgbox, control %control%`r`nwin_id %win_id%
; F3::ControlSend , %Control%, {enter}, ahk_id %win_id%

; change_key()
; {
	; XButton1::
		; send, {c Down}
	; return
	; XButton1 Up::
		; send, {c up}
	; return
; }

gen_list_around_value(value, length)
{
    start := value - (length // 2) * (value / length)
    if (mod(length, 2) == 0) {
        start += (value / length) / 2
	}
	array := object()
	loop % length {
		array.Push(start + (A_index - 1) * (value / length))
	}
	return array
}

 Clipboard_HasText() {
	Static CF_NATIVETEXT := A_IsUnicode ? 13 : 1 ; CF_UNICODETEXT = 13, CF_TEXT = 1
	Return DllCall("IsClipboardFormatAvailable", "UInt", CF_NATIVETEXT, "UInt")
 }
 
 get_clipboard() {
	Static CF_NATIVETEXT := A_IsUnicode ? 13 : 1 ; CF_UNICODETEXT = 13, CF_TEXT = 1
	ClipText := ""
	If DllCall("OpenClipboard", "Ptr", 0, "UInt") {
	   If (HMEM := DllCall("GetClipboardData", "UInt", CF_NATIVETEXT, "UPtr")) {
		  Chrs := DllCall("GlobalSize", "Ptr", HMEM, "Ptr") >> !!A_IsUnicode
		  If (PMEM := DllCall("GlobalLock", "Ptr", HMEM, "UPtr")) {
			 ClipText := StrGet(PMEM, Chrs)
			 DllCall("GlobalUnlock", "Ptr", HMEM)
		  }
	   }
	   DllCall("CloseClipboard")
	}
	if Clipboard_HasText()
		Return ClipText
 }

util_restric(ByRef x, ByRef y, x1, y1, x2, y2)
{
	if (x < x1) {
		x := x1
	}
	if (x > x2) {
		x := x2
	}
	if (y < y1) {
		y := y1
	}
	if (y > y2) {
		y := y2
	}
}


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
	; size := image_size(SubStr(image, InStrLast(image)+1))
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


rng_int(min, max) {
	Random, value, min, max
	return value
}

rng() {
	Random, value, 0.0, 1.0
	return value
}
;;;

;;; String - or check text.ahk


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

util_index(array, elementToFind) {
    for index, value in array {
        if (value == elementToFind) {
            return index
        }
    }
    return -1
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

;;; keys

util_spam_keys(keys, n, timer)
{
	; loop % n {
		for i, key in keys
		{
			send, {%key%}
			sleep, 10
		}
		sleep, % timer
	; }
}

_wait_release_key(key)
{
	if (GetKeyState(key, "P") || GetKeyState(key, "T")) {
		KeyWait, % key
	}
}

util_wait_release_key()
{
	_wait_release_key("Alt")
	_wait_release_key("Ctrl")
	_wait_release_key("Shift")
	_wait_release_key("LWin")
	_wait_release_key("RWin")
	_wait_release_key("MButton")
	_wait_release_key("LButton")
	_wait_release_key("RButton")
	_wait_release_key("z")
	_wait_release_key("q")
	_wait_release_key("s")
	_wait_release_key("d")
	_wait_release_key("a")
	_wait_release_key("e")
	_wait_release_key("r")
	_wait_release_key("f")
	_wait_release_key("w")
	_wait_release_key("x")
	_wait_release_key("c")
	_wait_release_key("AppsKey")
	_wait_release_key("RControl")
}

_release_key(key, yes:=1, all_state:=0)
{
	if (yes && GetKeyState(key)) {
		send, {%key% Up}
	}
}

util_release_key(LButton:=1, a:=1, z:=1, q:=1, s:=1, d:=1)
{
	_release_key("Alt")
	_release_key("Ctrl")
	_release_key("Shift")
	_release_key("LWin")
	_release_key("RWin")
	_release_key("MButton")
	_release_key("LButton", LButton)
	_release_key("RButton")
	_release_key("z", z)
	_release_key("q", q)
	_release_key("s", s)
	_release_key("d", d)
	_release_key("a", a)
	_release_key("e")
	_release_key("r")
	_release_key("f")
	_release_key("w")
	_release_key("x")
	_release_key("c")
	_release_key("AppsKey",1,1)
	_release_key("RControl",1,1)
}

util_reload()
{
	pause, off
	util_release_key()
	sleep, 10
	reload
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
			tooltip La fenetre %title% n'a pas �t� activ� en moins d'une 1s
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
	; if (X) {
		ControlFocus, control, %WinTitle%
	; 	WinGetPos, fenetre_X, fenetre_Y, Width, Height, % WinTitle
	; 	X -= fenetre_X
	; 	Y -= fenetre_Y
	; }
	ControlSend,, msg, %WinTitle%
	hwnd:=ControlFromPoint(X, Y, WinTitle, WinText, cX, cY, ExcludeTitle, ExcludeText)  
	PostMessage, %msg%, param, cX&0xFFFF | cY<<16, %control%, ahk_id %hwnd%
	; SendMessage, 0x115, 120 << 16, ( X << 16 )|Y,, ahk_id %hwnd%
	; PostMessage, 0x115, 120 << 16, ( X << 16 )|Y,, ahk_id %hwnd%
	; PostMessage, 0x20A, 0x780000, (X<<16)|Y,, ahk_id %hwnd%
	; MouseGetPos, mX, mY, TWinID, TCon
	; PostMessage, 0x20A, -120 << 16, (mY << 16) | (mX & 0xFFFF), %TCon%, ahk_id%TWinID%
}

util_click_absolute_magic(X, Y, WinTitle="", sleep_time:=0, WinText="", ExcludeTitle="", ExcludeText="", n=1)  
{
	SetControlDelay -1
	; mousemove, X, Y
	; pause
	; blockinput, On
	; if (WinTitle != "") {
		ControlFocus,, %WinTitle%
		WinGetPos, fenetre_X, fenetre_Y, Width, Height, % WinTitle
		; screenmode
		X -= fenetre_X
		Y -= fenetre_Y
	; }
	loop %n% {
		hwnd:=ControlFromPoint(X, Y, WinTitle, WinText, cX, cY, ExcludeTitle, ExcludeText)  
		; PostMessage, 0x200, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_MOUSEMOVE
		PostMessage, 0x201, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_LBUTTONDOWN
		PostMessage, 0x202, 0, cX&0xFFFF | cY<<16,, ahk_id %hwnd% ; WM_LBUTTONUP
		PostMessage, 0x201, 0, cX&0xFFFF | cY<<16,, WinTitle ; WM_LBUTTONDOWN
		sleep, 75
		PostMessage, 0x202, 0, cX&0xFFFF | cY<<16,, WinTitle ; WM_LBUTTONUP
		; PostMessage, 0x201, 0, cX&0xFFFF | cY<<16,, %WinTitle% ; WM_LBUTTONDOWN
		; PostMessage, 0x202, 0, cX&0xFFFF | cY<<16,, %WinTitle% ; WM_LBUTTONUP
		; blockinput, Off	
		sleep, %sleep_time%
	}
}

util_click_absolute_magic_2(X, Y, WinTitle="", sleep_time:=0, WinText="", ExcludeTitle="", ExcludeText="")  
{
	; mousemove, X, Y
	; pause
	SetControlDelay -1  ; May improve reliability and reduce side effects.
	; ControlClick, Toolbar321, Some Window Title,,,, NA x1297 y2744
	ControlFocus,, %WinTitle%
	WinGetPos, fenetre_X, fenetre_Y, Width, Height, % WinTitle
	; X -= fenetre_X
	; Y -= fenetre_Y
	ControlClick, "x" . X . " y" . Y
	ControlClick, x500 y500
}

util_click_rng_absolute_magic(X1, Y1, X2, Y2, WinTitle="", sleep_time:=0, WinText="", ExcludeTitle="", ExcludeText="")  
{
	x := rng_int(X1, X2)
	y := rng_int(Y1, Y2)
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

mousemove_builtinswin(x, y, length)
{
	loop % length {
		DllCall("mouse_event", uint, 1, int, x, int, y, uint, 0, int, 0)
		Sleep 10
	}
}