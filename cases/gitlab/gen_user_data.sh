#!/bin/bash

sum=10
if [[ ! -z $1 ]]; then
    sum=$1
fi

echo "username, name, email, password"

for i in $(seq 1 $sum); do
    user="a$i"
    echo "$user, $user, ${user}@tatfook.com, abcdefge"
done

