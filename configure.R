#!/usr/bin/Rscript
#   configure.R - configuring R to use twitteR
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
#   Version 0.1 - April 10, 2018
#   Author: Rodrigo Ernesto Alvarez Aguilera
#
#   Tested under Ubuntu 16.04.4 LTS using R version 3.4.4
#

# Select France mirror
chooseCRANmirror(ind=30)
# Set working directory
setwd("~/twitter/")
# Install packages
install.packages("twitteR")
install.packages("devtools")
install.packages("foreign")
# Load libraries
library(twitteR)
library(foreign)
library(devtools)
# Install twitteR from GitHub
install_github("geoffjentry/twitteR")
# Exit without prompt
quit(save="no")