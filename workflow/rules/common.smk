from snakemake.utils import validate
import pandas as pd

# this container defines the underlying OS for each job when using the workflow
# with --use-conda --use-singularity
singularity: "docker://continuumio/miniconda3"

##### load config and sample sheets #####

configfile: "config/config.yaml"
validate(config, schema="../schemas/config.schema.yaml")

samples = pd.read_csv(config["samples"], sep=",").set_index("sample", drop=False)

#validate(samples, schema="../schemas/samples.schema.yaml")

threads=config['threads']

def get_fastq(wildcards):
    fastqs = samples.loc[wildcards.sample, ["fq1", "fq2"]].dropna()

    if len(fastqs) == 2:
        return f"{fastqs.fq1}", f"{fastqs.fq2}"
    return f"{fastqs.fq1}"

def get_trimmed_fastq(wildcards):
    host=wildcards.sample.split('_')[0]
    print(host)
    return {'genome_index': f'resources/index/{host}', 'fq1': f'results/quality_analysis/{wildcards.sample}_R1_val_1.fq.gz', 'fq2': f'results/quality_analysis/{wildcards.sample}_R2_val_2.fq.gz'}

def get_resources(wildcards):
    if wildcards.host == 'Inter':
        return {'fasta': 'resources/Vellozia_intermedia.pseudochroms.fasta', 'gff': 'resources/Vellozia_intermedia.gff3'}
    else:
        return {'fasta': 'resources/Vellozia_nivea.pseudochroms.fasta', 'gff': 'resources/Vellozia_nivea.gff3'}