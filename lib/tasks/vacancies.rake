namespace :vacancies do
  desc "Vacancies tasks"
  task unpublish_closed: :environment do
    hostname = ENV['HOSTNAME'] || '127.0.0.1'
    Cms::Site.where(identifier: 'vacancies').each do |vacancy|
      Cms::Page.where(site_id: vacancy.id).where.not(slug: 'index').each do |page|
        p = Cms::Block.where(identifier: 'closing_date', page_id: page.id).first
        if p and Time.now > p.content
          Cms::Page.update(page.id, is_published: false)
        end
      end
    end
  end
end
