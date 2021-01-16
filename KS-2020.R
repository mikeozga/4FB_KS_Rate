###### Project OAS
# This project will attempt to relate the release height of a pitch, vertical
#break, and pitch height when crossing the plate.. Only 4 seam fastballs are
# included in this analysis

# this data was scraped from a custom baseball savant search of all pitches in
#the upper region of the strike zone, with a minimum of a total of 50 pitches 
# thrown throughout the 2020 season

# load packages
library(tidyverse)
library(ggrepel)
library(dplyr)
library(ggplot2)

# set seed to ensure replicatable results
set.seed(93)

# load the data
oas <- read_csv("OAS_Project.csv")



# rid the data of irrelevant columns
oas_data <- oas %>%
  select( release_speed, release_pos_x, release_pos_y,
          release_pos_z, player_name, batter, pitcher, events, description, zone,
          stand, p_throws, type, bb_type, balls, strikes, pfx_x, pfx_z, plate_x, 
          plate_z, effective_speed, game_pk)

# create a new variable for determining the result of the pitch:
# 1 = swinging strike, 0 = not a swinging strike
oas_data <- oas_data %>%
  mutate(swinging_strike = ifelse(description == "swinging_strike",1,0))


# Further subset the data into the variables of interest
zdata <- usable_data %>%
  select(swinging_strike, plate_z, pfx_z, release_pos_z)

## correlation plots, load corrplot package
install.packages("corrplot")
library(corrplot)

# create plots
corr1 <- cor(zdata[,1:4])
corrplot(corr1,method="number")
pairs(zdata, col=zdata$swinging_strike)

# create linear model (will not be good due to binary nature of the response)
lm1 = lm(swinging_strike ~ release_pos_z + pfx_z + plate_z, data=usable_data)
summary(lm1)

# create logistic regression mode, with the response belonging to the binomial
# family
glm1 = glm(swinging_strike ~ release_pos_z + pfx_z + plate_z, data=zdata,
           family = binomial)
summary(glm1)




usable_data <- oas_data%>%
  select(release_speed, release_pos_x,release_pos_y, release_pos_z, pfx_x,pfx_z,
         plate_x,plate_z,swinging_strike)


# subset the data into training and testing sets
ssize <- 0.60 * nrow(usable_data)
index <- sample(seq_len(nrow(usable_data)),size=ssize)
datatrain <- usable_data[index, ]
datatest <- usable_data[-index, ]


# scale data for neural network (normalize)
library(neuralnet)
max <- apply(usable_data,2,max)
min = apply(usable_data,2,min)
scaled <- as.data.frame(scale(usable_data,center=min,scale=max-min))


# creating training and test sets
trainNN <- scaled[index, ]
testNN <- scaled[-index, ]
set.seed(93)
NN <- neuralnet(swinging_strike ~ release_pos_z + pfx_z + plate_z, hidden = 3, linear.output = FALSE,data=usable_data, threshold = 0.1)
plot(NN)
summary(NN)
NN

predict_testNN <- compute(NN, testNN[,c(1:3)])
predict_testNN <- (predict_testNN$net.result * (max(usable_data$swinging_strike) - min(usable_data$swinging_strike))) + min(usable_data$swinging_strike)

plot(datatest$swinging_strike, predict_testNN, col='blue', pch=16, ylab = "predicted rating NN", xlab = "real rating")

# find the rmse 
RMSE <- (sum((datatest$swinging_strike - predict_testNN)^2) / nrow(datatest))^.5
RMSE

# prediction using test data
# 0.15 gives us a high enoug chance above the average swinging strike rate,
# so I feel good enough saying a .15% chace of a KS will be the threshold

Predict = compute(NN,datatest)
Predict$net.result
prob <- Predict$net.result
pred <- ifelse(prob>0.15,1,0)
pred
count(pred==1)

# predict one specific pitch
z = c(6.07)
pz  = c(1.19)
cz = c(3.12)

data2 = data.frame(z,pz,cz)
predict2 = compute(NN,data2)
predict2$net.result
prob2 = predict2$net.result
pred2 = ifelse(prob2>0.1,1,0)
pred2





