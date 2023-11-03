#!/bin/bash

curl -LO http://lftp.yar.ru/ftp/lftp-4.9.2.tar.xz

tar -xJf lftp-4.9.2.tar.xz

cd lftp-4.9.2
./configure --prefix=/global/common/software/m2650/lftp
make
make install

# add this to your script that needs to use lftp
export PATH="/global/common/software/m2650/lftp/bin:$PATH"
export LD_LIBRARY_PATH="/global/common/software/m2650/lftp/lib:$LD_LIBRARY_PATH"

