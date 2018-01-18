#Get-Candy Object Properties

Name
Description
Packaging [String (Boxed,FoilWrapped,Wrapped)
IsChocolate [Boolean]
ContainsNuts [Boolean]
Manufacturer [String]
PeanutFreeFacility [Boolean]
Format [String (bar,Roll,Drops)]
ItemsPerPackage [Int]

#Get-Candy Methods
Count

#Find candy that is chocolate
get-candy | Where-Object -Property IsChocolate -EQ $true

#Find Candy this is not in a box
Get-Candy | where-Object -Property Packaging -NE 'Boxed'



#Count amount of candy objects
(get-candy).count

#Example Output
Get-Candy

>Name: DOTS
Description: Assorted Fruit Flavored Gumdrops
Packaging: Boxed
IsChocolate: $False
ContainsNuts: $false
Manufacturer: Tootsie Roll Industries, Inc.
PeanutFreeFacility: $True
ItemsPerPackage: 

Name: Mr.GoodBar
Description: milk chocolate with peanuts
Packaging: FoilWrapped
IsChocolate: $True
ContainsNuts: $True
Manufacturer: Hershey
PeanutFreeFacility: $False
Format: Bar
ItemsPerPackage: 1