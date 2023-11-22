# 5.2 - Hardware Efficiency

## Improving Hardware Efficiency

- If we take into account the embodied carbon, it is clear that by the time we come to buy a computer, it's already emitted a good deal of carbon. Computers also have a limited lifespan, which means they eventually are unable to handle modern workloads and need to be replaced.
  - In these terms, hardware is a proxy for carbon, and since our goal is to be carbon efficient, we must also be hardware efficient.

There are two main approaches to hardware efficiency:

For end-user devices, it's extending the lifespan of the hardware.
For cloud computing, it's increasing the utilization of the device.

### Extending the Lifespan of Hardware

In the example we saw previously, if we can add just one more year to the lifespan of our server, then the amortized carbon drops from 1000kg CO2eq/year to 800kg CO2eq/year.

Hardware is retired when it breaks down or struggles to handle modern workloads. Of course, hardware will always break down eventually but, as developers, we can use software to build applications that run on older hardware and extend their lifetime.

### Increasing Device Utilization

- In the cloud space, hardware efficiency most often translates to an increase in the utilization of servers. It's better to use one server at 100% utilization than 5 servers at 20% utilization because of the cost of embodied carbon.
  - In the same way that owning one car and using it every day of the week is much better than owning five and using a different one each day of the week, it is much more efficient to use servers at their full capacity rather than employing several at below capacity.
  - Although emissions are the same, the embodied carbon that is used is much lower.

- The most common reason for having under-utilized servers is so that peak capacity is accounted for. Running servers at 20% means that you know you will be able to handle peaks in demand without impacting performance.
  - However, in the meantime, all that spare capacity just sitting there idle represents wasted embodied carbon.
  - Being hardware efficient means making sure that every hardware device is being utilized as much as possible for as long as possible.

- This is one of the main advantages of the public cloud; you know that when you do need to scale up, the space will be there to take up the slack.
- With multiple organizations making use of the public cloud, spare capacity can always be made available to whoever needs it, so that no servers are sitting idle.

It's important to note that simply moving operations to the public cloud will not automatically reduce your emissions. It simply gives you the space to be able to re-architect your software so that a reduction is possible.

## Summary

Embodied carbon is the amount of carbon pollution emitted during the creation and disposal of a device.
When calculating your total carbon pollution, you must consider both that which is emitted when running the computer as well as the embodied carbon associated with its creation and disposal.
Extending the lifetime of a device has the effect of amortizing the carbon emitted so that its CO2eq/year is reduced.
Cloud computing is more energy efficient then an on-premise server as it can apply demand shifting as well as demand shaping.
