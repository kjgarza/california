require 'maremma'
require 'json_api_client'


URL = "https://api.datacite.org"
OUTPUT = "errors.txt"

module MyApi
  # this is an "abstract" base class that
  class Base < JsonApiClient::Resource
    # set the api base url in an abstract base class
    self.site = "https://api.datacite.org"
  end

  class Events < Base
    # custom_endpoint :search, on: :collection, request_method: :get
  end
end

def get_events(page,size)
  Maremma.get("#{URL}/events?source-id=datacite-related,datacite-crossref&query=created_at%3A%7B2019-09-01+TO+2019-09-30%7D&page[size]=#{size}").body["data"].to_a

  # MyApi::Events.where(source_id: "datacite-related,datacite-crossref", query:"created_at:{2019-09-01 TO 2019-09-30}").per(size).to_a
end

def get_prefix(doi)
  doi[/(10\.\d{4,5})/,1]
end


def get_agency(prefix)
  Maremma.get("#{URL}/prefixes/#{prefix}").body.dig("data","attributes","registrationAgency")
end


def is_cr_cr(event)
  subj_prefix = event["attributes"]["subj-id"][/(10\.\d{4,5})/,1]
  puts get_agency(subj_prefix)
  save_to_file(event["id"]) if get_agency(subj_prefix) == "Crossref"
end


def save_to_file(uuid)
  File.open(OUTPUT, "a+") do |f|
    f.write(uuid)
  end
end


def main

end


get_events(1,100).lazy.each do | event|
  puts event["id"]
  is_cr_cr(event)
end
