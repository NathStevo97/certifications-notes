# 8.0 - Templating - Jinja2

- [8.0 - Templating - Jinja2](#80---templating---jinja2)
  - [8.1 - Introduction](#81---introduction)
    - [String Manipulation - Filters](#string-manipulation---filters)
    - [Filters - List and Set](#filters---list-and-set)
    - [Filters - File](#filters---file)

## 8.1 - Introduction

- Templating = Using variable substitution e.g. `{{ name }}` for variable `name`
- Jinja2 Templating defined by either `{{ }}` or `{% %}`
- Jinja = Templating language designed for Python.

### String Manipulation - Filters

- Make string substitute uppercase: `{{ var name | upper }}`
- Lowercase: `{{ var name | upper }}`
- Title Case: `{{ var name | title }}`
- Replace with a  given value `{{ var name | replace("<Original Value>", "<Replacing Value>" }}`
- Use defaults:  `{{ var name | default("<Default Value>") }}`

### Filters - List and Set

- When working with lists and sets:
- Get minimum: `{{ [1,2,3] | min }}`
- Get maximum: `{{ [1,2,3] | max }}`
- Get unique values: `{{ [1,2,3] | unique }}`
- Get unique values across multiple arrays: `{{ [1,2,3,4] | union( [4,5] ) }}`
- Find common values across multiple arrays `{{ [1,2,3,4] | intersect( [4,5] ) }}`
- Get a random number: `{{ 100 | random }}`
- Join an array of strings: `{{ "word1", "word2", "word3", "word4" | join(" ") }}`

### Filters - File

- Get file basename:
  - Windows hosts: `{{ "/path/to/file" | win_basename }}`
  - Linux Hosts `{{ "/path/to/file" | basename }}`
- Get the drive letter from a path `{{ "/path/to/file" | win_splitdrive }}`
  - Returns an array with the first entry being the drive letter, to isolate it, add an extra pipe `| first`
  - For the last filter: `| last`

- Many more filters are available at [jinja.pcoo.org/docs](http://jinja.pcoo.org/docs)
- Additional guidance also available in the Ansible documentation.
