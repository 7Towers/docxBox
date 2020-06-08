// Copyright (c) 2020 gyselroth GmbH
// Licensed under the MIT License - https://opensource.org/licenses/MIT

#include <docxbox/app/app.h>  // note: must be here for forward-declaration
#include <docxbox/docx/docx_batch.h>

class docx_archive_replace;

docx_batch::docx_batch(class docx_archive *archive, std::string json) {
  archive_ = archive;
  json_ = std::move(json);

  is_json_valid_ = InitFromJson();
}

// Extract batch commands and rel. arguments
bool docx_batch::InitFromJson() {
  if (!helper::Json::IsJson(json_)) return false;

  auto json_outer = nlohmann::json::parse(json_);

  for (auto json_inner : json_outer) {
    for (nlohmann::json::iterator it = json_inner.begin();
         it != json_inner.end();
         ++it) {
      commands_.push_back(it.key());

      // note: dumped JSON string has associations alphabetically sorted,
      //       and not necessarily in same order as originally given
      arguments_json_.push_back(it.value().dump());
    }
  }

  return !commands_.empty()
         && commands_.size() == arguments_json_.size();
}

bool docx_batch::ProcessSequence() {
  if (!is_json_valid_)
    return docxbox::AppStatus::Error("Cannot process: Detected invalid JSON");

  for (int index = 0; index < commands_.size(); ++index)
    if (!ProcessStep(index)) return false;

  return true;
}

bool docx_batch::ProcessStep(int index) {
  // Resolve command + arguments
  std::vector<std::string> values;
  values.emplace_back(archive_->GetArgValue(0));

  if (arguments_json_[index] == "[]") {
    values.emplace_back(commands_[index]);
  } else {
    auto json_outer = nlohmann::json::parse(arguments_json_[index]);

    for (auto json_inner : json_outer) {
      for (nlohmann::json::iterator it = json_inner.begin();
           it != json_inner.end();
           ++it) {
        nlohmann::json basic_json = it.value();

        if (basic_json.is_object()) {
          values.emplace_back(std::string(basic_json.dump()));
        } else if (basic_json.is_string()) {
          values.emplace_back(it.value().dump().c_str());
        } else {
          // TODO(kay): test - needs handling of other types?
        }
      }
    }
  }

  int argc = values.size();

  // Convert from std::vector<std::string> to char**
  char **argv = new char*[argc + 1];
  for(size_t i = 0; i < argc; ++i) argv[i] = strdup(values[i].c_str());
  argv[argc] = nullptr;

  auto app = new docxbox::App(argc, argv, true);

  // TODO(kay): init DOCX path (source + extraction) from archive_

  //app->Process();

  // TODO(kay): extend DOCX modification methods for optional batch processing

  // delete argv
  for(size_t i = 0; i < argc; ++i)
    delete argv[i];  // free memory for each c-style string

  delete[] argv;  // free memory for outer char* array

  delete app;

  return false;
}
