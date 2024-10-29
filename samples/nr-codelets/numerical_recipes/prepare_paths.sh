#!/bin/bash

for i in */*/*
do
	codelet=$( basename "$i" )
	codelet_path=$( readlink -f "$i" )

	prefix=$( echo "$i" | cut -b1 )
	if [[ "$prefix" == "1" ]]
	then
		collection="linear_codelets"
	else
		collection="quadratic_codelets"
	fi

	echo "$collection=\"\$$collection $codelet_path\""

done
