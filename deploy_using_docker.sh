#!/usr/bin/env sh
set -e

MASTER_DB=saas

cd "$(dirname "$0")"

./clone_master_modules.sh
./clone_build_modules.sh
./prepare_odoo_conf.sh

docker-compose run --rm web -d $MASTER_DB -i saas --stop-after-init

echo ==============================
echo Now run:
echo docker-compose run web
echo or
echo docker-compose run -d web
echo ==============================
