# Docker 可视化界面

## 参考资料

* [使用Docker镜像搭建consul和swarm集群基础环境及overlay网络](https://blog.csdn.net/gsying1474/article/details/52711467)
* [Docker可视化界面（Consul+Shipyard+Swarm+Service Discover）部署记录](https://www.cnblogs.com/kevingrace/p/6883727.html)
* [Docker(六)----Swarm搭建Docker集群](https://blog.csdn.net/u011781521/article/details/80468985)
* [Ubuntu16.04 更改主机名](https://blog.csdn.net/wales_2015/article/details/79645637)
* [Ubuntu 远程免密码登录设置](https://blog.csdn.net/weixin_37272286/article/details/80007649)
* [Docker stop停止/remove删除所有容器](https://blog.csdn.net/superdangbo/article/details/78688904)
* [通过Consul-Template实现动态配置服务](https://www.hi-linux.com/posts/36431.html)

## 宿主机

* mac os 或者 linux
* 三个待用的ubuntu系统

## 前置条件

* ssh免密登录
* 更改主机名，并记录相关主机的IP地址
* 配置Swarm设置2375监听(参考资料第三条)


## 执行目录下start脚本

* 例如 

```
 cd /tmp
 sh startMaster.sh
```

* 例如 

```
 cd /tmp
 sh startClient.sh
```

# 文档介绍
* [微服务之Consul](https://xcyxiner.github.io/2018/08/22/20180822%E5%BE%AE%E6%9C%8D%E5%8A%A11/)