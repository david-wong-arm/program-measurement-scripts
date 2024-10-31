#!/bin/bash

fully_vectorized_codes="balanc_3 elmhes_10 hqr_13 mprove_9 svdcmp_13 svdcmp_14 hqr_12 jacobi_5 matadd_16 svbksb_3 lop_13"
partially_vectorized_codes="ludcmp_4 toeplz_1 toeplz_3 rstrct_29"

for i in */*
do
	code=$( basename "$i" )

	if  echo "$fully_vectorized_codes $partially_vectorized_codes" | grep "$code" 
	then
		echo "Code: '$i'"

		for j in $i/*_sVS_*
		do
			codelet=$( basename "$j" )
			suffix=$( echo "$codelet" | tail -c 7 )

			if echo "$fully_vectorized_codes" | grep "$code"
			then
				new_codelet_name="${code}_sU1_$suffix"
			else
				new_codelet_name="${code}_sU1_$suffix"
			fi
			new_folder="$i/$new_codelet_name"

			echo "Codelet: '$codelet'"
			echo -e "\tSuffix: $suffix"
			echo -e "\tNew name: $new_codelet_name"

			rm -rf "$new_folder"
			cp -R "$j" "$new_folder"

			for file in "$new_folder"/codelet.conf "$new_folder"/codelet.meta
			do
				sed "s/$codelet/$new_codelet_name/g" -i "$file"
			done
		done
	fi
done
