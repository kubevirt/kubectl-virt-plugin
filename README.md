# kubectl-virt-plugin

**Caveat: This is WIP. PR should have been opened from [krew-index](github.com/dhiller/krew-index).**

## Requirements

* git
* kubectl
* krew

## Plugin installation

As long as the manifest file has not been merged into the krew repository the prepared
plugin can be installed like so:

    $ git clone git@github.com:dhiller/kubectl-virt-plugin.git
    $ cd kubectl-virt-plugin
    $ kubectl krew install --manifest=virt.yaml
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
    $ kubectl virt
    Available Commands:
      console      Connect to a console of a virtual machine instance.
      expose       Expose a virtual machine instance, virtual machine, or virtual machine instance replica set as a new service.
      help         Help about any command
      image-upload Upload a VM image to a PersistentVolumeClaim.
      restart      Restart a virtual machine.
      start        Start a virtual machine.
      stop         Stop a virtual machine.
      version      Print the client and server version information.
      vnc          Open a vnc connection to a virtual machine instance.

    Use "virtctl <command> --help" for more information about a given command.
    Use "virtctl options" for a list of global command-line options (applies to all commands).
