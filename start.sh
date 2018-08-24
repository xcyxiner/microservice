#!/bin/bash

baseDstDirectory="tmp"

#主节点域名，IP，以及docker name
masterHost=ubuntu101
masterName=node101
masterIP="192.168.31.15"
masterSrcDirectory="master"
#占位符替换
masterIPPlaceholder="MASTERIP"
masterHostNamePlaceholder="MASTERHOSTNAME"
#主节点镜像下载脚本
masterDownloadFileName="masterDockerFile.sh"
masterSrcDownloadFile="$masterSrcDirectory/$masterDownloadFileName"
masterDstDownloadFile="/$baseDstDirectory/$masterDownloadFileName"
#主节点consul启动脚本
masterConsulFileName="masterConsul.sh"
masterSrcConsulFile="$masterSrcDirectory/$masterConsulFileName"
masterDstConsulFile="/$baseDstDirectory/$masterConsulFileName"
#主节点Swarm启动脚本
masterSwarmFileName="masterSwarm.sh"
masterSrcSwarmFile="$masterSrcDirectory/$masterSwarmFileName"
masterDstSwarmFile="/$baseDstDirectory/$masterSwarmFileName"
#主节点Shipyard启动脚本
masterShipyardFileName="masterShipyard.sh"
masterSrcShipyardFile="$masterSrcDirectory/$masterShipyardFileName"
masterDstShipyardFile="/$baseDstDirectory/$masterShipyardFileName"
#主节点registrator脚本
masterRegistratorFileName="masterRegistrator.sh"
masterSrcRegistratorFile="$masterSrcDirectory/$masterRegistratorFileName"
masterDstRegistratorFile="/$baseDstDirectory/$masterRegistratorFileName"
#主节点启动脚本
masterStartFileName="startMaster.sh"
masterSrcStartFile="$masterSrcDirectory/$masterStartFileName"
masterDstStartFile="/$baseDstDirectory/$masterStartFileName"
#主节点关闭脚本
masterStopFileName="stopMaster.sh"
masterSrcStopFile="$masterSrcDirectory/$masterStopFileName"
masterDstStopFile="/$baseDstDirectory/$masterStopFileName"

#其他节点域名，IP，以及docker name
clientHost=(ubuntu102 ubuntu103)
clientName=(node102 node103)
clientIp=("192.168.31.19" "192.168.31.99")
clientSrcDirectory="client"
#占位符替换
clientIPPlaceholder="CLIENTIP"
clientHostNamePlaceholder="CLIENTHOSTNAME"
#其他节点镜像下载脚本
clientDownloadFileName="clientDockerFile.sh"
clientSrcDownloadFile="$clientSrcDirectory/$clientDownloadFileName"
clientDstDownloadFile="/$baseDstDirectory/$clientDownloadFileName"
#其他节点consul启动脚本
clientConsulFileName="clientConsul.sh"
clientSrcConsulFile="$clientSrcDirectory/$clientConsulFileName"
clientDstConsulFile="/$baseDstDirectory/$clientConsulFileName"
#其他节点Swarm启动脚本
clientSwarmFileName="clientSwarm.sh"
clientSrcSwarmFile="$clientSrcDirectory/$clientSwarmFileName"
clientDstSwarmFile="/$baseDstDirectory/$clientSwarmFileName"
#其他节点registrator脚本
clientRegistratorFileName="clientRegistrator.sh"
clientSrcRegistratorFile="$clientSrcDirectory/$clientRegistratorFileName"
clientDstRegistratorFile="/$baseDstDirectory/$clientRegistratorFileName"
#其他节点启动脚本
clientStartFileName="startClient.sh"
clientSrcStartFile="$clientSrcDirectory/$clientStartFileName"
clientDstStartFile="/$baseDstDirectory/$clientStartFileName"
#其他节点关闭脚本
clientStopFileName="stopClient.sh"
clientSrcStopFile="$clientSrcDirectory/$clientStopFileName"
clientDstStopFile="/$baseDstDirectory/$clientStopFileName"


masterDockerPull(){
    #主节点下载镜像
    scp $masterSrcDownloadFile root@$masterHost:$masterDstDownloadFile
    ssh -t root@$masterHost "sh $masterDstDownloadFile"
}

clientDockerpull(){
#其他节点下载镜像
for tmpHost in ${clientHost[@]};do
    scp $clientSrcDownloadFile root@$tmpHost:$clientDstDownloadFile
    ssh -t root@$tmpHost "sh $clientDstDownloadFile"
done
}

masterStartConsul(){
#开启主节点consul服务
    scp $masterSrcConsulFile  root@$masterHost:$masterDstConsulFile
    ssh -t root@$masterHost "sed -i 's/$masterIPPlaceholder/$masterIP/g' $masterDstConsulFile"
    ssh -t root@$masterHost "sed -i 's/$masterHostNamePlaceholder/$masterName/g' $masterDstConsulFile"
    ssh -t root@$masterHost "cat $masterDstConsulFile"
}

