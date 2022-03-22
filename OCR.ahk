#Include <Texte>
; #Include <betterOCR>
#Include <Image>

#Persistent

alphabets := "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
chiffres := "0123456789"

; msgbox % OCR_image("D:\_Fichier-PC\Documents\AutoHotKey Scripts\Temtem\ocr_out2.png")
; msgbox % OCR_image("D:\_Fichier-PC\Documents\AutoHotKey Scripts\Temtem\ocr_out2_modifier.png")

; !Rbutton::
	; msgbox % OCR_selection_better("1234567890")
	; msgbox % OCR_selection_C2T("#1234567890")
; return

take_screenshot(x1, y1, x2, y2, filename:="out.png")
{
	; A_ScriptDir
	fichier := "ocr_out.png"
	options = -c %x1%,%y1%,%x2%,%y2% %filename%
	; msgbox % options
	ahk_folder := substr(A_AhkPath, 1, StrLen(A_AhkPath) - StrLen("AutoHotkey.exe"))
	RunWait, %ahk_folder%\boxcutter-1.5\boxcutter.exe %options%
}

OCR_better(x1, y1, x2, y2, title, whitelist, marge:=255, fichier_suffixe:="", supprime_extra_caractere:=true, affiche_retour_ligne:=false, exePath:="")
{
	if !exePath
		exePath := "D:\_Fichier-PC\Documents\AutoHotKey Scripts\Util\transforme_ocr.pyw"
	fichier = ocr_out%fichier_suffixe%.png
	OCR_capture_screen(x1, y1, x2, y2, title, fichier)
	if (marge >= 0) {
		options = "%A_ScriptDir%\%fichier%" %marge%
		Run, %exePath% %options%
		while (!WinActive("ahk_exe py.exe")) {
			WinMinimize, ahk_exe py.exe
		}		
		WinMinimize, ahk_exe py.exe
		WinActivate, % title
		fichier = ocr_out%fichier_suffixe%_modifier.png
	}
	return OCR_image_better(fichier, whitelist, supprime_extra_caractere, affiche_retour_ligne)
}


OCR_image_better(image, whitelist, supprime_extra_caractere:=true, affiche_retour_ligne:=false)
{
	image_path = %A_ScriptDir%\%image%
	if (!FileExist(image_path)) {
		msgbox L'image à analyser n'existe pas`n|%image_path%|
		return
	}
	string := OCR_image(image_path)
	if (affiche_retour_ligne) {
		whitelist .= "`n"
		string := StrReplace(string, "\n", "`n")
	}
	; msgbox % string
	if (supprime_extra_caractere) {
		string := StrReplace(string, "\n", "")
		string := StrReplace(string, "\r", "")
		string := StrReplace(string, "\t", "")
	}
	return restreint_caractere(string, whitelist)
}

; Range: [0.71, 5.0]. Default is 3.5.
OCR_C2T(x1, y1, x2, y2, title, whitelist, factor, marge=255, fichier_suffixe:="", trimcapture:=true, deskew:=true)
{
	fichier = ocr_out%fichier_suffixe%.png
	OCR_capture_screen(x1, y1, x2, y2, title, fichier)
	; if (marge >= 0) {
		; options = "%A_ScriptDir%\%fichier%" %marge%
		; pause
		; Runwait, D:\_Fichier-PC\Documents\AutoHotKey Scripts\Util\transforme_ocr.pyw %options%
		; while (!WinActive("ahk_exe py.exe")) {
			; WinMinimize, ahk_exe py.exe
		; }		
		; WinMinimize, ahk_exe py.exe
		; WinActivate, % title
		; fichier = ocr_out%fichier_suffixe%_modifier.png
		; msgbox % fichier
	; }
	return OCR_image_C2T(fichier, whitelist, factor, trimcapture, deskew)
}


OCR_capture_screen(x1, y1, x2, y2, title, nameOutputFile)
{
	WinGetPos, title_X, title_Y, title_Width, title_Height, % title
	x1 += title_X
	x2 += title_X
	y1 += title_Y
	y2 += title_Y
	options = -c %x1%,%y1%,%x2%,%y2% %nameOutputFile%
	RunWait, D:\_Fichier-PC\Documents\AutoHotKey Scripts\Util\boxcutter-1.5\boxcutter.exe %options%
}

