# Event Machine Lab

# Goals

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
UrlFetcher to using a callback.



<hr>
[back](index.html)
