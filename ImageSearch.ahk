/*
imagesearch_de_droite_a_gauche(x1, y1, x2, y2, image, largeur, hauteur)
{
	j := y1
	i := x2
	xx1 := x2 - largeur
	xx2 := x2
	yy1 := y1
	yy2 := y1 + hauteur
	
	; while (j <= y2) {
		; i := x2
		; xx1 := x2 - largeur
		; xx2 := x2
		; while (i >= x1) {
			; ImageSearch, image_X, image_Y, xx1, yy1, xx2, yy2, % image
			; mousemove, xx1, yy1
			; mousemove, xx2, yy2
			; if (image_X || image_Y) {
				; return [image_X, image_Y]
			; }
			; xx1 -= largeur
			; xx2 -= largeur
			; i -= largeur
		; }
		; j += hauteur
		; yy1 += hauteur
		; yy2 += hauteur
	; }

	while (i >= x1) {
		j := y1
		yy1 := y1
		yy2 := y1 + hauteur
		while (j <= y2) {
			ImageSearch, image_X, image_Y, xx1, yy1, xx2, yy2, % image
			; mousemove, xx1, yy1
			; mousemove, xx2, yy2
			; msgbox % j " " . y2
			if (image_X || image_Y) {
				return [image_X, image_Y]
			}
			j += hauteur
			yy1 += hauteur
			yy2 += hauteur
		}
		i -= largeur
		xx1 -= largeur
		xx2 -= largeur
	}
}
*/