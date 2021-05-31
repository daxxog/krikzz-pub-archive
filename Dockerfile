FROM python:3.9 AS archiver
RUN pip install krikzz-pub-archive-tool
WORKDIR /
RUN krikzz-pub-archive-tool

FROM caddy:2
COPY --from=archiver /krikzz-pub-archive.tar.gz /srv/krikzz-pub-archive.tar.gz
RUN tar xzvf krikzz-pub-archive.tar.gz
RUN rm krikzz-pub-archive.tar.gz
CMD caddy file-server
