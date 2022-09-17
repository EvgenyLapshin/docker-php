#!make
include .env
export $(shell sed 's/=.*//' .env)
RED='\033[0;31m'        #  ${RED}
GREEN='\033[0;32m'      #  ${GREEN}
BOLD='\033[1;m'			#  ${BOLD}
WARNING=\033[37;1;41m	#  ${WARNING}
END_COLOR='\033[0m'		#  ${END_COLOR}

.PHONY: rebuild up clone stop restart status console-php console-nginx clean help

docker-init: nginx-config php-init rebuild up composer-init composer-install
docker-env: nginx-config php-init rebuild up composer-install

dialog:
	@bash ./sh-dialog.sh

nginx-config:
	@bash ./nginx/sh-config-nginx.sh

php-init:
	@bash ./php/index-php.sh

rebuild: stop
	@echo "\n\033[1;m Rebuilding containers... \033[0m"
	@docker-compose build --no-cache

clone:
	@echo "\n\033[1;m Cloning App (${BRANCH_NAME} branch) \033[0m"
	@if cd ${APP_FOLDER} 2> /dev/null; then git pull; else git clone -b ${BRANCH_NAME} ${GIT_URL} ${APP_FOLDER}; fi

up:
	@echo "\n\033[1;m Spinning up containers for ${ENVIRONMENT} environment... \033[0m"
	@docker-compose -p ${COMPOSE_PROJECT_NAME} up -d
	@$(MAKE) --no-print-directory status

hosts:
	@echo "\n\033[1;m Adding record in to your local hosts file.\033[0m"
	@echo "\n\033[1;m Please use your local sudo password.\033[0m"
	@echo "127.0.0.1 ${DOMAIN}" | sudo tee -a /etc/hosts

stop:
	@echo "\n\033[1;m Halting containers... \033[0m"
	@docker-compose stop

restart:
	@echo "\n\033[1;m Restarting containers... \033[0m"
	@docker-compose stop
	@docker-compose up -d
	@$(MAKE) --no-print-directory status

status:
	@echo "\n\033[1;m Containers statuses \033[0m"
	@docker-compose ps

clean:
	@echo "\033[1;31m\033[5m *** Removing containers and Application! ***\033[0m"
	@echo "\033[1;31m\033[5m *** Ensure that you commited changes!*** \033[0m"
	@$(MAKE) --no-print-directory dialog
	@docker-compose down --rmi all 2> /dev/null
	@rm -rf ./../.data/
	@rm -rf ./../.logs/
	@rm -rf ./../.config/
	@rm -rf ./../${APP_FOLDER}/
	@$(MAKE) --no-print-directory status

console-php:
	@docker-compose exec php bash
console-nginx:
	@docker-compose exec nginx bash
console-postgres:
	@docker-compose exec postgres bash

tests-init:
	@docker-compose exec -T php bash -c "cd /var/www/html/${APP_NAME}/ && composer require codeception/codeception --dev && php vendor/bin/codecept bootstrap && php vendor/bin/codecept generate:test Unit Example"
tests-run:
	@docker-compose exec -T php bash -c "cd /var/www/html/${APP_NAME}/ && php vendor/bin/codecept run --steps"

composer-init:
	@docker-compose exec -T php bash -c "cd /var/www/html/${APP_NAME}/ && composer init --name=${COMPOSER_NAME} --license=${COMPOSER_LICENSE} --type=${COMPOSER_TYPE} --description=${COMPOSER_DESCRIPTION} --autoload=${COMPOSER_AUTOLOAD}"
composer-install:
	@docker-compose exec -T php bash -c "cd /var/www/html/${APP_NAME}/ && composer install && composer dump-autoload -o"
composer-dump-autoload:
	@docker-compose exec php bash -c "cd /var/www/html/${APP_NAME}/ && composer dump-autoload"

logs-nginx:
	@docker-compose logs --tail=100 -f nginx
logs-php:
	@docker-compose logs --tail=100 -f php
logs-postgres:
	@docker-compose logs --tail=100 -f postgres

help:
	@echo "\n\033[1;32mdocker-init\t\t- First install (run once)\033[0m"
	@echo "\033[1;32mdocker-env\t\t- Main scenario, used by default\033[0m"

	@echo "\n\033[1mMain section\033[0m"
	@echo "clone\t\t\t- Clone Application repo (remove old Application)"
	@echo "rebuild\t\t\t- Build containers w/o cache"
	@echo "up\t\t\t- Start project"
	@echo "stop\t\t\t- Stop project"
	@echo "restart\t\t\t- Restart containers"
	@echo "status\t\t\t- Show status of containers"
	@echo "nginx-config\t\t- Generates nginx config file based on .env parameters"
	@echo "php-init\t\t- Generates: php config file, php-fpm config and dummy index.php"

	@echo "\n\033[1;31m\033[5mclean\t\t\t- Reset project. All Local application data will be lost!\033[0m"

	@echo "\n\033[1mConsole\033[0m"
	@echo "console-php\t\t- Run bash console for dev application (PHP) container"
	@echo "console-nginx\t\t- Run bash console for web server (Nginx) container"
	@echo "console-postgres\t- Run bash console for PostgreSQL container"

	@echo "\n\033[1mTests\033[0m"
	@echo "tests-init\t\t- Install Codeception tests and generate Example unit test"
	@echo "tests-run\t\t- Run Codeception tests"

	@echo "\n\033[1mComposer\033[0m"
	@echo "composer-init\t\t- Install composer"
	@echo "composer-install\t- Install dependencies via composer"
	@echo "composer-dump-autoload\t- Refresh dependencies via composer"

	@echo "\n\033[1mLogs\033[0m"
	@echo "logs-nginx\t\t- Show web server logs"
	@echo "logs-php\t\t- Show application dev logs"
	@echo "logs-postgres\t\t- Show PostgreSQL database logs"

	@echo "\n\033[0;33mhelp\t\t\t- Show this menu\033[0m"
