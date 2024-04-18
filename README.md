# kubectl-virt-plugin

Holds all scripts to create packages and manifest file required for publishing the 
[virtctl](https://kubevirt.io/user-guide/docs/latest/administration/intro.html#client-side-virtctl-deployment)
binary as a [krew](https://krew.dev/) package for 
[kubectl](https://kubernetes.io/docs/reference/kubectl/overview/).

## What is kubectl virt plugin, what is virtctl, and what is KubeVirt?

**kubectl virt plugin** is a wrapper for `virtctl` originating from the KubeVirt project.

[**KubeVirt**](https://kubevirt.io) is a virtualization add-on to Kubernetes, i.e. it enables to run existing virtual machines on Kubernetes 
clusters. 

virtctl controls virtual machine related operations on your Kubernetes cluster like connecting to the serial and VNC consoles.

See the [KubeVirt user guide](https://kubevirt.io/user-guide) for details.

## Installing virtctl as a kubectl plugin with krew

### Requirements

* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [krew](https://github.com/kubernetes-sigs/krew)

### Installing

For installation and usage of krew (the package manager for kubectl plugins) refer to its [manual](https://krew.dev/).

If krew is installed, the virt plugin can be installed:

    $ kubectl krew install virt                  
    
Output should be:

    Updated the local copy of plugin index.        
    Installing plugin: virt                                                                                                                                                                       
    CAVEATS:                                                                                       
    \                                              
     |  virt plugin is a wrapper for virtctl originating from the KubeVirt project. In order to use virtctl you will
     |  need to have KubeVirt installed on your Kubernetes cluster to use it. See https://kubevirt.io/ for details
     |                                             
     |  Run                                        
     |                                             
     |    kubectl virt help                        
     |                                             
     |  to get an overview of the available commands                                               
     |                                             
     |  ...                  
    /                                              
    Installed plugin: virt                         
    
Now we check the list of installed krew plugins

    $ kubectl plugin list
    The following kubectl-compatible plugins are available:
    
    /home/dhiller/.krew/bin/kubectl-krew
    /home/dhiller/.krew/bin/kubectl-virt

## Using virtctl 

After we have installed the virt plugin we can use it: 

    $ kubectl virt                                                                                                                                                                        130 ↵
    Available Commands:
      console      Connect to a console of a virtual machine instance.
      expose       Expose a virtual machine instance, virtual machine, or virtual machine instance replica set as a new service.
      help         Help about any command
      image-upload Upload a VM image to a PersistentVolumeClaim.
      restart      Restart a virtual machine.
      start        Start a virtual machine.
      stop         Stop a virtual machine.
      version      Print the client and server version information.
    ...
    
    $ kubectl virt version
    Client Version: version.Info{GitVersion:"v0.17.2", GitCommit:"58b5f4c64304f75c58ff0915ce70f9ed641d6629", GitTreeState:"clean", BuildDate:"2019-06-05T09:34:53Z", GoVersion:"go1.11.5", Compiler:"gc", Platform:"linux/amd64"}
    ...

## Creating krew packages after a new KubeVirt release 

**Note: a [prow job](https://github.com/kubevirt/project-infra/blob/cd56918c29690a1cda96d91a781b948f105c1dd6/github/ci/prow-deploy/files/jobs/kubevirt/kubectl-virt-plugin/kubectl-virt-plugin-periodics.yaml#L2) periodically executes the below script**

### Latest release

To manually prepare a kubectl krew release for a new release
just execute `./scripts/create-latest-release.sh` from the base directory. The script will create packages and store them in a new release in GitHub repo.

```bash
$ ./scripts/create-latest-release.sh
```

Output will be
```
Downloading binaries:
...

Creating pull request:
...
```

Creating the release will trigger [a GitHub action](.github/workflows/krew-release-bot.yaml) that then will create a PR against the [`krew-index`](https://github.com/kubernetes-sigs/krew-index) ([example](https://github.com/kubernetes-sigs/krew-index/pull/3677)).

### Specific release

Running `./scripts/create-release.sh` with a specific version will generate the release packages and create a release in GitHub.

```bash
./scripts/create-release.sh v1.2.0
```

The triggered GitHub actions will then create a PR as described above.
