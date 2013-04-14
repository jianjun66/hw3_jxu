# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(:title=>movie[:title], :rating=>movie[:rating], :release_date=>[:release_date])
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  first = page.body.index(e1)
  second = page.body.index(e2)
  first < second
end

Then /I should see all of the movies/ do 
  Movie.count.should == Movie.all.count
end

Then /I should see the movies with the following ratings: (.*)/ do |r| 
  ratings_str = r.split(%r{,\s*})
  m = Movie.where(:rating=>ratings_str)
  m.each do |mo|
    step "I should see \"#{mo.title}\""
  end
end

Then /I should not see the movies with the following ratings: (.*)/ do |r| 
  ratings_str = r.split(%r{,\s*})
  m = Movie.where(:rating=>ratings_str)
  m.each do |mo|
    step "I should not see \"#{mo.title}\""
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  steps = rating_list.split(%r{,\s*})
  tmp_str = (uncheck)?'uncheck':'check'
  
  steps.each do |s|
    if uncheck == "un"
      step %Q{I uncheck "ratings_#{s}"}
      step %Q{the "ratings_#{s}" checkbox should not be checked}
    else 
      step %Q{I check "ratings_#{s}"}
      step %Q{the "ratings_#{s}" checkbox should be checked}
    end
  end
end

Then /I should see the following (un)?checked ratings: (.*)/ do |uncheck, rating_list|
  steps = rating_list.split(%r{,\s*})

  steps.each do |s|
    if uncheck == "un"
      step %Q{the "ratings_#{s}" checkbox should not be checked}
    else 
      step %Q{the "ratings_#{s}" checkbox should be checked}
    end
  end 
end

When /I (un)?check all the ratings/ do |uncheck|
  all_ratings = Movie.all_ratings();
  tmp_str = (uncheck)?'un':''

  all_ratings.each do |s|
    if uncheck == "un"
      step %Q{I uncheck the following ratings: #{s}}
    else
      step %Q{I check the following ratings: #{s}}
    end
  end
end

Then /^print the page$/ do
  puts page.body
end
