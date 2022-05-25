FROM node:18.2.0-buster-slim

RUN apt update \
  && apt upgrade -y \
  && apt install -y \
    vim \
    curl  \
    jq 

RUN npm install mqtt -g

COPY ./resource/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "-h" ]

