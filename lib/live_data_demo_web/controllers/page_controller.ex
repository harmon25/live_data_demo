defmodule LiveDataDemoWeb.PageController do
  use LiveDataDemoWeb, :controller
  @user_id 1

  def index(conn, _params) do
    token = Phoenix.Token.sign(LiveDataDemoWeb.Endpoint, "user auth", @user_id)

    conn
    |> put_session(:current_user_id, @user_id)
    |> put_session(:live_data_socket_id, "users_socket:#{@user_id}")
    |> render("index.html", token: token)
  end
end
