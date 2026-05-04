SELECT 
    EXTRACT (year FROM public.instrument_rental.rental_date) as year,
    AVG(count_rental_ids)::numeric(1000,2)
FROM
      public.instrument_rental,
    (
    SELECT
         COUNT(public.instrument_rental.id) AS count_rental_ids
    FROM 
         public.instrument_rental 
    WHERE 
         EXTRACT (year FROM public.instrument_rental.rental_date) = '2014'
    GROUP BY 
         EXTRACT (month FROM public.instrument_rental.rental_date)
    ) AS total_rentals
WHERE 
    EXTRACT (year FROM public.instrument_rental.rental_date) = '2014'
GROUP BY
      year
	  
	  
	  
	  
	  ----------------- OR -------------
	  
	  
	  
SELECT 
    EXTRACT (year FROM public.instrument_rental.rental_date) as year,
    (CAST (COUNT(public.instrument_rental.id) AS DECIMAL)/12)::numeric(1000,2) AS average_rental
FROM
    public.instrument_rental,
	public.instrument
WHERE
	public.instrument_rental.instrument_id = public.instrument.id AND
	public.instrument.kind = 'Piano'
GROUP BY
    year
ORDER BY
	year