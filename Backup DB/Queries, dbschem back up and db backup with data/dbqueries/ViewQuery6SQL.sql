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