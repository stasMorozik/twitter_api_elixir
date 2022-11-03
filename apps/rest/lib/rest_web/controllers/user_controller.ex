defmodule RestWeb.UserController do
  use RestWeb, :controller

  alias User.UseCases.RegistrationUseCase
  alias User.UseCases.AuthorizationUseCase
  alias User.UseCases.AuthenticationUseCase
  alias Users.CreateAdapter
  alias Users.GetAdapter
  alias Users.GetByEmailAdapter

  def sign_up(conn, params) do
    with {:ok, _} <- RegistrationUseCase.registry(
      %{name: params["name"], email: params["email"], password: params["password"]},
      CreateAdapter
    ) do
      conn |> put_status(:ok) |> json(true)
    else
      {:error, some_error} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(some_error))
    end
  end

  def sign_in(conn, params) do
    with {:ok, token} <- AuthenticationUseCase.auth(
      %{email: params["email"], password: params["password"]},
      GetByEmailAdapter
    ) do
      conn = conn |> put_resp_cookie("token", token)
      conn |> put_status(:ok) |> json(true)
    else
      {:error, some_error} ->
        conn |> put_status(:bad_request) |> json(Map.from_struct(some_error))
    end
  end

  def sign_out(conn, _) do
    conn = conn |> delete_resp_cookie("token")
    conn |> put_status(:ok) |> json(true)
  end

  def authorization(conn, _) do
    with {:ok, user_entity} <- AuthorizationUseCase.auth(conn.req_cookies["token"], GetAdapter) do
      conn |> put_status(:ok) |> json(user_entity)
    else
      {:error, some_error} ->
        conn |> put_status(:unauthorized) |> json(Map.from_struct(some_error))
    end
  end
end
