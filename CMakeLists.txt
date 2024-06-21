cmake_minimum_required(VERSION 3.10)
#cmake_minimum_required(VERSION 3.14)

set(CMAKE_CXX_STANDARD 17)

project(docxbox)

include_directories(${CMAKE_SOURCE_DIR})
# use cpp std 11

set (VERSION_MAJOR "1")
set (VERSION_MINOR "0")
set (VERSION_PATCH "0")

# configure config.h to be generated from config.h.in,
# with injected version number
configure_file ("docxbox/config.h.in" "docxbox/config.h")

set(CMAKE_CXX_STANDARD 14)


#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -std=c++1y -pedantic")

add_library(docxbox STATIC
        docxbox/main.cc

        docxbox/app/app.cc
        docxbox/app/app.h
        docxbox/app/app_argument.cc
        docxbox/app/app_argument.h
        docxbox/app/app_command.cc
        docxbox/app/app_command.h
        docxbox/app/app_help.cc
        docxbox/app/app_help.h
        docxbox/app/app_log.cc
        docxbox/app/app_log.h

        docxbox/docx/docx_batch.cc
        docxbox/docx/docx_batch.h
        docxbox/docx/docx_diff.cc
        docxbox/docx/docx_diff.h
        docxbox/docx/docx_compare.cc
        docxbox/docx/docx_compare.h

        docxbox/docx/archive/docx_archive.cc
        docxbox/docx/archive/docx_archive.h
        docxbox/docx/archive/docx_archive_list.cc
        docxbox/docx/archive/docx_archive_list.h
        docxbox/docx/archive/docx_archive_replace.cc
        docxbox/docx/archive/docx_archive_replace.h

        docxbox/docx/component/contentTypes.cc
        docxbox/docx/component/contentTypes.h
        docxbox/docx/component/fontTable.cc
        docxbox/docx/component/fontTable.h
        docxbox/docx/component/meta.cc
        docxbox/docx/component/meta.h
        docxbox/docx/component/media.cc
        docxbox/docx/component/media.h
        docxbox/docx/component/numbering.cc
        docxbox/docx/component/numbering.h
        docxbox/docx/component/partNames.cc
        docxbox/docx/component/partNames.h
        docxbox/docx/component/rels.cc
        docxbox/docx/component/rels.h
        docxbox/docx/component/styles.cc
        docxbox/docx/component/styles.h

        docxbox/docx/renderer/docx_renderer.cc
        docxbox/docx/renderer/docx_renderer.h
        docxbox/docx/renderer/docx_renderer_delegate.cc
        docxbox/docx/renderer/docx_renderer_delegate.h
        docxbox/docx/renderer/contentType/docx_renderer_heading.cc
        docxbox/docx/renderer/contentType/docx_renderer_heading.h
        docxbox/docx/renderer/contentType/docx_renderer_image.cc
        docxbox/docx/renderer/contentType/docx_renderer_image.h
        docxbox/docx/renderer/contentType/docx_renderer_link.cc
        docxbox/docx/renderer/contentType/docx_renderer_link.h
        docxbox/docx/renderer/contentType/docx_renderer_list.cc
        docxbox/docx/renderer/contentType/docx_renderer_list.h
        docxbox/docx/renderer/contentType/docx_renderer_paragraph.cc
        docxbox/docx/renderer/contentType/docx_renderer_paragraph.h
        docxbox/docx/renderer/component/docx_renderer_rels.cc
        docxbox/docx/renderer/component/docx_renderer_rels.h
        docxbox/docx/renderer/component/docx_renderer_styles.cc
        docxbox/docx/renderer/component/docx_renderer_styles.h
        docxbox/docx/renderer/contentType/docx_renderer_table.cc
        docxbox/docx/renderer/contentType/docx_renderer_table.h
        docxbox/docx/renderer/contentType/docx_renderer_text.cc
        docxbox/docx/renderer/contentType/docx_renderer_text.h

        docxbox/docx/xml/docx_xml.cc
        docxbox/docx/xml/docx_xml.h
        docxbox/docx/xml/component/docx_xml_contentTypes.cc
        docxbox/docx/xml/component/docx_xml_contentTypes.h
        docxbox/docx/xml/component/docx_xml_rels.cc
        docxbox/docx/xml/component/docx_xml_rels.h
        docxbox/docx/xml/component/docx_xml_styles.cc
        docxbox/docx/xml/component/docx_xml_styles.h
        docxbox/docx/xml/contentType/docx_xml_field.cc
        docxbox/docx/xml/contentType/docx_xml_field.h
        docxbox/docx/xml/contentType/docx_xml_table.cc
        docxbox/docx/xml/contentType/docx_xml_table.h
        docxbox/docx/xml/visitor/docx_xml_tidy.cc
        docxbox/docx/xml/visitor/docx_xml_tidy.h
        docxbox/docx/xml/visitor/docx_xml_lorem.cc
        docxbox/docx/xml/visitor/docx_xml_lorem.h
        docxbox/docx/xml/visitor/docx_xml_to_plaintext.cc
        docxbox/docx/xml/visitor/docx_xml_to_plaintext.h
        docxbox/docx/xml/visitor/docx_xml_remove.cc
        docxbox/docx/xml/visitor/docx_xml_remove.h
        docxbox/docx/xml/visitor/docx_xml_replace.cc
        docxbox/docx/xml/visitor/docx_xml_replace.h

        docxbox/helper/helper_cli.cc
        docxbox/helper/helper_cli.h
        docxbox/helper/helper_dateTime.cc
        docxbox/helper/helper_dateTime.h
        docxbox/helper/helper_file.cc
        docxbox/helper/helper_file.h
        docxbox/helper/helper_json.cc
        docxbox/helper/helper_json.h
        docxbox/helper/helper_string.cc
        docxbox/helper/helper_string.h
        docxbox/helper/helper_numeric.cc
        docxbox/helper/helper_numeric.h
        docxbox/helper/helper_xml.cc
        docxbox/helper/helper_xml.h

        vendor/miniz-cpp/zip_file.hpp
        vendor/tinyxml2/tinyxml2.cpp
        vendor/tinyxml2/tinyxml2.h
    )

    target_compile_features(docxbox PRIVATE cxx_std_17)

    target_include_directories(docxbox PRIVATE ${CMAKE_CURRENT_SOURCE_DIR})
