class Comfy::Cms::FileObserver < ActiveRecord::Observer
  observe 'Comfy::Cms::File'

  def after_save(file)
    optimize_image(file)
  end

  private

  def optimize_image(file)
    path = file.file.path
    `convert -strip -interlace Plane -quality 80 #{path} #{path}` if file.is_image?
  end
end
