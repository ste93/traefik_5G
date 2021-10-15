to generate chiper username and password:

- htpasswd -b file utente password

to generate ssl certificate:

- openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out traefik.crt -keyout traefik.key

to launch it is enough to run:

- docker-compose up -d (to launch the daemon in background)


