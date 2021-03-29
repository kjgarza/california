require "base64"
require 'json'
require 'dotenv/load'

API_URL = "https://mds.test.datacite.org"

def post_metadata type, datafile, doi
  begin
    content = "Content-Type:#{type};charset=utf-8"
    credentials = {username: "DEMO.DATACITE", password: ENV["PASSWORD_DEMO"] }
    session = "#{credentials[:username]}:#{credentials[:password]}"
    request = "http -v  -a #{session} POST #{API_URL}/metadata/#{doi} < #{datafile} #{content} "
    # request = "http -v  -a #{session} POST #{API_URL}/metadata #{content} < #{datafile}"
    puts "`#{request}`" 
    system( request )
    puts ""
    # puts "```"
    # system( "http -a #{session} GET #{API_URL}/metadata/#{doi}" )
    # puts "```"
  rescue
    nil
  end
end

def validate_request

  puts "## Metadata in DataCite xml"
  type = "application/xml"
  datafile = "files/datacite.xml"
  doi = "10.70043/4K3M-NYVG"
  post_metadata type, datafile, doi

  # puts "## Metadata in RDF XML  "
  # type = "application/rdf+xml"
  # datafile = "files/datacite.rdf"
  # doi = "10.70043/1015681AA"
  # post_metadata type, datafile, doi

  # puts "## Metadata in RDF Turtle  "
  # type = "text/turtle"
  # datafile = "files/datacite.trt"
  # doi= "10.70043/1015681WAS"
  # post_metadata type, datafile, doi
 
  puts "## Metadata in Citeproc JSON "
  type = "application/vnd.citationstyles.csl+json"
  datafile = "files/citeproc.json"
  doi = "10.70043/4k3m-nyvg"
  post_metadata type, datafile, doi

  puts "## Metadata in Schema.org in JSON-LD  "
  type = "application/vnd.schemaorg.ld+json"
  datafile = "files/schema_org.json"
  doi ="10.70043/4K3M-NYVGX"
  post_metadata type, datafile, doi

  puts "## Metadata in Codemeta "
  type = "application/vnd.codemeta.ld+json"
  datafile = "files/codemeta.json"
  doi = "10.70043/F1M61H5XD"
  post_metadata type, datafile, doi

  # puts "## Metadata in Formatted text citation "
  # type = "text/x-bibliography"
  # datafile = "files/datacite.cit"
  # doi = "10.70043/1015681XW"
  # post_metadata type, datafile, doi

  puts "## Metadata in RIS "
  type = "application/x-research-info-systems"
  datafile = "files/crossref.ris"
  doi = "10.70043/eLife.01567d"
  post_metadata type, datafile, doi
  
  puts "## Metadata in BibTeX "
  type = "application/x-bibtex"
  datafile = "files/crossref.bib"
  doi = "10.70043/elife.01567D"
  post_metadata type, datafile, doi
 

end

def validate_random

  puts "## Metadata in DataCite xml"
  type = "application/xml"
  datafile = "files_random/datacite.xml"
  doi = "10.70043"
  post_metadata type, datafile, doi

  # puts "## Metadata in RDF XML  "
  # type = "application/rdf+xml"
  # datafile = "files_random/datacite.rdf"
  # doi = "10.70043/1015681AA"
  # post_metadata type, datafile, doi

  puts "## Metadata in RDF Turtle  "
  type = "text/turtle"
  datafile = "files_random/datacite.trt"
  doi= "10.70043"
  post_metadata type, datafile, doi
 
  puts "## Metadata in Citeproc JSON "
  type = "application/vnd.citationstyles.csl+json"
  datafile = "files_random/citeproc.json"
  doi = "10.70043"
  post_metadata type, datafile, doi

  puts "## Metadata in Schema.org in JSON-LD  "
  type = "application/vnd.schemaorg.ld+json"
  datafile = "files_random/schema_org.json"
  doi ="10.70043"
  post_metadata type, datafile, doi

  puts "## Metadata in Codemeta "
  type = "application/vnd.codemeta.ld+json"
  datafile = "files_random/codemeta.json"
  doi = "10.70043"
  post_metadata type, datafile, doi

  puts "## Metadata in RIS "
  type = "application/x-research-info-systems"
  datafile = "files_random/crossref.ris"
  doi = "10.70043"
  post_metadata type, datafile, doi
  
  puts "## Metadata in BibTeX "
  type = "application/x-bibtex"
  datafile = "files_random/crossref.bib"
  doi = "10.70043"
  post_metadata type, datafile, doi
 

end

def validate_random_seq

  puts "## Random DOI with prefix"
  type = "application/xml"
  datafile = "files_random/datacite.xml"
  doi = "10.70043"
  post_metadata type, datafile, doi

  puts "## Random DOI with non-prefix"
  type = "application/xml"
  datafile = "files_random/datacite.xml"
  doi = "10.7004"
  post_metadata type, datafile, doi

  puts "## Random DOI with number"
  type = "application/xml"
  datafile = "files_random/datacite.xml"
  doi = "10.70043?number=77"
  post_metadata type, datafile, doi

end

# validate_request
# validate_random
validate_random_seq