FROM alpine:3.20 as build

WORKDIR /src

RUN apk add --no-cache \
    gcc musl-dev make perl \
    openssl-dev pcre2-dev binutils bzip2 tar

COPY event-driven-servers-master.tar.gz /src/
RUN tar -xzf event-driven-servers-master.tar.gz && \
    cd MarcJHuber-event-driven-servers-* && \
    ./configure --prefix=/tacacs && \
    make && \
    make install && \
    strip /tacacs/sbin/tac_plus

FROM alpine:3.20

WORKDIR /

RUN apk add --no-cache \
    perl perl-io-socket-ssl perl-digest-md5 \
    openssl pcre2 nano vim

COPY --from=build /tacacs/sbin/tac_plus /usr/local/sbin/tac_plus
COPY --from=build /tacacs/lib /usr/local/lib

ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

COPY tac_plus.cfg /etc/tac_plus/tac_plus.cfg
COPY tac_user.cfg /etc/tac_plus/tac_user.cfg
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 49/tcp 49/udp

ENTRYPOINT ["/entrypoint.sh"]