FROM golang:alpine AS build


RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk update
RUN apk add --no-cache -U make git mercurial subversion bzr fossil

COPY . /src/goproxy
RUN cd /src/goproxy &&\
    export CGO_ENABLED=0 &&\
    make

FROM golang:alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories
RUN apk update
RUN apk add --no-cache -U git mercurial subversion bzr fossil

COPY --from=build /src/goproxy/bin/goproxy /goproxy

VOLUME /go

EXPOSE 8081

ENTRYPOINT ["/goproxy"]
CMD []

