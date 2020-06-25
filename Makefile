NAME = foramontano/moodle3.8
VERSION = 0.1.0
NOMBRE_CONTENEDOR_BBDD=mysql-moodle
NOMBRE_CONTENEDOR_MOODLE=moodle3.8

.PHONY: all build build-nocache

all: build deploy

build:
	docker build -t $(NAME):$(VERSION) --rm .

deploy:
	docker run  --name $(NOMBRE_CONTENEDOR_BBDD) -p 3306:3306 \
		--env MYSQL_DATABASE=moodle \
		--env MYSQL_ROOT_PASSWORD=moodle \
		--env MYSQL_USER=moodle \
		--env MYSQL_PASSWORD=moodle \
		--detach mysql:5

	docker run --name $(NOMBRE_CONTENEDOR_MOODLE) -p 8006:80 -p 4430:443 \
		--link $(NOMBRE_CONTENEDOR_BBDD):DB \
		--env MOODLE_URL=http://ldap1.decieloytierra.es:8006 \
		--volume php-dir:/etc/php/7.4/apache2 \
		--detach $(NAME):$(VERSION)

build-nocache:
	docker build -t $(NAME):$(VERSION) --no-cache --rm .
