FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine318
RUN apk add --no-cache firefox openjdk11
RUN apk add --no-cache -X http://dl-cdn.alpinelinux.org/alpine/edge/testing wmctrl
COPY /root /
COPY /mpc-client /mpc-client
COPY /run.sh /mpc-client/
COPY /java.security /mpc-client/
