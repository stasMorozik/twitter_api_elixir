defmodule RestWeb.UserControllerTest do
  use RestWeb.ConnCase

  @sign_up_attrs %{name: "Name", email: "name@gmail.com", password: "123456"}

  @sign_in_attrs %{email: "name@gmail.com", password: "123456"}

  test "sign up user" do
    conn = post(build_conn(), "/api/user/sign-up", @sign_up_attrs)

    assert conn.status == 200
  end

  test "sign in user" do
    conn = post(build_conn(), "/api/user/sign-up", %{@sign_up_attrs | email: "name1@gmail.com"})

    conn = post(conn, "/api/user/sign-in", %{@sign_in_attrs | email: "name1@gmail.com"}) |> fetch_cookies()

    assert conn.status == 200
  end

  test "authorization user" do
    conn = post(build_conn(), "/api/user/sign-up", %{@sign_up_attrs | email: "name2@gmail.com"})

    conn = post(conn, "/api/user/sign-in", %{@sign_in_attrs | email: "name2@gmail.com"}) |> fetch_cookies()

    conn =
      conn
      |> recycle()
      |> fetch_cookies()

    conn = get(conn, "/api/user/")


    assert conn.status == 200
  end

  test "sign out" do
    conn = post(build_conn(), "/api/user/sign-up", %{@sign_up_attrs | email: "name3@gmail.com"})

    conn = post(conn, "/api/user/sign-in", %{@sign_in_attrs | email: "name3@gmail.com"}) |> fetch_cookies()

    conn =
      conn
      |> recycle()
      |> fetch_cookies()

    conn = get(conn, "/api/user/sign-out")

    assert conn.status == 200
  end
end
