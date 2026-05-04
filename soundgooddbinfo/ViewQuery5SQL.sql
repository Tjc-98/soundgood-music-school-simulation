-------------------- given_ensembles_by_instructor -----------------

CREATE MATERIALIZED VIEW public.given_ensembles_by_instructor
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
      total_given_ensembles DESC

WITH DATA;

ALTER TABLE public.given_ensembles_by_instructor
    OWNER TO postgres;
	
	
	
-------------------- given_lessons_by_instructor -----------------

CREATE MATERIALIZED VIEW public.given_lessons_by_instructor
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
      total_given_lessons DESC

WITH DATA;

ALTER TABLE public.given_lessons_by_instructor
    OWNER TO postgres;
	
	
-------------------- given_ensembles_by_instructor_previous_month -----------------	
	
	
CREATE MATERIALIZED VIEW public.given_ensembles_by_instructor_previous_month
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
      total_given_ensembles DESC

WITH DATA;

ALTER TABLE public.given_ensembles_by_instructor_previouse_month
    OWNER TO postgres;
	
-------------------- given_lessons_by_instructor_previous_month -----------------	
	
CREATE MATERIALIZED VIEW public.given_lessons_by_instructor_previous_month
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
      total_given_lessons DESC
WITH DATA;

ALTER TABLE given_lessons_by_instructor_previous_month
    OWNER TO postgres;
	
	
-------------total_given_lessons_by_instructor-----------------
	
CREATE MATERIALIZED VIEW public.total_given_lessons_by_instructor
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
ORDER BY year

WITH DATA;
ALTER TABLE public.total_given_lessons_by_instructor
    OWNER TO postgres;


-------------instructors-----------------

CREATE MATERIALIZED VIEW public.available_instructors
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
    last_name, first_name ASC
WITH DATA;
ALTER TABLE public.available_instructors
    OWNER TO postgres;
	
-------------total_given_lessons_by_instructor_current_month-----------------	
	
CREATE MATERIALIZED VIEW public.total_given_lessons_by_instructor_current_month
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
    total_lessons_for_current_month DESC
WITH DATA;
ALTER TABLE public.total_given_lessons_by_instructor_current_month
    OWNER TO postgres;	
	
	
-------------total_given_lessons_by_instructor_previous_month-----------------	
CREATE MATERIALIZED VIEW public.total_given_lessons_by_instructor_previous_month
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
WITH DATA;
ALTER TABLE public.total_given_lessons_by_instructor_previous_month
    OWNER TO postgres;	
	
	
---------------------Query 5 ------------------------
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
	public.available_instructors.person_number = public.total_given_lessons_by_instructor_current_month.person_number OR
	public.available_instructors.person_number = public.total_given_lessons_by_instructor_previous_month.person_number

ORDER BY
    total_number_of_lessons_for_previous_month DESC
	
	
	
	
	
	
	
	
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

