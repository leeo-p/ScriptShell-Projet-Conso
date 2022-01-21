#!/bin/bash

#-------------------------------------------------------Projet de ScriptShell-------------------------------------------------------#
#-----Réalisé par Laura Sabadie & Léo Portet----------------------------------------------------------------------------------------#
#-----Réalisé du 10/01/21 au 21/01/21-----------------------------------------------------------------------------------------------#
#-----Ce script vous permet de réaliser un traitement de données, de les répertorier et d'en faire des graphiques-------------------#
#-----------------------------------------------------------------------------------------------------------------------------------#

type=$1 #variable prenant le premier paramètre qui définit si le deuxième est un continant ou un pays
nom=$2 #variable prenant le deuxième paramètre qui indique le nom du pays ou du continent

continent="Continent"

i=1 #variable d'incrémentation

#Fonction permettant de faire un graph à partir de données récupérées dans les fichiers sources
function graph() {
	gnuplot -e "reset;
	set terminal png;
	set output 'Resultats/$1/conso.png';
	set datafile separator ',';
	set xlabel 'Années';
	set ylabel 'Consommation';
	set title 'Conso par an de : $1';
	plot 'Resultats/$1/conso.csv' u 1:2 w l title '$1' ;
	"
}

#Fonction permettant de faire un graph de comparaison des différentes productions d'énergies renouvelables
function comparegraph() {
	gnuplot -e "reset; 
	set terminal png size 1920,1080;
	set output 'Resultats/$1/compare.png';
	set datafile separator ',';
	set xlabel 'Pays';
	set logscale y 10;
	set ylabel 'Production';
	set title 'Différentes Productions';
	set style data histogram;
	set boxwidth 1;
	set style fill solid border -1;
	set style histogram clustered gap 1;
	set xtics nomirror rotate by -60 scale 0;
	plot 'Resultats/$1/compare.csv' u 2:xtic(1) lt 7 title 'Hydro', 'Resultats/$1/compare.csv' u 3:xtic(1) lt 1 title 'Biofuel', 'Resultats/$1/compare.csv' u 4:xtic(1) lt 4 title 'Solar PV', 'Resultats/$1/compare.csv' u 5:xtic(1) lt 2 title 'Geothermal' ; 
	"
	#logscale y permet de mettre l'échelle en logarithmique, pour une lecture plus aisée
}

#Fonction permettant de grapher un histogramme
function graphisto() {
	gnuplot -e "reset;
	set terminal png;
	set output 'Resultats/$1/prod.png';
	set datafile separator ',';
	set xlabel 'Pays';
	set ylabel 'Production';
	set title \"Production d'énergie renouvelable par pays\";
	set style data histogram;
	set boxwidth 1;
	set style fill solid border -1;
	set style histogram clustered gap 1;
	set xtics nomirror rotate by -45 scale 0;
	plot 'Resultats/$1/prod.csv' u 2:xtic(1) lt 2 notitle;
	"
	#lt 2 sert a mettre la couleur verte
	# xtic(1) sert à mettre la colonne 1 en intitulés d'abscisse
	#xtics nomirror rotate by -45 sert à incliner de 45 degrés les noms de pays pour qu'ils soient plus lisibles
}

if [[ "$type" = "Country" ]];then #si le paramètre 1 = Country
	echo
	echo "----------------------------------"
	echo "Vous avez choisi le pays : $nom"
	echo "----------------------------------"
	while [[ `head -1 Sources/Country_Consumption_TWH.csv | cut -d',' -f"$i"` ]] #on parcours ce fichier colonne par colonne
	do
		if [[ "$nom" = `head -1 Sources/Country_Consumption_TWH.csv | cut -d',' -f"$i"` ]];then #si le paramètre 2 = nom du pays cherché
			if [ -d Resultats ];then #on vérifie si le dossier existe
				cd Resultats #si oui on rentre dedans
				if [ -d "$nom" ];then #on vérifie si le dossier du pays existe
					echo #si oui on ne fait rien
				else
					mkdir "$nom" #sinon on le crée
				fi
				cd .. #on sort du dossier Resultats
			else
				mkdir -p Resultats/"$nom" #sinon on crée récursivement les deux dossiers
			fi
			cut -d',' -f1,"$i" Sources/Country_Consumption_TWH.csv > Resultats/"$nom"/conso.csv #on crée le fichier de sortie avec les infos du pays
			graph $nom #appel de la fonction graph
			xdg-open Resultats/"$nom"/conso.png
			break #on sort de la boucle
		else
			let "i++" #on incrémente i
		fi
	done
