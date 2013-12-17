rails_friendly_extensions
============

This is my personal, useful lib to extend Rails basic methods for String, Date, Number, Hash and serveral other classes just for easy use... 

All in all, my first github project, trying to make some moves on new grounds or so... Just did it because i need this stuff, and some other 
code i wrote in the last three years, for serveral projects, so its just comfortable for for me to use it as a 'shared component'

What ever, maybe it will be useful to someone,  neither its test-covered nor checked any other way. so use it at ur own risk.

Up in here we have following tools: (just some examples for the best features, try the rest on ur own, it's all experimential, but's 
yet kinda useful to me, so feel free to check out;-):

Following Methods will be available for the Classes as listed below:

#= Class: Array
#== .avg(attr)
returns an average value of the attribute passed. E.g.: U have an Array of 'Orders' which all have a 'price'
@orders.avg(:price) returns an average of all orders price

#== .sum_with_attribute(attr)
returns the sum values of all items of the array. E.g.: U have an Array of 'Orders' which all have a 'price'
@orders.sum_with_attribute(:price) returns a sum of all orders price.
Special Feature:
@orders.sum_with_attribute("user.user_order_counts") returns a sum of all orders made by the users who made the selected orders.
That means, u can sum values retrievied from every kind of data selection based upon ur current array of data.
(!) Marked as very cool feature!

#== .count_for(data)
Easy function to find out how many items of the same type/data are included in an Array. E.g.:
[1,2,4,5,1,5,6,1,2,3].count_for(1) returns 3
Works with Strings, Numbers and almost any other Object


#== .seperate(count = 2)
Seperates an array into 'count' Arrays, each of them the same size. If Array.size is not %'count', the last Array
will take up the last items. E.g:
- [1,2,3,4].seperate(2) returns [[1,2],[3,4]]
- [1,2,3,4,5,6,7].seperate(3) returns [[1, 2], [3, 4], [5, 6, 7]]

#== .stack(count = 2)
Kinda similiar to '.seperate' buts works like that:
- [1,2,3,4,5,6,7].stack(2) = [[1, 2], [3, 4], [5, 6], [7]]
- [1,2,3,4,5,6,7].stack(3) = [[1, 2, 3], [4, 5, 6], [7]]
Divides all items of an Array into sets of 'count', starting from first item, so last set could maybe be smaller than 'count'
