#!/usr/bin/env sh
set -e

ODOO_BRANCH=14.0
GIT_PARAMS="-b $ODOO_BRANCH --single-branch"

cd "$(dirname "$0")"

cd vendor/OCA
git clone $GIT_PARAMS https://github.com/OCA/contract.git
git clone $GIT_PARAMS https://github.com/OCA/queue.git
git clone $GIT_PARAMS https://github.com/em230418/server-auth.git
git clone $GIT_PARAMS https://github.com/OCA/web.git
cd ../..

cd vendor/it-projects-llc
git clone -b $ODOO_BRANCH https://github.com/em230418/saas-addons.git
cd ../..
