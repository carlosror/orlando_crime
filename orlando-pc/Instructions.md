---
output: html_document
---

#### General
---

The data is for **Orlando Police Department dispatch calls** rather than actual crimes. The data was obtained from the [Code for Orlando data sources website](http://www.codefororlando.com/data-sources/)

**To safeguard citizens' privacy, each of the individual locations was randomly dithered so that none of the results shown is an exact location but rather an approximate one.**

Either type a location's address or click on the map to obtain results around that location.

Clicking on an individual marker will show the crime type and date and time at .

![alt text](crime_marker.png "Crime marker")

---

#### Bar plots
---

The bar plots (and the density maps) are faceted according to the input selection. In order to keep the tables readable, the top six crime types are used.

The following shows a result of crimes on Mondays, Wednesdays, and Fridays that took place during the early morning and evening time periods, faceted by day of the week

![alt text](faceted_inputs_1.png "Faceted inputs")  ![alt text](faceted_result_1.png "Faceted results")    
<br>
The same crime set, now faceted by time of day

![alt text](faceted_inputs_2.png "Faceted inputs")  ![alt text](faceted_result_2.png "Faceted results")

---
#### Density maps
---

The density maps take a few seconds to display. They are faceted similar to the bar plots

![alt text](faceted_result_3.png "Faceted map density")

---

#### Summary
---

The summary just tabulates the crime types by time period.
<br><br>