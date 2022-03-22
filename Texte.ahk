#include <Util>

; faire un sorted 

supprime_double_line(fichier)
{
	output = 
	loop, read, % fichier
	{
		If output not contains %A_LoopReadLine%`n
			output .= A_LoopReadLine . "`n"
	}
	return output
}

supprime_double_line_var(var)
{
	output := 
	loop, parse, var, "`n"
	{
		If output not contains %A_LoopField%
			output .= A_LoopField . "`n"
	}
	return output
}

prend_le_fichier(fichier, ignoreBlank:=false)
{
	string :=
	Loop, read, % fichier
	{
		if (ignoreBlank && (A_LoopReadLine = "" || A_LoopReadLine = "`n")) {
			continue
		}
		string .= A_LoopReadLine . "`n"
		; Loop, parse, A_LoopReadLine
		; {
			; string .= A_LoopField
		; }
	}
	return string
}

restreint_caractere(texte, whitelist)
{
	string :=
	Loop, parse, texte
	{
		if (InStr(whitelist, A_LoopField)) {
			string .= A_LoopField
		}
	}
	return string
}

; debut_texte=0 On commence Ã  partir de la fin
InStrLast(texte, recherche, debut_texte:=1)
{
	return InStr(texte, recherche,, debut_texte) + StrLen(recherche)
}

; retourne un tableau
prend_une_chaine(texte, recherche_debut, recherche_fin, debut_texte:=1, decalage_recherche_debut:=0, decalage_recherche_fin:=0)
{
	debut := InStrLast(texte, recherche_debut, debut_texte) + decalage_recherche_debut
	fin := InStr(texte, recherche_fin,, debut) + decalage_recherche_fin
	return [SubStr(texte, debut, fin - debut), debut]
}

texte_index(texte, index, longueur=1)
{
	if (index < 0) {
		return SubStr(texte, StrLen(texte) - index - longueur, longueur)
	}
	return SubStr(texte, index, longueur)
}

