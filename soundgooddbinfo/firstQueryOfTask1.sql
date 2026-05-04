SELECT
  public.instrument.id,
  public.instrument.name,
  public.instrument_rental.rental_id,
  public.instrument_rental.instrument_id,
  public.instrument_rental.rental_date,
  public.instrument_rental.return_date,
  public.instrument_rental.rental_period,
  public.instrument_rental.last_chance_return
FROM
  public.instrument_rental
  INNER JOIN public.instrument ON (public.instrument_rental.instrument_id = public.instrument.id)
 WHERE  
 	public.instrument_rental.rental_date >= '2015-01-01' AND
    public.instrument_rental.rental_date <= '2016-05-01'