# 1.1 - The VMWare Tanzu Portfolio

Tags: Done

# Introduction and Background

- Kubernetes is a key technology in VMWare's Tanzu Portfolio
- Tanzu Kubernetes grid is the common implementation of Kubernetes across supported cloud platforms e.g. Azure, AWS, vSphere.

# Objectives

- Describe the VMWare Tanzu Portfolio

# VMWare Tanzu Portfolio

- The VMware Tanzu portfolio aims to provide a modern applications platform.
- In doing so, the following operations can be carried out:
    - Build
    - Run
    - Manage
- Each of these operations is handled or  facilitated by a particular Tanzu-based service.

    ![Untitled](1%201%20-%20The%20VMWare%20Tanzu%20Portfolio%20e1b5aa100da049798a200acb4bf5420f/Untitled.png)

    - Typically, the services under RUN and Manage are handled by SRE, those in Build are primarily handled by Developers

# Kubernetes Lifecycle Management

- The focus of the course will be on the following:
    - Run:
        - VMWare Tanzu Kubernetes Grid
        - VMware vSphere with Tanzu
        - VMware Tanzu Kubernetes Grid Integrated Edition
    - Manage
        - VMWare Tanzu Mission Control (works in conjunction with the above)

## Tanzu Kubernetes Grid

- A multicloud Kubernetes distribution that can run on:
    - vSphere, VMWare Cloud on AWS, Azure VMware Solution (any vSphere-based solution)
    - AWS (in an EC2 instance)
    - Microsoft Azure
- Aims to automate the lifecycle management of multiple Tanzu Kubernetes clusters using **Cluster API**
- An open-source Kubernetes distribution
- Includes tested, signed Kubernetes binaries supported by VMWare
- Includes signed and supported versions of open-source apps to support the following operations in a production Kubernetes environment:
    - networking
    - authentication
    - ingress
    - logging
    - monitoring

## vSphere with Tanzu

- Provides a Kubernetes experience that only runs on vSphere 7 - a tight integration
- Contains multiple services which provide access to infrastructure via a Kubernetes API
- Contains the Tanzu Kubernetes Grid service
    - Runs on supervisor vSphere with Tanzu
    - Creates Tanzu Kubernetes clusters optimized for vSphere

## Tanzu Kubernetes Grid Integrated Edition

- A multicloud Kubernetes distribution that runs on the same platforms as Tanzu Kubernetes Grid
- Previously known as VMware Enterprise PKS
- Automates the lifecycle management of multiple Kubernetes clusters using BOSH
- Includes Kubernetes binaries that are tested, signed, and supported by VMware
- Provides advanced networking with VMWare NSX-T Data Center
- Provides integrations to vRealize Log Insight, vRealize Operations and Tanzu Observability
- Supports Microsoft Windows workloads

## VMware Tanzu Mission Control

- Provides a centralized management platform for operating and securing multiple Kubernetes clusters and applications across multiple teams and cloud environments.
- Available via VMware cloud services
- Provides a hosted Tanzu Kubernetes Grid implementation as a managed service.

---

# VMware Tanzu Editions

- Tanzu editions are groupings of the VMware Tanzu products that are designed for organizations at different stages of Kubernetes Adoption:
    - Basic - Run Kubernetes in vSphere
    - Standard - Run and manage Kubernetes across multiple clouds
    - Advanced - Simplify and secure the container lifecycle at scale and enhance app delivery.

![Untitled](1%201%20-%20The%20VMWare%20Tanzu%20Portfolio%20e1b5aa100da049798a200acb4bf5420f/Untitled%201.png)