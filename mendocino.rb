# This script gets a list of pairings for prefix and domains.
# Fixes: https://github.com/datacite/datacite/issues/435

require "addressable/uri"
require "maremma"
# require "faraday"
require 'json'
require 'zlib'
require 'base32/url'
require 'digest'
require 'yajl'
require 'dotenv/load'

require 'active_support'

REPORT ="H4sIAMvO9lsAA+2Uz27bMAzGX8XweartNMu/19hxyUGWWFuALHkS1S0b8u6jLCcO2m5A0AS55CiSH/lR+tn5n23uoLcOWQtcgtvmmylkeAcUiGdvdUBlTZZS2/zLqUrJoYZzPkY1cJ900umzSmUa1oNTVqYpNTTKMMkxFc/KasXKOSurQQNGvs/N1tv8QEnhgFJyylUVq9aDbkyxep8scORCxTaT4xelEZyn/PfdFOWITtUB4ZSAXwL6uPUQIcfCyuhnsaakh1faBdOUn9wZWm8Y0oH3vDleXGydKZ8J2/V0jR5kFjyVZs1v1Q/1LeiehXhTJGgRe78pikZhG+onUhXHDQrPfas6NYhicBCEOCuLx8wASJ+hzWrIgpkG0pXtDtOesdYDHncaj+kZYwD3/fh6Ns165TqkSFU+VV/X88KD4x3d+6z4xsrlYh4njKbYST5o95aW3JigNR2CU9OhD7VWvh2QG0NHK6hQwweVH3gUWoFJ5s+cRuHJUewYQfJvtdR3JOx/UmFN4sJOxPSa44t13XvCiO+Y4EbAOO6TxD+XiXhlPJ51FTYY+go3M0pxIeidWQfYWjli1wTN3Ygj2RfTs6BFrtn0RfvY/1Mdg1E/ArxpuYvMXQWvZfXA6154La6O1+Udb43X8oHX4+91O7xWD7zuhdfz1fG6vOON8VotHnjdC6/q6nhd3vGfeO0O+V/Fe1fZ3Q0AAA=="

def compress file
  report = File.read(file)
  # puts report
  gzip = Zlib::GzipWriter.new(StringIO.new)
  # string = report.delete!("\n").to_json
  # puts string
  # gzip << string
  string = JSON.parse(report).to_json
  # puts string
  gzip << string
  # gzip << report.to_json #for 1 liners
  body = gzip.close.string
  puts Digest::SHA256.hexdigest(body)
  body


  # puts JSON.parse(report).to_s
  # wio = StringIO.new("w")
  # w_gz = Zlib::GzipWriter.new(wio)
  # w_gz.write(Yajl::Parser.parse(report).to_s)
  # w_gz.close
  # wio.string
end


def active_compress file
  report = File.read(file)
  ActiveSupport::Gzip.compress(report.to_json)

end

def encode file
  puts Base64.strict_encode64(compress(file))
  Base64.strict_encode64(compress(file))
end

def decompress file
  report = File.read(file)
  gzip = Zlib::GzipWriter.new(StringIO.new)
  gzip << report.to_json
  body = gzip.close.string
  puts body
  body
end





def deencode_string 
  gzip = Base64.decode64(REPORT)
  puts decompress_string(gzip)
end

def decompress_string string
  Zlib::GzipReader.new(StringIO.new(string.to_s)).read
end


def deencode file
  gzip = Base64.decode64(file)
  decompress(gzip)
end


def parse file
   report = File.read(file)
   starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
# time consuming operation
    # parser = Yajl::Parser.new
    pp= JSON.parse(report)
    # puts pp.dig("report-datasets")[3]
    # puts pp.dig("report-header")
    ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
    elapsed = ending - starting
    puts elapsed # => 9.183449000120163 seconds
    pp
end

def save_as_json file
  pp = parse(file)
    File.open("#{file}_parsed.json","w") do |f|
      f.write(pp.to_json)
    end


end


def post_file file
  
  # uri = 'http://localhost:8075/reports'
  uri = URI('https://api.test.datacite.org/reports')
  # uri = 'https://api.test.datacite.org/reports'
  # uri = 'https://api.datacite.org/reports'
  puts uri
  puts file 

  headers = {
    content_type: "application/gzip",
    content_encoding: 'gzip',
    accept: 'gzip'
  }


  body = compress(file)

  starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
 
  #  => 9.183449000120163 seconds
  request = Maremma.post(uri, data: body,
    bearer: ENV['TOKEN'],
    headers: headers,
    timeout: 100)

  puts request.status
  puts request.body
  puts request.headers
  ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  elapsed = ending - starting
  puts elapsed 
end


def update_file file, id
  
  # uri = 'http://localhost:8075/reports'
  uri = URI('https://api.test.datacite.org/reports/'+ id)
  # uri = 'https://api.test.datacite.org/reports'
  # uri = 'https://api.datacite.org/reports'
  puts uri
  puts file 

  headers = {
    content_type: "application/gzip",
    content_encoding: 'gzip',
    accept: 'gzip'
  }


  body = compress(file)

  starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
 
  #  => 9.183449000120163 seconds
  request = Maremma.put(uri, data: body,
    bearer: ENV['TOKEN'],
    headers: headers,
    timeout: 100)

  puts request.status
  puts request.body
  puts request.headers
  ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
  elapsed = ending - starting
  puts elapsed 
end



# def post_file_normal file
  
#   uri = 'http://localhost:8075/reports'
#   # uri = URI('https://api.test.datacite.org/reports')
#   # uri = 'https://api.test.datacite.org/reports'
#   # uri = 'https://api.datacite.org/reports'
#   puts uri
#   puts file 

#   headers = {
#     content_type: "application/json",
#   }


#   body = (File.read(file))

