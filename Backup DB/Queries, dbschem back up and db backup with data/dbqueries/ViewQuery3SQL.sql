-------------QUERY3 #1#--------------	


CREATE MATERIALIZED VIEW public.given_lessons
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
HAVING 
  EXTRACT (year FROM public.lesson_schedule.start_date) = '2014' OR
  EXTRACT (year FROM public.lesson_schedule.start_date) = '2015' OR
  EXTRACT (year FROM public.lesson_schedule.start_date) = '2016' OR
  EXTRACT (year FROM public.lesson_schedule.start_date) = '2017' OR
  EXTRACT (year FROM public.lesson_schedule.start_date) = '2018' OR
  EXTRACT (year FROM public.lesson_schedule.start_date) = '2019' OR
  EXTRACT (year FROM public.lesson_schedule.start_date) = '2020' 
  ORDER BY year
WITH DATA;

ALTER TABLE public.given_lessons
    OWNER TO postgres;
	
	
CREATE MATERIALIZED VIEW public.group_total_given_lessons
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
	EXTRACT (year FROM public.lesson_schedule.start_date) = 2014 AND
  	public.lesson_schedule.lesson_id = public.lesson.id AND
	public.lesson.lesson_type = 'group'
GROUP BY
	EXTRACT (year FROM public.lesson_schedule.start_date),
  	EXTRACT (month FROM public.lesson_schedule.start_date),
	lesson_type

ORDER BY 
	month
WITH DATA;

ALTER TABLE public.group_total_given_lessons
    OWNER TO postgres;
	
	
	
CREATE MATERIALIZED VIEW public.individual_total_given_lessons
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
	EXTRACT (year FROM public.lesson_schedule.start_date) = 2014 AND
  	public.lesson_schedule.lesson_id = public.lesson.id AND
	public.lesson.lesson_type = 'individual'
GROUP BY
	EXTRACT (year FROM public.lesson_schedule.start_date),
  	EXTRACT (month FROM public.lesson_schedule.start_date),
	lesson_type

ORDER BY 
	month
WITH DATA;

ALTER TABLE public.individual_total_given_lessons
    OWNER TO postgres;
	
	
	
CREATE MATERIALIZED VIEW public.total_given_ensembles
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
 	ensemble_year, ensemble_month
WITH DATA;

ALTER TABLE public.total_given_ensembles
    OWNER TO postgres;
	
	
	
	
CREATE MATERIALIZED VIEW public.group_total_given_lessons
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
	year, month
WITH DATA;

ALTER TABLE public.group_total_given_lessons
    OWNER TO postgres;
	
	
	
	
	
	
	
	
--------Query3 in materialized View --------------
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
	


----------------///////VIEW/////////////-------------------

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

