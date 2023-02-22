#!/bin/bash
sheet=$1
echo $sheet
row=`cat $sheet | wc -l`


echo $sheet
echo $row
for i in `seq $row`
do
	echo $i'番目'
a=`cat $sheet | column -s, -t | sed -e '1d' | awk '{print $1}' | awk 'NR'==$i`
b=`cat $sheet | column -s, -t | sed -e '1d' | awk '{print $2}' | awk 'NR'==$i | sed s/.rna_seq.augmented_star_gene_counts//g`
echo $a
echo $b
curl 'https://api.gdc.cancer.gov/data/'$a > $b
done
