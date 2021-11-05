
/*

Project: 

		Develop a Database to Analyze and Visulaize Hotel Booking Data


	Task: Build a Data Story or Dashboard using Power BI to present to Stakeholder for business decisions

		1. Is our hotel revenue growing by year? ( We have two hotel types, we would like to analyze revenue by hotel types)
		2. Should we increase our parking lot size? ( To understand if there's a trend with guests with personal cars)
		3. What trends can we see in the data ? ( Focusing on Average Daily Rates and Guests to explore seasonability)




	Pipelines:

	Step 1 :		 Build a Database, import data
	Step 2 :		 Develop the SQL Query
	Step 3 :		 Connect Database to Power BI
	Step 4:			 Visualize
	Step 5:			 Summarize our findings
	Step 6:			 Publish Dashboard to Service


	*/

	-- Data Exploration
	-- Let's see all tables at once

	Select * from  dbo.Hotel2018
	Select * from  dbo.Hotel2019
	Select * from  dbo.Hotel2020
		

   -- Let's unify these dataset by using UNION

   Select * from  dbo.Hotel2018
    union
	Select * from  dbo.Hotel2019
	union
	Select * from  dbo.Hotel2020


  -- Exploratory Data Analysis
  -- We will create a TEMP TABLE using the select statements from above

  WITH hotels as 
  (
	Select * from  dbo.Hotel2018
    union
	Select * from  dbo.Hotel2019
	union
	Select * from  dbo.Hotel2020
	)
 Select * from hotels


 -- Question: Is the hotel revenue growing by year?

 -- We will create a DERIVED COLUMN display that 
 -- We will add the two columns Stays_in_Week_nights and Stays_in_Weekend_nights


  WITH hotels as 
  (
	Select * from  dbo.Hotel2018
    union
	Select * from  dbo.Hotel2019
	union
	Select * from  dbo.Hotel2020
	)

 Select stays_in_week_nights  + stays_in_weekend_nights from hotels

 -- Let's multiply this by the Average Daily Rate for the hotel and ALIAS it as REVENUE


 
  WITH hotels as 
  (
	Select * from  dbo.Hotel2018
    union
	Select * from  dbo.Hotel2019
	union
	Select * from  dbo.Hotel2020
	)

 Select (stays_in_week_nights  + stays_in_weekend_nights) *adr AS Revenue from hotels

 -- Let's see if revenue is increasing by year by using the Arrival Date Year


 

  WITH hotels as 
  (
	Select * from  dbo.Hotel2018
    union
	Select * from  dbo.Hotel2019
	union
	Select * from  dbo.Hotel2020
	)

 Select 
 arrival_date_year,
 
 (stays_in_week_nights  + stays_in_weekend_nights) *adr AS Revenue from hotels


 -- Let's GROUP BY and SUM by YEAR


   WITH hotels as 
  (
	Select * from  dbo.Hotel2018
    union
	Select * from  dbo.Hotel2019
	union
	Select * from  dbo.Hotel2020
	)

 Select 
 arrival_date_year,
 
 SUM((stays_in_week_nights  + stays_in_weekend_nights) *adr) AS Revenue from hotels
 GROUP BY arrival_date_year


 -- We can see that our revenue is indeed growing by year
 -- Let's break this down by Hotel Type as per Business question


   WITH hotels as 
  (
	Select * from  dbo.Hotel2018
    union
	Select * from  dbo.Hotel2019
	union
	Select * from  dbo.Hotel2020
	)

 Select 
 arrival_date_year,
 hotel,
 
 SUM((stays_in_week_nights  + stays_in_weekend_nights) *adr) AS Revenue from hotels
 GROUP BY arrival_date_year,hotel


 --LETS ROUND OUR DECIMALS FOR EASY READABILITY



   WITH hotels as 
  (
	Select * from  dbo.Hotel2018
    union
	Select * from  dbo.Hotel2019
	union
	Select * from  dbo.Hotel2020
	)

 Select 
 arrival_date_year,
 hotel,
 
 ROUND(SUM((stays_in_week_nights  + stays_in_weekend_nights) *adr),2) AS Revenue from hotels
 GROUP BY arrival_date_year,hotel

 
 -- Let's JOIN this TEMP TABLE (hotels)  with our tables


   WITH hotels as 
  (
	Select * from  dbo.Hotel2018
    union
	Select * from  dbo.Hotel2019
	union
	Select * from  dbo.Hotel2020
	)
 Select * from hotels
 JOIN dbo.market_segment
 on hotels.market_segment = market_segment.market_segment -- We joined the Hotel DB/market_segment column = market_segment table /market_segment column

 -- If we use LEFT JOIN, it will bring all the data irregardless if there's a match or not. 
 -- The LEFT Table is preserved

 
   WITH hotels as 
  (
	Select * from  dbo.Hotel2018
    union
	Select * from  dbo.Hotel2019
	union
	Select * from  dbo.Hotel2020
	)
 Select * from hotels
 LEFT JOIN dbo.market_segment
 on hotels.market_segment = market_segment.market_segment -- We joined the Hotel DB/market_segment column = market_segment table /market_segment column

 -- LEFT JOIN on Meal_cost table as well

 
   WITH hotels as 
  (
	Select * from  dbo.Hotel2018
    union
	Select * from  dbo.Hotel2019
	union
	Select * from  dbo.Hotel2020
	)
 Select * from hotels
LEFT  JOIN 
dbo.market_segment
 on hotels.market_segment = market_segment.market_segment  
 LEFT JOIN 
 dbo.meal_cost
 on meal_cost.meal = hotels.meal -- Table/Column


 -- Let's take this query to Power BI