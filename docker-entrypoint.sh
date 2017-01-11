#!/bin/sh
set -e

user_defined=
if [ -n "$PGADMIN_UID" -a "$PGADMIN_UID" -ne 0 ]; then
    echo "Create user pgadmin with UID=$PGADMIN_UID"
    adduser -D pgadmin -u "$PGADMIN_UID"
    user_defined=1
fi


if [ -n "$PGADMIN_DATA_DIR" ]; then
    mkdir -p "$PGADMIN_DATA_DIR"

    if [ "$user_defined" ]; then
        chown -R pgadmin:pgadmin "$PGADMIN_DATA_DIR"
    fi
fi

if [ "$user_defined" ]; then
    echo "Run pgadmin4 as pgadmin user"
    exec su-exec pgadmin python /pgadmin4/web/pgAdmin4.py
else
    echo "Run pgadmin4 as root user"
    exec python /pgadmin4/web/pgAdmin4.py
fi
