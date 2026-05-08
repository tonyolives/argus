#!/usr/bin/env bash

JAVA17_HOME=$(/usr/libexec/java_home -v 17 2>/dev/null) || {
  echo "Java 17 was not found on this machine." >&2
  return 1 2>/dev/null || exit 1
}

export JAVA_HOME="$JAVA17_HOME"
export PATH="$JAVA_HOME/bin:$PATH"

echo "Argus shell configured for Java 17"
echo "JAVA_HOME=$JAVA_HOME"
java -version
