FROM golang:1.16-alpine3.14 AS builder
RUN go get github.com/sberk42/fritzbox_exporter/

FROM alpine:latest
ENV USERNAME username
ENV PASSWORD password
ENV GATEWAY_URL http://fritz.box:49000
ENV LISTEN_ADDRESS 0.0.0.0:9042
ENV GATEWAY_LUAURL http://fritz.box
WORKDIR /root/
COPY --from=builder /go/bin/fritzbox_exporter . 
COPY metrics.json metrics-lua.json ./
EXPOSE 9042
ENTRYPOINT [ "./fritzbox_exporter" ]
CMD ./fritzbox_exporter -username $USERNAME -password $PASSWORD -gateway-url ${GATEWAY_URL} -listen-address ${LISTEN_ADDRESS} -gateway-luaurl ${GATEWAY_LUAURL}
