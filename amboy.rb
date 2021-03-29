# require 'json'




# issues = [
#   ["Investigation: Tasks for creating a Builder page" ,"", "research", "kjgarza"],
#   ["Setup for deployment in CDN", "Tasks: <br/> - [ ] Versioning configuration <br/> - [ ] CDN Definition <br/> - [ ] Setup CDN", "", "kjgarza"],
#   ["Investigation: detecting DOI name from page" ,"Researche Questions:  - Can we alternate between prop input and detecting DOI? <br/>  - What percentage of landingpage have DOI names embeded ?", "research", "kjgarza"],
#   ["Define build target", "Tasks: <br/> - [ ] Evaluate: Library vs Component <br/> - Parameters: isolation, style leaking, branding, props, browser compatibility, size <br/> - [ ] Implement build target", "", "kjgarza"],
#   ["Widget Documentation","Tasks: <br/> - [ ] How to create a Widget  <br/>  - [ ] What the information means", "documentation", "daslerr"],
#   ["Logo/Icon for the Widget","Tasks: <br/> - [ ] Investigate potential Logos <br/> - [ ] Define logo <br/> - [ ] Create PNG files", "", "daslerr"],
#   ["UI definition","Tasks: <br/> - [ ] Define font, colors, backgrounds <br/> - [ ] Mockups of the: tiny widget and normal size ", "", "daslerr"],
#   ["Icons for the metrics (downloads/views/citations)","Tasks: <br/> - [ ] Investigate potential icons for <br/> - [ ] Define icons <br/> - [ ] Create PNG files for icons in different sizes", "", "daslerr"],
#   ["UI/UX and inputs implementation","Tasks: <br/> - [ ] Implement compoents for citations, views and downloads <br/> - [ ] Input validation", "", "kjgarza"],
#   ["UI Implement differet sizes: Tiny , Normal ","Tasks: <br/> - [ ] Implement compoents for citations, views and downloads <br/> - [ ] Input validation", "", "kjgarza"],
#   ["Widget Testing and Browser Evalutation" , "Tasks: <br/> - [ ] Evaluation with different Browsers  <br/> - [ ] Unit testing", "", "kjgarza"],
#   ["User Testing" , "", "", "daslerr"],
#   ["Implement GraphQL integration","Tasks:  <br/> - [ ] Define aggregations for citations, views and downloads <br/> - [ ] Implement Resolver changes <br/> - [ ] Test for Aggregation results <br/> - [ ] Evaluate https://github.com/Akryum/vue-apollo <br/> - [ ] Define JSON Response for metrics response", "", "kjgarza"],
#   ["Setup for CI", "Tasks: <br/> - [ ] Travis <br/> - [ ] testing framework", "", "kjgarza"]
# ]

issues = [
  ["Investigation: Tasks for creating a Builder page" ,"", "research", "kjgarza"],
  ["Setup for deployment in CDN", "Tasks: <br/> - [ ] Versioning configuration <br/> - [ ] CDN Definition <br/> - [ ] Setup CDN", "", "kjgarza"],
  ["Investigation: detecting DOI name from page" ,"Researche Questions:  - Can we alternate between prop input and detecting DOI? <br/>  - What percentage of landingpage have DOI names embeded ?", "research", "kjgarza"],
  ["Define build target", "Tasks: <br/> - [ ] Evaluate: Library vs Component <br/> - Parameters: isolation, style leaking, branding, props, browser compatibility, size <br/> - [ ] Implement build target", "", "kjgarza"],
  ["Widget Documentation","Tasks: <br/> - [ ] How to create a Widget  <br/>  - [ ] What the information means", "documentation", "daslerr"],
  ["Logo/Icon for the Widget","Tasks: <br/> - [ ] Investigate potential Logos <br/> - [ ] Define logo <br/> - [ ] Create PNG files", "", "daslerr"],
  ["UI definition","Tasks: <br/> - [ ] Define font, colors, backgrounds <br/> - [ ] Mockups of the: tiny widget and normal size ", "", "daslerr"],
  ["Icons for the metrics (downloads/views/citations)","Tasks: <br/> - [ ] Investigate potential icons for <br/> - [ ] Define icons <br/> - [ ] Create PNG files for icons in different sizes", "", "daslerr"],
  ["UI Implement differet sizes: Tiny , Normal ","Tasks: <br/> - [ ] Implement compoents for citations, views and downloads <br/> - [ ] Input validation", "", "kjgarza"],
  ["Implement GraphQL integration","Tasks:  <br/> - [ ] Define aggregations for citations, views and downloads <br/> - [ ] Implement Resolver changes <br/> - [ ] Test for Aggregation results <br/> - [ ] Evaluate https://github.com/Akryum/vue-apollo <br/> - [ ] Define JSON Response for metrics response", "", "kjgarza"],
  ["Setup for CI", "Tasks: <br/> - [ ] Travis <br/> - [ ] testing framework", "", "kjgarza"]
]

