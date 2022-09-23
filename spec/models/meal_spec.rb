# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Meal, type: :model do
  let(:user) { User.create(name: 'User', email: 'email@user.com') }
  subject do
    described_class.new(food_name: 'Pizza', calorie_count: 120, price: 20, took_at: DateTime.now, user_id: user.id)
  end

  describe 'Validation' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without food_name' do
      subject.food_name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without calorie_count' do
      subject.calorie_count = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without price' do
      subject.price = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without took_at' do
      subject.took_at = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without user_id' do
      subject.user_id = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'Associations' do
    it { should belong_to(:user) }
  end
end
