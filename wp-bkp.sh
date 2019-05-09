#!/bin/bash
#   wp-bkp.sh - Respaldo de WordPress
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
#   Version 0.1 - May 9, 2019
#   Author: Rodrigo Ernesto Alvarez Aguilera
#
#   Tested under Debian GNU/Linux 9.7 (stretch) using GNU bash version 4.4.12
#

HELP="Uso: wp-bkp.sh [OPCIÓN]\n\n
\t-d\tmuestra la fecha actual\n
\t-h\tmuestra esta lista de ayuda\n
\t-l\tmuestra la licencia del programa\n
\t-v\tmuestra la versión del programa\n"

VERSION="wp-bkp.sh versión 0.1\n
\bCopyright © 2019 Rodrigo Ernesto Alvarez Aguilera"

DATE=`date +%Y%m%d`

if  [[ $1 = "-h" ]]; then
    echo -e $HELP
elif  [[ $1 = "-l" ]]; then
    more LICENSE
elif  [[ $1 = "-v" ]]; then
    echo -e $VERSION
elif  [[ $1 = "-d" ]]; then
    echo -e $DATE
else
    # Matar procesos usando NFS
    fuser -k -9 /var/www/html/archivos/
    # Desmontar NFS
    umount /var/www/html/archivos/
    df -h
    sleep 5
    # Respaldar y comprimir directorio "html"
    tar -czvf $DATE-html.tar.gz /var/www/html/
    # Respaldar la base de datos
    mysqldump -u root -p[dabase password] wordpress > wordpress.sql
    # Comprimir respaldo de base de datos
    tar -czvf $DATE-wordpress.tar.gz wordpress.sql
    # Eliminar respaldo de base de datos
    rm wordpress.sql
    # Montar NFS
    mount -t nfs 10.142.0.7:/data/archivos /var/www/html/archivos/
    df -h
    sleep 5
    reset
    ls -l
    echo -e "Respaldo finalizado" 
fi
