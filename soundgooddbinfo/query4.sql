----//////////////-------
 --lessons_average-- The 4th query ---------

SELECT 
    EXTRACT (year FROM public.lesson_schedule.start_date) as year,
    AVG(count_lessons_ids)::numeric(1000)
FROM
      public.lesson_schedule,
    (
    SELECT
         COUNT(public.lesson_schedule.id) AS count_lessons_ids
    FROM 
         public.lesson_schedule 
    WHERE 
         EXTRACT (year FROM public.lesson_schedule.start_date) = '2014'
    GROUP BY 
         EXTRACT (month FROM public.lesson_schedule.start_date)
    ) AS total_lessons
WHERE 
    EXTRACT (year FROM public.lesson_schedule.start_date) = '2014'
GROUP BY
      year
	  
	  
	  
----//////////////-------
 --ensembles_average-- The 4th query ---------

SELECT 
    EXTRACT (year FROM public.ensemble_schedule.start_date) as year,
    AVG(count_ensembles_ids)::numeric(1000)
FROM
      public.ensemble_schedule,
    (
    SELECT
         COUNT(public.ensemble_schedule.id) AS count_ensembles_ids
    FROM 
         public.ensemble_schedule 
    WHERE 
         EXTRACT (year FROM public.ensemble_schedule.start_date) = '2014'
    GROUP BY 
         EXTRACT (month FROM public.ensemble_schedule.start_date)
    ) AS total_lessons
WHERE 
    EXTRACT (year FROM public.ensemble_schedule.start_date) = '2014'
GROUP BY
      year