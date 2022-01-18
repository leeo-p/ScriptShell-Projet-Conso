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

if [[ "$type" = "$country" ]];then
	while [[ `head -1 Sources/Country_Consumption_TWH.csv | cut -d',' -f"$i"` ]]
	do
		if [[ "$nom" = `head -1 Sources/Country_Consumption_TWH.csv | cut -d',' -f"$i"` ]];then
			if [ -d Resultats ];then
				echo "Le dossier Resultats existe déjà"
				if [ -d "$nom" ];then
					echo "Le dossier "$nom" existe déjà !"
				else
					mkdir Resultats/"$nom"
				fi
			else
				mkdir Resultats
				if [ -d "$nom" ];then
					echo "Le dossier existe déjà !"
				else
					mkdir -p Resultats/"$nom"
				fi
			fi
			cut -d',' -f1 Sources/Country_Consumption_TWH.csv > Resultats/"$nom"/conso.csv
			cut -d',' -f"$i" Sources/Country_Consumption_TWH.csv >> Resultats/"$nom"/conso.csv
			break
		else
			let "i++"
		fi
	done
else
	echo "Recommence t'as écris de la merde frérot !"
fi
if [[ "$type"="$continent" ]];then
	while [[ `head -1 Sources/Continent_Consumption_TWH.csv | cut -d',' -f"$i"` ]]
	do
		if [[ "$nom" = `head -1 Sources/Continent_Consumption_TWH.csv | cut -d',' -f"$i"` ]];then
			if [ -d Resultats ];then
				echo "Le dossier Resultats existe déjà"
				if [ -d "$nom" ];then
					echo "Le dossier "$nom" existe déjà !"
				else
					mkdir Resultats/"$nom"
				fi
			else
				mkdir Resultats
				if [ -d "$nom" ];then
					echo "Le dossier existe déjà !"
				else
					mkdir -p Resultats/"$nom"
				fi
			fi
			cut -d',' -f1 Sources/Continent_Consumption_TWH.csv > Resultats/"$nom"/conso.csv
			cut -d',' -f"$i" Sources/Continent_Consumption_TWH.csv >> Resultats/"$nom"/conso.csv
			break
		else
			let "i++"
		fi
	done
else
	echo "Recommence t'as écris de la merde frérot !"
fi
