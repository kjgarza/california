### Script to find datacite-crossref events with xref dois in boths nodes

require "maremma"
require 'active_support/time'
require 'active_support'
require 'csv'
# require "ruby-progressbar"

def evaluate_by_month(options={})

  options[:from_date] = ENV['FROM_DATE'] || Date.current.beginning_of_month.strftime("%F")
  options[:until_date] = ENV['UNTIL_DATE'] || Date.current.end_of_month.strftime("%F")

  from_date = (options[:from_date].present? ? Date.parse(options[:from_date]) : Date.current).beginning_of_month
  until_date = (options[:until_date].present? ? Date.parse(options[:until_date]) : Date.current).end_of_month

  # get first day of every month between from_date and until_date
  (from_date..until_date).select {|d| d.day == 1}.each do |m|
    queue_jobs(from_date: m.strftime("%F"), until_date: m.end_of_month.strftime("%F"))
  end

  "Queued import for DOIs created from #{from_date.strftime("%F")} until #{until_date.strftime("%F")}."
end

def get_query_url(options={})
  options[:number] ||= 1
  options[:size] ||= 1000
  updated = "updated_at:[#{options[:from_date]}T00:00:00Z TO #{options[:until_date]}T23:59:59Z]"
  options[:source_id] = source_id

  params = { 
    query: updated,
    "page[number]" => options[:number],
    "source-id" => options[:source_id],
    "page[size]" => options[:size]
   }

  url +  URI.encode_www_form(params)
end

def get_total(options={})
  query_url = get_query_url(options.merge(size: 0))
  puts query_url
  result = Maremma.get(query_url, options)
  result.body.dig("meta", "total").to_i
end

def job_batch_size
  1000
end

def queue_jobs(options={})
  logger = Logger.new(STDOUT)

  options[:number] = options[:number].to_i || 1
  options[:size] = options[:size].presence || 1000
  options[:from_date] = options[:from_date].presence || (Time.now.to_date - 1.day).iso8601
  options[:until_date] = options[:until_date].presence || Time.now.to_date.iso8601
  options[:content_type] = 'json'

  total = get_total(options)
  # progressbar = ProgressBar.create

  if total > 0
    # walk through paginated results
    total_pages = (total.to_f / job_batch_size).ceil
    error_total = 0

    (0...total_pages).each do |page|
      options[:number] = page
      options[:total] = total
      process_data(options)
    end
    text = "[Event Data] Queued #{source_id} import for #{total} DOIs updated #{options[:from_date]} - #{options[:until_date]}."
  else
    text = "[Event Data] No DOIs updated #{options[:from_date]} - #{options[:until_date]} for #{source_id}."
  end

  logger.info text

  # send slack notification
  if total == 0
    options[:level] = "warning"
  elsif error_total > 0
    options[:level] = "danger"
  else
    options[:level] = "good"
  end
  options[:title] = "Report for #{source_id}"
  # send_notification_to_slack(text, options) if options[:slack_webhook_url].present?

  # return number of dois queued
  total
end

def timeout
  120
end

def process_data(options = {})
  data = get_data(options.merge(timeout: timeout, source_id: source_id))
  push_data(data, options) 
end

def is_wrong_event?(item, options={})
  puts item.dig("id")
  subj_ra = cached_get_doi_ra(item.dig("attributes","subj-id"))
  obj_ra = cached_get_doi_ra(item.dig("attributes","obj-id"))
  
  return true if subj_ra == "Crossref" && item.dig("attributes","source-id") == "datacite-crossref"
  return true if subj_ra == "Datacite" && item.dig("attributes","source-id") == "crossref"
  return true if subj_ra == "Crossref" && obj_ra == "Crossref"
  return false
end

def source_id
  "datacite-crossref,crossref"
end

def query
  ""
end

def get_data(options={})
  query_url = get_query_url(options)
  Maremma.get(query_url, options)
end


def url
  "https://api.datacite.org" + "/events?"
end

def cached_get_doi_ra(doi)
  Cache.fetch("events/#{doi}") do
    get_doi_ra(doi)
  end
end

class Cache
  @redis = {}
  def self.fetch key, &block
    if @redis.key?(key)
      # fetch and return result
      puts "fetch from cache"
      @redis[key]
    else
      if block_given?
        # make the DB query and create a new entry for the request result
        puts "did not find key in cache, executing block ..."
        @redis[key] = yield(block)
      end
    end
  end
end


def get_doi_ra(doi)
  prefix = validate_prefix(doi)
  return nil if prefix.blank?

  url = "https://doi.org/ra/#{prefix}"
  result = Maremma.get(url)

  result.body.dig("data", 0, "RA")
end

def validate_prefix(doi)
  Array(/\A(?:(http|https):\/(\/)?(dx\.)?(doi.org|handle.test.datacite.org)\/)?(doi:)?(10\.\d{4,5}).*\z/.match(doi)).last
end

def doi_from_url(url)
  if /\A(?:(http|https):\/\/(dx\.)?(doi.org|handle.test.datacite.org)\/)?(doi:)?(10\.\d{4,5}\/.+)\z/.match(url)
    uri = Addressable::URI.parse(url)
    uri.path.gsub(/^\//, '').downcase
  end
end


def push_data(result, options={})
  logger = Logger.new(STDOUT)
  return result.body.fetch("errors") if result.body.fetch("errors", nil).present?

  items = result.body.fetch("data", [])
  # Rails.logger.info "Extracting related identifiers for #{items.size} DOIs created from #{options[:from_date]} until #{options[:until_date]}."
  CSV.open("events_with_error_prod_#{Date.current}.csv", "wb") do |csv|

    Array.wrap(items).map do |item|
      begin
        # progressbar.increment
        # logger.info "#{item.dig("id")}, #{item.dig("attributes","subj-id")}, #{item.dig("attributes","obj-id")}" if is_wrong_event?(item, options)
        csv <<  [item.dig("id"), item.dig("attributes","subj-id"), item.dig("attributes","obj-id") ] if is_wrong_event?(item, options)
      rescue Aws::SQS::Errors::InvalidParameterValue, Aws::SQS::Errors::RequestEntityTooLarge, Seahorse::Client::NetworkingError => error
        logger.error error.message
      end
    end
  end

  items.length
end


evaluate_by_month()