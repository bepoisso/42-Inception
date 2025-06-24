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

logs:
	@echo ">> Affichage des logs (Ctrl+C pour quitter)..."
	@$(COMPOSE) $(COMPOSE_CMD) -f $(COMPOSE_FILE) logs -f

restart: down up
	@echo ">> Redémarrage complet des services."

.PHONY: build up down logs restart