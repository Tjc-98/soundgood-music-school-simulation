----------- MATERIALIZED VIEW --------

CREATE MATERIALIZED VIEW public.piano_rentals
AS
SELECT 
  EXTRACT (year FROM public.instrument_rental.rental_date) as year,
  EXTRACT (month FROM public.instrument_rental.rental_date) as month,
  COUNT(public.instrument_rental.id) as piano_rental_kind,
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
  public.instrument.kind = 'Piano' AND 
  public.instrument_rental.instrument_id = public.instrument.id
  
  ORDER BY year
WITH DATA;

ALTER TABLE public.piano_rentals
    OWNER TO postgres;
	
	
	
	
	
CREATE MATERIALIZED VIEW public.trumpet_rentals
AS
SELECT 
  EXTRACT (year FROM public.instrument_rental.rental_date) as year,
  EXTRACT (month FROM public.instrument_rental.rental_date) as month,
  COUNT(public.instrument_rental.id) as trumpet_rental_kind,
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
  public.instrument.kind = 'Trumpet' AND 
  public.instrument_rental.instrument_id = public.instrument.id
  
  ORDER BY year
WITH DATA;

ALTER TABLE public.trumpet_rentals
    OWNER TO postgres;
	
	
	
	
CREATE MATERIALIZED VIEW public.trumpet_rentals
AS
SELECT 
  EXTRACT (year FROM public.instrument_rental.rental_date) as year,
  EXTRACT (month FROM public.instrument_rental.rental_date) as month,
  COUNT(public.instrument_rental.id) as trumpet_rental_kind,
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
  public.instrument.kind = 'Trumpet' AND 
  public.instrument_rental.instrument_id = public.instrument.id
  
  ORDER BY year
WITH DATA;

ALTER TABLE public.trumpet_rentals
    OWNER TO postgres;
	


	
	--------------- Query1 in MATERIALIZED VIEW-----------------
SELECT 
    public.total_rentals.month as month,
    public.total_rentals.total_rentals,
    	CASE 
			WHEN public.saxophone_rentals.saxophone_rental_kind is NULL THEN '0'
    		ELSE
    			public.saxophone_rentals.saxophone_rental_kind
    	END AS saxophone_rental_count,
		CASE 
			WHEN public.piano_rentals.piano_rental_kind is NULL THEN '0'
    		ELSE
    			public.piano_rentals.piano_rental_kind
    	END AS piano_rental_count,
		CASE 
			WHEN public.violin_rentals.violin_rental_kind is NULL THEN '0'
    		ELSE
    			public.violin_rentals.violin_rental_kind
    	END AS violin_rental_count,
		CASE 
			WHEN public.drums_rentals.drums_rental_kind is NULL THEN '0'
    		ELSE
    			public.drums_rentals.drums_rental_kind
    	END AS drums_rental_count,
		CASE 
			WHEN public.clarinet_rentals.clarinet_rental_kind is NULL THEN '0'
    		ELSE
    			public.clarinet_rentals.clarinet_rental_kind
    	END AS clarinet_rental_count,
		CASE 
			WHEN public.trumpet_rentals.trumpet_rental_kind is NULL THEN '0'
    		ELSE
    			public.trumpet_rentals.trumpet_rental_kind
    	END AS trumpet_rental_count
FROM
    public.total_rentals LEFT JOIN public.saxophone_rentals ON (public.total_rentals.month = public.saxophone_rentals.month AND public.total_rentals.year = public.saxophone_rentals.year)
						 LEFT JOIN public.piano_rentals ON (public.total_rentals.month = public.piano_rentals.month AND public.total_rentals.year = public.piano_rentals.year)
						 LEFT JOIN public.violin_rentals ON (public.total_rentals.month = public.violin_rentals.month AND public.total_rentals.year = public.violin_rentals.year)
						 LEFT JOIN public.drums_rentals ON (public.total_rentals.month = public.drums_rentals.month AND public.total_rentals.year = public.drums_rentals.year)
						 LEFT JOIN public.clarinet_rentals ON (public.total_rentals.month = public.clarinet_rentals.month AND public.total_rentals.year = public.clarinet_rentals.year)
						 LEFT JOIN public.trumpet_rentals ON (public.total_rentals.month = public.trumpet_rentals.month AND public.total_rentals.year = public.trumpet_rentals.year)
WHERE 
    public.total_rentals.year = 2020
ORDER BY
    month
	
	
	
	
	
-------------------- VIEW ------------------------
CREATE OR REPLACE VIEW public.piano_rentals
 AS
SELECT 
  EXTRACT (year FROM public.instrument_rental.rental_date) as year,
  EXTRACT (month FROM public.instrument_rental.rental_date) as month,
  COUNT(public.instrument_rental.id) as piano_rental_kind,
  public.instrument.kind as istrument_kind
FROM
  public.instrument_rental,
  public.instrument
WHERE public.instrument_rental.instrument_id = public.instrument.id
GROUP BY
  EXTRACT (year FROM public.instrument_rental.rental_date),
  EXTRACT (month FROM public.instrument_rental.rental_date),
  public.instrument.kind
