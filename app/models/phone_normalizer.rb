class PhoneNormalizer
  def initialize(phone)
    Phonie.configuration.default_country_code = '49'
    begin
      @phone = Phonie::Phone.parse(phone.dup)
      @error = I18n.t('phones.errors.invalid') if @phone.nil?
    rescue => e
      @error = e.message
      @phone = nil
    end
  end

  attr_reader :error

  def valid?
    !@phone.nil? # && twilio_valid?
  end

  # def twilio_valid?
  #   lookup_client = Twilio::REST::LookupsClient.new
  #   begin
  #     response = lookup_client.phone_numbers.get(normalize)
  #     response.phone_number # if invalid, throws an exception. If valid, no problems.
  #     return true
  #   rescue => e
  #     @error = if e.code == 20_404
  #                "'#{format}' number was not found."
  #              else
  #                e.message
  #              end
  #     return false
  #   end
  # end

  def normalize
    @phone.nil? ? '' : @phone.format('%a%n').to_s
  end

  def format
    @phone.nil? ? '' : @phone.format(:us) # ("+%c (%a) %f-%l")
  end
end
