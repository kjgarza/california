require 'maremma'
require 'csv'
require 'sucker_punch'
require 'sucker_punch/async_syntax'
require 'dotenv/load'

# require 'sidekiq'


class CheckDoiJob
  include SuckerPunch::Job
  SuckerPunch.shutdown_timeout = 200 # # of sec. to wait before killing threads

  workers 10

  def perform(doi)
    Checker.new().check_metadata(doi)
  end
end

class CheckHandleJob
  include SuckerPunch::Job
  SuckerPunch.shutdown_timeout = 200 # # of sec. to wait before killing threads

  workers 10

  def perform(doi)
    Checker.new().check_resolv(doi)
  end
end






class Checker

  include SuckerPunch::Job


  def go_for_it

    last_doi = ""

    CSV.foreach('/Users/Kristian/Documents/missing_dois.csv') do |row|

      sleep 0.3
      doi = row.first.strip
      CheckDoiJob.perform_async(doi) 
      last_doi = doi
    end

    puts "File Completed at #{last_doi}"
  end

  def check_metadata doi
    api_url =  'https://api.datacite.org' 
  
  
    metadata_url = "#{api_url}/dois/#{doi}"
    response = Maremma.get(metadata_url, accept: 'application/vnd.api+json', password:ENV["PASSWORD"], username:"admin")

    unless [200, 201].include?(response.status)
      # failures << "#{doi} not indexed"
      puts "#{doi} [NotIndexed]"
    end


    if ["findable", "registered"].include?(response.body.dig("data","attributes","state"))
      CheckHandleJob.perform_async(doi)
    end

  end    


  def check_resolv doi
    doi_url =  'https://doi.org' 
  
    # doi = row.first

    # return nil unless doi.respond_to?(:to_str)
  
    resolver_url = "#{doi_url}/#{doi}"
    response = Maremma.get(resolver_url)
  
    if [404, 400, 500].include?(response.status)
      # failures << "#{doi} not minted"
      puts "#{doi} [NotMinted]"
    end
  end    
end


 Checker.new().go_for_it