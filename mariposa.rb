## check translation using abstract

require 'whatlanguage'
require 'fasttext'

require 'json'
require 'net/http'
require 'uri'
require 'open-uri'
require 'dotenv/load'



@query = '''query {
    works(
      query: "_exists_:descriptions.description && _exists_:language",
    ) {
      totalCount
      nodes{
        id
        language{
          name
        }
        descriptions{
          description
        }
      }
    }
}'''



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



def check_lang
  wl = WhatLanguage.new(:all)
  data = get_data(@query)
  puts data['works']['nodes'][1]['language']['name']
  # puts data['works']['nodes'][1]['descriptions'][0]['description'].language
  puts wl.language(data['works']['nodes'][1]['descriptions'][0]['description'])
end

def check_fast
  model = FastText.load_model("lid.176.ftz")
  data = get_data(@query)
  puts data['works']['nodes'][1]['language']['name']
  # puts data['works']['nodes'][1]['descriptions'][0]['description'].language
  puts model.predict(data['works']['nodes'][1]['descriptions'][0]['description'])
end




check_fast


