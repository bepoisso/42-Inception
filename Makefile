# Variables
COMPOSE=docker
COMPOSE_CMD=compose
COMPOSE_FILE=srcs/docker-compose.yml



build:
	@echo ">> Construction des images Docker..."
	@$(COMPOSE) $(COMPOSE_CMD) -f $(COMPOSE_FILE) build

up:
	@echo ">> Démarrage des services en arrière-plan..."
	@$(COMPOSE) $(COMPOSE_CMD) -f $(COMPOSE_FILE) up -d

down:
	@echo ">> Arrêt et suppression des conteneurs, réseaux et volumes..."
	@$(COMPOSE) $(COMPOSE_CMD) -f $(COMPOSE_FILE) down -v

re: down up
	@echo ">> Redémarrage complet des services."

fclean: down
	@echo ">> Supression total des services."
	@docker system prune -af

.PHONY: build up down logs re fclean