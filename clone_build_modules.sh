#!/usr/bin/env sh
set -e

if [ -z "$ODOO_VERSION" ] then
   echo ODOO_VERSION is not defined
fi

ODOO_BRANCH="$ODOO_VERSION"
GIT_PARAMS="-b $ODOO_BRANCH --single-branch"

cd "$(dirname "$0")"

cd vendor/itpp-labs
git clone $GIT_PARAMS https://github.com/itpp-labs/access-addons.git
cd ../..
