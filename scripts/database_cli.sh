#!/bin/bash
user="postgres"
database="auth_ex"

function prompt {
  printf "db> "
}

function req {
  psql -U "$user" -d "$database" -c "$1"
}

while IFS= read -p 'db> ' -r query
do
  req "$query"
done < "/dev/stdin"

exit 0
