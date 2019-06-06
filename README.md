# kubectl-virt-plugin

Holds all scripts to prepare packages and manifest file required for publishing the 
[virtctl](https://kubevirt.io/user-guide/docs/latest/administration/intro.html#client-side-virtctl-deployment)
binary as a [krew](https://github.com/kubernetes-sigs/krew) plugin for 
[kubectl](https://kubernetes.io/docs/reference/kubectl/overview/).

**Caveat: This is WIP!**

## Installing virtctl as a krew plugin

### Requirements

* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
* [krew](https://github.com/kubernetes-sigs/krew)

### Installing

As long as the manifest file has not been merged into the krew repository the 
plugin can be installed like so:

    $ wget https://github.com/dhiller/krew-index/raw/master/plugins/virt.yaml
    $ kubectl krew install --manifest=virt.yaml
    
Output should be

    Installing plugin: virt
    CAVEATS:
    \
     |  Usage:
     |    kubectl virt
     |
     |  Documentation:
     |    https://kubevirt.io/user-guide/docs/latest/administration/intro.html#client-side-virtctl-deployment
    /
    Installed plugin: virt
    
Now we check the list of installed krew plugins

    $ kubectl plugin list
    The following kubectl-compatible plugins are available:
    
    /home/dhiller/.krew/bin/kubectl-krew
    /home/dhiller/.krew/bin/kubectl-virt

Then we can use it with kubectl 

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

## Package virtctl for krew

Example: prepare a kubectl krew release for `v0.17.2`

1. Execute `scripts/create-release.sh` from the base directory:

        $ ./scripts/create-release.sh v0.17.2
        Downloading binaries:
        ...
        
        Creating release packages for krew:
        ...
        
        Creating manifest yaml file for krew:
        ...
        Manifest for dist is <path>/kubectl-virt-plugin/out/release/v0.17.2/virt.yaml

2. Create a GitHub release `v0.17.2` in this repository, adding the `tar.gz` files from 
`<path>/kubectl-virt-plugin/out/release/v0.17.2/` 

3. Create a pull request against krew-index using the file

        <path>/kubectl-virt-plugin/out/release/v0.17.2/virt.yaml
