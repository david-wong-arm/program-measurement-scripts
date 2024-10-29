#!/bin/bash

echo "Generating bws NRs"

codes="loads stores"
instructions="vmovaps vmovups movaps movups movsd movss movntdq"
#instructions="movntdq"
#swps="none 0128 0256 0512 0768 1024 1536 2048 3072 4096"
swps="none"
#dws="none addss nop rip_load rip_mix rip_pref rip_store stack_load stack_pref target_clone target_pref"
dws="none"
#target_pref target_clone stack_pref stack_load 
flags="hwp"
strides="none 64 96 128 192 256"
strides="none"

numbers_of_instructions="2"

# Make sure the number of consumed bytes / 8 is an integer
declare -A consumed_bytes
consumed_bytes+=([vmovaps]="32")
consumed_bytes+=([vmovups]="32")
consumed_bytes+=([movaps]="16")
consumed_bytes+=([movntdq]="16")
consumed_bytes+=([movups]="16")
consumed_bytes+=([movsd]="8")
consumed_bytes+=([movss]="4")

rm -rf generated_experiments
mkdir generated_experiments


for code in $codes
do
	for number_of_instructions in $numbers_of_instructions
	do
		for instruction in $instructions
		do
			if [[ "$instruction" == "vmovaps" || "$instruction" == "vmovups" ]]
			then
				reg_type="ymm"
			else
				reg_type="xmm"
			fi

			for flag in $flags
			do
				for swp in $swps
				do
					for dw in $dws
					do
						for stride in $strides
						do
							if [[ "$flag" == "hwp" ]]
							then
								flag_part=""
							else
								flag_part="_${flag}"
							fi

							if [[ "$swp" == "none" ]]
							then
								swp_part=""
							else
								swp_part="_swp-${swp}"
							fi

							if [[ "$dw" == "none" ]]
							then
								dw_part=""
							else
								dw_part="_dw-${dw}"
							fi

							if [[ "$stride" == "none" ]]
							then
								stride_part=""
								let "offset_increment = ${consumed_bytes[$instruction]}"
							else
								stride_part="_stride-$stride"
								let "offset_increment = $stride"
							fi

							codelet_name="${code}_1Sx${number_of_instructions}-${instruction}${flag_part}${swp_part}${dw_part}${stride_part}"

							dist_folder="generated_experiments/$codelet_name"

							echo "Generating: '$codelet_name'"

							let "nb_consumed_elements = $number_of_instructions * $offset_increment / 8"
							let "increment = $nb_consumed_elements * 8"

							cp -r "model" "$dist_folder"

							sed "s/REPLACE_BATCH/${code}_${number_of_instructions}/g" -i "$dist_folder/codelet.meta"
							sed "s/REPLACE_CODELET_NAME/${codelet_name}/g" -i "$dist_folder/codelet.meta"
							sed "s/REPLACE_CODELET_NAME/${codelet_name}/g" -i "$dist_folder/codelet.conf"
							sed "s/REPLACE_CODE/${code}_${number_of_instructions}-${instruction}/g" -i "$dist_folder/codelet.meta"
							sed "s/REPLACE_NB_ELEMENTS/$nb_consumed_elements/g" -i "$dist_folder/driver.c"

							sed "s/REPLACE_CONSUMED_ELEMENTS/$nb_consumed_elements/g" -i "$dist_folder/codelet.s"
							sed "s/REPLACE_INCREMENT/$increment/g" -i "$dist_folder/codelet.s"

							if [[ "$instruction" == "movups" ]]
							then
								alignment="8"
							else
								alignment="0"
							fi

							sed "s/REPLACE_ALIGNMENT/$alignment/g" -i "$dist_folder/codelet.s"

							if [[ "$swp" != "none" ]]
							then
								let "needed_number_of_swps = ($increment / 64)"
								let "need_plus_one = ($increment % 64)"
								if [[ "$need_plus_one" != "0" ]]
								then
									let "needed_number_of_swps = $needed_number_of_swps + 1"
								fi

								target="${swp#0}"

								for i in $( seq "$needed_number_of_swps" )
								do
									#echo "Prefetching '$target'"
									sed "s/\t\t#INSERT_SWP_PREFETCH_ABOVE/\t\tprefetcht0 $target(%rsi)\n\t\t#INSERT_SWP_PREFETCH_ABOVE/g" -i "$dist_folder/codelet.s"

									let "target = $target + 64"
								done
							fi

							xmm=0;
							offset=0;
							for i in $( seq "$number_of_instructions" )
							do
								if [[ "$code" == "loads" ]]
								then
									instr="$instruction $offset(%rsi), %${reg_type}$xmm"
								else
									instr="$instruction %${reg_type}$xmm, $offset(%rsi)"
								fi

								sed "s/\t\t#INSERT_INSTRUCTION_ABOVE/\t\t$instr\n\t\t#INSERT_INSTRUCTION_ABOVE/g" -i "$dist_folder/codelet.s"

								if [[ "$dw" != "none" ]]
								then
									case "$dw" in
										"addss")
											let "xmm_tmp = ($xmm + 8) % 16"
											if [[ "${reg_type}" == "xmm" ]]
											then
												dwi="addss %${reg_type}$xmm_tmp, %${reg_type}$xmm_tmp"
											else
												dwi="vaddss %${reg_type}$xmm_tmp, %${reg_type}$xmm_tmp"
											fi
											;;

										"nop")
											dwi="nop"
											;;

										"rip_load")
											let "xmm_tmp = ($xmm + 8) % 16"
											if [[ "${reg_type}" == "xmm" ]]
											then
												dwi="movss data(%rip), %${reg_type}$xmm_tmp"
											else
												dwi="vmovss data(%rip), %${reg_type}$xmm_tmp"
											fi
											;;

										"rip_mix")
											if [[ "$i" == "1" ]]
											then
												let "xmm_tmp = ($xmm + 8) % 16"
												if [[ "${reg_type}" == "xmm" ]]
												then
													dwi="movss data(%rip), %${reg_type}$xmm_tmp"
												else
													dwi="vmovss data(%rip), %${reg_type}$xmm_tmp"
												fi
											else
												dwi="prefetcht0 data(%rip)"
											fi
											;;

										"rip_pref")
											dwi="prefetcht0 data(%rip)"
											;;

										"rip_store")
											let "xmm_tmp = ($xmm + 8) % 16"
											if [[ "${reg_type}" == "xmm" ]]
											then
												dwi="movss %${reg_type}$xmm_tmp, data(%rip)"
											else
												dwi="vmovss %${reg_type}$xmm_tmp, data(%rip)"
											fi
											;;

										"stack_load")
											let "xmm_tmp = ($xmm + 8) % 16"
											if [[ "${reg_type}" == "xmm" ]]
											then
												dwi="movss 0(%rsp), %${reg_type}$xmm_tmp"
											else
												dwi="vmovss 0(%rsp), %${reg_type}$xmm_tmp"
											fi
											;;

										"stack_pref")
											dwi="prefetcht0 0(%rsp)"
											;;

										"target_clone")
											dwi="$instr"
											;;

										"target_load")
											let "xmm_tmp = ($xmm + 8) % 16"
											if [[ "${reg_type}" == "xmm" ]]
											then
												dwi="movss $offset(%rsi), %${reg_type}$xmm_tmp"
											else
												dwi="vmovss $offset(%rsi), %${reg_type}$xmm_tmp"
											fi
											;;

										"target_pref")
											dwi="prefetcht0 $offset(%rsi)"
											;;
									esac

									sed "s/\t\t#INSERT_INSTRUCTION_ABOVE/\t\t$dwi\t#dw_$dw\n\t\t#INSERT_INSTRUCTION_ABOVE/g" -i "$dist_folder/codelet.s"

								fi

#								let "offset = $offset + ${consumed_bytes[$instruction]}"
								let "offset = $offset + $offset_increment"
								let "xmm = ($xmm + 1) % 16"
							done
						done
					done
				done
			done
		done
	done
done
