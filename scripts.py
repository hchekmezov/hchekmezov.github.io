from robot.api import logger
from pypdf import PdfReader
import os
from robot.libraries.BuiltIn import BuiltIn
from ftfy import fix_text


def script(tags, tests):
    logger.console("\n You can start to print!")
    result_info = dict()
    for i in range(0, len(tags)):
        logger.console("Number -> {}\nTags -> {}\nTests -> {}".format(i, tags[i].replace(':', '').replace(',', '').split()
                                                                      , tests[i]))
        result_info[tests[i]] = input()
        # result_info.append(input())
    return result_info


def script_tags(tags):
    logger.console("\n You can start to print!")
    result_info = dict()
    for i in range(0, len(tags)):
        logger.console("Number -> {}\nTags -> {}".format(i, tags[i]))
        logger.console("1 - UNI\n2 - SCHOOL\n3 - EDU")
        x = input()
        if x == '1':
            temp = "UNIVERSITY"
        elif x == '2':
            temp = "SCHOOL"
        elif x == '3':
            temp = "EDUCATION"
        else:
            temp = x
        for tag in tags[i]:
            if 'TEST-' in tag:
                needed_tag = tag
                break
        result_info[needed_tag] = temp
    return result_info


def reason(test):
    logger.console(f"Reason for {test}\n")
    x = input()
    return x

def return_list_of_set(lst):
    return set(lst)


def make_a_report_for_place(place, tags):
    logger.console(f"\nReason For {place.upper()}")
    result = ""
    for i in range(0, len(tags) - 1):
        result = result + tags[i] + ', '
    result = result + tags[len(tags) - 1] + '; '
    return result + place + '; ' + input() + '\n'


def get_keys_by_value(diction, value):
    value = {i for i in diction if diction[i] == value}
    return list(value)


def write_links_to_file(links):
    f = open("links.txt", "w")
    f.write(links)
    f.close()


def write_report_to_file(report):
    f = open("report.txt", "w")
    f.write(report)
    f.close()


def zapyataya_probel():
    return ", "


def tochka_zapyataya_imya(imya):
    return "; {}; ".format(imya)


def reason_printing(key):
    logger.console("Message for key -> {}".format(key))
    msg = input()
    return "{}".format(msg)


def make_counter_with_probel(counter):
    return "{}. ".format(counter)


def minus_one():
    return -1


def import_text_from_pdf_file(pdf_file_path):
    reader = PdfReader(pdf_file_path)
    text = ""
    for page in reader.pages:
        text += page.extract_text() + "\n"
    return text


def get_parent_directory(path):
    return os.path.abspath(os.path.join(path, os.pardir))


def none_returning():
    return None


def built_check():
    is_lap_test = BuiltIn().get_variable_value("${IAMINLAPTEST}")
    if is_lap_test is None or is_lap_test.lower() == 'false':
        return 'good'
    else:
        return 'bad'


def fix_json_format(json_string):
    fixed_text = fix_text(json_string)
    return fixed_text


def get_page_id_by_url_part(browser_catalog, browser_id, context_id, url_part):
    for browser in browser_catalog:
        if browser['id'] == browser_id:
            for context in browser['contexts']:
                if context['id'] == context_id:
                    for page in context['pages']:
                        if url_part in page['url']:
                            return page['id']
    return None
