#!/bin/bash
#   set-environment.sh - Update system and install R base
#
#   Copyright © 2018, Rodrigo Ernesto Alvarez Aguilera <incognia@gmail.com>
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
#   Version 0.1 - April 28, 2019
#   Author: Rodrigo Ernesto Alvarez Aguilera
#
#   Tested under Ubuntu 16.04.6 LTS using GNU bash version 4.3.48
#

HELP="Uso: set-environment.sh [OPCIÓN]\n\n
    \t-h\tmuestra esta lista de ayuda\n
    \t-l\tmuestra la licencia del programa\n
    \t-v\tmuestra la versión del programa\n"

VERSION="set-environment.sh versión 0.1\n
    \bCopyright © 2018 Rodrigo Ernesto Alvarez Aguilera"

if  [[ $1 = "-h" ]]; then
    echo -e $HELP
elif  [[ $1 = "-l" ]]; then
    more LICENSE
elif  [[ $1 = "-v" ]]; then
    echo -e $VERSION
else
    # Put the system up to date
    sudo apt-get update
    sudo apt-get install aptitude
    sudo aptitude safe-upgrade --assume-yes
    # Add key and repository for R
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
    sudo add-apt-repository 'deb [arch=amd64,i386] https://cran.rstudio.com/bin/linux/ubuntu xenial/'
    sudo apt-get update
    # Install R base with libraries and nmon to display local system statistics
    sudo apt-get install --assume-yes r-base libssl-dev libcurl4-openssl-dev nmon
    # Create work directory
    mkdir ~/twitter
    # Excecure Rscript with sudo to configure R repositories and install libraries
    sudo Rscript configure.R
    # Reset terminal and display final message
    sleep 5
    reset
    echo -e "R y sus bibliotecas se han instalado correctamente en el sistema."
fi
