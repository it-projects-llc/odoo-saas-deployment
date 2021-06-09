#!/usr/bin/env sh
set -e

if [ -z "$ODOO_VERSION" ] then
   echo ODOO_VERSION is not defined
fi

ODOO_BRANCH="$ODOO_VERSION"
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
