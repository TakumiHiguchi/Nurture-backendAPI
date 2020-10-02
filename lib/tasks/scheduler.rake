namespace :scheduler do
    desc "This task is called by the Heroku scheduler add-on"
    task :get_news => :environment do
       require 'nokogiri'
        require 'open-uri'
        require 'csv'

        #スクレイピング先url
        url = 'https://www.nihon-u.ac.jp'
        charset = 'utf-8'
        
        #リクエストを投げる
        begin
            html = open(url,'User-Agent' => 'Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)') { |f| f.read }
            News.destroy_all
            rescue OpenURI::HTTPError => e
        end
        
        #parseする
        doc = Nokogiri::HTML.parse(html, nil, charset)
        
        
        links = doc.xpath('//ul[@class="list_pattern_a"]/li/a/@href')
        date = doc.xpath('//ul[@class="list_pattern_a"]/li/a/p[@class="date"]')
        titles = doc.xpath('//ul[@class="list_pattern_a"]/li/a/p[@class="title"]')
        pageTitle = doc.xpath('//title')
        
        if doc.xpath('//ul[@class="list_pattern_a"]')
            lsCount = doc.xpath('//ul[@class="list_pattern_a"]/li/a/@href').count
            lsCount.times do |i|
                if !links[i].text.include?("https://") && !links[i].text.include?("http://")
                    link = "https://www.nihon-u.ac.jp" + links[i].text
                else
                    link =  links[i].text
                end
                lpdate = date[i].text.gsub("月", "/").gsub("年", "/").gsub("日", "")
                title = titles[i].text
                baseTitle = pageTitle.text.gsub(" ", "")
                News.create(:title => title, :date => lpdate, :link => link, :base_title => baseTitle, :base_link => url)
            end
        end
    end
end

