// Copyright (c) 2020 gyselroth GmbH

#include <docxbox/helper/helper_dateTime.h>

namespace helper {

// Get string of current timestamp, w/ given offset in days added,
// in given format.
std::string DateTime::GetCurrentDateTimeFormatted(const char *format) {
  time_t raw_time;
  struct tm *time_info;
  char buffer[80];

  time(&raw_time);
  time_info = localtime(&raw_time);

  strftime(buffer, sizeof(buffer), format, time_info);
  std::string str(buffer);

  return str;
}

// @return dateTime in ISO 8601 format, e.g. "1994-11-05T13:15:30Z"
// @see ISO-8601 https://www.w3.org/TR/NOTE-datetime
std::string DateTime::GetCurrentDateTimeInIso8601() {
  return GetCurrentDateTimeFormatted(kFormatIso8601);
}

}  // namespace helper
