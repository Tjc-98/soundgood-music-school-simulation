	--------------- Query1 in VIEW-----------------
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
	
	
	
	
	
	
	
	
	
	
	
	
-----------////////// Query 2 ///////////-----------------

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
	
	
	
	------------/////////// Executed query 2 ///////------------------
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
	
	
	
	
	
	
-----------------/////////////////   Query 3 /////////---------------------


----------------///////VIEWS/////////////-------------------

CREATE OR REPLACE VIEW public.given_lessons
 AS
SELECT 
  EXTRACT (year FROM public.lesson_schedule.start_date) as year,
  EXTRACT (month FROM public.lesson_schedule.start_date) as month,
  COUNT(public.lesson_schedule.id) as given_lessons
FROM
  public.lesson_schedule
GROUP BY
  EXTRACT (year FROM public.lesson_schedule.start_date),
  EXTRACT (month FROM public.lesson_schedule.start_date)
  ORDER BY year, month;

ALTER TABLE public.given_lessons
    OWNER TO postgres;
	
	
--------------////////////////////---------------------

CREATE OR REPLACE VIEW public.group_total_given_lessons
 AS
SELECT 
	EXTRACT (year FROM public.lesson_schedule.start_date) as year,
  	EXTRACT (month FROM public.lesson_schedule.start_date) as month,
  	COUNT(public.lesson_schedule.id) as given_lessons,
  	public.lesson.lesson_type as lesson_type
FROM
  	public.lesson,
	public.lesson_schedule
WHERE 
	public.lesson_schedule.lesson_id = public.lesson.id AND
	public.lesson.lesson_type = 'group'
GROUP BY
	EXTRACT (year FROM public.lesson_schedule.start_date),
  	EXTRACT (month FROM public.lesson_schedule.start_date),
	lesson_type

ORDER BY 
	year, month;

ALTER TABLE public.group_total_given_lessons
    OWNER TO postgres;
	
--------------------///////////////////-----------------------------

CREATE OR REPLACE VIEW public.individual_total_given_lessons
 AS
SELECT 
	EXTRACT (year FROM public.lesson_schedule.start_date) as year,
  	EXTRACT (month FROM public.lesson_schedule.start_date) as month,
  	COUNT(public.lesson_schedule.id) as given_lessons,
  	public.lesson.lesson_type as lesson_type
FROM
  	public.lesson,
	public.lesson_schedule
WHERE 
  	public.lesson_schedule.lesson_id = public.lesson.id AND
	public.lesson.lesson_type = 'individual'
GROUP BY
	EXTRACT (year FROM public.lesson_schedule.start_date),
  	EXTRACT (month FROM public.lesson_schedule.start_date),
	lesson_type

ORDER BY 
	year, month;

ALTER TABLE public.individual_total_given_lessons
    OWNER TO postgres;
	
-------------////////////////---------------------------------

CREATE OR REPLACE VIEW public.total_given_ensembles
 AS
SELECT 
	EXTRACT (year FROM public.ensemble_schedule.start_date) as ensemble_year,
  	EXTRACT (month FROM public.ensemble_schedule.start_date) as ensemble_month,
	COUNT(public.ensemble_schedule.id) as given_ensembles,
	'ensembles' as ensemble_type
FROM
	public.ensemble,
	public.ensemble_schedule
WHERE 
	public.ensemble_schedule.ensemble_id = public.ensemble.id
GROUP BY
	EXTRACT (year FROM public.ensemble_schedule.start_date),
  	EXTRACT (month FROM public.ensemble_schedule.start_date),
	ensemble_type

ORDER BY 
 	ensemble_year, ensemble_month;

ALTER TABLE public.total_given_ensembles
    OWNER TO postgres;
	
--------------////////////////////-----------------

-----------///////////// Executed query 3 /////////////---------------
SELECT 
    public.given_lessons.month as month,
    (public.given_lessons.given_lessons + public.total_given_ensembles.given_ensembles) AS total_lessons,
	CASE 
		WHEN public.individual_total_given_lessons.given_lessons is NULL THEN '0'
	ELSE
		public.individual_total_given_lessons.given_lessons
	END AS individual_total_given_lessons_count,
	CASE 
		WHEN public.group_total_given_lessons.given_lessons is NULL THEN '0'
	ELSE
		public.group_total_given_lessons.given_lessons
	END AS group_total_given_lessons_count,
	CASE 
		WHEN public.total_given_ensembles.given_ensembles is NULL THEN '0'
	ELSE
		public.total_given_ensembles.given_ensembles
	END AS total_given_ensembles_count
