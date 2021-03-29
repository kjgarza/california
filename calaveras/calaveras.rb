require 'maremma'
require 'hooks'
require 'sucker_punch'
require 'sucker_punch/async_syntax'
require 'json'
require 'dotenv/load'

class Event 

  include Hooks

  def initialize(attribute)
    @attribute = attribute
  end

  def push

    api_url = 'http://localhost:8065'

    url = URI.encode("#{api_url}/events")

    data = {
      data: {
        attributes: @attribute["attributes"],
        id: @attribute["id"],
        type: @attribute["type"]
      }
    }

    options= {}
    options[:jwt] = ENV["TOKEN"] 

    if options[:jwt].present?
      response = Maremma.post(url, accept: 'application/vnd.api+json; version=2', content_type: 'application/vnd.api+json', data: data.to_json, bearer: options[:jwt]) 
    end

    if [200, 201].include?(response.status)
      puts "[Event Data]  pushed to Event Data service."
    elsif response.status == 409
      puts "[Event Data]already pushed to Event Data service."
    elsif response.body["errors"].present?
      puts "[Event Data] had an error: #{response.body['errors'].first['title']}"
    end 
  end

  def obj_id
    @attribute.dig("attributes","objId")
  end

  def subj_id
    @attribute.dig("attributes","subjId")
  end



end



class Doi 

  include SuckerPunch::Job
  SuckerPunch.shutdown_timeout = 20 # # of sec. to wait before killing threads


  # include Hooks

  # define_hooks :after_initiliaze

  # after_initiliaze :get_async  

  def initialize(attribute)
    @attribute = attribute
    @doi = @attribute.gsub("https://doi.org/","")
    get_xml
  end


  # def get_async
  #   GetMetadataJob.perform_async(@attribute)
  # end

  def get_xml
    api_url =  'https://api.datacite.org' 

    url = "#{api_url}/works/#{@doi}"
    response = Maremma.get(url, accept: 'application/vnd.api+json')

    if [200, 201].include?(response.status)
      puts "There is metadata."
    elsif response.body["errors"].present?
      puts "[Error Metadata] had an error: #{response.body['errors'].first['title']}"
    end 

    @xml = response.body.dig("data","attributes","xml")
  end


  def push

    api_url = 'http://localhost:8065'

    url = URI.encode("#{api_url}/dois")

    data = {
      data: {
        attributes: {
          event: "publish",
          doi: @doi,
          url: "https://schema.datacite.org/meta/kernel-4.0/index.html",
          xml: @xml
        },
        id: @doi,
        type: "dois"
      }
    }

    options= {}
    options[:jwt] = ENV["TOKEN"] 

    if options[:jwt].present?
      response = Maremma.post(url, content_type: 'application/vnd.api+json;charset=UTF-8', data: data.to_json, bearer: options[:jwt]) 
    end

    if [200, 201].include?(response.status)
      puts "Created DOI."
    elsif response.status == 409
      puts "DOI already existed."
    elsif response.body["errors"].present?
      puts "[Error DOI] had an error: #{response.body['errors'].first['title']}"
    end 
  end


end


# class GetMetadataJob
#   include SuckerPunch::Job
#   workers 4

#   def perform(doi)
#   end
# end

class PushDoiJob
  include SuckerPunch::Job
  SuckerPunch.shutdown_timeout = 20 # # of sec. to wait before killing threads

  workers 4

  def perform(event)
    Doi.new(event).push
  end
end

class PushEventJob
  include SuckerPunch::Job
  SuckerPunch.shutdown_timeout = 20 # # of sec. to wait before killing threads


  def perform(event)
    Event.new(event).push
  end
end


class Response 

  include SuckerPunch::Job
  SuckerPunch.shutdown_timeout = 20 # # of sec. to wait before killing threads



  # include Hooks

  # define_hooks :after_new

  # after_new :get_response  

  def initialize(attribute)
    @attribute = attribute
    get_response
  end

  def get_response
    api_url =  'https://api.datacite.org' 
    puts api_url

    url = "#{api_url}/events?source-id=datacite-related"
    @events = Maremma.get(url, accept: 'application/vnd.api+json; version=2').body.dig("data")
  end


  def mimic
    @events.each do |event|
      PushEventJob.perform_async(event)
      PushDoiJob.perform_async(event.dig("attributes","objId"))
      PushDoiJob.perform_async(event.dig("attributes","subjId"))
      # PushDoiJob.perform_async(event.subj_id)
    end
  end
end


Response.new("").mimic