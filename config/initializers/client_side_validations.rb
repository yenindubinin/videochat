# ClientSideValidations Initializer

# Commented by AF. Updated the gem to version 3.2. Simple_form and formtastic support is done using a gem.
#require 'client_side_validations/simple_form' if defined?(::SimpleForm)
#require 'client_side_validations/formtastic'  if defined?(::Formtastic)

# Uncomment the following block if you want each input field to have the validation messages attached.
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  unless html_tag =~ /^<label/
    %{<div class="field_with_errors">#{html_tag}<div class="error_notice"><span class="arrow"></span><label for="#{instance.send(:tag_id)}" class="message">#{instance.error_message.first}</label></div></div>}.html_safe
  else
    %{<div class="field_with_errors">#{html_tag}</div>}.html_safe
  end
end

