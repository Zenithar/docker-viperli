FROM alpine:edge
MAINTAINER Thibault NORMAND  <me@zenithar.org>

RUN apk add --update \
    build-base autoconf automake libtool \
    python python-dev py-pip \
    openssl openssl-dev pcre-dev jansson-dev \
    git ca-certificates\
    swig file libffi libffi-dev \
    && update-ca-certificates \
    && pip install virtualenv PySocks SQLAlchemy PrettyTable python-magic \
    && rm -rf /var/cache/apk/*

RUN wget http://downloads.sourceforge.net/project/ssdeep/ssdeep-2.13/ssdeep-2.13.tar.gz \
    && tar zxvf ssdeep-2.13.tar.gz \
    && cd ssdeep-2.13 \
    && ./configure --prefix=/usr \
    && make \
    && make install \
    && cd .. \
    && rm -rf ssdeep-2.13*

RUN wget https://github.com/plusvic/yara/archive/v3.4.0.tar.gz \
    && tar zxvf v3.4.0.tar.gz \
    && rm -f v3.4.0.tar.gz \
    && cd yara-3.4.0 \
    && ./bootstrap.sh \
    && ./configure --prefix=/usr --with-crypto --enable-cuckoo \
    && make \
    && make install \
    && cd yara-python \
    && python setup.py build \
    && python setup.py install \
    && cd / \
    && rm -rf v3.4.0* 

RUN git clone https://github.com/viper-framework/viper /app \
    && cd /app \
    && virtualenv /env \
    && /env/bin/pip install -r requirements.txt

WORKDIR /app
ENTRYPOINT ["/env/bin/python", "/app/viper.py"]