OCR_image_C2T(image, whitelist, factor, trimcapture:=true, deskew:=true, exePath:="")
{
	if (!exePath) {
		exePath := "D:\_Fichier-PC\Documents\AutoHotKey Scripts\Util\Capture2Text\Capture2Text.exe"
	}
	if (!FileExist(image)) {
		; msgbox L'image à analyser n'existe pas`n|%image%|
		return
	}
	if (trimcapture) {
		trimcapture := "--trim-capture"
	}
	else {
		trimcapture :=
	}
	if (deskew) {
		deskew := "--deskew"
	}
	else {
		deskew :=
	}
	if (factor) {
		factor := "--scale-factor " . factor
	}
	else {
		factor :=
	}
	options = -i %image% --whitelist %whitelist% %trimcapture% %deskew% %factor% -o tmp.txt
	RunWait, %exePath% %options%
	ocr := prend_le_fichier("tmp.txt")
	FileDelete, tmp.txt
	return SubStr(ocr, 1, StrLen(ocr) - 1)
}

OCR_transform(image, marge)
{
	if (marge >= 0) {
		WinGetTitle, title, A
		options = "%A_ScriptDir%\%image%" %marge%
		Run, D:\_Fichier-PC\Documents\AutoHotKey Scripts\Util\transforme_ocr.py %options%
		while (!WinExist("ahk_exe py.exe")) {
			WinMinimize, ahk_exe py.exe
		}
		WinMinimize, ahk_exe py.exe
		WinActivate, % title
		while (WinExist("ahk_exe py.exe")) {
			WinMinimize, ahk_exe py.exe
		}
	}
}

OCR_capture_screen_absolute(x1, y1, x2, y2, title, nameOutputFile, exePath:="")
{
	if !exePath
		exePath := "D:\_Fichier-PC\Documents\AutoHotKey Scripts\Util\boxcutter-1.5\boxcutter.exe"
	options = -c %x1%,%y1%,%x2%,%y2% %nameOutputFile%
	RunWait, %exePath% %options%
}

; a utiliser avec !Rbutton::
OCR_selection_better(whitelist, supprime_extra_caractere:=true)
{
	selection := selection_click()
	x1 := selection[1]
	y1 := selection[2]
	x2 := selection[3]
	y2 := selection[4]
	fichier := "ocr_out.png"
	options = -c %x1%,%y1%,%x2%,%y2% %fichier%
	RunWait, D:\_Fichier-PC\Documents\AutoHotKey Scripts\Util\boxcutter-1.5\boxcutter.exe %options%
	; msgbox % string
	string := restreint_caractere(OCR_image(fichier), whitelist)
	if (supprime_extra_caractere) {
		string := StrReplace(string, "\n", "")
		string := StrReplace(string, "\r", "")
		string := StrReplace(string, "\t", "")
	}
	return string
}

OCR_selection_C2T(whitelist, factor:=3.5, trimcapture:=true, deskew:=true)
{
	selection := selection_click()
	x1 := selection[1]
	y1 := selection[2]
	x2 := selection[3]
	y2 := selection[4]
	fichier := "ocr_out.png"
	if (trimcapture) {
		trimcapture := "--trim-capture"
	}
	else {
		trimcapture :=
	}
	if (deskew) {
		deskew := "--deskew"
	}
	else {
		deskew :=
	}
	if (factor) {
		factor := "--scale-factor " . factor
	}
	else {
		factor :=
	}
	options = -s "%x1% %y1% %x2% %y2%" --whitelist %whitelist% %trimcapture% %deskew% %factor% -o tmp.txt
	; msgbox % options
	RunWait, D:\_Fichier-PC\Documents\AutoHotKey Scripts\Util\Capture2Text\Capture2Text.exe %options%
	ocr := prend_le_fichier("tmp.txt")
	FileDelete, tmp.txt
	return ocr
}

OCR_image(image)
{
	; image = fond_blanc_transparent.png	;non
	; image = fond_transparent_blanc.png	; non
	; image = fond_blanc_noir.png		; a moitié non
	; image = fond_noir_transparent.png	; a moitié ok
	; image = fond_transparent_noir.png	; a moitié ok
	; image = fond_noir_blanc.png		; a moitié ok
	if (!FileExist(image)) {
		msgbox L'image à analyser n'existe pas`n|%image%|
		return
	}
	
	retry:
	
	; https://ocr.space/OCRAPI
	oForm := { apikey: "f53342743188957"
			 , language: "eng"
	 , ocrengine: "2"
			 , scale: "true"
			 , isTable: "true"
			 , file: [image] }

	CreateFormData(PostData, ContentType, oForm)
	url := "https://api.ocr.space/Parse/Image"
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	ComObjError(false)
	whr.Open("POST", url, true)
	whr.SetRequestHeader("Content-Type", ContentType)
	whr.SetRequestHeader("Referer", "https://api.ocr.space/")
	whr.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")
	whr.Option(6) := False ; No auto redirect
	whr.Send(PostData)
	while (whr.WaitForResponse() != -1) {
		return ""
		goto, retry
	}
	json_str := whr.ResponseText
	a = ParsedText":
	start := InStr(json_str, a) + StrLen(a) + 1
	b = ,"ErrorDetails":""}]
	len := InStr(json_str, b) - start
	end := len - StrLen(b) + 1
	resultat := substr(json_str, start, end)
	; MsgBox, % json_str
