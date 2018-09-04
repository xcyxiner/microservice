#!/bin/bash

baseDstDirectory="tmp"
baseVip="192.168.31.100"
baseVIPPlaceholder="VIPADDRESS"


#主节点域名，IP，以及docker name
masterHost=ubuntu101
masterName=node101
masterIP="192.168.31.15"
masterSrcDirectory="master"
masterEth0Name="enp0s5"
#占位符替换
masterIPPlaceholder="MASTERIP"
masterHostNamePlaceholder="MASTERHOSTNAME"
masterEth0NamePlaceholder="MASTERETH0NAME"
masterMemberPeersPlaceholder="MEMBERSPEERS"
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
#主节点web脚本
masterWebFileName="masterWeb.sh"
masterSrcWebFile="$masterSrcDirectory/$masterWebFileName"
masterDstWebFile="/$baseDstDirectory/$masterWebFileName"
#主节点lb脚本
masterLbFileName="masterLb.sh"
masterSrcLbFile="$masterSrcDirectory/$masterLbFileName"
masterDstLbFile="/$baseDstDirectory/$masterLbFileName"
#主节点Keepalived脚本
masterKeepalivedFileName="masterKeepalived.sh"
masterSrcKeepalivedFile="$masterSrcDirectory/$masterKeepalivedFileName"
masterDstKeepalivedFile="/$baseDstDirectory/$masterKeepalivedFileName"

#其他节点域名，IP，以及docker name
clientHost="ubuntu102"
clientName="node102"
clientIp="192.168.31.19"
clientSrcDirectory="client"
clientEth0Name="enp0s5"
#占位符替换
clientIPPlaceholder="CLIENTIP"
clientHostNamePlaceholder="CLIENTHOSTNAME"
clientEth0NamePlaceholder="CLIENTETH0NAME"
clientMemberPeersPlaceholder="MEMBERSPEERS"
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
#其他节点Web脚本
clientWebFileName="clientWeb.sh"
clientSrcWebFile="$clientSrcDirectory/$clientWebFileName"
clientDstWebFile="/$baseDstDirectory/$clientWebFileName"
#其他节点lb脚本
clientLbFileName="clientLb.sh"
clientSrcLbFile="$clientSrcDirectory/$clientLbFileName"
clientDstLbFile="/$baseDstDirectory/$clientLbFileName"
#其他节点Keepalived脚本
clientKeepalivedFileName="clientKeepalived.sh"
clientSrcKeepalivedFile="$clientSrcDirectory/$clientKeepalivedFileName"
clientDstKeepalivedFile="/$baseDstDirectory/$clientKeepalivedFileName"


#获取除自己外的所有的IP
getAllIp()
{
    tmpStr=""
    tmpIP="192.168.31.100";
    if [ $tmpIP != $masterIP ] ; then    
        if [ -z ${tmpStr} ]; then
            tmpStr="'${masterIP}'"
        else
            tmpStr="${tmpStr},'${masterIP}'"
        fi
    fi
    for tmpclientIP in ${clientIp[@]};do
        if [ $tmpIP != $tmpclientIP ] ; then
            if [ -z ${tmpStr} ]; then
                 tmpStr="'${tmpclientIP}'"
            else
                tmpStr="${tmpStr},'${tmpclientIP}'"
            fi
        fi
    done
    echo $tmpStr
}

masterDockerPull(){
    #主节点下载镜像
    scp $masterSrcDownloadFile root@$masterHost:$masterDstDownloadFile
    ssh -t root@$masterHost "sh $masterDstDownloadFile"
}

