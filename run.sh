#!/bin/bash
set -e

if [ ! -z ${GIT_REPO} ]; then
  if [ ! -f /var/www/drupal/.git/config ]; then
    if [ -z ${GIT_BRANCH} ]; then
      git clone $GIT_REPO /var/www/
    else
      git clone -b $GIT_BRANCH $GIT_REPO /var/www/
    fi
  else
    if [ -z ${GIT_BRANCH} ]; then
      git pull
    else
      git checkout $GIT_BRANCH
    fi
  fi
elif [ ! -z ${SITE_INSTALL} ]; then
   if [ ! -f /var/www/docroot/index.php ]; then
     drush dl drupal-7.x --destination=/var/www --drupal-project-rename=docroot
     cd /var/www/docroot
     drush site-install standard --account-name=$DRUPAL_USER --account-pass=$DRUPAL_PASSWORD --db-url=mysql://$MYSQL_USER:$MYSQL_PASSWORD@$MYSQL_HOST/$MYSQL_DATABASE
   fi
fi

#Set Envs
#PHP Memory Limit
if [ ! -z ${PHP_MEMORY_LIMIT} ]; then
  sed -i 's/memory_limit = .*/memory_limit = $PHP_MEMORY_LIMIT/' /etc/php5/fpm/php.ini
fi

#PHP Upload
if [ ! -z ${PHP_POST_MAX_SIZE} ]; then
  sed -i 's/post_max_size = .*/post_max_size = $PHP_POST_MAX_SIZE/' /etc/php5/fpm/php.ini
  sed -i 's/upload_max_filesize = .*/upload_max_filesize = $PHP_POST_MAX_SIZE/' /etc/php5/fpm/php.ini
fi

exec supervisord -n