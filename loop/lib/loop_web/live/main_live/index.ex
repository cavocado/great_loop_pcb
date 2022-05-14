defmodule LoopWeb.MainLive.Index do
  use LoopWeb, :surface_view
  alias LoopWeb.Components.Button
  alias Circuits.SPI
  alias Surface.Components.Form
  alias Surface.Components.Form.{Field, Label, TextInput, Submit}
  alias LoopWeb.Components.Place

  def mount(_params, _session, socket) do
    {:ok, spi} = SPI.open("spidev0.0", mode: 3, lsb_first: true)

    {:ok,
     assign(socket, %{
       spi: spi,
       brightness: "1/16",
       leds: 0,
       on: [],
       places: Loop.Location.list(),
       blink: false,
       tps: 2,
       times: 4
     })}
  end

  @impl true
  def render(assigns) do
    ~F"""
    <h1>The Great Loop Board Controls</h1>

    <svg viewBox="0 0 120 110" xmlns="http://www.w3.org/2000/svg"  style="background-color:black;max-width:1000px;">
    {#for {place, {num, x, y}} <- @places}
      {#if Enum.member?(@on, num)}
        <Place x={x} y={y} fill="yellow" id={place} />
      {#else}
        <Place x={x} y={y} fill="white" id={place} />
      {/if}
    {/for}
    </svg>
    <br><br>
    <Button action="on" label="All On" id="on"/>
    <Button action="off" label="All Off" id="off"/>
    <Button action="loop" label="Loop" id="loop"/>

    <Form for={:leds} opts={autocomplete: "on"} submit="led">
      <Field name="led">
        <Label text="LEDs"/>
        <div class="control">
          <TextInput value={@leds}/>
        </div>
      </Field>
      <Submit label="Submit"/>
    </Form>

    <Form for={:brightness} opts={autocomplete: "on"} submit="bright">
      <Field name="brightness">
        <Label text="Brightness"/>
        <div class="control">
          <TextInput value={@brightness}/>
        </div>
      </Field>
      <Submit label="Submit"/>
    </Form>

    <Form for={:blink} opts={autocomplete: "on"} submit="blink">
      <Field name="blink">
      <Label text="Blink?"/>
      <div class="control">
        <TextInput value={@blink}/>
      </div>
      </Field>
      <Field name="tps">
      <Label text="Times Per Second"/>
      <div class="control">
        <TextInput value={@tps}/>
      </div>
      </Field>
      <Field name="times">
      <Label text="Number of Times"/>
      <div class="control">
        <TextInput value={@times}/>
      </div>
      </Field>
      <Submit label="Submit"/>
    </Form>
    """
  end

  @impl true
  def handle_event("on", _value, %{assigns: %{spi: spi, brightness: brightness}} = socket) do
    Loop.on(spi, brightness)
    {:noreply, assign(socket, spi: spi, on: Enum.to_list(1..63))}
  end

  @impl true
  def handle_event("off", _value, %{assigns: %{spi: spi}} = socket) do
    Loop.off(spi)
    {:noreply, assign(socket, spi: spi, on: [])}
  end

  @impl true
  def handle_event("loop", _value, %{assigns: %{spi: spi, brightness: brightness}} = socket) do
    Loop.great_loop(spi, brightness)
    {:noreply, assign(socket, spi: spi, on: [])}
  end

  @impl true
  def handle_event(
        "led",
        %{"leds" => leds},
        %{assigns: %{spi: s, brightness: b, blink: bl, tps: tps, times: t}} = socket
      ) do
    led_list = Loop.get_list(leds) |> Enum.sort()

    if bl do
      Loop.blink(s, led_list, b, tps, t)
    else
      Loop.turn_on(s, led_list, b, [0, 0, 0, 0, 0, 0, 0, 0])
    end

    {:noreply, assign(socket, on: led_list)}
  end

  @impl true
  def handle_event("bright", %{"brightness" => %{"brightness" => brightness}}, socket) do
    {:noreply, assign(socket, brightness: brightness)}
  end

  @impl true
  def handle_event(
        "blink",
        %{"blink" => %{"blink" => bl, "tps" => tps, "times" => times}},
        socket
      ) do
    blink =
      if bl == "true" do
        true
      else
        false
      end

    {:noreply,
     assign(socket, blink: blink, tps: String.to_integer(tps), times: String.to_integer(times))}
  end
end
