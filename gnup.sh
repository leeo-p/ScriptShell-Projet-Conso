#!/bin/bash

gnuplot -persist <<-EOFMarker
		set 
		set xlabel "Pays"
		set ylabel "Années"
		set title "Conso"
		splot #nom du fichier + commandes


