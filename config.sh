#!/bin/bash
echo "（前段階の処理）"

read -p "Hit enter: "

echo "（続きの処理）"
read -p "GDC website ready? (y/N): " yn
case "$yn" in [yY]*) ;; *) echo "abort." ; exit ;; esac
#プロンプトをechoを使って表示
echo -n FOLDER_NAME: 
#入力を受付、その入力を「str」に代入
read str1
#結果を表示
echo $str1 "	 #保存先のフォルダ名" > $str1".txt"

echo -n Database name "(TCGA or CPTAC etc.)":
read str2
echo $str2 "	 #データベースの名前" >> $str1".txt"

echo -n Tumor name "(GDC abbrebiation)":
read str3
echo $str3 "	 #腫瘍の名前" >> $str1".txt"

echo -n Prepare FPKM list?: 
read str4
echo $str4 "	 #FPKMリストの作成" >> $str1".txt"

echo -n Prepare TPM list?:
read str5
echo $str5 "	 #TPMリストの作成" >> $str1".txt"

echo -n Prepare Count list?:
read str6
echo $str6 "	 #リードカウントリストの作成" >> $str1".txt"

echo -n Manifest name?:
read str7
echo $str7 "	 #マニフェストファイルの名前" >> $str1".txt"

echo -n Sample sheet name?:
read str8
echo $str8 "	 #サンプルシートファイルの名前" >> $str1".txt"

cat $str1".txt"
#exit
