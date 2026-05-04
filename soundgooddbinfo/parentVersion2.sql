DELETE FROM public.parent;
INSERT INTO public.parent(
	student_id, first_name, last_name, person_number, street, city, zip_code, telefon_number, email_address)
	VALUES 
	(1, 'Berj', 'Bedros', '196410104323', 'AddressValue', 'sodertalje', 15151, 0728594234, 'Berj@Berj.Berj'),
	(2, 'Berj', 'Bedros', '196410104323', 'AddressValue', 'sodertalje', 15151, 0728594234, 'Berj@Berj.Berj'),
	(2, 'Berj', 'Bedros', '196910104323', 'AddressValue', 'sodertalje', 15151, 0723592344, 'Soad@Soad.Soad');