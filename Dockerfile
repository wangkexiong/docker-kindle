FROM alpine:3.12
LABEL maintainer wangkexiong

COPY kindle.sh /usr/local/bin/

RUN dos2unix /usr/local/bin/kindle.sh && \
    apk add --no-cache curl python2 python3 && \
    cd /tmp && \
    curl -fsSL https://github.com/kevinhendricks/KindleUnpack/archive/v082.tar.gz | gunzip | tar xvf - && \
    cp -r KindleUnpack-082/lib /usr/local/bin/. && \
    curl -fsSL https://archive.org/download/kindlegen/kindlegen -o /usr/local/bin/kindlegen && \
    curl -fsSL https://github.com/jefftriplett/kindlestrip/archive/v1.36.1.tar.gz | gunzip | tar xvf - && \
    cp kindlestrip-1.36.1/kindlestrip.py /usr/local/bin/. && \
    rm -rf /tmp/* && \
    chmod +x /usr/local/bin/kindle.sh /usr/local/bin/kindlegen /usr/local/bin/kindlestrip.py

VOLUME [ "/working" ]

ENTRYPOINT [ "/usr/local/bin/kindle.sh" ]
