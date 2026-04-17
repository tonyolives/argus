#!/bin/sh
# ----------------------------------------------------------------------------
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
# ----------------------------------------------------------------------------

# ----------------------------------------------------------------------------
# Apache Maven Wrapper startup batch script, version 3.2.0
# ----------------------------------------------------------------------------

# If JAVA_HOME is not set, try to detect it
if [ -z "$JAVA_HOME" ]; then
  if [ -x "/usr/libexec/java_home" ]; then
    JAVA_HOME=$(/usr/libexec/java_home)
    export JAVA_HOME
  fi
fi

# Determine the base directory of the script
APP_HOME=$(cd "$(dirname "$0")" && pwd)
MAVEN_WRAPPER_PROPERTIES="$APP_HOME/.mvn/wrapper/maven-wrapper.properties"

# Read the distribution URL from maven-wrapper.properties
if [ -f "$MAVEN_WRAPPER_PROPERTIES" ]; then
  DISTRIBUTION_URL=$(grep "^distributionUrl" "$MAVEN_WRAPPER_PROPERTIES" | sed 's/distributionUrl=//')
else
  echo "ERROR: Cannot find $MAVEN_WRAPPER_PROPERTIES" >&2
  exit 1
fi

# Compute the distribution directory name
DIST_FILENAME=$(basename "$DISTRIBUTION_URL")
DIST_NAME="${DIST_FILENAME%-bin.zip}"
MAVEN_HOME="$HOME/.m2/wrapper/dists/$DIST_NAME"

# Download and unpack if not already present
if [ ! -d "$MAVEN_HOME/bin" ]; then
  mkdir -p "$MAVEN_HOME"
  echo "Downloading Apache Maven $DIST_NAME ..."
  if command -v curl > /dev/null 2>&1; then
    curl -o "$MAVEN_HOME/$DIST_FILENAME" -L "$DISTRIBUTION_URL"
  elif command -v wget > /dev/null 2>&1; then
    wget -O "$MAVEN_HOME/$DIST_FILENAME" "$DISTRIBUTION_URL"
  else
    echo "ERROR: curl or wget is required to download Maven." >&2
    exit 1
  fi
  unzip -q "$MAVEN_HOME/$DIST_FILENAME" -d "$MAVEN_HOME"
  mv "$MAVEN_HOME/$DIST_NAME/"* "$MAVEN_HOME/"
  rm -rf "$MAVEN_HOME/$DIST_NAME" "$MAVEN_HOME/$DIST_FILENAME"
fi

exec "$MAVEN_HOME/bin/mvn" "$@"
