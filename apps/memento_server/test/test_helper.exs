ExUnit.start()
Mix.Task.run "ecto.drop", ~w(-r MementoServer.Repo --quiet)
Mix.Task.run "ecto.create", ~w(-r MementoServer.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r MementoServer.Repo --quiet)
