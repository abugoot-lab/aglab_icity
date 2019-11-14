FROM arcanabio/python:3.7

RUN apt-get update && \
    apt-get install -y git build-essential make cmake vim-common libgomp1 gawk && \
    cd /root/ && \
    git clone https://github.com/soedinglab/MMseqs2 mmseqs2 && \
    cd mmseqs2 && \
    git checkout ${MMSEQS2_VERSION} && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_INSTALL_PREFIX=. .. && \
    make -j$(nproc) && \
    make install && \
    mv bin/mmseqs /usr/bin/ && \
    cd /root && \
    rm -rf /root/mmseqs2 && \
    apt-get purge -y git build-essential make cmake vim-common && \
    apt-get autoremove -y --purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo 'deb http://archive.ubuntu.com/ubuntu xenial multiverse' >> /etc/apt/sources.list \
         && apt-get update \
         && apt-get upgrade -y --force-yes \
         && apt-get install -y --force-yes \
        build-essential \
        git \
        python3-numpy \
         wget \
         gcc \
         g++ \
         python3-dev \
         unzip \
         make \
         t-coffee python3-pil \
         python3-matplotlib \
         python3-reportlab \
         python3-pip r-base \
         python3-pandas \
         && apt-get clean

RUN pip3 install rdflib --upgrade \
    && pip3 install cython --upgrade \
    && pip3 install numpy --upgrade \
    && pip3 install Pillow --upgrade \
    && pip3 install matplotlib --upgrade \
    && pip3 install pandas --upgrade


WORKDIR /
ENV PYTHON_PATH /biopython
RUN git clone https://github.com/biopython/biopython.git
WORKDIR /biopython
RUN python setup.py install

RUN apt-get update --fix-missing \
    && apt-get install -y wget g++ make \
    && cd /usr/local/ \
    && wget http://www.drive5.com/muscle/downloads3.8.31/muscle3.8.31_src.tar.gz \
    && tar -xzvf muscle3.8.31_src.tar.gz \
    && cd muscle3.8.31/src \
    && make \
    && mv muscle /usr/local/bin \
    && cd ../../ \
    && rm -rf muscle* \
    && apt-get remove -y wget g++ make \
    && apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /pasteur

LABEL tool=blast+ version=2.9.0

WORKDIR /data


