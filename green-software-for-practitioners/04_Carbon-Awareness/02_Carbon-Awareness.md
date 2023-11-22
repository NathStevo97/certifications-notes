# 4.2 - Carbon Awareness

## Key Concepts

### Carbon Intensity

- How much Carbon (CO2e) is emitted per kWh of electricity consumed. Measured in gCO2eq/kWh (grams of carbon per kilowatt hour).
- Carbon intensity is a mix of all the current power sources in the power grid, both the low and high-carbon using resources will be considered in the measurement.

###  Variability of Carbon Intensity

- This varies by location, depending on the clean energy sources available.
- Additional variability follows due to changes in when clean energy could be available / unavailable due to weather conditions e.g. on a windy day carbon intensity will decrease / not be as intense.

### Dispatchability & Curtailment

- Electricity demand varies throughout the day.
- If a utility doesn't provide enough electricity to meet demand, a brownout occurs (a dip in the power line's voltage level)
- If a utility produces more electricity than is required,a  blackout occurs / is put in place to stop infrastructure burning out.
- The balance between the demand and supply is handled by the utility provider.
- For fossil fuels, it's easier to control the amount of power produced; this is dispatchability.
- For renewable power, we cannot easily control how much is produced e.g. we cannot control whether it's a sunny day.
- If a power source produces more electricity needed, that electricity will be thrown away, this is curtailment.

### Marginal Carbon Intensity

If you suddenly need to access more power - for example, you need to turn on a light - that energy comes from the marginal power plant. The marginal power plant is dispatchable, which means marginal power plants are often powered by fossil fuels.

Marginal carbon intensity is the carbon intensity of the power plant that would have to be employed to meet any new demand.

- Fossil-fueled power plants rarely scale down to 0. They have a minimum functioning threshold, and some don't scale; they are considered a consistent, always-on baseload.
  - Because of this, we sometimes have the scenario where we curtail (throw away) renewable energy while still consuming energy from fossil fuel power plants.

In these situations, the marginal carbon intensity will be 0 gCO2eq/kWh since we know that any new demand will match the renewable energy we are curtailing.

### Energy Markets

The exact market model varies around the world but broadly follows the same model.

When the demand for electricity goes down, utilities need to reduce the supply to balance supply and demand. They can do this in one of two ways:

1. Buy less energy from fossil fuel plants.

Energy from fossil fuel plants is usually the most expensive so this is the preferred method. This directly translates to burning fewer fossil fuels.

1. Buy less energy from renewable sources.

Renewable sources are the cheapest, so they prefer not to do this. If a renewable source doesn't manage to sell all of its electricity, it has to throw the rest away.

Reducing the amount of electricity consumed in your applications can help decrease the energy's carbon intensity seeing as the first thing to be scaled back are fossil fuels.

When the demand for electricity goes up, utilities need to increase the supply to balance supply and demand. They can do this in one of two ways:

1. Buy more energy from renewable sources that are currently being curtailed.

If you are curtailing, it means you have excess energy you could dispatch. Renewable energy is already the cheapest, so curtailed renewable energy will be the cheapest dispatchable energy source. Renewable plants will then sell the energy they would have had to curtail.

1. Buy more energy from fossil fuel plants.

- Fossil fuels are inherently dispatchable; they can quickly increase energy production by burning more. However, coal costs money, so this is the least preferred solution.

- Energy markets are some of the most complex markets in the world so the above explanation is a simplification. But what's important to understand is that our goal is to increase investment into lower carbon energy sources, like renewables, and decrease investment into higher carbon sources, like coal.
- The best way to ensure money flows in the right direction is to make sure you use electricity with the least carbon intensity.

## Carbon Awareness Tips

- In general, it's advised to use electricity when the carbon intensity is low, as this ensures investment flows towards low-carbon emitting plants and away from high-carbon emitting plants.
- Carbon intensity is lower when more energy comes from lower-carbon sources and higher when it comes from higher-carbon sources.

## Demand Shifting

- Being carbon aware means responding to shifts in carbon intensity by increasing or decreasing your demand.
- If your work allows you to be flexible with when and where you run workloads, you can shift accordingly - consuming electricity when the carbon intensity is lower and pausing production when it is higher.
- For example, training a Machine Learning model at a different time or region with much lower carbon intensity.

Studies show these actions can result in 45% to 99% carbon reductions depending on the number of renewables powering the grid.

Demand shifting can be further broken down into spatial and temporal shifting.

## Spatial Shifting

Spatial shifting means moving your computation to another physical location where the current carbon intensity is lower. It might be a region that naturally has lower carbon sources of energy. For example, moving to different hemispheres depending on the season for more sunlight hours.

## Temporal Shifting

- If you can't shift your computation spatially to another region, another option you have is to shift to another time. Perhaps later in the day or night when it's sunnier or windier and, therefore, the carbon intensity is lower.
  - This is called temporal demand shifting. We can predict future carbon intensity reasonably well through advances in weather forecasting.

Some of the biggest technology companies have recognized the importance of carbon awareness and are using advanced modeling techniques to implement demand shifting.

- Google Carbon Aware Data Centers - Google launched a project to make some of the cloud workloads carbon aware.
- They created models to predict tomorrow's carbon intensity and workload. They then shaped large-scale workloads so more would happen when and where the carbon intensity is lowest, but in such a way that they could still handle the expected load.
Microsoft Carbon Aware Windows - Microsoft announced a project to make Windows 11 more sustainable. Initially, this means running Windows updates when the carbon intensity is lower.

## Demand Shaping

Demand shifting is the strategy of moving computation to regions or times when the carbon intensity is lowest. Demand shaping is a similar strategy. However, instead of moving demand to a different region or time, we shape our computation to match the existing supply.

- If carbon intensity is low, increase the demand; do more in your applications.
- If carbon intensity is high, decrease demand; do less in your applications.

Demand shaping for carbon-aware applications is all about the supply of carbon. When the carbon cost of running your application becomes high, shape the demand to match the supply of carbon. This can happen automatically, or the user can make a choice.

- Eco mode is an example of demand shifting. Eco modes are found in everyday appliances like cars or washing machines. When activated, some amount of performance is sacrificed in order to consume fewer resources (gas or electricity).
  - Because there is this trade-off with performance, eco modes are always presented to a user as a choice.

Software applications can also have eco modes that can - either automatically or with user consent - make decisions to reduce carbon emissions.

One example of this is video conferencing software that adjusts streaming quality automatically. Rather than streaming at the highest quality possible at all times, it reduces the video quality to prioritize audio when the bandwidth is low.

Another example is TCP/IP. The transfer speed increases in response to how much data is broadcast over the wire.

A third example is progressive enhancement with the web. The web experience improves depending on the resources and bandwidth available on the end user’s device.

Demand shaping is related to a broader concept in sustainability, which is to reduce consumption. We can achieve a lot by becoming more efficient with resources, but we also need to consume less at some point.

As Green Software practitioners, we would consider canceling a process when the carbon intensity is high instead of demand shifting - reducing the demands of our application and the expectations of our end users.

##  Summary

Carbon awareness means understanding that the energy you consume does not always have the same impact in terms of carbon intensity.
Carbon intensity varies depending on the time and place it is consumed.
The nature of fossil fuels and renewable energy sources means that consuming energy when carbon intensity is low increases the demand for renewable energy sources and increases the percentage of renewable energy in the supply.
Demand shifting means moving your energy consumption to different locations or times of days where the carbon intensity is lower.
Demand shaping means adapting your energy consumption around carbon intensity variability in order to consume more in periods of low intensity and less in periods of high intensity.