FROM
    public.given_lessons LEFT JOIN public.individual_total_given_lessons ON (public.given_lessons.month = public.individual_total_given_lessons.month AND public.given_lessons.year = public.individual_total_given_lessons.year)
						 LEFT JOIN public.group_total_given_lessons ON ( public.given_lessons.month = public.group_total_given_lessons.month AND public.given_lessons.year = public.group_total_given_lessons.year)
						 LEFT JOIN public.total_given_ensembles ON ( public.given_lessons.month = public.total_given_ensembles.ensemble_month AND public.given_lessons.year = public.total_given_ensembles.ensemble_year)
WHERE 
	public.given_lessons.year = 2014
GROUP BY
	public.given_lessons.month,
	public.individual_total_given_lessons.given_lessons,
	public.group_total_given_lessons.given_lessons,
	public.given_lessons.given_lessons,
	public.total_given_ensembles.given_ensembles
	
ORDER BY
    month
	
	--------------////////////////////-----------------
	
	
	
------------Query4 -------------------

--------------- VIEW -----------------------

CREATE OR REPLACE VIEW public.average_ind_lessons
 AS
SELECT 
    EXTRACT (year FROM public.lesson_schedule.start_date) as year,
     (CAST (COUNT(public.lesson_schedule.id) AS DECIMAL)/12)::numeric(1000) AS average_ind_lessons
FROM
      public.lesson_schedule,
	  public.lesson
WHERE
	public.lesson_schedule.lesson_id = public.lesson.id AND
	public.lesson.lesson_type = 'individual'
GROUP BY
      year
ORDER BY
	year;

ALTER TABLE public.average_ind_lessons
    OWNER TO postgres;
	
-----------------//////////////////------------------------

CREATE OR REPLACE VIEW public.average_group_lessons
 AS
SELECT 
    EXTRACT (year FROM public.lesson_schedule.start_date) as year,
     (CAST (COUNT(public.lesson_schedule.id) AS DECIMAL)/12)::numeric(1000) AS average_group_lessons
FROM
      public.lesson_schedule,
	  public.lesson
WHERE
	public.lesson_schedule.lesson_id = public.lesson.id AND
	public.lesson.lesson_type = 'group'
GROUP BY
      year
ORDER BY
	year;

ALTER TABLE public.average_group_lessons
    OWNER TO postgres;
	
----------------////////////////////--------------------------

CREATE OR REPLACE VIEW public.average_ensembles
 AS
SELECT 
    EXTRACT (year FROM public.ensemble_schedule.start_date) as year,
     (CAST (COUNT(public.ensemble_schedule.id) AS DECIMAL)/12)::numeric(1000) AS average_ensembles
FROM
      public.ensemble_schedule,
	  public.ensemble
WHERE
	public.ensemble_schedule.ensemble_id = public.ensemble.id
GROUP BY
      year
ORDER BY
	year;

ALTER TABLE public.average_ensembles
    OWNER TO postgres;
	
-------------//////////////////------------------

CREATE OR REPLACE VIEW public.table_average_all_lessons
 AS
SELECT 
    EXTRACT (year FROM public.lesson_schedule.start_date) as year
FROM
      public.lesson_schedule,
	  public.lesson
GROUP BY
      year
ORDER BY
	year;

ALTER TABLE public.table_average_all_lessons
    OWNER TO postgres;
	
-------------------/////////////////////////---------------------
-------------------///////////// Executed query 4 ////////////---------------------
SELECT 
    public.table_average_all_lessons.year as year,
	(public.average_ind_lessons.average_ind_lessons + public.average_group_lessons.average_group_lessons + public.average_ensembles.average_ensembles) AS average_year_lessons,
	CASE 
		WHEN public.average_ind_lessons.average_ind_lessons is NULL THEN '0'
	ELSE
		public.average_ind_lessons.average_ind_lessons
	END AS average_ind_lessons_count,
	
	CASE 
		WHEN public.average_group_lessons.average_group_lessons is NULL THEN '0'
	ELSE
		public.average_group_lessons.average_group_lessons
	END AS average_group_lessons_count,
	
	CASE 
		WHEN public.average_ensembles.average_ensembles is NULL THEN '0'
	ELSE
		public.average_ensembles.average_ensembles
	END AS average_ensembles_count
	
FROM
    public.table_average_all_lessons 	LEFT JOIN public.average_ind_lessons ON ( public.table_average_all_lessons.year = public.average_ind_lessons.year)
										LEFT JOIN public.average_group_lessons ON ( public.table_average_all_lessons.year = public.average_group_lessons.year)
										LEFT JOIN public.average_ensembles ON ( public.table_average_all_lessons.year = public.average_ensembles.year)
