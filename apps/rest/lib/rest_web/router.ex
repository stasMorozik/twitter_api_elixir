defmodule RestWeb.Router do
  use RestWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", RestWeb do
    pipe_through :api

    post "/user/sign-up", UserController, :sign_up
    post "/user/sign-in", UserController, :sign_in
    delete "/user/sign-out", UserController, :sign_out
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
