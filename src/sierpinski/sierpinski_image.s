/*
Implementation en C:
void sierpinskiImage(uint32_t x, uint32_t y, uint32_t size, Image& img, Pixel color) {
    // vérifier les bornes
    if (x >= img.largeur || y >= img.hauteur) return;

    // Cas de base: dessiner un seul pixel
    if (size == 1) {
        img.pixels[y][x] = color;
        return;
    }

    uint32_t half = size / 2;

    // Triangle en bas à gauche
    sierpinskiImage(x, y + half, half, img, color);
    // Triangle en bas à droite
    sierpinskiImage(x + half, y + half, half, img, color);
    // Triangle du haut
    sierpinskiImage(x + half / 2, y, half, img, color);
}

L’algorithme fonctionne mieux avec des tailles puissances de 2.
L’appel de la fonction dans le main sera ainsi : sierpinskiImage(0, 0, 1024, img, color);
*/

.data 

.text 
.globl sierpinskiImage                      

sierpinskiImage:
    pushl %ebp
    movl  %esp, %ebp

    pushl %ebx
    pushl %esi
    pushl %edi

    movl 8(%ebp),  %eax        # eax = x
    movl 12(%ebp), %ebx        # ebx = y
    movl 16(%ebp), %esi        # esi = size
    movl 20(%ebp), %edx        # edx = &img

    movl 0(%edx), %edi
    cmpl %edi, %eax
    jae finish
    movl 4(%edx), %edi
    cmpl %edi, %ebx
    jae finish

    cmpl $1, %esi
    jne do_recurse

base:
    movl 20(%ebp), %edx        # recharge &img
    movl 8(%edx),  %edi        # edi = Pixel**
    movl (%edi, %ebx, 4), %edi # edi = pixels[y]
    leal (%edi, %eax, 4), %edi # edi = &pixels[y][x]
    movl 24(%ebp), %ecx        # ecx = color
    movl %ecx, (%edi)
    jmp finish

do_recurse:
    # half = size / 2
    movl 16(%ebp), %esi
    shrl $1, %esi              # esi = half

    # Triangle bas gauche : sierpinskiImage(x, y+half, half, img, color)
    pushl 24(%ebp)             # color
    pushl 20(%ebp)             # img
    pushl %esi                 # half
    movl 12(%ebp), %ecx
    addl %esi, %ecx            # y + half
    pushl %ecx
    pushl 8(%ebp)              # x
    call sierpinskiImage
    addl $20, %esp

    # Recharge après appel récursif
    movl 8(%ebp),  %eax        # x
    movl 12(%ebp), %ebx        # y
    movl 16(%ebp), %esi
    shrl $1, %esi              # half

    # Triangle bas droite : sierpinskiImage(x+half, y+half, half, img, color)
    pushl 24(%ebp)             # color
    pushl 20(%ebp)             # img
    pushl %esi                 # half
    movl %ebx, %ecx
    addl %esi, %ecx            # y + half
    pushl %ecx
    movl %eax, %ecx
    addl %esi, %ecx            # x + half
    pushl %ecx
    call sierpinskiImage
    addl $20, %esp

    # Recharge après appel récursif
    movl 8(%ebp),  %eax        # x
    movl 12(%ebp), %ebx        # y
    movl 16(%ebp), %esi
    shrl $1, %esi              # half

    # --- Triangle haut : sierpinskiImage(x+half/2, y, half, img, color) ---
    pushl 24(%ebp)             # color
    pushl 20(%ebp)             # img
    pushl %esi                 # half
    pushl %ebx                 # y
    movl %esi, %ecx
    shrl $1, %ecx              # half/2
    addl %eax, %ecx            # x + half/2
    pushl %ecx
    call sierpinskiImage
    addl $20, %esp

finish:
    popl %edi
    popl %esi
    popl %ebx
    leave
    ret
