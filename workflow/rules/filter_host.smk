
rule create_index:
    input: unpack(get_resources)
    output:
        "resources/index/{host}"
    threads: threads
    conda: 
        "../envs/star.yaml"
    shell:
        """
        STAR --runThreadN 24 --runMode genomeGenerate --genomeDir {output} --genomeFastaFiles {input.fasta} --sjdbGTFfile {input.gff} --sjdbOverhang 99 --genomeSAindexNbases 13
        """

rule filter_host:
    input: 
        unpack(get_trimmed_fastq)
    output:
        "results/star/{sample}Unmapped.out.mate1",
        "results/star/{sample}Unmapped.out.mate2"
    threads: threads
    conda:
        "../envs/star.yaml"
    shell: 
        """
        STAR --runThreadN {threads} --genomeDir {input.genome_index} --readFilesIn {input.fq1} {input.fq2} --outFilterMultimapNmax 9999999 --outFilterMismatchNmax 999 --outFilterMismatchNoverReadLmax 0.04 --outFileNamePrefix {wildcards.sample} --outSAMtype BAM Unsorted --outReadsUnmapped Fastx --readFilesCommand zcat
        """