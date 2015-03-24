#!/bin/bash -x

URLS=(
  'http://ftp.gnu.org/gnu/automake/automake-1.14.tar.gz'
  'http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz'
)

GITS=(
  'https://github.com/KLab/miruo.git'
)

function getgz() {
  URL=${1}
  DIR=${2}
  cd ${DIR} && curl ${URL} | tar xz && cd -
}

function tgzdir (){
  compfile=${1##*/}
  echo ${compfile%.tar.gz}
}

function gtdir (){
  compfile=${1##*/}
  echo ${compfile%.git}
}

function urlbuild (){
  URL=${1}
  BASEDIR=${2}
  SRCDIR=${BASEDIR}/src 
  BLDDIR=$(tgzdir ${URL})
  if [ ! -d ${SRCDIR} ]; then mkdir -p ${SRCDIR} ; fi
  getgz ${URL} ${SRCDIR}
  cd  ${SRCDIR}/${BLDDIR} && ./configure --prefix=${BASEDIR} && make; make install && cd -
}

function gitbuild (){
  GITURL=${1}
  BASEDIR=${2}
  SRCDIR=${BASEDIR}/src 
  BLDDIR=$(gtdir ${GITURL})
  if [ ! -d ${SRCDIR} ]; then mkdir -p ${SRCDIR} ; fi
  git clone ${GITURL} ${SRCDIR}/${BLDDIR}
  cd  ${SRCDIR}/${BLDDIR} && ./configure --prefix=${BASEDIR} && make; make install && cd -
}

## main

BASEDIR=${1}

PATH=${BASEDIR}/bin:${PATH}

for U in ${URLS[@]};
do urlbuild ${U} ${BASEDIR}
done   

for G in ${GITS};
do gitbuild ${G} ${BASEDIR}
done

