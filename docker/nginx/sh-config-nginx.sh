#!/usr/bin/env bash

if [[ -a ../.config/nginx/conf.d ]]; then
	rm -rf ../.config/nginx/conf.d/
fi

mkdir -p ../.config/nginx/conf.d
cat <<EOF > ../.config/nginx/conf.d/${APP_NAME}-${ENVIRONMENT}.conf
server {
    server_name ${DOMAIN} www.${DOMAIN};
    root /var/www/html/${APP_NAME}/public;

    location / {
        try_files \$uri /index.php\$is_args\$args;
    }

    location ~ ^/index\.php(/|$) {
        fastcgi_pass php:${PHP_PORT};
        fastcgi_split_path_info ^(.+\.php)(/.*)$;
        include fastcgi_params;

        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT \$realpath_root;
        internal;
    }

    location ~ \.php$ {
        return 404;
    }

    error_log /var/log/nginx/site_error.log;
    access_log /var/log/nginx/site_access.log;
}
EOF

cp -p nginx/nginx.conf ../.config/nginx/
