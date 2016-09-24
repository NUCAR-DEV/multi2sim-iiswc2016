FROM xianggong/m2c-docker
MAINTAINER NUCAR

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y lib32gcc1 gcc-multilib lib32g++ g++-multilib
RUN cd /tmp && git clone https://github.com/Multi2Sim/multi2sim.git && cd multi2sim && git checkout iiswc2016 && libtoolize && aclocal && autoconf && automake --add-missing && ./configure && make && make install && ldconfig
COPY ./part2 /root/
COPY ./part3 /root/
COPY ./part4 /root/


