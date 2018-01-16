######################################################################################################
# Join and merge in R
# Renata Muylaert
# https://stackoverflow.com/questions/1299871/how-to-join-merge-data-frames-inner-outer-left-right
# script_merge_intersect_fintersect_match_full_join_smartbind
# merge()
# dplyr::intersect()
# data.table::fintersect(setDT(), setDT())
# match()
# dplyr::full_join()
######################################################################################################

# Create the dataframes

df1 <- data.frame(V1 = LETTERS[1:4], V2 = 1:4)
df2 <- data.frame(V1 = LETTERS[2:3], V2 = 2:3)

df1
df2


# You can use inner joins when there is nested information on 2 dataframes

merge(df1, df2)
merge(df2, df1)

# Not that it captures all the information of df1 :) 
df1 <- data.frame(V1 = LETTERS[1:4], V2 = 1:4, V3=2:5, V4=c("dog"))
merge(df1, df2)

# And the inverse?
df2 <- data.frame(V1 = LETTERS[1:4], V2 = 1:4, V3=2:5, V5=c("cat"))

# It captures all the info of both?
merge(df1, df2)

# But CAUTION.. with the names of columns
df2 <- data.frame(V1 = LETTERS[1:4], V2 = 1:4, V3=2:5, V4=c("cat"))
merge(df1, df2)

# Now with dplyr
df2 <- data.frame(V1 = LETTERS[1:4], V2 = 1:4, V3=2:5, V5=c("cat"))

# Oh... it does not intersect! Different columns are not incorporated
dplyr::intersect(df1, df2)

# Lets return to simple nested dataframes

df1 <- data.frame(V1 = LETTERS[1:4], V2 = 1:4)
df2 <- data.frame(V1 = LETTERS[2:3], V2 = 2:3)
str(df1)
str(df2)
df3 <- dplyr::intersect(df1, df2)
 
# CAUTION: Oh shit, it changed V1 to character! Do you want that?

str(bla)

# Now with data.table 

require(data.table)
df4 <- data.table::fintersect(setDT(df1), setDT(df2))

# data.table mantain V1 as factor

str(df4)

# Let´s see how data.table deals with more complex nested data

df1 <- data.frame(V1 = LETTERS[1:4], V2 = 1:4, V3=2:5, V4=c("dog"))
df2 <- data.frame(V1 = LETTERS[2:3], V2 = 2:3)

# Oh...  they must have same column names... 

df5 <- data.table::fintersect(setDT(df1), setDT(df2))

# Oh.. they must have same column classes..

df2 <- data.frame(V1 = LETTERS[2:3], V2 = 2:3, V3= c(0), V4=c("don´t know"))
df1
df5 <- data.table::fintersect(setDT(df1), setDT(df2))

str(df1)
str(df2)

# And same contents...

df2 <- data.frame(V1 = LETTERS[2:3], V2 = 2:3, V3=as.integer( c(3,4)), V4=c("dog"))
str(df2)
df5 <- data.table::fintersect(setDT(df1), setDT(df2))
df1
df2
df5

######################################################################################################
     
# Using match

df1 <- data.frame(CustomerId=1:6,Product=c(rep('Toaster',3L),rep('Radio',3L)));
df2 <- data.frame(CustomerId=c(2L,4L,6L,7L),State=c(rep('Alabama',2L),'Ohio','Texas'));

# Note that customer 7 is not in df1

df1
df2

#Let´s understand the indexing
names(df2)[-1L]
names(df1)[-1L]

names(df1)[1L]
names(df2)[1L]

# Match with key name
match(df1[,1L],df2[,1L])

# Same as
match(df1[,"CustomerId"],df2[,"CustomerId"])

# Set right places

# content from "State"
names(df2)[-1L]
df2[match(df1[,1L],df2[,1L]),-1L]

# CAUTION content going to an unexisting place (State)
names(df2)[-1L]

df1[names(df2)[-1L]]

# Replace directly in df1 with no information 
# on customer 7 from Texas

# You are creating a column

df1[names(df2)[-1L]] <- df2[match(df1[,1L],df2[,1L]),-1L]

# Now, state exists in df1

df1[names(df2)[-1L]]


df1

#################### Full join in dplyr

# Full join adds columns and rows. Its handy!

# Now we get the customer from Texas 

df1 <- data.frame(CustomerId=1:6, Product=c(rep('Toaster',3L),rep('Radio',3L)));
df2 <- data.frame(CustomerId=c(2L,4L,6L,7L), State=c(rep('Alabama',2L),'Ohio','Texas'));

# It gets that you only have 1 column in common :)
dplyr::full_join(df1, df2)

str(dplyr::full_join(df1, df2))

# Or just tell him that

dplyr::full_join(df1, df2, by= "CustomerId")

##################### smartbind()
require(gtools)
# Efficient rbind of data frames, even if the column names don't match perfectly

df1 <- data.frame(A=1:10, B=LETTERS[1:10], C=rnorm(10) )
df2 <- data.frame(A=11:20, D=rnorm(10), E=letters[1:10] )

# rbind would fail
rbind(df1, df2)
# but smartbind combines them, 
# appropriately creating NA entries
 
smartbind(df1, df2)
str(smartbind(df1, df2))
 
# specify fill=0 to put 0 into the missing row entries
# Really cool

smartbind(df1, df2, fill=0)



######################################################################################################
