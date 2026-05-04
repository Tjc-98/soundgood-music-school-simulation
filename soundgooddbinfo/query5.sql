----//////////////-------
----- first part of 5th query ---------

SELECT 
  public.instructor.id,
  public.instructor.last_name,
  public.instructor.first_name,
  public.instructor.person_number,
  COUNT(public.lesson_schedule.id) + COUNT(public.ensemble_schedule.id) AS lesson_count
FROM
  public.instructor
  INNER JOIN public.lesson ON (public.instructor.id = public.lesson.instructor_id)
  INNER JOIN public.lesson_schedule ON (public.lesson.id = public.lesson_schedule.lesson_id)
  INNER JOIN public.ensemble ON (public.instructor.id = public.ensemble.instructor_id)
  INNER JOIN public.ensemble_schedule ON (public.ensemble.id = public.ensemble_schedule.ensemble_id)
WHERE
     EXTRACT(year FROM public.lesson_schedule.start_date) = EXTRACT(year FROM CURRENT_DATE) AND
     EXTRACT(month FROM public.lesson_schedule.start_date) = EXTRACT(month FROM CURRENT_DATE) AND
	 EXTRACT(year FROM public.ensemble_schedule.start_date) = EXTRACT(year FROM CURRENT_DATE) AND
     EXTRACT(month FROM public.ensemble_schedule.start_date) = EXTRACT(month FROM CURRENT_DATE)
GROUP BY
  public.instructor.id,
  public.instructor.last_name,
  public.instructor.first_name,
  public.instructor.person_number
HAVING
	COUNT(public.lesson_schedule.id) + COUNT(public.ensemble_schedule.id) >= 20
ORDER BY 
	lesson_count DESC
	
	
	
----//////////////-------
----- second part of 5th query ---------

SELECT 
  public.instructor.id,
  public.instructor.last_name,
  public.instructor.first_name,
  public.instructor.person_number,
  COUNT(public.lesson_schedule.id) + COUNT(public.ensemble_schedule.id) AS lesson_count
FROM
  public.instructor
  INNER JOIN public.lesson ON (public.instructor.id = public.lesson.instructor_id)
  INNER JOIN public.lesson_schedule ON (public.lesson.id = public.lesson_schedule.lesson_id)
  INNER JOIN public.ensemble ON (public.instructor.id = public.ensemble.instructor_id)
  INNER JOIN public.ensemble_schedule ON (public.ensemble.id = public.ensemble_schedule.ensemble_id)
WHERE
     EXTRACT(year FROM public.lesson_schedule.start_date) = EXTRACT(year FROM CURRENT_DATE - interval'1 month') AND
     EXTRACT(month FROM public.lesson_schedule.start_date) = EXTRACT(month FROM CURRENT_DATE - interval'1 month') AND
	 EXTRACT(year FROM public.ensemble_schedule.start_date) = EXTRACT(year FROM CURRENT_DATE - interval'1 month') AND
     EXTRACT(month FROM public.ensemble_schedule.start_date) = EXTRACT(month FROM CURRENT_DATE - interval'1 month')
GROUP BY
  public.instructor.id,
  public.instructor.last_name,
  public.instructor.first_name,
  public.instructor.person_number
HAVING
	COUNT(public.lesson_schedule.id) + COUNT(public.ensemble_schedule.id) >= 0
ORDER BY 
	lesson_count DESC

