FROM elixir:1.9.4

COPY ./resource/app /app

RUN apt update \
  && apt upgrade -y \
  && apt install -y \
    bash \
    vim \
    curl  \
  && mkdir /data

WORKDIR /app

COPY ./resource/entrypoint.sh /app/entrypoint.sh

ENTRYPOINT [ "/app/entrypoint.sh" ]
CMD [ "-h" ]

