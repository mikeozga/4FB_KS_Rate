# 4FB_KS_Rate
Looking at the relationship between the pitcher's release height and the swinging strike rate. 

In order to predict the swinging strike rate of a given pitch, we will consider the release height, height as the pitch crosses the plate, and vertical movement of the pitch.
This project only includes 4 seam fastballs thrown in the upper portion of the zone in 2020. A minimum of 50 pitches thrown in 2020 was used as a minimum for this project. 

For the purpose of this project, we will define pitches in the upper portion of the strike zone as pitches thrown in 9 "attack zones" defined by Baseball Savant. The zones included are:
High strikes: zones 1, 2, and 3.
Shadow zone pitches above the zone: zones 11, 12 and 13
Chase pitches above the zone: zones 21, 22 and 23.

The data was limited to 4seam fastballs as 4seam fastballs produce the highest chase rate at the top of the strike zone, due to the perceived "rise" (vertical movement) of the pitch.

The aim of the project is to determine if shorter pitchers (or pitchers with a lower release point) have a higher probability of producing a swing and miss on a "high" pitch compared to 
a pitch with the same height crossing the plate released from a higher point. 

The variables included in this project are:
swinging_strike (0,1): where 1 indicates a swing and miss, and 0 indicates any other result (foul, called strike, ball in play). 
release_pos_z: This is the release height above the ground, measured in feet. 
pfx_z : this is the vertical movement of the pitch, in feet. 
plate_z : the height of the pitch as it crosses the plate, in feet.

Based on the subset of the data selected, we considered 30,885 pitches from the 2020 season. 

The R code provided details the process taken to determine the relationship between the selected variables. 

Also provided is an attempt at creating a neural network to predict the swinging strike rate of pitches in 9 attack zones based on the 3 above variables. 
