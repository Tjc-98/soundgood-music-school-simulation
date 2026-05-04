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