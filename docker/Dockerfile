# BUILD stage

## Install EPICS-base
FROM ubuntu:22.04 as builder

RUN mkdir /epics
WORKDIR /epics

RUN apt-get update && \
    apt-get install -y g++ make re2c wget perl && \
    apt-get autoremove && \
    apt-get autoclean

COPY ./epics-base /epics/epics-base

RUN cd /epics/epics-base && \
    mkdir -p /EPICS/epics-base && \
    make -j 32

WORKDIR /epics

RUN apt-get install -y git

COPY assemble_synApps /epics/

RUN mkdir /epics/synApps && \
    cd /epics && \
    chmod +x ./assemble_synApps && \
    ./assemble_synApps --base=/EPICS/epics-base --dir=/epics/synApps

WORKDIR /epics/synApps/support

RUN apt-get install -y libhdf5-dev libxmu-dev && \
    mkdir -p /EPICS/synApps/support && \
    perl -i -pe  's/#INSTALL_LOCATION=<fullpathname>/INSTALL_LOCATION=\/EPICS\/synApps\/support/g' /epics/synApps/support/configure/CONFIG_SITE && \
    cp /epics/synApps/support/configure/CONFIG_SITE /epics/synApps/support/configure/CONFIG_SITE.local && \
    make release

RUN cd /epics/synApps/support && \
    apt-get install -y libghc-bzlib-dev && \
    make release

RUN cd /epics/synApps/support/asyn-R4-44-2 && \
    make -j 32
    
RUN cd /epics/synApps/support/alive-R1-4-1 && \
    make -j 32

RUN cd /epics/synApps/support/autosave-R5-11 && \
    make -j 32

RUN cd /epics/synApps/support/busy-R1-7-4 && \
    make -j 32

RUN cd /epics/synApps/support/sequencer-mirror-R2-2-9 && \
    make -j 32 && \
    make install

RUN cd /epics/synApps/support/sscan-R2-11-6 && \
    perl -i -pe  's/#INSTALL_LOCATION=<\/path\/name\/to\/install\/top>/INSTALL_LOCATION=\/EPICS\/synApps\/support/g' /epics/synApps/support/sscan-R2-11-6/configure/CONFIG_SITE && \
    make && \
    make install

RUN cd /epics/synApps/support/sequencer-mirror-R2-2-9 && \
    perl -i -pe  's/#INSTALL_LOCATION = <install path>/INSTALL_LOCATION=\/EPICS\/synApps\/support/g' /epics/synApps/support/sequencer-mirror-R2-2-9/configure/CONFIG_SITE && \
    make -j 32 && \
    make install

RUN cd /epics/synApps/support/calc-R3-7-5 && \
    make -j 32

RUN cd /epics/synApps/support/iocStats-3-1-16 && \
    perl -i -pe  's/#INSTALL_LOCATION=<fullpathname>/INSTALL_LOCATION=\/EPICS\/synApps\/support/g' /epics/synApps/support/iocStats-3-1-16/configure/CONFIG_SITE && \
    make -j 32

RUN cd /epics/synApps/support/std-R3-6-4 && \
    make -j 32

RUN cd /epics/synApps/support/areaDetector-R3-12-1 && \
    cd ADCore && \
    git checkout master && \
    cd ../ADSupport && \
    git checkout master && \
    cd ../ADSimDetector && \
    git checkout master && \
    cd ../ADGenICam && \
    git checkout master && \
    cd ../ADSpinnaker && \
    git checkout master && \
    cd /epics/synApps/support/areaDetector-R3-12-1 && \
    make -j 32

RUN cd /epics/synApps/support && \
    make && \
    make install

RUN apt-get install -y vim

RUN cd /epics/synApps/support/areaDetector-R3-12-1 && \
    perl -i -pe  's/#INSTALL_LOCATION=<\/path\/name\/to\/install\/top>/INSTALL_LOCATION=\/EPICS\/synApps\/support/g' /epics/synApps/support/areaDetector-R3-12-1/configure/CONFIG_SITE && \
    make -j 32
    

# DEPLOY EPICS-BASE stage
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y vim libxmu-dev iproute2

COPY --from=builder /EPICS /EPICS

ENV EPICS_BASE=/EPICS/epics-base
ENV EPICS_HOST_ARCH=linux-x86_64
ENV PATH=${EPICS_BASE}/bin/linux-x86_64:${PATH}
ENV PATH=/EPICS/synApps/support/bin/linux-x86_64:${PATH}

RUN mkdir /EPICS/iocs

COPY ./iocs /EPICS/iocs

WORKDIR /EPICS/iocs/simDetectorIOC

RUN chmod +x ./start_epics

