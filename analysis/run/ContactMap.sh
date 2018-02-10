#!/bin/bash

ehh_start=$1
ehh_end=$2
ehh_inc=$3
ehl_start=$4
ehl_end=$5
ehl_inc=$6
run_start=$7
run_end=$8
run_inc=$9
dir=${10}

ehh=$(python -c "print '%.1f' % ($ehh_start)")
ehl=$(python -c "print '%.1f' % ($ehl_start)")

source 'runconfig.cfg'
contact_exe="${bin}/contact/ContactMap"

# Selection arguments
cut_off=3.0

N=6303
L=40
chr=20
rc=7
block=3
colour=0  # 0 = don't distinguish EU/HET, 1 = distinguish EU/HET
tstart=150000
tend=200000
tinc=1000

max_jobs=8
cmd=()
jobid=0

while (( $(bc <<< "$ehh < $ehh_end") ))
do
    ehl=$(python -c "print '%.1f' % ($ehl_start)")
    while (( $(bc <<< "$ehl < $ehl_end") ))
    do
	for (( run=$run_start; $run<=$run_end; run+=$run_inc ))
	do
	    echo "Calculating contact map for HH = ${ehh} HL = ${ehl} run = ${run}"

	    name="cluster_chr_${chr}_L_${L}_HH_${ehh}_HL_${ehl}_run_${run}"
	    pos_file="${dir}/pos_${name}.dat"
	    contact_file="${dir}/contact_${name}.dat"

	    cmd[$jobid]="$contact_exe $N $N $L $L $L $rc $block $colour $tstart $tend $tinc $pos_file $contact_file"
	    jobid=$(bc <<< "$jobid + 1")

	done
	ehl=$(python -c "print '%.1f' % ($ehl + $ehl_inc)")
    done
    ehh=$(python -c "print '%.1f' % ($ehh + $ehh_inc)")
done


# Parallel runs

total_jobs=$jobid
jobid=0

while (( $(bc <<< "$jobid < $total_jobs") ))
do
    for (( i=0; i<$max_jobs && $jobid < $total_jobs; i++))
    do
	echo "${cmd[jobid]} &"
	${cmd[jobid]} &
	jobid=$(bc <<< "$jobid + 1")
    done
    wait
done
