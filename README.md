# XsdModel [![Build Status](https://travis-ci.org/Masa331/xsd_model.svg?branch=master)](https://travis-ci.org/Masa331/xsd_model)

Schema Definition (XSD) parser.

Content:
1. [About](#about)
2. [Usage](#usage)
5. [License](#license)

## About

XsdModel parses a XML Schema Definition (XSD) and returns tree structure of objects representing XSD nodes. Each object implements specific API simplify the work with XSD.

## Usage

### Basics

Suppose you have following schema in a schema.xsd file:
```
<?xml version="1.0"?>
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema">

<xs:element name="note">
  <xs:complexType>
    <xs:sequence>
      <xs:element name="to" type="xs:string"/>
      <xs:element name="from" type="xs:string"/>
      <xs:element name="heading" type="xs:string"/>
      <xs:element name="body" type="xs:string"/>
    </xs:sequence>
  </xs:complexType>
</xs:element>

</xs:schema>
```

To parse it:
```
require('xsd_model')
raw = File.read('schema.xsd')
xsd = XsdModel.parse(raw)
#=> #<XsdModel::Elements::Document:0x000056471a3b7cb8
#@children=
# [#<XsdModel::Elements::Schema:0x000056471a4659a8
#   @children=
#    [#<XsdModel::Elements::Text:0x000056471a4307d0>,
#     #<XsdModel::Elements::Element:0x000056471a400dc8
#      @children=
#       [#<XsdModel::Elements::Text:0x000056471a3b3898>,
#        #<XsdModel::Elements::ComplexType:0x000056471a403668
#         @children=
#          [#<XsdModel::Elements::Text:0x000056471a3b2a10>,
#           #<XsdModel::Elements::Sequence:0x000056471a3d8ff8
#            @children=
#             [#<XsdModel::Elements::Text:0x000056471a3b19f8>,
#              #<XsdModel::Elements::Element:0x000056471a3b0cd8>,
#              #<XsdModel::Elements::Text:0x000056471a3c71b8>,
#              #<XsdModel::Elements::Element:0x000056471a3c62b8>,
#              #<XsdModel::Elements::Text:0x000056471a3c54f8>,
#              #<XsdModel::Elements::Element:0x000056471a3c47b0>,
#              #<XsdModel::Elements::Text:0x000056471a3dbaa0>,
#              #<XsdModel::Elements::Element:0x000056471a3da830>,
#              #<XsdModel::Elements::Text:0x000056471a3d9930>]>,
#           #<XsdModel::Elements::Text:0x000056471a403cf8>]>,
#        #<XsdModel::Elements::Text:0x000056471a4014a8>]>,
#     #<XsdModel::Elements::Text:0x000056471a4660b0>],
#   >],
#>
```

### TODO
* basic parsing
* ignore option
* collect only option
* basic api - children, attributes, namespaces
* navigation shorthands(`#elements`)
* imports
* includes
* `Schema` api
* comparison

...

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
