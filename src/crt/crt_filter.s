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
    pushl   %ebp                      
    movl    %esp, %ebp    
    
     
    pushl %ebx
    pushl %esi
    pushl %edi

    movl 8(%ebp), %ebx # adresse de l'image        
    addl $4, %ebx # passer à la largeur de l'image
    movl (%ebx), %edi # largeur de l'image
    addl $4, %ebx # passer à la hauteur de l'image
    movl (%ebx), %ebx # hauteur de l'image
    addl $4, %esi # passer à l'adresse du tableau de pixels
    

    
    # esi = adresse du tableau de pixels
    # ebx = hauteur de l'image y
    # edi = largeur de l'image x
    /*
    ##################################################################
    # Ici on fait une double boucle pour parcourir tous les pixels   #
    # La boucle externe parcourt les lignes (y) et la boucle interne #
    # parcourt les colonnes (x) de chaque ligne.                     #
    # avant de rentrer dans la boucle on enleve 1 à la hauteur et    #
    # à la largeur pour faire un index de 0 à n-1                    #
    # et éviter les index hors limites                               #
    ##################################################################
    */
    subl $1, %ebx # décrémenter la hauteur pour l'index de ligne
    subl $1, %edi # décrémenter la largeur pour l'index de colonne

    
        for_y:  
            
            
            for_x:
                /*
                #########################################################################
                # Ici nous allons devoir calculer l'adresse du pixel actuel en          # 
                #fonction de l'index de ligne (y) et de l'index de colonne (x)          #
                # L'adresse du pixel peut être calculée avec la formule suivante        #
                #: adresse_pixel = adresse_tableau_pixels + (y * largeur_image + x) * 3 #
                # Ensuite on va devoir faire le y % scanlineSpacing pour déterminer     #
                # si on doit appliquer applyScanline ou applyPhosphor                    #
                #########################################################################
                */
                
                movl 12(%ebp), %eax # charger scanlineSpacing
                divl %ebx # diviser la hauteur par scanlineSpacing
                testl %edx, %edx # vérifier si le reste est zéro (ligne)
                jz apply_scanline # si c'est un multiple, appliquer applyScanline
                jmp end_apply_phosphor # sinon, appliquer applyPhosphor
                apply_scanline:
                    pushl $60 # pourcentage d'assombrissement
                    lea (%esi), %eax # charger l'adresse du pixel
                    pushl %eax # pousser l'adresse du pixel pour l'appel de fonction
                    call applyScanline
                    addl $8, %esp # nettoyer la pile après l'appel
                    jmp end_for_x # passer à la prochaine colonne
                end_apply_phosphor:
                /*
                #############################################################
                # Ici on vien faire le x % 3 pour déterminer le subpixel    #
                # et faire l'appel à applyPhosphorEnsuite on netoit la pile #
                #############################################################
                */
                    movl %edi, %eax 
                    divl $3
                    pushl %edx 
                    push %esi
                    call applyPhosphor
                    addl $8, %esp  
                    
            /*
            ################################################################
            # Ici on check si on est rendu a x -1 pour sortir de la boucle #
            ################################################################
            */
            subl $1, %edi # décrémenter la largeur pour l'index de colonne
            cmp $-1, %edi # vérifier si on a traité toutes les colonnes
            jne for_x # si on a traité toutes les colonnes, sortir de la boucle
            
            end_for_x:


            /*
            ################################################################################
            # Ici on check si on est rendu a y -1 pour sortir de la boucle                 #
            # et on revient chercher la largeur de l'image pour le prochain tour de boucle #
            ################################################################################
            */

            movl 8(%ebp), %edi# recharger l'adresse du tableau de pixels
            addl $4, %edi # ici on reviens chercher la largeur de l'image
            movl (%edi), %edi # largeur de l'image
            subl $1, %edi # décrémenter la largeur pour pas faire un index hors limite pour le prochain tour de boucle
 
             
            subl $1, %ebx # décrémenter la hauteur pour l'index de ligne
            cmp $-1, %ebx # décrémenter la hauteur pour l'index de ligne
            jne for_y # si on a traité toutes les lignes, sortir de la boucle


        end_for_y:

    finish:
    popl %edi
    popl %esi
    popl %ebx

    # TODO
   
    # epilogue
    leave 
    ret 

