FROM golang:1.16.4-alpine3.13 AS builder

WORKDIR /app

ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

COPY . .

RUN go build .


FROM alpine:3.13

COPY --from=builder /app/trivy-mod-parse /app/trivy-mod-parse

ENTRYPOINT ["/app/trivy-mod-parse"]