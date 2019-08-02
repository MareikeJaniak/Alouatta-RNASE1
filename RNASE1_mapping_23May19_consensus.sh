ref="/home/mareike.janiak/data/Alouatta_mapping/mapping/consensus_sequences/Apal_10X.consensus.fa" #create variable for reference file
fastq="/home/mareike.janiak/data/trimmed_fastq"                 #create variable for fastq directory    
bwadir="/home/mareike.janiak/data/Alouatta_mapping/mapping/bwa_out"     #create variable for output directory

while read line;do
        mkdir -p $bwadir/sbatch/;         #make directory for qsub files created below
        mkdir -p $bwadir/errors/;       #make directory for error files
        mkdir -p $bwadir/stdout/;       #make directory for standard out files

#what to write to individual qsub files
        echo "#!/bin/sh
#SBATCH -t 0-08:00:00
#SBATCH -N 1 
#SBATCH -n 4
#SBATCH --mem=4G
#SBATCH -e /home/mareike.janiak/data/Alouatta_mapping/mapping/bwa_out/errors/$line.consensus.err
#SBATCH -o /home/mareike.janiak/data/Alouatta_mapping/mapping/bwa_out/stdout/$line.consensus.out

bwa mem -M $ref $fastq/${line}_R1_001.fastq.gz $fastq/${line}_R2_001.fastq.gz -t4 | samtools view -@4 -Sbh - | samtools sort -@4 -T $bwadir/Apal_10X/${line}.consensus.sort.tmp -O bam -o - > $bwadir/Apal_10X/${line}.consensus.sort.bam; samtools index $bwadir/Apal_10X/${line}.consensus.sort.bam" > $bwadir/sbatch/$line.bwa.sbatch; sbatch $bwadir/sbatch/$line.bwa.sbatch; done < $fastq/fastq_files.txt

#use bwa mem function to map paired read files to consensus RNASE1 region. Each pair of fastq files is mapped, sorted and indexed. List of fastq file names to input is in fastq_files.txt.

