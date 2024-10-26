with Ada.Text_IO;
use Ada.Text_IO;
with Ada.Integer_Text_IO;
use Ada.Integer_Text_IO;
with Alea;

--------------------------------------------------------------------------------
--  Auteur   : Arthur SAUVEZIE
--  Objectif : Permettre à un joueur humain d'affronter une machine aujeu des 13 Allumettes
--------------------------------------------------------------------------------

procedure Allumettes is

	ALL_INITIAL : Constant Integer :=13;   	--Nombre d'Allumettes initiales
	ALL_PRENABLES : Constant Integer :=3;  	--Nombre d'Allumettes prenables
	NBR_LIGNES_ALL : Constant Integer :=3; 	--Nombre de lignes nécéssaires au dessin des Allumettes
	NBR_PAQUET_ALL : Constant Integer :=5; 	--Nombre d'allumettes par paquet

        Choix : Character;                     	-- Enregistre le choix du joueur quand au commencement
        All_Retirees : Integer ;        	-- Nombre d'allumettes retirées à l'issu d'un tour
        All_Restantes : Integer;        	-- Nombre d'allumettes restantes
        Difficulte : Character;         	-- Enregistre le difficulté choisie par le joueur
        Nbr_Tour : Integer :=0 ;        	-- Compteur de Tours
        All_mod : Integer;              	-- Modulo du nombre d'allumettes pour tour expert
        Tour_correct : Boolean;   	     	--Permet de valider qu'un tour est correct

	package P_Alea is			--Gestion de l'Aléatoire
		new Alea (1, ALL_PRENABLES);
	use P_Alea;

begin
        --Permettre au joueur de choisir le niveau de difficulté
        Put("Niveau de l'ordinateur (n)aïf, (d)istrait, (r)apide ou (e)xpert ? ");
        Get(Difficulte);
	
	--Confirmer le niveau souhaité
	Put("Mon niveau est ");
	case Difficulte is
		when 'n'|'N' =>Put_Line("naïf.");
		when 'd'|'D' =>Put_Line("distrait.");
		when 'r'|'R' =>Put_Line("rapide.");
		when others =>Put_Line("expert.");
	end case;

	--Permettre au joueur de choisir s'il commence
        Put("Est-ce que vous commencez (o/n) ? ");
        Get(Choix);
        If Choix = 'o'or Choix = 'O' then
                null;
        Else -- L'ordinateur joue même si l'utilisateur entre autre chose que n ou N
                Nbr_Tour := 1;
        End If;

        --Initialiser le jeu
        All_Restantes := ALL_INITIAL;
        Loop 
                --Afficher le Plateau
		New_Line;
                For I in 1..NBR_LIGNES_ALL loop -- Pour faire dessiner les allumettes sur NBR_LIGNES_ALL lignes 
			For J in 1..All_Restantes loop -- Pour faire chaque allumette
                                if J < All_Restantes then

					Put("| ");
                                	If J mod NBR_PAQUET_ALL = 0 then  -- Pour gérer les espacements entre les paquets d'allumettes
                                        	Put("  ");
                               	 	Else 
                                        	null;
                                	End If;
				Else 
					Put("|");
				End if;
                        End Loop;
               		 Put_Line(""); --Revenir à la ligne
                End Loop;
		--Put_Line("");
                exit when All_Restantes < 1; --Fin du jeu
		Put_Line("");
                
                --Jouer au Jeu
                If Nbr_Tour mod 2 = 0 then

                        --Enregistre le tour Joueur
                        Tour_correct := False; --Permet de tester si la valeur entrée est correcte
                        loop
                                Put("Combien d'allumettes prenez-vous ? "); 
                                Get(All_Retirees);
                                If All_Retirees > ALL_PRENABLES then
                                        Put("Arbitre : Il est interdit de prendre plus de ");
                                        Put(ALL_PRENABLES,1);
                                        Put_Line(" allumettes.");
                                Elsif All_Retirees < 1 then
                                        Put_Line("Arbitre : Il faut prendre au moins une allumette.");
                                Elsif All_Retirees >All_Restantes then
					If All_restantes = 1 then
						Put_Line("Arbitre : Il reste une seule allumette.");
					Else	
                                        	Put("Arbitre : Il reste seulement ");
						Put(All_Restantes,1);
						Put_Line(" allumettes.");
					End If;
                                Else 
                                        All_Restantes := All_Restantes - All_retirees; --Mise à jour du jeu à la fin du tour
                                        Tour_correct := True;
                                End If;
                                exit when Tour_correct;
                        end loop;
                        
                 Else       

                        --Enregistre le tour Ordinateur
                        All_Retirees := 0;
                        case Difficulte is

				--Jouer tour Naïf
                                when 'n'|'N' =>
                                        If All_Restantes < ALL_PRENABLES +1  then
                                                loop -- Boucle forcant le nombre aléatoire à être dans un intervalle définit sans avoir à créér un package supplémentaire
							P_Alea.Get_Random_Number (All_Retirees);
							exit when All_Retirees < All_Restantes+1;
						end loop;
                                        Else
						loop
							P_Alea.Get_Random_Number (All_Retirees);
							exit when All_Retirees < ALL_PRENABLES+1;
						end loop;
                                        End If;

				--Jouer tour Distrait		
                                when 'd'|'D' => 
					loop 
						P_Alea.Get_Random_Number (All_Retirees);
						If All_Retirees>All_Restantes then --Spécificité du tour distrait,il peut prendre trop d'allumettes en fin de jeu.
							Put("Je prends ");
							Put(All_Retirees,1);
							Put_Line(" allumettes.");
							Put("Arbitre : il ne reste que ");
							Put(All_Restantes,1);
							Put_Line(" Allumettes");
						else
							null;
						end If;
						exit when All_Retirees < All_Restantes  +1;
					end loop;

				--Jouer tour Rapide	
                                when 'r'|'R' => 
                                        If All_Restantes < ALL_PRENABLES +1 then
                                                All_Retirees := All_Restantes;
					else 
                                                All_Retirees := ALL_PRENABLES;
                                        end if;

				--Jouer tour Expert	
                                when others =>
					All_mod := (All_Restantes - 1 ) mod (ALL_PRENABLES+1);
					All_Retirees := Integer'Max(1, All_mod);
                        end case;
			Put("Je prends "); --Affichage du tour Ordinateur
			Put(All_Retirees,1);
			Put_Line(" allumettes.");
                        All_Restantes := All_restantes - All_Retirees; --Mise à jour du jeu en fin de tour
                End If;
                Nbr_Tour := Nbr_Tour + 1;
        end Loop;

        --Afficher le vainqueur
        if Nbr_Tour mod 2 = 0 then
                Put("Vous avez gagné.");
        else
                Put("J'ai gagné.");
        end if;
end Allumettes;
