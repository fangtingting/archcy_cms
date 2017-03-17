# 使用方法 ./bin/unicorn.sh start|restart|stop

#!/bin/bash
RAILS_ROOT=/home/reach/rccchina/reach

source "$HOME/.rvm/scripts/rvm"
cd $RAILS_ROOT
rvm use 2.1.4@archcy_cms
case "$1" in
  start)
    unicorn_rails -c $RAILS_ROOT/config/test_unicorn.rb -E production -D
    ;;
  stop)
    kill -QUIT `cat $RAILS_ROOT/tmp/pids/unicorn.pid`
    ;;
  restart)
    kill -USR2 `cat $RAILS_ROOT/tmp/pids/unicorn.pid`
    ;;
  kill)
    kill -KILL `cat $RAILS_ROOT/tmp/pids/unicorn.pid`
    ;;
  *)
    printf "Usage: $NAME {start|stop|restart}"
    ;;
esac

exit 0