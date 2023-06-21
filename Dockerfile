FROM rust:1.67 as builder

RUN USER=root cargo new --bin rust-react-chat
WORKDIR /rust-react-chat
COPY . .
RUN cargo build --release
RUN rm src/*.rs

ADD . ./

RUN rm ./target/release/deps/rust_react_chat*
RUN cargo build --release
RUN ls .

FROM debian:buster-slim AS debian
ARG APP=/usr/src/app/

RUN apt-get update \
    && apt-get install -y ca-certificates tzdata sqlite3\
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8080

ENV TZ=Etc/UTC \
    APP_USER=appuser

RUN groupadd $APP_USER \
    && useradd -g $APP_USER $APP_USER \
    && mkdir -p ${APP}

COPY --from=builder /rust-react-chat/target/release/rust_react_chat ${APP}/rust-react-chat

RUN chown -R $APP_USER:$APP_USER ${APP}

USER $APP_USER
WORKDIR ${APP}

CMD ["./rust-react-chat"]