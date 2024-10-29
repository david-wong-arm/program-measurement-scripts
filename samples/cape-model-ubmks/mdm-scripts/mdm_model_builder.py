#!/usr/bin/python3

import os
import os.path as path
import argparse
import subprocess
import csv
import math
import numpy as np
import numpy.ma as ma
import matplotlib.pyplot as plt
import pandas as pd
import multiprocessing
from sklearn.linear_model import LinearRegression
from tkinter import *
from tkinter import ttk
from scipy.optimize import curve_fit

DEBUG_MODELING=False
RAW_FILES="./raw_files.txt"
MODELING_FILES="./modeling_raw_files.txt"
MODELING_BW_FILES="./modeling_bw_raw_files.txt"
SELECTED_DS_RUN_FILE="./selected_run.txt"
steady_cache_line_threshold = 1.0 * 0.98
silent_cache_line_threshold = 0.01
QSIZE = 10


parser = argparse.ArgumentParser(description='Create modeling data files for MDM.')
parser.add_argument('--explore', action='store_const', const='explore', help='Explore data sizes for different cache hierarchy', required=False, dest='mode')
parser.add_argument('--build-model', action='store_const', const='build', help='Build the model to generate MDM data files', required=False, dest='mode')
parser.add_argument('--build-parallel-model', action='store_const', const='build-parallel', help='Build the model to generate MDM data files for more parallel/bandwidth limited situation', required=False, dest='mode')
args = parser.parse_args()

if not args.mode:
    parser.error('One of --explore or --build-model must exist or --build-parallel-model');

    
def sort_data(datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its):
    s_datasizes= np.array([x for x,_ in sorted(zip(datasizes,L2_rc_per_its))])
    s_L2_rc_per_its = np.array([x for _,x in sorted(zip(datasizes,L2_rc_per_its))])
    s_L3_rc_per_its = np.array([x for _,x in sorted(zip(datasizes,L3_rc_per_its))])
    s_ram_rc_per_its = np.array([x for _,x in sorted(zip(datasizes,ram_rc_per_its))])
    return s_datasizes, s_L2_rc_per_its, s_L3_rc_per_its, s_ram_rc_per_its

def plot_data(datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its, sel_datasizes, logscale, \
              ylabel):
    plt.figure()
    s_datasizes, s_L2_rc_per_its, s_L3_rc_per_its, s_ram_rc_per_its = \
                 sort_data(datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its)

    plt.plot(s_datasizes, s_L2_rc_per_its)


    plt.plot(s_datasizes, s_L3_rc_per_its)

    plt.plot(s_datasizes, s_ram_rc_per_its)
    if logscale:
        plt.xscale('log')
    maxY=max(max(s_L2_rc_per_its), max(s_L3_rc_per_its), max(s_ram_rc_per_its), 1)

    plt.ylim(0, maxY)
    plt.ylabel(ylabel)
    plt.xlabel('Data Size')

    voffset=1
    for ds in sel_datasizes:
        voffset=voffset+1
        plt.annotate('datasize = {}'.format(ds), xy=(ds,1), xytext=(ds+10,0.1*voffset), \
                     ha='center', arrowprops=dict(facecolor='black', shrink=0.05))
#    plt.plot([0, max(s_datasizes)],[0,1])

    plt.show(block=False)

def plot_filtered_data(datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its, cond):
    plot_data(datasizes[cond], L2_rc_per_its[cond], L3_rc_per_its[cond], ram_rc_per_its[cond])                       
    
