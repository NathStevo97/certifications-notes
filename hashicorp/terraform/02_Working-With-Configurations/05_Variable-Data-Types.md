# 2.5 - Data Types

- When defining a variable, it's good practice to define its data type during implementation; preventing errors by invalid data.

## 2.5.1 - Example

- Consider a company where every employee has a particular identification number, if that employee wanted to create a form of infrastructure, it should be done with that number
only.
- So in variables.tf, the variable `instance_name` should be of type number.

- Suppose that in the terraform.tfvars the value for instance_name is set to a value that isn't of that data type/the data type also isn't specified, eg. john-123; what will happen?
    - This value will not be accepted and the plan will fail.

## 2.5.2 - Data Types Overview

- To specify a variable's data type, simply add the type in the variable within `variables.tf` in the form `type = type`.
- Key types used include:
    - String: A set of unicode characters representing text
    - List: A sequential list of values identified by position within the list, position starting with 0 e.g. `["London", "Paris", "Helsinki"]
    - Map: A group of values categorised by labels e.g. {name = "Joe", age = 23}
        - This can contain multiple data types
    - Number: Numerical values

- By defining data types in `variables.tf`, users can use this as a reference point when defining variables in the `.tfvars` file.
- In some cases, if a variable type isn't specified, errors will arise as the program will assume a different type is expected.