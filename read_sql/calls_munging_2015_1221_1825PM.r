################################
# Processing time column of data
################################
library(chron) # for dealing with chronological objects
library(magrittr) # pipe operator
library(plyr) # rename

calls <- read.csv("calls_2014.csv")
# The date and time are recorded in the following format:
# "2014-01-01 00:38:00"
# Use substring to extract
calls_dates <- substr(as.character(calls[,2]), 2, 11) %>% as.Date()
calls_times <- substr(as.character(calls[,2]), 13, 20) %>%times() 
calls_hours <- hours(calls_times)

# Find out day of week
calls_days_of_week <- weekdays(calls_dates)
# vector of "Wednesday" , "Saturday", ...

calls_saturday <- calls_days_of_week == "Saturday" # Boolean, 1 if crime was on a Saturday
calls_sunday <- calls_days_of_week == "Sunday" # Boolean, 1 if crime was on a Sunday
calls_weekend <- calls_saturday + calls_sunday # OR of calls_saturday and calls_sunday
# the other way t do it is to define a function is_weekend that returns TRUE if the vector
# element is Saturday or Sunday:

# is_weekend <- function(day) {return(day=="Saturday"|day=="Sunday")}
# calls_weekend <- as.vector(sapply(calls_days_of_week, is_weekend))

days_of_week <- function(day) {if (day == 0) "weekday" else "weekend"}
calls$days <- sapply(calls_weekend, days_of_week)

# Determine periods as follows:
# Early Morning (before 6 AM): 0, Morning (between 6 AM and 12 PM): 1
# Afternoon (between noon and 6 PM): 2, Evening (between 6 PM and midnight): 3
hours_to_periods <- function(hour) {if (hour %/% 6 == 0) "early_morning" else if (hour %/% 6 == 1) "morning" else if (hour %/% 6 == 2) "afternoon" else "evening"}
calls$periods <- sapply(calls_hours, hours_to_periods)

# Rename "time" column to "times"
calls <- rename(calls, replace=c("time" = "event_time"))

###################################
# Classify each crime in a category
###################################

num_reasons <- length(unique(calls$reason))
reasons <- rep("placeholder", num_reasons)
names(reasons) <- as.vector(unique(calls$reason))

  # [1]  vandalism/criminal mischief             suspicious incident                     residential alarm                     
  # [4]  person robbery                          mentally-ill person (non-violent)       rape                                  
  # [7]  theft                                   noise ordinance violation               trespasser                            
 # [10]  general disturbance                     battery                                 suspicious person                     
 # [13]  unknown trouble                         hit and run (minor)                     threats/assaults - armed              
 # [16]  accident (minor)                        domestic disturbance                    signal out                            
 # [19]  commercial alarm                        man down                                accident (injuries)                   
 # [22]  attempted suicide                       vehicle b&e                             suspicious vehicle                    
 # [25]  bank alarm                              accident with road blockage             911 hang up                           
 # [28]  check the well being of                 non-emergency assistance                stolen vehicle                        
 # [31]  disturbance involving tow truck/driver  threatening animal                      threats/assault                       
 # [34]  abandoned vehicle                       obstruction on highway                  drunk pedestrian                      
 # [37]  illegally parked cars                   door alarm                              drug violation                        
 # [40]  missing person - adult                  ambulance escort                        theft by shoplifting                  
 # [43]  residential b&e                         commercial b&e                          obscene/harassing phone calls         
 # [46]  nuisance animal                         child neglect                           fraud-counterfeit                     
 # [49]  general investigation                   battery - fight in progress             lost/found property                   
 # [52]  sick or injured person                  battery - cutting                       fire                                  
 # [55]  general disturbance - armed             recovered missing person                liquor law violation                  
 # [58]  house/business check                    missing person - juvenile               disabled occupied vehicle             
 # [61]  hit and run (injuries)                  direct traffic                          child abuse                           
 # [64]  fugitive from justice                   bomb threat                             reckless vehicle                      
 # [67]  dead person                             mentally-ill person (violent)           trash dumping                         
 # [70]  stalking                                stolen/lost tag                         hold-up alarm                         
 # [73]  vehicle alarm                           other sex crimes                        recovered stolen vehicle              
 # [76]  officer with prisoner                   accident (general disturbance)          solicitor                             
 # [79]  community orientated policing detail    deviate sexual activities               school zone crossing                  
 # [82]  hit and run with road blockage          bank robbery                            designated patrol area - available    
 # [85]  weapons/armed                           commercial robbery                      battery - shooting                    
 # [88]  impersonating police officer            home invasion                           prostitution                          
 # [91]  industrial accident                     arson fire                              attempted rape                        
 # [94]  designated patrol area                  suspicious boat                         suicide                               
 # [97]  car jacking                             prowler                                 drunk driver                          
# [100]  escaped prisoner                        kidnapping                              law enforcement officer escort        
# [103]  gambling                                bad check passed                        immediate backup                      
# [106]  illegal fishing                         reckless boat                           suspicious luggage                    
# [109]  recovered stolen/lost tag               designated patrol area - intersections  security checkpoint alarm             
# [112]  rush-officer needs help                 suspicious video                        murder                                
# [115]  k-9 requested                           dead animal                             drowning                              
# [118]  hitchhiker                              abandoned boat                          stopping vehicle

# crimes to be classified as "other"
reasons[c(2:3, 5, 8:10, 12:13, 17:20, 22, 24:25, 27:29, 32, 38, 40, 45:47, 
          49, 51:52, 55:59, 63:65, 67:74, 76, 78:80, 84:85, 88, 90:91, 94:96, 98, 
          100:109, 111:113, 115:119)] = "other"

# Classifying the rest
reasons[1] = "mischief"; reasons[c(4, 83, 86)] = "robbery"
reasons[c(6,15, 33, 93)] = "assault"
reasons[c(7, 23, 42:44, 75, 89, 97)] = "theft"; reasons[c(11, 50, 53, 87)] = "battery"
reasons[39] = "drugs"
reasons[48] = "fraud"; reasons[54] = "fire"; reasons[92] = "arson"
reasons[99] = "dui"; reasons[114] = "murder"
reasons[c(14, 16, 21, 26, 30:31, 34:37, 41, 60:62, 66, 77, 81:82, 110, 120)] = "traffic"

# View all
# for (xyz in unique(calls$reason)) {cat(xyz, ": ", rep("\t", 4), reasons[xyz], " \n")}

# Add the categories to the calls data frame
calls$categories <- reasons[as.vector(calls$reason)] %>% as.character()

########################################################
# Randomize the longitude and latitude to anonymize data
########################################################

# The approach is to randomly add -0.0005 or 0.0005 to the longitude and latitude.
# This is equivalent to shifting the point by ~ 50 meters North or South and East or West.
# http://www.movable-type.co.uk/scripts/latlong.html
set.seed(567) #repeatability
num_samples <- length(calls$longitude)
offset_vector <- c(-0.0005, 0.0005)
offsets_long <- sample(offset_vector, num_samples, replace = TRUE)
offsets_lat <- sample(offset_vector, num_samples, replace = TRUE)
calls$longitude <- calls$longitude + offsets_long
calls$latitude <- calls$latitude + offsets_lat

###########################################################################
# Discard address column as we don't plan to use it and also it saves space
###########################################################################

calls$address <- NULL

# Write to a csv which will be put in the shiny app folder
write.table(calls, "calls_2014_munged.csv", sep=",")