  client = Client.where(symbol: "datacite.test")
  prefix = Prefix.where(prefix: "10.14454")

  dois = FactoryBot.create_list(:doi,10, client: client, state: "findable")

  ## add authors
  dois.each do |doi|
    FactoryBot.create(:event_for_datacite_orcid_auto_update, subj_id: doi.id,  obj_id: 'http://orcid.org/0000-0003-2926-8353') 
    FactoryBot.create(:event_for_datacite_orcid_auto_update, subj_id: doi.id,  obj_id: 'http://orcid.org/0000-0003-1840-6984') 
    FactoryBot.create(:event_for_datacite_orcid_auto_update, subj_id: doi.id,  obj_id: 'http://orcid.org/0000-0002-2623-0854') 
    FactoryBot.create(:event_for_datacite_orcid_auto_update, subj_id: doi.id,  obj_id: 'http://orcid.org/0000-0003-0402-2605') 
    FactoryBot.create(:event_for_datacite_orcid_auto_update, subj_id: doi.id,  obj_id: 'http://orcid.org/0000-0002-4221-1039') 
    FactoryBot.create(:event_for_datacite_orcid_auto_update, subj_id: doi.id,  obj_id: 'http://orcid.org/0000-0001-7670-4475') 
  end


  ## citatations
  FactoryBot.create_list(:event_for_datacite_related, 34, obj_id: dois.first.doi) 
  FactoryBot.create_list(:event_for_datacite_related, 34, obj_id: dois.last.doi) 

  ## usage
  FactoryBot.create_list(:event_for_datacite_usage, 32, obj_id: dois.first.doi)
  FactoryBot.create_list(:event_for_datacite_usage, 32, relation_type_id: "unique-dataset-requests-regular", obj_id: dois.last.doi)


  