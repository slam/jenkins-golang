FROM jenkins

USER root

# FROM golang
# gcc for cgo
RUN apt-get update && apt-get install -y \
        gcc libc6-dev make \
        --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

ENV GOLANG_VERSION 1.4.2

RUN curl -sSL https://golang.org/dl/go$GOLANG_VERSION.src.tar.gz \
        | tar -v -C /usr/src -xz

RUN cd /usr/src/go/src && ./make.bash --no-clean 2>&1

ENV PATH /usr/src/go/bin:$PATH

RUN mkdir -p /go/src /go/bin && chmod -R 777 /go
ENV GOPATH /go
ENV PATH /go/bin:$PATH

# install the ec2 cli tools
RUN apt-get update && \
    apt-get install -yq --no-install-recommends  awscli groff-base python-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN pip install awsebcli

USER jenkins
