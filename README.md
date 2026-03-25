# AGV Embedded Systems Selection Round

I attempted the first two tasks, the PCB design of the nPM1100 and the digital design of CORDIC in verilog

## Structure of the Repository

The task folders each have their directories, within the first level, the README.md
will have the info required to run the programs including installation directions etc
The documentation and approach will be in the doc folder

## Progress on the tasks

### PCB design

1. Base task (design req)
    a. Schematic
    b. Design 
    c. BOM
2. Expose CHG, ERR, ISET, MODE, SHPHLD and SHPACT pins to MCU
3. Status LEDs
4. Battery Monitoring

Constraints
1. Max Dimensions
2. SMD, top mounted
3. 0403-0805 footprints
4. Input via 2 pin header       NOTE
5. Max 4 copper layers
6. QFN24 footprint with used central thermal pad
7. 3V output
8. 200mA output

### Digital Design

1. Design
    a. n-bit adder
    b. complemts and subtracter
    c. comparator
    d. look up table
    e. 8 bit to 12 bit CORDIC
2. Test Bench
3. GTKWave
