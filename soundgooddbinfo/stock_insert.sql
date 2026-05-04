DELETE FROM public.stock;
INSERT INTO public.stock(
	instrument_id, amount, instrument_rental_fee, rented_instruments)
VALUES 
	(1, 82, 218, 52),
	(2, 15, 202, 15),
	(3, 78, 201, 49),
	(4, 87, 418, 87),
	(5, 76, 425, 35),
	(6, 40, 306, 21),
	(7, 52, 300, 36),
	(8, 34, 110, 21),
	(9, 10, 240, 10),
	(10, 29, 292, 12);