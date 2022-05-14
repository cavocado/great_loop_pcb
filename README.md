# Loop

## Building

```sh
cd loop
mix deps.get
mix assets.deploy
cd ../loop_fw
export MIX_ENV=rpi0  # or rpi3a or whatever board you're using
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
mix firmware.gen.script
./upload.sh
```

