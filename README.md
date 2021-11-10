# EE365 Project 4

This repository contains the Vivado project for our EE365 project 4 submission.

# Hardware

The usage is as follows:

1. Connect the 7-segment display controller to the Cora Z7 using hte pinout below. Do not use TX and SPI connections at the same time, only one.
2. Plug the buttons PMOD connector into the top of the A PMOD connector.
3. Run the synthesis, implementation and bitstream generation, then upload to the board.

# Simulations

The project simulations are as follows:

- `sim_1`: `top_logic` simulation
- `sim_2`: UART simulation
- `sim_3`: SPI simulation

# Pinouts

JA is designed to be connected directly to the button PMOD module, with the header plugged into the higher row of positions.

JB is as follows:

| `jb[x]` | Connection | Purpose        |
|---------|------------|----------------|
| `jb[0]` | TX         | UART TX Signal |
| `jb[1]` | MOSI       | SPI            |
| `jb[2]` | CS         | SPI            |
| `jb[3]` | SCK        | SPI            |

The LEDs are used for quick troubleshooting and feedback. 

- LED_0_RED will be turned on whenever the TX line is active, indicating communication on SPI and UART.
- LED_1_RED will be turned on whenever the system is in up-counting mode.
