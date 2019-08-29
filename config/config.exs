use Mix.Config

config :server, Server.Endpoint, port: 4000

config :server, ecto_repos: [Server.Repo]

config :server, Server.Repo,
  database: "auth_ex",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"

config :server, ttl: 60

import_config "#{Mix.env()}.exs"