clientDockerpull(){
    #其他节点下载镜像
    tmpHost=$clientHost
    scp $clientSrcDownloadFile root@$tmpHost:$clientDstDownloadFile
    ssh -t root@$tmpHost "sh $clientDstDownloadFile"
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
    tmpHost=$clientHost
    tmpName=$clientName
    tmpIp=$clientIp
    scp $clientSrcConsulFile  root@$tmpHost:$clientDstConsulFile
    ssh -t root@$tmpHost "sed -i 's/$masterIPPlaceholder/$masterIP/g' $clientDstConsulFile"
    ssh -t root@$tmpHost "sed -i 's/$clientIPPlaceholder/$tmpIp/g' $clientDstConsulFile"
    ssh -t root@$tmpHost "sed -i 's/$clientHostNamePlaceholder/$tmpName/g' $clientDstConsulFile"
    ssh -t root@$tmpHost "cat $clientDstConsulFile"
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
    tmpHost=$clientHost
    tmpName=$clientName
    tmpIp=$clientIp
    scp $clientSrcSwarmFile  root@$tmpHost:$clientDstSwarmFile
    ssh -t root@$tmpHost "sed -i 's/$masterIPPlaceholder/$masterIP/g' $clientDstSwarmFile"
    ssh -t root@$tmpHost "sed -i 's/$clientIPPlaceholder/$tmpIp/g' $clientDstSwarmFile"
    ssh -t root@$tmpHost "cat $clientDstSwarmFile"
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
    tmpHost=$clientHost
    tmpName=$clientName
    tmpIp=$clientIp
    scp $clientSrcRegistratorFile  root@$tmpHost:$clientDstRegistratorFile
    ssh -t root@$tmpHost "sed -i 's/$masterIPPlaceholder/$masterIP/g' $clientDstRegistratorFile"
    ssh -t root@$tmpHost "sed -i 's/$clientIPPlaceholder/$tmpIp/g' $clientDstRegistratorFile"
    ssh -t root@$tmpHost "cat $clientDstRegistratorFile"
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
    tmpHost=$clientHost
    scp $clientSrcStartFile root@$tmpHost:$clientDstStartFile
    ssh -t root@$tmpHost "cat $clientDstStartFile"
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
    tmpHost=$clientHost
    scp $clientSrcStopFile root@$tmpHost:$clientDstStopFile
    ssh -t root@$tmpHost "cat $clientDstStopFile"
}

masterLb()
{
#主节点负载均衡脚本
    scp $masterSrcLbFile  root@$masterHost:$masterDstLbFile
    ssh -t root@$masterHost "sed -i 's/$masterHostNamePlaceholder/$masterName/g' $masterDstLbFile"
    ssh -t root@$masterHost "cat $masterDstLbFile"  
}

clientLb()
{
    #其他节点测试Lb脚本
    tmpHost=$clientHost
    tmpName=$clientName
    tmpIp=$clientIp
    scp $clientSrcLbFile  root@$tmpHost:$clientDstLbFile
    ssh -t root@$tmpHost "sed -i 's/$clientHostNamePlaceholder/$tmpName/g' $clientDstLbFile"
    ssh -t root@$tmpHost "cat $clientDstLbFile"
}


masterWeb()
{
    #主节点测试web脚本
    scp $masterSrcWebFile  root@$masterHost:$masterDstWebFile
    ssh -t root@$masterHost "sed -i 's/$masterHostNamePlaceholder/$masterName/g' $masterDstWebFile"
    ssh -t root@$masterHost "cat $masterDstWebFile"  
}

clientWeb()
{
    #其他节点测试web脚本
    tmpHost=$clientHost
    tmpName=$clientName
    tmpIp=$clientIp
    scp $clientSrcWebFile  root@$tmpHost:$clientDstWebFile
    ssh -t root@$tmpHost "sed -i 's/$clientHostNamePlaceholder/$tmpName/g' $clientDstWebFile"
    ssh -t root@$tmpHost "cat $clientDstWebFile"
}

masterKeepalived()
{
 #主节点测试web脚本
    scp $masterSrcKeepalivedFile  root@$masterHost:$masterDstKeepalivedFile
    ssh -t root@$masterHost "sed -i 's/$baseVIPPlaceholder/$baseVip/g' $masterDstKeepalivedFile"
    ssh -t root@$masterHost "sed -i 's/$masterEth0NamePlaceholder/$masterEth0Name/g' $masterDstKeepalivedFile"
    tmpStr="'${clientIp}'"
    ssh -t root@$masterHost "sed -i \"s/$masterMemberPeersPlaceholder/$tmpStr/g\" $masterDstKeepalivedFile"
    ssh -t root@$masterHost "cat $masterDstKeepalivedFile"  
}

clientKeepalived()
{
    #其他节点测试web脚本
    tmpHost=$clientHost
    tmpName=$clientName
    scp $clientSrcKeepalivedFile  root@$tmpHost:$clientDstKeepalivedFile
    ssh -t root@$tmpHost "sed -i 's/$baseVIPPlaceholder/$baseVip/g' $clientDstKeepalivedFile"
    ssh -t root@$tmpHost "sed -i 's/$clientEth0NamePlaceholder/$clientEth0Name/g' $clientDstKeepalivedFile"
    tmpStr="'${masterIP}'"
    ssh -t root@$tmpHost "sed -i \"s/$clientMemberPeersPlaceholder/$tmpStr/g\" $clientDstKeepalivedFile"    
    ssh -t root@$tmpHost "cat $clientDstKeepalivedFile"
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
masterLb
clientLb
masterWeb
clientWeb
masterKeepalived
clientKeepalived