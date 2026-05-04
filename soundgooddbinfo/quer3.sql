---First part of Query 3 ----
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
  
  
---- ////////////////////////////////////////////////////////////////////---------


---Second part of Query 3 ----

SELECT 
	EXTRACT (year FROM public.lesson_schedule.start_date) as year,
  	COUNT(public.lesson_schedule.id) as given_lessons
FROM
  public.lesson_schedule
GROUP BY
  EXTRACT (year FROM public.lesson_schedule.start_date)
  HAVING 
	EXTRACT (year FROM public.lesson_schedule.start_date) = '2014' OR
 	EXTRACT (year FROM public.lesson_schedule.start_date) = '2015' OR 
  	EXTRACT (year FROM public.lesson_schedule.start_date) = '2016' OR 
  	EXTRACT (year FROM public.lesson_schedule.start_date) = '2017' OR 
  	EXTRACT (year FROM public.lesson_schedule.start_date) = '2018' OR 
  	EXTRACT (year FROM public.lesson_schedule.start_date) = '2019' OR 
  	EXTRACT (year FROM public.lesson_schedule.start_date) = '2020'
	
  ORDER BY year
  
  
  
---- ////////////////////////////////////////////////////////////////////---------


---Third part of Query 3 ----

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
  	public.lesson_schedule.lesson_id = public.lesson.id 
GROUP BY
	EXTRACT (year FROM public.lesson_schedule.start_date),
  	EXTRACT (month FROM public.lesson_schedule.start_date),
	lesson_type

ORDER BY 
	month
	
	---------/////////////////////////////----------------
	
SELECT 
	EXTRACT (year FROM public.ensemble_schedule.start_date) as ensemble_year,
  	EXTRACT (month FROM public.ensemble_schedule.start_date) as ensemble_month,
	COUNT(public.ensemble_schedule.id) as given_ensembles,
	'ensembles' as ensemble_type
FROM
	public.ensemble,
	public.ensemble_schedule
WHERE 
	EXTRACT (year FROM public.ensemble_schedule.start_date) = 2014 AND
	public.ensemble_schedule.ensemble_id = public.ensemble.id
GROUP BY
	EXTRACT (year FROM public.ensemble_schedule.start_date),
  	EXTRACT (month FROM public.ensemble_schedule.start_date),
	ensemble_type

ORDER BY 
 	ensemble_year, ensemble_month