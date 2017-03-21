#!/bin/bash

cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="ARG" ;count=$2; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="HIS" ;count=$3; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="LYS" ;count=$4; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="ASP" ;count=$5; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="GLU" ;count=$6; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="SER" ;count=$7; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="THR" ;count=$8; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="ASN" ;count=$9; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="GLN" ;count=$10; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="CYS" ;count=$11; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="GLY" ;count=$12; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="PRO" ;count=$13; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="ALA" ;count=$14; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="VAL" ;count=$15; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="ILE" ;count=$16; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="LEU" ;count=$17; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="MET" ;count=$18; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="PHE" ;count=$19; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="TYR" ;count=$20; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
cat top8000_matrix.dat | while read line; do awk \
    '{res1=$1; res2="TRP" ;count=$21; print "\x27"res1"-"res2"\x27"":""\x27"count"\x27"","}';done
