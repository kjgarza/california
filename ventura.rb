### checking orcid client in isolation
require "orcid_client"
require "bolognese"
require 'dotenv/load'

ENV['SOLR_URL'] = "https://search.datacite.org/api"

def get doi, orcid
  options = {sandbox: false}
  w = OrcidClient::Work.new(doi: doi, orcid: orcid, access_token: ENV["TOKEN"], options:options)
  puts w.metadata.inspect
  puts w.inspect
end


# get "10.25596/jalc-2012-017", "0000-0003-0031-5275"


# get "10.5281/zenodo.59983", "0000-0001-6528-2027"


def metadata doi, sandbox
  Bolognese::Metadata.new(doi: doi, sandbox: sandbox)
end

# doi="https://doi.org/10.26180/5c15d36f7ebaf"
# doi="https://doi.org/10.7554/elife.01567"
# doi="10.5438/6423"
doi="10.5281/zenodo.59983"
sandbox=false

x = metadata(doi,sandbox)

puts x.inspect
