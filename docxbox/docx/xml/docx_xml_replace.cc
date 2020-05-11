// Copyright (c) 2020 gyselroth GmbH
// Licensed under the MIT License - https://opensource.org/licenses/MIT

#include <docxbox/docx/xml/docx_xml_replace.h>

docx_xml_replace::docx_xml_replace(
    int argc,
    char **argv) : docx_xml(argc, argv) {
}

// Replace given search string by replacement, which can be:
// 1. A regular string: will replace the given string
// 2. A string containing JSON: will be interpreted for rendering word markup,
//   which will than replace the <w:r> that contained the <w:t> node,
//   which contained the search-string
bool docx_xml_replace::ReplaceInXml(
    const std::string& path_xml,
    const std::string& search,
    const std::string& replacement,
    bool replace_segmented) {
  replace_segmented_ = replace_segmented;

  if (replace_segmented) {
    segments_look_behind_ = 0;
    previous_text_nodes_.clear();
  }

  is_replacement_xml_ = helper::String::IsJson(replacement);

  tinyxml2::XMLDocument doc;

  std::string doc_xml = helper::File::GetFileContents(path_xml);

  if (!helper::String::Contains(doc_xml, "w:document")
      || !helper::String::Contains(doc_xml, "w:body")) return true;

  if (is_replacement_xml_) {
    // Replacement will be done in steps:
    // 1. Inject pre-rendered XML into document
    // 2. Locate nodes containing child-nodes containing text to be replaced
    // 3. Replace the located nodes w/ deep-cloned duplicates of XML from 1.
    // 4. Remove injection from 1.
    runs_to_be_replaced_.clear();

    try {
      // Render and inject markup (initially) before body
      helper::String::ReplaceAll(
          doc_xml,
          "<w:body>",
          RenderMarkupFromJson(replacement) + "<w:body>");
    } catch (std::string &message) {
      std::cerr << message;

      return false;
    }
  }

  doc.Parse(doc_xml.c_str());

  if (doc.ErrorID() != 0) return false;

  amount_replaced_ = 0;

  if (is_replacement_xml_)
    replacement_xml_element_ =
        doc.FirstChildElement()->FirstChildElement("w:r");

  tinyxml2::XMLElement *body =
      doc.FirstChildElement("w:document")->FirstChildElement("w:body");

  if (replace_segmented) {
    do {
      // Replace (regular and) segmented text
      document_text_ = "";

      ReplaceSegmentedStringInTextNodes(body, search, replacement);

      segments_look_behind_++;
    } while (helper::String::Contains(document_text_, search.c_str()));
  } else {
    // Replace unsegmented plain text,
    // or if replacement is markup: locate runs to be replaced
    ReplaceOrLocateStringInXml(body, search, replacement);
  }

  if (is_replacement_xml_ && !runs_to_be_replaced_.empty())
    ReplaceRunsByXmlElement();

  if (amount_replaced_ > 0
      && tinyxml2::XML_SUCCESS != doc.SaveFile(path_xml.c_str(), true)) {
    std::cerr << "Error - Failed saving: " << path_xml << "\n";

    return false;
  }

  return true;
}

// Replaces the searched string when contained within a single <w:t> node
void docx_xml_replace::ReplaceOrLocateStringInXml(
    tinyxml2::XMLElement *node,
    const std::string& search,
    const std::string& replacement) {
  if (!node || node->NoChildren()) return;

  tinyxml2::XMLElement *sub_node = node->FirstChildElement();

  if (sub_node == nullptr) return;

  do {
    if (!sub_node) continue;

    const char *tag = sub_node->Value();

    if (tag) {
      if (0 == strcmp(tag, "w:r")) {
          current_run_ = sub_node;
      } else if (0 == strcmp(tag, "w:t")
          && sub_node->FirstChild() != nullptr) {
        std::string text = sub_node->GetText();

        if (!text.empty()
            && helper::String::Contains(text, search.c_str())) {
          if (is_replacement_xml_) {
            runs_to_be_replaced_.push_back(current_run_);
          } else {
            amount_replaced_ +=
                helper::String::ReplaceAll(text, search, replacement);

            sub_node->SetText(text.c_str());
          }
        }

        continue;
      }
    }

    ReplaceOrLocateStringInXml(sub_node, search, replacement);
  } while ((sub_node = sub_node->NextSiblingElement()));
}

// Step two of replacing text by markup
// (1: locate runs, containing nodes containing text to be replaced)
// 2: Replace located runs by markup
void docx_xml_replace::ReplaceRunsByXmlElement() {
  for (auto run : runs_to_be_replaced_) {
    if (nullptr == run) continue;

    tinyxml2::XMLNode *kParent = run->Parent();

    if (kParent) {
      auto replacement =
          replacement_xml_element_->DeepClone(
              replacement_xml_element_->GetDocument());

      kParent->InsertAfterChild(run, replacement);
      kParent->DeleteChild(run);
    }

    amount_replaced_++;
  }

  replacement_xml_element_->Parent()->DeleteChild(replacement_xml_element_);
}

/*  Replaces the searched string when contained in a single <w:t> tag,
 *  and also when contained "segmented", that is:
 *  spread over multiple consecutive <w:t> nodes (due to formatting).
 *
 *  Steps for replacing segmented strings:
 *  1. Replace simple (look-behind level = 0),
 *     collecting document plaintext at the same time
 *  2. When plaintext of whole XML does not contain search-string anymore: done
 *  3. Increment look-behind level
 *  4. Iterate over text nodes, detect when concatenated text from
 *     previous nodes and current contains search-string
 *  5. When search-string found:
 *        - Replace matching text segment within 1st <w:t> node
 *          of current look-behind-sequence,
 *        - Remove matching text segments from other <w:t> nodes
 *          of current look-behind-sequence
 *  6. Repeat from step 2.
 */
void docx_xml_replace::ReplaceSegmentedStringInTextNodes(
    tinyxml2::XMLElement *node,
    const std::string& search,
    const std::string& replacement
) {
  if (!node || node->NoChildren()) return;

  if (0 == strcmp(node->Value(), "w:p")) document_text_ += "\n";

  tinyxml2::XMLElement *sub_node = node->FirstChildElement();

  if (sub_node == nullptr) return;

  do {
    if (!sub_node) continue;

    const char *value = sub_node->Value();

    if (value) {
      if (0 == strcmp(value, "w:t")
          && sub_node->FirstChild() != nullptr) {
        std::string text = sub_node->GetText();

        document_text_ += text;

        if (!text.empty()
            && helper::String::Contains(text, search.c_str())) {
          amount_replaced_ +=
              helper::String::ReplaceAll(text, search, replacement);

          sub_node->SetText(text.c_str());
        }

        continue;
      } else if (0 == strcmp(value, "w:fldChar")) {
        if (
            0 == strcmp(
                sub_node->Attribute("w:fldCharType"),
                "begin")) document_text_ += " ";
      } else if (0 == strcmp(value, "w:instrText")) {
        continue;
      }
    }

    ReplaceOrLocateStringInXml(sub_node, search, replacement);
  } while ((sub_node = sub_node->NextSiblingElement()));
}

std::string docx_xml_replace::RenderMarkupFromJson(const std::string& json) {
  auto type = docx_renderer::DetectElementType(json);

  switch (type) {
    case docx_renderer::Element_Image:
      return docx_renderer_image::RenderMarkup(argc_, argv_, json);
    case docx_renderer::Element_Table:
      return docx_renderer_table::RenderMarkup(argc_, argv_, json);
    case docx_renderer::Element_None:default:
      throw "Invalid markup config, failed to identify element type.";
  }
}
