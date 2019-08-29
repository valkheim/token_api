#!/usr/bin/env bash

mix ecto.create

user="postgres"
database="auth_ex"

function req() {
  psql -U "$user" -d "$database" -c "$1"
}

req "DROP TABLE IF EXISTS tokens"

req 'CREATE TABLE tokens(id serial unique,
"user" text unique primary key,
"pass" text,
"token" text,
"seed" int,
"issued_at" int,
"expire_at" int)'
req "INSERT INTO tokens VALUES (1,'user','pass','token',000000000,1567070779,1567074509)"
req "SELECT * FROM tokens"

count=$(psql -U "$user" -d "$database" -t -c "select count(1) from tokens")

echo "tokens: $count"

curl localhost:4000/tokens
