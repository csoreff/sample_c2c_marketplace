class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  include DeviseTokenAuth::Concerns::User

  after_create :assign_sign_up_points

  def tokens_has_json_column_type?
    database_exists? && table_exists? && self.type_for_attribute('tokens').type.in?([:json, :jsonb])
  end

  private

  def assign_sign_up_points
  	self.points = 10_000
  end
end
