--------------Query4 materlized view creation

CREATE MATERIALIZED VIEW public.average_ind_lessons
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
	year
WITH DATA;

ALTER TABLE public.average_ind_lessons
    OWNER TO postgres;


----------------------------------------------------

CREATE MATERIALIZED VIEW public.average_group_lessons
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
	year
WITH DATA;

ALTER TABLE public.average_group_lessons
    OWNER TO postgres;
	
	
------------------------------------------------------

CREATE MATERIALIZED VIEW public.average_ensembles
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
	year
WITH DATA;

ALTER TABLE public.average_ensembles
    OWNER TO postgres;
	
	
------------------------------------------------------
	
CREATE MATERIALIZED VIEW public.table_average_all_lessons
AS
SELECT 
    EXTRACT (year FROM public.lesson_schedule.start_date) as year
FROM
      public.lesson_schedule,
	  public.lesson
GROUP BY
      year
ORDER BY
	year
WITH DATA;

ALTER TABLE public.average_ind_lessons
    OWNER TO postgres;
	
	
------------Query4 Solution -------------------

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

