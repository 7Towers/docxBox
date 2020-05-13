#!/usr/bin/env bats

# Copyright (c) 2020 gyselroth GmbH
# Licensed under the MIT License - https://opensource.org/licenses/MIT

load _helper

base_command="docxbox diff filename.docx"
error_message="is an error message"

@test "Output of \"docxbox diff {missing argument}\" ${error_message}" {
  run "$BATS_TEST_DIRNAME"/docxbox diff
  [ "$status" -ne 0 ]
  [ "Missing argument: DOCX file to compare with" = "${lines[0]}" ]
}

@test "Output of \"${base_command} {missing argument}\" ${error_message}" {
  path_docx="test/functional/tmp/cp_table_unordered_list_images.docx"

  run "$BATS_TEST_DIRNAME"/docxbox diff $path_docx
  [ "$status" -ne 0 ]
  [ "Missing argument: DOCX file to compare with" = "${lines[0]}" ]
}

title="Output of \"${base_command} otherFilename.docx {missing argument}\""
@test "${title} ${error_message}" {
  path_docx_1="test/functional/tmp/cp_table_unordered_list_images.docx"
  path_docx_2="test/files/docx/table_unordered_list_images.docx"

  run "$BATS_TEST_DIRNAME"/docxbox diff $path_docx_1 $path_docx_2
  [ "$status" -ne 0 ]
  [ "Missing argument: File within DOCX archives to be compared" = "${lines[0]}" ]
}

#@test "With \"docxbox diff filename_v1.docx filename_v2.docx fileToCompare\" a side-by-side comparison is displayed" {
#  run "$BATS_TEST_DIRNAME"/docxbox lorem test/functional/tmp/cp_table_unordered_list_images.docx
#  run "$BATS_TEST_DIRNAME"/docxbox diff test/functional/tmp/cp_table_unordered_list_images.docx test/files/docx/table_unordered_list_images.docx word/document.xml
#  [ "<w:t xml:space=\"preserve\">Officia</w:t>						   |	                <w:t xml:space=\"preserve\">Lorem</w:t>" = "${lines[13]}" ]
#  xdotool key Enter
#}
