DELETE FROM public.instructor;
ALTER SEQUENCE public.instructor_id_seq RESTART WITH 1;	
INSERT INTO public.instructor(
	 first_name, last_name, person_number, street, city, zip_code)
VALUES 	
	('Moltas', 'Blom', '199108260317', 'Föreningsgatan 30', 'SKÄRPLINGE', '81065'),
	('Norea', 'Gunnarsson', '196211079162', 'Barrgatan 21', 'GLOMMERSTRÄSK', '93081'),
	('Dani', 'Carlsson', '197206179892', 'Änggårda Anga 70', 'GRUMS', '66400'),
	('Sanja', 'Gunnarsson', '197303269968', 'Törneby 49', 'ÅTORP', '69350'),
	('Alexia', 'Berggren', '197511219581', 'Långlöt 6', 'BYXELKROK', '38075'),
	('Alwin', 'Nyström', '199011255958', 'Idvägen 17', 'VADSTENA', '59200'),
	('Noelia', 'Lindqvist', '196907107764', 'Alingsåsvägen 84', 'HEDARED', '50580'),
	('Jack', 'Göransson', '197006182773', 'Mållångsbo 67', 'PAJALA', '98451'),
	('Kalle', 'Holmgren', '198712053951', 'Östbygatan 65', 'KUNGSÖR', '73693'),
	('Alwin', 'Söderberg', '198709085412', 'Hantverkarg 55', 'RUNMARÖ', '13038'),
	('Susanna', 'Eliasson', '198207099121', 'Stackekärr 38', 'HARMÅNGER', '82075'),
	('Petrus', 'Pettersson', '198809199691', 'Messlingen 74', 'LILLHÄRDAL', '84080'),
	('Elvin', 'Karlsson', '198505221518', 'Lidbovägen 34', 'LILLPITE', '94017'),
	('Alex', 'Hellström', '199106277636', 'Edeby 73', 'VAGNHÄRAD', '61070'),
	('Anastasija', 'Gunnarsson', '195607194601', 'Nybyvägen 7', 'ANKARSRUM', '59090');