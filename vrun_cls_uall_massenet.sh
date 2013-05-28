#!/bin/bash -l


variants="time_reference"
linear_sizes="1000 2000 4000 6000 8000 10000 20000 40000 60000 80000 100000 200000 400000 600000 800000 1000000 2000000 4000000 6000000 8000000 10000000"
quadratic_sizes="208 240 304 352 400 528 608 704 800 928 1008 1100 1200 1300 1400 1500 1600 1800 2000 2500 3000"
memory_loads="0"
frequencies="1200000 2700000"


#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch1/balanc_3_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch1/balanc_3_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch1/balanc_3_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch1/balanc_3_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch1/balanc_3_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch1/svdcmp_13_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch1/svdcmp_13_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch1/svdcmp_13_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch1/svdcmp_13_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch1/svdcmp_13_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch1/svdcmp_14_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch1/svdcmp_14_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch1/svdcmp_14_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch1/svdcmp_14_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch1/svdcmp_14_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch1/toeplz_1_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch1/toeplz_1_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch1/toeplz_1_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch1/toeplz_1_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch1/toeplz_1_dp_sse"



#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch2/four1_2_mp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch2/four1_2_mp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch2/four1_2_mp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch2/four1_2_mp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch2/four1_2_mp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch2/hqr_12_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch2/hqr_12_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch2/hqr_12_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch2/hqr_12_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch2/hqr_12_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch2/hqr_12_square_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch2/hqr_12_square_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch2/hqr_12_square_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch2/hqr_12_square_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch2/hqr_12_square_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch2/lop_13_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch2/lop_13_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch2/lop_13_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch2/lop_13_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch2/lop_13_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch2/ludcmp_4_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch2/ludcmp_4_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch2/ludcmp_4_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch2/ludcmp_4_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch2/ludcmp_4_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch2/relax2_26_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch2/relax2_26_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch2/relax2_26_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch2/relax2_26_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch2/relax2_26_dp_sse"


#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch3/hqr_15_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch3/hqr_15_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch3/hqr_15_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch3/hqr_15_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch3/hqr_15_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch3/jacobi_5_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch3/jacobi_5_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch3/jacobi_5_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch3/jacobi_5_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch3/jacobi_5_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch3/matadd_16_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch3/matadd_16_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch3/matadd_16_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch3/matadd_16_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch3/matadd_16_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch3/mprove_8_mp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch3/mprove_8_mp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch3/mprove_8_mp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch3/mprove_8_mp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch3/mprove_8_mp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch3/rstrct_29_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch3/rstrct_29_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch3/rstrct_29_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch3/rstrct_29_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch3/rstrct_29_dp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch3/svbksb_3_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch3/svbksb_3_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch3/svbksb_3_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch3/svbksb_3_sp_sse"
#quadratic_codelets="$quadratic_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch3/svbksb_3_sp_sse"


#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch4/elmhes_10_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch4/elmhes_10_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch4/elmhes_10_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch4/elmhes_10_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch4/elmhes_10_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch4/elmhes_11_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch4/elmhes_11_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch4/elmhes_11_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch4/elmhes_11_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch4/elmhes_11_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch4/hqr_13_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch4/hqr_13_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch4/hqr_13_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch4/hqr_13_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch4/hqr_13_dp_sse"
linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch4/mprove_9_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch4/mprove_9_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch4/mprove_9_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch4/mprove_9_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch4/mprove_9_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch4/realft_4_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch4/realft_4_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch4/realft_4_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch4/realft_4_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch4/realft_4_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch4/svdcmp_11_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch4/svdcmp_11_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch4/svdcmp_11_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch4/svdcmp_11_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch4/svdcmp_11_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch4/svdcmp_6_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch4/svdcmp_6_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch4/svdcmp_6_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch4/svdcmp_6_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch4/svdcmp_6_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch4/toeplz_2_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch4/toeplz_2_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch4/toeplz_2_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch4/toeplz_2_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch4/toeplz_2_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch4/toeplz_3_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch4/toeplz_3_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch4/toeplz_3_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch4/toeplz_3_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch4/toeplz_3_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch4/toeplz_4_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch4/toeplz_4_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch4/toeplz_4_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch4/toeplz_4_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch4/toeplz_4_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_free/batch4/tridag_1_bet1_dt0_sse_initbet1"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch4/tridag_1_bet1_dt0_sse_initbet1"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch4/tridag_1_bet1_dt0_sse_initbet1"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch4/tridag_1_bet1_dt0_sse_initbet1"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch4/tridag_1_bet1_dt0_sse_initbet1"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_1/batch4/tridag_2_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_2/batch4/tridag_2_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_4/batch4/tridag_2_dp_sse"
#linear_codelets="$linear_codelets /home/users/vpalomares/nfs/codelets/NR_format/massenet/numerical_recipes_unroll_8/batch4/tridag_2_dp_sse"


for codelet in $linear_codelets
do
	echo "Launching CLS on '$codelet'..."
	./cls.sh "$codelet" "$variants" "$linear_sizes" "$memory_loads" "$frequencies" &> "$codelet/cls.log"
	res=$?
	if [[ "$res" != "0" ]]
	then
		echo -e "\tAn error occured! Check '$codelet/cls.log' for more information."
	fi
done

for codelet in $quadratic_codelets
do
	echo "Launching CLS on '$codelet'..."
	./cls.sh "$codelet" "$variants" "$quadratic_sizes" "$memory_loads" "$frequencies" &> "$codelet/cls.log"
	res=$?
	if [[ "$res" != "0" ]]
	then
		echo -e "\tAn error occured! Check '$codelet/cls.log' for more information."
	fi
done


