FROM golang:1.14.4-alpine as code

#Download & Install govc
RUN apk update && apk add git findutils \
	&& go get -u github.com/vmware/govmomi/govc \
	&& apk del git \
        && rm -rf /var/cache/apk/*

FROM alpine 

COPY --from=code /go/bin/govc /usr/local/bin/govc

RUN apk update  \
    && apk add bash jq ipcalc awake curl \
    && rm -rf /var/cache/apk/*

ENTRYPOINT ["/usr/local/bin/govc"]