elif [[ "$type" = "Continent" ]];then #si le paramètre 1 = Continent
	echo
	echo "---------------------------------------"
	echo "Vous avez choisi le continent : $nom"
	echo "---------------------------------------"
	while [[ `head -1 Sources/Continent_Consumption_TWH.csv | cut -d',' -f"$i"` ]] #on parcours le fichier colonne par colonne
	do
		if [[ "$nom" = `head -1 Sources/Continent_Consumption_TWH.csv | cut -d',' -f"$i"` ]];then #si le paramètre 2 = nom du continent cherché 
			if [ -d Resultats ];then #on vérifie si le dossier existe
				cd Resultats #si oui on rentre dedans
				if [ -d "$nom" ];then #on vérifie si le dossier du continent existe
					echo #si oui on ne fait rien
				else
					mkdir "$nom" #sinon on le crée
				fi
				cd .. #on sort du dossier Resultats
			else
				mkdir -p Resultats/"$nom" #sinon on crée récursivement le deux dossiers
			fi
			cut -d',' -f1,"$i" Sources/Continent_Consumption_TWH.csv > Resultats/"$nom"/conso.csv #on crée le fichier de sotie avec les infos du continent
			graph $nom #appel de la fonction graph
			xdg-open Resultats/"$nom"/conso.png
			break #on sort de la boucle
		else
			let "i++" #on incrémente i
		fi
	done
elif [[ "$type" = "Renouv_par_pays" ]];then #si le paramètre 1 = Renouv_par_pays
	echo
	echo "----------------------------------------------------"
	echo "Vous avez choisi les énergies renouvelables par pays"
	echo "----------------------------------------------------"
	nom_dossier="Renouvelables"
	#vérification de l'existence des dossiers
	if [ -d Resultats ];then
		cd Resultats
		if [ -d "$nom_dossier" ];then
			echo
		else
			mkdir $nom_dossier
		fi
		cd ..
	else
		mkdir -p Resultats/$nom_dossier
	fi
	cut -d',' -f1,6 Sources/top20CountriesPowerGeneration.csv > Resultats/"$nom_dossier"/prod.csv #on génère le fichier de sortie avec les infos attendues pour le graph
	graphisto $nom_dossier #appel de la fonction graphisto
	xdg-open Resultats/"$nom_dossier"/prod.png

elif [[ "$type" = "Energie_Compare" ]];then #si le paramètre 1 = Energie_Compare
	echo
	echo "-----------------------------------------------------------------"
	echo "Vous avez choisi le compartif des énergies renouvelables par pays"
	echo "-----------------------------------------------------------------"
	nom_dossier="Comparaison"
	#vérification de l'existance des dossiers
	if [ -d Resultats ];then
		cd Resultats
		if [ -d "$nom_dossier" ];then
			echo 
		else
			mkdir $nom_dossier
		fi
		cd ..
	else
		mkdir -p Resultats/$nom_dossier
	fi
	cut -d',' -f1-5 Sources/top20CountriesPowerGeneration.csv > Resultats/"$nom_dossier"/compare.csv #on génère le fichier de sortie avec les infos attendues pour le graph
	comparegraph $nom_dossier #appel de la fonction comparegraph
	xdg-open Resultats/"$nom_dossier"/compare.png

#Affichages terminal
elif [[ "$type" = "Renouvelable" ]];then #si le paramètre 1 = Renouvelable
	pays=`sort -t',' -k6nr Sources/top20CountriesPowerGeneration.csv | head -1 | cut -d',' -f1` #on trie le fichier pour trouver le pays
	res=`sort -t',' -k6nr Sources/top20CountriesPowerGeneration.csv | head -1 | cut -d',' -f6` #on trie le fichier pour trouver sa production
	echo
	echo "------------------------------------------------------------------------"
	echo "Le pays qui produit le plus est : $pays, en effet il produit $res TWh" #on affiche dans le terminal les éléments recherchés
	echo "------------------------------------------------------------------------"
	echo
elif [[ "$type" = "Non_Renouvelable" ]];then #si le paramètre 1 = Non_Renouvelable
	pays=`sort -t',' -k6n Sources/top20CountriesPowerGeneration.csv | head -2 | tail -1 | cut -d',' -f1` #on trie le fichier pour trouver le pays
	res=`sort -t',' -k6n Sources/top20CountriesPowerGeneration.csv | head -2 | tail -1 | cut -d',' -f6` #on trie le fichier pour trouver sa production
	echo
	echo "------------------------------------------------------------------------"
	echo "Le pays qui produit le moins est : $pays, en effet il produit $res TWh" #on affiche dans le terminal les éléments recherchés
	echo "------------------------------------------------------------------------"
	echo
else
	echo
	echo "--------------------------------------------------------------"
	echo "Veuillez recommencer le paramètre n°1 n'est pas valide, merci."
	echo "--------------------------------------------------------------"
	echo
fi
