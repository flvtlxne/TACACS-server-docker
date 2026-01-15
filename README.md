Installation:

docker build -t tacacs-server .
docker run -d --name tacacs-server -p 49:49/tcp -p 49:49/udp
