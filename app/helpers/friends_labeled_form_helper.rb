# -*- encoding : utf-8 -*-
module FriendsLabeledFormHelper

  def self.included(arg)
    ActionView::Helpers::FormBuilder.send(:include, FriendsLabeledFormBuilder)
  end

  def label_tag_for(object_name, method, options = {})
    label_name = (options[:label].blank? ? method.to_label : options[:label])
    
    label_name += options[:append] unless options[:append].nil?
    
    label_text = "<span class='label-text'>#{label_name}</span>"

    if options[:errors]
      label_text << tooltip_box(options[:errors].to_text)
    elsif ((options[:label].blank? && options[:tooltip].blank?) || !options[:tooltip].blank?) && options[:tooltip] != false
      tooltip = (options[:tooltip] || method.to_label(:show_tooltip => true))
      if !tooltip.blank? && options[:hide_tooltip] != true
        # Setting Tooltip format for display in Browsertooltip
        # line breaks in unicode
        tooltip = tooltip.gsub(/\n|\<br(\ )?(\/)?\>/, "&#xA;")
        # single to double quotes 
        tooltip = tooltip.gsub("'", '"')
        label_text << tooltip_box(tooltip)
      end  
    end    
      
    
    label_options = {}
    label_options.merge!(:class => options[:class]) unless options[:class].blank?
    label_options.merge!(:for => options[:for]) unless options[:for].blank?
    label_options.merge!(:id => options[:id]) unless options[:id].blank?

    return label(object_name, method, label_text.html_safe, label_options).html_safe
  end

  def labeled_text_field(object_name, method, options={})
    
    if options[:id]
      label_options = options.merge(:id => "label-#{options[:id]}")
    else
      label_options = options
    end    
    
    html = label_tag_for(object_name, method, label_options)
    if options[:password] && options.delete(:password)
      html += password_field(object_name, method, options)
    else  
      html += text_field(object_name, method, options)
    end  
    return html.html_safe
  end

  def labeled_check_box(object_name, method, options={}, checked_value=1, unchecked_value=0)
    method = method.to_s.to_sym
    box_id = object_name.to_s+"_"+method.to_s
    
    html = "<div class='cf labeled-check-box'>"
    html += "<div class='checkbox-container'>#{check_box(object_name, method, options.merge!(:id => box_id), checked_value, unchecked_value)}</div>"
    html += "<div class='checkbox-label-container'>#{label_tag_for(object_name, method, :label => options[:label], :tooltip => options[:tooltip], :class => "checkbox-label", :for => box_id, :errors => options[:errors])}</div>"
    html += "</div>"

    return html.html_safe
  end



  def labeled_radio_button(object_name, method, value, options = {})
    options[:id] ||= "radio-#{method.to_s}-#{value.inspect}"
    options[:label] ||= method.to_label
    html = "<div class='cf labeled-radio-button'>"
    html << radio_button(object_name, method, value, options.except(:label, :errors))
    html << "&nbsp;"
    html << label_tag_for(object_name, method, {:label => options[:label], :for => options[:id]})
    html << "</div>"
    return raw(html)
  end    

end

module FriendsLabeledFormBuilder
  
  def label_tag_for(method, options = {})
    @template.label_tag_for(@object_name, method, options)
  end  
  

  def labeled_radio_button(method, value, options ={})
    options[:checked] = (object.send(method) == value) if options[:checked].nil?

    options[:class] ||= ""
    options[:class] << " error" if ((!object.errors[method.to_sym].empty? && !object.new_record?) rescue false  )
    options[:errors] = ((object.errors[method.to_sym].empty? ? nil : object.errors[method.to_sym]) rescue false )

    @template.labeled_radio_button(@object_name, method, value, options)
  end


  def labeled_check_box(method, options = {}, checked_value=1, unchecked_value=0)

    options[:class] ||= ""
    options[:class] << " error" if ((!object.errors[method.to_sym].empty? && !object.new_record?) rescue false  )
    options[:errors] = ((object.errors[method.to_sym].empty? ? nil : object.errors[method.to_sym]) rescue false )

    options[:checked] ||= ((object.send(method) rescue false) || options[:checked])
    @template.labeled_check_box(@object_name, method, options, checked_value, unchecked_value)
  end    


  def labeled_text_field(method, options = {})

    options[:value] ||= (object.send(method) rescue nil )
    options[:class] ||= ""
    options[:class] << " error" if ((!object.errors[method.to_sym].empty? && !object.new_record?) rescue false )

    options[:errors] = ((object.errors[method.to_sym].empty? ? nil : object.errors[method.to_sym]) rescue false )

    @template.labeled_text_field(@object_name, method, options)
  end  

end  

