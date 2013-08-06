require 'csv'

desc "Import clients data from CSV file"
task import_clients: :environment do
  puts "Start Import"

  contents = CSV.open "import_data/clients.csv", headers: true, header_converters: :symbol
  puts "Open File"

  contents.each do |row|
    human_client_id = row[:clientid]
    entity_title = row[:clienttitle]
    entity_initials = row[:clientinit]
    entity_name = row[:clientname]
    # title2= row[:clienttitle2]
    # init2 = row[:clientinit2]
    # name2 = row[:clientname2]

    flatnum = row[:flatno]
    housena = row[:housename]
    roadno = row[:rdno]
    road = row[:rd]
    dist = row[:district]
    tow = row[:town]
    count = row[:county]
    postcd = row[:pc]

    if road == "14 Waterloo Street"
     roadno = "14"
     road = "Waterloo Street"
     count = "West Midlands"
     tow = "Birmingham"
    end


    if human_client_id == 18
     roadno = "-"
     dist = "-"
     road = "-"
     count = "-"
     tow = "-"
     postcd = "-"

    end

    tow = tow.downcase.capitalize if tow =="SOLIHULL"

    my_client = Client.where(human_client_id: human_client_id)
    puts my_client.inspect unless my_client.nil?

    # client = Client.new human_client_id: human_client_id
    # client.entities.new title: entity_title, initials: entity_initials, name: entity_name
    # # client.entities.new title: entity_title2, initials: entity_initials, name: entity_name
    # client.build_address flat_no: flatnum, house_name: housena, road_no: roadno, road: road, district: dist, town: tow, county: count, postcode: postcd
    # client.save!

    # puts client.inspect
    # puts client.entities.first.inspect
  end
end



 # def populate_article
 #      puts "populate article"
 #      article_populate_file = File.join(Rails.root, 'populate', 'articles.csv')
 #      CSV.foreach(article_populate_file, headers: true) do |row|
 #        article = Article.find_by_id(row['id']) || Article.new
 #        article.attributes = row.to_hash.slice(*['id','title','summary','content','published_on','tags', 'properties','slug','published', 'user_id'])
 #        article.save!
 #      end
