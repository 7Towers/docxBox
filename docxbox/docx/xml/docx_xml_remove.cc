// Copyright (c) 2020 gyselroth GmbH

#include <docxbox/docx/xml/docx_xml_remove.h>

docx_xml_remove::docx_xml_remove(
    int argc,
    char **argv) : docx_xml(argc, argv) {}

bool docx_xml_remove::RemoveBetweenStringsInXml(
    const std::string& path_xml,
    const std::string& lhs,
    const std::string& rhs) {
  tinyxml2::XMLDocument doc;

  std::string kPathXml = path_xml;
  std::string xml = helper::File::GetFileContents(kPathXml);

  if (!helper::String::Contains(xml, "w:document")
      || !helper::String::Contains(xml, "w:body")) return true;

  doc.LoadFile(path_xml.c_str());

  if (doc.ErrorID() != 0) return false;

  tinyxml2::XMLElement *body =
      doc.FirstChildElement("w:document")->FirstChildElement("w:body");

  LocateNodesBetweenText(body, lhs, rhs);

  if (!nodes_to_be_removed_.empty()
      && found_lhs_
      && found_rhs_) {
    RemoveNodes();

    if (tinyxml2::XML_SUCCESS != doc.SaveFile(path_xml.c_str(), true)) {
      std::cerr << "Error - Failed saving: " << path_xml << "\n";

      return false;
    }
  }

  return true;
}

void docx_xml_remove::LocateNodesBetweenText(
    tinyxml2::XMLElement *node,
    const std::string& lhs,
    const std::string& rhs) {
  if (!node || node->NoChildren()) return;

  tinyxml2::XMLElement *sub_node = node->FirstChildElement();

  if (sub_node == nullptr) return;

  do {
    if (!sub_node) continue;

    const char *tag = sub_node->Value();

    if (tag) {
      if (0 == strcmp(tag, "w:p")) {
          current_run_ = sub_node;
      } else if (0 == strcmp(tag, "w:t")
          && sub_node->FirstChild() != nullptr) {
        std::string text = sub_node->GetText();

        if (text.empty() || (found_lhs_ && found_rhs_)) continue;

        if (!found_lhs_) {
          if (helper::String::Contains(text, lhs.c_str())) {
            found_lhs_ = true;

            nodes_to_be_removed_.push_back(current_run_);
          }
        } else {
          // Collect all runs until also right-hand-side string is found
          nodes_to_be_removed_.push_back(current_run_);

          if (helper::String::Contains(text, rhs.c_str())) found_rhs_ = true;
        }
      }
    }

    LocateNodesBetweenText(sub_node, lhs, rhs);
  } while (!(found_lhs_ && found_rhs_)
      && (sub_node = sub_node->NextSiblingElement()));
}


void docx_xml_remove::RemoveNodes() {
  tinyxml2::XMLNode *previous_node = NULL;

  for (auto node : nodes_to_be_removed_) {
    // Avoid deleting already deleted node (segmentation fault)
    if (node != previous_node) {
      tinyxml2::XMLNode *kParent = node->Parent();

      previous_node = node;

      kParent->DeleteChild(node);
    }
  }
}

// TODO(kay): add removal based on segmented texts
