
# @count=0
@aux = {} # Put the intermediate results in an auxilliary array to minimize the recursions
# Returns minimum the number of insertions/deletions/updations required to
# transform `str1` to `str2` or vice-versa 
def transformation_distance(str1, str2)
  # puts "#{@count += 1}"

  str1,str2 = str1.downcase, str2.downcase
  # Dont need to compute if it has already been computed earlier, return from the aux hash.
  return @aux["#{str1}_#{str2}"] if !(@aux["#{str1}_#{str2}"].nil?)

  # if one string is empty, return the length of other string - obviously!
  return (@aux["#{str1}_#{str2}"] = str2.size) if str1.empty?
  return (@aux["#{str1}_#{str2}"] = str1.size) if str2.empty?

  
  # reduced_str denotes the last character removed from the original string.
  reduced_str1 = str1.size==1 ? "" : str1[0..-2]
  reduced_str2 = str2.size==1 ? "" : str2[0..-2]

  # Levenshtein algorithm:
  cost = (str1[-1] == str2[-1]) ? 0 : 1
  return (@aux["#{str1}_#{str2}"] = [transformation_distance(reduced_str1,str2) + 1,
            transformation_distance(str1,reduced_str2) + 1,
            transformation_distance(reduced_str1, reduced_str2) + cost].min)
end

############################################################################################################################

array_of_names = %w(abhishek-jain ashish-jain akanksha-jain utsav-jain tanvi-jain ranbir-kapoor narendra-modi raghuram-rajan deepika-padukone barrack-obama akansha-mathur)

search_query = "akaansha-jaain"

# The user's name is divided in 2 parts: first name and last name. When dealing with millions of records, 
# a better way would be to first filter out the possible matches assuming the user must have entered 
# either the first name or the last name correctly. This should be relatively simple using KMP and would 
# reduce the dataset significantly.
filtered_dataset = search_query.split('-').collect{|query| 
  array_of_names.select{|name| name.include?(query)}
}.flatten

puts "With the assumtion that either one of first name or last name would be exact match: \n"
if filtered_dataset.length > 0
  distance_for_filtered_names = filtered_dataset.collect{|name| transformation_distance(search_query, name)}
  suggestion = distance_for_filtered_names.each_with_index.min.last
  puts "\tDid you mean #{filtered_dataset[suggestion]}"
else
  puts "\tNo matches found..."
end


puts "\n\nWithout assumption: \n"
distance_for_names = array_of_names.collect{|name| transformation_distance(search_query, name)}
suggestion = distance_for_names.each_with_index.min.last
puts "\tDid you mean #{array_of_names[suggestion]}"


