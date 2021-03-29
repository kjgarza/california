#### this scripts extracts the gzipped usage reports 
### ruby kern.rb report_id

require "addressable/uri"
require "maremma"
require "faraday"
require 'json'
require 'zlib'
require 'base32/url'
require 'digest'


API = "https://api.datacite.org/reports"
UID = ARGV[0]

def get_report uid
  url = API + "/" + uid
  Maremma.get(url)
end

def decompress_string string
  Zlib::GzipReader.new(StringIO.new(string.to_s)).read
end

def deencode subset
  gzip = Base64.decode64(subset)
  decompress_string(gzip)
end


def save_to_file string
  file_name = UID + "_" + Time.now.to_s + ".json"
  File.open(file_name,"w") do |f|
    f.write(JSON.pretty_generate string)
  end
end

def save_compressed_subset uid
  # puts get_report(uid).body["data"]
  get_report(uid).body.dig("data","report","report-subsets").each do |subset|
    save_to_file(deencode(subset.dig("gzip")))
  end
end


save_compressed_subset ARGV[0]