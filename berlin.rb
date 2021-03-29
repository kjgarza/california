require 'json_api_client'
require 'uri'
require 'cgi'

module DataciteRestApi
  # this is an "abstract" base class that

  class Base < JsonApiClient::Resource
    JsonApiClient::Paginating::Paginator.page_param = "cursor"
    JsonApiClient::Paginating::Paginator.per_page_param = "size"
    # set the api base url in an abstract base class
    # self.paginator = MyPaginator
    self.site = "https://api.datacite.org/"
  end

  class Doi < Base
  end
end

response = DataciteRestApi::Doi.with_headers(mailto: 'kgarza@datacite.org') do
  DataciteRestApi::Doi.paginate(page: 1, per_page: 1000)
end

# response =  DataciteRestApi::Doi.paginate(page: 1, per_page: 1000)
loops = 1

if response.meta.attributes.dig("totalPages").positive?
  puts "Batch Length #{response.length} -- #{Time.now.getutc}"
  while response.length.positive?
    puts "Page number #{loops} -- #{Time.now.getutc}"
    puts "Scrolled #{loops*1000} DOIs -- #{Time.now.getutc}"
    puts "Last Item of the batch #{response.first.id} -- #{Time.now.getutc}"
    args = URI.parse(response.links.links["next"])
    cursor = CGI::parse(args.query)["page[cursor]"].first
    puts "Cursor #{cursor} -- #{Time.now.getutc}"

    
    response = response.pages.next

    loops=loops+1
    break unless response.length.positive?
  end
end

