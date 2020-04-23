// Copyright (c) 2020 gyselroth GmbH

#ifndef DOCXBOX_DOCX_XML_DOCX_XML_INDENT_H_
#define DOCXBOX_DOCX_XML_DOCX_XML_INDENT_H_

#include <docxbox/docx/xml/docx_xml.h>
#include <docxbox/helper/helper_file.h>
#include <docxbox/helper/helper_string.h>

#include <vendor/tinyxml2/tinyxml2.h>

#include <iostream>
#include <string>
#include <vector>

class docx_xml_indent:docx_xml {
 public:
  docx_xml_indent(int argc, char **argv);

  static bool IndentXml(const std::string& path_xml);
};

#endif  // DOCXBOX_DOCX_XML_DOCX_XML_INDENT_H_
