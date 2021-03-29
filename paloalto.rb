
# This script gets a list of pairings for prefix and domains.
# Fixes: https://github.com/datacite/datacite/issues/435

require "addressable/uri"
require "maremma"
require 'csv'


API_URL = "https://api.datacite.org"

def get_prefixes
  query = "#{API_URL}/prefixes?state=with-client&page[size]=1000&page[number]=2"
  # query = "#{API_URL}/prefixes?state=with-client&page[size]=1&page[number]=1"
  json = Maremma.get(query).body.dig("data")
  json.map { |item| item.dig("id") }
end

def get_host prefix
  puts prefix
  # prefix = "10.3206"
  # query = "#{API_URL}/works?query=doi:#{prefix}*%20AND%20url:*&sample=1"
  query = "#{API_URL}/works?query=doi:#{prefix}*&sample=1"
  json =  Maremma.get(query).body.dig("data").first
  return "" unless json.respond_to?("dig")
  puts json.class
  url = json.dig("attributes","url")
  uri = Addressable::URI.parse(url)
  return resolve_doi(json.dig("id")) unless uri.respond_to?("host")
  uri.host
end

def resolve_doi doi
  # puts doi
  json =  Maremma.head(doi, limit: 0)
  # puts json
  uri = Addressable::URI.parse(json.headers["location"])
  puts uri.host
  return "" unless uri.respond_to?("host")
  uri.host
end

def loop_list list
  list.map do |prefix| 
    {prefix: prefix, host: get_host(prefix), from: "datacite"}
  end
end

def to_csv data
  CSV.open("prefixes4.csv", "wb") do |csv|
    csv << data.first.keys # adds the attributes name on the first line
    data.each do |hash|
      csv << hash.values unless hash[:host].empty?
    end
  end
end

def main
  list = get_prefixes
  loaded_list = loop_list list
  to_csv loaded_list
end

main










