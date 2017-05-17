desc "Generate thumbnails with paperclip"
task refresh_images: :environment do
  images = Comfy::Cms::File.all.select { |f| f.is_image? }
  images = images.select { |f| f.try(:file).exists? }
  images.each do |image|
    image.file.reprocess!
  end

  puts images.count
end