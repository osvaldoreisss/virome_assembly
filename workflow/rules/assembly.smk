rule create_spades_dataset:
    input: 
        fq1=expand("results/star/{sample}Unmapped.out.mate1",sample=samples['sample']),
        fq2=expand("results/star/{sample}Unmapped.out.mate2",sample=samples['sample']),
    output: 
        "results/dataset/dataset.yaml"
    run: 
        import yaml

        fq1 = list({input.fq1})
        fq2 = list({input.fq2})
        
        out_str = f"""[
            {{
                orientation: "rf",
                type: "paired-end",
                right reads:
                    {fq1}
                left reads:
                    {fq2}
            }}
        ]"""

        with open('{output}', 'w') as file:
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