; MsgBox, |%resultat%|
	return resultat
}


;;; LIB

; CreateFormData() by tmplinshi, AHK Topic: https://autohotkey.com/boards/viewtopic.php?t=7647
; Thanks to Coco: https://autohotkey.com/boards/viewtopic.php?p=41731#p41731
; Modified version by SKAN, 09/May/2016
;Version from Suresh https://autohotkey.com/boards/viewtopic.php?p=85687#p85687


CreateFormData(ByRef retData, ByRef retHeader, objParam) {
	New CreateFormData(retData, retHeader, objParam)
}

Class CreateFormData {

	__New(ByRef retData, ByRef retHeader, objParam) {

		Local CRLF := "`r`n", i, k, v, str, pvData
		; Create a random Boundary
		Local Boundary := this.RandomBoundary()
		Local BoundaryLine := "------------------------------" . Boundary

    this.Len := 0 ; GMEM_ZEROINIT|GMEM_FIXED = 0x40
    this.Ptr := DllCall( "GlobalAlloc", "UInt",0x40, "UInt",1, "Ptr"  )          ; allocate global memory

		; Loop input paramters
		For k, v in objParam
		{
			If IsObject(v) {
				For i, FileName in v
				{
					str := BoundaryLine . CRLF
					     . "Content-Disposition: form-data; name=""" . k . """; filename=""" . FileName . """" . CRLF
					     . "Content-Type: " . this.MimeType(FileName) . CRLF . CRLF
          this.StrPutUTF8( str )
          this.LoadFromFile( Filename )
          this.StrPutUTF8( CRLF )
				}
			} Else {
				str := BoundaryLine . CRLF
				     . "Content-Disposition: form-data; name=""" . k """" . CRLF . CRLF
				     . v . CRLF
        this.StrPutUTF8( str )
			}
		}

		this.StrPutUTF8( BoundaryLine . "--" . CRLF )

    ; Create a bytearray and copy data in to it.
    retData := ComObjArray( 0x11, this.Len ) ; Create SAFEARRAY = VT_ARRAY|VT_UI1
    pvData  := NumGet( ComObjValue( retData ) + 8 + A_PtrSize )
    DllCall( "RtlMoveMemory", "Ptr",pvData, "Ptr",this.Ptr, "Ptr",this.Len )

    this.Ptr := DllCall( "GlobalFree", "Ptr",this.Ptr, "Ptr" )                   ; free global memory 

    retHeader := "multipart/form-data; boundary=----------------------------" . Boundary
	}

  StrPutUTF8( str ) {
    Local ReqSz := StrPut( str, "utf-8" ) - 1
    this.Len += ReqSz                                  ; GMEM_ZEROINIT|GMEM_MOVEABLE = 0x42
    this.Ptr := DllCall( "GlobalReAlloc", "Ptr",this.Ptr, "UInt",this.len + 1, "UInt", 0x42 )   
    StrPut( str, this.Ptr + this.len - ReqSz, ReqSz, "utf-8" )
  }
  
  LoadFromFile( Filename ) {
    Local objFile := FileOpen( FileName, "r" )
    this.Len += objFile.Length                     ; GMEM_ZEROINIT|GMEM_MOVEABLE = 0x42 
    this.Ptr := DllCall( "GlobalReAlloc", "Ptr",this.Ptr, "UInt",this.len, "UInt", 0x42 )
    objFile.RawRead( this.Ptr + this.Len - objFile.length, objFile.length )
    objFile.Close()       
  }

	RandomBoundary() {
		str := "0|1|2|3|4|5|6|7|8|9|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z"
		Sort, str, D| Random
		str := StrReplace(str, "|")
		Return SubStr(str, 1, 12)
	}

	MimeType(FileName) {
		n := FileOpen(FileName, "r").ReadUInt()
		Return (n        = 0x474E5089) ? "image/png"
		     : (n        = 0x38464947) ? "image/gif"
		     : (n&0xFFFF = 0x4D42    ) ? "image/bmp"
		     : (n&0xFFFF = 0xD8FF    ) ? "image/jpeg"
		     : (n&0xFFFF = 0x4949    ) ? "image/tiff"
		     : (n&0xFFFF = 0x4D4D    ) ? "image/tiff"
		     : "application/octet-stream"
	}

}

