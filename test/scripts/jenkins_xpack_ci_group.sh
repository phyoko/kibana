#!/usr/bin/env bash

set -e
set -o pipefail

source "$(dirname "$0")/../../src/dev/ci_setup/setup.sh"
source "$(dirname "$0")/../../src/dev/ci_setup/git_setup.sh"
source "$(dirname "$0")/../../src/dev/ci_setup/java_setup.sh"

export TEST_BROWSER_HEADLESS=1
export XPACK_DIR="$(cd "$(dirname "$0")/../../x-pack"; pwd)"
echo "-> XPACK_DIR ${XPACK_DIR}"

echo " -> Ensuring all functional tests are in a ciGroup"
cd "$XPACK_DIR"
node scripts/functional_tests --assert-none-excluded \
  --include-tag ciGroup1 \
  --include-tag ciGroup2 \
  --include-tag ciGroup3 \
  --include-tag ciGroup4 \
  --include-tag ciGroup5 \
  --include-tag ciGroup6

echo " -> building and extracting default Kibana distributable for use in functional tests"
cd "$KIBANA_DIR"
node scripts/build --debug --no-oss
linuxBuild="$(find "$KIBANA_DIR/target" -name 'kibana-*-linux-x86_64.tar.gz')"
installDir="$PARENT_DIR/install/kibana"
mkdir -p "$installDir"
tar -xzf "$linuxBuild" -C "$installDir" --strip=1

export TEST_ES_FROM=${TEST_ES_FROM:-source}
echo " -> Running functional and api tests"
cd "$XPACK_DIR"
node scripts/functional_tests --debug --bail --kibana-install-dir "$installDir" --include-tag "ciGroup$CI_GROUP"
echo ""
echo ""
