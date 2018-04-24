class Weather
  attr_accessor :location, :temperature

  # before :ensure_slug_uniqueness
  
  def initialize(option={})
    @location = option[:location]
    @temperature = option[:temperature]
  end

  def is_blank?
    @location.nil?
  end

  protected
    def ensure_slug_uniqueness
      
      # we also want to ensure the slug is not blank
      if self.slug.blank?
        errors.add(:slug, "can't be blank")
      end
      
      # if this is a new post, the id is nil
      # otherwise, the slug should point to this post's id
      unless Slug[self.slug].nil? || Slug[self.slug] == self.location.to_s
        errors.add(:slug, "is already taken")
      end
    end
end