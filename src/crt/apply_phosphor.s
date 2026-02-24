/*
Signature: void applyPhosphor(Pixel& p, int subpixel);

Paramètres:
p : la référence vers le pixel à modifier (sur place)
subpixel : indice du pixel dominant

Description : Le paramètre subpixel détermine quelle composante reste dominante :
	si subpixel == 0 → le rouge est conservé, le vert et le bleu sont réduits à 70 % de leur valeur initiale.
	si subpixel == 1→ le vert est conservé, le rouge et le bleu sont réduits à 70 % de leur valeur initiale.
	sinon → le bleu est conservé, le rouge et le vert sont réduits à 70 % de leur valeur initiale.

Encore une fois, puisqu’on travaille avec des divisions entières, la réduction se fait avec la formule suivante : nouvelle_valeur = valeur_originale × 70 / 100


*/
.data 

offset:
    .int 3

factor:
    .int 70

percent_conversion: 
    .int 100
        
.text 
.globl applyPhosphor                      

applyPhosphor:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  
    
    pushl %ebx
    pushl %esi

    movl 8(%ebp), %ebx # adresse du pixel
    movl 12(%ebp), %esi # subpixel
    cmpl $0, %esi
    je .red_dominant
    cmpl $1, %esi
    je .green_dominant
    jmp .blue_dominant

    .red_dominant:
    # rouge dominant, réduire vert et bleu
    addl $1 , %ebx # passer à la composante verte
    movl $0, %eax # initialiser le registre pour la multiplication
    movb (%ebx), %al # charger la composante verte
    mull factor # multiplier par 70
    movl percent_conversion, %ecx # charger 100 pour la division
    divl %ecx # diviser par 100
    movb %al, (%ebx) # stocker la nouvelle valeur
    addl $1, %ebx # passer à la composante bleue
    movl $0, %eax # initialiser le registre pour la multiplication
    movb (%ebx), %al # charger la composante bleue
    mull factor # multiplier par 70
    movl percent_conversion, %ecx # charger 100 pour la division
    divl %ecx # diviser par 100
    movb %al, (%ebx) # stocker la nouvelle valeur
    jmp .done
    
    .green_dominant:
    # vert dominant, réduire rouge et bleu
    movl $0, %eax # initialiser le registre pour la multiplication
    movb (%ebx), %al # charger la composante rouge
    mull factor # multiplier par 70
    movl percent_conversion, %ecx # charger 100 pour la division
    divl %ecx # diviser par 100
    movb %al, (%ebx) # stocker la nouvelle valeur
    addl $2, %ebx # passer à la composante bleue
    movl $0, %eax # initialiser le registre pour la multiplication
    movb (%ebx), %al # charger la composante bleue
    mull factor # multiplier par 70
    movl percent_conversion, %ecx # charger 100 pour la division
    divl %ecx # diviser par 100
    movb %al, (%ebx) # stocker la nouvelle valeur
    jmp .done

    .blue_dominant:
    movl $0, %eax # initialiser le registre pour la multiplication
    movb (%ebx), %al # charger la composante rouge
    mull factor # multiplier par 70
    movl percent_conversion, %ecx # charger 100 pour la division
    divl %ecx # diviser par 100
    movb %al, (%ebx) # stocker la nouvelle valeur
    addl $1, %ebx # passer à la composante verte
    movl $0, %eax # initialiser le registre pour la multiplication
    movb (%ebx), %al # charger la composante verte
    mull factor # multiplier par 70
    movl percent_conversion, %ecx # charger 100 pour la division
    divl %ecx # diviser par 100
    movb %al, (%ebx) # stocker la nouvelle valeur
    # bleu dominant, réduire rouge et vert

    .done:
    pop %esi # subpixel
    pop %ebx # adresse du pixel
    # TODO

    # epilogue
    leave 
    ret   