clientStartConsul(){
#开启其他节点consul服务
    for ((i=0;i<${#clientHost[@]};i++));do
        tmpHost=${clientHost[$i]}
        tmpName=${clientName[$i]}
        tmpIp=${clientIp[$i]}
        scp $clientSrcConsulFile  root@$tmpHost:$clientDstConsulFile
        ssh -t root@$tmpHost "sed -i 's/$masterIPPlaceholder/$masterIP/g' $clientDstConsulFile"
        ssh -t root@$tmpHost "sed -i 's/$clientIPPlaceholder/$tmpIp/g' $clientDstConsulFile"
        ssh -t root@$tmpHost "sed -i 's/$clientHostNamePlaceholder/$tmpName/g' $clientDstConsulFile"
        ssh -t root@$tmpHost "cat $clientDstConsulFile"
    done
}

masterSwarm(){
    #开启主节点Swarm
    scp $masterSrcSwarmFile  root@$masterHost:$masterDstSwarmFile
    ssh -t root@$masterHost "sed -i 's/$masterIPPlaceholder/$masterIP/g' $masterDstSwarmFile"
    ssh -t root@$masterHost "cat $masterDstSwarmFile"
}

masterShipyard(){
    #开启主节点Shipyard
    scp $masterSrcShipyardFile  root@$masterHost:$masterDstShipyardFile
    ssh -t root@$masterHost "sed -i 's/$masterIPPlaceholder/$masterIP/g' $masterDstShipyardFile"
    ssh -t root@$masterHost "cat $masterDstShipyardFile"
}

clientSwarm(){
     #开启其他节点Swarm代理
    for ((i=0;i<${#clientHost[@]};i++));do
        tmpHost=${clientHost[$i]}
        tmpName=${clientName[$i]}
        tmpIp=${clientIp[$i]}
        scp $clientSrcSwarmFile  root@$tmpHost:$clientDstSwarmFile
        ssh -t root@$tmpHost "sed -i 's/$masterIPPlaceholder/$masterIP/g' $clientDstSwarmFile"
        ssh -t root@$tmpHost "sed -i 's/$clientIPPlaceholder/$tmpIp/g' $clientDstSwarmFile"
        ssh -t root@$tmpHost "cat $clientDstSwarmFile"
    done
}

masterRegistrator()
{
    #开启主节点Registrator
    scp $masterSrcRegistratorFile  root@$masterHost:$masterDstRegistratorFile
    ssh -t root@$masterHost "sed -i 's/$masterIPPlaceholder/$masterIP/g' $masterDstRegistratorFile"
    ssh -t root@$masterHost "cat $masterDstRegistratorFile"  
}

clientRegistrator(){
     #开启其他节点Registrator
    for ((i=0;i<${#clientHost[@]};i++));do
        tmpHost=${clientHost[$i]}
        tmpName=${clientName[$i]}
        tmpIp=${clientIp[$i]}
        scp $clientSrcRegistratorFile  root@$tmpHost:$clientDstRegistratorFile
        ssh -t root@$tmpHost "sed -i 's/$masterIPPlaceholder/$masterIP/g' $clientDstRegistratorFile"
        ssh -t root@$tmpHost "sed -i 's/$clientIPPlaceholder/$tmpIp/g' $clientDstRegistratorFile"
        ssh -t root@$tmpHost "cat $clientDstRegistratorFile"
    done
}

masterStart()
{
    #主节点启动脚本
    scp $masterSrcStartFile  root@$masterHost:$masterDstStartFile
    ssh -t root@$masterHost "cat $masterDstStartFile"  
}

clientStart()
{
    #其他节点启动脚本
    for tmpHost in ${clientHost[@]};do
        scp $clientSrcStartFile root@$tmpHost:$clientDstStartFile
        ssh -t root@$tmpHost "cat $clientDstStartFile"
    done
}

masterStop()
{
    #主节点关闭脚本
    scp $masterSrcStopFile  root@$masterHost:$masterDstStopFile
    ssh -t root@$masterHost "cat $masterDstStopFile"  
}

clientStop()
{
    #其他节点关闭脚本
    for tmpHost in ${clientHost[@]};do
        scp $clientSrcStopFile root@$tmpHost:$clientDstStopFile
        ssh -t root@$tmpHost "cat $clientDstStopFile"
    done
}


masterDockerPull
clientDockerpull
masterStartConsul
clientStartConsul
masterSwarm
masterShipyard
clientSwarm
masterRegistrator
clientRegistrator
masterStart
clientStart
masterStop
clientStop