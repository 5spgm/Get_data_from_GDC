# Get_data_from_GDC
#　GDC data portal( https://portal.gdc.cancer.gov/ )に収録されているファイルをダウンロードするためのスクリプト群です。
## This repository is under construction. It is not yet available.

## GDCのサイトで準備するもの
- マニフェストファイル
- サンプルシート

## 含まれるもの
- gdc_api.sh　
- fpkmlist.R

## 動作確認済の環境
- Ubuntu 20.04

## つかいかた
### ファイルの取得
```bash gdc_api.sh ***(マニフェストファイル名)```

### ファイル一覧のテキストファイルを作成
```ls *.tsv > files.txt```

### 個々のファイルを合体
```R --vanilla --slave --args *1 *2 < fpkmlist.R```

*1は任意の識別名称。例えば大腸癌だとCOAD、膵臓癌だとPAADなど
*2マニフェストファイル名
