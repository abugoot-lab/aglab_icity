FROM    ubuntu

RUN echo "deb http://ppa.launchpad.net/fkrull/deadsnakes/ubuntu trusty main" > /etc/apt/sources.list.d/deadsnakes.list \
    && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys DB82666C

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y \
    build-essential \
    ca-certificates \
    gcc \
    git \
    libpq-dev \
    make \
    mercurial \
    pkg-config \
    python3.4 \
    python3.4-dev \
    ssh \
    && apt-get autoremove \
    && apt-get clean

ADD https://raw.githubusercontent.com/pypa/pip/701a80f451a62aadf4eeb21f371b45424821582b/contrib/get-pip.py /root/get-pip.py
RUN python3.4 /root/get-pip.py
RUN pip3.4 install -U "setuptools==15.1"
RUN pip3.4 install -U "pip==6.1.1"
RUN pip3.4 install -U "virtualenv==12.1.1"


RUN     cd /tmp \
&&      apt-get update \
&&      apt-get install -y wget \
&&      wget https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.9.0/ncbi-blast-2.9.0+-x64-linux.tar.gz \
&&      tar xf ncbi-blast-2.9.0+-x64-linux.tar.gz \
&&      cp -r ncbi-blast-2.9.0+/bin/* /usr/local/bin/ \
&&      cd / \
&&      apt-get autoremove -y wget \
&&      rm -rf /tmp/* \
&&      rm -rf /var/lib/apt/lists/*

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


