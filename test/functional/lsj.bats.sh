#!/usr/bin/env bats

# Copyright (c) 2020 gyselroth GmbH
# Licensed under the MIT License - https://opensource.org/licenses/MIT

load _helper

@test "Output of \"docxbox lsj filename.docx\" contains files' and directories' attributes" {
  path_docx="test/functional/tmp/cp_table_unordered_list_images.docx"

  "$BATS_TEST_DIRNAME"/docxbox lsj $path_docx | grep -c "length"
  "$BATS_TEST_DIRNAME"/docxbox lsj $path_docx | grep -c "date"
  "$BATS_TEST_DIRNAME"/docxbox lsj $path_docx | grep -c "time"
  "$BATS_TEST_DIRNAME"/docxbox lsj $path_docx | grep -c "file"
  "$BATS_TEST_DIRNAME"/docxbox lsj $path_docx | grep -c "length"
  "$BATS_TEST_DIRNAME"/docxbox lsj $path_docx | grep -c "date"
  "$BATS_TEST_DIRNAME"/docxbox lsj $path_docx | grep -c "time"
  "$BATS_TEST_DIRNAME"/docxbox lsj $path_docx | grep -c "file"
}

@test "Output of \"docxbox ls filename.docx --json\" contains files' and directories' attributes" {
  path_docx="test/functional/tmp/cp_table_unordered_list_images.docx"

  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx --json | grep -c "length"
  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx --json | grep -c "date"
  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx --json | grep -c "time"
  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx --json | grep -c "file"
}

@test "Output of \"docxbox ls filename.docx -j\" contains files' and directories' attributes" {
  path_docx="test/functional/tmp/cp_table_unordered_list_images.docx"

  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx -j | grep -c "length"
  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx -j | grep -c "date"
  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx -j | grep -c "time"
  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx -j | grep -c "file"
}

@test "Output of \"docxbox lsj filename.docx\" are contained files" {
  path_docx="test/functional/tmp/cp_table_unordered_list_images.docx"

  "$BATS_TEST_DIRNAME"/docxbox lsj $path_docx | grep -c "[Content_Types].xml"
  "$BATS_TEST_DIRNAME"/docxbox lsj $path_docx | grep -c "word/settings.xml"
  "$BATS_TEST_DIRNAME"/docxbox lsj $path_docx | grep -c "word/_rels/document.xml.rels"
  "$BATS_TEST_DIRNAME"/docxbox lsj $path_docx | grep -c "word/fontTable.xml"
}

@test "Output of \"docxbox lsj filename.docx\" contains files' date and time" {
  path_docx="test/functional/tmp/cp_table_unordered_list_images.docx"

  "$BATS_TEST_DIRNAME"/docxbox lsj $path_docx | grep -c "4/11/2020"
  "$BATS_TEST_DIRNAME"/docxbox lsj $path_docx | grep -c "11:3"
}

@test "Output of \"docxbox ls {missing argument}\" is an error message" {
  run "$BATS_TEST_DIRNAME"/docxbox lsj
  [ "$status" -ne 0 ]
  [ "Missing argument: DOCX filename" = "${lines[0]}" ]
}
