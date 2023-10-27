# 3.11 - API Versions & Deprecations

## API Versions

- Each API group has its own version.
- At `/v1`, the API group is in it's "General Availability" or "stable" version. Other versions are possible, a summary follows:

|              | Alpha                                               | Beta                                                       | GA (Stable)                                    |
|--------------|-----------------------------------------------------|------------------------------------------------------------|------------------------------------------------|
| Version Name | `vXalphaY`                                          | `vXbetaY`                                                  | `vX`                                           |
| Enabled      | No, enabled via flags                               | Yes, by default                                            | Yes, by default                                |
| Tests        | May lack E2E Tests                                  | E2E Tests                                                  | Conformance Tests                              |
| Reliability  | May have bugs                                       | May have minor bugs                                        | Highly Reliable                                |
| Support      | No committment, may be dropped                      | Commits defined to complete the feature and progress to GA | Expected to be present in many future releases |
| Audience     | Expert users interested in providing early feedback | Users interested in beta testing and providing feedback    | All users                                      |

- **Note:** An API Group can support multiple versions at the same time e.g. you could create the same Deployment using `apps/v1beta` and `apps/v1`, but only one can be the preferred version.
- The preferred version is the `apiVersion` that is queried via `kubectl` commands and converted to for storage in the ETCD server.
- A preferred version is listed when viewing the `APIGroup` under `preferredVersion`.
- There is no way to see the `storageVersion` easily, except for querying the `ETCD` database directly.
- APIGroups that are enabled / disabled can be controlled by the flags for the `kube-apiserver` via the `--runtime-config=<api version>` flag in a comma-separated list.

## API Deprecations

- A single API group can support multiple versions at the same time, but some versions may need to be shelved / have support dropped.
- There are rules put in place by Kubernetes' community to manage this, the **API Deprecation Policy**, some rules to highlight follow:

### Rule 1

- API Elements may only be removed by incrementing the version of the API group.
- In an example scenario, suppose for a given API Group you have 2 components released as part of `v1alpha1`, component B proved unusable / unnecessary etc and was deemed suitable for removal.
  - Component B cannot just be removed from `v1alpha1`, it may only be removed by removing it from `v1alpha2`, the next incremental version.
  - In this scenario, YAML files would need to be changed to the new version, but the new release would need to support both versions.
  - The preferred version could still be set to `v1alpha2` only.

### Rule 2

- API objects must be able to round-trip between API versions in a given release without information loss, with the exception of whole REST resources that do not exist in some versions.
- Suppose a new field was added to a component in `v1alpha2`, an equivalent field must be added to `v1alpha1` should the user convert back to the older API Version from the newer version.

### Rule 4a

- As development progresses towards GA, older versions such as `v1alpha1` will need to be dropped.
- Suppose `v1alpha1` was first included with version `X` of Kubernetes, then `v1alpha2` in `X+1`, etc, what happens to `v1alpha1`?
- In the alpha phase there is no requirement to maintain support for a past release. Similar rules apply for `Beta` and `GA`.
- **Rule 4a:** *Other than the most recent API Versions in each track, older API versions must be supported after their announced deprecation for a duration of no less than:*
  - **GA:** *12 months or 3 releases (whichever is longer)*
  - **Beta:** *9 months or 3 releases (whichever is longer)*
  - **Alpha:** *0 Releases*

- These deprecations must be mentioned in changelogs for each version update.
- Similarly to above, when API version `v1beta1` is released with Kubernetes `X+2`, there is no requirement to keep the `v1alpha2` version support.
- `v1beta1` must then stay supported for 3 Kubernetes releases (with a note on deprecation) when `v1beta2` is released in `X+3`.
- The preferred or storage version cannot change until Kubernetes `X+4` This is due to Rule 4b.

### Rule 4b

- *The preferred API version and the storage version for a given group may not advance until after a release has been made that supports both the new version and the previous version*

### Rule 3

- An API Version in a given track may not be deprecated until a new API Version at least as stable is released.
- This means that GA can deprecate another GA version and Beta versions, Beta for other betas and alpha versions, etc.

---

## Kubectl Convert

- When clusters are upgraded, this is often packed with APIversion changes. Managing these changes can be very tedious for large amounts of manifest files.
- This process can be expedited by the `kubectl convert` plugin. Once installed, run `kubectl convert -f <old-file> --output-version <new api version>`
  - Example: `kubectl convert -f <deployment.yaml> --output-version apps/v1`
- The plugin may not be installed by default, however it can be installed via instructions in the Kubernetes documentation.
