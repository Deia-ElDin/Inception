all:
	cd srcs && docker compose up -d

down:
	cd srcs && docker compose down

up:
	cd srcs && docker compose up -d

build:
	cd srcs && docker compose build

clean:
	cd srcs && docker compose down --volumes

db:
	docker exec -it mariadb /bin/sh

fclean:
	@-docker container rm -f $(docker container ls -a)
	@-docker volume prune -f
	@-docker network rm -f $(docker network ls -a)
	@-docker image rm -f $(docker image ls -a)
	@-yes | docker system prune -a

restart:
	cd srcs && docker compose restart

log:
	cd srcs && docker compose logs -f

re: clean 
	cd srcs && docker compose up --build