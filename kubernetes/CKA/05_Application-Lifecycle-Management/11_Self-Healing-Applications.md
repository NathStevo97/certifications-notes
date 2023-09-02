# 5.11 - Self-Healing Applications

- Self-healing applications are supported through the use of ReplicaSets and
Replication Controllers
- ReplicationControllers help in ensuring a pod is recreated automatically when the
application within crashes; thus ensuring enough replicas of the application are
running at all times
- Additional support to check the health of applications running within pods and take
necessary actions when they're unhealthy, this is done through Readiness and
Liveness Probes.
- For more information, see section 5.0-5.2 of the written CKAD notes