########## Pull ##########
FROM nvidia/opengl:base-ubuntu20.04
########## User ##########
ARG home_dir="/home/user"
COPY copy/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN apt-get update && \
	apt-get install -y \
		gosu \
		sudo && \
	chmod +x /usr/local/bin/entrypoint.sh && \
	mkdir -p $home_dir
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
########## Non-interactive ##########
ENV DEBIAN_FRONTEND=noninteractive
########## Unity ##########
## Hub
RUN apt-get update && \
    apt-get install -y \
		wget \
		gnupg gnupg2 && \
	wget -qO - https://hub.unity3d.com/linux/keys/public | gpg --dearmor | tee /usr/share/keyrings/Unity_Technologies_ApS.gpg > /dev/null && \
	sh -c 'echo "deb [signed-by=/usr/share/keyrings/Unity_Technologies_ApS.gpg] https://hub.unity3d.com/linux/repos/deb stable main" > /etc/apt/sources.list.d/unityhub.list' && \
	apt-get update && \
    apt-get install -y \
		unityhub \
		libgbm-dev \
		firefox
## Editor
ARG editor_version=2022.3.7f1
RUN apt-get update && \
	apt-get install -y xvfb && \
	sed -i 's/^\(.*DISPLAY=:.*XAUTHORITY=.*\)\( "\$@" \)2>&1$/\1\2/' /usr/bin/xvfb-run && \
	echo '#!/bin/bash\nxvfb-run -a /opt/unityhub/unityhub-bin --no-sandbox --headless "$@" 2>/dev/null' > /usr/bin/unityhub-root && \
	chmod +x /usr/bin/unityhub-root && \
	mkdir -p $home_dir/Unity/Hub/Editor && \
	unityhub-root install-path --set "$home_dir/Unity/Hub/Editor" && \
	unityhub-root install --version $editor_version
## Requirements
RUN apt-get update && \
	apt-get install -y \
		libglu1 \
		libgconf-2-4
########## Initial Position ##########
WORKDIR $home_dir
CMD ["bash"]