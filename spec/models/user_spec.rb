# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  subject { described_class.create(name: 'User', email: 'email@user.com') }

  describe 'Validation' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'has 2100 default per_day_calorie_limit' do
      expect(subject.per_day_calorie_limit).to be_present
      expect(subject.per_day_calorie_limit).to eq(2100)
    end

    it 'has 2100 default per_month_price_limit' do
      expect(subject.per_month_price_limit).to be_present
      expect(subject.per_month_price_limit).to eq(1000)
    end

    it 'is not valid without name' do
      subject.name = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without email' do
      subject.email = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without per_day_calorie_limit' do
      subject.per_day_calorie_limit = nil
      expect(subject).to_not be_valid
    end

    it 'is not valid without per_month_price_limit' do
      subject.per_month_price_limit = nil
      expect(subject).to_not be_valid
    end
  end

  describe 'Associations' do
    it { should have_many(:meals) }
  end

  describe 'methods' do
    context '#daily_calorie_limit_exceeded' do
      let!(:meal) do
        Meal.create(food_name: 'Pizza', calorie_count: 2100, price: 20, took_at: DateTime.now, user_id: subject.id)
      end

      it 'should return true' do
        expect(subject.daily_calorie_limit_exceeded).to be_truthy
      end

      it 'should return false when limit is not reached' do
        meal.update(calorie_count: 2099)
        expect(subject.daily_calorie_limit_exceeded).to be_falsey
      end
    end

    context '#monhly_price_limit_exceeded' do
      let!(:meal) do
        Meal.create(food_name: 'Pizza', calorie_count: 2100, price: 1000, took_at: DateTime.now,
                         user_id: subject.id)
      end

      it 'should return true' do
        expect(subject.monhly_price_limit_exceeded).to be_truthy
      end

      it 'should return false when limit is not reached' do
        meal.update(price: 999)
        expect(subject.monhly_price_limit_exceeded).to be_falsey
      end
    end
  end
end
