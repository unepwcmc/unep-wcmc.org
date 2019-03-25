desc "Export resources to csv file"
task export_resources: :environment do
  attributes = %w{title content publication_date content_type first_url second_url author isbn}
  CSV.open("#{Rails.root}/lib/export_resources.csv", 'wb') do |csv|
    csv << attributes
    resources = Comfy::Cms::Site.find_by_identifier('resources-and-data')
                                .pages.root.children.published
                                .includes(blocks: [:files])
    attributes = attributes.map(&:to_sym)
    resources.each do |resource|
      row = []
      attributes.each do |attribute|
        row << block_content(attribute, resource)
      end
      csv << row
    end
  end
end

def block_content(identifier, page)
  return '' unless block = page.blocks.find {
    |block| block.identifier == identifier.to_s
  }
  ComfortableMexicanSofa::Tag.process_content(page, block.content)
end
