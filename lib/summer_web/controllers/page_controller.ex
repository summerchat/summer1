defmodule SummerWeb.PageController do
  use SummerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
