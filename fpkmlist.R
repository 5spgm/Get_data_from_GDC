args<-commandArgs(trailingOnly = T)
print(paste("癌腫は",args[1]))
print(paste("マニフェストは",args[2]))

#合体用SNVファイルの作成

file<-read.delim("files.txt",header=F);head(file)
manifest<-read.delim(paste(args[2],".tsv",sep=""),header=T);head(manifest)

summary(manifest)
manifest[,2]<-gsub(".gz","",manifest[,2])

head(manifest)
# 必要なパッケージの読み込み
library(dplyr)
 
# 操作対象となるデータフレームの準備
 
#man2は、複数のファイルが収録されてるもの（Normal、Tumor、Primary、Metaなど）

man_n<-subset(manifest,manifest[,8]=="Solid Tissue Normal")
man_t<-subset(manifest,manifest[,8]=="Primary Tumor")


#man1は、ファイルの重複がないもの
man1<-man_t %>%
  group_by(man_t$Case.ID) %>%
  filter(n()==1)
man1<-as.data.frame(man1)
dim(man1)

man2<-man_t %>%
  group_by(man_t$Case.ID) %>%
  filter(n()>1)
man2<-as.data.frame(man2)
dim(man2)

#man3は、同一IDのファイルが２つ収録されているもの
man3<-man2 %>%
  group_by(man2$Sample.ID) %>%
  filter(n()>1)
man3<-as.data.frame(man3)
dim(man3)
man3<-man3[!duplicated(man3[,6]),];dim(man3)

#man4は、IDの重複がないもの
man4<-man2 %>%
  group_by(man2$Sample.ID) %>%
  filter(n()==1)
man4<-as.data.frame(man4)
dim(man4)

man5<-rbind(man3,man4);dim(man5)
#01Aと01Bが両方ある場合、01Aを落とす
man5<-man5[grep("-01A",man5[,7]),];dim(man5)

man<-rbind(man_n,man1[,c(1:8)],man5[,c(1:8)])
dim(man)

manifest<-subset(man)


fpkm1<-read.delim(manifest[1,2],header=F)
colnames(fpkm1)<-c("symbol",as.matrix(manifest[1,7]))

head(fpkm1)

for (i in 2:nrow(manifest)){
    fpkm<-read.delim(manifest[i,2],header=F)
    colnames(fpkm)<-c("symbol",as.matrix(manifest[i,7]))
    fpkm1<-merge(fpkm1,fpkm,by="symbol")
    print(i)
}

head(fpkm1)
nrow(file)
nrow(manifest)
rownames(fpkm1)<-substring(fpkm1[,1],1,15)
fpkm1<-fpkm1[,-1]
write.table(fpkm1,paste(args[1],"_FPKM_UQ.xls",sep=""),sep="\t")

library(biomaRt)

head(listMarts())
db <- useMart("ensembl")
head(listDatasets(db))
hg <- useDataset("hsapiens_gene_ensembl", mart = db)

head(listAttributes(hg))
head(listFilters(hg))

grep("symbol",listAttributes(hg))


ensid <- c(rownames(fpkm1))

db <- useMart("ensembl")
hg <- useDataset("hsapiens_gene_ensembl", mart = db)

res <- getBM(attributes = c("ensembl_gene_id","hgnc_symbol"),
             filters = "ensembl_gene_id", 
             values = ensid,
             mart = hg)
             
fpkm1$IDs<-rownames(fpkm1)
fpkm2<-merge(res,fpkm1,by.x="ensembl_gene_id",by.y="IDs")

rownames(fpkm2)<-paste(fpkm2[,1],"-",fpkm2[,2],sep="")

head(fpkm2)
fpkm2<-fpkm2[,-(1:2)]

fpkm3<-as.data.frame(t(fpkm2))

fpkm3$type<-ifelse(substring(rownames(fpkm3),14,15)=='01',"1.Tumor","2.Normal")


write.table(fpkm3,paste("TCGA_",args[1],"_FPKM_uq_annot.txt",sep=""),sep="\t")
print("完了")






