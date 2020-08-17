class Job < ApplicationRecord
  def self.scrape_qiita
    agent = Mechanize.new
    url_base = 'https://jobs.qiita.com/postings'

    (1..100).each do |i|
      url_params = "?page=#{i}"
      
      sleep 0.1
      list_page = agent.get("#{url_base}#{url_params}")
      links = list_page.search('a.p-postings__posting')
      break if links.length == 0

      last_requested_at = nil
      links.each do |link|
        attr_from_qiita_job_elm(link)

        Job.find_or_create_by(service: 'qiita', url: attrs[:url]) do |j|
          j.attributes = attrs
        end
      end
    end
  end

  def self.attr_from_qiita_job_elm(elm)
    path = elm.attr :href
    attrs[:url] = "https://jobs.qiita.com#{path}" 
    container = elm.search('.p-postings__text').first
    
    attrs[:category] = container.search('.p-postings__postingProfession').first.text
    attrs[:title] = container.search('.p-postings__postingName').first.text
    attrs[:skills] = container.search('.p-postings__postingTagName').map(&:text)
    attrs[:place] = container.search(".fa-map-marker-alt + .p-postings__tagName").first.text
    fee_range_elms = container.search('.fa-yen-sign ~ .p-postings__tagName')
    attrs[:fee_min] = fee_range_elms[0].text
    attrs[:fee_max] = fee_range_elms[2].text
    attrs[:company_name] = container.search('.p-postings__postingEmployerName').first.text

    detail_page = agent.get(attrs[:url])
    %i[product_proposal_level business_proposal_level people_management_level].each do |field|
      detail_page.search(".p-postings__showRadioGroup input[name=#{field}]").each do |input|
        attrs[field] = input.search('+ span').text unless input.attr(:checked).nil?
      end
    end
  end
end
