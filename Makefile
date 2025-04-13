all: create_dir build
	cd srcs && docker compose up -d

create_dir:
	mkdir -p /home/${USER}/data/mariadb
	mkdir -p /home/${USER}/data/wordpress

down:
	cd srcs && docker compose down

up:
	cd srcs && docker compose up -d

build:
	cd srcs && docker compose build

clean:
	cd srcs && docker compose down

db:
	docker exec -it mariadb /bin/sh

fclean: 
	-sudo rm -rf /home/${USER}/data/
	-cd srcs && docker compose down
	-docker container rm -f $(docker container ls -a)
	-docker volume rm mariadb wordpress
	-docker network rm -f $(docker network ls -a)
	-docker image rm -f $(docker image ls -a)
	-yes | docker system prune -a

# docker stop $(docker ps -qa)
# docker rm $(docker ps -qa)
# docker rmi -f $(docker images -qa)
# docker volume rm $(docker volume ls -q)
# docker network rm $(docker network ls -q)

restart:
	cd srcs && docker compose restart

log:
	cd srcs && docker compose logs -f

re: clean 
	cd srcs && docker compose up --build