require 'csv'
require 'json'

def to_csv file
   CSV.generate do |csv|
    JSON.parse(File.open(file).read).each do |hash|
      csv << hash.values
    end
  end
end


puts to_csv "/Users/kristian/Downloads/clients_prod_3.json"