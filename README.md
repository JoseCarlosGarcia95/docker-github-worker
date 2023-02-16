# docker-github-worker

## Quickstart

    docker build . --tag runner-image
    docker run -e REPOSITORY_URL="<repo-url>" -e ACCESS_TOKEN="<access-token>" runner-image

### Generate Access Token

#### Organization & Personal

Only-for-org: Enable fine-grained for the organization -> <https://github.com/organizations/ORG/settings/personal-access-tokens>

Go to <https://github.com/settings/tokens?type=beta>, then create a new token with the following scopes:

- repo:admin

If you want to give access to a repository in a different organization, change resource owner.
