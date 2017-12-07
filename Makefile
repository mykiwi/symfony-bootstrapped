DOCKER_COMPOSE	= /bin/env docker-compose

EXEC_PHP		= $(DOCKER_COMPOSE) exec php /path/to/container/entrypoint
EXEC_JS			= $(DOCKER_COMPOSE) exec node /path/to/container/entrypoint

SYMFONY			= $(EXEC_PHP) bin/console
COMPOSER		= $(EXEC_PHP) composer
YARN			= $(EXEC_JS) yarn

## 
## Project
## -------
## 

build:
	@$(DOCKER_COMPOSE) pull --parallel --quiet --ignore-pull-failures 2> /dev/null
	$(DOCKER_COMPOSE) build --pull

kill:
	$(DOCKER_COMPOSE) kill
	$(DOCKER_COMPOSE) down --volumes --remove-orphans

install: ## Install and start the project
install: .env build start assets db

reset: ## Stop and start a fresh install of the project
reset: kill install

start: ## Start the project
	$(DOCKER_COMPOSE) up -d --remove-orphans --no-recreate

stop: ## Stop the project
	$(DOCKER_COMPOSE) stop

clean: ## Stop the project and remove generated files
clean: kill
	rm -rf .env vendor
	$(DOCKER_COMPOSE) down --rmi

no-docker:
	$(eval DOCKER_COMPOSE := \#)
	$(eval EXEC_PHP := )
	$(eval EXEC_NODE := )

.PHONY: build kill install reset start stop clean no-docker

## 
## Utils
## -----
## 

db: ## Reset the database and load fixtures
db: start vendor
	$(EXEC_PHP) php -r "require('./vendor/autoload.php');for(;;){try{\Doctrine\DBAL\DriverManager::getConnection($$_ENV['DATABASE_URL']);break;}catch(\Exception $$e){}}" # Wait for MySQL
	$(SYMFONY) doctrine:database:drop --if-exists --force
	$(SYMFONY) doctrine:database:create --if-not-exists
	$(SYMFONY) doctrine:migrations:migrate --no-interaction
	$(SYMFONY) doctrine:fixtures:load --no-interaction

migration: ## Generate a new doctrine migration
migration: start vendor
	$(SYMFONY) doctrine:migrations:diff

assets: ## Run Webpack Encore to compile assets
assets: start node_modules
	$(YARN) run dev

watch: ## Run Webpack Encore in watch mode
watch: start node_modules
	$(YARN) run watch

.PHONY: db migration assets watch

## 
## Tests
## -----
## 

tests: ## Run unit and functional tests
	@make -j tu tf

tu: ## Run unit tests
tu: start vendor
	$(EXEC_PHP) bin/phpunit --exclude-group functional

tf: ## Run functional tests
tf: start vendor
	$(EXEC_PHP) bin/phpunit --group functional

.PHONY: tests tu tf

# rules based on files
composer.lock: composer.json
	$(COMPOSER) update --lock --no-scripts --no-interaction

vendor: composer.lock
	$(COMPOSER) install

node_modules: yarn.lock
	$(YARN) install

yarn.lock: package.json
	@echo yarn.lock is not up to date.

.env: .env.dist
	@if [ -f .env ]; \
	then\
		echo '\033[1;41m/!\ The .env.dist file has changed. Please check your .env file (this message will not be displayed again).\033[0m';\
		touch .env;\
		exit 1;\
	else\
		echo cp .env.dist .env;\
		cp .env.dist .env;\
	fi

## 
## Quality assurance
## -----------------
## 

QA = docker run --rm -v `pwd`:/project mykiwi/phaudit:7.1
ARTEFACTS = var/artefacts

lint: ## Lints twig and yaml files
lint: lt ly

lt: start vendor
	$(SYMFONY) lint:twig templates

ly: start vendor
	$(SYMFONY) lint:yaml config

security: ## Check security of your dependencies
security: start vendor
	$(EXEC_PHP) ./vendor/bin/security-checker security:check

phploc: ## PHPLoc (https://github.com/sebastianbergmann/phploc)
	$(QA) phploc src/

pdepend: ## PHP_Depend (https://pdepend.org)
pdepend: artefacts
	$(QA) pdepend \
		--summary-xml=$(ARTEFACTS)/pdepend_summary.xml \
		--jdepend-chart=$(ARTEFACTS)/pdepend_jdepend.svg \
		--overview-pyramid=$(ARTEFACTS)/pdepend_pyramid.svg \
		src/

phpmd: ## PHP Mess Detector (https://phpmd.org)
	$(QA) phpmd src text .phpmd.xml

php_codesnifer: ## PHP_CodeSnifer (https://github.com/squizlabs/PHP_CodeSniffer)
	$(QA) phpcs -v --standard=.phpcs.xml src

phpcpd: ## PHP Copy/Paste Detector (https://github.com/sebastianbergmann/phpcpd)
	$(QA) phpcpd src

phpdcd: ## PHP Dead Code Detector (https://github.com/sebastianbergmann/phpdcd)
	$(QA) phpdcd src

phpmetrics: ## PhpMetrics (http://www.phpmetrics.org)
phpmetrics: artefacts
	$(QA) phpmetrics --report-html=$(ARTEFACTS)/phpmetrics src

php-cs-fixer: ## php-cs-fixer (http://cs.sensiolabs.org)
	$(QA) php-cs-fixer fix --dry-run --using-cache=no --verbose --diff

apply-php-cs-fixer: ## apply php-cs-fixer fixes
	$(QA) php-cs-fixer fix --using-cache=no --verbose --diff

artefacts:
	mkdir -p $(ARTEFACTS)

.PHONY: lint lt ly phploc pdepend phpmd php_codesnifer phpcpd phpdcd phpmetrics php-cs-fixer apply-php-cs-fixer artefacts



.DEFAULT_GOAL := help
help:
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'
.PHONY: help
