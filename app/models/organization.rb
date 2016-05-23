class Organization < ActiveRecord::Base
  has_many :memberships, class_name: 'UserOrganizationMembership', dependent: :destroy
  has_many :members, through: :memberships, class_name: 'User', source: :user

  belongs_to :admin, class_name: 'User'

  has_many :spaces, dependent: :destroy

  def prefers_private?
    true
  end
end