#   starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
 
#   #  => 9.183449000120163 seconds
#   request = Maremma.post(uri, data: body,
#     bearer: ENV['TOKEN'],
#     headers: headers,
#     timeout: 100)

#   puts request.status
#   puts request.body[0...50]
#   puts request.headers
#   ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
#   elapsed = ending - starting
#   puts elapsed 
# end


# def put_file_normal file
  
#   # uri = 'http://localhost:8075/reports'
#   # uri = URI('https://api.test.datacite.org/reports')
#   # uri = 'https://api.test.datacite.org/reports'
#   id = "9176cdba-5ff4-4f08-9a35-f2a39eb27c25"
#   uri = 'https://api.datacite.org/reports'+"/"+id
#   puts uri
#   puts id 

#   headers = {
#     content_type: "application/json",
#   }


#   body = (File.read(file))

#   starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
 
#   #  => 9.183449000120163 seconds
#   request = Maremma.put(uri, data: body,
#     bearer: ENV['TOKEN'],
#     headers: headers,
#     timeout: 100)

#   puts request.status
#   puts request.body[0...50]
#   puts request.headers
#   ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
#   elapsed = ending - starting
#   puts elapsed 
# end

# def compress_merged_file
#   report = File.read(merged_file)
#   gzip = Zlib::GzipWriter.new(StringIO.new)
#   # gzip << report.delete!("\n").to_json
#   gzip << report.to_json
#   body = gzip.close.string
#   body    
# end

def merged_file
  "reports_large/datacite_resolution_report_2018-09_2.json"
end

def encoded
  Base64.strict_encode64(compress_merged_file)
end

def checksum
  Digest::SHA256.hexdigest(compress_merged_file)
end

def encoded_file
  "reports_large/datacite_resolution_report_2018-09_encoded.json"
end 

# def report_compressed 
#   report = 
#   {
#     "report-header": get_header,
#     gzip: encoded,
#     checksum: checksum
#   }

#   File.open(encoded_file,"w") do |f|
#     f.write(JSON.pretty_generate report)
#   end
# end


# def get_header 
#   {
#     "report-name": "resolution report",
#     "report-id": "dsr",
#     release: "drl",
#     created: "2018-11-27",     #Date.today.strftime("%Y-%m-%d"),
#     "created-by": "datacite",
#     "reporting-period": {
#       "begin-date": "2018-09-01",
#       "end-date": "2018-09-30"
#     },
#     "report-filters": [],
#     "report-attributes": [],
#     exceptions: [{code: 69,severity: "warning", message: "Report is compressed using gzip","help-url": "https://github.com/datacite/sashimi",data:"usage data needs to be uncompressed"}]
#   }
# end





# def put_file file
  
#   # uri = 'http://localhost:8075/reports'
#   # uri = URI('https://api.test.datacite.org/reports')
#   # uri = 'https://api.test.datacite.org/reports'
#   id = "23f0e6d8-e8c6-4b2c-8dc9-79437ea234ad"
#   uri ="https://api.datacite.org/reports"+"/"+id

#   headers = {
#     content_type: "application/gzip",
#     content_encoding: 'gzip',
#     accept: 'gzip'
#   }


#   body = compress(file)
#   starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
 
#   # => 9.183449000120163 seconds
#   request = Maremma.put(uri, data: body,
#     bearer: ENV['TOKEN'],
#     headers: headers)

#   puts request.status
#   # puts request.body
#   puts request.headers
#   ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
#   elapsed = ending - starting
#   puts elapsed 
# end


# def faraday_file file
  
#   # uri = URI('http://localhost:8075/reports')
#   uri = URI('https://api.test.datacite.org')


#   body = compress(file)
#   starting = Process.clock_gettime(Process::CLOCK_MONOTONIC)
 
#   # => 9.183449000120163 seconds
#   conn = Faraday.new(:url => uri) do |faraday|
#     faraday.request  :url_encoded             # form-encode POST params
#     faraday.response :logger                  # log requests to $stdout
#     faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP

#   end


#   conn.post do |req|
#     req.url '/reports'
#     req.headers['Content-Type'] = 'json'
#     req.headers['Content-Encoding'] = 'gzip'
#     # req.headers['accept'] = 'json'
#     req.body = body
#   end

#   # puts request.status
#   # # puts request.body
#   # puts request.headers
#   ending = Process.clock_gettime(Process::CLOCK_MONOTONIC)
#   elapsed = ending - starting
#   puts elapsed 
# end




post_file("cdl_report.json")
# update_file("cdl_report.json","07bdf5a9-9387-430d-abc3-0415a4f34f3b")


# post_file("reports_large/dash_large.json")
# post_file("reports_large/dash_large_wrong.json")


# post_file("reports_large/datacite_resolution_report_2018-08.json")
# post_file_normal("reports_large/datacite_resolution_report_2018-09_encoded.json")
# post_file("reports_large/datacite_resolution_report_2018-09_2.json")
# post_file("/Users/kristian/datacite/kishu/reports/datacite_resolution_report_2018-09_2.json")

# post_file("reports_large/datacite_resolution_report_2018-04.json_parsed.json")
# save_as_json("reports_large/datacite_resolution_report_2018-04.json")
# report_compressed
# post_file_normal("reports_large/datacite_resolution_report_2018-08-encoded.json")
# put_file_normal("reports_large/datacite_resolution_report_2018-08-encoded.json")
# deencode_string

# compress("/Users/kristian/Downloads/2013-11-report/2013-11-pretty-print.json")
# post_file("reports_large/small_dataone")
# post_file("/Users/kristian/datacite/kishu/reports/datacite_resolution_report_2018-10_2.json")
# post_file("/Users/Kristian/Downloads/DSR-D1-2012-07-31-urn-node-PISCO.json")
