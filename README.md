# The Great Loop PCB

This is a project designed to provide a user-friendly interface for controlling LEDs on a custom PCB, showcasing the Great Loop.

![PCB](pictures/loop_pcb.jpeg)

## Building

```sh
cd loop
mix deps.get
mix assets.deploy
cd ../loop_fw
export MIX_TARGET=rpi0  # or rpi3a or whatever board you're using
mix deps.get
mix firmware
```

## Loading firmware

To create the MicroSD card for the first time:

```sh
cd loop_fw
mix firmware.burn
```

The next times:

```sh
# Run this line if you don't have ./upload.sh
mix firmware.gen.script
# Upload the firmware over ssh
./upload.sh
```

## Using

Visit http://your_device_name.local/main to access the controls for the board.

![UI 1](pictures/ui_1.png)

Below the display, there are forms and buttons to turn LEDs on and off, make them blink and turn them on in a path. The LEDs are referred to by their place names and separated by commas.

![UI 2](pictures/ui_2.png)

The names of the LEDs are located at the bottom of the page.

![UI 3](pictures/ui_3.png)

## Hardware

We used [EasyEDA](https://easyeda.com/) for creating the schematics and ordered
boards through [JLCPCB](https://jlcpcb.com/). We also had JLCPCB do the
assembly. You can view a [pdf of the schematics](schematic_great_loop.pdf) or
look at its [OSHWLab project](https://oshwlab.com/fhunleth/binary_clock2_copy).

![Front](pictures/3d-front.png)
![Back](pictures/3d-back.png)

## License

The code for this project is licensed under the Apache License, Version 2.0.
