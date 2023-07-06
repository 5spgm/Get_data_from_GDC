# Get_data_from_GDC
#　GDC data portal( https://portal.gdc.cancer.gov/ )に収録されているファイルをダウンロードするためのスクリプト群です。
## This repository is under construction. It is not yet available.

## GDCのサイトで準備するもの
- マニフェストファイル
- サンプルシート

## 含まれるもの
- config.sh
- gdc_api_DL.sh　
- RNAseq_list.R

## 動作確認済の環境
- Ubuntu 22.04
- R version 4.3.0

## 必要なRパッケージ
- dplyr
- openxlsx

## つかいかた
### ファイル情報の入力
```bash config.sh

### ファイルの取得
```bash gdc_api.sh ***(上記config.shで作成したテキストファイル名)```

### 個々のファイルを合体
```R --vanilla --slave --args *1 *2 < RNAseq_list.R```

*1は任意の識別名称。例えば大腸癌だとCOAD、膵臓癌だとPAADなど
*2マニフェストファイル名
