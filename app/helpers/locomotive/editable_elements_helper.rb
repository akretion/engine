module Locomotive
  module EditableElementsHelper

    def each_editable_element(blocks, elements_by_block)
      blocks.each_with_index do |block, block_index|
        elements_by_block[block[:name]].each_with_index do |(page, element), el_index|
          index = block_index * 100 + el_index
          yield(page, element, index)
        end
      end
    end

    def editable_text_format_to_input_type(editable_element)
      case editable_element.format
      when 'html'     then :rte
      when 'markdown' then :markdown
      else :text
      end
    end

    def editable_element_input_options(editable_element, index, options = {})
      {
        label:        editable_element_label(editable_element),
        placeholder:  false,
        hint:         editable_element.hint,
        wrapper_html: {
          id:   "#{editable_element.type.to_s.dasherize}-#{editable_element._id}",
          data: { block: editable_element.block || '' }
        }
      }.merge(options)
    end

    def editable_element_label(editable_element)
      label = <<-HTML
      <span class="label label-primary">#{editable_element.block_label}</span>
      &nbsp;
      #{editable_element.label}
      HTML

      label.html_safe
    end

    def nice_editable_elements_path
      _path = params[:preview_path] || current_site.localized_page_fullpath(@page, current_content_locale)
      _path = 'index' if _path.blank?

      truncate('/' + _path, length: 50)
    end

    def options_for_page_blocks(blocks)
      options_for_select(
        [[t('.blocks.all'), '']] +
        blocks.map do |block|
          block[:name].nil? ? [t('.blocks.unknown'), '_unknown'] : [block[:label], block[:name]]
        end)
    end

  end
end
