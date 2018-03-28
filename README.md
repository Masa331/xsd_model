# XsdModel [![Build Status](https://travis-ci.org/Masa331/xsd_model.svg?branch=master)](https://travis-ci.org/Masa331/xsd_model)

*Note that this can be unstable until 1.0.0*

Takes a XSD string and parses it into a tree structure of nodes. A lot similar to Nokogiri but with few more useful methods.

Content:
1. [About](#about)
2. [Api](#api)
5. [License](#license)

## About

This gem provides a parser which takes XSD in a string and outputs tree structure of objects much like Nokogiri(which is internally used for parsing) does with XML. Each returned object represents one specific XSD core element and implements specific API to simplify the work with XSD. As it's written under the top heading, the API can be unstable until 1.0.0 and might miss some core XSD elements, attribute accessors, etc.

## Api

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
