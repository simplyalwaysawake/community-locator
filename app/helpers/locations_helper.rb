# frozen_string_literal: true

module LocationsHelper
  def short_address(location)
    if location.city || location.state
      [location.city, location.state].reject { |p| p.to_s.empty? }.join(', ')
    else
      "#{location.country} #{location.postal_code}".strip
    end
  end
end
