class User < ActiveRecord::Base

  before_validation :slugify_name
  after_initialize :create_login_token

  has_many :clicks

  def points
    clicks.sum(:value)
  end

  def latest_click
    self.clicks.order("created_at desc").first
  end

  def allowed_to_click?
    !self.latest_click || self.latest_click.next_click_allowed <= Time.now
  end

  def next_click_allowed_words
    self.latest_click.next_click_allowed_words
  end

  def click!
    self.clicks.create
  end

  private 

  def create_login_token
    self.auth_token ||= SecureRandom.uuid
  end

  def slugify_name
    self.slug = self.name.downcase.gsub(/[^a-z]/, "-")
  end

end