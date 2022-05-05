FROM rabbitmq:3.9.16-management

RUN apt update \
  && apt upgrade -y \
  && apt install -y \
    vim \
    curl  \
  && mkdir /data

COPY ./resource/data/schema.json /data/schema.json
COPY ./resource/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "-h" ]

