require 'selenium-webdriver'
require 'pry'
require 'csv'
require 'json'

driver = Selenium::WebDriver.for :firefox

# Get the front page of hacker news
driver.get('https://news.ycombinator.com')

# Get all of the data off of the homepage of hackernews
athings = driver.find_elements(class: 'athing')

hn_data = athings.each_with_object([]) do |item, obj| 
  id = item.attribute('id')

  obj << {
    id: id,
    title: item.find_element(class: 'storylink').text,
    url: item.find_element(class: 'storylink').attribute('href'),
    score: driver.find_element(xpath: "//*[@id='score_#{id}']").text,
    comments: driver.find_elements(xpath: "//*[@href='item?id=#{id}']").last.text,
    comments_link: driver.find_element(xpath: "//*[@href='item?id=#{id}']").attribute('href')
  }
end

# Save our data as a json file
File.open('hn_data.json', "w") { |f| f.puts hn_data.to_json }

# Convert our data to csv format
hn_data_csv = CSV.generate do |csv|
  JSON.parse(File.open('hn_data.json').read).each do |hash|
    csv << hash.values
  end
end

# Save our data as a csv file
File.open('hn_data.csv', "w") {|f| f.puts hn_data_csv }

sleep(2)

# Switch from HN to a new tab and open google
driver.execute_script( "window.open()" )
driver.switch_to.window(driver.window_handles.last)

driver.get('https://google.com')

sleep(1)

# Click the sign in button
driver.find_element(link_text: 'Sign in').click

# Enter your email
driver.find_element(id: 'identifierId').send_keys(ENV['EMAIL'])

sleep(1)

# Click the next button
driver.find_element(id: 'identifierNext').click

sleep(3)

# Enter pass
driver.find_element(xpath: '//*[@type="password"]').send_keys(ENV['PASS'])
driver.find_element(id: 'passwordNext').click

sleep(2)

# open dropdown list
driver.find_element(xpath: '//*[@title="Google apps"]').click

# select google sheets from dropdown
driver.find_element(id: 'gb283').click

# Create a new google spreadsheet
driver.find_elements(class: 'docs-homescreen-templates-templateview-showcase').first.click

sleep(3)

# Open the file menu
driver.find_element(id: 'docs-file-menu').click

# Open import tab
driver.find_element(xpath: '//*[@aria-label="Import i"]').click

sleep(3)

# From here, the uploader modal is inside of an iframe, so we need to figure out the name of the iframe and switch into it.
# inspecting the page, we can see that the iframe has a name value of "name", so we should be able to target this and switch to the specific frame.
# Since the unique name of our iframe seems to change on each page reload, we need a way to be able to target it reliably each time without knowing the name in advance.
# For now, I think we can solve this by getting a list of all the iframes on the page with find_elements and then selecting our specific iframe and getting the name attribute.
# at the time of writing, using select_elements(tag_name: 'iframe'), the iframe we want is always the last item in the array. So something like this should work
iframe_name = driver.find_elements(tag_name: 'iframe').last.attribute('name')
driver.switch_to.frame(iframe_name)

sleep(3)

# Select the upload button by it's unique id on the page
driver.find_element(id: ':8').click

# Normally at this point you would open the file upload prompt to select a file, but we can't actually interact with it
# like a human. So instead we need to try to submit directly to the input field in the page using the 'send_keys' method.
# If we dig around the page a little more we can find the actual input with a type of "file". 
# So let's instead target this and directly upload the file we want to it using send_keys.
# We should be able to upload our file by doing something like this then
driver.find_element(xpath: '//*[@type="file"]').send_keys("#{Dir.pwd}/hn_data.csv")

sleep(3)

# After we upload our file, the prompt to import the file is no longer within the upload iframe, so we will need to
# switch back out of our iframe to the default page content
driver.switch_to.default_content

# Select the import button to import our file to the document
driver.find_element(class: 'goog-buttonset-action').click

binding.pry

puts 'the end'
