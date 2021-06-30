from snakemake.utils import validate
import pandas as pd

# this container defines the underlying OS for each job when using the workflow
# with --use-conda --use-singularity
singularity: "docker://continuumio/miniconda3"

##### load config and sample sheets #####

configfile: "config/config.yaml"
validate(config, schema="../schemas/config.schema.yaml")

samples = pd.read_csv(config["samples"], sep=",").set_index("sample", drop=False)

validate(samples, schema="../schemas/samples.schema.yaml")

threads=config['threads']

def get_fastq(wildcards):
    fastqs = samples.loc[wildcards.accession, ["fq1", "fq2"]].dropna()

    if len(fastqs) == 2:
        return f"{fastqs.fq1}", f"{fastqs.fq2}"
    return f"{fastqs.fq1}"