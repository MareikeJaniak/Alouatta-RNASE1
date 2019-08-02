#call variants from reads mapped to consensus sequence generated from initial mapping against human reference. By re-mapping against consensus sequence, variant calling is improved, as reference allele is actually always present in at least one read.

ref="/home/mareike.janiak/data/Alouatta_mapping/mapping/consensus_sequences"
bam_files="/home/mareike.janiak/data/Alouatta_mapping/mapping/bwa_out/AddedRG"
freebayes_out="/home/mareike.janiak/data/Alouatta_mapping/variant_calling/freebayes/"


while read line; do
	echo "#!/bin/bash
#SBATCH -t 0-10:00:00
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --mem=8G
#SBATCH -e $freebayes_out/errors/$line.freebayes.err
#SBATCH -o $freebayes_out/stdout/$line.freebayes.out

/home/mareike.janiak/freebayes/bin/freebayes -f $ref/$line.consensus.fa $bam_files/$line.consensus.RG.markdup.bam --report-all-haplotype-alleles --haplotype-length 0 > $freebayes_out/$line.consensus.var.vcf" > $freebayes_out/sbatch/${line}.consensus_freebayes.sbatch; done < /home/mareike.janiak/data/Alouatta_mapping/MiSeq_7March19/sample_list.txt
