#!/bin/bash

[ ! -f "pom.xml" ] && echo "error: pom.xml not found : wrong directory or not a maven project" && exit 1

CURRENT_PROJECT_VERSION=$(mvn help:evaluate -Dexpression=project.version -q -DforceStdout)

echo "current project version = $CURRENT_PROJECT_VERSION"

IFS="." read CURRENT_MAJOR CURRENT_MINOR CURRENT_PATCH <<< "$CURRENT_PROJECT_VERSION"

NEW_MINOR="$(($CURRENT_MINOR + 1))"

echo "new minor = $NEW_MINOR"

NEW_PROJECT_VERSION="$CURRENT_MAJOR.$NEW_MINOR.$CURRENT_PATCH"

echo "new project version = $NEW_PROJECT_VERSION"

echo "::set-output name=newversion::$NEW_PROJECT_VERSION"

echo "applying new version in maven project..."

mvn versions:set --no-transfer-progress -DgenerateBackupPoms=false -DnewVersion=$NEW_PROJECT_VERSION

echo "successfully updated project version"