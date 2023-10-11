# 2.7 - Count and Count Index

- The count parameter on resources can simplify configurations and allow easier scalability of configurations.
- Commonly, if wanting to create a small number of the same resource, e.g. 2 identical instances, one could define them as separate instances, however this is not sustainable.
- The Terraform function `count` can be used to save code space by adding `count = value`
- In resource blocks where count is set, an additional count object is available in expressions,
so each instance's configurations can still be modified.
- This object has just one attribute: `count.index`, which starts with 0 for the first instance and continues like a list index.
  - This is commonly used for altering properties such as the name.

- When wanting to utilize the count index, append `.count.index` to the chosen property.

- Example application to create 3 virtual machines:
  - `machine_instance.0` -> count = 1
  - `machine_instance.1` -> count = 2
  - `machine_instance_2` -> count = 3

- The above isn't a common practice, usually resources are configured for different environments like staging, development, etc.
  - Count can still be utilized for this, but it'll reference positions in a list instead.
  - This can be done in a similar manner to `var.<variable>[count_index]` - which will look iteratively through the list and apply each desired entry.
  