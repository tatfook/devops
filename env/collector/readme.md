



grafana ref:

https://hub.docker.com/r/grafana/grafana/


influxdb ref:

https://hub.docker.com/_/influxdb/


create config file

$ docker run --rm influxdb influxd config > influxdb.conf

open graphite, http, udp options

create db

```
curl -G http://localhost:8086/query --data-urlencode "q=CREATE DATABASE jmeter"
curl -G http://localhost:8086/query --data-urlencode "q=CREATE DATABASE docker"
curl -G http://localhost:8086/query --data-urlencode "q=CREATE DATABASE gitlab"
```



jmeter

metric to influxdb
http://jmeter.apache.org/usermanual/realtime-results.html
http://jmeter.apache.org/usermanual/component_reference.html#Backend_Listener

1. jmeter add backend listener

![](./jmeter-backend-listener.png)

2. 配置选项

- backend listener implementation 选择 influxdb

params:
- influxdbMetricsSender，保持不动
- influxdbUrl，选择db服务的地址，db名称保持一致
- application，自己命名，后期作为筛选条件
- measurement，保持jmeter不动
- summaryOnly，改为false，不只需要一个总结统计
- samplersRegex，可以与application结合起来，绑定一组samplers
- percentiles，保持默认即可，百分比统计
- testTitle，测试名称，存储在influxdb events 中的 text 字段中
- eventTags，用来进行标注，暂时用不到

3. db数据分析

`docker exec -it collector_db_1 influx`

进入容器并执行influx shell程序

```
> help

> show databases
name: databases
name
----
_internal
jmeter
docker
gitlab

> use jmeter
Using database jmeter

> show series
key
---
events,application=gitlab,title=ApacheJMeter
jmeter,application=gitlab,statut=all,transaction=HTTP请求
jmeter,application=gitlab,statut=all,transaction=all
jmeter,application=gitlab,statut=all,transaction=创建用户
jmeter,application=gitlab,statut=all,transaction=删除用户
jmeter,application=gitlab,statut=all,transaction=查询用户ID
jmeter,application=gitlab,statut=ok,transaction=HTTP请求
jmeter,application=gitlab,statut=ok,transaction=创建用户
jmeter,application=gitlab,statut=ok,transaction=删除用户
jmeter,application=gitlab,statut=ok,transaction=查询用户ID
jmeter,application=gitlab,transaction=internal

> show field keys
name: events
fieldKey fieldType
-------- ---------
text     string

name: jmeter
fieldKey   fieldType
--------   ---------
avg        float
count      float
countError float
endedT     float
hit        float
max        float
maxAT      float
meanAT     float
min        float
minAT      float
pct90.0    float
pct95.0    float
pct99.0    float
startedT   float
```

- 数据全部存储在jmeter数据库中
- series可以理解为表，最前面的为表名，如events，jmeter，后续的键值可以理解为选择表的条件，必需将
  所有列限定，才算作指定一个表，取到其中存储的数据
- field keys可以理解为表中的列，每一个key其中都存储了相应数据，类型由fieldType标识





4. 配置grafana

理解数据结构之后，再来配置grafana就简单一些

![](./grafana-config.png)

- 其中最前面的为表名
- where标明了表的限定条件，这里使用了3个条件，才完全限定了一个表
- select标明了数据列的取值
- group by一般不用
