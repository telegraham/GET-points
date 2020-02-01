class User < ActiveRecord::Base

  before_validation :slugify_name
  after_initialize :create_login_token

  has_many :clicks

  has_many :transfers_to, class_name: "Transfer", foreign_key: :to_id
  has_many :transfers_from, class_name: "Transfer", foreign_key: :from_id

  def points
    clicks.sum(:value) + transfers_to.sum(:points) - transfers_from.sum(:points)
  end

  def latest_click
    self.clicks.order("created_at desc").first
  end

  def can_click?
    !self.latest_click || self.latest_click.next_click_allowed <= Time.now
  end

  def click!
    self.clicks.create
  end

  private 

  def create_login_token
    self.auth_token ||= SecureRandom.uuid
  end

  def slugify_name
    self.slug = self.name.downcase.gsub(/[^a-z]+/, "-")
  end

end