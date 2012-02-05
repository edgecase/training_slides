# Event Machine Lab

## Goals

* Learn about event driven programming.
* Learn how to increase overall performance without threading.

## Lab

Our current version of check-link is throttled by a fetch/parse loop.
A fetch of a web-page can take a long time, during which the
check-links script cannot do another other work.

There are several ways to solve this.  In this lab we will using event
machine to allow us to issue HTTP requests in parallel and really
speed up the program.

### Step 1 -- Prepare for Callback Oriented Programming

Event driven code has a heavy emphasis on callbacks. Our current
fetch/parse loop it too tightly coupled to ease in callbacks without
some changes.

Our main loop looks something like this (greatly simplified):

    while ! unchecked_urls.empty?
      url = unchecked_urls.shift
      body = fetch(url)
      parse(body)
    end

The code hardcodes the interleaving of fetching and parsing.  For
every fetch, there is a parse operation.  The next fetch cannot be
started until the current cycle is done.

Event driven callback style programming breaks this hard coded
interleaving by introducing a callback.  This style would write the
loop as this:

    while ! unchecked_urls.empty?
      url = unchecked_urls.shift
      fetch(url) do |body|
        parse(body)
      end
    end

Essentially the code that executes after the fetch is moved into a
block that will get called whenever the fetch is done and ready to
hand-off the body to the parser.

Your first step to using event driven program is to convert your
UrlFetcher to using a callback, and modify the LinkChecker class to
call it appropriately.

#### Hint - Source for run method

%hideon

Here is the link fetcher class written in callback style.

    module CheckLinks
      class UrlFetcher
        def fetch(url, &block)
          body = open(url) { |f| f.read }
          block.call(body)
        rescue StandardError => ex
          block.call(nil)
        end
      end
    end

And here is the run method using the callback style fetcher.

    def run
      while ! @unchecked_urls.empty?
        url = @unchecked_urls.pop
        next if seen?(url)
        mark_seen(url)
        @fetcher.fetch(url) do |body|
          if body.nil?
            @bad_urls << url
          else
            @good_urls << url
            if has_prefix?(url)
              new_urls = parse(url, body)
              add_urls(new_urls)
            end
          end
        end
      end
    end

%hideoff

### Step 2 -- A EventMachine Friendly URL Fetcher

Our current URL fetcher will block while waiting on a URL.  We need to
use an EventMachine friendly version, and the em-http-request gem is
just what we need.  Add the following lines to your Gemfile and
re-bundle.

    gem 'eventmachine'
    gem 'em-http-request'

To make an HTTP request with this library, create an request object
and call 'get' on it ...

    http = EventMachine::HttpRequest.new("http://somewhere.com").get

Now add callbacks to the http object.  These callbacks specify what is
to happen when the http request completes.

    http.callback do
      puts http.response_header.status
      puts http.response
    end

If there is an error, an error callback will called instead of the
normal callback.  Use the creatively named "errback" method to define
the error callback.

    http.errback do
      puts "There was an error"
    end

One more thing.  The non-EventMachine version of the link checker
terminated when the unchecked URLs list became empty.  Since we no
longer have a unchecked URL list, we need another way to tell when we
are done.  A simple thing to do is let the URL fetcher keep track of
the number of outstanding fetch requests.

Add a <code>busy?</code> method to the URL fetcher that is true
whenever there are URL fetch requests that have not yet invoked their
callbacks.

A simple way to accomplish this is to keep an outstanding_request
counter that is incremented every time a fetch is initiated and is
decremented in both the successful and error callbacks.  The method
<code>busy?</code> should return true if the outstanding request
counter is greater than zero.

So, to summarize step 2, create a new class called EmFetcher that uses
the em-http-library to fetch URLs.  Add a <code>busy?</code> method
that is true whenever there are outstanding fetch requests.

#### Hint -- Demonstration of em-http-request

%hideon

Here is a quick standalone program that uses the em-http-request
library with EventMachine.

    require 'eventmachine'
    require 'em-http'

    EventMachine.run {
      http = EventMachine::HttpRequest.new('http://onestepback.org/articles/depinj/index.html').get

      http.errback { p 'Uh oh'; EM.stop }
      http.callback {
        p http.response_header.status
        p http.response_header
        p http.response

        EventMachine.stop
      }
    }

%hideoff

#### Hint -- Code for EmFetcher

%hideon

%code "labs/eventmachine/lib/check_links/em_fetcher.rb"

%hideoff

### Step 2 -- Add Event Machine Infrastructure

Now we are ready to actually add EventMachine into our main code
base. You will want to make the following changes.

1. Modify the main script to use the EmFetcher class rather than the
   non-EventMachine UrlFetcher version.

1. Add require 'eventmachine' to the LinkChecker file.

1. Remove the explicit while loop from the LinkChecker module and
   depend on the callbacks to keep the URLs coming.

1. At the end of the callback, make sure you check
   <code>fetcher.busy?</code> and terminate the event loop whenever
   the fetcher is not busy.

1. Add <code>EventMachine.run { ... }</code> around the code that does
   the link checking.

   You can choose to add it in the main script, or in the LinkChecker
   class.  We chose to add it to LinkChecker.

   **BONUS QUESTION:**
   *Discuss the advantages and disadvanges of the event run loop in
   the main script VS just the LinkChecker).

#### Hint -- The Run Loop

%hideon

We choose to put the event run loop in the LinkChecker in the check
method, but only around the check_url method (where all the action
happens).

%code "labs/eventmachine/lib/check_links/link_checker.rb", runloop

%hideoff

#### Hint -- Checking a URL

%hideon

The guts of checking a url now happen in the <code>check_url</code>
method.  A

We choose to put the event run loop in the LinkChecker in the check
method, but only around the check_url method (where all the action
happens).

%code "labs/eventmachine/lib/check_links/link_checker.rb", checkurl

%hideoff

#### Hint -- The Complete Solution

%hideon

Here are all the classes and the main script for the final solution

**bin/check-links**
%code "labs/eventmachine/bin/check-links"

**lib/check\_links/link\_checker.rb**
%code "labs/eventmachine/lib/check_links/link_checker.rb"

**lib/check\_links/em\_fetcher.rb**
%code "labs/eventmachine/lib/check_links/em_fetcher.rb"

**lib/check\_links/html\_parser.rb**
%code "labs/eventmachine/lib/check_links/html_parser.rb"

%hideoff

<hr>
[back](index.html)
