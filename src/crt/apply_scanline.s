/*
Signature: void applyPhosphor(applyScanline& p, int percent);

Paramètres:
p : la référence vers le pixel à modifier (sur place)
percent : facteur d’assombrissement

Description : Cette fonction applique un facteur d’assombrissement à un pixel en multipliant chacune de ses composantes RGB par un pourcentage donné: nouvelle_valeur = valeur_orignale x percent / 100
*/    
.data 

percent_conversion: 
.int 100

.text 
.globl applyScanline                      

applyScanline:
    # prologue
    pushl   %ebp                      
    movl    %esp, %ebp                  

    
    # TODO
    pushl %ebx
    pushl %esi
    pushl %edi

    movl 8(%ebp), %ebx # adresse du pixel
    movl 12(%ebp), %esi # percent
    movl $3, %edi # nombre de composantes RGB
    for_loop:
    movl $0, %eax # initialiser le registre pour la multiplication
    movb (%ebx), %al # charger la composante actuelle
    mull %esi # multiplier par le pourcentage
    movl percent_conversion, %ecx # charger 100 pour la division
    divl %ecx # diviser par 100
    movb %al, (%ebx) # stocker la nouvelle valeur
    addl $1, %ebx # passer à la composante suivante
    subl $1, %edi # décrémenter le compteur de composantes
    jnz for_loop # répéter pour les 3 composantes

    popl %edi
    popl %esi
    popl %ebx
    # epilogue
    leave 
    ret   

