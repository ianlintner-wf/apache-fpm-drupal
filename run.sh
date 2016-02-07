#!/bin/bash
set -e

if [ ! -z ${GIT_REPO} ]; then
  if [ ! -f /var/www/drupal/.git/config ]; then
    if [ -z ${GIT_BRANCH} ] then
      git clone $GIT_REPO /var/www/drupal
    else
      git clone -b $GIT_BRANCH $GIT_REPO /var/www/drupal
    fi
  else
    if [ -z ${GIT_BRANCH} ] then
      git pull
    else
      git checkout $GIT_BRANCH
    fi
  fi
else if [ ! -z ${SITE_INSTALL} ]; then
   if [ ! -f /var/www/drupal/docroot/index.php ]; then
     cd /var/www/drupal
     drush dl drupal7 --destination=/var/www/drupal/docroot
   fi
fi

exec supervisord -n