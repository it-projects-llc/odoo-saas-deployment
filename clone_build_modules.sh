#!/usr/bin/env sh
set -e

ODOO_BRANCH=14.0
GIT_PARAMS="-b $ODOO_BRANCH --single-branch"

cd "$(dirname "$0")"

cd vendor/itpp-labs
git clone $GIT_PARAMS https://github.com/itpp-labs/access-addons.git
cd ../..
