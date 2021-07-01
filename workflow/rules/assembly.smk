rule create_spades_dataset:
    input: 
        fq1=expand("results/star/{sample}Unmapped.out.mate1.fq",sample=samples['sample']),
        fq2=expand("results/star/{sample}Unmapped.out.mate2.fq",sample=samples['sample']),
    output: 
        "results/dataset/dataset.yaml"
    run: 
        fq1 = input.fq1
        fq2 = input.fq2

        fq1 = (', '.join('"../../' + item + '"' for item in fq1))
        fq2 = (', '.join('"../../' + item + '"' for item in fq2))


        out_str = f"""
[
    {{
        orientation: "rf",
        type: "paired-end",
        right reads:
            [{fq1}],
        left reads:
            [{fq2}]
     }}
]"""

        with open(f'{output}', 'w') as file:
            file.write(out_str)

rule spades_assembly:
    input: 
        "results/dataset/dataset.yaml"
    output:
        directory("results/spades")
    threads: threads
    conda:
        "../envs/spades.yaml"
    shell:
        """
        rnaviralspades.py -t {threads} --dataset {input} -o {output}
        """ 
