import argparse
import logging
import sys
import xml.etree.ElementTree
import hashlib

if __name__ == "__main__":
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.INFO)
    handler = logging.StreamHandler(sys.stdout)
    handler.setLevel(logging.INFO)
    logger.addHandler(handler)

    parser = argparse.ArgumentParser(sys.argv)
    parser.add_argument("-s", dest="swupdate", default="SWUPDATE.BIN", type=str, help="SWUPDATE.BIN")
    parser.add_argument("-f", dest="fwinfo", default="fwinfo.xml", type=str, help="fwinfo.xml")
    args = parser.parse_known_args()

    logger.info(f"Read {args[0].swupdate}")
    md5_hash = hashlib.md5()
    with open(args[0].swupdate, "rb") as f:
        md5_hash.update(f.read())
        md5 = md5_hash.hexdigest()
    logger.info(f"md5 = {md5}")

    # frinfo_xml_tree = None
    logger.info(f"Read {args[0].fwinfo}")
    with open(args[0].fwinfo, "r", encoding="utf-8") as f:
        xml_data = f.readlines()
        frinfo_xml_tree = xml.etree.ElementTree.fromstringlist(xml_data)
        old_md5_tags = frinfo_xml_tree.findall("./md5sum")
        for t in  old_md5_tags:
            parent  = t.find("..")
            if not parent:
                parent = frinfo_xml_tree
            parent.remove(t)

        md5sum_tag = xml.etree.ElementTree.Element("md5sum")
        md5sum_tag.text = md5
        frinfo_xml_tree.append(md5sum_tag)

    root = xml.etree.ElementTree.ElementTree(frinfo_xml_tree).getroot()
    xml_out = xml.etree.ElementTree.tostring(root, encoding="utf8")
    logger.info(f"Write {args[0].fwinfo}")
    with open(args[0].fwinfo, "wb") as f:
        f.write(xml_out)

