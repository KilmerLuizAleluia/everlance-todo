# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { Faker::Quote.yoda }
    completed { false }
    notes { ['first note', 'second note'] }
    user { create(:user) }
  end
end
