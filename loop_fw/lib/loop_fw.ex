defmodule LoopFw do
  @moduledoc """
  Loop firmware
  """

  def ssh_check_pass(_provided_username, provided_password) do
    correct_password = Application.get_env(:loop_fw, :password, "loop")

    provided_password == to_charlist(correct_password)
  end

  def ssh_show_prompt(_peer, _username, _service) do
    {:ok, name} = :inet.gethostname()

    msg = """
    https://github.com/cavocado/loop

    ssh loop@#{name}.local # Use password "loop"
    """

    {'The Great Loop', to_charlist(msg), 'Password: ', false}
  end
end
