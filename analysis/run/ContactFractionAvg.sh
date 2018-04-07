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
in_dir=${10}
out_dir=${11}

# Selection arguments
N=6303
L=40
chr=20

# Average
avg_py="../src/TimeAverage.py"
multi_avg_py="../src/AverageMultiFiles.py"
t_start=150000
t_end=200000
t_inc=1000
out_file="${out_dir}/wall-frac_sene_chr_${chr}_L_${L}_1.dat"
> $out_file

ehh=$(python -c "print '%.1f' % ($ehh_start)")
ehl=$(python -c "print '%.1f' % ($ehl_start)")

while (( $(bc <<< "$ehh < $ehh_end") ))
do
    ehl=$(python -c "print '%.1f' % ($ehl_start)")
    while (( $(bc <<< "$ehl < $ehl_end") ))
    do
	echo "Doing ehh = $ehh ehl = $ehl"
	name="sene_chr_${chr}_L_${L}_HH_${ehh}_HL_${ehl}"
	for (( run=$run_start; $run<=$run_end; run+=$run_inc ))
	do
	    frac_file="${in_dir}/wall-frac_${name}_run_${run}.dat"
	    avg_file="${out_dir}/wall-frac_${name}_run_${run}_avg.dat"
	    python $avg_py 0 1 $t_start $t_end $t_inc $frac_file $avg_file
	done
	multi_avg_file="${out_dir}/wall-frac_${name}_avg.dat"
	python $multi_avg_py -1 0 -1 -1 $multi_avg_file "${out_dir}/wall-frac_${name}_run"*_avg.dat
	data=$(cat $multi_avg_file)
	echo $ehh $ehl $data >> $out_file
	ehl=$(python -c "print '%.1f' % ($ehl + $ehl_inc)")
    done
    echo >> $out_file
    ehh=$(python -c "print '%.1f' % ($ehh + $ehh_inc)")
done

