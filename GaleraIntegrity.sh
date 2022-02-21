#!/bin/bash
#
#
# Igor Andrade - 18/02/2022
# HostGator - TechOps LatAm
# Galera Cluster check integrity using wsrep variables
#
#
#

#############################################################################################
#																							                                              #
#					CHANGABLE VARS, ADJUST ACCOURDING YOUR CLUSTER						                      	#
#																						                                              	#
#############################################################################################


# CHANGABLE:
send_queue=1000  # send queue in seconds
recv_queue=1000  # received queue in seconds
state="Synced"   # status of the cluster, Synced status is health status of the cluster
sizecluster=3    # Size of your cluster, in this case i will use 3
StatusReady="ON" # And Always should be ON

#############################################################################################
#																						                                              	#
#								DONT CHANGE ANYTHING BELOW								                                 	#
#																							                                              #
#############################################################################################

#Constant Vars
wsrep_local_send_queue=$(mysql -e "show status like 'wsrep%';" | egrep "(wsrep_ready|wsrep_cluster_size|wsrep_local_send_queue|wsrep_local_state_comment|wsrep_local_recv_queue)" | egrep -v "(_max|_min|_avg)" | awk {'print $2'} | sed -n '1p')
wsrep_local_recv_queue=$(mysql -e "show status like 'wsrep%';" | egrep "(wsrep_ready|wsrep_cluster_size|wsrep_local_send_queue|wsrep_local_state_comment|wsrep_local_recv_queue)" | egrep -v "(_max|_min|_avg)" | awk {'print $2'} | sed -n '2p')
wsrep_local_state_comment=$(mysql -e "show status like 'wsrep%';" | egrep "(wsrep_ready|wsrep_cluster_size|wsrep_local_send_queue|wsrep_local_state_comment|wsrep_local_recv_queue)" | egrep -v "(_max|_min|_avg)" | awk {'print $2'} | sed -n '3p')
wsrep_cluster_size=$(mysql -e "show status like 'wsrep%';" | egrep "(wsrep_ready|wsrep_cluster_size|wsrep_local_send_queue|wsrep_local_state_comment|wsrep_local_recv_queue)" | egrep -v "(_max|_min|_avg)" | awk {'print $2'} | sed -n '4p')
wsrep_ready=$(mysql -e "show status like 'wsrep%';" | egrep "(wsrep_ready|wsrep_cluster_size|wsrep_local_send_queue|wsrep_local_state_comment|wsrep_local_recv_queue)" | egrep -v "(_max|_min|_avg)" | awk {'print $2'} | sed -n '5p')

alertNow(){
zabbixclient=$(hostname)
/usr/bin/zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -s $zabbixclient -k galera_behaviour.status -o $returns
}

AllinOne(){
if [ $wsrep_local_send_queue -ge $send_queue ] || [ $wsrep_local_recv_queue -ge $recv_queue ] || [ $wsrep_local_state_comment != $state ] || [ $wsrep_cluster_size -ne $sizecluster ] || [ $wsrep_ready != $StatusReady ]; then
	echo -e "Any of galera variables are with issues...Alerting now"
	returns=0
	alertNow
else
	echo -e "All OK"
	returns=1
	alertNow
fi
}

AllinOne
