FROM elixir:1.13.4

RUN apt update \
  && apt upgrade -y \
  && apt install -y \
    bash \
    vim \
    curl  \
  && mkdir /data

COPY ./resource/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "-h" ]

