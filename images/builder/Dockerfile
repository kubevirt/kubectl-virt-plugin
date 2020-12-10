FROM kubevirtci/bootstrap:v20201119-a5880e0

RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-upgrade \
        shellcheck \
        gettext-base \
        python3-pkg-resources \
        yamllint

# install kubectl
RUN kubectl_version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$kubectl_version/bin/linux/amd64/kubectl && \
    rm -f /google-cloud-sdk/bin/kubectl && \
    mv kubectl /google-cloud-sdk/bin/ && \
    chmod +x /google-cloud-sdk/bin/kubectl

# install krew
RUN set -x && \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v0.3.3/krew.{tar.gz,yaml}" && \
    tar zxvf krew.tar.gz && \
    mv krew-linux_amd64 "/google-cloud-sdk/bin/kubectl-krew" && \
    chmod +x "/google-cloud-sdk/bin/kubectl-krew"

RUN kubectl --client=true version && \
    kubectl krew version

ENV GIMME_GO_VERSION=1.13.14

RUN mkdir -p /gimme && curl -sL \
    https://raw.githubusercontent.com/travis-ci/gimme/master/gimme | \
    HOME=/gimme bash >> /etc/profile.d/gimme.sh

ENV GOPATH="/go" GOBIN="/usr/bin" GO111MODULE="on"

RUN set -x && \
    . /etc/profile.d/gimme.sh && \
    go get -v sigs.k8s.io/krew/cmd/validate-krew-manifest@v0.4.0 && \
    go clean -cache -modcache && \
    rm -rf /go && mkdir /go
