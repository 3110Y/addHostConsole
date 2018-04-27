#!/bin/bash
#########################################################
#
# Script  add Host Console
# Author:GRS gaevoyrs@gmail.com
#
#########################################################

##############
# var
##############

ACTION=$1
DOMAIN=$2
VERSION=$3
PATH_WWW="/var/php/www"
PATH_TEMPLATE="`pwd`"
PATH_TEMPLATE_POSTFIX=".template"
PATH_APACHE="/etc/apache2/sites-available"
PATH_HOSTS="/etc/hosts"

##########
# method
##########

#install
install() {
    alias ahc='bash `pwd`'/ahc.sh' $@'
    echo 'Добавлено';
}

#uninstall
uninstall() {
    unalias ahc
    echo 'Удалено';
}

# add virtual host item
addVH() {
    ITEM=$1
    ITEM_APACHE="$PATH_APACHE/$ITEM.conf"
    chmod 777 "$PATH_WWW/$ITEM"
    TEMPLATE="$PATH_TEMPLATE/$VERSION$PATH_TEMPLATE_POSTFIX"
    cp ${TEMPLATE} ${ITEM_APACHE}
    sed -i -e "s/ITEM_APACHE/$ITEM/g" ${ITEM_APACHE}
    chmod 777 ${ITEM_APACHE}
    a2ensite "$ITEM.conf"
    echo "127.0.0.1       $ITEM" >> ${PATH_HOSTS}
    restart
}

# dell virtual host item
dellVH() {
    ITEM=$1
    ITEM_APACHE="$PATH_APACHE/$ITEM.conf"
    a2dissite "$ITEM.conf"
    rm -f ${ITEM_APACHE}
    restart
}

# restart apache2
restart() {
    systemctl reload apache2
}

#############
# script
#############
if [[ ${ACTION} == 'a' ]]
then
    echo "Добавление $DOMAIN";
    addVH ${DOMAIN}
elif [[ ${ACTION} == 'd' ]]
then
    echo "Удаление $DOMAIN";
    dellVH ${DOMAIN}
elif [[ ${ACTION} == 'i' ]]
then
    echo "Установка";
    init
elif [[ ${ACTION} == 'u' ]]
then
    echo "Удалено";
    uninstall
elif [[ ${ACTION} == 'd' ]]
then
    echo "DEBUG";
    echo "ACTION = $ACTION";
    echo "DOMAIN = $DOMAIN";
    echo "VERSION = $VERSION";
    echo "PATH_WWW = $PATH_WWW";
    echo "PATH_TEMPLATE = $PATH_TEMPLATE";
    echo "PATH_TEMPLATE_POSTFIX = $PATH_TEMPLATE_POSTFIX";
    echo "PATH_APACHE = $PATH_APACHE";
    echo "PATH_HOSTS = $PATH_HOSTS";
    echo "ACTION:"
    echo "ACTION"
elif [[ ${ACTION} == 'h' ]]
then
    echo "HELP";
    echo "ACTION:"
    echo "  a - add"
    echo "      NEED: DOMAIN, VERSION"
    echo "  d - dell"
    echo "      NEED: DOMAIN"
    echo "  i - install"
    echo "  u - uninstall"
    echo "  d - debug"
    echo "  h - help"
    echo "DOMAIN: your domain"
    echo "VERSION:"
    echo "  5.6"
    echo "  7.1"
    echo "  7.2"
else
    echo 'use h'
fi