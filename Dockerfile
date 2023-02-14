ARG ALPINE_VERSION=3.17.2

FROM amd64/alpine:${ALPINE_VERSION}


RUN mkdir -p /actions-runner && \
    apk add --no-cache --virtual .build-deps \
    curl \
    tar 

ARG RUNNER_VERSION=2.301.1

RUN curl -o /tmp/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz

RUN tar xzf /tmp/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -C /actions-runner

COPY ./bin /actions-runner/bin

ENTRYPOINT [ "/bin/entrypoint.sh" ]