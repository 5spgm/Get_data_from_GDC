#!/bin/bash]
config=$1

sheet=`cat $config | awk '{print $1}' | awk 'NR'==7`
type=`cat $config | awk '{print $1}' | awk 'NR'==3`
echo $sheet
row=`cat $sheet | wc -l`

echo $sheet
echo $row
for i in `seq $row`
do
	echo $i'番目'
a=`cat $sheet | column -s, -t | sed -e '1d' | awk '{print $1}' | awk 'NR'==$i`
b=`cat $sheet | column -s, -t | sed -e '1d' | awk '{print $2}' | awk 'NR'==$i | sed s/.rna_seq.augmented_star_gene_counts//g`
#c=`echo $b | sed s/.gdc_hg38//g`
echo $a
echo $b
curl 'https://api.gdc.cancer.gov/data/'$a > $b
done
#jhu-usc.edu_KIRC.HumanMethylation450.4.lvl-3.TCGA-B0-4815-11A-02D-1500-05
