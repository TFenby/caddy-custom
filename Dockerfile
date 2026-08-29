ARG CADDY_VERSION=2.11.4

# ---- Builder Stage ----
FROM caddy:${CADDY_VERSION}-builder AS builder

RUN xcaddy build \
    --with github.com/lucaslorentz/caddy-docker-proxy/v2 \
    --with github.com/pberkel/caddy-storage-redis \
    --with github.com/caddy-dns/cloudflare

# Final image
FROM gcr.io/distroless/static-debian13:debug

# Not sure if these are actually necessary
ENV XDG_CONFIG_HOME=/config \
    XDG_DATA_HOME=/data

EXPOSE 80 443 2019 443/udp

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

ENTRYPOINT ["/usr/bin/caddy"]
CMD ["docker-proxy"]
