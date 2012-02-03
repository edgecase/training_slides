# HTML Parsing Lab

## Goals

* Learn about Nokogiri and parsing HTML and XML documents

## Lab

Write a class named HtmlParser.  The class should have a single method
named parse that takes a string of HTML text and returns a list of URL
links found in the document.  The URLs returned should be absolute
URLs (i.e. relative links should be normalized to be full URLs).

You can use [Nokogiri](http://nokogiri.org/) to parse the HTML string.
The Ruby
[URI](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/uri/rdoc/URI.html#method-c-parse)
library is useful for converting relative URLs to the full thing.

Here's the outline:

    class HtmlParser
      def parse(html_string)
        # Write this code
      end
    end

#### Hint: Nokogiri (click to view)

%hideon

You can get a Nokogiri DOM document by parsing the string

    doc = Nokogiri::HTML(html_string)

Links can be extracted from the document using the "css" method.

    links = doc.css('a')

Each link represents an '<a href="...">...</a>' tag.  You can get the
href with:

    href = link.attribute['href']

%hideoff

#### Hint: URI (click to view)

%hideon

URI can be used to parse a URL string.

    uri = URI.parse(url_string)

To create an absolute reference from a relative, you will need to
merge the relative URL with the source URL.

    uri = URI.parse(source_url_string).merge(URI.parse(relative_url_string))

%hideoff

#### Hint: Specification (click to view)

%hideon

%code "labs/html_parser/html_parser_spec.rb"

%hideoff

#### Solution: (click to view)

%hideon

%code "labs/html_parser/html_parser.rb"

%hideoff

<hr>
[back](index.html)
