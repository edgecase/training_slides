# Rake Lab

## Goal

* Learn the difference between task and file targets.
* Learn about file lists

## Lab

You have documentation for your project contained in a "docs"
directory.  The documents are written in "markdown" (a common plain
text markup language).  You wish to convert these files into a set of
HTML documents that can be read in a standard browser.

You can convert markdown document to HTML easily enough with the
BlueCloth gem.  The following snippet of code will read a markdown
file and write an html file.

    content = open("doc.md") { |f| f.read }
    html = BlueCloth.new(content).to_html
    open("doc.html", "w") { |f| f.write(html) }

### Part 1: Convert a Single File

Write a file task that creates "html/index.html" from the source file
in "docs/index.md".

#### Solution: (click to view)

%hideon

    file "html/index.html" => "docs/index.md" do |t|
      source = t.name.pathmap("docs/%n.md")
      content = open(source) { |f| f.read }
      html = BlueCloth.new(content).to_html
      open(t.name, "w") { |f| f.write(html) }
    end

%hideoff

### Part 2: Convert Multiple Files

Writing a conversion task for each markdown file will quickly get
tedious. Use a FileList and a loop to write all the tasks at once.

It may help to know that you can easily get the name of the HTML file
from the doc file with a rake pathmap expression.

    "doc/index.md".pathmap("html/%n.html")  # => "html/index.html"

#### Solution: (click to view)

%hideon

The key is to create a file list of document files that can

%code "labs/rake/Rakefile", step2

%hideoff

### Part 3: Add a convenience task (docs) and default task

Create a single task named :docs the will build all the HTML files.
Also create a task named :default that will also build the
documentation (the :default task is run whenever rake is invoked
without an explicit task).

#### Solution: (click to view)

%hideon

Create a file list derived from the list of document files from step
2.  Then make a :docs task depend on the HTML files.  Whenever the
docs task is invoked, rake will build the HTML files as dependencies.

%code "labs/rake/Rakefile", step3

%hideoff


### Full Solution

Parts 2 & 3 combined:

#### Solution: (click to view)

%hideon

%code "labs/rake/Rakefile"

%hideoff
