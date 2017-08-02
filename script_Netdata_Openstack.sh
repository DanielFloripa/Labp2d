#!/bin/bash

IP_NOVA='http://10.10.20.91:30000'
FILE_OUTPUT='TesteNetData.log'


## Dar um awk para pegar o "ID da VM" e o "IP público"
SERVER_ID=`openstack server list --format=value | awk '{print $1}'`
SERVER_NAME=`openstack server list --format=value | awk '{print $2}'`
SERVER_PUB_IP=`openstack server list --format=value | awk '{print $5}'`
echo "O ID da MV '$SERVER_NAME' é: $SERVER_ID, e está disponivel em: $SERVER_PUB_IP"

eval "(openstack server show $SERVER_ID --format=shell)"
set | grep "^NETDATA_CGROUP_MACHINE_INSTANCE_$ID_QEMU"

## OBS: Usar um filtro para remover a variável antes de '...=instance-'
#ID_QEMU=`set | grep "^os_ext_srv_attr_instance_name"`
#NODE=`set | grep "^os_ext_srv_attr_hypervisor_hostname"`

# OU MELHOR:
ID_QEMU=`echo $os_ext_srv_attr_instance_name | cut -d "-" -f 2`
NODE=`echo $os_ext_srv_attr_hypervisor_hostname | cut -d "-" -f 2`

## Pegando dados API do NetData:
eval "$(curl -s '$IP_NOVA/host/$NODE/api/v1/allmetrics')"
set | grep "^NETDATA_CGROUP_MACHINE_INSTANCE_$ID_QEMU"

# Agora é só imprimir os valores das variaveis que interessam em um arquivo

INI="NETDATA_CGROUP_MACHINE_INSTANCE_${ID_QEMU}_LIBVIRT_QEMU_"

ARRAY_V=(
	CPU_PER_CORE_CPU0
	CPU_PER_CORE_CPU1
	CPU_PER_CORE_CPU2
	CPU_PER_CORE_CPU3
	CPU_PER_CORE_VISIBLETOTAL
	CPU_SYSTEM
	CPU_USER
	CPU_VISIBLETOTAL
	MEM_ACTIVITY_PGPGIN
	MEM_ACTIVITY_PGPGOUT
	MEM_ACTIVITY_VISIBLETOTAL
	MEM_CACHE
	MEM_MAPPED_FILE
	MEM_RSS
	MEM_RSS_HUGE
	MEM_USAGE_RAM
	MEM_USAGE_SWAP
	MEM_USAGE_VISIBLETOTAL
	MEM_VISIBLETOTAL
	PGFAULTS_PGFAULT
	PGFAULTS_PGMAJFAULT
	PGFAULTS_VISIBLETOTAL
	THROTTLE_IO_READ
	THROTTLE_IO_VISIBLETOTAL
	THROTTLE_IO_WRITE
	THROTTLE_SERVICED_OPS_READ
	THROTTLE_SERVICED_OPS_VISIBLETOTAL
	THROTTLE_SERVICED_OPS_WRITE
	WRITEBACK_DIRTY
	WRITEBACK_VISIBLETOTAL
	WRITEBACK_WRITEBACK)
	
	
for i in `seq 1 30`;
do
	ASD=$INI${ARRAY_V[$i]}
	echo -n "${!ASD}; " >> $FILE_OUTPUT
done
echo "" >> $FILE_OUTPUT
        
