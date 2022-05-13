defmodule LoopWeb.Components.Button do
  use Surface.LiveComponent

  prop(action, :string, required: true)
  prop(label, :string, required: true)

  def mount(socket, action, label) do
    {:ok, assign(socket, action: action, label: label)}
  end

  def render(assigns) do
    ~F"""
    <button phx-click={@action}>{@label}</button>
    """
  end
end
