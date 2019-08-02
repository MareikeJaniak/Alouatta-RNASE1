# Re-run freebayes to call long haplotypes, using vcf file generated from calling variants on bam files from mapping against consensus sequence. 
# freebayes -f ref.fa --haplotype-length ?? --haplotype-basis-alleles $line.consensus.var.filtered.vcf $line.consensus.RG.markdup.bam > haps.vcf
# Use reads marked as duplicates? Length? Limit to positions 680-end? Other filters?

hap_out="/home/mareike.janiak/data/Alouatta_mapping/variant_calling/freebayes/haplotype_calling"
ref="/home/mareike.janiak/data/Alouatta_mapping/mapping/consensus_sequences"
bam_files="/home/mareike.janiak/data/Alouatta_mapping/mapping/bwa_out/AddedRG"
freebayes_out="/home/mareike.janiak/data/Alouatta_mapping/variant_calling/freebayes/"

while read line; do
        echo "#!/bin/bash
#SBATCH -t 0-10:00:00
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --mem=8G
#SBATCH -e $hap_out/errors/$line.freebayes_haplotypes.err
#SBATCH -o $hap_out/stdout/$line.freebayes_haplotypes.out

/home/mareike.janiak/freebayes/bin/freebayes -f $ref/$line.consensus.fa --region ${line}_RNASE1_consensus:690-1155 --haplotype-length 50 --report-all-haplotype-alleles --haplotype-basis-alleles $freebayes_out/$line.consensus.var.filtered.vcf.gz $bam/$line.consensus.RG.markdup.bam > $hap_out/$line.hap.vcf" > $hap_out/sbatch/${line}.freebayes_haplotypes.sbatch; done < /home/mareike.janiak/data/Alouatta_mapping/MiSeq_7March19/sample_list.txt
