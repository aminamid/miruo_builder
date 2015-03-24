#!/bin/bash -x

AUTOMAKEURL=http://ftp.gnu.org/gnu/automake/automake-1.14.tar.gz
AUTOCONFURL=http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz


function getgz() {
  URL=${1}
  DIR=${2}
  cd ${DIR} && curl ${URL} | tar xz && cd -
}

function tgzdir (){
  compfile=${1##*/}
  echo ${compfile%.tar.gz}
}

BASEDIR=${1}
SRCDIR=${BASEDIR}/src
AUTOCONF=$(tgzdir ${AUTOCONFURL})
AUTOMAKE=$(tgzdir ${AUTOMAKEURL})


mkdir -p ${SRCDIR}
getgz ${AUTOCONFURL} ${SRCDIR}
cd ${SRCDIR}/${AUTOCONF} && ./configure --prefix=${BASEDIR} && make; make install && cd -

PATH=${BASEDIR}/bin:${PATH}

which autconf
getgz ${AUTOMAKEURL} ${SRCDIR}
cd ${SRCDIR}/${AUTOMAKE} && ./configure --prefix=${BASEDIR} && make; make install && cd -


git clone https://github.com/KLab/miruo ${SRCDIR}/miruo
cd ${SRCDIR}/miruo && ./configure --prefix=${BASEDIR} && make; make install && cd -
