# GaleraCluster-Integrity

This bash script will check the most important and necessary variables from galera cluster 

variables that will be monitored:
* wsrep_local_send_queue
* wsrep_local_recv_queue
* wsrep_local_state_comment
* wsrep_cluster_size
* wsrep_ready

I have used the zabbix client to fire the trigger, but you can use an webhook, just add the curl inside the function AlertNow().

Enjoy!
