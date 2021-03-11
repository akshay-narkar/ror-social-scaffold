class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: :User
  validates_uniqueness_of :user_id, scope: %i[friend_id]
  validates_uniqueness_of :friend_id, scope: %i[user_id]

  scope :friendlist, -> { where('status = ?', true) }
  scope :waiting, -> { where('status = ?', false) }

  def await(current_user, user)
    x = Friendship.where('friend_id = ?', current_user.id).and(Friendship.where('user_id = ?', user.id)).waiting
    x1 = Friendship.where('friend_id = ?', user.id).and(Friendship.where('user_id = ?', current_user.id)).waiting

    x2 = x + x1

    x2.empty? ? nil : x2
  end

  def friendss(current_user, user)
    y = Friendship.where('friend_id = ?', current_user.id).and(Friendship.where('user_id = ?',
                                                                                user.id)).friendlist

    y1 = Friendship.where('friend_id = ?', user.id).and(Friendship.where('user_id = ?', current_user.id)).friendlist

    y2 = y + y1

    y2.empty? ? nil : y2
  end

  def pendingreq(currentuser)
    Friendship.where('friend_id = ?', currentuser.id).waiting
  end
end
