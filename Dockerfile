FROM ubuntu:20.04

MAINTAINER Sergey Ignatov <welcome-news@mail.ru>

RUN apt-get update && apt-get install -y --no-install-recommends make \
git \
g++ 

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

RUN export GIT_SSL_NO_VERIFY=1 \
&& git clone https://github.com/sass/libsass.git \
&& git clone https://github.com/sass/sassc.git libsass/sassc \
&& git clone https://github.com/sass/sass-spec.git libsass/sass-spec

RUN export BUILD="shared"

RUN echo "======= build app libsass =======" \
&& make -C libsass -j5 \
&& make -C libsass install

RUN echo "======= build app re2 =======" \
&& export GIT_SSL_NO_VERIFY=1 \
&& git clone https://code.googlesource.com/re2 \
&& cd /usr/src/app/re2 \
&& make \
&& make test \
&& make install \
&& make testinstall

RUN apt-get autoremove --assume-yes --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN ls -l 
RUN ls -l /usr/src/app/libsass/lib 
RUN ls -l /usr/src/app/re2/obj

#ENTRYPOINT ["sassc", "-v"]
