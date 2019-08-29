use Mix.Config

config :server, Server.Endpoint, port: 80

config :server, Server.Repo,
  database: "auth_ex",
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  port: "5432"
