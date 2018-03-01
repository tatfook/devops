# gitlab测试规划

对gitlab的测试，只关心keepwork所使用到的部分

目前keepwork将gitlab当做一个保存git的数据库来使用，涉及最多的就是仓库，文件的读写，完全使用api
来操作

## api

统计keepwork所调用的gitlab api有哪些以及它们各自调用的频率是多少

对前一个的nginx日志统计计算，由goaccess进行分析，生成result.html报表

可以分析出大部分对于gitlab的访问，集中于项目的写入与读取。挑选出其中占比80的接口，作出统计

由于CDN对静态md文件的缓存，导致统计的文件读次数要少很多

用户，项目，仓库，文件
增，删，查，更新

top requests (URLs)

|hits|method|url|doc|desc|
|----|------|---|---|----|
|4141|POST|/api/v4/projects|https://docs.gitlab.com/ee/api/projects.html#create-project|创建项目|
|3838|POST|/api/v4/users|https://docs.gitlab.com/ee/api/users.html#user-creation|创建用户|
|3794|GET|/api/v4/projects?owned=true&search=keepworkdatasource|项目搜索|
|    |GET|/[gitlab user]/[project name]/raw/[file path] |非api， 直接访问项目文件 |
||GET|/api/v4/projects/[repo id]/repository/tree?[params]|获取项目目录结构|
||GET|/api/v4/projects/[repo id]/repository/files/[path]?[params] |获取项目文件|



|实体|操作    |帮助 |method|url|hits|hit how to|
|---|--------|----|------|---|----|----------|
|用户|创建|https://docs.gitlab.com/ee/api/users.html#user-creation|POST|/api/v4/users| 3838 |`grep -E 'POST /api/v4/users[ ?]'` |
|用户|删除|https://docs.gitlab.com/ee/api/users.html#user-deletion|DELETE|/api/v4/users/:id| 0 | `grep -E 'DELETE /api/v4/users/[0-9]+[ ?]'`                                   |
|用户|修改|https://docs.gitlab.com/ee/api/users.html#user-modification|PUT|/api/v4/users/:id| 13  | `grep -E 'PUT /api/v4/users/[0-9]+[ ?]'` |
|用户|查找|https://docs.gitlab.com/ee/api/users.html#for-admins|GET|/api/v4/users| 3902 | ` grep -E 'GET /api/v4/users[ ?]'` |
|项目|创建|https://docs.gitlab.com/ee/api/projects.html#create-project|POST|/api/v4/projects| 4141 | `grep -E 'POST /api/v4/projects[ ?]'` |
|项目|删除|https://docs.gitlab.com/ee/api/projects.html#remove-project|DELETE|/api/v4/projects/:id| 0 | `grep -E 'DELETE /api/v4/projects/[0-9]+[ ?]'`|
|项目|修改|https://docs.gitlab.com/ee/api/projects.html#edit-project|PUT|/api/v4/projects/:id| 2 | `grep -E 'PUT /api/v4/projects/[0-9]+[ ?]'`|
|项目|查找|https://docs.gitlab.com/ee/api/projects.html#list-all-projects |GET|/api/v4/projects | 4192         |  `grep -E 'GET /api/v4/projects[ ?]'` |









## 规划
