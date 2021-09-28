FROM ubuntu:20.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update --fix-missing && \
  apt-get install -y wget bzip2 build-essential \
  ca-certificates git libglib2.0-0 libxext6 libsm6 \
  libxrender1 git mercurial nano subversion vim && \
  apt-get clean

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
  /bin/bash ~/miniconda.sh -b -p /opt/conda && \
  rm ~/miniconda.sh && \
  /opt/conda/bin/conda clean -tipsy && \
  ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
  echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
  echo "conda activate base" >> ~/.bashrc && \
  find /opt/conda/ -follow -type f -name '*.a' -delete && \
  find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
  /opt/conda/bin/conda clean -afy

ENV PATH=/opt/conda/bin:$PATH

# install packages to base environment
RUN conda install mamba -n base -c conda-forge && \
    mamba install -n base -c conda-forge -c bioconda python=3.8 \
    fastqc \
    multiqc \
    star \
    trimmomatic \
    trinity \
    #cufflinks \
    rsem \
    htseq \
    #tophat \
    bioconductor-deseq2 \
    bioconductor-edger \
    r-pheatmap \
    r-ggplot2 \
    r-nlme \
    r-phytools \
    bioconductor-noiseq \
    pyrpipe -y

COPY /entrypoint.sh /opt/conda/bin/entrypoint.sh
RUN chmod a+x /opt/conda/bin/entrypoint.sh

# gatk4 example
# WORKDIR /app
# RUN wget https://github.com/broadinstitute/gatk/releases/download/4.2.2.0/gatk-4.2.2.0.zip
# RUN unzip gatk-4.2.2.0.zip
# lives at /app/gatk-4.2.2.0
# after adding to path
# picard.jar should be in PATH

#ENTRYPOINT ["/opt/conda/bin/entrypoint.sh"]
CMD [".", "/opt/conda/bin/entrypoint.sh"]