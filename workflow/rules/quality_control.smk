rule trim_galore:
    input: 
        get_fastq
    output: 
        fq1="results/quality_analysis/{sample}_R1_val_1.fq.gz",
        fq2="results/quality_analysis/{sample}_R2_val_2.fq.gz"
    conda:
        "../envs/trim-galore.yaml"
    threads: threads
    params:
        **config["params"]
    log: 
        "results/logs/trim_galore/{sample}.log"
    shell:
        "trim_galore {params.trim} --cores {threads} --output_dir $(dirname {output.fq1}) {input} 2> {log}"
