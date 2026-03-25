# PCB Design with the nPM1100 PMIC

This is documentaion written after the fact, if you want to read the 
design process as it was done, consider [./README.old.md](the old readme). 
I'll explain my model in two layers of abstraction.

1. Behaviour level
2. Pin level

## Behaviour level

A PMIC is typically used on a portable electronic device: like a mobile phone, 
a gaming mouse, a drone etc. it abstracts away the details of charging and battery
and provides a stable voltage and current to the microcontroller chip.

This means that our chip has the following

1. input (USB or barrel)
2. output (microcontroller)
3. inout (battery, which has to be charged and discharged)

In this case, our design requirements demand

1. 3V DC
2. 200mA charging
3. 35mmx35mm for the entire PCB

and we have been told to use the nordic semiconductor nPM1100 PMIC
with the QFN24 variant, which is 4mmx4mm.

The charging current is to be 200mA, for the battery to be useful,
the consumption current should be less than that,
say 50-100mA, the datasheet states about 150,
so we have about 450mW of power consumption, which is more or less typical for 
a small electronic device.

Now we confirm a few things from the datasheet

### Package size

The 4mmx4mm package does indeed exist

> nPM1100 is an integrated Power Management IC (PMIC) with a linear-mode lithium-ion/lithium-polymer battery charger in a compact 2.1x2.1 mm WLCSP or 4.0x4.0 mm QFN package. It has a highly efficient DC/ DC buck regulator with configurable dual mode output.

![./images/ordering_informtation.png](Ordering info)

and we can indeed order it, according to the datasheet, the exact variant we want is

> nPM1100-QDAA-XX

where the QD portion signifies the QFN package, and AA specifies the Vterm voltage

### Charging Current

We can indeed charge at 200mA 

> Configurable charge current with a resistor connected to the ICHG pin (from 20 mA to 400 mA)

and we need to use a 1.5k resistor according to the table

![./images/charging_current.png](charging current)

### Output voltage

We can indeed output a stable 3.0V using the buck regulator

> Configurable output voltage between 1.8 V and 3.0 

and we need to set both VOUTBSET pins high accourding to the table

![./images/voltage_selection.png](voltage selection)

