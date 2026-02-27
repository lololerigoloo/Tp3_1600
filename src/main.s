/*
    Vous pouvez modifier le liens des images. SVP mettre leur source si pris en ligne.

    Commandes:

	make : compile le projet en générant l’exécutable principal.
	make run : compile le projet (si nécessaire) puis exécute l’application.
	make test : lance la suite de tests prévue pour vérifier le bon fonctionnement des fonctions et filtres implémentés.
	make remise : crée un fichier zip contenant l’ensemble des fichiers nécessaires pour la remise du projet, prêt à être soumis.

*/

.data 

inputCrt: 
    .asciz "images/screenshot_e50-the-legend-of-zelda-exploring-hyrule.png"
outputCrt:
    .asciz "crt.png"
outputSierpinski:
    .asciz "sierpinski.png"


.text 
.globl main                      

main:
    # prologue
    pushl %ebp                      
    movl  %esp, %ebp

    # struct Image = largeur(4) + hauteur(4) + Pixel**(4) = 12 octets
    subl $24, %esp
    # [ebp-12] = imgCrt
    # [ebp-24] = imgSierpinski

    #################### Filtre CRT #######################

    # TODO: Charger l'image inputCrt en appelant loadImage()
    # loadImage(filename, &img)  ← filename EN PREMIER
    leal -12(%ebp), %eax
    pushl %eax                  # arg2 : &imgCrt
    leal inputCrt, %eax
    pushl %eax                  # arg1 : filename
    call loadImage
    addl $8, %esp

    # TODO: Appliquer le filtre crtFilter() sur cette image
    pushl $4                    # scanlineSpacing
    leal -12(%ebp), %eax
    pushl %eax
    call crtFilter
    addl $8, %esp

    # TODO: Sauvegarder cette image dans le fichier outputCrt avec saveImage()
    # saveImage(filename, &img)  ← filename EN PREMIER
    leal -12(%ebp), %eax
    pushl %eax                  # arg2 : &imgCrt
    leal outputCrt, %eax
    pushl %eax                  # arg1 : filename
    call saveImage
    addl $8, %esp

    # TODO: Libérer la mémoire de vos images avec freeImage()
    leal -12(%ebp), %eax
    pushl %eax
    call freeImage
    addl $4, %esp

#################### Triangle de Sierpinski #######################

    # TODO: Créer une image vide de taille d'une puissance de 2 en appelant createImage()
    # pointeur retour en premier, puis width, puis height
    # ret $0x4 dans createImage nettoie le pointeur retour automatiquement
    pushl $2048                 # height (arg3)
    pushl $2048                 # width  (arg2)
    leal -24(%ebp), %eax
    pushl %eax                  # pointeur retour (arg1)
    call createImage
    addl $8, %esp               # nettoie seulement width + height

    # TODO: Dessiner le triangle de Sierpinski avec la fonction récursive sierpinskiImage()
    # sierpinskiImage(0, 0, 1024, &img, color)
    # color = {r=227, g=171, b=59, a=255} = 0xFF3BABE3
    pushl $0x960000FF          # color
    leal -24(%ebp), %eax
    pushl %eax                  # &imgSierpinski
    pushl $2048                 # size
    pushl $0                    # y
    pushl $0                    # x
    call sierpinskiImage
    addl $20, %esp

    # TODO: Sauvegarder cette image dans le fichier outputSierpinski avec saveImage()
    leal -24(%ebp), %eax
    pushl %eax                  # arg2 : &imgSierpinski
    leal outputSierpinski, %eax
    pushl %eax                  # arg1 : filename
    call saveImage
    addl $8, %esp

    # TODO: Libérer la mémoire de vos images avec freeImage()
    leal -24(%ebp), %eax
    pushl %eax
    call freeImage
    addl $4, %esp

    movl $0, %eax
    # epilogue
    leave
    ret
