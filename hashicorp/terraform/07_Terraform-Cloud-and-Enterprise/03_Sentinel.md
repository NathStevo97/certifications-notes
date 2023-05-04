# 7.3 - Sentinel

- An embedded policy-as-code framework integrated with the products provided by Hashicorp.
- Allows fine-grained, logic-based policy decisions, which can be extended to use info from external sources.
- A paid feature of Terraform.
- Carries out policy checks during `plan` and `apply` invocations.

- As an example:
  - A policy may be put in place for EC2 instances e.g. "forbid creation if no tags are set"
  - This policy would be attached to a policy set, which would then be applied to a workspace.

- To create a policy set:
  1. Settings -> Policy Set -> Connect a Policy Set
  2. Configure VCS Connection as Required
  3. Configure Settings for policy and what workspace(s) to apply the policy to.

- To create the policy:
  1. Settings -> Policies -> Create Policy
  1. Add policy where required.
  1. Set enforcement mode.
        1. Hard-Mandatory: Cannot Override
        1. Soft-Mandatory: Can be Overrode
        1. Advisory: For logging purposes
  1. Add policy code (see Terraform Documentation)
  1. Associate the policy with a policy set

- Now when a plan is queued, the policies will be checked to see if the `apply` can be ran, displaying the results as logs in the UI.

- Example Policy:
```go
import "tfplan"


main = rule {
    all tfplan.resources.aws_instance as _, instances {
        all instances as _, r {
            (length(r.applied.tags) else 0) > 0
        }
    }
}
```