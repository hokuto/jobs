class Job < ApplicationRecord
  def self.scrape_qiita
    agent = Mechanize.new
    url_base = 'https://jobs.qiita.com/postings'
    attrs = {}
    (1..100).each do |i|
      url_params = "?page=#{i}"
      
      sleep 0.1
      page = agent.get("#{url_base}#{url_params}")
      
      links = page.search('a.p-postings__posting')
      break if links.length == 0

      last_requested_at = nil
      links.each do |link|
        href = link.attr :href
        attrs[:key] = href.split('/').last.to_i
        container = link.search('.p-postings__text').first
        attrs[:category] = container.search('.p-postings__postingProfession').first.text
        attrs[:title] = container.search('.p-postings__postingName').first.text
        attrs[:skills] = container.search('.p-postings__postingTagName').map(&:text)
        attrs[:place] = container.search(".fa-map-marker-alt + .p-postings__tagName").first.text
        fee_range_elms = container.search('.fa-yen-sign ~ .p-postings__tagName')
        attrs[:pay_min] = fee_range_elms[0].text
        attrs[:pay_max] = fee_range_elms[2].text
        attrs[:company_name] = container.search('.p-postings__postingEmployerName').first.text
        
        Job.find_or_create_by(service: 'qiita', key: attrs[:key]) do |j|
          j.attributes = attrs
        end
      end
    end
  end
end
