
V_PATH = $(HOME)/data
V_DIRS = wordpress mariadb

BLUE = \e[0;34m

all:  volume build up
	@echo "$(BLUE)   _____ ________           .___ _______  _________ ________________________________.___________    _______    $(RESET)"
	@echo "$(BLUE)  /  |  |\_____  \          |   |\      \ \_   ___ \\_   _____/\______   \__    ___/|   \_____  \   \      \   $(RESET)"
	@echo "$(BLUE) /   |  |_/  ____/   ______ |   |/   |   \/    \  \/ |    __|_  |     ___/ |    |   |   |/   |   \  /   |   \  $(RESET)"
	@echo "$(BLUE)/    ^   /       \  /_____/ |   /    |    \     \____|        \ |    |     |    |   |   /    |    \/    |    \ $(RESET)"
	@echo "$(BLUE)\____   |\_______ \         |___\____|__  /\______  /_______  / |____|     |____|   |___\_______  /\____|__  / $(RESET)"
	@echo "$(BLUE)     |__|        \/                     \/        \/        \/                                  \/         \/  $(RESET)"
	@echo "$(BLUE)                                                                                              by bepoisso 🐟   $(RESET)"

build:
	@docker compose -f srcs/docker-compose.yml build || exit 1

up:
	@docker compose -f srcs/docker-compose.yml up -d || exit 1

volume:
	@if [ ! -d "/home/$(USER)/data" ]; then \
		mkdir -p /home/$(USER)/data/wordpress && \
		mkdir -p /home/$(USER)/data/mariadb; \
	fi
	@sudo chown -R $(USER):$(USER) /home/$(USER)/data/wordpress
	@sudo chown -R $(USER):$(USER) /home/$(USER)/data/mariadb
	@sudo chmod 755 /home/$(USER)/data/wordpress
	@sudo chmod 755 /home/$(USER)/data/mariadb

down:
	@docker compose -f srcs/docker-compose.yml down || exit 1

clean: down
	@docker system prune -a -f

fclean: clean
	@for dir in $(V_DIRS); do \
		sudo rm -rf $(V_PATH)/$$dir; \
	done
	@sudo rm -rf $(V_PATH)
	@if [ -n "$(shell docker volume ls -q)" ]; then \
		docker volume rm $(shell docker volume ls -q); \
	fi

re: fclean all

.PHONY: all build up down clean fclean re volume
