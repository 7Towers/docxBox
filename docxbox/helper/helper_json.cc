// Copyright (c) 2020 gyselroth GmbH
// Licensed under the MIT License - https://opensource.org/licenses/MIT

#include <docxbox/helper/helper_json.h>

namespace helper {

// Extract 1st key out of JSON like: {"<KEY>"...}
std::string Json::GetFirstKey(const std::string &json) {
  int offset_end_key = helper::String::OffsetChar(json, '"', 3);

  return offset_end_key == -1
    ? ""
    : json.substr(2, offset_end_key - 2);
}

std::string Json::GetFirstValueOfKey(
    const std::string &json, std::string key) {
  auto json_outer = nlohmann::json::parse(json);

  for (auto &json_inner : json_outer) {
    for (nlohmann::json::iterator it = json_inner.begin();
         it != json_inner.end();
         ++it) {
      const std::string &key_current = it.key();

      if (key_current == key) return it.value();

      // TODO(kay): on-demand: make recursive to handle multi-level JSON
    }
  }
}

}  // namespace helper
