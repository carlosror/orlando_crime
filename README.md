## URL
[https://carlosgg.shinyapps.io/orlando-pc-map/](https://carlosgg.shinyapps.io/orlando-pc-map/, "Orlando police calls map")

## Motivation

I wanted an Orange County equivalent of [this Hillsborough County website](http://gis.hcso.tampa.fl.us/PublicGIS/CrimeMapping/), i.e., 
I wanted to be able to enter an O.C. address or landmark and get a plot of criminal activity within a given radius of that address/landmark.
Here I had access to the police calls data rather than the actual criminal activity.

## Technologies

[https://leanpub.com/rprogramming](R), [R Studio](https://www.rstudio.com/), [Shiny R server](http://shiny.rstudio.com/articles/), [Leaflet for R](http://rstudio.github.io/leaflet/).

## Features

By default, the app plots the police calls in a 0.5 mile radius around a large intersection downtown:

![Alt](docs_images/Radius_1.JPG?raw=true "Default")

You can enter a landmark in the search box, e.g., Lake Eola Park, and click Search:

![Alt](docs_images/Radius_2.JPG?raw=true "Lake Eola")

You can also click on the map (outside the circle) and click Search and the app will return the police calls centered around the location.
Here you can see I clicked on the Lynx Central Station:

![Alt](docs_images/Radius_3.JPG?raw=true "Lynx Central Station")

## References

1. Chow, Jo-fai. (2014, March 11). ***Introducing 'CrimeMap'***. Retrieved from http://www.jofaichow.co.uk/2014_03_11_LondonR/#1

2. Matloff, Norman. ***The Art of R Programming***. San Francisco: No Starch Press, 2011. PDF.

3. Adler, Joseph. ***R in a Nutshell, Second Edition***. Sebastopol: O'Reilly Media, 2012. PDF.

4. D. Kahle and H. Wickham. ***ggmap: Spatial Visualization with ggplot2***. The R Journal, 5(1), 144-161. URL http://journal.r-project.org/archive/2013-1/kahle-wickham.pdf

5. Veness, Chris. ***Calculate distance, bearing and more between Latitude/Longitude points***. Retrieved from http://www.movable-type.co.uk/scripts/latlong.html

6. Roger Peng. ***Computing for Data Analysis***, Spring 2014. Coursera.

7. Shiny Articles. Retrieved from http://shiny.rstudio.com/articles/

8. Hillsborough County Sheriff's Ofiice. ***Hillsborough County Crime Map***. Retrieved from http://gis.hcso.tampa.fl.us/crimemapping/

9. Samarasa and Jarpal. ***Fixing the order of facets in ggplot***. Retrieved from http://stackoverflow.com/questions/14262497/fixing-the-order-of-facets-in-ggplot

10. Stein, Jonas and Muspratt, Sandy. ***What does size really mean in geom_point?*** Retrieved from http://stackoverflow.com/questions/13548321/what-does-size-really-mean-in-geom-point