# 2.02 - Installation of HashiCorp Vault

Complete: Yes
Flash Cards: Yes
Lab: Yes
Read: Yes
Status: Complete
Watch: Yes
You done?: 🔥🔥🔥🔥

# Notes

- Vault is available on all major operating systems and can also be installed on platforms such as Kubernetes clusters.

## Windows:

- Download and extract binary file from [https://www.vaultproject.io/downloads](https://www.vaultproject.io/downloads)
- Or use package managers such as Chocolatey:

```powershell
choco install vault
```

- Verify the installation:

```powershell
vault
```

- Ensure Vault’s location is added to the PATH env variable.

---

## Linux

- [https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started)

### Ubuntu

- Add the HashiCorp [GPG key](https://apt.releases.hashicorp.com/gpg)

```bash
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
```

- Add the official HashiCorp Linux repository - replace arch=<> as appropriate (confirm via `arch`

```bash
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
```

- Update and Install

```bash
sudo apt-get update && sudo apt-get install vault
```

- Again, ensure it is in $PATH if installing manually

```bash
echo $PATH
mv <vault binary> $PATH
```

---

## MacOS

[https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started](https://learn.hashicorp.com/tutorials/vault/getting-started-install?in=vault/getting-started)