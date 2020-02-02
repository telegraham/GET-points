class User < ActiveRecord::Base

  before_validation :slugify_name
  after_initialize :create_login_token

  has_many :clicks, -> { order("created_at desc") }

  # has_many :transfers_from, class_name: "Transfer", foreign_key: :from_id

  def transfers
    Transfer.where("from_id = ? OR to_id = ?", self.id, self.id)
    .order("coalesce(created_at, to_timestamp(0)) desc, id desc")
  end

  def transfers_total
    transfers_received_total - transfers_sent_total
  end

  def transfers_sent_total
    transfers_from_total || 0
  end

    def transfers_received_total
    transfers_to_total || 0
  end

  def click_timeouts_total
    clicks.map(&:timeout).sum
  end

  def latest_click
    clicks.first
  end

  def can_click?
    clicks.none? || (latest_click.next_click_allowed <= Time.now)
  end

  def click!
    clicks.create
  end

  default_scope -> {
    joins( 'left join (select to_id, sum(points) as to_points from transfers group by to_id) as transfers_to on transfers_to.to_id = users.id
            left join (select from_id, sum(points) as from_points from transfers group by from_id) as transfers_from on transfers_from.from_id = users.id
            left join (select user_id, sum(value) as click_points from clicks group by user_id) as clicks on clicks.user_id = users.id')
    .select('users.*, 
      clicks.click_points as click_points_total,
      transfers_to.to_points as transfers_to_total,
      transfers_from.from_points as transfers_from_total,
      coalesce(clicks.click_points, 0) 
        + coalesce(transfers_to.to_points, 0) 
        - coalesce(transfers_from.from_points, 0) as points')
    .order('points DESC')
  }

  private 

  def create_login_token
    self.auth_token ||= SecureRandom.uuid
  end

  def slugify_name
    self.slug = self.name.downcase.gsub(/[^a-z]+/, "-")
  end

end