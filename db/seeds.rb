# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

calories = (1..20).map {|n| n * 10}
dates = (1..20).map{|n| n.days.ago}
food_names = ['Sweet Potatoes', 'Burger', 'Pizza', 'French Fries', 'Russian Salad', 'Pasta', 'Chicken']
names = ['Jimmie Park', 'Jacob Beck', 'Sandra Rios', 'Otis Leonard', 'Jimmy Thornton', 'Byron Williamson', 'Omar Fisher', 'Antoinette Hanson', 'Jean Underwood', 'Olga Powers', 'Nicolas Cox', 'Evan Welch', 'Hugo Freeman', 'Susan Garza', 'Charlie Wallace', 'Allen Howard', 'Marguerite Joseph', 'Faith Pratt', 'Mindy Garner', 'Caleb Adams', 'Crystal Jenkins', 'Johanna Watkins', 'Carole Jacobs', 'Janice Martinez', 'Michele Adkins']
prices = (1..20).map {|n| n * 10}
names.each do |name|
  first_name, last_name = name.split(' ')
  user = User.create(name: name, email: "#{first_name}.#{last_name}@calories.com")
  (1..20).each do |num|
    Meal.create(user_id: user.id, food_name: food_names.sample, took_at: dates.sample, calorie_count: calories.sample, price: prices.sample)
  end
end
