#!/usr/bin/env bats

# Copyright (c) 2020 gyselroth GmbH
# Licensed under the MIT License - https://opensource.org/licenses/MIT

load _helper

base_command="\"docxbox ls filename.docx"
path_docx="test/functional/tmp/cp_table_unordered_list_images.docx"

@test "Exit code of ${base_command}\" is zero" {
  run "$BATS_TEST_DIRNAME"/docxbox ls $path_docx
  [ "$status" -eq 0 ]
}

@test "Output of \"docxbox ls {missing argument}\" is an error message" {
  run "$BATS_TEST_DIRNAME"/docxbox ls
  [ "$status" -ne 0 ]
  [ "Missing argument: DOCX filename" = "${lines[0]}" ]
}

@test "Output of ${base_command}\" contains files' and directories' attributes" {
  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx | grep -c "Length"
  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx | grep -c "Date"
  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx | grep -c "Time"
  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx | grep -c "Name"
}

@test "Output of ${base_command}\" is contained files" {
search_values=(
"[Content_Types].xml"
"docProps/app.xml"
"docProps/core.xml"
"word/_rels/document.xml.rels"
"word/charts/chart1.xml"
"word/document.xml"
"word/fontTable.xml"
"word/media/image1.jpeg"
"word/numbering.xml"
"word/settings.xml"
"word/styles.xml");

  for f in ${search_values[@]}
  do
    "$BATS_TEST_DIRNAME"/docxbox ls $path_docx | grep -c $f
  done
}

@test "Output of ${base_command}\" contains amount of contained files" {
  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx | grep -c '11 files'
}

@test "Output of ${base_command}\" contains files' date and time" {
  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx | grep -c "4/11/2020"
  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx | grep -c "11:3"
}

long_description="contains files with the given file ending"
@test "Output of ${base_command} *.file-ending\" ${long_description}" {
  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx *.jpeg | grep -c "image1.jpeg"
  "$BATS_TEST_DIRNAME"/docxbox ls $path_docx *.xml | grep -c "9 files"
}
