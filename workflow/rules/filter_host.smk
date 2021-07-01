
rule create_index:
    input: unpack(get_resources)
    output:
        directory("resources/index/{host}")
    threads: threads
    conda: 
        "../envs/star.yaml"
    shell:
        """
        STAR --runThreadN {threads} --runMode genomeGenerate --genomeDir {output} --genomeFastaFiles {input.fasta} --sjdbGTFfile {input.gff} --sjdbOverhang 99 --genomeSAindexNbases 13
        """

rule filter_host:
    input: 
        unpack(get_trimmed_fastq)
    output:
        "results/star/{sample}Unmapped.out.mate1.fq",
        "results/star/{sample}Unmapped.out.mate2.fq"
    threads: threads
    conda:
        "../envs/star.yaml"
    shell: 
        """
        STAR --runThreadN {threads} --genomeDir {input.genome_index} --readFilesIn {input.fq1} {input.fq2} --outFilterMultimapNmax 9999999 --outFilterMismatchNmax 999 --outFilterMismatchNoverReadLmax 0.04 --outFileNamePrefix results/star/{wildcards.sample} --outSAMtype BAM Unsorted --outReadsUnmapped Fastx --readFilesCommand zcat
        dirname=$(dirname {output[0]})
        filename1=$(basename {output[0]} .fq)
        filename2=$(basename {output[1]} .fq)
        mv $dirname"/"$filename1 {output[0]}
        mv $dirname"/"$filename2 {output[1]}
        """