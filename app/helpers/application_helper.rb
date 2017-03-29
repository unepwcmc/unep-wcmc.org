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

  def active_class_link_to(name, path, classes = nil)
    classArray = [];

    classArray.push(classes) if classes != nil

    classArray.push("active") if current_page?(path)
    
    classString = classArray.join(" ")

    link_to(name, path, class: classString)
  end
end
