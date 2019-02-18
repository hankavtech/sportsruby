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

  driver.get "https://www.livescore.in/hockey"
    driver.find_element(:xpath,"//div[@id='timezone']").click
  driver.find_element(:xpath,"//div[@id='tzcontentenv']/ul/li[descendant::a[contains(text(),'GMT+0')]]").click
  sleep 5
  f=File.new("hockeyresults.txt","w")    
  parsed=Nokogiri::HTML(driver.page_source)
        
         sport=parsed.css("table").attribute("class")
         parsed.css("table").each do |sporttable| 
           region=sporttable.css("thead").css("tr").css("span.country_part").text.encode("iso-8859-1").force_encoding("utf-8") 
           event=sporttable.css("thead").css("tr").css("span.tournament_part").text.encode("iso-8859-1").force_encoding("utf-8") 
             i=0
             sporttable.css("tbody").css("tr.stage-finished").each do |row| 
                        i=i+1
                        f.print row.attribute('id')
                        f.print("||")
                        f.print row.css("td.cell_aa").css("span").text.encode("iso-8859-1").force_encoding("utf-8") 
                        f.print("||")
                        if i%2==1
                        text5=row.css("td.team-home").attr('class')
                        f.print text5.text.split(' ').last.encode("iso-8859-1").force_encoding("utf-8") 
                        end
                        if i%2==0                        
                        text1=row.css("td.team-away").attr('class')
                        f.print text1.text.split(' ').last.encode("iso-8859-1").force_encoding("utf-8") 
                        end                  
                        f.print("||")
                        f.print row.css("td.score-home").text.encode("iso-8859-1").force_encoding("utf-8") 
                        row.css("td.part-bottom").each do |col|
                           f.print("||")
                           f.print col.children.first.text.encode("iso-8859-1").force_encoding("utf-8") 
                        end
                        f.print row.css("td.score-away").text.encode("iso-8859-1").force_encoding("utf-8") 
                        row.css("td.part-top").each do |col|
                          f.print("||")
                          f.print col.children.first.text.encode("iso-8859-1").force_encoding("utf-8") 
                        end
                        f.puts " "
               
            end
         end

  sleep(5) 
    driver.find_element(:id, 'ifmenu-calendar').click
    sleep 5
    driver.find_element(:xpath, "//a[@class='ifmenu-active ifmenu-today']/parent::li/preceding-sibling::li[1]/a").click
    sleep 5
    parsed=Nokogiri::HTML(driver.page_source)
    parsed.css("table").each do |sporttable|
       region=sporttable.css("thead").css("tr").css("span.country_part").text.encode("iso-8859-1").force_encoding("utf-8") 
       event=sporttable.css("thead").css("tr").css("span.tournament_part").text.encode("iso-8859-1").force_encoding("utf-8") 
       i=0
       sporttable.css("tbody").css("tr.stage-finished").each do |row|  
                        i=i+1
                        f.print row.attribute('id')
                        f.print("||")
                        f.print row.css("td.cell_aa").css("span").text.encode("iso-8859-1").force_encoding("utf-8") 
                        f.print("||")
                        if i%2==1
                        text5=row.css("td.team-home").attr('class')
                        f.print text5.text.split(' ').last.encode("iso-8859-1").force_encoding("utf-8") 
                        end
                        if i%2==0                        
                        text1=row.css("td.team-away").attr('class')
                        f.print text1.text.split(' ').last.encode("iso-8859-1").force_encoding("utf-8") 
                        end                  
                        f.print("||")
                        f.print row.css("td.score-home").text.encode("iso-8859-1").force_encoding("utf-8") 
                        row.css("td.part-bottom").each do |col|
                           f.print("||")
                           f.print col.children.first.text.encode("iso-8859-1").force_encoding("utf-8")
                        end
                        f.print row.css("td.score-away").text.encode("iso-8859-1").force_encoding("utf-8") 
                        row.css("td.part-top").each do |col|
                           f.print("||")
                           f.print col.children.first.text.encode("iso-8859-1").force_encoding("utf-8")                    
                          
                        end
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

def own_text(node)
  # Find the content of all child text nodes and join them together
  node.xpath('text()').text
end


scraper
