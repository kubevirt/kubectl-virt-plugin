FROM gcr.io/k8s-testimages/bootstrap:v20190516-c6832d9

RUN apt-get update \
    && apt-get install -y --no-install-recommends --no-upgrade \
        shellcheck \
        gettext-base \
        python3-pkg-resources \
        yamllint

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
