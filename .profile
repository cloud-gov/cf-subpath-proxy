# delete the line starting with `php-fpm:`
# this makes PHP not start, which is good cause we don't need it
sed -i '/^php-fpm/d' $HOME/.procs
