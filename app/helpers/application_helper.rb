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
end
