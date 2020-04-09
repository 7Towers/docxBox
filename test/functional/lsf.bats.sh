#!/usr/bin/env bats

load _helper

@test "Output of \"docxbox lsf {missing argument}\" is an error message" {
  run $BATS_TEST_DIRNAME/docxbox lsf
  [ "$status" -ne 0 ]
  [ "Missing argument: Filename of DOCX to be extracted" = "${lines[0]}" ]
}
