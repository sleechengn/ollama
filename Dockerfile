from ubuntu:jammy

#APT-PLACE-HOLDER

run apt update \
	&& apt install -y curl aria2 \
	&& apt clean

run set -e && echo install source && curl -fsSL https://ollama.com/install.sh | sh
#INSTALL-OLLAMA

run curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash
run mkdir /opt/filebrowser

RUN apt install -y nginx ttyd
RUN rm -rf /etc/nginx/sites-enabled/default
ADD ./NGINX /etc/nginx/sites-enabled/


copy ./docker-entrypoint.sh /
run chmod +x /docker-entrypoint.sh
env OLLAMA_HOST=0.0.0.0:11434
cmd []
entrypoint ["/docker-entrypoint.sh"]
