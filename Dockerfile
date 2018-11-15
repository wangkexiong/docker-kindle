FROM alpine:3.8
LABEL maintainer wangkexiong

COPY kindle.sh /usr/local/bin/

RUN dos2unix /usr/local/bin/kindle.sh && \
    apk add --no-cache curl python python3 && \
    cd /tmp && \
    curl -fsSL https://github.com/kevinhendricks/KindleUnpack/archive/v080.tar.gz | gunzip | tar xvf - && \
    cp -r KindleUnpack-080/lib /usr/local/bin/. && \
    curl -fsSL http://kindlegen.s3.amazonaws.com/kindlegen_linux_2.6_i386_v2_9.tar.gz | gunzip | tar xvf - && \
    cp kindlegen /usr/local/bin/. && \
    curl -fsSL https://github.com/jefftriplett/kindlestrip/archive/v1.36.1.tar.gz | gunzip | tar xvf - && \
    cp kindlestrip-1.36.1/kindlestrip.py /usr/local/bin/. && \
    rm -rf /tmp/* && \
    chmod +x /usr/local/bin/kindle.sh /usr/local/bin/kindlegen /usr/local/bin/kindlestrip.py

VOLUME [ "/working" ]

ENTRYPOINT [ "/usr/local/bin/kindle.sh" ]
