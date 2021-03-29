require 'maremma'
require 'sucker_punch'
require 'sucker_punch/async_syntax'
require 'dotenv/load'

API_URL = 'https://api.datacite.org'
USERNAME = "admin"
PASSWORD = ENV["PASSWORD"]


class DoiUpdateJob
  include SuckerPunch::Job
  SuckerPunch.shutdown_timeout = 200 # # of sec. to wait before killing threads

  workers 10

  def perform(doi, options)
    Doi.new.update_rest_doi(doi, options)
  end
end



class Bulker

  include SuckerPunch::Job

  def run
    pages = fetch_paginated_data
    
    pages.each do |page|
      page.each do |item|
          doi = item.dig("id")
          options = {}
          options[:data] = Doi.new.generate_state_change_template()
          DoiUpdateJob.perform_async(doi, options)
      end
    end

    puts "completed"
  end

  def fetch_paginated_data
    Enumerator.new do |yielder|
      page = 1

      loop do
        results = Doi.new.get_page(page)

        if [200].include?(results.status)
          yielder.yield results.body["data"]
          page += 1
        else
          raise StopIteration
        end
      end
    end.lazy
  end
end



class Doi

  include SuckerPunch::Job

  def get_page page
    api_url = API_URL

    query = "page[number]=#{page}&provider-id=ethz&query=aasm_state:draft  && url:http* && -registered:*"

    url = URI.encode("#{api_url}/dois?#{query}")
    puts url

    Maremma.get(url, content_type: 'application/vnd.api+json;charset=UTF-8', password:PASSWORD, username:USERNAME)
  end

  def generate_state_change_template(options={})
    response = {
      "data" => {
        "type" => "dois",
        "attributes" => {
          "event" => "publish"
        }
      }
    }
    response
  end

  def update_rest_doi(doi, options={}) 

    api_url = API_URL

    url = URI.encode("#{api_url}/dois/#{doi}")
    puts doi
 
    # response = Maremma.patch(url, content_type: 'application/vnd.api+json;charset=UTF-8', data: options[:data], password:PASSWORD, username:USERNAME)

    # if [200, 201].include?(response.status)
    #   puts "#{doi} Updated"
    # else
    #   puts "Error: #{doi} " + response.body["errors"].first.fetch("title", "An error occured")
    # end
  end

end


Bulker.new().run