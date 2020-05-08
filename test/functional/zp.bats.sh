#!/usr/bin/env bats

load _helper

@test "Output of \"docxbox zp {missing argument}\" is an error message" {
  run "$BATS_TEST_DIRNAME"/docxbox zp
  [ "$status" -ne 0 ]
  [ "Missing argument: Path of directory to be zipped" = "${lines[0]}" ]
}

@test "With \"docxbox zp directory /path-to-file/filename.docx\" a directory can be zipped into a docx" {
  if [ ! -d test/files/docx/unziped ]; then
    mkdir test/files/docx/unziped;
    path_docx="test/functional/tmp/cp_table_unordered_list_images.docx"
    unzip $path_docx -d test/files/docx/unziped;
  fi

  path_docx="test/files/docx/zp_table_unordered_list_images.docx"

  run "$BATS_TEST_DIRNAME"/docxbox zp test/files/docx/unziped $path_docx
  [ "$status" -eq 0 ]

  ls test/functional/tmp | grep -c zp_table_unordered_list_images.docx
}
