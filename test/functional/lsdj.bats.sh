#!/usr/bin/env bats

# Copyright (c) 2020 gyselroth GmbH
# Licensed under the MIT License - https://opensource.org/licenses/MIT

load _helper

docxbox=""$BATS_TEST_DIRNAME"/docxbox"
base_command="docxbox lsdj filename.docx"

path_docx="test/functional/tmp/cp_table_unordered_list_images.docx"
long_description_json="the fields in the docx are listed as JSON"

@test "Exit code of \"${base_command}\" is zero" {
  run "${docxbox}" lsdj "${path_docx}"
  [ "$status" -eq 0 ]
}

@test "Output of \"docxbox lsdj {missing argument}\" is an error message" {
  run "${docxbox}" lsdj
  [ "$status" -ne 0 ]
  [ "Missing argument: Filename of DOCX to be extracted" = "${lines[0]}" ]
}

@test "With \"${base_command}\" the fields in the docx are listed as JSON" {
  pattern="table_unordered_list_images.docx-"
  "${docxbox}" lsdj "${path_docx}" | grep --count "${pattern}"

  pattern="/word/document.xml"
  "${docxbox}" lsdj "${path_docx}" | grep --count "${pattern}"
}

longhand="--fields --json"
title="With \"docxbox ls filename.docx ${longhand}\" "
title+="${long_description_json}"
@test "${title}" {
  pattern="table_unordered_list_images.docx-"
  "${docxbox}" ls "${path_docx}" ${longhand} | grep --count "${pattern}"

  pattern="/word/document.xml"
  "${docxbox}" ls "${path_docx}" ${longhand} | grep --count "${pattern}"
}

@test "With \"docxbox ls filename.docx -dj\" ${long_description_json}" {
  pattern="table_unordered_list_images.docx-"
  "${docxbox}" ls "${path_docx}" -dj | grep --count "${pattern}"

  pattern="/word/document.xml"
  "${docxbox}" ls "${path_docx}" -dj | grep --count "${pattern}"
}

@test "With \"docxbox lsd filename.docx --json\" ${long_description_json}" {
  pattern="table_unordered_list_images.docx-"
  "${docxbox}" lsd "${path_docx}" --json | grep --count "${pattern}"

  pattern="/word/document.xml"
  "${docxbox}" lsd "${path_docx}" --json | grep --count "${pattern}"
}
