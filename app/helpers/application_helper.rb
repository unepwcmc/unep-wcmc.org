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
    opts[:class] << " active" if @cms_site.identifier == identifier && @cms_page.slug.to_s == slug

    link_to(text, path, opts)
  end

  def active_cms_page_link_to(text, path, page, opts={})
    opts[:title] = text
    opts[:class] ||= ""
    opts[:class] << " active" if page == @cms_page

    link_to(text, path, opts)
  end

  def get_current_page_full_url
    return request.base_url + request.fullpath
  end

  def email_share_subject
    email_subject = ''

    if cms_block_content(:email_share_subject) != ''
      email_subject = cms_block_content(:email_share_subject)
    elsif cms_block_content(:project_name, @cms_page) != ''
      email_subject = cms_block_content(:project_name, @cms_page)
    elsif cms_block_content(:news_header, @cms_page) != ''
      email_subject = cms_block_content(:news_header, @cms_page)
    elsif cms_block_content(:position_title, @cms_page) != ''
      email_subject = cms_block_content(:position_title, @cms_page) + ' at UNEP-WCMC'
    else
      email_subject = 'Visit the UNEP-WCMC website'
    end

    return ERB::Util.url_encode(email_subject)
  end

  def email_share_body
    email_body = ''

    if cms_block_content(:email_share_content) != ''
      email_body = cms_block_content(:email_share_content)
    elsif cms_block_content(:project_name, @cms_page) != ''
      email_body = cms_block_content(:project_name, @cms_page) + ': ' + get_current_page_full_url
    elsif cms_block_content(:news_header, @cms_page) != ''
      email_body = cms_block_content(:news_header, @cms_page) + ': ' + get_current_page_full_url
    elsif cms_block_content(:position_title, @cms_page) != ''
      email_body = cms_block_content(:position_title, @cms_page) + ' at UNEP-WCMC: ' + get_current_page_full_url
    else
      email_body = 'Visit the UNEP-WCMC website: ' + get_current_page_full_url
    end

    return ERB::Util.url_encode(email_body)
  end

  def twitter_share_text
    share_text = ''
    share_text_end = ' | Read more on the @unepwcmc website: ' + get_current_page_full_url

    if cms_block_content(:email_share_subject) != ''
      share_text = cms_block_content(:email_share_subject) + share_text_end
    elsif cms_block_content(:project_name, @cms_page) != ''
      share_text = cms_block_content(:project_name, @cms_page) + share_text_end
    elsif cms_block_content(:news_header, @cms_page) != ''
      share_text = cms_block_content(:news_header, @cms_page) + share_text_end
    elsif cms_block_content(:position_title, @cms_page) != ''
      share_text = cms_block_content(:position_title, @cms_page) + share_text_end
    else
      share_text = 'Visit the @unepwcmc website | ' + get_current_page_full_url
    end

    return ERB::Util.url_encode(share_text)
  end
end
