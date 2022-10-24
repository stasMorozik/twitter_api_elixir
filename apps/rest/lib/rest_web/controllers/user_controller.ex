defmodule RestWeb.UserController do
  use RestWeb, :controller

  alias User.UseCases.RegistrationUseCase
  alias User.UseCases.AuthorizationUseCase
  alias User.UseCases.AuthenticationUseCase
  alias Users.CreateAdapter
  alias Users.GetAdapter
  alias Users.GetByEmailAdapter

  def sign_up(conn, params) do

  end

  def sign_in(conn, params) do

  end

  def sign_out(conn, params) do

  end
end
