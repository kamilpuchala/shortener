class UrlValidator < ActiveModel::EachValidator
  require 'uri'
  
  def validate_each(record, attribute, value)
    begin
      uri = URI.parse(value)
      if !uri.is_a?(URI::HTTPS) || uri.host.to_s.strip.empty?
        record.errors.add(attribute, options[:message] || error_message )
      end
    rescue URI::InvalidURIError
      record.errors.add(attribute, options[:message] || error_message )
    end
  end
  
  private
  
  def error_message
    "must be a valid https URL with a given host (for example, 'https://example.com')"
  end
end
