# pcb-util

Contains a script for exporting a gEDA PCB file to the Gerber format in the form
expected by DirtyPCBs.

## Prerequisites

Debian: `apt-get install gerbv pcb zip`
Arch Linux: `pacman -S gerbv pcb zip`
NixOS: `nix-shell ./shell.nix`

## Usage

```bash
./build-gerbers.sh ../power-v4-hw/power.pcb
./build-gerbers.sh ../motor-v4-hw/motor.pcb
```

A `build` directory is created in the current directory, containing the ZIP file
ready for submission to DirtyPCBs along with other intermediate files.

## License

See [LICENSE.md](LICENSE.md).
