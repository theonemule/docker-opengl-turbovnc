FROM ubuntu:24.04
ENV USER=root
ENV PASSWORD=password1
ENV DEBIAN_FRONTEND=noninteractive 
ENV DEBCONF_NONINTERACTIVE_SEEN=true
RUN apt-get update 
RUN	echo "tzdata tzdata/Areas select America" > ~/tx.txt 
RUN	echo "tzdata tzdata/Zones/America select New York" >> ~/tx.txt 
RUN	debconf-set-selections ~/tx.txt 
RUN	apt-get install -y abiword gnupg apt-transport-https wget software-properties-common ratpoison novnc websockify libxv1 libglu1-mesa xauth x11-utils xorg tightvncserver 
RUN	wget -q -O- https://packagecloud.io/dcommander/virtualgl/gpgkey | gpg --dearmor >/etc/apt/trusted.gpg.d/VirtualGL.gpg 
RUN	wget -q -O- https://packagecloud.io/dcommander/turbovnc/gpgkey |  gpg --dearmor >/etc/apt/trusted.gpg.d/TurboVNC.gpg 
RUN     wget  https://raw.githubusercontent.com/VirtualGL/repo/main/VirtualGL.list
RUN     wget https://raw.githubusercontent.com/TurboVNC/repo/main/TurboVNC.list
RUN     mv TurboVNC.list /etc/apt/sources.list.d/TurboVNC.list
RUN     mv VirtualGL.list  /etc/apt/sources.list.d/VirtualGL.list
RUN	apt-get update 
RUN	apt-get install virtualgl -y
RUN	apt install turbovnc -y 
RUN	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb 
RUN	apt install -y ./google-chrome-stable_current_amd64.deb	
RUN	mkdir ~/.vnc/ 
RUN	mkdir ~/.dosbox 
RUN	echo $PASSWORD | vncpasswd -f > ~/.vnc/passwd 
RUN	chmod 0600 ~/.vnc/passwd 
RUN	echo "set border 1" > ~/.ratpoisonrc  
RUN	echo "exec google-chrome --no-sandbox">> ~/.ratpoisonrc
RUN	openssl req -x509 -nodes -newkey rsa:2048 -keyout ~/novnc.pem -out ~/novnc.pem -days 3650 -subj "/C=US/ST=NY/L=NY/O=NY/OU=NY/CN=NY emailAddress=email@example.com"
EXPOSE 80
CMD /opt/TurboVNC/bin/vncserver && websockify -D --web=/usr/share/novnc/ --cert=~/novnc.pem 80 localhost:5901 && tail -f /dev/null
