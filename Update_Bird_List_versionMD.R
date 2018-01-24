# Script to update Ornithology Class Semester Bird List
# Modified by Matt DeSaix, 01-24-2018
# Created by Ben Nickley 12-03-2017

# This script produces a function, 'update_birdlist()', which updates the Semester Bird List for the BIOZ 416 Ornithology Class.
# The Semester Bird list consists of rows for each of the species seen (and an initial row for Total Species), and columns for each site visited and additional fields
# Species that have not yet been seen by the class are added to the bird list.
# Species for each trip are marked and also tallied under the row 'Total Species'.  The total # of species for the class is tallied at the top of the column 'Notes'

# Files Needed:
# 1.) The most recent 'Semester_Bird_List.csv' and 
# 2.) An eBird data export of the most recent sightings
# Create project with all files in same directory

# Outputs
# 1.) The updated 'Semester_Bird_List.csv'
# 2.) A list of species that are new for the class

# To use, simply run the code in this script. It will prompt you to enter the site name.

dat <- read.csv('Initial_Bird_List.csv')	#THIS IS THE CURRENT BIRD LIST
new <- read.csv('ebird.csv')	#THIS IS THE NEW eBird LIST FROM MOST RECENT FIELD TRIP, downloaded and re-named

update_birdlist <- function(dat, new){

# ---------------------------- BN's cool trick for adding Site name ----------------------------
  
# The site name is entered after the funciton update() has been called
readline(cat("Press [Enter]","\n"))
cat("Enter the Site Name:","\n","Use underscore for spaces (i.e. Belle_Isle)")
# Save input of site name as variable 'site'
site <- scan(file = "", what = "character", nmax = 1)

# ---------------------------- Add birds to the list that hadn't been seen already ----------------------------

# create a list of birds not already on the list
new_birds <- as.character(new[!(new$Species %in% dat$Common_Name),1])
# create a data frame of equal dimensions to the Semester_bird_list
new_birds.df <- as.data.frame(matrix( nrow = length(new_birds), ncol = ncol(dat)))
# add the list of new birds to this new dataframe
new_birds.df[,1] <- new_birds 
# make column names of the new bird dataframe the same as the semester bird list colnames (essential for rbind())
names(new_birds.df) <- names(dat)
# combine the two dataframes
dat <- rbind(dat, new_birds.df)

#  ---------------------------- Mark all birds  ----------------------------

# create new column with temp name 'new.site'
dat$new.site<-NA
# Mark all of the birds seen on this trip
dat[dat$Common_Name %in% new$Species, 'new.site'] <- 'x'
# Tally number of birds seen on trip
dat$new.site[1] <- nrow(new)
# Tally all birds seen so far
dat$Notes[1] <- nrow(dat) - 1
# Re-name 'new.site' with site name provided above
names(dat)[names(dat)=='new.site']<- site
cat(paste(site), "\n", "New Birds for the Class:", "\n")
# replace NA values with ""
dat[is.na(dat)] <- ""
# write file
write.csv(dat, file='Semester_Bird_List.csv', row.names = F)
## Output what the new birds from the trip were
if(nrow(new_birds.df)>=1){
  return(new_birds.df[,1])
}else{
    cat("\n", "NO NEW SPECIES")}
}

update_birdlist(dat, new)



