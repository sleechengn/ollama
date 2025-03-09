from ubuntu:jammy

run apt update \
	&& apt install -y curl aria2 \
	&& apt clean

run curl -fsSL https://ollama.com/install.sh | sh

#run set -e \
#	&& mkdir -p /opt/ollama \
#	&& cd /opt/ollama \
#	&& aria2c -x 10 -j 10 -c "https://github.com/ollama/ollama/releases/download/v0.5.13/ollama-linux-amd64.tgz" -o "ollama-linux-amd64.tgz" \
#	&& tar -zxvf ollama-linux-amd64.tgz \
#	&& rm -rf ollama-linux-amd64.tgz

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
