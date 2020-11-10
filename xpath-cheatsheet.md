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
|*[self::type1 or self::type2]|Either `type1` and `type2` element|
|./following-sibling::*|Any element that is a sibling to the this element|
