# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create(movie)
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  expect(page.body.index(e1)).to be < page.body.index(e2)
  #expect(actual).to be matcher(expected)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

Then /I should sort "(.*)"/ do |sorting_method|
  if sorting_method == "alphabetically"
    movies = Movie.order(:title)
    movies.each_cons(2) do |movie1, movie2|
      step "I should see \"#{movie1.title}\" before \"#{movie2.title}\""
    end
  elsif sorting_method == "release date"
    movies = Movie.order(:release_date)
    movies.each_cons(2) do |movie1, movie2|
      step "I should see \"#{movie1.title}\" before \"#{movie2.title}\""
    end
  end
end



When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb

  if uncheck #if the step file is When I uncheck the following ratings
    rating_list.split(', ').each do |field|
      uncheck("ratings_#{field}")
    end
  
  else
    rating_list.split(', ').each do |field|
      check("ratings_#{field}")
    end
  end
end


Then /I should see all the movies/ do
  # Make sure that all the movies in the app are visible in the table
  movies = Movie.all
  movies.each do |data|
    step "I should see \"#{data.title}\"" #step file only takes .title
    #\" is used to ensure that the variable is passed as a string
  end
end

