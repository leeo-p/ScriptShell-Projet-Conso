#!/bin/bash

echo "Le paramètre est $1"

pays=$1
echo $pays

i=0

while [ true ]
do
	colonne=`head -1 Sources/Country_Consumption_TWH.csv | cut -d',' -f$i` 
	if [ $pays=$colonne ];then
		cut -d',' -f$i Sources/Country_Consumption_TWH.csv > conso.csv
		break
	else
		$i=$i+1
	fi
done

if [ -d Resultats ];then
	echo "Le dossier Resultat existe déjà"
	if [ -d $pays ];then
		echo "Le dossier $pays existe déjà !"
	else 
		mkdir Resultats/$pays
	fi
else 
	mkdir Resultats
	if [ -d $pays ];then
		echo "Le dossier existe déjà !"
	else 
		mkdir Resultats/$pays
	fi
fi


