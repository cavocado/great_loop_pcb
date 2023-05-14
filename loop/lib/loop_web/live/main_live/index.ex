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
       leds: "",
       on: [],
       places: Loop.Location.make_list(),
       blink: "solid",
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
          <Label text="Blink, Solid, or Route?"/>
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


        <b>Place Names (in path order; counterclockwise)</b>
        <p>
        Middle (Chattanooga Section):
        Grand Rivers,
        Chattanooga,
        Huntsville,
        Fulton,
        Columbus,
        Demopolis
        </p>
        <p>
        South:
        New Orleans,
        Gulfport,
        Pensacola,
        Miramar Beach,
        Apalachicola,
        Clearwater,
        Cape Coral,
        Marco Island,
        Key West,
        Miami,
        Lake Okeechobee,
        West Palm Beach,
        New Smyrna Beach,
        St. Augustine,
        Fernandina Beach
        </p>
        <p>
        East:
        Albany,
        New York City,
        Atlantic City,
        Cape May,
        Annapolis,
        Deltaville,
        Norfolk,
        Dismal Swamp,
        Morehead City,
        Wilmington,
        Myrtle Beach,
        Charleston,
        Savannah
        </p>
        <p>
        North (US path):
        Syracuse,
        Rochester,
        Buffalo,
        Cleveland,
        Toledo,
        Detroit,
        Port Hope,
        Alpena
        </p>
        <p>
        North (Canada path):
        Fort Edward,
        Burlington,
        Montreal,
        Ottawa,
        Kingston,
        Peterborough,
        Britt,
        Drummond
        </p>
        <p>
        West:
        Mackinaw City,
        Petoskey,
        Manistee,
        Grand Haven,
        Chicago,
        Hennepin,
        Peoria,
        St. Louis,
        Cape Girardeau,
        Memphis,
        Greenville,
        Vicksburg,
        Baton Rouge
        </p>
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
  def handle_event("led", %{"leds" => %{"led" => leds}}, %{assigns: %{spi: s, brightness: b, blink: "blink", tps: tps, times: t}} = socket) do
    led_list = Loop.Location.get_list(leds) |> Enum.sort()
    Loop.blink(s, led_list, b, tps, t)
    {:noreply, assign(socket, on: led_list)}
  end

  @impl true
  def handle_event("led", %{"leds" => %{"led" => leds}}, %{assigns: %{spi: s, brightness: b, blink: "route"}} = socket) do
    led_list = Loop.Location.get_list(leds)
    Loop.route(led_list, s, b)
    {:noreply, assign(socket, on: led_list)}
  end

  @impl true
  def handle_event("led", %{"leds" => %{"led" => leds}}, %{assigns: %{spi: s, brightness: b}} = socket) do
    led_list = Loop.Location.get_list(leds)
    Loop.turn_on(s, led_list, b, [0, 0, 0, 0, 0, 0, 0, 0])
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
    {:noreply,
     assign(socket, blink: bl, tps: String.to_integer(tps), times: String.to_integer(times))}
  end
end
