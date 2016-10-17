use Mix.Config

config :memento_server, MementoServer.Repo,
  database: "memento.notes.test"
  #pool:     Ecto.Adapters.SQL.Sandbox

config :logger, level: :debug
