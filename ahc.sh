#!/bin/bash
#########################################################
#
# Script  add Virtual host
# Author:GRS gaevoyrs@gmail.com
#
#########################################################

##############
# var
##############
ACTION=$1
DOMAIN=$2
VERSION=$3
PATH_WWW="var/php/www"
PATH_TEMPLATE="`pwd`"
PATH_TEMPLATE_POSTFIX=".template"
PATH_APACHE="/etc/apache2/sites-available"
PATH_HOSTS="/etc/hosts"

##########
# method
##########

# add virtual host item
addVH() {
    ITEM=$1
    ITEM_APACHE="$PATH_APACHE/$ITEM.conf"
    chmod 777 "$PATH_WWW/$ITEM"
    TEMPLATE="$PATH_TEMPLATE/$VERSION/$PATH_TEMPLATE_POSTFIX"
    cp ${PATH_TEMPLATE} ${ITEM_APACHE}
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
if [ ${ACTION} == 'a' ]
then
    echo "Добавление $DOMAIN";
    addVH ${DOMAIN}
elif [ ${ACTION} == 'd' ]
then
    echo "Удаление $DOMAIN";
    dellVH ${DOMAIN}
elif [ ${ACTION} == 'h' ]
then
    echo "HELP $DOMAIN $VERSION";
fi