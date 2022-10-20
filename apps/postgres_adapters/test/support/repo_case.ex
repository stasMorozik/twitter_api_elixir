defmodule RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Users.Repo

      import Ecto
      import Ecto.Query
      import RepoCase

      # and any other stuff
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Users.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Users.Repo, {:shared, self()})
    end

    :ok
  end
end
