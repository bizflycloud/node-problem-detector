# Copyright 2016 The Kubernetes Authors All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ARG BASEIMAGE

# ENTRYPOINT ["/node-problem-detector", "--config.system-log-monitor=/config/kernel-monitor.json"]

FROM registry.k8s.io/node-problem-detector/node-problem-detector:v0.8.18 as builder

# Install crictl
ARG TARGETOS
ARG TARGETARCH
#`BUILDX_ARCH` will be used in the buildx package download URL
# The required format is in `TARGETOS-TARGETARCH`
# Set it default to linux-amd64 to make the Dockerfile
# works with / without buildkit
ENV BUILDX_ARCH="${TARGETOS:-linux}-${TARGETARCH:-amd64}"

ARG VERSION="v1.25.0"
RUN apt-get -qq update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y curl unzip < /dev/null > /dev/null && \
    rm -rf /var/cache/apt/* && \
    curl -sLO https://github.com/kubernetes-sigs/cri-tools/releases/download/$VERSION/crictl-${VERSION}-${BUILDX_ARCH}.tar.gz && \
    tar zxvf crictl-$VERSION-${BUILDX_ARCH}.tar.gz -C /usr/bin && \
    rm -f crictl-$VERSION-${BUILDX_ARCH}.tar.gz && \
    apt-get -qq autoremove curl unzip systemd