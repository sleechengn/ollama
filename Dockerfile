from ubuntu:jammy

#APT_CN_UBUNTU_JAMMY

run apt update \
	&& apt install -y curl aria2 \
	&& apt clean

# ollama
run set -e \
        && mkdir /opt/ollama \
	&& cd /opt/ollama \
        && DOWNLOAD=$(curl -s https://api.github.com/repos/ollama/ollama/releases/latest | grep browser_download_url |grep linux|grep amd64| grep -v rocm| cut -d'"' -f4) \
        && aria2c -x 10 -j 10 -k 1m $DOWNLOAD -o bin.tgz \
        && tar -zxvf bin.tgz \
        && rm -rf bin.tgz \
        && BIN_DIR=$(pwd)/bin \
        && ln -s $BIN_DIR/ollama /usr/bin/ollama

# filebrowser                                                                                                                                                                                                                                                                
run mkdir /opt/filebrowser \                                                                                                                                                                                                                                                 
        && cd /opt/filebrowser\                                                                                                                                                                                                                                              
        && DOWNLOAD=$(curl -s https://api.github.com/repos/filebrowser/filebrowser/releases/latest | grep browser_download_url |grep linux|grep amd64| grep -v rocm| cut -d'"' -f4) \                                                                                        
        && aria2c -x 10 -j 10 -k 1M $DOWNLOAD -o linux-amd64-filebrowser.tar.gz \                                                                                                                                                                                            
        && tar -zxvf linux-amd64-filebrowser.tar.gz \                                                                                                                                                                                                                        
        && rm -rf linux-amd64-filebrowser.tar.gz \                                                                                                                                                                                                                           
        && ln -s $(pwd)/filebrowser /usr/bin/filebrowser
# ttyd
run set -e \
       && DOWNLOAD=$(curl -s https://api.github.com/repos/tsl0922/ttyd/releases/latest | grep browser_download_url |grep ttyd.x86_64| cut -d'"' -f4) \
       && aria2c -x 10 -j 10 -k 1m $DOWNLOAD -o /usr/bin/ttyd.x86_64 \
       && chmod +x /usr/bin/ttyd.x86_64

# trzsz
run set -e \
        && mkdir /opt/trzsz && cd /opt/trzsz \
        && DOWNLOAD=$(curl -s https://api.github.com/repos/trzsz/trzsz-go/releases/latest | grep browser_download_url |grep linux_x86_64|grep tar| cut -d'"' -f4) \
        && aria2c -x 10 -j 10 -k 1m $DOWNLOAD -o bin.tar.gz \
        && tar -zxvf bin.tar.gz \
        && rm -rf bin.tar.gz \
        && BIN_DIR=$(pwd)/$(ls -A .) \
        && ln -s $BIN_DIR/trzsz /usr/bin/trzsz \
        && ln -s $BIN_DIR/trz /usr/bin/trz \
        && ln -s $BIN_DIR/tsz /usr/bin/tsz

run apt install -y nginx
run rm -rf /etc/nginx/sites-enabled/default
add ./NGINX /etc/nginx/sites-enabled/

run apt install -y tmux lrzsz

copy ./docker-entrypoint.sh /
run chmod +x /docker-entrypoint.sh
env OLLAMA_HOST=0.0.0.0:11434
cmd []
entrypoint ["/docker-entrypoint.sh"]
