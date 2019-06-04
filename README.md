# kubectl-virt-plugin

**Caveat: This is WIP. PR should have been opened from [krew-index](github.com/dhiller/krew-index).**

## Requirements

* git
* kubectl
* krew

## Plugin installation

As long as the manifest file has not been merged into the krew repository the prepared
plugin can be installed like so:

    git clone git@github.com:dhiller/kubectl-virt-plugin.git
    kubectl krew install --manifest=virt.yaml 
