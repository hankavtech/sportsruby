require 'nokogiri'
require 'httparty'
require 'watir'
require 'selenium-webdriver'

def scraper
        # options = Selenium::WebDriver::Chrome::Options.new
        #options.add_argument('--headless')
	driver = Selenium::WebDriver.for :chrome #,options: options
	driver.manage.timeouts.page_load = 120
	driver.manage.timeouts.implicit_wait = 120

	driver.get "https://www.livescore.in/hockey/"
    driver.find_element(:xpath,"//div[@id='timezone']").click
	driver.find_element(:xpath,"//div[@id='tzcontentenv']/ul/li[descendant::a[contains(text(),'GMT+0')]]").click
    driver.find_element(:css,"ul.ifmenu li.ifmenu-odds span").click
	sleep 5
	f=File.new("http://localhost:8080/foot/matchesscraper/hockeymatches.txt","w")    
	parsed=Nokogiri::HTML(driver.page_source)
	      
	       sport=parsed.css("table").attribute("class").text.split(' ').first
	       parsed.css("table").each do |sporttable| 
           region=sporttable.css("thead").css("tr").css("span.country_part").text
           event=sporttable.css("thead").css("tr").css("span.tournament_part").text
	          sporttable.css('tr.stage-scheduled:not(.no-service-info)').each do |row|
		                	  f.print sport
		                	  f.print "||"
		                	  f.print region
		                	  f.print "||"
		                	  f.print event
		                	  f.print "||"
		                	  unparsedday=parsed.css("li[id='ifmenu-calendar']").css("span.h2").css("a").text
	          	              onlydaymonth=unparsedday.split(" ")[0]
	          	              onlyday=onlydaymonth.split("/")[0]
	          	              onlymonth=onlydaymonth.split("/")[1]
	          	              onlyyear=getmatchyear(onlyday,onlymonth)
		                	  onlytime=row.css("td")[0].text
                              f.print "#{onlyday}/#{onlymonth}/#{onlyyear} #{onlytime}"
		      			      f.print "||"
		      			      f.print row.attribute('id')
		      			      f.print "||"
		      			      f.print row.css("td.team-home").css("span").text 
	        			      f.print "||"
	        			      f.print row.css("td.team-away").css("span").text
	        		          f.puts " "
	             
	          end
	       end

	sleep(5) 
    driver.find_element(:id, 'ifmenu-calendar').click
    sleep 5
    driver.find_element(:xpath, "//a[@class='ifmenu-active ifmenu-today']/parent::li/following-sibling::li/a").click
    sleep 15
    driver.find_element(:css,"ul.ifmenu li.ifmenu-odds span").click
    sleep 5
    parsed=Nokogiri::HTML(driver.page_source)
    parsed.css("table").each do |sporttable|
       region=sporttable.css("thead").css("tr").css("span.country_part").text
       event=sporttable.css("thead").css("tr").css("span.tournament_part").text
       sporttable.css('tr.stage-scheduled:not(.no-service-info)').each do |row|	          	  
	          	  f.print sport
	          	  f.print "||"
	          	  f.print region
	          	  f.print "||"
	          	  f.print event
	          	  f.print "||"	              
	          	  unparsedday=parsed.css("li[id='ifmenu-calendar']").css("span.h2").css("a").text
	          	  onlydaymonth=unparsedday.split(" ")[0]
	          	  onlyday=onlydaymonth.split("/")[0]
	          	  onlymonth=onlydaymonth.split("/")[1]
	          	  onlyyear=getmatchyear(onlyday,onlymonth)
	          	  onlytime=row.css("td")[0].text
                  f.print "#{onlyday}/#{onlymonth}/#{onlyyear} #{onlytime}"
	          	  f.print "||"
				  f.print row.attribute('id')
				  f.print "||"
				  f.print row.css("td.team-home").css("span").text 
				  f.print "||"
				  f.print row.css("td.team-away").css("span").text
			      f.puts " " 
       
        end
        
    end
    



end


def getmatchyear(matchday,matchmonth)
	time1=Time.now.getlocal("+00:00")
	cyear=time1.year
	cmonth=time1.month
	cday=time1.day
	mtime=Time.new(cyear,matchmonth,matchday).getlocal("+00:00")
	myear=cyear
	mday=mtime.day
	if cmonth==12 && mday<cday
		myear=cyear+1
	end
	return myear
end

def wait_for(seconds)
  Selenium::WebDriver::Wait.new(timeout: seconds).until { yield }
end

scraper

