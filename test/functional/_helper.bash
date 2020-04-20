#!/usr/bin/env bash

case "$OSTYPE" in
  bsd*)     OS="bsd" ;;
  darwin*)  OS="osx" ;;
  linux*)   OS="linux" ;;
  solaris*) OS="solaris" ;;
  *)        OS="unknown: $OSTYPE" ;;
esac

setup() {
  if [ "$OS" == "osx" ]; then
    cp $BATS_TEST_DIRNAME/../../bin/mac/docxbox $BATS_TEST_DIRNAME/docxbox
  elif [ $OS == "linux" ]; then
    cp $BATS_TEST_DIRNAME/../../bin/linux/docxbox $BATS_TEST_DIRNAME/docxbox
  fi
  if [ ! -f test/files/docx/cp_bio_assay.docx ]; then
    cp test/files/docx/bio_assay.docx test/files/docx/cp_bio_assay.docx;
  fi
  if [ ! -f test/files/docx/cp_table_unordered_list_images.docx ]; then
    cp test/files/docx/table_unordered_list_images.docx test/files/docx/cp_table_unordered_list_images.docx;
  fi
#  if [ ! -d test/files/unziped ]; then
#    mkdir test/files/unziped;
#    unzip test/files/cp_table_unordered_list_images.docx -d test/files/unziped;
#  fi
}

teardown() {
  if [ -f $BATS_TEST_DIRNAME/docxbox ] ; then
    rm $BATS_TEST_DIRNAME/docxbox;
  fi
  if [ -f test/files/docx/cp_bio_assay.docx ]; then
    rm test/files/docx/cp_bio_assay.docx;
  fi
  if [ -f test/files/docx/cp_table_unordered_list_images.docx ]; then
    rm test/files/docx/cp_table_unordered_list_images.docx;
  fi
#  if [ -d test/files/unziped ]; then
#    rm -r  test/files/unziped;
#  fi
}
