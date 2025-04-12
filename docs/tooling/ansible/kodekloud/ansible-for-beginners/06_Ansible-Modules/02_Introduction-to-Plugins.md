# 6.2 - Introduction to Plugins

## Overview

- Ansible plugins aim to provide additional functionality and customisation options beyond the core features.
- Plugins extend or modify the core functionality of ansible, such as inventory, modules, and callbacks.
- Plugins can be found as any of:
  - Inventory Plugins (e.g. Dynamic Inventory)
  - Module Plugins (e.g. provision custom cloud configuration)
  - Action Plugins (e.g. define a series of high-level tasks to help enhance consistency in the configuration)
  - Callback Plugins - provide hooks into ansible's execution lifecycle, facilitating custom actions during playbook execution.
  - Lookup Plugins (typically used with Databases)
  - Filter Plugins
  - Connection Plugins
- Each plugin comes with their own parameters and configuration.
