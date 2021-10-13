# XPath cheatsheet

|Locator|Description|
|---|---|
|.|This element|
|..|Parent element|
|./|Direct child of this element|
|.//|Any decendant of this element|
|*|Any element|
|*[@attribute='value']|Any element with a certain value for an attribute|
|*[contains(@attribute, 'value')]|Any element which has an attribute that contains 'value'|
|*[contains(text(), 'this text ')]|Any element, that contains exactly 'this text ', precisely, including whitespaces (even trailing ones).|
|*[contains(normalize-space(.), 'this text')]|Any element, that contains 'this text', stripped of leading or trailing whitespaces, or sequences of whitespaces inside it. Useful if texts contain additional whitespaces like 'this&nbsp;&nbsp; text'.|
|*[self::type1 or self::type2]|Either `type1` and `type2` element|
|./following-sibling::*|Any element that is a sibling to the this element|
