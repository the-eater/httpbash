FROM bash
RUN apk add --no-cache gawk socat
COPY . /app
VOLUME ["/app/src"]
CMD ["bash", "/app/httpd.sh"]