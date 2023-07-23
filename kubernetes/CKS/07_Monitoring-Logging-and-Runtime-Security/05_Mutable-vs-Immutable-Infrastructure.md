# 7.5 - Mutable vs Immutable Infrastructure

- Software upgrades can be done via manual methods or using configuration tools such as custom scripts or configuration managers like ansible
- In high-availability setups, could apply the same update approach to each server
running the software - in-place updates
  - Configuration remains the same, but the software has changed
  - This leads to mutable infrastructure
- If the upgrade fails for a particular server due to dependency issues like network or files, a configuration drift can occur - each server behaves slightly differently to one another.
- To workaround, can just spin up new servers with the new updated software and delete the old servers upon successful updates
  - This is the idea behind immutable infrastructure - Unchanged infrastructure
- Immutability is one of the primary thoughts on containers
  - As they are made using images, any changes e.g. version updates should be applied to an image first, then that image is used to create new containers via rolling updates
  - **Note:** containers can be changed during runtime e.g. copying files to and
from containers - this is not in line with security best practices