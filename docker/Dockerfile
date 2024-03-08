# BUILD stage
FROM ubuntu:22.04 as builder

RUN mkdir /epics
WORKDIR /epics

RUN apt-get update && \
    apt-get install -y g++ make re2c wget perl && \
    apt-get autoremove && \ 
    apt-get autoclean 

COPY ./epics-base /epics/epics-base

RUN cd /epics/epics-base && \
    mkdir /EPICS && \
    make -j 8 && \
    make install


# DEPLOY stage
FROM ubuntu:22.04
COPY --from=builder /EPICS /EPICS/epics-base
RUN ln -s /EPICS/epics-base/lib/linux-x86_64/libdbRecStd.so     /lib/x86_64-linux-gnu/libdbRecStd.so.3.23.1 && \
    ln -s /EPICS/epics-base/lib/linux-x86_64/libdbCore.so       /lib/x86_64-linux-gnu/libdbCore.so.3.23.1 && \
    ln -s /EPICS/epics-base/lib/linux-x86_64/libCom.so          /lib/x86_64-linux-gnu/libCom.so.3.23.1 && \
    ln -s /EPICS/epics-base/lib/linux-x86_64/libca.so           /lib/x86_64-linux-gnu/libca.so.4.14.4 && \
    ln -s /EPICS/epics-base/lib/linux-x86_64/libpvAccessCA.so   /lib/x86_64-linux-gnu/libpvAccessCA.so.7.1.8 && \
    ln -s /EPICS/epics-base/lib/linux-x86_64/libpvAccess.so     /lib/x86_64-linux-gnu/libpvAccess.so.7.1.8 && \
    ln -s /EPICS/epics-base/lib/linux-x86_64/libpvData.so       /lib/x86_64-linux-gnu/libpvData.so.8.0.7

ENV EPICS_BASE=/EPICS/epics-base
ENV EPICS_HOST_ARCH=linux-x86_64
ENV PATH=${EPICS_BASE}/bin/linux-x86_64:${PATH}
