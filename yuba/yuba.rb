
  # Creates a snapshop of different GraphQL queries and uploads it to github gist
  

resource = ARGV[0]

require 'json'
require 'CSV'
require 'net/http'
require 'json'
require 'uri'
require 'open-uri'
require 'dotenv/load'



@query = '''query {
  datasets( facetCount:60,
   query: "subjects.subjectScheme:\"Fields of Science and Technology (FOS)\""
) {
    totalCount
    subjects: fieldsOfScience{
      title
      id
      count
    }
  	published{
      title
      id
      count
    }
  	repositories{
      title
      id
      count
    }
  licenses{
    title
    id
    count
  }
  affiliations{
    title
    id
    count
  }
  languages{
    title
    id
    count
  }
  }
}'''

@query_citations = '''query {
  datasets( facetCount:60, hasCitations:1,
   query: "subjects.subjectScheme:\"Fields of Science and Technology (FOS)\""
) {
    totalCount
    subjects: fieldsOfScience{
      title
      id
      count
    }
  	published{
      title
      id
      count
    }
  	repositories{
      title
      id
      count
    }
  licenses{
    title
    id
    count
  }
  affiliations{
    title
    id
    count
  }
  languages{
    title
    id
    count
  }
  }
}'''

@query_only_citations = '''query {
  datasets( facetCount:60, hasCitations:1,
) {
    totalCount
    subjects: fieldsOfScience{
      title
      id
      count
    }
  	published{
      title
      id
      count
    }
  	repositories{
      title
      id
      count
    }
  licenses{
    title
    id
    count
  }
  affiliations{
    title
    id
    count
  }
  languages{
    title
    id
    count
  }
  }
}'''


@dmps = '''query {
  DataManagementPlans{
    totalCount
    subjects: fieldsOfScience{
      title
      id
      count
    }
  	published{
      title
      id
      count
    }
  	repositories{
      title
      id
      count
    }
  licenses{
    title
    id
    count
  }
  affiliations{
    title
    id
    count
  }
  languages{
    title
    id
    count
  }
  }
}'''

@date = Time.now
# @date = Time.now+ (3 * 24 * 60 * 60)

def get_data(query)
  uri = URI("https://api.datacite.org/graphql")
  res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Post.new(uri)
      req['Content-Type'] = 'application/json'
      # The body needs to be a JSON string.
      req.body = JSON[{'query' => query}]
      puts(req.body)
      http.request(req)
  end
  JSON.parse(res.body)['data']
end



def save_data(data, aggregation)
  CSV.open("data/new.csv", "wb") do |csv|
    data.each do |hash|
      hash['aggregation'] = aggregation
      hash['date'] = @date.strftime("%B %d, %Y")
      csv << hash.values
    end
  end
end


def get_file(id)
  uri = URI("https://api.github.com/gists/#{id}")
  res = Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      req = Net::HTTP::Get.new(uri)
      req['Content-Type'] = 'application/json'
      # The body needs to be a JSON string.
      # req.body = JSON[{'query' => query}]
      puts(req.body)
      http.request(req)
  end

  return CSV.new('data/previous.csv') if res.code == "404"
  url = JSON.parse(res.body)['files'].first.last["raw_url"]
  download = open(url)
  IO.copy_stream(download, 'data/previous.csv')
end


def merge_files
  CSV.open("final.csv", "a+", write_headers: false, headers: ["title","id","count","aggregation","date"]) do |csv|
    Dir["data/new.csv"].each do |path|  # for each of your csv files
      CSV.foreach(path, headers: false, return_headers: false) do |row| # don't output the headers in the rows
        csv << row # append to the final file
      end
    end
  end
end

def update_file(id,query,resource)
  get_file(id)
  data = get_data(query).dig(resource)
  puts data
  CSV.open('final.csv','w+') 
  ["subjects","languages","licenses","repositories","published","affiliations"].each do |agg|
    save_data(data.dig(agg),agg)
    merge_files
  end
  CSV.open("final.csv", "a+", write_headers: false, headers: ["title","id","count","aggregation","date"]) do |csv|
    Dir["data/previous.csv"].each do |path|  # for each of your csv files
      CSV.foreach(path, headers: true, return_headers: false) do |row| # don't output the headers in the rows
        csv << row # append to the final file
      end
    end
  end

  system( "gist -u #{id} final.csv" )
  system( "rm final.csv" )
  system( "rm data/previous.csv" )
end

# update_file("807819894edc766e38d682437b3ac3f8",@query,"datasets")
# update_file("6b8642e765cea2e5afdfab39203b4ad5",@query_citations,"datasets")
# update_file("0c8504414fd7cf86ba085813ef7317bd",@query_only_citations,"datasets")

case resource
when "datasets"
  update_file("807819894edc766e38d682437b3ac3f8",@query,"datasets")
  update_file("6b8642e765cea2e5afdfab39203b4ad5",@query_citations,"datasets")
  update_file("0c8504414fd7cf86ba085813ef7317bd",@query_only_citations,"datasets")
when "works"
  update_file("",@query,"datasets")
  update_file("",@query_citations,"datasets")
  update_file("",@query_only_citations,"datasets")
when "dmps"
  update_file("696cb47ad2c7c9707fb1f51c1eef8351",@dmps,"datamanagementplans")
else
  puts "I don't know what to do"
end