#!/bin/sh
#mapping fastq files from MiSeq run to reference, followed by sorting and indexing. Bash loop that operates on all files in a list.

ref="/home/mareike.janiak/data/Alouatta_mapping/human_RNASE1_fit.fa" #create variable for reference file
fastq="/home/mareike.janiak/data/Alouatta_mapping/MiSeq_7March19"                 #create variable for fastq directory    
bwadir="/home/mareike.janiak/data/Alouatta_mapping/mapping/bwa_out"     #create variable for output directory

while read line;do
        mkdir -p $bwadir/sbatch/;         #make directory for sbatch files created below
        mkdir -p $bwadir/errors/;       #make directory for error files
        mkdir -p $bwadir/stdout/;       #make directory for standard out files

#what to write to individual qsub files
	echo "#!/bin/sh
#SBATCH -t 0-08:00:00
#SBATCH -N 1 
#SBATCH -n 4
#SBATCH --mem=4G
#SBATCH -e /home/mareike.janiak/data/Alouatta_mapping/mapping/bwa_out/errors/$line.err
#SBATCH -o /home/mareike.janiak/data/Alouatta_mapping/mapping/bwa_out/stdout/$line.out
#SBATCH --job-name=$line

bwa mem -M $ref $fastq/${line}_L001_R1_001.fastq.gz $fastq/${line}_L001_R2_001.fastq.gz -t4 | samtools view -@4 -Sbh - | samtools sort -@4 -T $bwadir/${line}.sort.tmp -O bam -o - > $bwadir/${line}.sort.bam; samtools index $bwadir/${line}.sort.bam" > $bwadir/sbatch/$line.bwa.sbatch; sbatch $bwadir/sbatch/$line.bwa.sbatch; done < $fastq/sample_list.txt

