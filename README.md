Mariadb docker container with s6-overlay supervisor.

Usage:

```
docker run --name mariadb \ 
           -p 3360:3360 \
           -v /var/lib/mysql:/var/lib/mysql \
           -e MARIADB_USER=<USER> \
           -e MARIADB_PASSWORD=<PASSWORD> \
           -e MARIADB_DATABASE=<DATABASE_NAME> \ 
           quay.io/amarruedo/mariadb:v0.2
```

This will start a Mariadb instance and will create provided USER and DATABASE_NAME if they don't exist.

