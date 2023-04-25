FROM alpine:3.17

RUN apk add ca-certificates

COPY build/pod-info /app/pod-info
COPY build/main.html /app/main.html

EXPOSE 8080

ENTRYPOINT [ "/app/pod-info" ]