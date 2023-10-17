# 5.9 - Multi-Container Pod Design Patterns

- 3 Design patterns available:
  1. Sidecar
  2. Adapter
  3. Ambassador

![Multi-Container Pod Designs](./img/multi-container-pod-design.png)

### Sidecar

- The most common design pattern
- Uses a "helper" container to assist or improve the functionalut of a primary container
- Example: Log agent with a web server

### Adapter

- Used to assist in standardising communications between resources
  - Processes that transmit data e.g. logs will be formatted in the same manner
  - All data stored in centralised location

### Ambassador

- Responsible for handling proxy for other parts of the system or services
- Used when wanting microservices to interact with one another
- Services to be identified by name only via service discovery such as DNS or at an application level.

---

- Whilst the design patterns differ, their implementation is the same, adding containers to the pod definition file spec where required,
