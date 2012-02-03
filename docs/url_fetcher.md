# Fetching Web Pages

## Goals

* Learn how to fetch web pages using open-uri

## Lab

Write a class named UrlFetcher.  It has a single method named "fetch"
that takes a URL and returns the web page corresponding to the URL. If
an error occurs, or if the web page is not available, fetch should
return nil.

The easiest way to fetch web pages in Ruby is to use the [Open
URI](http://www.ruby-doc.org/stdlib-1.9.3/libdoc/open-uri/rdoc/OpenURI.html)
library that allows you to open web pages as if they were files.

Here's the outline:

    class UrlFetcher
      def fetch(url)
        # Write this code
      end
    end

#### Hint: open-uri (click to view)

%hideon

Open-URI allows you to open URLs as if they were files.  Use the block
form of open to read the string and return the result.

    html = open(url) { |stream| stream.read }

%hideoff

#### Hint: Specification (click to view)

%hideon

%code "labs/url_fetcher/url_fetcher_spec.rb"

%hideoff

#### Solution: (click to view)

%hideon

%code "labs/url_fetcher/url_fetcher.rb"

%hideoff

<hr>
[back](index.html)
