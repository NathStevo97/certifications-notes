# 9.13 - Custom Controllers

- Controllers are any process or code that continuously monitors clusters for events associated with a specific type of Kubernetes objects, and can respond accordingly to said events to ensure the desired state determined by the ETCD database is maintained in the cluster.
- Kubernetes provides a base sample-controller repository to start off with.
- Most controllers are written in `Go`, so `controller.go` (or appropriate) is edited accordingly with the desired logic.
- The controller can be built by `go build -o <controller name> .`
- The controller can then be ran and pointed to the desired kubeconfig: `./<go executable> -kubeconfig=/path/to/kubeconfig`

- You may also package the controller as a Go Docker image and run it within the Kubernetes cluster as a pod.
- Expected questions in the exam may include defining a custom resource definition and WORKING WITH custom controllers.
