FROM alpine:3.16 as builder

ENV RELEASE_VERSION=1.3.3

RUN apk add --no-cache ca-certificates openssl
RUN wget https://github.com/buger/goreplay/releases/download/${RELEASE_VERSION}/gor_${RELEASE_VERSION}_x64.tar.gz -O gor.tar.gz
RUN tar xzf gor.tar.gz

FROM scratch
COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /gor /
ENTRYPOINT ["/gor", "--input-raw", ":8081", "--output-kafka-host", "kafka-headless.kafka-dev.svc.cluster.local:9092", "--output-kafka-topic", "core.requests.publicapi"]