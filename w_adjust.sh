#!/bin/bash -l

source ./const.sh

if [[ "$nb_args" != "5" ]]
then
	echo "ERROR! Invalid arguments (need: codelet's folder, binary's name, desired size, minimum number of repetitions)."
	exit -1
fi

codelet_folder="$1"
binary_name="$2"
desired_size="$3"
min_repet="$4"
desired_length="$5"

echo "W_adjust: Going to assess the right number of repetitions (to reach $desired_length hundredths of second) for codelet '$codelet_folder' with a data set of '$desired_size'"

cd "$codelet_folder"

current_repetitions=$min_repet
saved_repetitions=$min_repet
res=0

cd $codelet_folder

while [ $res -le $desired_length  -a $current_repetitions -le 1000000000 -a $current_repetitions -ge 0 ]
do
	echo "Trying number of repetitions = $current_repetitions"
	echo "$current_repetitions $desired_size" > codelet.data
	saved_repetitions=$current_repetitions

	res=$( /usr/bin/time -f %e ./${binary_name} 2>&1 )
	val_res=$?

	if [[ "$val_res" != "0" ]]
	then
		echo "Error while running the codelet. Aborting."
		exit -1
	fi

	res=$( echo -e "$res" | tail -n 1 )

	#echo "Res time: $res"
	res=$( echo $res | sed "s/\.//g" )
	#echo "Res without dot: $res"
	res=$( echo $res | sed 's/^[0]*//' )
	#echo "Res without 0s: $res"

	if [[ "$res" == "" ]]
	then
		#echo "Took 0.0s => multiplying by 10"
		let "current_repetitions = $current_repetitions * 10"
		#echo "Forced repetitions = $current_repetitions"
		res=0
	else
		if [ $res -le $desired_length  ]
		then
			let "current_repetitions = $current_repetitions * (($desired_length  / $res) + 1)"
			#echo "Deduced repetitions = $current_repetitions"
		fi
	fi
	
done


echo "Done: saved_repetitions = $saved_repetitions"

echo "$desired_size $saved_repetitions" >> repetitions_history


exit 0
