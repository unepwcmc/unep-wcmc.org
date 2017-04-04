module ApplicationHelper
  def block_content(identifier, page)
    return '' unless block = page.blocks.find {
      |block| block.identifier == identifier.to_s
    }
    ComfortableMexicanSofa::Tag.process_content(page, block.content)
  end

  def page_files(identifier, page)
    return nil unless block = page.blocks.find {
      |block| block.identifier == identifier.to_s
    }
    block.files
  end

  def page_file(identifier, page)
    p = page_files(identifier, page)
    p ? p[0] : nil
  end

  def active_class_link_to(name, path, opts={})
    opts[:class] ||= ""
    opts[:class] << " active" if current_page?(path)

    link_to(name, path, opts)
  end

  def active_subnav_link_to(text, path, identifier, slug, opts={})
    opts[:title] = text
    opts[:class] ||= ""
    opts[:class] << " active" if @cms_site.identifier == identifier && @cms_page.slug == slug

    link_to(text, path, opts)
  end

  def active_cms_page_link_to(text, path, page, opts={})
    opts[:title] = text
    opts[:class] ||= ""
    opts[:class] << " active" if page == @cms_page

    link_to(text, path, opts)
  end
end