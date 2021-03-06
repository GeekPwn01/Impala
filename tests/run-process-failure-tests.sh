#!/bin/bash
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# Runs the Impala process failure tests.

set -euo pipefail
trap 'echo Error in $0 at line $LINENO: $(cd "'$PWD'" && awk "NR == $LINENO" $0)' ERR

# Disable HEAPCHECK for the process failure tests because they can cause false positives.
export HEAPCHECK=

RESULTS_DIR="${IMPALA_LOGS_DIR}/process_failure_tests"
mkdir -p "${RESULTS_DIR}"

cd "${IMPALA_HOME}/tests"
. "${IMPALA_HOME}/bin/set-classpath.sh" &> /dev/null
impala-py.test experiments/test_process_failures.py \
    --junitxml="\"${RESULTS_DIR}/TEST-impala-proc-failure.xml\"" \
    --resultlog="\"${RESULTS_DIR}/TEST-impala-proc-failure.log\"" "$@"
