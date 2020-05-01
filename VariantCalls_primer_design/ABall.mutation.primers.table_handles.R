locus_info <- read.table("ABall.mutation.final_5.loucs.list", sep="\t", header=T)
primer_info <- read.table("ABall.mutation.primers.table_handles.txt", sep="\t", header=T)
merged_info <- merge(locus_info, primer_info, by="locus")
write.table(merged_info, "ABall.mutation.primers.table_handles.vaf.txt", quote=F,sep="\t",row.names=F)

