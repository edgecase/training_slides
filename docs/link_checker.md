# Link Checking Lab

## Goals

* Build a complete and functional Ruby script
* Learn the canonical structure of a typical Ruby project
* Learn how to handle command line parsing.

## Lab

### Part 1 -- Create a project structure

Create a directory called check_links to start your new Ruby project.
Within that directory, create the following directory structure.  This
is a typical Ruby structure.

    check_links         -- Top level project directory
      Rakefile          -- Project level makefile
      Gemfile           -- Gem dependency specification
      Gemfile.lock      -- Gem dependency lock down
      lib               -- Directory for Ruby source
      bin               -- Directory for command line scripts
      spec              -- Directory for unit and other tests a

#### Hint - Gemfile (click to view)

%hideon

Here is our Gemfile

%code "labs/check_links/Gemfile"

%hideoff

#### Hint - Rakefile (click to view)

%hideon

Here is our Rakefile

%code "labs/check_links/Rakefile"

%hideoff

### Part 2 -- Import your pre-existing code

Now take the code from the HTML parsing labs and import it into the
project.  Since it is good practice to use namespaces in projects that
are likely to be shared, you should do the following for both the
HtmlParser and the UrlFetcher:

* Move the source code into a subdirectory of lib.  The subdirectory
  will have the same name as the project.  This provides a namespace
  for the require commands.  Your project directory should look like
  this:

<pre>
check_links
  ...
  lib
    check_links
      html_parser.rb
      url_fetcher.rb
  ...
  spec
    check_links
      html_parser_spec.rb
      url_fetcher_spec.rb
</pre>

* Nest the Ruby classes within a module named CheckLinks.  This
  provides a namespace for the Ruby source code.  The code should look
  like this:

<pre>
module CheckLinks
  class UrlFetcher
    ...
  end
end
</pre>

#### Hint - Source for HtmlParser (click to view)

%hideon

If you don't have a working HtmlParser class, you can use ours:

%code "labs/check_links/lib/check_links/html_parser.rb"

%hideoff

#### Hint - Source for UrlFetcher (click to view)

%hideon

If you don't have a working UrlFetcher class, you can use ours:

%code "labs/check_links/lib/check_links/url_fetcher.rb"

%hideoff

### Part 3 -- Write a link checking class

Here's the meat of the lab.  Write a new class called LinkChecker that
uses UrlFetcher and HtmlParser that checks all the links on a web site
to make sure they are still valid.

The use case for LinkChecker should be something like this:

    checker = LinkChecker.new
    checker.check(base_url, prefix)

    checker.good_urls   -- list of all the working URLs found
    checker.bad_urls    -- list of all urls that failed

Effectively this means that a LinkChecker checker object starts by
fetching the first page of a web-site and extracts all the URLs from
it.  It then fetches each of the URLs on that initial page and makes
sure that each URL is a valid link.  If a fetched URL is also part of
the web site, then any URLs on that page are also queued for
checking.  The link checker continues to check URLs until the list of
unchecked URLs is empty.

You will also need to keep track of URLs that have already been
checked, so that you don't download a link that has already been
verified.

#### Hint - Pseudo-code for the Link checker

%hideon

Here is the basic algorithm written in more or less Ruby:

    seen = {}
    good_urls = []
    bad_urls = []
    unchecked_urls = [initial_url]

    while ! unchecked_urls.empty?
      url = unchecked_urls.shift
      seen[url] = true
      html = fetch(url)
      if html.nil?
        bad_urls << url
      else
        good_urls << url
        if url starts with the prefix
          new_urls = parse(html)
          new_urls.each do |u|
            unchecked_urls << u unless seen[url]
          end
        end
      end
    end

%hideoff

#### Hint - Specification for LinkChecker

%hideon

We make testing the link checker very easy by using a FauxFetcher and
FauxParser class.  This allows us to easily specify each page and what
links it has without actually have fetch pages from the web.

Here are the Faux classes for testing.

%code "labs/check_links/spec/spec_helper.rb", faux

It is also helpful to use a matcher for nice error messages when
comparing lists of urls.  Here is the RSpec matcher we use.

%code "labs/check_links/spec/spec_helper.rb", matcher

And finally, here is the complete specification for the CheckLinks class.

%code "labs/check_links/spec/check_links/link_checker_spec.rb"

%hideoff

#### Hint - Source for LinkChecker

%hideon

%code "labs/check_links/lib/check_links/link_checker.rb"

%hideoff

### Part 4 -- Tie it together with main program

Finally, we need to write a top level Ruby script that ties the whole
thing together, reading URL and prefix from the command line and
creating and invoking the LinkChecker object.

The "check-links" file should go in the bin directory.

The main program/main script file has several responsibilities.  It
should

* Read any command line options and handle them appropriately.

* Create the initial classes (LinkChecker in this case) and invoke it
  with the correct URL and prefix (if a prefix was given).

The command line options to be supported are:

* **-p** *prefix_url* -- A prefix URL.  Only pages that have a url
  that starts with the prefix will be scanned for additional URLs.
  This prevents the link_checker from going wild and downloading the
  entire web.

* **-v** -- Display the version of the program and exit.

You can use the [optparse
library](http://ruby-doc.org/stdlib-1.9.3/libdoc/optparse/rdoc/OptionParser.html)
to handle the command line arguments

You should be able to invoke check-links as follows:

    ruby -Ilib bin/check-links -p http://site.com/something http://site.com/something/index.html

**NOTE:** *Running the command with "ruby -Ilib" is inconvenient, but
that will be addressed when we gem-ify the project.

#### Hint - Using optparse

%hideon

The [documentation for
optparse](http://ruby-doc.org/stdlib-1.9.3/libdoc/optparse/rdoc/OptionParser.html)
is fairly good, but here are some additional hints.

I like to isolate the option handling in a method (generally called
handle\_options).  I like to pass ARGV as an argument to this method
(allows for easier testing if I feel its warrented) and return a
option hash as the result.  The structure of the handle\_options method
is something like this:

    def handle_options(args)
      options = { ... default values for options here ... }
      parser = OptionParser.new do |opts|
        opts.banner = "Usage: example.rb [options]"

        opts.on("-v", "--version", "Display the version") do |value|
          puts "Version 1.0"
          exit
        end

        opts.on("-l", "--logging=level", "Site prefix URL") do |value|
          options[:logging] = value.to_i
        end
      end
      options       # return the options hash
    end

%hideoff

#### Hint - The handle_options source

%hideon

%code "labs/check_links/bin/check-links", opts

%hideoff

#### Hint - Source for check-links

%hideon

Here is the complete source code for the check-links file.

%code "labs/check_links/bin/check-links"

%hideoff

<hr>
[back](index.html)
