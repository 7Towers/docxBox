// Copyright (c) 2020 gyselroth GmbH

#include <docxbox/docx/xml/docx_xml_indent.h>

docx_xml_indent::docx_xml_indent(
    int argc,
    char **argv) : docx_xml(argc, argv) {}

bool docx_xml_indent::IndentXml(const std::string& path_xml) {
  tinyxml2::XMLDocument doc;

  doc.LoadFile(path_xml.c_str());

  if (doc.ErrorID() != 0) return false;

  if (tinyxml2::XML_SUCCESS != doc.SaveFile(path_xml.c_str())) {
      std::cerr << "Error - Failed saving: " << path_xml << "\n";

      return false;
  }

  return true;
}
