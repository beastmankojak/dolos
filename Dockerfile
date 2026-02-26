FROM rust:1.93-slim-bookworm AS builder
COPY . /opt/dolos
WORKDIR /opt/dolos
RUN apt update && apt install -y pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*\
  && cargo build --target x86_64-unknown-linux-gnu --locked --release

FROM debian:12-slim

RUN apt-get update && apt-get install -y ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/dolos/.github/image/genesis /etc/genesis
COPY --from=builder /opt/dolos/target/x86_64-unknown-linux-gnu/release/dolos /bin/dolos
RUN chmod +x /bin/dolos
RUN ln -s /bin/dolos /dolos

ENTRYPOINT [ "dolos" ]