ORDER BY
    year
	
-------------------/////////////////////////---------------------



---------------------Query 5 ------------------------

-------------------///////// VIEW ////////////---------------

CREATE OR REPLACE VIEW public.given_ensembles_by_instructor
 AS
SELECT 
       EXTRACT(year FROM public.ensemble_schedule.start_date) AS year,
       EXTRACT(month FROM public.ensemble_schedule.start_date) AS month,
	   public.instructor.id,
       public.instructor.first_name,
       public.instructor.last_name,
       public.instructor.person_number,
       COUNT(public.ensemble_schedule.ensemble_id) AS total_given_ensembles
FROM
    public.instructor
    INNER JOIN public.ensemble ON (public.ensemble.instructor_id = public.instructor.id)
    INNER JOIN public.ensemble_schedule ON (public.ensemble.id = public.ensemble_schedule.ensemble_id)
WHERE
     EXTRACT(year FROM public.ensemble_schedule.start_date) = EXTRACT(year FROM CURRENT_DATE) AND 
     EXTRACT(month FROM public.ensemble_schedule.start_date) = EXTRACT(month FROM CURRENT_DATE)
GROUP BY
      EXTRACT(year FROM public.ensemble_schedule.start_date),
      EXTRACT(month FROM public.ensemble_schedule.start_date),
	  public.instructor.id,
      public.instructor.first_name,
      public.instructor.last_name,
      public.instructor.person_number
ORDER BY
      total_given_ensembles DESC;

ALTER TABLE public.given_ensembles_by_instructor
    OWNER TO postgres;

-------------------///////////////////////---------------------

CREATE OR REPLACE VIEW public.given_lessons_by_instructor
 AS
SELECT 
       EXTRACT(year FROM public.lesson_schedule.start_date) AS year,
       EXTRACT(month FROM public.lesson_schedule.start_date) AS month,
	   public.instructor.id,
       public.instructor.first_name,
       public.instructor.last_name,
       public.instructor.person_number,
       COUNT(public.lesson_schedule.lesson_id) AS total_given_lessons
FROM
    public.instructor
    INNER JOIN public.lesson ON (public.lesson.instructor_id = public.instructor.id)
    INNER JOIN public.lesson_schedule ON (public.lesson.id = public.lesson_schedule.lesson_id)
WHERE
     EXTRACT(year FROM public.lesson_schedule.start_date) = EXTRACT(year FROM CURRENT_DATE) AND 
     EXTRACT(month FROM public.lesson_schedule.start_date) = EXTRACT(month FROM CURRENT_DATE)
GROUP BY
      EXTRACT(year FROM public.lesson_schedule.start_date),
      EXTRACT(month FROM public.lesson_schedule.start_date),
	  public.instructor.id,
      public.instructor.first_name,
      public.instructor.last_name,
      public.instructor.person_number
ORDER BY
      total_given_lessons DESC;

ALTER TABLE public.given_lessons_by_instructor
    OWNER TO postgres;
	
--------------////////////////-----------------------

CREATE OR REPLACE VIEW public.given_ensembles_by_instructor_previous_month
 AS
SELECT 
       EXTRACT(year FROM public.ensemble_schedule.start_date) AS year,
       EXTRACT(month FROM public.ensemble_schedule.start_date) AS month,
	   public.instructor.id,
       public.instructor.first_name,
       public.instructor.last_name,
       public.instructor.person_number,
       COUNT(public.ensemble_schedule.ensemble_id) AS total_given_ensembles
FROM
    public.instructor
    INNER JOIN public.ensemble ON (public.ensemble.instructor_id = public.instructor.id)
    INNER JOIN public.ensemble_schedule ON (public.ensemble.id = public.ensemble_schedule.ensemble_id)
WHERE
     EXTRACT(year FROM public.ensemble_schedule.start_date) = EXTRACT(year FROM CURRENT_DATE - interval'1 month') AND 
     EXTRACT(month FROM public.ensemble_schedule.start_date) = EXTRACT(month FROM CURRENT_DATE - interval'1 month')
GROUP BY
      EXTRACT(year FROM public.ensemble_schedule.start_date),
      EXTRACT(month FROM public.ensemble_schedule.start_date),
	  public.instructor.id,
      public.instructor.first_name,
      public.instructor.last_name,
      public.instructor.person_number
