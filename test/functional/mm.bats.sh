#!/usr/bin/env bats

# Copyright (c) 2020 gyselroth GmbH
# Licensed under the MIT License - https://opensource.org/licenses/MIT

load _helper

@test "Output of \"docxbox mm {missing argument}\" is an error message" {
  run "$BATS_TEST_DIRNAME"/docxbox mm
  [ "$status" -ne 0 ]
  [ "Missing argument: DOCX filename" = "${lines[0]}" ]
}

@test "Output of \"docxbox mm filename.docx {missing argument}\" is an error message" {
  path_docx="test/functional/tmp/cp_table_unordered_list_images.docx"

  run "$BATS_TEST_DIRNAME"/docxbox mm $path_docx
  [ "$status" -ne 0 ]
  [ "Missing argument: Meta attribute to be set" = "${lines[0]}" ]
}

@test "With \"docxbox mm filename.docx title {argument}\" the meta attribute title can be changed" {
  path_docx="test/functional/tmp/cp_bio_assay"

  run "$BATS_TEST_DIRNAME"/docxbox mm $path_docx.docx title "someTitle"
  [ "$status" -eq 0 ]
  "$BATS_TEST_DIRNAME"/docxbox lsm $path_docx.docx | grep -c "title: someTitle"
}

@test "With \"docxbox mm filename.docx creator {argument}\" the meta attribute creator can be changed" {
  path_docx="test/functional/tmp/cp_bio_assay"

  run "$BATS_TEST_DIRNAME"/docxbox mm $path_docx.docx creator "someOne"
  [ "$status" -eq 0 ]
  "$BATS_TEST_DIRNAME"/docxbox lsm $path_docx.docx | grep -c "creator: someOne"
}

@test "With \"docxbox mm filename.docx lastModifiedBy {argument}\" the meta attribute lastModifiedBy can be changed" {
  path_docx="test/functional/tmp/cp_bio_assay"

  run "$BATS_TEST_DIRNAME"/docxbox mm $path_docx.docx lastModifiedBy "someOneElse"
  [ "$status" -eq 0 ]
  "$BATS_TEST_DIRNAME"/docxbox lsm $path_docx.docx | grep -c "lastModifiedBy: someOneElse"
}

@test "With \"docxbox mm filename.docx lastPrinted {argument}\" the meta attribute lastPrinted can be changed" {
  path_docx="test/functional/tmp/cp_bio_assay"

  run "$BATS_TEST_DIRNAME"/docxbox mm $path_docx.docx lastPrinted "2020-02-20T10:31:00Z"
  [ "$status" -eq 0 ]
  "$BATS_TEST_DIRNAME"/docxbox lsm $path_docx.docx | grep -c "lastPrinted: 2020-02-20T10:31:00Z"
}

@test "With \"docxbox mm filename.docx language {argument}\" the meta attribute language can be changed" {
  path_docx="test/functional/tmp/cp_bio_assay"

  run "$BATS_TEST_DIRNAME"/docxbox mm $path_docx.docx language "de-CH"
  [ "$status" -eq 0 ]
  "$BATS_TEST_DIRNAME"/docxbox lsm $path_docx.docx | grep -c "language: de-CH"
}

@test "With \"docxbox mm filename.docx modified {argument}\" the meta attribute modified can be changed" {
  path_docx="test/functional/tmp/cp_bio_assay"

  run "$BATS_TEST_DIRNAME"/docxbox mm $path_docx.docx modified "2020-10-20T10:20:00Z"
  [ "$status" -eq 0 ]
  "$BATS_TEST_DIRNAME"/docxbox lsm $path_docx.docx | grep -c "modified: 2020-10-20T10:20:00Z"
}

@test "With \"docxbox mm filename.docx created {argument}\" the meta attribute created can be changed" {
  path_docx="test/functional/tmp/cp_bio_assay"

  run "$BATS_TEST_DIRNAME"/docxbox mm $path_docx.docx created "2020-10-20T10:20:00Z"
  [ "$status" -eq 0 ]
  "$BATS_TEST_DIRNAME"/docxbox lsm $path_docx.docx | grep -c "created: 2020-10-20T10:20:00Z"
}

@test "With \"docxbox mm filename.docx revision {argument}\" the meta attribute revision can be changed" {
  path_docx="test/functional/tmp/cp_bio_assay"

  run "$BATS_TEST_DIRNAME"/docxbox mm $path_docx.docx revision "25"
  [ "$status" -eq 0 ]
  "$BATS_TEST_DIRNAME"/docxbox lsm $path_docx.docx | grep "revision: 25"
}
