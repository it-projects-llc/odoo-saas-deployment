#!/usr/bin/env sh
set -e

cd "$(dirname "$0")"

PW=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 20 | head -n 1)
sed -i "s/^;\ admin_passwd\ =.*/admin_passwd = $PW/g" odoo.conf
