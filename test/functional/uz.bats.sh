#!/usr/bin/env bats

# Copyright (c) 2020 gyselroth GmbH
# Licensed under the MIT License - https://opensource.org/licenses/MIT

load _helper

docxbox=""$BATS_TEST_DIRNAME"/docxbox"

@test "Output of \"docxbox uz {missing argument}\" is an error message" {
  run "${docxbox}" uz
  [ "$status" -ne 0 ]
  [ "Missing argument: Filename of DOCX to be extracted" = "${lines[0]}" ]
}

@test "With of \"docxbox uz filename.docx\" all files are unziped" {
  run "${docxbox}" uz test/functional/tmp/cp_bio_assay.docx
  [ "$status" -eq 0 ]
}

@test "Unziped files are located in project root" {
  ls | grep --count cp_bio_assay.docx-extracted

  if [ -d cp_bio_assay.docx-extracted ]; then
    rm --recursive cp_bio_assay.docx-extracted;
  fi
}
