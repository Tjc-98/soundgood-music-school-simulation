------- QUERY2 #1#------------
CREATE MATERIALIZED VIEW public.average_rentals
AS
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
WITH DATA;

ALTER TABLE public.average_rentals
    OWNER TO postgres;
	
-------------QUERY2 #2#--------------	

SELECT 
    public.average_rentals.year as year,
    public.average_rentals.average_rental,
	CASE 
		WHEN public.clarinet_average_rentals.clarinet_average_rental is NULL THEN '0'
	ELSE
		public.clarinet_average_rentals.clarinet_average_rental
	END AS clarinet_average_rentals_count,
	CASE 
		WHEN public.trumpet_average_rentals.trumpet_average_rental is NULL THEN '0'
	ELSE
		public.trumpet_average_rentals.trumpet_average_rental
	END AS trumpet_average_rentals_count,
	CASE 
		WHEN public.saxophone_average_rentals.saxophone_average_rental is NULL THEN '0'
    ELSE
    	public.saxophone_average_rentals.saxophone_average_rental
    END AS saxophone_average_rental_count,
	CASE 
		WHEN public.piano_average_rentals.piano_average_rental is NULL THEN '0'
    ELSE
    	public.piano_average_rentals.piano_average_rental
    END AS piano_average_rental_count,
	CASE 
		WHEN public.violin_average_rentals.violin_average_rental is NULL THEN '0'
    ELSE
    	public.violin_average_rentals.violin_average_rental
    END AS violin_average_rental_count,
	CASE 
		WHEN public.drums_average_rentals.drums_average_rental is NULL THEN '0'
    ELSE
    	public.drums_average_rentals.drums_average_rental
    END AS drums_average_rental_count
    
FROM
    public.average_rentals 	LEFT JOIN public.clarinet_average_rentals ON ( public.average_rentals.year = public.clarinet_average_rentals.year)
							LEFT JOIN public.trumpet_average_rentals ON ( public.average_rentals.year = public.trumpet_average_rentals.year)
							LEFT JOIN public.saxophone_average_rentals ON ( public.average_rentals.year = public.saxophone_average_rentals.year)
							LEFT JOIN public.piano_average_rentals ON ( public.average_rentals.year = public.piano_average_rentals.year)
							LEFT JOIN public.violin_average_rentals ON ( public.average_rentals.year = public.violin_average_rentals.year)
							LEFT JOIN public.drums_average_rentals ON ( public.average_rentals.year = public.drums_average_rentals.year)
ORDER BY
    year
	
	
	
-----------------// VIEW // ----------------------------------

CREATE OR REPLACE VIEW public.piano_average_rentals
 AS
SELECT 
    EXTRACT (year FROM public.instrument_rental.rental_date) as year,
    (CAST (COUNT(public.instrument_rental.id) AS DECIMAL)/12)::numeric(1000,2) AS piano_average_rental
FROM
    public.instrument_rental,
	public.instrument
WHERE
	public.instrument_rental.instrument_id = public.instrument.id AND
	public.instrument.kind = 'Piano'
GROUP BY
    year
ORDER BY
	year;

ALTER TABLE public.piano_average_rentals
    OWNER TO postgres;
	
-------------------- ///////// -------------
CREATE OR REPLACE VIEW public.saxophone_average_rentals
 AS
SELECT 
    EXTRACT (year FROM public.instrument_rental.rental_date) as year,
    (CAST (COUNT(public.instrument_rental.id) AS DECIMAL)/12)::numeric(1000,2) AS saxophone_average_rental
FROM
    public.instrument_rental,
	public.instrument
WHERE
	public.instrument_rental.instrument_id = public.instrument.id AND
	public.instrument.kind = 'Saxophone'
GROUP BY
    year
ORDER BY
	year;

ALTER TABLE public.saxophone_average_rentals
    OWNER TO postgres;
	
--------------/////////////////-------------------

CREATE OR REPLACE VIEW public.clarinet_average_rentals
 AS
SELECT 
    EXTRACT (year FROM public.instrument_rental.rental_date) as year,
    (CAST (COUNT(public.instrument_rental.id) AS DECIMAL)/12)::numeric(1000,2) AS clarinet_average_rental
FROM
    public.instrument_rental,
	public.instrument
WHERE
	public.instrument_rental.instrument_id = public.instrument.id AND
	public.instrument.kind = 'Clarinet'
GROUP BY
    year
ORDER BY
	year;

ALTER TABLE public.clarinet_average_rentals
    OWNER TO postgres;
	
----------------------////////////////-------------------

CREATE OR REPLACE VIEW public.drums_average_rentals
 AS
SELECT 
    EXTRACT (year FROM public.instrument_rental.rental_date) as year,
    (CAST (COUNT(public.instrument_rental.id) AS DECIMAL)/12)::numeric(1000,2) AS drums_average_rental
FROM
    public.instrument_rental,
	public.instrument
WHERE
	public.instrument_rental.instrument_id = public.instrument.id AND
	public.instrument.kind = 'Drums'
GROUP BY
    year
ORDER BY
	year;

ALTER TABLE public.drums_average_rentals
    OWNER TO postgres;
	
---------------//////////////////-------------------

CREATE OR REPLACE VIEW public.trumpet_average_rentals
 AS
SELECT 
    EXTRACT (year FROM public.instrument_rental.rental_date) as year,
    (CAST (COUNT(public.instrument_rental.id) AS DECIMAL)/12)::numeric(1000,2) AS trumpet_average_rental
FROM
    public.instrument_rental,
	public.instrument
WHERE
	public.instrument_rental.instrument_id = public.instrument.id AND
	public.instrument.kind = 'Trumpet'
GROUP BY
    year
ORDER BY
	year;

ALTER TABLE public.trumpet_average_rentals
    OWNER TO postgres;
	
-------------//////////////////--------------------

CREATE OR REPLACE VIEW public.violin_average_rentals
 AS
SELECT 
    EXTRACT (year FROM public.instrument_rental.rental_date) as year,
    (CAST (COUNT(public.instrument_rental.id) AS DECIMAL)/12)::numeric(1000,2) AS violin_average_rental
FROM
    public.instrument_rental,
	public.instrument
WHERE
	public.instrument_rental.instrument_id = public.instrument.id AND
	public.instrument.kind = 'Violin'
GROUP BY
    year
ORDER BY
	year;

ALTER TABLE public.violin_average_rentals
    OWNER TO postgres;
	
--------------///////////////////////---------------------

CREATE OR REPLACE VIEW public.average_rentals
 AS
SELECT 
    EXTRACT (year FROM public.instrument_rental.rental_date) as year,
    (CAST (COUNT(public.instrument_rental.id) AS DECIMAL)/12)::numeric(1000,2) AS average_rental
FROM
    public.instrument_rental,
	public.instrument
WHERE
	public.instrument_rental.instrument_id = public.instrument.id
GROUP BY
    year
ORDER BY
	year;

ALTER TABLE public.average_rentals
    OWNER TO postgres;