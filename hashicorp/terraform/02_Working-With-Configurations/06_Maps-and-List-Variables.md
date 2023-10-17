# 2.6 - Fetching Data from Maps and Lists in Variables

- When working with lists in terraform, sometimes you wish to reference a particular value from that list, rather than include all the values.
- When referencing items from a map, follow the format: `var.map_id["map_key"]`
- When referencing items from a list: `var.list_id[list_position]`
- List positions ALWAYS start from [0].
