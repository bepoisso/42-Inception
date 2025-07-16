FROM debian:bullseye

RUN apt update -y
RUN apt upgrade -y

RUN apt install -y clang

COPY ./ircserv /ircserv
RUN chmod +x /ircserv

EXPOSE 6667

CMD ["bash", "-c", "./ircserv 6667 123"]
