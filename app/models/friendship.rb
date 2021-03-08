class Friendship < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: :User
  validates_uniqueness_of :user, scope: %i[friend]

  scope :friendlist, -> { where('status = ?', true) }
  scope :waiting, -> { where('status = ?', false) }

  def await(current_user, user)
    Friendship.where('friend_id = ?', current_user.id).or(Friendship.where('user_id = ?',
                                                                           user.id)).or(Friendship.where('friend_id = ?',
                                                                                                         user.id)).or(Friendship.where(
                                                                                                                        'user_id = ?', current_user.id
                                                                                                                      )).waiting
  end

  def friendss(current_user, user)
    Friendship.where('friend_id = ?', current_user.id).or(Friendship.where('user_id = ?',
                                                                           user.id)).or(Friendship.where('friend_id = ?',
                                                                                                         user.id))
      .or(Friendship.where('user_id = ?', current_user.id)).friendlist
  end

  def pendingreq(currentuser)
    Friendship.where('friend_id = ?', currentuser.id).waiting
  end
end
