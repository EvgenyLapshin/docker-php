# Docker environment
Docker Compose configuration to run PHP 8 with Nginx, PHP-FPM, PostgreSQL

Prerequisites
-----
You will require:

- Docker engine for your platform ([Get Docker](https://docs.docker.com/get-docker/))
- Git client
- [Make](https://en.wikipedia.org/wiki/Make_(software))

Deployment steps
-----
* Clone the Docker repo:

```
git clone https://github.com/EvgenyLapshin/docker-php.git site && cd site
```

* Replace ALL values in `.env` file;
* Start spinup scenario

```
make docker-init
```

* Run tests

```
make tests-init
```
```
make tests-run
```

* For additional commands

```
make help
```
