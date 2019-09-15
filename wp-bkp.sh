#!/bin/bash
#   wp-bkp.sh - Respaldo del sistema de gestion de contenidos WordPress
#
#   Copyright © 2019, Rodrigo Ernesto Alvarez Aguilera <incognia@gmail.com>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#   Version 0.2 - May 13, 2019
#   Author: Rodrigo Ernesto Alvarez Aguilera
#
#   Tested under Debian GNU/Linux 9.7 using GNU bash version 4.4.12
#

HELP="Uso: wp-bkp.sh [OPCIÓN]\n\n
\t-h\tmuestra esta lista de ayuda\n
\t-l\tmuestra la licencia del programa\n
\t-v\tmuestra la versión del programa\n"

VERSION="wp-bkp.sh versión 0.2\n
\bCopyright © 2019, Rodrigo Ernesto Alvarez Aguilera"

DATABASE="wordpress"

DBUSER=[database user]

DBPASS=[dabase password]

DATE=`date +%Y%m%d`

HOST=`hostname`

NFS=[nfs server]

if  [[ $1 = "-h" ]]; then
    echo -e $HELP
elif  [[ $1 = "-l" ]]; then
    more LICENSE
elif  [[ $1 = "-v" ]]; then
    echo -e $VERSION
else
    # Matar procesos usando directorio NFS
    fuser -k -9 /var/www/html/archivos/
    # Desmontar directorio NFS
    umount /var/www/html/archivos/
    df -h
    sleep 5
    # Respaldar y comprimir directorio "html"
    tar -czvf $DATE-$HOST-html.tar.gz /var/www/html/
    # Respaldar base de datos
    mysqldump -u $DBUSER -p$DBPASS $DATABASE > $DATABASE.sql
    # Comprimir respaldo de base de datos
    tar -czvf $DATE-$HOST-wordpress.tar.gz wordpress.sql
    # Eliminar respaldo de base de datos
    rm wordpress.sql
    # Montar directorio NFS
    mount -t nfs $NFS:/data/archivos /var/www/html/archivos/
    echo -e "┌──────────────────────────────────────────────────────────────────────────────┐"
    echo -e "│                            Generando informe...                              │"
    echo -e "└──────────────────────────────────────────────────────────────────────────────┘"
    # Generar suma MD5
    md5sum $DATE-*.gz > md5.tmp
    reset
    # Listar archivos
    echo -e "┌──────────────────────────────────────────────────────────────────────────────┐"
    echo -e "│        Respaldo de directorios y base de datos de WordPress finalizado       │"
    echo -e "└──────────────────────────────────────────────────────────────────────────────┘"
    df -h |grep -e File -e archivos
    echo -e " ────────────────────────────────────────────────────────────────────────────── "
    ls -hl $DATE-*.gz
    echo -e " ────────────────────────────────────────────────────────────────────────────── "
    cat md5.tmp
    echo -e "┌──────────────────────────────────────────────────────────────────────────────┐"
    echo -e "│              Copyright © 2019, Rodrigo Ernesto Alvarez Aguilera              │"
    echo -e "└──────────────────────────────────────────────────────────────────────────────┘"
    rm md5.tmp
fi
