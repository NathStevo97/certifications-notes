# 3.2 - Energy Efficiency

- [3.2 - Energy Efficiency](#32---energy-efficiency)
  - [Fossil Fuels and High-Carbon Sources of Energy](#fossil-fuels-and-high-carbon-sources-of-energy)
  - [Low-Carbon Sources of Energy](#low-carbon-sources-of-energy)
  - [Energy Measurement](#energy-measurement)
  - [Improving Energy Efficiency](#improving-energy-efficiency)
    - [Power Usage Effectiveness](#power-usage-effectiveness)
  - [Energy Proportionality](#energy-proportionality)
    - [Static Power Draw](#static-power-draw)
  - [Summary](#summary)

## Fossil Fuels and High-Carbon Sources of Energy

- Most electricity is produced via fossil fuel burning.
- The fuels are made from decomposing plants and animals, found within the earth's crust, and comprise of carbon and hyrdrogen.
- Typical examples: coal, oil, natural gas.

- As most electricity comes from fossil fuels, the most significant carbon emission cause, one can immediately see how tightly linked electricity usage is to fossil fuel emissions.
- To be carbon efficient, one therefore needs to be energy efficient as energy is a proxy for carbon.

## Low-Carbon Sources of Energy

- Clean energy comes from renewable, zero-emission sources that don't pollute the atmosphere when used.
- They also save enrgy through energy efficient practices.
- There are often overlaps between clean, green, and renewable energy sources, key differences include:
  - Clean Energy - Doesn't produce carbon emissions e.g. nuclear
  - Green energy - relies on sources from nature
  - Renewable Energy - sources don't expire e.g. solar, wind

## Energy Measurement

- Energy is measured in Joules (J); the SI unit of energy.
- Power is measured in watts (W), 1W = 1 Joule per second
- Kilowatt (kW) = 1000 Joules per second
- kilowatt-hour (kWh) = measure of energy corresponding to 1 kilowatt sustained for 1 hour.

## Improving Energy Efficiency

### Power Usage Effectiveness

- Data centers use Power Usage Effectiveness (PUE) to measure data center energy efficiency.
- This defines how much energy the infrastructure uses compared to cooling and other supporting overheads.
- Examples:
  - 1.0 - Computing is using nearly all the enrgy
  - 2.0 - An additional watt of IT power is needed to cool and distribute power to the infrastructure for every watt it uses.
- Effectively, PUE = a multiplier to an application's energy consumption.
- Example: if an application uses 10kWh and the data center's PUE is 1.5, the actual consumption is 15kWh; 5kWh goes towards operational overhead of the data center and 10kWh is used to run the application.

## Energy Proportionality

- Measures the relationship between power consumed by a computer and the rate at which useful work is done (its utilization).
- Utilization = how much of a computer's resources are used, usually expressed as a percentage.
- Power usage and utilization isn't proportional or linear in relationship, plateuing at high power usage.
- The more a computer is utilized, the more efficient it becomes at converting electricity to computation operations.
- To improve hardware efficiency, workloads should be run on as few servers as possible; this would maximise utilization rate and therefore energy efficiency.

### Static Power Draw

- How much electricity is drawn when in an idle state.
- Typically varies by configuration and hardware components, but all parts have it.
- It's the reason that lots of devices have power-saving modes; where the screen and disk are put to sleep, or the CPU's frequency is changed.
- These modes save electricity, but typically have adverse effects on performance e.g. slow restarts.

- Servers aren't typically configured for aggresive or minimal power saving.
- Typical use cases for servers demand total capacity as quickly as possible, as the server needs to respond to rapidly changing demands.
- This leads to many servers in idle modes during low demand periods; which incurs carbon costs from both embedded carbon and inefficient utilization.

## Summary

- Electricity is a proxy for carbon, so building an application that is energy efficient is equivalent to building an application that is carbon efficient.
- Green software takes responsibility for its electricity consumption and is designed to consume as little as possible.
- Quantifying the energy consumption of an application is a step in the right direction to start thinking about how an application can operate more efficiently. However, understanding your application's energy consumption is not the only story.
  - The hardware your software is running on uses some of the electricity for operational overhead. This is called power usage efficiency (PUE) in the cloud space.
- The concept of energy proportionality adds another layer of complexity since hardware becomes more efficient at turning electricity into useful operations the more it's used.
- Understanding this gives green software practitioners a better insight into how their application behaves with respect to energy consumption in the real world.
