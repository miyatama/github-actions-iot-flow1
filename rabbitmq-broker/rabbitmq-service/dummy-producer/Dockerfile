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
COPY ./resource/dummy_producer/ /app/dummy_producer/

RUN cd ./dummy_producer \
  && mix local.hex --force \
  && mix local.rebar --force \
  && mix deps.get --force \
  && MIX_ENV=prod mix compile

COPY ./resource/entrypoint.sh /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]
CMD [ "-h" ]

