## tpcc-mysql in Docker

This is [tpcc-mysql](https://github.com/pingcap/tpcc-mysql) in a docker image.

### How to use

#### Preparing database

```bash
# create database on your MySQL
echo "create database <mysql-dbname>;" | mysql -u <mysql-user> -h <mysql-host> <other-mysql-options...>
# create tables and add indexes
docker run -it --rm gaishimo/docker-tpcc-mysql cat create_table.sql add_fkey_idx.sql | mysql -u <mysql-user> -h <mysql-host> <other-mysql-options...>
```

#### tpcc_load (load test data)

```bash
docker run -it --rm -e MYSQL_PORT_3306_TCP_ADDR=<mysql-host> gaishimo/docker-tpcc-mysql tpcc_load <mysql-dbname> <mysql-user> '<mysql-password>' <warehouses>
```

Please set mysql host through the env MYSQL_PORT_3306_TCP_ADDR or link mysql docker container.

If linking mysql container, do like below.
```bash
docker run -it --rm --link mysql-container:mysql gaishimo/docker-tpcc-mysql tpcc_load <mysql-dbname> <mysql-user> '<mysql-password>' <warehouses>
```


#### tpcc_start

```bash
docker run -it --rm -e MYSQL_PORT_3306_TCP_ADDR=<mysql-host> gaishimo/docker-tpcc-mysql tpcc_start -d<mysql-dbname> -u <mysql-user> -w <warehouses> -c<connections> -r<warmup_time> -l<benchmark_time>
```
