#!/bin/bash


if [[ $# -ne 1 ]]; then
    echo "usage: $0 /path/to/-nginx.log"
    echo ""
    echo "  分析统计gitlab接口分类访问量"
    exit 1
fi

echo "| 用户 | 创建            | `grep -E 'POST /api/v4/users[ ?]' $1 | wc -l` |                                 "
echo "| 用户 | 删除            | `grep -E 'DELETE /api/v4/users/[0-9]+[ ?]' $1 | wc -l ` |                        "
echo "| 用户 | 修改            | `grep -E 'PUT /api/v4/users/[0-9]+[ ?]' $1 | wc -l ` |                           "
echo "| 用户 | 查找            | ` grep -E 'GET /api/v4/users[ ?]' $1 | wc -l ` |                                 "
echo "| 项目 | 创建            | `grep -E 'POST /api/v4/projects[ ?]' $1 | wc -l ` |                              "
echo "| 项目 | 删除            | `grep -E 'DELETE /api/v4/projects/[0-9]+[ ?]' $1 | wc -l ` |                     "
echo "| 项目 | 修改            | `grep -E 'PUT /api/v4/projects/[0-9]+[ ?]' $1 | wc -l ` |                        "
echo "| 项目 | 查找            | `grep -E 'GET /api/v4/projects[ ?]' $1 | wc -l ` |                               "
echo "| 仓库 | 查看tree        | `grep -E 'GET /api/v4/projects/[[:digit:]]+/repository/tree[ ?]' $1 | wc -l ` |  "
echo "| 文件 | 查看            | `grep -E 'GET /api/v4/projects/[[:digit:]]+/repository/files/' $1 | wc -l ` |    "
echo "| 文件 | 查看，非api方式  | `grep -E 'GET /.*/raw/([[:alnum:]]+|master)/' $1 | wc -l ` |                    "
echo "| 文件 | 新建            | `grep -E 'POST /api/v4/projects/[[:digit:]]+/repository/files/' $1 | wc -l ` |   "
echo "| 文件 | 更新            | `grep -E 'PUT /api/v4/projects/[[:digit:]]+/repository/files/' $1 | wc -l ` |    "
echo "| 文件 | 删除            | `grep -E 'DELETE /api/v4/projects/[[:digit:]]+/repository/files/' $1 | wc -l ` | "

exit 0
