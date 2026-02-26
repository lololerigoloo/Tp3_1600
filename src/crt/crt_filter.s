/*
Signature : void crtFilter(Image& img, int scanlineSpacing)

Paramètres :
img : la référence vers l’image à modifier (sur place)
scanlineSpacing : espacement entre les lignes que l’on va dessiner sur l’image pour l’effet CRT


Description : Cette fonction applique un filtre global à une image afin de reproduire l’apparence d’un ancien écran CRT. Elle combine les deux fonctions précédentes.
Il faut parcourir TOUS les pixels et appliquer les traitements suivants:
1.	Appeler applyScanline() 
    	Si la ligne y est un multiple de scanlineSpacing on applique un assombrissement de 60 %.

2.	Appler applyPhosphor()
        Le paramètre subpixel est déterminé par la position horizontale du pixel : x % 3

*/
.data   

full_color:
    .int 100

less_color:
    .int 60

max_index:
    .int 3

.text 
.globl crtFilter     
crtFilter:
    # prologue
    pushl %ebp
    movl  %esp, %ebp
    
    subl  $4, %esp          # variable locale : [ebp-4] = adresse pixel courante
    pushl %ebx
    pushl %esi
    pushl %edi

    movl 8(%ebp), %eax
    movl 0(%eax), %edi      # edi = largeur
    movl 4(%eax), %esi      # esi = hauteur  
    movl 8(%eax), %ebx      # ebx = Pixel**

    movl $0, %ecx           # ecx = y = 0
for_y:
    cmpl %esi, %ecx
    jge end_for_y

    movl $0, %edx           # edx = x = 0
for_x:
    cmpl %edi, %edx
    jge end_for_x

    # Adresse du pixel[y][x] → sauvée en variable locale
    movl (%ebx, %ecx, 4), %eax
    leal (%eax, %edx, 4), %eax
    movl %eax, -4(%ebp)     # sauvegarde adresse pixel en local

    # y % scanlineSpacing
    pushl %ecx              # sauvegarde y
    pushl %edx              # sauvegarde x
    movl %ecx, %eax
    xorl %edx, %edx
    movl 12(%ebp), %ecx
    divl %ecx               # edx = y % scanlineSpacing
    testl %edx, %edx
    popl %edx               # restaure x
    popl %ecx               # restaure y
    jnz do_phosphor

do_scanline:
    pushl %ecx
    pushl %edx
    pushl $60
    pushl -4(%ebp)
    call applyScanline
    addl $8, %esp
    popl %edx
    popl %ecx
    # PAS de jmp next_x → on tombe directement dans do_phosphor

do_phosphor:
    pushl %ecx              # sauvegarde y
    pushl %edx              # sauvegarde x

    movl %edx, %eax
    xorl %edx, %edx
    movl $3, %ecx
    divl %ecx               # edx = x % 3

    pushl %edx              # arg2 : subpixel
    pushl -4(%ebp)          # arg1 : pixel*
    call applyPhosphor
    addl $8, %esp

    popl %edx               # restaure x
    popl %ecx               # restaure y

next_x:
    incl %edx
    jmp for_x
end_for_x:
    incl %ecx
    jmp for_y
end_for_y:
    popl %edi
    popl %esi
    popl %ebx
    # epilogue
    leave
    ret

