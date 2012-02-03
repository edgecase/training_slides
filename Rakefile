#!/usr/bin/ruby -wKU

require 'rake/clean'
require './lib/file_includer'
require 'bluecloth'

DOC_FILES = FileList['docs/*.md']
HTML_FILES = DOC_FILES.pathmap("html/%n.html")

IMAGE_FILES = FileList['docs/images/*']
CSS_FILES = FileList['docs/stylesheets/*']
JS_FILES = FileList['docs/javascripts/*']

ASSET_FILES = (IMAGE_FILES + CSS_FILES + JS_FILES).pathmap("%{docs,html}p")

CLOBBER.include("html")

directory "html"
directory "html/stylesheets"
directory "html/images"
directory "html/javascripts"

task :default => :docs

task :docs => ["html"] + HTML_FILES + ASSET_FILES

ASSET_FILES.each do |asset_file|
  src = asset_file.pathmap("%{html,docs}p")
  file asset_file => ["html", asset_file.pathmap("%d"), src] do
    cp src, asset_file
  end
end

DOC_FILES.each do |doc_file|
  html_file = doc_file.pathmap("html/%n.html")
  file html_file => ['html', doc_file] + ASSET_FILES do
    puts "#{doc_file} => #{html_file}"
    template = open("docs/template.html") { |f| f.read }
    raw_content = open(doc_file) { |ins| ins.read }
    included_content = FileIncluder.include(raw_content)
    content = BlueCloth.new(included_content).to_html
    content.gsub!(%r(<p>%hideon</p>), "<div class=\"solution\">")
    content.gsub!(%r(<p>%hideoff</p>), "</div>")
    open(html_file, "w") do |outs|
      outs.write(template.gsub(/%CONTENT%/, content))
    end
  end
end
