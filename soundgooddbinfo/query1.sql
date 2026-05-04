-- first part of the query
SELECT 
  EXTRACT (year FROM public.instrument_rental.rental_date) as year,
  EXTRACT (month FROM public.instrument_rental.rental_date) as month,
  COUNT(public.instrument_rental.id) as rental_count
FROM
  public.instrument_rental
GROUP BY
  EXTRACT (year FROM public.instrument_rental.rental_date),
  EXTRACT (month FROM public.instrument_rental.rental_date)
HAVING 
  EXTRACT (year FROM public.instrument_rental.rental_date) = '2014' OR 
  EXTRACT (year FROM public.instrument_rental.rental_date) = '2015' OR 
  EXTRACT (year FROM public.instrument_rental.rental_date) = '2016' OR 
  EXTRACT (year FROM public.instrument_rental.rental_date) = '2017' OR 
  EXTRACT (year FROM public.instrument_rental.rental_date) = '2018' OR 
  EXTRACT (year FROM public.instrument_rental.rental_date) = '2019' OR 
  EXTRACT (year FROM public.instrument_rental.rental_date) = '2020'
  
  ORDER BY year
  ------------------------------------------------------------------------------------
--////--
------------------------------------------------------------------------------------

  
-- second part of the query
SELECT 
	EXTRACT (year FROM public.instrument_rental.rental_date) as year,
  	COUNT(public.instrument_rental.id) as total_rentals
FROM
  public.instrument_rental
GROUP BY
  EXTRACT (year FROM public.instrument_rental.rental_date)
  HAVING 
	EXTRACT (year FROM public.instrument_rental.rental_date) = '2014' OR
 	EXTRACT (year FROM public.instrument_rental.rental_date) = '2015' OR 
  	EXTRACT (year FROM public.instrument_rental.rental_date) = '2016' OR 
  	EXTRACT (year FROM public.instrument_rental.rental_date) = '2017' OR 
  	EXTRACT (year FROM public.instrument_rental.rental_date) = '2018' OR 
  	EXTRACT (year FROM public.instrument_rental.rental_date) = '2019' OR 
  	EXTRACT (year FROM public.instrument_rental.rental_date) = '2020'
	
  ORDER BY year
------------------------------------------------------------------------------------
--////--
------------------------------------------------------------------------------------
  
-- third part of the query


SELECT 
  EXTRACT (year FROM public.instrument_rental.rental_date) as year,
  COUNT(public.instrument_rental.id) as rental_count,
  public.instrument.kind as istrument_kind
FROM
  public.instrument_rental,
  public.instrument
GROUP BY
  EXTRACT (year FROM public.instrument_rental.rental_date),
  public.instrument_rental.instrument_id,
  public.instrument.id,
  public.instrument.kind
HAVING 
  public.instrument.kind = 'Saxophone' AND 
  public.instrument_rental.instrument_id = public.instrument.id
  
  ORDER BY year
 ------------------------------------------------------------------------------------
--////--
------------------------------------------------------------------------------------

 
 
 --//// OR /// -- 
 
 
 SELECT 
  EXTRACT (year FROM public.instrument_rental.rental_date) as year,
  EXTRACT (month FROM public.instrument_rental.rental_date) as month,
  COUNT(public.instrument_rental.id) as rental_count,
  public.instrument.kind as istrument_kind
FROM
  public.instrument_rental,
  public.instrument
GROUP BY
  EXTRACT (year FROM public.instrument_rental.rental_date),
  EXTRACT (month FROM public.instrument_rental.rental_date),
  public.instrument_rental.instrument_id,
  public.instrument.id,
  public.instrument.kind
HAVING 
  public.instrument_rental.instrument_id = public.instrument.id
  
  ORDER BY year, month
------------------------------------------------------------------------------------
--////--
------------------------------------------------------------------------------------


--///// OR //// ---
--// THE SOLUTION //--

SELECT 
	EXTRACT (year FROM public.instrument_rental.rental_date) as year,
  	EXTRACT (month FROM public.instrument_rental.rental_date) as month,
  	COUNT(public.instrument_rental.id) as rental_count,
  	public.instrument.kind as istrument_kind
FROM
  	public.instrument_rental,
  	public.instrument
GROUP BY
	EXTRACT (year FROM public.instrument_rental.rental_date),
  	EXTRACT (month FROM public.instrument_rental.rental_date),
  	public.instrument_rental.instrument_id,
  	public.instrument.id,
  	public.instrument.kind
HAVING 
	EXTRACT (year FROM public.instrument_rental.rental_date) = 2014 AND
	public.instrument.kind = 'Piano' AND
  	public.instrument_rental.instrument_id = public.instrument.id
ORDER BY 
 	rental_count DESC
  -- //// 
------------------------------------------------------------------------------------
--////--
------------------------------------------------------------------------------------

--POSSIBLE SOLUTION FOR query1 // 

SELECT 
  EXTRACT (year FROM public.instrument_rental.rental_date) AS year,
  EXTRACT (month FROM public.instrument_rental.rental_date) AS month,
  COUNT(public.instrument_rental.instrument_id) AS rental_count,
  clarinet_rental
FROM
  public.instrument_rental,
  public.instrument,
  ( SELECT
         COUNT(public.instrument.kind) AS clarinet
    FROM 
        public.instrument,
   		public.instrument_rental
    WHERE 
        public.instrument.kind = 'Clarinet' AND 
   		public.instrument_rental.instrument_id = public.instrument.id 
    GROUP BY 
         public.instrument.kind
    ) AS clarinet_rental
WHERE 
	public.instrument_rental.instrument_id = public.instrument.id 
GROUP BY
  EXTRACT (year FROM public.instrument_rental.rental_date),
  EXTRACT (month FROM public.instrument_rental.rental_date),
  clarinet_rental
  
ORDER BY year, month

------------------------------------------------------------------------------------
--////--
------------------------------------------------------------------------------------