HAVING 
  public.instrument.kind = 'Piano'
ORDER BY
	year, month;

ALTER TABLE public.piano_rentals
    OWNER TO postgres;
	
	
	
------------------------------////////////////-------------------

CREATE OR REPLACE VIEW public.trumpet_rentals
 AS
SELECT 
  EXTRACT (year FROM public.instrument_rental.rental_date) as year,
  EXTRACT (month FROM public.instrument_rental.rental_date) as month,
  COUNT(public.instrument_rental.id) as trumpet_rental_kind,
  public.instrument.kind as istrument_kind
FROM
  public.instrument_rental,
  public.instrument
WHERE public.instrument_rental.instrument_id = public.instrument.id
GROUP BY
  EXTRACT (year FROM public.instrument_rental.rental_date),
  EXTRACT (month FROM public.instrument_rental.rental_date),
  public.instrument.kind
HAVING 
  public.instrument.kind = 'Trumpet'
ORDER BY
	year, month;

ALTER TABLE public.trumpet_rentals
    OWNER TO postgres;
	
---------------///////////////--------------------

CREATE OR REPLACE VIEW public.saxophone_rentals
 AS
SELECT 
  EXTRACT (year FROM public.instrument_rental.rental_date) as year,
  EXTRACT (month FROM public.instrument_rental.rental_date) as month,
  COUNT(public.instrument_rental.id) as saxophone_rental_kind,
  public.instrument.kind as istrument_kind
FROM
  public.instrument_rental,
  public.instrument
WHERE public.instrument_rental.instrument_id = public.instrument.id
GROUP BY
  EXTRACT (year FROM public.instrument_rental.rental_date),
  EXTRACT (month FROM public.instrument_rental.rental_date),
  public.instrument.kind
HAVING 
  public.instrument.kind = 'Saxophone'
ORDER BY
	year, month;

ALTER TABLE public.saxophone_rentals
    OWNER TO postgres;
	
--------------///////////////////------------------

CREATE OR REPLACE VIEW public.drums_rentals
 AS
SELECT 
  EXTRACT (year FROM public.instrument_rental.rental_date) as year,
  EXTRACT (month FROM public.instrument_rental.rental_date) as month,
  COUNT(public.instrument_rental.id) as drums_rental_kind,
  public.instrument.kind as istrument_kind
FROM
  public.instrument_rental,
  public.instrument
WHERE public.instrument_rental.instrument_id = public.instrument.id
GROUP BY
  EXTRACT (year FROM public.instrument_rental.rental_date),
  EXTRACT (month FROM public.instrument_rental.rental_date),
  public.instrument.kind
HAVING 
  public.instrument.kind = 'Drums'
ORDER BY
	year, month;

ALTER TABLE public.drums_rentals
    OWNER TO postgres;
	
	---------/////////////////--------------
	
CREATE OR REPLACE VIEW public.clarinet_rentals
 AS
SELECT 
  EXTRACT (year FROM public.instrument_rental.rental_date) as year,
  EXTRACT (month FROM public.instrument_rental.rental_date) as month,
  COUNT(public.instrument_rental.id) as clarinet_rental_kind,
  public.instrument.kind as istrument_kind
FROM
  public.instrument_rental,
  public.instrument
WHERE public.instrument_rental.instrument_id = public.instrument.id
GROUP BY
  EXTRACT (year FROM public.instrument_rental.rental_date),
  EXTRACT (month FROM public.instrument_rental.rental_date),
  public.instrument.kind
HAVING 
  public.instrument.kind = 'Clarinet'
ORDER BY
	year, month;

ALTER TABLE public.clarinet_rentals
    OWNER TO postgres;
	
----------------///////////////---------------

CREATE OR REPLACE VIEW public.total_rentals
 AS
SELECT 
	EXTRACT (year FROM public.instrument_rental.rental_date) as year,
  	EXTRACT (month FROM public.instrument_rental.rental_date) as month,
  	COUNT(public.instrument_rental.id) as total_rentals
FROM
  	public.instrument_rental
GROUP BY
	EXTRACT (year FROM public.instrument_rental.rental_date),
 	EXTRACT (month FROM public.instrument_rental.rental_date)
ORDER BY 
	year;

ALTER TABLE public.total_rentals
    OWNER TO postgres;
	
-------------////////////-------------

CREATE OR REPLACE VIEW public.violin_rentals
 AS
SELECT 
  EXTRACT (year FROM public.instrument_rental.rental_date) as year,
  EXTRACT (month FROM public.instrument_rental.rental_date) as month,
  COUNT(public.instrument_rental.id) as violin_rental_kind,
  public.instrument.kind as istrument_kind
FROM
  public.instrument_rental,
  public.instrument
WHERE public.instrument_rental.instrument_id = public.instrument.id
GROUP BY
  EXTRACT (year FROM public.instrument_rental.rental_date),
  EXTRACT (month FROM public.instrument_rental.rental_date),
  public.instrument.kind
HAVING 
  public.instrument.kind = 'Violin'
ORDER BY
	year, month;

ALTER TABLE public.violin_rentals
    OWNER TO postgres;
	
	-------------------