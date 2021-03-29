require "base64"
require 'json'
require 'dotenv/load'

API_URL = "https://mds.test.datacite.org"
EZ_URL  = "https://ez.test.datacite.org"
credentials ={username: "DEMO.DATACITE", password: ENV["PASSWORD_DEMO"] }
SESSION = "#{credentials[:username]}:#{credentials[:password]}"

def post_metadata type, datafile, doi
  begin
    content = "Content-Type:#{type};charset=utf-8"
  
    request = "http -v  -a #{SESSION} POST #{API_URL}/metadata/#{doi} < #{datafile} #{content} "
    # request = "http -v  -a #{SESSION} POST #{API_URL}/metadata #{content} < #{datafile}"
    puts "> #{request}" 
    puts "\n ```"
    system( request )
    puts "\n ```"
    puts ""
  rescue
    nil
  end
end

def draft_doi type, datafile, doi
  begin
    content = "Content-Type:#{type};charset=utf-8"
  
    request = "http -v  -a #{SESSION} POST #{API_URL}/metadata/10.70043/ < #{datafile} #{content} "
    # request = "http -v  -a #{SESSION} POST #{API_URL}/metadata #{content} < #{datafile}"
    puts "> #{request}" 
    puts "\n ```"
    system( request )
    puts "\n ```"
    puts ""
  rescue
    nil
  end
end

def post_doi type, datafile, doi
  begin
    content = "Content-Type:#{type};charset=utf-8"
   
    request = "printf 'doi=#{doi}\nurl=http://example.org/' | http -v  -a #{SESSION} PUT #{API_URL}/doi/#{doi}  #{content} "
    # request = "http -v  -a #{SESSION} POST #{API_URL}/metadata #{content} < #{datafile}"
    puts "> #{request}" 
    puts "\n ```"
    system( request )
    puts "\n ```"
    puts ""
  rescue
    nil
  end
end

def post_media type, datafile, doi
  begin
    content = "Content-Type:#{type};charset=utf-8"
    datafile = "image/jpeg=https://upload.wikimedia.org/wikipedia/en/a/a9/Example.jpg"
    request = "echo '#{datafile}' | http -v  -a #{SESSION} POST #{API_URL}/media/#{doi} #{content} "
    # request = "http -v  -a #{SESSION} POST #{API_URL}/metadata #{content} < #{datafile}"
    puts "> #{request}" 
    puts "\n ```"
    system( request )
    puts "\n ```"
    puts ""
  rescue
    nil
  end
end

def get_doi doi
  begin
    request = "http -v  -a #{SESSION} GET #{API_URL}/doi/#{doi}"
    puts "> #{request}" 
    puts "\n ```"
    system( request )
    puts "\n ```"
    puts ""
  rescue
    nil
  end
end

def get_all_doi 
  begin
   
    request = "http -v  -a #{SESSION} GET #{API_URL}/doi "
    puts "> #{request}" 
    puts "\n ```"
    system( request )
    puts "\n ```"
    puts ""
  rescue
    nil
  end
end

def get_metadata doi
  begin
   
    request = "http -v  -a #{SESSION} GET #{API_URL}/metadata/#{doi}"
    puts "> #{request}" 
    puts "\n ```"
    system( request )
    puts "\n ```"
    puts ""
  rescue
    nil
  end
end

def get_media doi
  begin
   
    request = "http -v  -a #{SESSION} GET #{API_URL}/media/#{doi}"
    puts "> #{request}" 
    puts "\n ```"
    system( request )
    puts "\n ```"
    puts ""
  rescue
    nil
  end
end

def update_metadata type, datafile, doi
  begin
    content = "Content-Type:#{type};charset=utf-8"

    request = "http -v  -a #{SESSION} PUT  #{API_URL}/metadata/10.70043/4K3M-NYVG < #{datafile} #{content}"
    puts "> #{request}" 
    puts "\n ```"
    system( request )
    puts "\n ```"
    puts ""
  rescue
    nil
  end
end


def delete_metadata 
  begin
   
    request = "http -v  -a #{SESSION} DELETE #{API_URL}/metadata/10.70043/4K3M-NYVG < #{datafile} #{content} "
    # request = "http -v  -a #{SESSION} POST #{API_URL}/metadata #{content} < #{datafile}"
    puts "> #{request}" 
    puts "\n ```"
    system( request )
    puts "\n ```"
    puts ""
  rescue
    nil
  end
end



def ez_post_doi type, datafile, doi
  begin
    content = "Content-Type:#{type}"
  
    request = "http -v  -a #{SESSION} PUT #{EZ_URL}/id/doi:#{doi} < #{datafile} #{content} "
    # request = "http -v  -a #{SESSION} POST #{API_URL}/metadata #{content} < #{datafile}"
    puts "> #{request}" 
    puts "\n ```"
    system( request )
    puts "\n ```"
    puts ""
  rescue
    nil
  end
end

def ez_reserve_doi type, datafile, doi
  begin
    content = "Content-Type:#{type}"
  
    request = "http -v  -a #{SESSION} PUT #{EZ_URL}/id/doi:#{doi} < #{datafile} #{content} "
    # request = "http -v  -a #{SESSION} POST #{API_URL}/metadata #{content} < #{datafile}"
    puts "> #{request}" 
    puts "\n ```"
    system( request )
    puts "\n ```"
    puts ""
  rescue
    nil
  end
