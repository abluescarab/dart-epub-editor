import 'package:xml/xml.dart';

String valueOrInnerText(XmlNode xml) {
  if (xml is XmlElement) {
    return xml.value != null && xml.value!.isNotEmpty
        ? xml.value!
        : xml.innerText;
  } else if (xml is XmlAttribute) {
    return xml.value.isNotEmpty ? xml.value : xml.innerText;
  }

  return '';
}
