FROM golang:alpine AS build
RUN wget https://github.com/chihaya/chihaya/archive/refs/heads/main.zip && unzip main.zip
WORKDIR chihaya-main/
RUN CGO_ENABLED=0 go install ./cmd/chihaya

FROM alpine:latest
WORKDIR app/
COPY --from=build /go/bin/chihaya .
RUN wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 && mv cloudflared-linux-amd64 cloudflared && chmod +x cloudflared
COPY chihaya.sh .
COPY chihaya-config.yaml .
CMD ["/app/chihaya.sh"]