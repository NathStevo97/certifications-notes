# 5.5 - Open Policy Agent (OPA)

- Consider a user logging into a web server, there are typically multiple steps for
logging in:
  - Authentication - Checking identity
  - Authorization - Checking / restricting
- OPA exists to handle authorization requests / verification.
- Without OPA, any time a new service will be deployed, one will have to manually
configure all the routes and authorization mechanisms / policies between it and the
other services => VERY TEDIOUS!
- In practice, OPA is deployed within the environment and policies are configured
within it.
  - When a service wants to make a request to another service, the request first
goes to OPA, which either allows or denies it.
- **Step 1:**
  - Download from Github
  - Execute from within directory: `./opa run -s`
- **Step 2: Load Policies**
  - Policies defined in .rego language (Example follows):

    ```rego
    package httpai.authz

    # HTTP API Request
    import input

    default allow = false

    allow {
        input.path == "home"
        input.user == "john"
    }
    ```

    - {} determines acceptance conditions
  - Once ready, can load the policy via curl to use a PUT request e.g.: `curl -X PUT --data-binary @example.rego http://localhost:8181/v1/policies/example1`
  - To view the list of existing policies: `curl http://localhost:8181/v1/policies`
- Policies can then be called within programs by making a post request to the API and passing the required input parameters -> If allow conditions are met, OPA allows the request, if not, rejected.
- **Note:** A guide on utilising the rego language is available via the documentation and a "playground" for policy testing
