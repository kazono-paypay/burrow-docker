# builder
FROM golang:1.21 as builder

ENV BURROW_VERSION 1.6.0

RUN wget "https://github.com/linkedin/Burrow/archive/v${BURROW_VERSION}.tar.gz" \
    && tar -xzf v${BURROW_VERSION}.tar.gz \
    && cd ./Burrow-${BURROW_VERSION}/ \
    && go mod tidy \
    && go build -o /tmp/burrow .


# runner
FROM amazonlinux:2023

LABEL maintainer="kazono"

COPY --from=builder /tmp/burrow /opt
COPY ./conf/* /etc/burrow/

WORKDIR /opt

COPY ./bin/entrypoint.sh ./entrypoint.sh
RUN mkdir -p /var/log/Burrow/ && chmod +x ./entrypoint.sh

EXPOSE 8000
ENTRYPOINT ["./entrypoint.sh"]
