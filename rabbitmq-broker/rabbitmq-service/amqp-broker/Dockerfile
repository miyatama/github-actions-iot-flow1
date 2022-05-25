FROM rabbitmq:3.9.16-management

RUN apt update \
  && apt upgrade -y \
  && apt install -y \
    vim \
    curl  \
    jq \
  && mkdir /data \
  && rabbitmq-plugins enable --offline \
    rabbitmq_mqtt

COPY ./resource/data/etc/rabbitmq/rabbitmq.conf /etc/rabbitmq/rabbitmq.conf
COPY ./resource/data/schema.json /data/schema.json
COPY ./resource/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "-h" ]

