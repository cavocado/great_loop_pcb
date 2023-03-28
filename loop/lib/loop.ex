defmodule Loop do
  alias Circuits.SPI

  @route [
    20,
    19,
    11,
    10,
    18,
    17,
    29,
    28,
    27,
    26,
    25,
    33,
    41,
    49,
    42,
    43,
    44,
    35,
    45,
    50,
    51,
    57,
    58,
    59,
    52,
    53,
    54,
    60,
    61,
    62,
    63,
    55,
    56,
    48,
    40,
    47,
    38,
    39,
    31,
    32,
    16,
    15,
    14,
    13,
    8,
    7,
    6,
    5,
    12,
    19,
    20
  ]

  # Turns on LEDs in the Great Loop path
  def great_loop(spi, brightness), do: route(@route, spi, brightness)

  # Turns on LEDs in a given order
  def route([], spi, _brightness), do: off(spi)

  def route([first | rest], spi, brightness) do
    turn_on(spi, first, brightness, [])
    Process.sleep(100)
    route(rest, spi, brightness)
  end

  # Turns all the LEDs off
  def off(spi) do
    SPI.transfer(spi, <<0b01000000>>)
    SPI.transfer(spi, <<0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00>>)
    SPI.transfer(spi, <<0b10000000>>)
  end

  # Turns all the LEDs on
  def on(spi, brightness) do
    list = for i <- 1..63, do: i
    turn_on(spi, list, brightness, [0, 0, 0, 0, 0, 0, 0, 0])
  end

  # Turns one LED off and on at the given rate for the given number of times
  def blink(spi, _num, _brightness, _tps, 0), do: off(spi)

  def blink(spi, num, brightness, tps, times) do
    wait_time = div(1000, tps * 2)
    off(spi)
    Process.sleep(wait_time)
    turn_on(spi, num, brightness, [0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00])
    Process.sleep(wait_time)
    blink(spi, num, brightness, tps, times - 1)
  end

  # Turns on one LED
  def turn_on(spi, num, brightness, _list) when is_integer(num) do
    grid = div(num - 1, 8) + 1
    section = rem(num - 1, 8) + 1
    string = get_string(grid, section)
    SPI.transfer(spi, <<0b01000000>>)
    SPI.transfer(spi, string)
    SPI.transfer(spi, get_brightness(brightness))
  end

  # Turns on multiple LEDs
  def turn_on(spi, [], brightness, [g1, g2, g3, g4, g5, g6, g7, g8]) do
    SPI.transfer(spi, <<0b01000000>>)
    SPI.transfer(spi, <<0xC0, g1, g2, g3, g4, g5, g6, g7, g8>>)
    SPI.transfer(spi, get_brightness(brightness))
  end

  def turn_on(spi, [num | rest], brightness, grid_list) do
    grid = div(num - 1, 8)

    section =
      (rem(num - 1, 8) + 1)
      |> get_value()

    new_grid_list = List.update_at(grid_list, grid, fn x -> x + section end)
    turn_on(spi, rest, brightness, new_grid_list)
  end

  # Gets the binary representation of the LED
  defp get_string(1, section),
    do: <<0xC0, get_value(section), 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00>>

  defp get_string(2, section),
    do: <<0xC0, 0x00, get_value(section), 0x00, 0x00, 0x00, 0x00, 0x00, 0x00>>

  defp get_string(3, section),
    do: <<0xC0, 0x00, 0x00, get_value(section), 0x00, 0x00, 0x00, 0x00, 0x00>>

  defp get_string(4, section),
    do: <<0xC0, 0x00, 0x00, 0x00, get_value(section), 0x00, 0x00, 0x00, 0x00>>

  defp get_string(5, section),
    do: <<0xC0, 0x00, 0x00, 0x00, 0x00, get_value(section), 0x00, 0x00, 0x00>>

  defp get_string(6, section),
    do: <<0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, get_value(section), 0x00, 0x00>>

  defp get_string(7, section),
    do: <<0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, get_value(section), 0x00>>

  defp get_string(8, section),
    do: <<0xC0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, get_value(section)>>

  # Gets the binary representation of the section
  defp get_value(1), do: 0x01
  defp get_value(2), do: 0x02
  defp get_value(3), do: 0x04
  defp get_value(4), do: 0x08
  defp get_value(5), do: 0x10
  defp get_value(6), do: 0x20
  defp get_value(7), do: 0x40
  defp get_value(8), do: 0x80

  # Translates brightness to binary representation
  defp get_brightness("1/16"), do: <<0b10001000>>
  defp get_brightness("2/16"), do: <<0b10001001>>
  defp get_brightness("4/16"), do: <<0b10001010>>
  defp get_brightness("10/16"), do: <<0b10001011>>
  defp get_brightness("11/16"), do: <<0b10001100>>
  defp get_brightness("12/16"), do: <<0b10001101>>
  defp get_brightness("13/16"), do: <<0b10001110>>
  defp get_brightness("14/16"), do: <<0b10001111>>
end