texte_mult(texte, n)
{
	if (n <= 0) {
		; msgbox if (n <= 0) {
		return ""
	}
	else if (n == 1) {
		return texte
	}
	string := texte
	i = 1
	while (i < n) {
		string .= texte
		i++
	}
	return string
}

texte_count(texte, mot) {
	if (texte = "") {
		return 0
	}
	return StrSplit(texte, mot).Length() - 1
}

texte_index_enclose(texte, caractereStart, debut:=1, caractereEnd:="")
{
	double := {"(":")", ")":"(", "[":"]", "]":"[", "{":"}", "}":"{"}
	if (!caractereEnd) {
		caractereEnd := double[caractereStart]
	}
	texte_analyse := SubStr(texte, debut)
	count := 0
	start := false
	; msgbox |%caractereStart%| |%caractereEnd%| %debut%
	Loop, parse, % texte_analyse
	{
		if (!start && A_LoopField == caractereStart) {
			count++
			start := true
			go := A_Index - 1
			; msgbox % "0- " . count  . " " . A_LoopField . " " . A_Index . "`n" . substr(texte, go + debut, 100)
		}
		else if (start) {
			if (A_LoopField == caractereStart) {
				count++
				; msgbox % "1- " . count  . " " . A_LoopField . " " . A_Index . "`n" . substr(texte, go + debut, 100)
			}
			if (A_LoopField == caractereEnd) {
				count--
				; msgbox % "2- " . count  . " " . A_LoopField . " " . A_Index . "`n" . substr(texte, go + debut, 100)
			}
			if (count == 0) {
				; msgbox % "fin- " . count  . " " . A_LoopField . " " . A_Index . "`n" . substr(texte, go + debut, 100)
				; msgbox % substr(texte_analyse, go + debut, A_Index - go)
				return [go + debut, A_Index, A_Index - go]
			}
		}
	}
	; msgbox count %count%
	; msgbox % substr(texte, go + debut, A_Index - go)
	return [go + debut, A_Index, A_Index - go]
}

texte_put_var(nom_variable, valeur, fichier, dict_ligne_var:="")
{
	if (dict_ligne_var) {
		ligne := dict_ligne_var[nom_variable]
		if (!ligne) {
			dict_ligne_var[nom_variable] := util_dict_maxValue(dict_ligne_var) + 1
			ligne := dict_ligne_var[nom_variable]
		}
	}
	
	if (valeur = "") {
		valeur = 0
	}
	file := ""
	fileEnd := ""
	ok := false
	Loop, read, %fichier%
	{
		; pause
		save := A_index
		if (dict_ligne_var) {
			if (A_index > ligne) {
				fileEnd .= A_LoopReadLine . "`n"
			}
			else if (A_index == ligne) {
			
			}
			else {
				file .= A_LoopReadLine . "`n"
			}
		}
		else {
			if (ok) {
				fileEnd .= A_LoopReadLine . "`n"
			}
			else if (InStr(A_LoopReadLine, nom_variable)) {
				nom := StrSplit(A_LoopReadLine, "`t")
				if (nom[2] = nom_variable) {
					ok := true
					; file .= valeur . "`t" . nom_variable . "`n"
				}
				else {
					file .= A_LoopReadLine . "`n"
				}
			}
			else {
				file .= A_LoopReadLine . "`n"
			}
		}
	}
	save++
	while (save < ligne) {
		file .= "`n"
		save++
	}
	file .= valeur . "`t" . nom_variable . "`n" . fileEnd
	FileDelete, %fichier%
	FileAppend, %file%, %fichier%
}

texte_get_var(nom_variable, fichier, dict_ligne_var:="", colonne:=1)
{
	if (!dict_ligne_var) {
		varFind := true
	}
	ligne := dict_ligne_var[nom_variable]
	Loop, read, %fichier%
	{
		if (varFind) {
			if (InStr(A_LoopReadLine, nom_variable)) {
				nom := StrSplit(A_LoopReadLine, "`t")
				if (nom[2] = nom_variable) {
					return nom[colonne]
				}
			}
		}
		else {
			if (A_index = ligne) {
				if (colonne = 0) {	; retourne la ligne
					return A_LoopReadLine
				}
				else if (colonne = 1) {	; retourne la valeur de la nom_variable
					val := SubStr(A_LoopReadLine, 1, InStr(A_LoopReadLine, "`t") - 1)
					if (val = "") {
						return 0
					}
					return val
				}
				else if (colonne = 2) {	; retourne le nom de la nom_variable
					return SubStr(A_LoopReadLine, InStr(A_LoopReadLine, "`t")+1, StrLen(A_LoopReadLine))
				}
			}
		}
	}
	return 0
}

texte_incr_var(nom_variable, fichier, dict_ligne_var:="") {
	if (dict_ligne_var) {
		valeur := texte_get_var(nom_variable, fichier, dict_ligne_var)
	}
	else {
		valeur := texte_get_var(nom_variable, fichier)
	}
	if (!valeur) {
		valeur := 0
	}
	valeur++
	texte_put_var(nom_variable, valeur, fichier)
}

texte_create_dict_from_file(fichier)
{

}

texte_pick_json_txt(texte) {
	json_find := Object()
	start_file := 1
	debutJson = e.exports=JSON.parse('
	while (true) {
		; msgbox start_file %start_file%
		start_enclose := InStrLast(texte, debutJson, start_file)
		if (start_enclose < save) {
			break
		}
		save := start_enclose
		; msgbox % substr(texte, start_enclose, 1000)
		charactere_enclose := substr(texte, start_enclose, 1)
		; msgbox charactere_enclose %charactere_enclose%
		end_enclose := texte_index_enclose(texte, charactere_enclose, start_enclose)
		; msgbox % end_enclose[1]
		; msgbox % end_enclose[2]
		; msgbox % end_enclose[3]
		; clipboard := substr(html_texte, end_enclose[1], end_enclose[3])
		json_txt := substr(texte, end_enclose[1], end_enclose[3])
		json_find.Push(json_txt)
; msgbox % json_find.Length() . "`n" . json_txt
		start_file := end_enclose[1] + end_enclose[2]
	}
	return json_find
}