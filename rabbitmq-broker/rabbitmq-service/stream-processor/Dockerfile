FROM elixir:1.13.4

RUN apt update \
  && apt upgrade -y \
  && apt install -y \
    bash \
    vim \
    curl \
    jq \
  && mkdir /app

WORKDIR /app
COPY ./resource/stream_app/ /app/stream_app/

RUN cd ./stream_app \
  && mix local.hex --force \
  && mix local.rebar --force \
  && mix deps.get --force \
  && MIX_ENV=prod mix compile

COPY ./resource/entrypoint.sh /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]
CMD [ "-h" ]

