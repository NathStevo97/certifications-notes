# 2.19 - Imperative vs Declarative Commands

- Imperative: The use of statements to change a programs state, give a program
step-by-step instructions on how to perform a task, specify the "how" to get to the
"what"
- Declarative: Writing a program describing an operation by specifying only the end
goal, specify the "what" only
- In Kubernetes, this split in programming language can be broken down as:
  - Imperative - Using kubectl commands to perform CRUD operations like
scaling and updating images, as well as operations with .yaml definition files.
■ These commands specify the exact commands and how they should
be performed.
  - Declarative:
■ Using kubectl apply commands with definition files, Kubernetes will
consider the information provided and determine what changes need
to be made
- Imperative commands in kubernetes include:
  - Creation
■ Run
■ Create
■ Expose
  - Update Objects
■ Edit
■ Scale
■ Set (image)
- It should be noted that Imperative commands are often "one-time-use" and are
limited in functionality, for advanced operations it's better to work with definition
files, and that's where using the `-f <filename>` commands are better-used.
- Imperative commands can become taxing as they require prior knowledge of
pre-existing configurations, which can result in extensive troubleshooting if
unfamiliar.
- For the declarative approach, it's more recommended to use this when making
extensive changes or updates without having to worry about manual
troubleshooting or management.