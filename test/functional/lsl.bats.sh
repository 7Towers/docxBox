#!/usr/bin/env bats

load _helper

@test "Exit code of \"docxbox lsl filename.docx searchString\" is zero" {
  run "$BATS_TEST_DIRNAME"/docxbox lsl test/functional/tmp/cp_table_unordered_list_images.docx fonts
  [ "$status" -eq 0 ]
}

@test "Output of \"docxbox lsl {missing argument}\" is an error message" {
  run "$BATS_TEST_DIRNAME"/docxbox lsl
  [ "$status" -ne 0 ]
  [ "Missing argument: String (or regular expression) to be found" = "${lines[0]}" ]
}

@test "Output of \"docxbox lsl filename.docx {missing argument}\" is an error message" {
  run "$BATS_TEST_DIRNAME"/docxbox lsl
  [ "$status" -ne 0 ]
  [ "Missing argument: String (or regular expression) to be found" = "${lines[0]}" ]
}

@test "\"docxbox lsl filename.docx searchString\" lists all files containing given searchString" {
  "$BATS_TEST_DIRNAME"/docxbox lsl test/functional/tmp/cp_table_unordered_list_images.docx fonts | grep -c "word/document.xml"
  "$BATS_TEST_DIRNAME"/docxbox lsl test/functional/tmp/cp_table_unordered_list_images.docx fonts | grep -c "word/fontTable.xml"
  "$BATS_TEST_DIRNAME"/docxbox lsl test/functional/tmp/cp_table_unordered_list_images.docx fonts | grep -c "word/numbering.xml"
  "$BATS_TEST_DIRNAME"/docxbox lsl test/functional/tmp/cp_table_unordered_list_images.docx fonts | grep -c "word/styles.xml"
}

@test "\"docxbox ls filename.docx -l searchString\" lists all files containing given searchString" {
  "$BATS_TEST_DIRNAME"/docxbox ls test/functional/tmp/cp_table_unordered_list_images.docx -l fonts | grep -c "word/document.xml"
  "$BATS_TEST_DIRNAME"/docxbox ls test/functional/tmp/cp_table_unordered_list_images.docx -l fonts | grep -c "word/fontTable.xml"
  "$BATS_TEST_DIRNAME"/docxbox ls test/functional/tmp/cp_table_unordered_list_images.docx -l fonts | grep -c "word/numbering.xml"
  "$BATS_TEST_DIRNAME"/docxbox ls test/functional/tmp/cp_table_unordered_list_images.docx -l fonts | grep -c "word/styles.xml"
}

@test "\"docxbox ls filename.docx --locate searchString\" lists all files containing given searchString" {
  "$BATS_TEST_DIRNAME"/docxbox ls test/functional/tmp/cp_table_unordered_list_images.docx --locate fonts | grep -c "word/document.xml"
  "$BATS_TEST_DIRNAME"/docxbox ls test/functional/tmp/cp_table_unordered_list_images.docx --locate fonts | grep -c "word/fontTable.xml"
  "$BATS_TEST_DIRNAME"/docxbox ls test/functional/tmp/cp_table_unordered_list_images.docx --locate fonts | grep -c "word/numbering.xml"
  "$BATS_TEST_DIRNAME"/docxbox ls test/functional/tmp/cp_table_unordered_list_images.docx --locate fonts | grep -c "word/styles.xml"
}

@test "\"docxbox lsl filename.docx regular-expression\" lists all files containing given regular-expression" {
  "$BATS_TEST_DIRNAME"/docxbox lsl test/functional/tmp/cp_bio_assay.docx "/[0-9A-Z]\{8\}/" | grep -c "docProps/core.xml"
}

@test "\"docxbox ls filename.docx -l regular-expression\" lists all files containing given regular-expression" {
  "$BATS_TEST_DIRNAME"/docxbox ls test/functional/tmp/cp_bio_assay.docx -l "/[0-9A-Z]\{8\}/" | grep -c "docProps/core.xml"
}

@test "\"docxbox ls filename.docx --locate regular-expression\" lists all files containing given regular-expression" {
  "$BATS_TEST_DIRNAME"/docxbox ls test/functional/tmp/cp_bio_assay.docx --locate "/[0-9A-Z]\{8\}/" | grep -c "docProps/core.xml"
}
