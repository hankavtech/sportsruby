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

  driver.get "https://www.livescore.in/"
    driver.find_element(:xpath,"//div[@id='timezone']").click
  driver.find_element(:xpath,"//div[@id='tzcontentenv']/ul/li[descendant::a[contains(text(),'GMT+0')]]").click
  sleep 5
  f=File.new("footballresults.txt","w")    
  parsed=Nokogiri::HTML(driver.page_source)
        
         sport=parsed.css("table").attribute("class")
         parsed.css("table").each do |sporttable| 
           region=sporttable.css("thead").css("tr").css("span.country_part").text.encode("iso-8859-1").force_encoding("utf-8")
           event=sporttable.css("thead").css("tr").css("span.tournament_part").text.encode("iso-8859-1").force_encoding("utf-8")
             sporttable.css("tbody").css("tr.stage-finished:not(.no-service-info)").each do |row| 
                        f.print row.attribute('id')  
                        f.print("||")
                      status=row.css("td.cell_aa").css("span").text.encode("iso-8859-1").force_encoding("utf-8") 
                        f.print status
                        if status!="Canc" && status!="Postp" && status!="Abn"             
                        f.print("||")
                        f.print row.css("td.part-top").text.encode("iso-8859-1").force_encoding("utf-8")
                        f.print("||")
                        end
                        if status=="Fin" 
                        f.print row.css("td.cell_sa").text.encode("iso-8859-1").force_encoding("utf-8")
                        end
                        if status=="Pen" || status=="AET"
                        f.print row.css("td.cell_sa").children.last.text.encode("iso-8859-1").force_encoding("utf-8")
                        f.print("||")
                        f.print row.css("td.cell_sa").children.first.text.encode("iso-8859-1").force_encoding("utf-8")
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
             sporttable.css("tbody").css("tr.stage-finished:not(.no-service-info)").each do |row| 
                      
                        f.print row.attribute('id')  
                        f.print("||")
                      status=row.css("td.cell_aa").css("span").text.encode("iso-8859-1").force_encoding("utf-8") 
                        f.print status
                        if status!="Canc" && status!="Postp" && status!="Abn"             
                        f.print("||")
                        f.print row.css("td.part-top").text.encode("iso-8859-1").force_encoding("utf-8")
                        f.print("||")
                        end
                        if status=="Fin" 
                        f.print row.css("td.cell_sa").text.encode("iso-8859-1").force_encoding("utf-8")
                        end
                        if status=="Pen" || status=="AET"
                        f.print row.css("td.cell_sa").children.last.text.encode("iso-8859-1").force_encoding("utf-8")
                        f.print("||")
                        f.print row.css("td.cell_sa").children.first.text.encode("iso-8859-1").force_encoding("utf-8")
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



scraper
