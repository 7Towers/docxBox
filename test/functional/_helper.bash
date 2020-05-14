#!/usr/bin/env bash

# Copyright (c) 2020 gyselroth GmbH
# Licensed under the MIT License - https://opensource.org/licenses/MIT

case "$OSTYPE" in
  bsd*)     OS="bsd" ;;
  darwin*)  OS="osx" ;;
  linux*)   OS="linux" ;;
  solaris*) OS="solaris" ;;
  *)        OS="unknown: $OSTYPE" ;;
esac

setup() {
  if [ "$OS" == "osx" ]; then
    cp "$BATS_TEST_DIRNAME"/../../bin/mac/docxbox "$BATS_TEST_DIRNAME"/docxbox
  elif [ $OS == "linux" ]; then
    cp "$BATS_TEST_DIRNAME"/../../bin/linux/docxbox "$BATS_TEST_DIRNAME"/docxbox
  fi
  bash ./test/functional/_copy_mockfiles.sh
}

teardown() {
  if [ -f "$BATS_TEST_DIRNAME"/docxbox ] ; then
    rm "$BATS_TEST_DIRNAME"/docxbox;
  fi
  bash ./test/functional/_delete_copied_mockfiles.sh
}
