# RubyGems Lab

## Goals 

* Learn how to package your project as a gem
* Learn how to install your gem from a file

## Create a Gem from the project

We have created our project for checking links. We now want to distribute it for our friends to use and so that we can install it on other machines. 

### Step 1

Take the last lab you did ([Meta-Programming](meta_programming.html)) and create a gem out of it. You will need to create your .gemspec file. Make sure your directories are setup correctly and create the gem.

You can use this as your blank .gemspec file. Make sure you include your files. Hint: use a FileList from rake. 

%code "labs/rubygems/blank.gemspec"

#### Hint - Source for gemspec

%hideon

%code "labs/rubygems/check-links.gemspec"

%hideoff


### Step 2

Run the command to build the gem:

    $ gem build check-links

Run the command to install the gem: 

    $ gem install check-links-0.1.0.gem 

Now test to ensure your binary works:

    $ check-links -h

#### Extra Information

Naming can be hard. When do you use a dash, when an underscore. Here are some hints on naming your gem:
* If it's a compound name use an underscore (example: 'url_fetcher)
* If it is a plugin for another gem use a dash in the name and a slash in the require (example: 'rspec-given' name and 'require 'rspec/given' in the file)

[Back](index.html)
