args<-commandArgs(trailingOnly = T)
#configのファイルを読み込む
config<-read.delim(args[1],header=F)
config[,1]<-gsub(" ","",config[,1])

print(paste("データベースは",config[2,1]))
print(paste("癌種は",config[3,1]))

#合体用SNVファイルの作成
#args<-c("HNSC","gdc_sample_sheet.2023-04-24_tongue.tsv")

file<-read.delim("files.txt",header=F);head(file)
sheet<-read.delim(config[8,1],header=T);head(sheet)
filename<-paste(config[2,1],"_",config[3,1],sep="")

summary(sheet)
sheet[,2]<-gsub(".rna_seq.augmented_star_gene_counts","",sheet[,2])

head(manifest)
# 必要なパッケージの読み込み
library(dplyr)
library(openxlsx)
 
# 操作対象となるデータフレームの準備
 
#man2は、複数のファイルが収録されてるもの（Normal、Tumor、Primary、Metaなど）

sheet_n<-subset(sheet,sheet[,8]=="Solid Tissue Normal")
sheet_t<-subset(sheet,sheet[,8]=="Primary Tumor")

#man_t<-subset(manifest,manifest[,8]=="Primary Blood Derived Cancer - Peripheral Blood")


#man1は、ファイルの重複がないもの
sheet1<-sheet_t %>%
  group_by(sheet_t$Case.ID) %>%
  filter(n()==1)
sheet1<-as.data.frame(sheet1)
dim(sheet1)

sheet2<-sheet_t %>%
  group_by(sheet_t$Case.ID) %>%
  filter(n()>1)
sheet2<-as.data.frame(sheet2)
dim(sheet2)

#man3は、同一IDのファイルが２つ収録されているもの
sheet3<-sheet2 %>%
  group_by(sheet2$Sample.ID) %>%
  filter(n()>1)
sheet3<-as.data.frame(sheet3)
dim(sheet3)
sheet3<-sheet3[!duplicated(sheet3[,6]),];dim(sheet3)

#man4は、IDの重複がないもの
sheet4<-sheet2 %>%
  group_by(sheet2$Sample.ID) %>%
  filter(n()==1)
sheet4<-as.data.frame(sheet4)
dim(sheet4)

sheet5<-rbind(sheet3,sheet4);dim(sheet5)
#01Aと01Bが両方ある場合、01Aを落とす
sheet5<-sheet5[grep("-01A",sheet5[,7]),];dim(sheet5)

sheet<-rbind(sheet_n,sheet1[,c(1:8)],sheet5[,c(1:8)])
dim(sheet)

sheet<-subset(sheet)


exp1<-read.delim(sheet[1,2],header=F)
colnames(exp1)<-c(exp1[2,]);exp1<-exp1[-(1:6),]

exp1_count<-exp1[,c(1:4)];colnames(exp1_count)[4]<-sheet[1,7]
exp1_tpm<-exp1[,c(1:3,7)];colnames(exp1_tpm)[4]<-sheet[1,7]
exp1_fpkm<-exp1[,c(1:3,8)];colnames(exp1_fpkm)[4]<-sheet[1,7]

head(exp1)

ifelse(config[4,1]=="y",
for (i in 2:nrow(sheet)){
    exp<-read.delim(sheet[i,2],header=F)
    colnames(exp)<-c(exp[2,]);exp<-exp[-(1:6),]
    exp_fpkm<-exp[,c(1,8)];colnames(exp_fpkm)[2]<-sheet[i,7]
    exp_tpm<-exp[,c(1,7)];colnames(exp_tpm)[2]<-sheet[i,7]
    exp_count<-exp[,c(1,4)];colnames(exp_count)[2]<-sheet[i,7]
    exp1_fpkm<-merge(exp1_fpkm,exp_fpkm,by="gene_id")
    exp1_tpm<-merge(exp1_tpm,exp_tpm,by="gene_id")
    exp1_count<-merge(exp1_count,exp_count,by="gene_id")
    print(i);print(sheet[i,7])
},
for (i in 2:nrow(sheet)){
    exp<-read.delim(sheet[i,2],header=F)
    colnames(exp)<-c(exp[2,]);exp<-exp[-(1:6),]
    exp_count<-exp[,c(1,4)];colnames(exp_count)[2]<-sheet[i,7]
    exp_tpm<-exp[,c(1,7)];colnames(exp_tpm)[2]<-sheet[i,7]
    exp1_count<-merge(exp1_count,exp_count,by="gene_id")
    exp1_tpm<-merge(exp1_tpm,exp_tpm,by="gene_id")
    print(i);print(sheet[i,7])
})

write.xlsx(exp1_count,paste(filename,"_count.xlsx",sep=""),rowName=F)
write.xlsx(exp1_tpm,paste(filename,"_TPM.xlsx",sep=""),rowName=F)
write.xlsx(exp1_fpkm,paste(filename,"_FPKM.xlsx",sep=""),rowName=F)

print("完了")

