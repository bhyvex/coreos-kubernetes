Azure CoreOS-Kubernetes installation
====================================

Our architecture will consist of a kubernetes master and two minions. For this job we'll need the `azure` command line tool (npm).

By default, the templates use the `stable` channel. This can be changed in both cloud configs from the `group: stable` var.

Use the following command to provision the kubernetes master node:

```
azure vm create --custom-data=master.yaml --vm-size=Large --ssh=22 --ssh-cert=/home/commixon/.ssh/passwordless.pem --no-ssh-password --vm-name=kubemaster --location="North Europe" kube-project 2b171e93f07c4903bcad35bda10acf22__CoreOS-Stable-723.3.0 core
```

After the machine is up and running (this is an azure specific step) we have to find the machine's private ip(!!!) and replace 
accordingly to the node.yaml (`cp node.yml.dist node.yaml`).

To create minion1:

```
azure vm create --custom-data=node.yaml --vm-size=Large --ssh=2022 --ssh-cert=/home/commixon/.ssh/passwordless.pem --no-ssh-password --vm-name=kubeminion1 --connect=kube-project 2b171e93f07c4903bcad35bda10acf22__CoreOS-Stable-723.3.0 core
```

And to create minion2:

```
azure vm create --custom-data=node.yaml --vm-size=Large --ssh=3022 --ssh-cert=/home/commixon/.ssh/passwordless.pem --no-ssh-password --vm-name=kubeminion2 --connect=kube-project 2b171e93f07c4903bcad35bda10acf22__CoreOS-Stable-723.3.0 core
```

Now we have to install the `kubectl` tool locally: https://github.com/GoogleCloudPlatform/kubernetes/blob/release-1.0/docs/getting-started-guides/aws/kubectl.md

And add the following to bashrc, bash_profile or something bash like locally:

```
export KUBERNETES_MASTER=http://<public-ip>:8080
```

And then issue:

```
source ~/.bash_profile
kubectl cluster-info
```

However, since this is azure, we have to open some endpoints:

Open 8080 on kubernetes master.

Also create a Load Balancer across all 3 of them for 4001 for the fleet service

