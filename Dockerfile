ARG DEBIAN_VERSION=11.6

FROM amd64/debian:${DEBIAN_VERSION}

RUN useradd -m -s /bin/bash runner

RUN mkdir -p /opt/actions-runner && \
    apt-get update && \
    apt-get install -y \
    curl \
    tar \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-pip \
    jq 

# Install latest version of Docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
    apt-get install -y docker-ce-cli

ARG RUNNER_VERSION=2.301.1

RUN curl -o /tmp/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN tar xzf /tmp/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -C /opt/actions-runner
RUN /bin/bash -c "/opt/actions-runner/bin/installdependencies.sh"
RUN chown -R runner:runner /opt/actions-runner

COPY ./bin/entrypoint.sh /bin/

RUN chmod +x /bin/entrypoint.sh

USER runner

ENV BUILDX_VERSION=v0.8.2
ENV DOCKER_COMPOSE_VERSION=v2.5.1

# Docker Plugins
RUN mkdir -p "${HOME}/.docker/cli-plugins" \
    && curl -SsL "https://github.com/docker/buildx/releases/download/${BUILDX_VERSION}/buildx-${BUILDX_VERSION}.linux-amd64" -o "${HOME}/.docker/cli-plugins/docker-buildx" \
    && curl -SsL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" -o "${HOME}/.docker/cli-plugins/docker-compose" \
    && chmod +x "${HOME}/.docker/cli-plugins/docker-buildx" \
    && chmod +x "${HOME}/.docker/cli-plugins/docker-compose"

ENTRYPOINT [ "/bin/entrypoint.sh" ]