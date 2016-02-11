#!/bin/bash
set -e

show_warning (){
	echo >&2 'warning: missing MYSQL_PORT_3306_TCP_ADDR'
	echo >&2 '  Did you forget to --link some-mysql:mysql'
	echo >&2 '  or -e MYSQL_PORT_3306_TCP_ADDR=some-mtsql-host -e MYSQL_PORT_3306_TCP_PORT=some-mysql-port ?'
	echo >&2
}

if [ "$1" = 'tpcc_load' ]; then
  if [ "$MYSQL_PORT_3306_TCP_ADDR" ]; then
    : ${MYSQL_PORT_3306_TCP_PORT:=3306}
    shift
    # exec gosu tpcc-mysql _test.sh $MYSQL_PORT_3306_TCP_ADDR:$MYSQL_PORT_3306_TCP_PORT "$@"
    exec gosu root tpcc_load $MYSQL_PORT_3306_TCP_ADDR:$MYSQL_PORT_3306_TCP_PORT "$@"
  else
		show_warning
    exit
  fi
elif [ "$1" = 'tpcc_start' ]; then
  if [ "$MYSQL_PORT_3306_TCP_ADDR" ]; then
    : ${MYSQL_PORT_3306_TCP_PORT:=3306}
    shift
    exec gosu root tpcc_start -h$MYSQL_PORT_3306_TCP_ADDR -P$MYSQL_PORT_3306_TCP_PORT "$@"
  else
		show_warning
    exit
  fi
fi

exec gosu root "$@"
