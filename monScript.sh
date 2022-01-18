#!/bin/bash

echo "Le paramètre 1 est $1"
echo "Le paramètre 2 est $2"

type=$1
nom=$2

echo $type
echo $nom

country="Country"
continent="Continent"

i=1

function graph() {
	gnuplot -e "reset;
	set terminal png;
	set output 'Resultats/$1/conso.png';
	set datafile separator ',';
	set xlabel 'Années';
	set ylabel 'Consommation';
	set title 'Conso par an  de : $1';
	plot 'Resultats/$1/conso.csv' u 1:2 w l title '$1' ;
	"
}

# grapher un histogramme
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
	# lt 2 --> couleur verte
	# xtic(1) --> mettre la colonne 1 en intitulés d'abscisse
}

if [[ "$type" = "$country" ]];then # si param 1 = Country
	while [[ `head -1 Sources/Country_Consumption_TWH.csv | cut -d',' -f"$i"` ]]
	do
		if [[ "$nom" = `head -1 Sources/Country_Consumption_TWH.csv | cut -d',' -f"$i"` ]];then
			if [ -d Resultats ];then
				echo "Le dossier Resultats existe déjà"
				cd Resultats
				if [ -d "$nom" ];then
					echo "Le dossier "$nom" existe déjà !"
				else
					mkdir "$nom"
				fi
				cd ..
			else
				mkdir -p Resultats/"$nom"
			fi
			cut -d',' -f1,"$i" Sources/Country_Consumption_TWH.csv > Resultats/"$nom"/conso.csv
			graph $nom
			break
		else
			let "i++"
		fi
	done
elif [[ "$type" = "$continent" ]];then # si param 1 = Continent
	while [[ `head -1 Sources/Continent_Consumption_TWH.csv | cut -d',' -f"$i"` ]]
	do
		if [[ "$nom" = `head -1 Sources/Continent_Consumption_TWH.csv | cut -d',' -f"$i"` ]];then
			if [ -d Resultats ];then
				echo "Le dossier Resultats existe déjà"
				cd Resultats
				if [ -d "$nom" ];then
					echo "Le dossier "$nom" existe déjà !"
				else
					mkdir "$nom"
				fi
				cd ..
			else
				mkdir -p Resultats/"$nom"
			fi
			cut -d',' -f1,"$i" Sources/Continent_Consumption_TWH.csv > Resultats/"$nom"/conso.csv
			graph $nom
			break
		else
			let "i++"
		fi
	done
elif [[ "$type" = "Renouv_par_pays" ]];then # si param 1 = Renouv_par_pays
	nom_dossier="Renouvelables"
	if [ -d Resultats ];then
		echo "Le dossier Resultats existe déjà"
		cd Resultats
		if [ -d "$nom_dossier" ];then
			echo "Le dossier '$nom_dossier' existe déjà !"
		else
			mkdir $nom_dossier
		fi
		cd ..
	else
		mkdir -p Resultats/$nom_dossier
	fi
	cut -d',' -f1,6 Sources/top20CountriesPowerGeneration.csv > Resultats/"$nom_dossier"/prod.csv
	graphisto $nom_dossier

elif [[ "$type" = "Renouvelable" ]];then
	pays=`sort -t',' -k6nr Sources/top20CountriesPowerGeneration.csv | head -1 | cut -d',' -f1`
	res=`sort -t',' -k6nr Sources/top20CountriesPowerGeneration.csv | head -1 | cut -d',' -f6`
	echo "$pays : $res TWh"
elif [[ "$type" = "Non_Renouvelable" ]];then
	pays=`sort -t',' -k6n Sources/top20CountriesPowerGeneration.csv | head -2 | tail -1 | cut -d',' -f1`
	res=`sort -t',' -k6n Sources/top20CountriesPowerGeneration.csv | head -2 | tail -1 | cut -d',' -f6`
	echo "$pays : $res TWh"
else
	echo "Recommence t'as écris de la merde frérot !"
fi


