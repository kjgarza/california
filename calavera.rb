require 'maremma'

file = '/Users/kristian/datacite/stats-portal/source/stats/resolution-report/resolutions_01_2020.html'
out_put ="resolutions_01_2020.html"

url = "https://api.datacite.org/prefixes"

File.readlines(file).each do |line|
  next if line.include?("<p><h1>Not</p>")
  if line.include?('<a href="https://search.datacite.org/works?query=prefix:')
    prefix = line[/(10\.\d{4,5})/,1]
    puts prefix
    unless prefix.blank?
      metadata = Maremma.get("#{url}/#{prefix}") 
      # puts "#{url}/#{prefix}"
      # puts metadata
      client_id = metadata.body.dig("data","relationships","clients","data",0,"id")
      # puts client_id
      replacement_line = client_id.present? ? "<p>#{client_id.upcase}</p>" : "<p>Not</p>"
    end
    File.open(out_put, "a+") do |f|
      f.write(line)
      f.write(replacement_line || "<p>Not</p>")
    end
  else
    File.open(out_put, "a+") do |f|
      f.write(line)
    end
  end
end
