#!/bin/sh

ROOT=/opt/mango

REPOS="ol7_latest ol7_u0_base ol7_UEKR3 ol7_optional_latest ol7_addons ol7_MySQL56 ol7_MySQL55 sl6x sl6x-security sl6x-fastbugs sl6-fastbugs sl6-testing sl6-addons sl6 sl6-security puppetlabs-products-rhel7 puppetlabs-deps-rhel7 puppetlabs-devel-rhel7 puppetlabs-products-rhel6 puppetlabs-deps-rhel6 puppetlabs-devel-rhel6 zabbix22-rhel7 zabbix22-non-supported-rhel7 zabbix24-rhel7 zabbix24-non-supported-rhel7 zabbix22-rhel6 zabbix22-non-supported-rhel6 zabbix24-rhel6 zabbix24-non-supported-rhel6 epel-rhel7 epel-testing-rhel7 epel-rhel6 epel-testing-rhel6 openvz-utils openvz-kernel-rhel6 openvz-kernel-rhel6-testing pgdg93-rhel7 pgdg94-rhel7 pgdg95-rhel7 pgdg92-rhel6 pgdg93-rhel6 pgdg94-rhel6 pgdg95-rhel6 epel-bacula-rhel7 epel-bacula-rhel6 network_ha-clustering_Stable-rhel7 network_ha-clustering_Stable-rhel6 elrepo-rhel7 elrepo-testing-rhel7 elrepo-kernel-rhel7 elrepo-extras-rhel7 remi remi-php56 vesta nginx-rhel7 nginx-rhel6"
#REPOS="remi-php72 remi remi-php56"
#REPOS="remi-php71 ol7_latest"
#REPOS="remi-php71"

DESTDIR=/var/www/html/current
URL=http://repo/current

#REPOS="ol7_latest ol7_u0_base ol7_UEKR3 ol7_optional_latest ol7_addons ol7_MySQL56 ol7_MySQL55 sl6x sl6x-security sl6x-fastbugs sl6-fastbugs sl6-testing sl6-addons sl6 sl6-security puppetlabs-products-rhel7 puppetlabs-deps-rhel7 puppetlabs-devel-rhel7 puppetlabs-products-rhel6 puppetlabs-deps-rhel6 puppetlabs-devel-rhel6 zabbix22-rhel7 zabbix22-non-supported-rhel7 zabbix24-rhel7 zabbix24-non-supported-rhel7 zabbix22-rhel6 zabbix22-non-supported-rhel6 zabbix24-rhel6 zabbix24-non-supported-rhel6 epel-rhel7 epel-testing-rhel7 epel-rhel6 epel-testing-rhel6 openvz-utils openvz-kernel-rhel6 openvz-kernel-rhel6-testing pgdg93-rhel7 pgdg94-rhel7 pgdg95-rhel7 pgdg92-rhel6 pgdg93-rhel6 pgdg94-rhel6 pgdg95-rhel6 epel-bacula-rhel7 epel-bacula-rhel6 network_ha-clustering_Stable-rhel7 network_ha-clustering_Stable-rhel6 elrepo-rhel7 elrepo-testing-rhel7 elrepo-kernel-rhel7 elrepo-extras-rhel7 remi remi-php56 vesta nginx-rhel7 nginx-rhel6"
#REPOS="remi-php72 remi remi-php56"
#REPOS="zabbix30-rhel6 zabbix30-rhel7"


for repo in $REPOS; do
    /usr/bin/reposync -t --config=${ROOT}/yum.conf --delete --download_path=${DESTDIR} --downloadcomps --download-metadata --repoid=${repo}

    CREATEREPO_OPTS=""
    if [ -f "${DESTDIR}/${repo}/comps.xml" ]; then
        CREATEREPO_OPTS="${CREATEREPO_OPTS} --groupfile ${DESTDIR}/${repo}/comps.xml"
    fi

    TEMPDIR=`mktemp -d`
    createrepo${CREATEREPO_OPTS} --baseurl=${URL}/${repo} --cachedir=${TEMPDIR}/${REPO}/ ${DESTDIR}/${repo}
    rm -rf $TEMPDIR
done