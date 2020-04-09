
#ifndef DOCXBOX_CLASS_DOCX_XML
#define DOCXBOX_CLASS_DOCX_XML

#include <string>
#include <iostream>

#include "../../helper/helper_file.h"
#include "../../helper/helper_string.h"

#include "../../../vendor/tinyxml2/tinyxml2.h"

class docx_xml {

 public:
  docx_xml(int argc, char **argv);

  static bool IsXmlFileContainingText(std::string filename);

 protected:
  int argc;
  char **argv;

  std::string document_text;
};

#endif //DOCXBOX_CLASS_DOCX_XML
