# 7.6 - View Certificate Details

- The generation of certificates depends on the cluster setup
  - If setup manually, all certificates would have to be generated manually in a
similar manner to that of the previous sections
■ Components deployed as native services in this manner
  - If setup using a tool such as kubeadm, this is all pre-generated
■ Components deployed as pods in this manner
- For Kubeadm clusters:
  - Component found in `/etc/kubernetes/manifests/` folder
■ Certificate file paths located within component's yaml files
■ Example: apiserver.crt
■ Use `openssl x509 -in /path/to/.crt` file -text -noout
  - Can check the certificate details such as name, alternate names, issuer and
expiration dates
- Note: Additional details available in the documentation for certificates
- Use `kubectl logs <podname>` on kubeadm if any issues are found with the
components
- If kubectl is unavailable, use Docker to get the logs of the associated container:
  - Run `docker ps - a` to identify the container ID
  - View the logs via `docker logs <container ID>`
