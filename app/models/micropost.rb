class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  def self.from_users_followed_by(user)
    # followed_user_ids = user.followed_user_ids
    # where("user_id IN (?) OR user_id = ?", followed_user_ids, user)
    
    # better query for big data
    followed_user_ids = "SELECT FOLLOWED_ID
						FROM RELATIONSHIPS
						WHERE FOLLOWER_ID = :user_id"
    where("USER_ID IN (#{followed_user_ids}) OR USER_ID = :user_id",
          user_id: user)
  end
end