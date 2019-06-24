#!/bin/sh

ROOT=/opt/mango

WORKDIR=/var/www/html
URL=http://repo

if [ "x${1}" == "x" ]; then
        exit 1
else
        TAG=$1
fi

shift

if [ "x${*}" == "x" ]; then
        REPOS=`ls -1 ${WORKDIR}/current`
else
        REPOS=""
#       for i in $*; do
#       for i in ol7_latest ol7_u0_base ol7_UEKR3 ol7_optional_latest ol7_addons ol7_MySQL56 ol7_MySQL55 sl6x sl6x-security sl6x-fastbugs sl6-fastbugs sl6-testing sl6-addons sl6 sl6-security puppetlabs-products-rhel7 puppetlabs-deps-rhel7 puppetlabs-devel-rhel7 puppetlabs-products-rhel6 puppetlabs-deps-rhel6 puppetlabs-devel-rhel6 zabbix22-rhel7 zabbix22-non-supported-rhel7 zabbix24-rhel7 zabbix24-non-supported-rhel7 zabbix22-rhel6 zabbix22-non-supported-rhel6 zabbix24-rhel6 zabbix24-non-supported-rhel6 epel-rhel7 epel-testing-rhel7 epel-rhel6 epel-testing-rhel6 openvz-utils openvz-kernel-rhel6 openvz-kernel-rhel6-testing pgdg93-rhel7 pgdg94-rhel7 pgdg92-rhel6 pgdg93-rhel6 pgdg94-rhel6 epel-bacula-rhel7 epel-bacula-rhel6 network_ha-clustering_Stable-rhel7 network_ha-clustering_Stable-rhel6 elrepo-rhel7 elrepo-testing-rhel7 elrepo-kernel-rhel7 elrepo-extras-rhel7 remi remi-php56 vesta pgdg95-rhel7 pgdg95-rhel6; do
        for i in pgdg96-rhel6 pgdg96-rhel7; do
                if [ -d "${WORKDIR}/current/${i}" ]; then
                        REPOS="${REPOS} ${i}"
                fi
        done
fi

REPOS=`ls -1 ${WORKDIR}/current | egrep -v "\.sh$"`

echo $REPOS

mkdir ${WORKDIR}/${TAG}

for repo in $REPOS; do
        CREATEREPO_OPTS=""
        if [ -f "${WORKDIR}/current/${repo}/comps.xml" ]; then
                CREATEREPO_OPTS="${CREATEREPO_OPTS} --groupfile ${WORKDIR}/current/${repo}/comps.xml"
        fi

        TEMPDIR=`mktemp -d`
        createrepo${CREATEREPO_OPTS} --baseurl=${URL}/${TAG}/${repo} --cachedir=${TEMPDIR}/${REPO}/ ${WORKDIR}/current/${repo}
        rm -rf $TEMPDIR
        cp -R ${WORKDIR}/current/${repo} ${WORKDIR}/${TAG}/
        TEMPDIR=`mktemp -d`
        createrepo${CREATEREPO_OPTS} --baseurl=${URL}/current/${repo} --cachedir=${TEMPDIR}/${REPO}/ ${WORKDIR}/current/${repo}
        rm -rf $TEMPDIR
done