# issues = [
#   ["UI/UX and inputs implementation","Tasks: <br/> - [ ] Implement components for citations, views and downloads <br/> - [ ] Format counts <br/> - [ ] Input validation  <br/> https://docs.google.com/document/d/16LfFgjwjQVFmgl6db7arMr0gay8zVYSeUTH24cUIZ5o/edit#", "", "kjgarza"],
#   ["Widget Testing and Browser Evalutation" , "Tasks: <br/> - [ ] Evaluation with different Browsers  <br/> - [ ] Unit testing", "", "kjgarza"],
#   ["User Testing" , "It can do be in production", "", "daslerr"],
#   ["Improve perfornace of GraphQL call for widget"," Currently graphql for data metrics takes around 4s. We need to improve it. <br/> Optimal response time: TBD <br/> API Limit: TBD  <br/>  Tasks: <br/> - [ ] Avoid script usage <br/> - [ ] Evaluate pre-indexing for citations ", "", "kjgarza"],
# ]

issues.each do |issue|
  main_issue = " <br/> child https://github.com/datacite/datacite/issues/802"
  title = '"'+issue[0]
  description = issue[1]+main_issue+'"'

  # message = '"'+"#{title} <br/> 
  #{description} #{main_issue}"+'"'
  user  = issue[3]
  label = issue[2]

  puts( "ghi open -u #{user} -m #{title}
    #{description}" )

  # exec( "hub issue create -a #{user} -m #{title} \ #{description}" )
end









# ["Investigation: Tasks for creating a Builder page" ,"", "research", "kjgarza"]
# ["Setup for deployment in CDN", " - [ ] Versioning configuration <br/> - [ ] CDN Definition <br/> - [ ] Setup CDN", "", "kjgarza"]
# ["Investigation: detecting DOI name from page" ,"Researche Questions:  - Can we alternate between prop input and detecting DOI? <br/>  - What percentage of landingpage have DOI names embeded ?", "research", "kjgarza"]
# ["Define build target", "Tasks: <br/> - [ ] Evaluate: Library vs Component <br/> - Parameters: isolation, style leaking, branding, props, browser compatibility, size <br/> - [ ] Implement build target", "", "kjgarza"]
# ["Widget Documentation","Tasks: <br/> - [ ] How to create a Widget  <br/>  - [ ] What the information means", "documentation", "daslerr"]
# ["Logo/Icon for the Widget","Tasks: <br/> - [ ] Investigate potential Logos <br/> - [ ] Define logo <br/> - [ ] Create PNG files", "", "daslerr"]
# ["UI definition","Tasks: <br/> - [ ] Define font, colors, backgrounds <br/> - [ ] Mockups of the: tiny widget and normal size ", "", "daslerr"]
# ["Icons for the metrics (downloads/views/citations)","Tasks: <br/> - [ ] Investigate potential icons for <br/> - [ ] Define icons <br/> - [ ] Create PNG files for icons in different sizes", "", "daslerr"]
# ["UI/UX and inputs implementation","Tasks: <br/> - [ ] Implement compoents for citations, views and downloads <br/> - [ ] Input validation", "", "kjgarza"]
# ["UI Implement differet sizes: Tiny , Normal ","Tasks: <br/> - [ ] Implement compoents for citations, views and downloads <br/> - [ ] Input validation", "", "kjgarza"]
# ["Widget Testing and Browser Evalutation" , "Tasks: <br/> - [ ] Evaluation with different Browsers  <br/> - [ ] Unit testing", "", "kjgarza"]
# ["User Testing" , "", "", "daslerr"]
# ["Implement GraphQL integration","Tasks: <br/> - [ ] Define aggregations for citations, views and downloads <br/> - [ ] Implement Resolver changes <br/> - [ ] Test for Aggregation results <br/> - [ ] Evaluate https://github.com/Akryum/vue-apollo <br/> - [ ] Define JSON Response for metrics response", "", "kjgarza"]
# ["Setup for CI", " - [ ] Travis <br/> - [ ] testing framework", "", "kjgarza"]