def runCmdGetRst_safe_pipes(pipeCmds, cwd, env=os.environ.copy()):
    last_stdin=None
    for pipeCmd in pipeCmds:
        result = subprocess.Popen(pipeCmd, cwd=cwd, env=env, text=True, stdin=last_stdin, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        last_stdin = result.stdout
    output, error = result.communicate()
    return output.strip(), error.strip()

def do_runs(datasizes):
    print(datasizes)
    with open ('explore_data.txt', 'w') as f: f.write (' '.join(map(str,datasizes)))
    #raw_file=subprocess.check_output(["""./vrun_ancodskx1020_mdm_explore.sh 'Test'|grep 'Cape raw data'| sed 's/.*: //g'"""], shell=True).strip().decode('utf-8')
    raw_file = runCmdGetRst_safe_pipes([[f'vrun_ancodskx1020_mdm_explore.sh', 'Test'], ['grep', 'Cape raw data'], ['sed', 's/.*: //g']], cwd='.')

    with open(RAW_FILES, "a") as myfile: myfile.write(raw_file+"\n")
    return raw_file

def do_modeling_runs_generic(datasizes, script, raw_files):
    print(datasizes)
    with open ('model_data_sizes.txt', 'w') as f: f.write (' '.join(map(str,datasizes)))
    #raw_file=subprocess.check_output(["""./{} 'Test'|grep 'Cape raw data'| sed 's/.*: //g'""".format(script)], shell=True).strip().decode('utf-8')
    raw_file = runCmdGetRst_safe_pipes([[f'{script}', 'Test'], ['grep', 'Cape raw data'], ['sed', 's/.*: //g']], cwd='.')
    with open(raw_files, "a") as myfile: myfile.write(raw_file+"\n")
    return raw_file

def do_modeling_runs(datasizes):
    return do_modeling_runs_generic(datasizes, "vrun_ancodskx1020_mdm_modeling.sh", MODELING_FILES)

#     raw_file=subprocess.check_output(["""./vrun_ancodskx1020_mdm_modeling.sh 'Test'|grep 'Cape raw data'| sed 's/.*: //g'"""], shell=True).strip().decode('utf-8')
#     with open(MODELING_FILES, "a") as myfile: myfile.write(raw_file+"\n")
#     return raw_file


def do_bw_modeling_runs(datasizes, proc_list):
    print(proc_list)
    with open ('bw_model_proc_list.txt', 'w') as f: f.write (' '.join(map(str,proc_list)))    
    return do_modeling_runs_generic(datasizes, "vrun_ancodskx1020_mdm_bw_modeling.sh", MODELING_BW_FILES)    

def compute_npts_range (current_lb, current_ub, inclusive, npts):
    if inclusive:
        npts = npts - 2
    base = max(int(math.floor((current_ub - current_lb-1) ** (1/npts))), 2)
    print('base', base)
    return compute_range(current_lb, current_ub, inclusive, base)

def compute_npts_linear_range (current_lb, current_ub, inclusive, npts):
    if inclusive:
        stride = max(int(math.floor((current_ub - current_lb )/(npts-1))),1)
        lb = current_lb
        ub = current_ub
    else:
        stride = max(int(math.floor((current_ub - current_lb )/(npts+1))),1)
        lb = current_lb+stride
        ub = current_ub-stride
#     print('current_lb={} current_ub={} npts={}'.format(current_lb, current_ub, npts))
#     print('lb={} ub={} stride={}'.format(lb, ub, stride))
#    ans = compute_linear_range(lb, ub, inclusive, stride)
    return [ int(i) for i in np.linspace(lb, ub, npts) ]


def compute_linear_range(current_lb, current_ub, inclusive, stride):
    # Go ahead to exclude ub
    diff=current_ub - current_lb - 1

    num_steps = int(math.floor(diff / stride))

    range_ans = [ int(current_lb)+ stride * n for n in range (1, num_steps+1)]
    if inclusive:
        # Go ahead to put back lb and ub
        range_ans.insert(0, int(current_lb))
        range_ans.append(int(current_ub))
    return range_ans
    
    
def compute_range(current_lb, current_ub, inclusive, base):
    # Go ahead to exclude ub
    diff=current_ub - current_lb - 1

    num_steps = int(math.floor(math.log(diff, base)))
    range_ans = [ int(current_lb)+ base ** n for n in range (1, num_steps+1)]
    if inclusive:
        # Go ahead to put back lb and ub
        range_ans.insert(0, int(current_lb))
        range_ans.append(int(current_ub))
    return range_ans

def getter(in_row, *argv):
    for arg in argv:
        if (arg in in_row):

            if (in_row[arg]):
                return float(in_row[arg])
            else:
                return 0
    return 0
#    raise IndexError(', '.join(map(str, argv)))


def arch_helper(row):
    arch = row['cpu.generation'].lower()
    if 'skylake' in arch:
        return 'SKL'
    elif 'haswell' in arch:
        return 'HSW'
    elif 'ivy' in arch:
        return 'IVB'
    elif 'sandy' in arch:
        return 'SNB'
    else:
        return '???'
def calculate_lfb_per_it (in_row):
    lfbc=np.zeros(QSIZE+1)
    lfbk=np.zeros(QSIZE)
    lfbocc=0
    try:
        lfbocc = getter(in_row, "L1D_PEND_MISS_PENDING")
        for i in range(1, 9+1):
            lfbc[i-1] = getter(in_row, "L1D_PEND_MISS_PENDING:c{}".format(i))

        lfbc[10-1] = getter(in_row, "L1D_PEND_MISS_PENDING:c0xa")
        lfbc[11-1] = 0
        assert (QSIZE + 1 - 1)== 11-1
        for i in range(0, QSIZE-1+1):
            lfbk[i]=(i+1)*(lfbc[i] - lfbc[i+1])
    except:
        pass

    return lfbc, lfbk, lfbocc
        
def calculate_mem_rc_per_it (in_row, arch):
    if arch == 'SKL':
        L2_rc_per_it = getter(in_row, 'L1D_REPLACEMENT') 
        L3_rc_per_it = getter(in_row, 'L2_RQSTS_MISS') 
    elif arch == 'HSW':
        L2_rc_per_it = getter(in_row, 'L1D_REPLACEMENT', 'L1D_REPLACEMENT_ND')
        L3_rc_per_it = getter(in_row, 'L2_RQSTS_MISS') + getter(in_row, 'SQ_MISC_FILL_DROPPED')
    elif arch == 'IVB' or arch == 'SNB':
        L2_rc_per_it = getter(in_row, 'L1D_REPLACEMENT') 
        L3_rc_per_it = getter(in_row, 'L2_LINES_ALL') + getter(in_row, 'SQ_MISC_FILL_DROP')
    else:
        raise Exception('Unknown arch %s!' % arch)
    ram_rc_per_it = getter(in_row, 'UNC_M_CAS_COUNT_RD', 'UNC_IMC_DRAM_DATA_READS')

    return L2_rc_per_it, L3_rc_per_it, ram_rc_per_it


def calculate_mem_wc_per_it (in_row, arch):
    if arch == 'SKL':
        L2_wc_per_it = getter(in_row, 'L2_TRANS_L1D_WB')
        L3_wc_per_it = getter(in_row, 'L2_TRANS_L2_WB')
    elif arch == 'HSW':
        L2_wc_per_it = getter(in_row, 'L2_TRANS_L1D_WB') + getter(in_row, 'L2_DEMAND_RQSTS_WB_MISS')
        L3_wc_per_it = getter(in_row, 'L2_TRANS_L2_WB') + getter(in_row, 'L2_DEMAND_RQSTS_WB_MISS')
    elif arch == 'IVB' or arch == 'SNB':
        L2_wc_per_it = getter(in_row, 'L1D_WB_RQST_ALL')
        L3_wc_per_it = getter(in_row, 'L2_TRANS_L2_WB') + getter(in_row, 'L2_L1D_WB_RQSTS_MISS')
    else:
        raise Exception('Unknown arch %s!' % arch)

    ram_wc_per_it = getter(in_row, 'UNC_M_CAS_COUNT_WR', 'UNC_IMC_DRAM_DATA_WRITES')

    return L2_wc_per_it, L3_wc_per_it, ram_wc_per_it

def calculate_mem_rwc_per_it (in_row, arch):
    L2_rc_per_it, L3_rc_per_it, ram_rc_per_it=calculate_mem_rc_per_it (in_row, arch)
    L2_wc_per_it, L3_wc_per_it, ram_wc_per_it=calculate_mem_wc_per_it (in_row, arch)
    return L2_rc_per_it+L2_wc_per_it, L3_rc_per_it+L3_wc_per_it, ram_rc_per_it+ram_wc_per_it

def calculate_mem_rates_from_traffic(in_row, iters_per_rep, time_per_rep, arch, L2_rwc_per_it, L3_rwc_per_it, ram_rwc_per_it):
    L2_rwb_per_it = 64 * L2_rwc_per_it
    L3_rwb_per_it = 64 * L3_rwc_per_it
    ram_rwb_per_it = ram_rwc_per_it * 64

    L1_rb_per_it  = getter(in_row, 'Bytes_loaded') * getter(in_row, 'decan_experimental_configuration.num_core')
    L1_wb_per_it  = getter(in_row, 'Bytes_stored') * getter(in_row, 'decan_experimental_configuration.num_core')
    L1_rwb_per_it  = (L1_rb_per_it  + L1_wb_per_it)

    L1_GB_s  = (L1_rwb_per_it  * iters_per_rep) / (1E9 * time_per_rep)
    L2_GB_s  = (L2_rwb_per_it  * iters_per_rep) / (1E9 * time_per_rep)
    L3_GB_s  = (L3_rwb_per_it  * iters_per_rep) / (1E9 * time_per_rep)
    ram_GB_s = (ram_rwb_per_it * iters_per_rep) / (1E9 * time_per_rep)
    return (L1_GB_s, L2_GB_s, L3_GB_s, ram_GB_s)
    
    
def calculate_mem_rates(in_row, iters_per_rep, time_per_rep, arch):
    L2_rwc_per_it, L3_rwc_per_it, ram_rwc_per_it = calculate_mem_rwc_per_it (in_row, arch)
    return calculate_mem_rates_from_traffic (in_row, iters_per_rep, time_per_rep, arch, L2_rwc_per_it, L3_rwc_per_it, ram_rwc_per_it)

def calculate_gflops(in_row, iters_per_rep, time_per_rep):
    if args.skx:
        counter_flops = ((0.5 * getter(in_row, 'FP_ARITH_INST_RETIRED_SCALAR_SINGLE') + \
            1 * getter(in_row, 'FP_ARITH_INST_RETIRED_SCALAR_DOUBLE') + \
            2 * getter(in_row, 'FP_ARITH_INST_RETIRED_128B_PACKED_SINGLE') + \
            2 * getter(in_row, 'FP_ARITH_INST_RETIRED_128B_PACKED_DOUBLE') + \
            4 * getter(in_row, 'FP_ARITH_INST_RETIRED_256B_PACKED_SINGLE') + \
            4 * getter(in_row, 'FP_ARITH_INST_RETIRED_256B_PACKED_DOUBLE') + \
            8 * getter(in_row, 'FP_ARITH_INST_RETIRED_512B_PACKED_SINGLE') + \
            8 * getter(in_row, 'FP_ARITH_INST_RETIRED_512B_PACKED_DOUBLE'))) / getter(in_row, 'decan_experimental_configuration.num_core')

    flops = 0.5 * getter(in_row, 'Nb_insn_ADD/SUBSS') + \
            2 * getter(in_row, 'Nb_insn_ADD/SUBPS_XMM') + \
            4 * getter(in_row, 'Nb_insn_ADD/SUBPS_YMM') + \
            8 * getter(in_row, 'Nb_insn_ADD/SUBPS_ZMM') + \
            1 * getter(in_row, 'Nb_insn_ADD/SUBSD') + \
            2 * getter(in_row, 'Nb_insn_ADD/SUBPD_XMM') + \
            4 * getter(in_row, 'Nb_insn_ADD/SUBPD_YMM') + \
            8 * getter(in_row, 'Nb_insn_ADD/SUBPD_ZMM') + \
            0.5 * getter(in_row, 'Nb_insn_DIVSS') + \
            2 * getter(in_row, 'Nb_insn_DIVPS_XMM') + \
            4 * getter(in_row, 'Nb_insn_DIVPS_YMM') + \
            8 * getter(in_row, 'Nb_insn_DIVPS_ZMM') + \
            1 * getter(in_row, 'Nb_insn_DIVSD') + \
            2 * getter(in_row, 'Nb_insn_DIVPD_XMM') + \
            4 * getter(in_row, 'Nb_insn_DIVPD_YMM') + \
            8 * getter(in_row, 'Nb_insn_DIVPD_ZMM') + \
            0.5 * getter(in_row, 'Nb_insn_MULSS') + \
            2 * getter(in_row, 'Nb_insn_MULPS_XMM') + \
            4 * getter(in_row, 'Nb_insn_MULPS_YMM') + \
            8 * getter(in_row, 'Nb_insn_MULPS_ZMM') + \
            1 * getter(in_row, 'Nb_insn_MULSD') + \
            2 * getter(in_row, 'Nb_insn_MULPD_XMM') + \
            4 * getter(in_row, 'Nb_insn_MULPD_YMM') + \
            8 * getter(in_row, 'Nb_insn_MULPD_ZMM') + \
            0.5 * getter(in_row, 'Nb_insn_SQRTSS') + \
            2 * getter(in_row, 'Nb_insn_SQRTPS_XMM') + \
            4 * getter(in_row, 'Nb_insn_SQRTPS_YMM') + \
            8 * getter(in_row, 'Nb_insn_SQRTPS_ZMM') + \
            1 * getter(in_row, 'Nb_insn_SQRTSD') + \
            2 * getter(in_row, 'Nb_insn_SQRTPD_XMM') + \
            4 * getter(in_row, 'Nb_insn_SQRTPD_YMM') + \
            8 * getter(in_row, 'Nb_insn_SQRTPD_ZMM') + \
            0.5 * getter(in_row, 'Nb_insn_RSQRTSS') + \
            2 * getter(in_row, 'Nb_insn_RSQRTPS_XMM') + \
            4 * getter(in_row, 'Nb_insn_RSQRTPS_YMM') + \
            8 * getter(in_row, 'Nb_insn_RSQRTPS_ZMM') + \
            1 * getter(in_row, 'Nb_insn_RSQRTSD') + \
            2 * getter(in_row, 'Nb_insn_RSQRTPD_XMM') + \
            4 * getter(in_row, 'Nb_insn_RSQRTPD_YMM') + \
            8 * getter(in_row, 'Nb_insn_RSQRTPD_ZMM') + \
            0.5 * getter(in_row, 'Nb_insn_RCPSS') + \
            2 * getter(in_row, 'Nb_insn_RCPPS_XMM') + \
            4 * getter(in_row, 'Nb_insn_RCPPS_YMM') + \
            8 * getter(in_row, 'Nb_insn_RCPPS_ZMM') + \
            1 * getter(in_row, 'Nb_insn_RCPSD') + \
            2 * getter(in_row, 'Nb_insn_RCPPD_XMM') + \
            4 * getter(in_row, 'Nb_insn_RCPPD_YMM') + \
            8 * getter(in_row, 'Nb_insn_RCPPD_ZMM')
    try:
        # try to add the FMA counts
        flops += 1 * getter(in_row, 'Nb_insn_FMASS') + \
                 4 * getter(in_row, 'Nb_insn_FMAPS_XMM') + \
                 8 * getter(in_row, 'Nb_insn_FMAPS_YMM') + \
                 16 * getter(in_row, 'Nb_insn_FMAPS_ZMM') + \
                 2 * getter(in_row, 'Nb_insn_FMASD') + \
                 4 * getter(in_row, 'Nb_insn_FMAPD_XMM') + \
                 8 * getter(in_row, 'Nb_insn_FMAPD_YMM') + \
                 16 * getter(in_row, 'Nb_insn_FMAPD_ZMM')
    except:
        pass
    flops=(flops * getter(in_row, 'decan_experimental_configuration.num_core') * iters_per_rep) / (1E9 * time_per_rep)
    counter_flops=(counter_flops * getter(in_row, 'decan_experimental_configuration.num_core') * iters_per_rep) / (1E9 * time_per_rep)
    return (flops, counter_flops)

def calculate_iterations_per_rep(in_row):
#    return np.float64(getter(in_row, 'Iterations')) / np.float64(in_row.get('Repetitions', '1'))
    return np.float64(getter(in_row, 'Iterations')) / np.float64(getter(in_row, 'Iterations'))

def calculate_time_per_rep(in_row, iters_per_rep):
    return ((getter(in_row, 'CPU_CLK_UNHALTED_REF_TSC') * iters_per_rep) /
            (getter(in_row, 'cpu.nominal_frequency', 'decan_experimental_configuration.frequency') * 1e3 * \
             getter(in_row, 'decan_experimental_configuration.num_core')))


# # Assume we get the data file
# expr_out_file="/localdisk/cwong29/working/NR-scripts/mdm-modeling/mdm-scripts/logs/runs/1559764895/cape_1559764895.csv"
# with open (expr_out_file, 'rU') as input_csvfile:
#     csvreader = csv.DictReader(input_csvfile, delimiter=',')
#     for input_row in csvreader:
#         print(input_row['codelet.name'])

#         arch = arch_helper(input_row)
#         freq = str(round(getter(input_row, 'cpu.nominal_frequency', 'decan_experimental_configuration.frequency') / 1e6, 1)) + 'GHz'
#         if str(input_row['decan_experimental_configuration.frequency']).endswith('1000'):
#             freq += '-TB'
#         num_cores = getter(input_row, 'decan_experimental_configuration.num_core')
#         iters_per_rep = calculate_iterations_per_rep(input_row)
#         mem_rates=calculate_mem_rates(row, iters_per_rep, time_per_rep, arch)
#         print(iters_per_rep)

def refine_transition(datasizes, traffic_per_its):

    cnt_lvl_datasizes=datasizes[traffic_per_its >= steady_cache_line_threshold]
    print(cnt_lvl_datasizes)
    min_cnt_lvl_datasize=min(cnt_lvl_datasizes)
    prev_lvl_datasizes=datasizes[(traffic_per_its <= silent_cache_line_threshold) & \
                                 (datasizes <= min_cnt_lvl_datasize)]
    max_prev_lvl_datasizes=max(prev_lvl_datasizes)
    
    print ("CNT LVL DS", cnt_lvl_datasizes)
    print ("Pre LVL", prev_lvl_datasizes)
    
    explore_pre_lvl_datasize_ub=min(datasizes[datasizes > max_prev_lvl_datasizes])
    explore_cnt_lvl_datasize_lb=max(datasizes[datasizes < min_cnt_lvl_datasize])
    print ("Explore UB of Prev Lvl", explore_pre_lvl_datasize_ub)
    print ("Explore LB of Cnt Lvl", explore_cnt_lvl_datasize_lb)
    
    # Compute base value so that each transition region will have 4 data points
    num_points=1
    
    exploreCntLvlLbRange=compute_npts_linear_range(explore_cnt_lvl_datasize_lb, \
                                                   min_cnt_lvl_datasize, False, num_points)
    explorePrvLvlUbRange=compute_npts_linear_range(max_prev_lvl_datasizes, \
                                            explore_pre_lvl_datasize_ub, False, num_points)
    numSteps=math.log(min_cnt_lvl_datasize-explore_cnt_lvl_datasize_lb, 2) + \
              math.log(explore_pre_lvl_datasize_ub-max_prev_lvl_datasizes,2)
    print ("explore Ub of prev lvl:", explorePrvLvlUbRange)
    print ("explore Lb of cnt lvl:", exploreCntLvlLbRange)
    steps=np.append(explorePrvLvlUbRange, exploreCntLvlLbRange)
    print ("Comb:", steps)
    return steps, numSteps

# Toy function useful for debugging curve_fit()
# def model_fit_fn1(x, a, b):
#     ans= a * np.exp(-b * x)
#     print("HEHEx",x)
#     print("HEHE",ans)
#     print("HEHE ndim",ans.ndim)
#     print("HEHE type",type(ans))
#     ans=np.array([1.0,1,1,1,1,1,1,1,1,1])
#     return ans

# qkx is i*lfb_ki derived from counters
def model_fit_fn(qkx, lat, Delta):
    latDeltaVec=np.linspace(lat,lat+(QSIZE-1)*Delta, QSIZE)    
    latDeltaVec=1/latDeltaVec
    latDeltaVec=latDeltaVec[:,None]
    ans = qkx @ latDeltaVec
    return ans.flatten()

def read_raw_file(raw_file, datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its, \
                  L1_GB_ss, L2_GB_ss, L3_GB_ss, ram_GB_ss, \
                  lfbcs, lfbks, lfboccs, clks, codelet_names, archs):
    print("RAW FILE:", raw_file)
    with open (raw_file, 'rU') as input_csvfile:
        csvreader = csv.DictReader(input_csvfile, delimiter=',')
        for input_row in csvreader:
            datasizes = np.append(datasizes, int(input_row['decan_experimental_configuration.data_size']))
            iters_per_rep = calculate_iterations_per_rep(input_row)
            time_per_rep = np.float64(calculate_time_per_rep(input_row, iters_per_rep)) # use float64 so 1/0 yield inf

            arch = arch_helper(input_row)
            L2_rc_per_it, L3_rc_per_it, ram_rc_per_it = calculate_mem_rc_per_it (input_row, arch)
#            print("tr", L2_rc_per_it, L3_rc_per_it, ram_rc_per_it)
            
            L1_GB_s, L2_GB_s, L3_GB_s, ram_GB_s = \
                     calculate_mem_rates_from_traffic(input_row, iters_per_rep, time_per_rep, arch, \
                                                      L2_rc_per_it, L3_rc_per_it, ram_rc_per_it)

#            print("rate", L2_GB_s, L3_GB_s, ram_GB_s)
            
            lfbc, lfbk, lfbocc = calculate_lfb_per_it (input_row)
            L2_rc_per_its = np.append(L2_rc_per_its, L2_rc_per_it)
            L3_rc_per_its = np.append(L3_rc_per_its, L3_rc_per_it)
            ram_rc_per_its= np.append(ram_rc_per_its, ram_rc_per_it)
            L1_GB_ss = np.append(L1_GB_ss, L1_GB_s)
            L2_GB_ss = np.append(L2_GB_ss, L2_GB_s)
            
            L3_GB_ss = np.append(L3_GB_ss, L3_GB_s)
            ram_GB_ss = np.append(ram_GB_ss, ram_GB_s)            
            clks = np.append(clks, getter(input_row, 'CPU_CLK_UNHALTED_THREAD'))
            codelet_names = np.append(codelet_names, input_row['codelet.name'])
            lfboccs = np.append(lfboccs, lfbocc)
            lfbcs = np.row_stack((lfbcs, lfbc))
            lfbks = np.row_stack((lfbks, lfbk))
            archs.append(arch)
    datasizes = np.array([int(i) for i in datasizes])
    return datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its, \
           L1_GB_ss, L2_GB_ss, L3_GB_ss, ram_GB_ss, \
           lfbcs, lfbks, lfboccs, clks, codelet_names, archs


def read_raw_files(raw_files):
    archs=[]
    sel_datasizes=np.array([])
    sel_L2_rc_per_its=np.array([])
    sel_L3_rc_per_its=np.array([])
    sel_ram_rc_per_its=np.array([])
    L1_GB_ss=np.array([])
    L2_GB_ss=np.array([])
    L3_GB_ss=np.array([])
    ram_GB_ss=np.array([])        
    lfbcs=np.empty((0, QSIZE+1), float)
    lfbks=np.empty((0, QSIZE), float)
    lfboccs=np.array([])
    clks=np.array([])
    codelet_names=np.empty((0), str)
    with open (raw_files, 'rU') as srun_files:
        for srun_file in srun_files:
            sel_datasizes, sel_L2_rc_per_its, sel_L3_rc_per_its, sel_ram_rc_per_its, \
                           L1_GB_ss, L2_GB_ss, L3_GB_ss, ram_GB_ss, \
                           lfbcs, lfbks, lfboccs, clks, codelet_names, archs= \
                           read_raw_file(srun_file.strip(), sel_datasizes, sel_L2_rc_per_its, \
                                         sel_L3_rc_per_its, sel_ram_rc_per_its, \
                                         L1_GB_ss, L2_GB_ss, L3_GB_ss, ram_GB_ss, \
                                         lfbcs, lfbks, lfboccs, clks, \
                                         codelet_names, archs)


    return sel_datasizes, sel_L2_rc_per_its, sel_L3_rc_per_its, sel_ram_rc_per_its, \
           L1_GB_ss, L2_GB_ss, L3_GB_ss, ram_GB_ss, \
           lfbcs, lfbks, lfboccs, clks, codelet_names, archs

def create_model(datasize, L2_rc_per_its, lfbcs, lfbks, lfboccs, clks, codelet_names):
    lfbocc_per_L2_rcs = lfboccs/L2_rc_per_its
    alpha=clks-1-lfbocc_per_L2_rcs
    pattern=re.compile(r'ptr(\d+)_movaps(?:-(\d+)lfbhit)?_branch')
    numChases=[int(pattern.match(n).group(1)) for n in codelet_names]
    numLfb=[pattern.match(n).group(2) for n in codelet_names]


    numLfb=np.array([ int(n) if n is not None else 0 for n in numLfb ])
    allLd = (numLfb+1)*numChases
    print (allLd)

    lfbks_W=lfbks[numLfb == 0,:]
    lfbcs_W=lfbcs[numLfb == 0,:]
    L2_rc_per_its_W=L2_rc_per_its[numLfb == 0]
    L2_rc_per_its_W=L2_rc_per_its_W[:,None]

    print ("/tmp/tr_{}.csv".format(datasize))
    with open ("/tmp/tr_{}.csv".format(datasize), mode='w') as out_csv_file:
        out_csv_writer = csv.writer(out_csv_file, delimiter=',')
        for tr in L2_rc_per_its_W:
            out_csv_writer.writerow(tr)

    print ("/tmp/lfbk_{}.csv".format(datasize))
    with open ("/tmp/lfbk_{}.csv".format(datasize), mode='w') as out_csv_file:
        out_csv_writer = csv.writer(out_csv_file, delimiter=',')
        for lfbks in lfbks_W:
            out_csv_writer.writerow(lfbks)


    popt, pcov = curve_fit(model_fit_fn, lfbks_W, L2_rc_per_its_W.flatten(), p0=[1, 1], bounds=(0, np.inf), method='trf')

    lat=popt[0]
    delta=popt[1]
    print(lat, delta)
    
    # Do 'secondary fit' to make latency an integer
    intLat = round(lat)
    ipopt, ipcov = curve_fit(lambda qkx, delta: model_fit_fn(qkx, intLat, delta), lfbks_W, L2_rc_per_its_W.flatten(), p0=[1], bounds=(0, np.inf), method='trf')


    iDelta=ipopt[0]
    print("iDelta", iDelta)
    # Evaluate the coefficient by computing modeled traffic and compared against measurements
    Ls=np.linspace(intLat, intLat+(QSIZE-1)*iDelta, QSIZE)
    invLs=np.diag(1/Ls)
    trs=lfbks_W@invLs
    trs=np.sum(trs, axis=1)
    tr_errs=(trs-L2_rc_per_its_W.flatten())/L2_rc_per_its_W.flatten()

    if DEBUG_MODELING:
        print("Ls", Ls)
        print("invLs", invLs)
        print("LFBK", lfbks_W)
        print("TRS",trs)    

        print("LFBC", lfbcs_W)
    print("ERR", "{:.3f}".format(max(np.abs(tr_errs))))


    # Alpha data computation

    df = pd.DataFrame({'allLd': allLd[allLd <= 32], 'alpha': alpha[allLd <= 32]})
    grMnDf=df.groupby('allLd').mean();
    # Try to do regression starting at 11 Rif
    grMnDf=grMnDf.reset_index()
    regressData=grMnDf[grMnDf['allLd']>10]
    print(regressData)
    X_data=regressData['allLd'].values
    X_data=X_data.reshape(len(X_data),1)
    Y_data=regressData['alpha'].values
    Y_data=Y_data.reshape(len(Y_data),1)
#    print(X_data)
#    print(Y_data)
#    reg=LinearRegression().fit(regressData['allLd'].values, regressData['alpha'].values)

    reg=LinearRegression().fit(X_data, Y_data)
    alpha_slope=reg.coef_[0][0]
    alpha_intercept=reg.intercept_[0]

    ax=grMnDf.plot(x='allLd', y='alpha', color='blue')
    ymin,ymax=plt.ylim()
    plt.ylim(0, ymax)
    textx=15
    texty=5
    liney=reg.predict([[textx]])
    plt.plot(X_data, reg.predict(X_data), color='red', linewidth=3)
    plt.annotate('Fitted Eqn: y={0:0.4f}x+{1:0.4f}'.format(alpha_slope, alpha_intercept), \
                 xy=(textx,liney), xytext=(textx,texty), arrowprops=dict(facecolor='black', shrink=0.05))
    plt.title('DataSize:{}'.format(datasize))
    plt.show(block=False)
    
    if DEBUG_MODELING:
        print("SLOPE", alpha_slope)
        print("INTER", alpha_intercept)



#    plt.plot(allLd[allLd <= 32], alpha[allLd <= 32])
#    plt.show()
    return intLat, iDelta, grMnDf, alpha_slope, alpha_intercept



def extract_datasizes(datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its):
    L1_datasizes=datasizes[L2_rc_per_its <= silent_cache_line_threshold]
#    plot_filtered_data(datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its, L2_rc_per_its <= silent_cache_line_threshold)

    L2_datasizes=datasizes[(L2_rc_per_its >= steady_cache_line_threshold) & (L3_rc_per_its <= silent_cache_line_threshold)]

#    plot_filtered_data(datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its, \
#                       (L2_rc_per_its >= steady_cache_line_threshold) & \
#                       (L3_rc_per_its <= silent_cache_line_threshold))


    L3_datasizes=datasizes[(L3_rc_per_its >= steady_cache_line_threshold) & (ram_rc_per_its <= silent_cache_line_threshold)]
#    plot_filtered_data(datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its, \
#                       (L3_rc_per_its >= steady_cache_line_threshold) & \
#                       (ram_rc_per_its <= silent_cache_line_threshold))

    
    
    ram_datasizes=datasizes[(ram_rc_per_its >= steady_cache_line_threshold)]
#    plot_filtered_data(datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its, \
#                       ram_rc_per_its >= steady_cache_line_threshold)

    return L1_datasizes, L2_datasizes, L3_datasizes, ram_datasizes

if args.mode == 'explore':
    print('Explore mode: trying to find out best data size for MDM experiments')
    if path.exists(RAW_FILES):
        print("Found previous runs.  Loading previous results")
    else:
        print("Previous runs not found.  Perform initial runs")

        mem_in_bytes = os.sysconf('SC_PAGE_SIZE') * os.sysconf('SC_PHYS_PAGES');
        max_size_in_bytes = mem_in_bytes * 0.8
        max_size_in_cachelines = max_size_in_bytes / 64
        min_size_in_bytes = 640
        min_size_in_cachelines = min_size_in_bytes / 64


        steps=compute_range(min_size_in_cachelines, max_size_in_cachelines, True, 4)
        do_runs(steps)
        
    assert path.exists(RAW_FILES)


    datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its,\
               L1_GB_ss, L2_GB_ss, L3_GB_ss, ram_GB_ss, \
               lfbcs, lfbks, lfboccs, clks, codelet_names, archs = \
               read_raw_files(RAW_FILES)
    

    max_total_num_steps = -1
    while True: 

#        L1_datasizes=datasizes[L2_rc_per_its <= 1-steady_cache_line_threshold]
#        L2_datasizes=datasizes[L2_rc_per_its >= steady_cache_line_threshold ]
#        L3_datasizes=datasizes[L3_rc_per_its >= steady_cache_line_threshold]

        # Try to work on ram traffic now

    
        #        print ("L1", L1_datasizes)
        #        print ("L2", L2_datasizes)
        #        print ("L3", L3_datasizes)
        
        print ("DS: ", datasizes)
        print ("CLK: ", clks)        
        print ("L2: ", L2_rc_per_its)
        print ("L3: ", L3_rc_per_its)
        print ("RAM: ", ram_rc_per_its)


        L2_steps, num_L2_steps=refine_transition(datasizes, L2_rc_per_its)
        L3_steps, num_L3_steps=refine_transition(datasizes, L3_rc_per_its)
        ram_steps, num_ram_steps=refine_transition(datasizes, ram_rc_per_its)


        cnt_max_ram_datasizes=max(datasizes[ram_rc_per_its >= steady_cache_line_threshold])
        cnt_min_failed_ram_datasizes=min(datasizes[(ram_rc_per_its <= silent_cache_line_threshold) & (datasizes > cnt_max_ram_datasizes)])

        ram_ub_steps=compute_npts_linear_range(cnt_max_ram_datasizes, \
                                               cnt_min_failed_ram_datasizes, False, 1)
        print("Explore max RAM size between {} and {}".
              format(cnt_max_ram_datasizes, cnt_min_failed_ram_datasizes))
        print("RAM STEPS", ram_ub_steps)

        num_ram_ub_steps=math.ceil(math.log(cnt_min_failed_ram_datasizes - \
                                            cnt_max_ram_datasizes, 2))

        num_total_steps = int(num_L2_steps + num_L3_steps + num_ram_steps + num_ram_ub_steps)

        if max_total_num_steps == -1:
            max_total_num_steps = num_total_steps
            root = Tk()
            prog=ttk.Progressbar(root, orient = HORIZONTAL, length=120)
            prog.pack()
            prog.config(mode='determinate', maximum=max_total_num_steps, value=0)
        else:
            prog['value']=max_total_num_steps-num_total_steps
        root.update_idletasks()
        print("Num steps ahead:", num_total_steps)
        print("L2 steps", L2_steps)
        print("L3 steps", L3_steps)
        print("ram steps", ram_steps)
        print("ram UB steps", ram_ub_steps)
        all_steps = np.append(np.append(np.append(L2_steps, L3_steps), ram_steps), ram_ub_steps)
        all_steps = set([int(i) for i in all_steps]) # Force to be int (some empty list may cause other to become float)

        all_datasizes = set(datasizes)
        print("ALL steps", all_steps)
        print("ALL DS", all_datasizes)
        remain_all_steps=sorted(all_steps.difference(all_datasizes))
        print("REMAIN", remain_all_steps)

        if not remain_all_steps:
            # No more new steps
            print("not remain", not(remain_all_steps))
            break
#        plot_data(datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its)
        raw_file=do_runs(remain_all_steps)
        datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its, \
                   L1_GB_ss, L2_GB_ss, L3_GB_ss, ram_GB_ss, \
                   lfbcs, lfbks, lfboccs, clks, codelet_names, archs= \
                   read_raw_file(raw_file, datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its, \
                                 L1_GB_ss, L2_GB_ss, L3_GB_ss, ram_GB_ss, \
                                 lfbcs, lfbks, lfboccs, clks, \
                                 codelet_names, archs)                                 

    # Filter out failed runs
    datasizes0=datasizes
    datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its = \
               sort_data(datasizes0, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its)
    print("L2Rate", L3_GB_ss)
    print("RAmRate", ram_GB_ss)    
    datasizes_rate, L2_GB_ss, L3_GB_ss, ram_GB_ss = \
               sort_data(datasizes0, L2_GB_ss, L3_GB_ss, ram_GB_ss)

    
#    print("ORIG DS", datasizes)
#    print("ORIG DS rate", datasizes_rate)
    assert(np.array_equal(datasizes, datasizes_rate))

    max_non_failing_DS=max(datasizes[ram_rc_per_its > 0])
    L2_rc_per_its=L2_rc_per_its[datasizes <= max_non_failing_DS]
    L3_rc_per_its=L3_rc_per_its[datasizes <= max_non_failing_DS]
    ram_rc_per_its=ram_rc_per_its[datasizes <= max_non_failing_DS]
    L2_GB_ss=L2_GB_ss[datasizes <= max_non_failing_DS]
    L3_GB_ss=L3_GB_ss[datasizes <= max_non_failing_DS]
    ram_GB_ss=ram_GB_ss[datasizes <= max_non_failing_DS]    
    datasizes=datasizes[datasizes <= max_non_failing_DS]



    L1_datasizes, L2_datasizes, L3_datasizes, ram_datasizes = extract_datasizes(datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its)

    L1_chosen_datasize  = int(math.ceil((max(L1_datasizes) + min(L1_datasizes))/2))
    L2_chosen_datasize  = int(math.ceil((max(L2_datasizes) + min(L2_datasizes))/2))
    L3_chosen_datasize  = int(math.ceil((max(L3_datasizes) + min(L3_datasizes))/2))
    ram_chosen_datasize = int(math.ceil((max(ram_datasizes) + min(ram_datasizes))/2))
    print("L1 DS: ", L1_datasizes, "chosen", L1_chosen_datasize)
    print("L2 DS: ", L2_datasizes, "chosen", L2_chosen_datasize)
    print("L3 DS: ", L3_datasizes, "chosen", L3_chosen_datasize)
    print("Ram DS: ", ram_datasizes, "chosen", ram_chosen_datasize)

    if not path.exists(SELECTED_DS_RUN_FILE):
        srun_file=do_runs([L1_chosen_datasize, L2_chosen_datasize, L3_chosen_datasize, ram_chosen_datasize])
        with open(SELECTED_DS_RUN_FILE, "a") as myfile: myfile.write(srun_file+"\n")

    sel_datasizes, sel_L2_rc_per_its, sel_L3_rc_per_its, sel_ram_rc_per_its, \
                   sel_L1_GB_ss, sel_L2_GB_ss, sel_L3_GB_ss, sel_ram_GB_ss, \
                   _,_,_,_,_,_ = \
                   read_raw_files(SELECTED_DS_RUN_FILE)
                      
    print("SDS:", sel_datasizes)
    print("SL2:", ["{0:0.2f}".format(i) for i in sel_L2_rc_per_its])
    print("SL3:", ["{0:0.2f}".format(i) for i in sel_L3_rc_per_its])
    print("SRAM:",["{0:0.2f}".format(i) for i in sel_ram_rc_per_its])

    print("L2 rc", len(L2_rc_per_its), L2_rc_per_its)
    print("L3 rc", len(L3_rc_per_its), L3_rc_per_its)    
    print("L2 rate", len(L2_GB_ss), L2_GB_ss)
    print("L3 rate", len(L3_GB_ss), L3_GB_ss)    

    plot_data(datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its, sel_datasizes, True, 'Traffic Per Iteration')
    plot_data(datasizes, L2_GB_ss, L3_GB_ss, ram_GB_ss, sel_datasizes, True, 'MemRate')    
    plot_data(datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its, sel_datasizes, False, 'Traffic Per Iteration')    

#     print("L1(L2/L3/Ram traffic)", L2_rc_per_its[datasizes == L1_chosen_datasize], \
#           L3_rc_per_its[datasizes == L1_chosen_datasize], ram_rc_per_its[datasizes == L1_chosen_datasize])
#     print("L2(L2/L3/Ram traffic)", L2_rc_per_its[datasizes == L2_chosen_datasize], \
#           L3_rc_per_its[datasizes == L2_chosen_datasize], ram_rc_per_its[datasizes == L2_chosen_datasize])
#     print("L3(L2/L3/Ram traffic)", L2_rc_per_its[datasizes == L3_chosen_datasize], \
#           L3_rc_per_its[datasizes == L3_chosen_datasize], ram_rc_per_its[datasizes == L3_chosen_datasize])
#     print("ram(L2/L3/Ram traffic)", L2_rc_per_its[datasizes == ram_chosen_datasize], \
#           L3_rc_per_its[datasizes == ram_chosen_datasize], ram_rc_per_its[datasizes == ram_chosen_datasize])
    

    input("Paused press any key to exit...")
    exit()
    print("DONE datasizse exploration")
else:
    print('Model building mode: trying to determining modeling data for MDM experiments')
    if not path.exists(SELECTED_DS_RUN_FILE):
        print("Preselected data file not found.  Run this command with --explore flag to determine data sizes")
        exit(-1)

    datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its, _,_,_,_, lfbcs, lfbks, lfboccs, clks, codelet_names, archs = \
               read_raw_files(SELECTED_DS_RUN_FILE)
        

    L1_datasizes, L2_datasizes, L3_datasizes, ram_datasizes = extract_datasizes(datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its)

    print("L1 datasize:", L1_datasizes)
    print("L2 datasize:", L2_datasizes)
    print("L3 datasize:", L3_datasizes)
    print("RAM datasize:", ram_datasizes)

    assert len(L1_datasizes) == 1
    assert len(L2_datasizes) == 1
    assert len(L3_datasizes) == 1
    assert len(ram_datasizes) == 1    

#    modeling_data_sizes=np.append(np.append(np.append(L1_datasizes, L2_datasizes), L3_datasizes), ram_datasizes)


    if args.mode == 'build':
        modeling_data_sizes=np.append(np.append(L2_datasizes, L3_datasizes), ram_datasizes)
        if not path.exists(MODELING_FILES):
            do_modeling_runs (modeling_data_sizes)
    else:
        nprocs=multiprocessing.cpu_count()
        print("Parallel run", nprocs)
        proc_list=[int(i) for i in np.linspace(2, nprocs, nprocs/2)]
        modeling_data_sizes=np.append(L3_datasizes, ram_datasizes)
        if not path.exists(MODELING_BW_FILES):
            do_bw_modeling_runs (modeling_data_sizes, proc_list)

        exit()


    print("Loading modeling run results...")
    
    MODELING_FILES="modeling_raw_files.test.txt"
    datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its, _,_,_,_, \
               lfbcs, lfbks, lfboccs, clks, codelet_names, archs \
               = read_raw_files(MODELING_FILES)

    archs_set = set(archs)
    if len(archs_set) == 1:
        model_arch=next(iter(archs_set))
    else:
        print("Modeling results contain multiple archs")
        exit()

    #    print(lfboccs)

    taus = []
    deltas = []
    alphas = None
    alpha_slopes=['Slope']
    alpha_intercepts=['Intercept']    
    #modeling_data_sizes= np.array([5611, 142195, 18174154])
    for ds in modeling_data_sizes:
        tau, delta, alpha_info, alpha_slope, alpha_intercept= \
             create_model(ds, L2_rc_per_its[ds == datasizes], lfbcs[ds == datasizes], \
                          lfbks[ds == datasizes], lfboccs[ds == datasizes], clks[ds == datasizes], \
                          codelet_names[ds == datasizes])
        taus.append(tau)
        deltas.append(delta)
        alpha_slopes.append(alpha_slope)
        alpha_intercepts.append(alpha_intercept)        
        if alphas is None:
            print("HERE")
            alphas = alpha_info
        else:
            print("ALPHAS", alphas)
            print("INFO", alpha_info)
#            alphas = alphas.set_index('allLd').join(alpha_info.set_index('allLd'))
#            alphas = alphas.set_index('allLd').join(alphas.set_index('allLd'))
            alphas = alphas.merge(alpha_info, on='allLd', sort=True)
                                                    

    with open ("tau-delta-{}.csv".format(model_arch), mode='w') as tau_delta_file:
        out_csv_writer = csv.writer(tau_delta_file, delimiter=',')
        for tau, delta in zip(taus, deltas):
            out_csv_writer.writerow(["{}".format(int(tau)), "{:.4f}".format(delta)])

    print(alphas)
    alpha_file='alpha-{}.csv'.format(model_arch)
    alphas.to_csv(alpha_file, header=False, index=False)
    with open(alpha_file,'a') as fd:
        out_csv_writer = csv.writer(fd, delimiter=',')
        out_csv_writer.writerow(alpha_slopes)
        out_csv_writer.writerow(alpha_intercepts)        

    input("Press Enter to end this run...")
    exit()

    datasizes, L2_rc_per_its, L3_rc_per_its, ram_rc_per_its, lfbcs, lfbks, lfboccs = read_raw_files(SELECTED_DS_RUN_FILE)


    print(lfbc)
    print(lfbk)    
    
