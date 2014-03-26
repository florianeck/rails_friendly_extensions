module FriendsFormsHelper
  
  def fieldset(title, options = {}, &block)
    if options[:if].nil? || options[:if] == true
      data_string = " "
      if options[:data]
        options[:data].each {|d,v| data_string << "#{d}='v' "}
      end  
      concat raw("<fieldset id='#{options[:id]}' #{data_string} class='shadow #{options[:mainclass]}' #{("style='height: %spx'" % options[:height]) if options[:height]} style='#{options[:mainstyle]}'>")
      concat raw("<legend class='#{options[:class]}' style='#{options[:style]}'>#{title}</legend><div class='fieldset-content'>")
        yield
      concat raw("</div></fieldset>")
    end  
  end  
    
  def tooltip_box(tooltip)
    "<span class='label-tooltip' title='#{tooltip}'>&nbsp;</span>".html_safe
  end
  
  def tooltip_content_box(name, options = {}, &block)
    options[:default_class] ||= "icon-clue"
    html = "<div class='tooltip-box'><div class='tooltip-box-label #{options[:default_class]}'>"
    html << "#{name}<div class='tooltip-box-content #{options[:css]} box rounded shadow'>#{capture(&block)}</div></div></div>"
    concat(html.html_safe)
  end    
  
end  