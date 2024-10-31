#!/bin/bash

UB_METAREPTS=1
UB_REPTS=100

mem_bytes=`echo "(20480 * 0.5) * 1024" | bc` # 50% of L3 cache, per socket
streams_nb=3
stream_bytes=`echo "${mem_bytes} / ${streams_nb}" | bc`

warmup_bytes=`echo "1024 * 1024 * 1024" | bc` # 1 GB: should take at least few milliseconds
warmup_repts=`echo "${warmup_bytes} / ${stream_bytes}" | bc`

insn_bytes=640 #10 CLs stride
unroll_factor=4
iter_bytes=`echo "${insn_bytes} * ${unroll_factor}" | bc`
iter_nb=`echo "${stream_bytes} / ${iter_bytes}" | bc`

echo $UB_METAREPTS ${warmup_repts} $UB_REPTS ${iter_nb} ${stream_bytes} > codelet.data
cmd="./wrapper"
echo CMD:${cmd}
LD_LIBRARY_PATH=../../../../cape-cls/utils/codeletProbe ${cmd}
