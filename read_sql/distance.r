# http://www.movable-type.co.uk/scripts/latlong.html

R = 6371000
lat1 = 28.5332492
long1 = -81.3056629
lat2 = 30.0500
long2 = 31.2333

theta1 = lat1 * pi / 180.0
theta2 = lat2 * pi / 180.0
delta_theta = (lat2 - lat1) * pi / 180.0
delta_lambda = (long2 - long1) * pi / 180.0

############################
# Haversine distance formula
############################

a = sin(delta_theta/2) * sin(delta_theta/2) + cos(theta1) * cos(theta2) * sin(delta_lambda/2.0) * sin(delta_lambda/2.0)
c1 = 2.0 * atan2(sqrt(a), sqrt(1-a))

d_Haver = R * c1

##########################
# Spherical law of cosines
##########################

d_spher = acos(sin(theta1) * sin(theta2) + cos(theta1) * cos(theta2) * cos(delta_lambda)) * R

###############################
# Equirectangular approximation
###############################

x = delta_lambda * cos((theta1 + theta2)/2.0)
y = delta_theta

d_equi = R * sqrt(x*x + y*y)