ORDER BY
      total_given_ensembles DESC;

ALTER TABLE public.given_ensembles_by_instructor_previous_month
    OWNER TO postgres;
	
-----------///////////------------------

CREATE OR REPLACE VIEW public.given_lessons_by_instructor_previous_month
 AS
SELECT 
       EXTRACT(year FROM public.lesson_schedule.start_date) AS year,
       EXTRACT(month FROM public.lesson_schedule.start_date) AS month,
       public.instructor.first_name,
	   public.instructor.id,
       public.instructor.last_name,
       public.instructor.person_number,
       COUNT(public.lesson_schedule.lesson_id) AS total_given_lessons
FROM
    public.instructor
    INNER JOIN public.lesson ON (public.lesson.instructor_id = public.instructor.id)
    INNER JOIN public.lesson_schedule ON (public.lesson.id = public.lesson_schedule.lesson_id)
WHERE
     EXTRACT(year FROM public.lesson_schedule.start_date) = EXTRACT(year FROM CURRENT_DATE - interval'1 month') AND 
     EXTRACT(month FROM public.lesson_schedule.start_date) = EXTRACT(month FROM CURRENT_DATE - interval'1 month')
GROUP BY
      EXTRACT(year FROM public.lesson_schedule.start_date),
      EXTRACT(month FROM public.lesson_schedule.start_date),
	  public.instructor.id,
      public.instructor.first_name,
      public.instructor.last_name,
      public.instructor.person_number
ORDER BY
      total_given_lessons DESC;

ALTER TABLE public.given_lessons_by_instructor_previous_month
    OWNER TO postgres;
	
-------------///////////////-----------------

CREATE OR REPLACE VIEW public.total_given_lessons_by_instructor
 AS
SELECT 
  public.given_lessons_by_instructor.year as year,
  public.given_lessons_by_instructor.month as month
FROM
  public.given_lessons_by_instructor
GROUP BY
  public.given_lessons_by_instructor.year,
  public.given_lessons_by_instructor.month
HAVING 
  public.given_lessons_by_instructor.year = EXTRACT(year FROM CURRENT_DATE)
ORDER BY year;

ALTER TABLE public.total_given_lessons_by_instructor
    OWNER TO postgres;
	
------------////////////////------------------

CREATE OR REPLACE VIEW public.available_instructors
 AS
SELECT 
	public.instructor.id,
	public.instructor.first_name,
	public.instructor.last_name,
	public.instructor.person_number
FROM 
	public.instructor
GROUP BY
	public.instructor.id,
	public.instructor.first_name,
	public.instructor.last_name,
	public.instructor.person_number
ORDER BY
    last_name, first_name ASC;

ALTER TABLE public.available_instructors
    OWNER TO postgres;
	
----------------//////////////////------------------

CREATE OR REPLACE VIEW public.total_given_lessons_by_instructor_current_month
 AS
SELECT 
	public.given_lessons_by_instructor.first_name,
	public.given_lessons_by_instructor.last_name,
	public.given_lessons_by_instructor.person_number,
	public.instructor.id,
	(public.given_lessons_by_instructor.total_given_lessons + public.given_ensembles_by_instructor.total_given_ensembles) AS total_lessons_for_current_month
FROM 
	public.given_ensembles_by_instructor,
	public.given_lessons_by_instructor,
	public.instructor
WHERE 
	public.instructor.id = public.given_lessons_by_instructor.id AND
	public.instructor.id = public.given_ensembles_by_instructor.id
GROUP BY
	total_lessons_for_current_month,
	public.given_lessons_by_instructor.first_name,
	public.given_lessons_by_instructor.last_name,
	public.given_lessons_by_instructor.person_number,
	public.instructor.id
ORDER BY
    total_lessons_for_current_month DESC;

ALTER TABLE public.total_given_lessons_by_instructor_current_month
    OWNER TO postgres;
	
-----------///////////////--------------

CREATE OR REPLACE VIEW public.total_given_lessons_by_instructor_previous_month
 AS
SELECT 
	public.instructor.id,
	public.given_lessons_by_instructor_previous_month.first_name,
	public.given_lessons_by_instructor_previous_month.last_name,
	public.given_lessons_by_instructor_previous_month.person_number,
	(public.given_lessons_by_instructor_previous_month.total_given_lessons + public.given_ensembles_by_instructor_previous_month.total_given_ensembles) AS total_lessons_for_previous_month
FROM 
	public.instructor,
	public.given_lessons_by_instructor_previous_month,
	public.given_ensembles_by_instructor_previous_month
