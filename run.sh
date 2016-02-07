#!/bin/bash
set -e

if [ ! -z ${GIT_REPO} ]; then
  if [ ! -f /var/www/drupal/.git/config ]; then
    if [ -z ${GIT_BRANCH} ]; then
      git clone $GIT_REPO /var/www/drupal
    else
      git clone -b $GIT_BRANCH $GIT_REPO /var/www/drupal
    fi
  else
    if [ -z ${GIT_BRANCH} ]; then
      git pull
    else
      git checkout $GIT_BRANCH
    fi
  fi
elif [ ! -z ${SITE_INSTALL} ]; then
   if [ ! -f /var/www/drupal/docroot/index.php ]; then
     drush dl drupal-7.x --destination=/var/www/drupal --drupal-project-rename=docroot
     cd /var/www/drupal/docroot
     drush site-install standard --account-name=$DRUPAL_USER --account-pass=$DRUPAL_PASSWORD --db-url=mysql://$MYSQL_USER:$MYSQL_PASSWORD@$MYSQL_HOST/$MYSQL_DATABASE
   fi
fi

exec supervisord -n