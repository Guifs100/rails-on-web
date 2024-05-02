# Define o comando padrão a ser executado quando o Make é chamado sem argumentos.
.DEFAULT_GOAL := help

run:
	docker compose run --rm -it web bash

build:
	docker compose build

up:
	docker compose up

exec:
	docker exec -it rails_web bash

down:
	docker compose down --remove-orphans

attach:
	docker attach rails_web --detach-keys="ctrl-q"

help:
	@echo "Uso:"
	@echo "  make attach                Attacha em um conteiner já upado, para sair aperte 'ctrl+q'"
	@echo "  make run                   Inicia um novo container com o bash"
	@echo "  make build                 Monta a imagem configurado no projeto"
	@echo "  make down                  derruba todos os container e os orfãos"
	@echo "  make exec                  Inica o bash de um container já levantado"
	@echo "  make help                  exibe as listas de comandos"
	@echo "  make up                    Sobe um container e suas dependências"
