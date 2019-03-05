# Load the packages
library(tidyverse)
library(NHANES)

# Check column names
colnames(NHANES)

# Look at contents
str(NHANES)
glimpse(NHANES)

# See summary
summary(NHANES)

# Look over the dataset documentation
?NHANES

# Datasets come from tidyr
# Tidy:
table1
table2
table3
table4a
table4b

###The pipe operator (%>%) helps doing the code more readable
colnames(NHANES)

NHANES %>%
  colnames()


#Standar R way of changing functions toguether
glimpse(NHANES)

NHANES %>%
  head() %>%
  glimpse()

# Modify an existing variable mutate() function
NHANES_changed <- NHANES%>%
  mutate(Height_meters = Height/100)

View(NHANES_changed)
View(NHANES)

# Or create a new variable based on a condition
NHANES_changed <- NHANES_changed %>%
  mutate(HighlyActive = if_else(PhysActiveDays >= 5, "yes", "no"))
View(NHANES)
View(NHANES_changed)

# Create or replace multiple variables by using the ","
NHANES_changed <- NHANES_changed %>%
  mutate(new_column = "only one value",
         Height = Height / 100,
         UrineVolAvarage = (UrineVol1 + UrineVol2)/2)


#EXERCISE 2
#1. Create a new variable called “UrineVolAverage” by calculating the average urine volumne (from “UrineVol1” and “UrineVol2”).
#2. Modify/replace the “Pulse” variable to beats per second (currently is beats per minute).
#3. Create a new variable called “YoungChild” when age is less than 6 years.

# Check the names of the variables
colnames(NHANES)

# Pipe the data into mutate function and:
NHANES_changed <- NHANES %>% # dataset
  mutate(
    # 1. Calculate average urine volume
    UrineVolAvarage = (UrineVol1 + UrineVol2)/2,
    # 2. Modify Pulse variable
    Pulse_new = Pulse/100,
    # 3. Create YoungChild variable using a condition
    YoungChild = if_else(Age <= 10, "TRUE", "FALSE")
  )
NHANES_changed

View(NHANES)
View(NHANES_changed)


# Select specific data by the variables -----------------------------------
NHANES_characteristics <-  NHANES %>%
    select(Age, Gender, BMI)
View (NHANES_characteristics)

# To *not* select a variable, us minus (-)
NHANES %>%
  select(-HeadCirc)
View(NHANES)


# When you have many variables with similar names, use "matching" functions
NHANES %>%
  select(starts_with("BP"), contains("Vol"))

?select_helpers


# Rename specific columns -------------------------------------------------
# rename using the form: "newname = oldname"
NHANES %>%
  rename(NumberBabies = nBabies,
         Sex = Gender)

# Filtering/subsetting the data by row ------------------------------------
# when gender is equal to female
NHANES %>%
  filter(Gender == "female")

# when gender is *not* equal to
NHANES %>%
  filter(Gender != "female")

# when BMI is equal to
NHANES %>%
  filter(BMI == 25)


# when BMI more or equal to 25
NHANES %>%
  filter(BMI >= 25)


# when BMI is equal to 25 and gender is female
NHANES %>%
  filter(BMI == 25 & Gender == "female")

# when BMI is equal to 25 or gender is female
NHANES %>%
  filter(BMI == 25 | Gender == "female")



# Sorting/(re)arranging your data by column -------------------------------

# ascending order by age
NHANES %>%
  arrange(Age) %>%
  select(Age)

# Descending order by age
NHANES %>%
  arrange(desc(Age)) %>%
  select(Age)

# order by age and gender
NHANES %>%
  arrange(Age, Gender) %>%
  select(Age, Gender)



# Exercise: Filtering and logic, arranging, and selecting -----------------

#1. Filter so only those with BMI more than 20 and less than 40 and keep only those with diabetes.
#2. Filter to keep those who are working (“Work”) or those who are renting (“HomeOwn”) and those who do not have diabetes. Select the variables age, gender, work status, home ownership, and diabetes status.
#3. Using sorting and selecting, find out who has had the most number of babies and how old they are.

# To see values of categorical data
summary(NHANES)

# 1. BMI between 20 and 40 and who have diabetes
NHANES %>%
  # format: variable >= number
  filter(BMI >= 20 & BMI <= 40 & Diabetes == "yes")

# 2. Working or renting, and not diabetes
NHANES %>%
  filter(Work == "Working" | HomeOwn == "Rent" & Diabetes == "No") %>%
  select(Work, HomeOwn, Diabetes)

# 3. How old is person with most number of children.
NHANES %>%
  arrange(desc(nBabies), desc(Age) %>%
  select(desc(nBabies), desc(Age)

#REMEMBER TO RESTART AND RERUN THE LIBRARIES ONCE YOU DON'T USE FOR A WHILE

# Create a summary of the data, alone or by a group -----------------------
#Summarise() function by itself
#na.rm : remove the non available
NHANES %>%
  summarise(MaxAge = max(Age, na.rm = TRUE),
            MeanBMI = mean(BMI, na.rm = TRUE),
            MedianBMI = median(BMI, na.rm = TRUE))

# Grouped by gender
NHANES %>%
  group_by(Gender) %>%
  summarise(MaxAge = max(Age, na.rm = TRUE),
            MeanBMI = mean(BMI, na.rm = TRUE),
            MedianBMI = median(BMI, na.rm = TRUE))


# Converting from wide to long form ---------------------------------------

#1. The name of a new column that contains the original column names
#2. The name of a new column that contains the values from the original columns
#3. The original columns we either want or do not want “gathered” up.
# Convert to long form by stacking population by each year
# Use minue to exclude a variable (country) from being "gathered"
table4b

table4b %>%
  gather(key = year, value = population, -country)

#CHange the quotes, that is the mistake
table4b %>%
  gather(key = year, value = population, ´1999´, ´2000)

#Combine summarize and gather
# Keep only variables of interest for us
nhanes_char <- NHANES %>%
  select(SurveyYr, Gender, Age, Weight, Height, BMI, BPSysAve)
nhanes_char

#convert from wide to long, excluding year and gender
nhanes_long <- nhanes_char %>%
  gather(Measure, Value, -SurveyYr, -Gender)
nhanes_long

#USe summarise to calculate mean
nhanes_long %>%
  group_by(SurveyYr, Gender, Measure) %>%
  summarise(MeanValues = mean(Value, na.rm = TRUE))








