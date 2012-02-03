# Meta-Programming

## Goals

* Learn about some basic meta-programming in Ruby

## Lab

This lab will build upon the check-links program developed in the last lab.

The check-links program will chug away on a web-site for quite awhile,
producing no output until the very end.  It would be nice to add some
(optional) logging to the program so we can monitor its progress.

### Step 1 -- Add a logging level command line option

Modify the main program to accept a **-l***n* option that sets a
logging level.  The logging levels are:

* 0 -- No logging (just like the original). This is the default
  behavior.

* 1 -- Log any fetch operations. Display the URL involved.

* 2 -- Log any fetch or parse operation. Display the URL involved.

#### Hint - changes to optparse

%hideon

Initial value for the logging option.

%code "labs/metaprogramming/bin/check-links", opts1

Handle the "-l" command line option

%code "labs/metaprogramming/bin/check-links", opts2

%hideoff

### Step 2 -- Add a Logging Wrapper

An easy way to get logging is to use a logging version of the
UrlFetcher and the HtmlParser.  It is easy enough to write a
LoggingUrlFetcher that decorates our existing UrlFetcher.  It might
look something like this:

    class LoggingUrlFetcher
      def initializer(fetcher)
        @fetcher = fetcher
      end
      def fetch(url)
        puts "fetch: #{url}:
        @fetcher.fetch(url)
      end
    end

All the hard work is still done by the original UrlFetcher, but the
logging version will print a quick log message before handing the URL
to the original.

The problem is that we have to write almost (but not quite) the exact
same code for the LoggingHtmlParser.  It would be nice if we could
write a single class that handled both the fetcher and the parser.

What we want is something that allows us to do this:

    fetcher = CheckLinks::UrlFetcher.new
    fetcher = LogWrapper.new(:fetch, fetcher) if options[:logging] > 0

    parser  = CheckLinks::HtmlParser.new
    parser  = LogWrapper.new(:parse, parser) if options[:logging] > 1

If the log level is high enough, the fetcher/parser will be replaced by a
logging wrapper that logs a message before calling :fetch/:parse on
the corresponding object.

#### Hint - Using define_method

%hideon

There is a define_method method that allows you to dynamically define
methods on a class.  It is typically used like this:

    class Something
      class << self
        # Create an instance method named "method_name".
        define_method(:method_name) do |args|
          method_code_goes_here
        end
      end
    end

It is a class method, so it must be invoked in the context of a class
(hence the "class << self").

So, our log wrapper needs something like this in its initialize
method:

    def initialize(method_name, object)
      ...
      self.class.define_method(method_name) do |*args|
        # code to log the call to method name
        # code to forward the argument list to the original object.
      end
    end

Unfortunately, "define_method" is a private method, so if you are
invoking it with an explicit object, you need to write this:

    def initialize(method_name, object)
      ...
      self.class.send(:define_method, method_name) do |*args|
        # code to log the call to method name
        # code to forward the argument list to the original object.
      end
    end

%hideoff


#### Hint - Source for LogWrapper

%hideon

Here is the source for the log wrapper

%code "labs/metaprogramming/bin/check-links", wrapper

And here is how we use the log wrapper.

%code "labs/metaprogramming/bin/check-links", wrapping

%hideoff

#### Hint - Full Source for Logging check-links

%hideon

Here is the full source for the check-links.

%code "labs/metaprogramming/bin/check-links"

%hideoff

<hr>
[back](index.html)
