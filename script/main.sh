#!/usr/bin/env bash

# Purpose : pull dags files from s3
# Author  : Ky-Anh Huynh
# Date    : 2020-02

set -u

dag_pull() {
  echo >&2 ":: Pulling latest dags from s3 (${S3_FILE})"

  MY_TEMP="$(mktemp -d)" || exit

  cd "${MY_TEMP}"
  aws s3 cp "${S3_FILE}" . || exit
  tar xfz latest.tgz
  rm -fv latest.tgz
  rsync -rapv --delete-after "${MY_TEMP}/" "${HOME}/dags/"
  cd "${HOME}" && { rm -rf "${MY_TEMP}" || true; }
}

loop() {
  sleep_time="${1:-29s}"; shift
  echo >&2 ":: Entering loop..."
  while :; do
    "${@:-true}"
    echo >&2 ":: Sleeping ${sleep_time}"
    sleep "$sleep_time"
  done
}

"${@:-true}"
