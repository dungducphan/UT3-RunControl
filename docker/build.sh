#!/bin/bash

if [ ! -d "epics-base" ]; then
    git clone --recursive https://github.com/epics-base/epics-base.git
    perl -i -pe  's/#INSTALL_LOCATION=<fullpathname>/INSTALL_LOCATION=\/EPICS\/epics-base/g' epics-base/configure/CONFIG_SITE
fi



docker build -t ddp822/ut3rc:1.0.0 .
#docker push ddp822/ut3rc:1.0.0