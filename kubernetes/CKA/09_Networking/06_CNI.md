# 3.6 - Prerequisite: CNI

- A single program encompassing all the steps required to setup a particular network
type, for example `bridge add <container ns> /path/`
- CNI Defines a set of standards that define how programs should be developed to
solve and perform network operations with containers
- Any variants developed in line with the CNI are plugins
- Docker doesn't use CNI, instead adopting CNM (container network model)
  - Can't use certain CNI plugins with Docker instantly, instead would have to
create a none network container, then manually configure CNI features
