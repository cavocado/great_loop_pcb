defmodule LoopWeb.Components.Place do
  use Surface.LiveComponent

  prop(x, :string, required: true)
  prop(y, :string, required: true)
  prop(fill, :string, required: true)

  def mount(socket, x, y, fill) do
    {:ok, assign(socket, x: x, y: y, fill: fill)}
  end

  def render(assigns) do
    ~F"""
    <circle cx={@x} cy={110 - @y} r="1.5" fill={@fill} />
    """
  end
end