end

def ez_update_doi type, datafile, doi
  begin
    content = "Content-Type:#{type}"
  
    request = "http -v  -a #{SESSION} POST #{EZ_URL}/id/doi:#{doi} < #{datafile} #{content} "
    # request = "http -v  -a #{SESSION} POST #{API_URL}/metadata #{content} < #{datafile}"
    puts "> #{request}" 
    puts "\n ```"
    system( request )
    puts "\n ```"
    puts ""
  rescue
    nil
  end
end

def ez_get_doi doi
  begin

  
    request = "http -v  -a #{SESSION} GET #{EZ_URL}/id/doi:#{doi} "
    # request = "http -v  -a #{SESSION} POST #{API_URL}/metadata #{content} < #{datafile}"
    puts "> #{request}" 
    puts "\n ```"
    system( request )
    puts "\n ```"
    puts ""
  rescue
    nil
  end
end

def ez_delete_doi doi
  begin
  
    request = "http -v  -a #{SESSION} DELETE #{EZ_URL}/id/doi:#{doi} "
    # request = "http -v  -a #{SESSION} POST #{API_URL}/metadata #{content} < #{datafile}"
    puts "> #{request}" 
    puts "\n ```"
    system( request )
    puts "\n ```"
    puts ""
  rescue
    nil
  end
end


def datacite_gets
  puts "# MDS Validation"
  prng = Random.new


  type = "application/xml"
  datafile = "files/datacite.xml"
  doi = "10.70043/4K3M-NYVG#{prng.rand(100)}"
  post_metadata type, datafile, doi
  type = "text/plain"
  post_doi type, datafile, doi
  type = "text/plain"
  post_media type, datafile, doi

  puts "## Show a doi"
  get_doi doi
  puts "## Show all dois"
  get_all_doi
  puts "## Show metadataof a doi"
  get_metadata doi
  puts "## Show media"
  get_media doi
end



def creating
  prng = Random.new
  
  type = "application/xml"
  datafile = "files/datacite.xml"
  doi = "10.70043/4K3M-NYVG#{prng.rand(100)}"


  puts "## Create doi metadata"
  post_metadata type, datafile, doi

  puts "## Create draft doi"
  draft_doi type, datafile, doi

  puts "## Mint doi"
  type = "text/plain"
  post_doi type, datafile, doi

  puts "## Create media"
  type = "text/plain"
  post_media type, datafile, doi
end


def ezid 
  prng = Random.new


  puts "# EZ Validation"

  datafile = "files/10.5072_DRYAD.B3B0T7S_1.txt"
  type = "text/plain"
  doi = "10.70043/4K3M-NFVG#{prng.rand(100)}"

  puts "## Create doi"
  ez_post_doi type, datafile, doi

  puts "## Update doi"
  ez_update_doi type, datafile, doi

  puts "## Show doi"
  ez_get_doi  doi

  puts "## Create draft doi"
  datafile = "files/10.5072_DRYAD.B3B0T7S_2.txt"
  doi = "10.70043/4K3M-NFVG#{prng.rand(100)}"
  ez_reserve_doi type, datafile, doi

  puts "## Delete doi"
  ez_delete_doi  doi

end

def header

  puts "

  #MDS and EZID API Manual Testing

  ##Requirements

  - https://httpie.org/ - You can use curl too, but httpie is just easier to work with.

  ### Tests

  API | Name                  		| Endpoint    	| Method 	| Pass/Fail
  ---- | --- 						| ---			| ---	 	| ---
  MDS | Get URL for DOI 	  		| /doi/doi 		| GET 		| Pass
  MDS | List all DOI's 		  		| /doi 			| GET		| Pass
  MDS | Create DOI            		| /doi/doi    	| PUT		| Pass
  MDS | Create DOI Alternate  		| /doi/doi 		| POST		| Not Tested
  MDS | Delete DOI            		| /doi/doi 		| DELETE	| Not Tested
  MDS | Get Metadata for DOI  		| /metadata/doi | GET		| Pass
  MDS | Create Metadata for DOI  	| /metadata/doi | POST		| Pass
  MDS | Update Metadata for DOI  	| /metadata/doi | PUT		| Pass
  MDS | Create Draft DOI 			| /metadata/doi | POST		| Pass
  MDS |  Delete Metadata for DOI  	| /metadata/doi | DELETE	| Not Tested
  MDS |  Get Media for DOI 	 		| /media/doi 	| GET		| Pass
  MDS | Create Media for DOI  		| /media/doi 	| POST		| Pass
  EZID | Get URL for DOI 	  		| /id/doi:{doi} 		| GET 		| Pass
  EZID | Create DOI            		| /id/doi:{doi}    	| PUT		| Pass
  EZID | Create DOI reserved  		| /id/doi:{doi} 		| PUT		| Pass
  EZID | Delete DOI            		| /id/doi:{doi} 		| DELETE	| Pass
  EZID | Update  DOI  	         | id/doi:{doi} | POST		| Pass
"

end




header
datacite_gets
creating
ezid