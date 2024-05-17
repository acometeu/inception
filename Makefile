Name	=	Inception

all:
	mkdir -p /home/acomet/data/www /home/acomet/data/database
	docker compose -f srcs/docker-compose.yml up -d --build

clean:
	docker compose -f srcs/docker-compose.yml down

fclean: clean
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	docker system prune -af
	@sudo rm -rf /home/acomet/data

re: fclean all

.PHONY: all clean fclean re
