#!/bin/bash

LC_CTYPE=en_US.UTF-8
LC_ALL=en_US.UTF-8

cd /home/paulo/Documents/Research/ExtremeEvent/NLSE

Codes="1 2 3 4 5 6 7"

for run in $Codes
do
    sem -j 8 "./nlse.jl"
done
