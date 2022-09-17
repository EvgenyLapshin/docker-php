#!/usr/bin/env bash

if [[ -a ../${APP_FOLDER}/public ]]; then
	rm -rf ../${APP_FOLDER}/public/
fi

mkdir -p ../${APP_FOLDER}/public
cat <<EOF > ../${APP_FOLDER}/public/index.php
<?php

try {
    new PDO(
        "pgsql:host=${COMPOSE_PROJECT_NAME}_postgres;port=${POSTGRES_PORT};dbname=${POSTGRES_DB};",
        "${POSTGRES_USER}",
        "${POSTGRES_PASSWORD}",
        [PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION]
    );

    echo "Database connection established successfully!";
} catch (PDOException \$exception) {
    die(\$exception->getMessage());
}

EOF

if [[ -a ../.config/php ]]; then
	rm -rf ../.config/php
fi

mkdir -p ../.config/php
cp -a php/conf.d ../.config/php
cp -p php/www.conf ../.config/php
