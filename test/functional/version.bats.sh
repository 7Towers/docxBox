#!/usr/bin/env bats

load _helper

@test "\"docxbox v\" displays version number" {
  #todo: check needs to be more dynamic
  "$BATS_TEST_DIRNAME"/docxbox v | grep '0.0.2'
}
