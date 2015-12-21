# Create a function to find the maximum value in 
# an array of numbers. 
# For instance: [100,10,-1000] should return 100.

# Create a function that takes two 
# arguments - both of them arrays. 
# Inside of the function, combine the arrays using 
# the items from the first array as keys and the 
# second array as values into a hash. 

# For example, when these two arrays are 
# supplied as arguments:
# ruby [:toyota, :tesla] ["Prius", "Model S"]
# they should return a hash like so:
# ruby {toyota: "Prius", tesla: "Model S"}


def itsFun(x)
	x + "Only in America!"
end
puts itsFun("Trump is the nominee? ")




arr = [56, -78, 567, 9786, 23]
def notsoFun(arr)
	bigNum = arr[0]
	for i in 0..arr.length
		if arr[i] > bigNum
		    bigNum = arr[i]
			return bigNum
		end
	end
end
puts notsoFun(arr)




arr1 = [:ny, :boston] 
arr2 = ["yankees","redsocks"]