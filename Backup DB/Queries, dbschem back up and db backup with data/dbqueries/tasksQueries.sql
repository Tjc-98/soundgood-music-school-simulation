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




-------------QUERY2 in VIEW--------------	

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





--------Query3 in View --------------
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




------------Query4 in View-------------------

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




---------------------Query 5 in View------------------------
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



---------------------Query 6 in MATERIALIZED  View------------------------


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


---------------------Query 7 in MATERIALIZED  View------------------------



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