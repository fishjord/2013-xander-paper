# HMP Mock Community Analysis Procedures

## Pre-requisits
* khmer (optional, only if you want to use diginorm, the analysis included in the paper does not)
* [glowing_sakana](http://github.com/fishjord/glowing_sakana)

_NOTE_ You must edit 'Makefile' to change the GLOWING_SAKANA path and (if you plan to use diginorm) the KHMER path

## Overview

### Quick start
1. git clone https://github.com/fishjord/glowing_sakana
2. git clone https://github.com/fishjord/2013-xander-paper
3. Edit '2013-xander-paper/Makefile' to change the GLOWING_SAKANA path and (if you plan to use diginorm) the KHMER path
4. cd 2013-xander-paper/hmp && make
