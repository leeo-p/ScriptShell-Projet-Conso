#!/bin/bash

echo "Le paramètre est $1"

pays=$1
echo $pays

i=1

while [[ `head -1 Sources/Country_Consumption_TWH.csv | cut -d',' -f"$i"` ]]
do
	if [[ "$pays" = `head -1 Sources/Country_Consumption_TWH.csv | cut -d',' -f"$i"` ]];then
		if [ -d Resultats ];then
			echo "Le dossier Resultat existe déjà"
			if [ -d "$pays" ];then
				echo "Le dossier "$pays" existe déjà !"
			else
				mkdir Resultats/"$pays"
			fi
		else
			mkdir Resultats
			if [ -d "$pays" ];then
				echo "Le dossier existe déjà !"
			else
				mkdir Resultats/"$pays"
			fi
		fi
		cut -d',' -f"$i" Sources/Country_Consumption_TWH.csv > Resultats/"$pays"/conso.csv
		break
	else
		let "i++"
	fi
done
