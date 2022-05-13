defmodule LoopWeb.PageController do
  use LoopWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
