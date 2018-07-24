require 'rails_helper'

RSpec.describe User, type: :model do
  it 'gives a user 10,000 points on create' do
  	user = User.create(email: 'test@test.com', password: 'password')
    expect(user.points).to eq(10_000)
  end
end