WHERE 
	public.instructor.id = public.given_lessons_by_instructor_previous_month.id AND
	public.instructor.id = public.given_ensembles_by_instructor_previous_month.id
GROUP BY
	total_lessons_for_previous_month,
	public.given_lessons_by_instructor_previous_month.first_name,
	public.given_lessons_by_instructor_previous_month.last_name,
	public.given_lessons_by_instructor_previous_month.person_number,
	public.instructor.id
ORDER BY
    total_lessons_for_previous_month DESC
LIMIT 3;

ALTER TABLE public.total_given_lessons_by_instructor_previous_month
    OWNER TO postgres;
	
---------------/////////////////----------------
---------------//////// Executed query 5 /////////----------------

SELECT 
	public.available_instructors.first_name,
	public.available_instructors.last_name,
	public.total_given_lessons_by_instructor_current_month.total_lessons_for_current_month AS total_number_of_lessons_for_current_month,
	CASE 
		WHEN public.total_given_lessons_by_instructor_previous_month.total_lessons_for_previous_month is NULL THEN '0'
	ELSE
		public.total_given_lessons_by_instructor_previous_month.total_lessons_for_previous_month
	END AS total_number_of_lessons_for_previous_month
FROM 
	public.available_instructors	FULL OUTER JOIN public.total_given_lessons_by_instructor_current_month ON (public.total_given_lessons_by_instructor_current_month.id = available_instructors.id)
									FULL OUTER JOIN public.total_given_lessons_by_instructor_previous_month ON (public.total_given_lessons_by_instructor_previous_month.id = available_instructors.id)
WHERE 
	total_lessons_for_current_month > 8 AND
	public.available_instructors.person_number = public.total_given_lessons_by_instructor_current_month.person_number OR
	public.available_instructors.person_number = public.total_given_lessons_by_instructor_previous_month.person_number

ORDER BY
    total_number_of_lessons_for_previous_month DESC
	
---------------/////////////////----------------
	
	
---------------////////		Query 6		/////////----------------
CREATE MATERIALIZED VIEW public.next_week_ensembles_list
AS
SELECT 
  	public.ensemble.id,
  	public.ensemble_schedule.week_day,
  	public.ensemble_schedule.start_date,
  	public.ensemble.genre,
	CASE WHEN maximum_enrolled_students - enrolled_students =0 THEN 'Full booked'
		WHEN maximum_enrolled_students - enrolled_students =1 OR maximum_enrolled_students - enrolled_students =2 THEN '1-2 seats'
		ELSE 'has more seats left'
	END AS available_seats
FROM
  	public.ensemble_schedule
	INNER JOIN public.ensemble ON (public.ensemble_schedule.ensemble_id = public.ensemble.id)
WHERE
	public.ensemble_schedule.start_date <= CURRENT_DATE + interval'2 week' AND 
	public.ensemble_schedule.start_date >= CURRENT_DATE + interval'1 week'
ORDER BY
	public.ensemble.genre, public.ensemble_schedule.start_date
WITH DATA;

ALTER TABLE public.next_week_ensembles_list
    OWNER TO postgres;
	
---------------/////////////////----------------

---------------////////		Query 7 	/////////----------------

CREATE MATERIALIZED VIEW public.instrument_lowest_monthly_fee
AS
SELECT *
FROM
	(SELECT 
	DISTINCT ON (public.lesson.instrument_kind) instrument_kind,
  	public.stock.instrument_rental_fee AS instrument_fee,
  	public.lesson.lesson_type,
  	public.lesson_schedule.start_date AS start_date,
	CASE WHEN public.stock.amount - public.stock.rented_instruments =0 THEN 'Not available'
		ELSE 'Available'
	END AS available_instruments
FROM
  public.instrument_rental
  INNER JOIN public.instrument ON (public.instrument_rental.instrument_id = public.instrument.id)
  INNER JOIN public.stock ON (public.instrument.id = public.stock.instrument_id)
  INNER JOIN public.lesson ON (public.lesson.instrument_kind = public.instrument.kind)
  INNER JOIN public.lesson_schedule ON (public.lesson_schedule.lesson_id = public.lesson.id)
WHERE
  public.lesson_schedule.start_date >= CURRENT_DATE AND 
  public.lesson.lesson_type = 'group'
ORDER BY
	instrument_kind, start_date ASC, instrument_fee ASC) AS data1
	
ORDER BY 
	instrument_fee
LIMIT 3
WITH DATA;

ALTER TABLE public.instrument_lowest_monthly_fee
    OWNER TO postgres;