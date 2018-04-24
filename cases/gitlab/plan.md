# gitlab测试规划

对gitlab的测试，只关心keepwork所使用到的部分

目前keepwork将gitlab当做一个保存git的数据库来使用，涉及最多的就是仓库，文件的读写，完全使用api
来操作

## api


keepwork对gitlab的访问无外乎资源的访问，以下的表格统计了主要资源访问的方式与在日志中检索到的次数

> 对用户，项目，仓库，文件的增，删，查，更新


| 实体 | 操作            | 帮助                                                                                    | method | url                                                 |  hits | hit how to                                                         |            |
|------|-----------------|-----------------------------------------------------------------------------------------|--------|-----------------------------------------------------|-------|--------------------------------------------------------------------|------------|
| 用户 | 创建            | https://docs.gitlab.com/ee/api/users.html#user-creation                                 | POST   | /api/v4/users                                       |  3838 | `grep -E 'POST /api/v4/users[ ?]'`                                 |            |
| 用户 | 删除            | https://docs.gitlab.com/ee/api/users.html#user-deletion                                 | DELETE | /api/v4/users/:id                                   |     0 | `grep -E 'DELETE /api/v4/users/[0-9]+[ ?]'`                        |            |
| 用户 | 修改            | https://docs.gitlab.com/ee/api/users.html#user-modification                             | PUT    | /api/v4/users/:id                                   |    13 | `grep -E 'PUT /api/v4/users/[0-9]+[ ?]'`                           |            |
| 用户 | 查找            | https://docs.gitlab.com/ee/api/users.html#for-admins                                    | GET    | /api/v4/users                                       |  3902 | ` grep -E 'GET /api/v4/users[ ?]'`                                 |            |
| 项目 | 创建            | https://docs.gitlab.com/ee/api/projects.html#create-project                             | POST   | /api/v4/projects                                    |  4141 | `grep -E 'POST /api/v4/projects[ ?]'`                              |            |
| 项目 | 删除            | https://docs.gitlab.com/ee/api/projects.html#remove-project                             | DELETE | /api/v4/projects/:id                                |     0 | `grep -E 'DELETE /api/v4/projects/[0-9]+[ ?]'`                     |            |
| 项目 | 修改            | https://docs.gitlab.com/ee/api/projects.html#edit-project                               | PUT    | /api/v4/projects/:id                                |     2 | `grep -E 'PUT /api/v4/projects/[0-9]+[ ?]'`                        |            |
| 项目 | 查找            | https://docs.gitlab.com/ee/api/projects.html#list-all-projects                          | GET    | /api/v4/projects                                    |  4192 | `grep -E 'GET /api/v4/projects[ ?]'`                               |            |
| 仓库 | 查看tree        | https://docs.gitlab.com/ee/api/repositories.html#list-repository-tree                   | GET    | /api/v4/projects/:id/repository/tree                | 21179 | `grep -E 'GET /api/v4/projects/[[:digit:]]+/repository/tree[ ?]'`  |            |
| 文件 | 查看            | https://docs.gitlab.com/ee/api/repository_files.html#get-file-from-repository           | GET    | /api/v4/projects/:id/repository/files/:file_path    | 19745 | `grep -E 'GET /api/v4/projects/[[:digit:]]+/repository/files/'`    |            |
| 文件 | 查看，非api方式 | no                                                                                      | GET    | /:user_name/:project_name/raw/:commit_id/:file_path | 59588 | `grep -E 'GET /.*/raw/([[:alnum:]]+                                | master)/'` |
| 文件 | 新建            | https://docs.gitlab.com/ee/api/repository_files.html#create-new-file-in-repository      | POST   | /api/v4/projects/:id/repository/files/:file_path    | 73629 | `grep -E 'POST /api/v4/projects/[[:digit:]]+/repository/files/'`   |            |
| 文件 | 更新            | https://docs.gitlab.com/ee/api/repository_files.html#update-existing-file-in-repository | PUT    | /api/v4/projects/:id/repository/files/:file_path    |  3278 | `grep -E 'PUT /api/v4/projects/[[:digit:]]+/repository/files/'`    |            |
| 文件 | 删除            | https://docs.gitlab.com/ee/api/repository_files.html#delete-existing-file-in-repository | DELETE | /api/v4/projects/:id/repository/files/:file_path    |   295 | `grep -E 'DELETE /api/v4/projects/[[:digit:]]+/repository/files/'` |            |


由于CDN对静态md文件的缓存，非api统计的读文件次数要少


## jmeter

日常的主要操作是读与写，两者的比例大致设定为4：1

批量创建用户 -> 删除用户
