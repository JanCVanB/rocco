### Heavyweight builder ###
FROM debian:testing as builder

WORKDIR /app

# Linux
## utilities
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    curl \
    git \
    wget

# Go
## compiler
RUN wget https://go.dev/dl/go1.19.1.linux-amd64.tar.gz
RUN rm -rf /usr/local/go && \
    tar -C /usr/local -xzf go1.19.1.linux-amd64.tar.gz
ENV PATH="${PATH}:/usr/local/go/bin"
## app
COPY go.* ./
RUN go mod download
COPY invoke.go ./
RUN go build -mod=readonly -v -o server

# Roc
## compiler
RUN wget https://github.com/roc-lang/roc/releases/download/nightly/roc_nightly-linux_x86_64-2022-09-16-525cde8.tar.gz
RUN mkdir roc-release
RUN tar -xf roc_nightly-linux_x86_64-2022-09-16-525cde8.tar.gz -C roc-release
RUN apt-get -y install \
    libasound2-dev
## platform
RUN git clone https://github.com/roc-lang/roc && \
    ( cd roc && git reset --hard 525cde8 )
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
## app
COPY *.roc ./
RUN ./roc-release/roc build



### Lightweight server ###
FROM debian:testing-slim

WORKDIR /

# Linux
## SSL (minimal)
RUN set -x && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        --no-install-recommends \
        ca-certificates && \
        rm -rf /var/lib/apt/lists/*

# Go app
COPY --from=builder /app/server /app/server

# Roc app
COPY --from=builder /app/rocco /app/rocco
RUN chmod +x /app/rocco

CMD ["/app/server"]
