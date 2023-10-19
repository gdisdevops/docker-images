#!/bin/bash

SENTRY_CLI_VERSION=2.21.2
SENTRY_DOWNLOAD_URL_ARM="https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}?response=download&arch=aarch64&platform=Linux&package=sentry-cli"
SENTRY_DOWNLOAD_URL_x86="https://release-registry.services.sentry.io/apps/sentry-cli/${SENTRY_CLI_VERSION}?response=download&arch=x86_64&platform=Linux&package=sentry-cli"

curl -L "${SENTRY_DOWNLOAD_URL_ARM}" -o sentry-cli-arm
curl -L "${SENTRY_DOWNLOAD_URL_x86}" -o sentry-cli-x86

sha256sum sentry-cli-arm
sha256sum sentry-cli-x86

rm sentry-cli-x86 sentry-cli-arm