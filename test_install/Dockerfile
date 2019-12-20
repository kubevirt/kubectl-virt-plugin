FROM pstauffer/curl

# install kubectl
RUN kubectl_version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt) && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$kubectl_version/bin/linux/amd64/kubectl && \
    mv kubectl /usr/bin/ && \
    chmod +x /usr/bin/kubectl

# install krew
RUN set -x && \
    curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/download/v0.3.3/krew.{tar.gz,yaml}" && \
    tar zxvf krew.tar.gz && \
    mv krew-linux_amd64 /usr/bin/kubectl-krew && \
    chmod +x /usr/bin/kubectl-krew

RUN kubectl krew version
