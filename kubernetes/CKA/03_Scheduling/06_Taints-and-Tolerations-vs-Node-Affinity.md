# 3.6 - Taints and Tolerations vs Node Affinity

- Consider a 5-cluster setup:
  - Blue Node: Runs the blue pod
  - Red Node: Runs the red pod
  - Green Node: runs the green pod
  - Node 1: To run the grey pod
  - Node 2: " "

- Applying a taint ot each of the coloured nodes to accept their respective pod
  - Tolerances are then are applied to the pods

- Need to apply a taint to node 1 and node 2 as the coloured pods can still be allocated to nodes where they're not wanted.

- To overcome, use Node Affinity:
  - Label nodes with respective colours
  - Pods end up in the correct nodes via use of Node Selector.

- There's a chance that the unwanted pods could still be allocated.

- A combination of taints and tolerations, and node affinity must be used.
  - Apply taints and tolerations to present unwanted pod placement on nodes
  - Use node affinity to prevent the correct pods from being placed on incorrect nodes.