DELETE FROM public.instrument;

INSERT INTO
  public.instrument(id,name,type,condition,brand)
VALUES
(1,'Piano','string','good','Bechstein'),
(2,'Piano','string','good','FAZIOLI'),
(3,'Violin','string','good','Stentor'),
(4,'Drums','percussion','very good','YAMAHA'),
(5,'Saxophone','brass','good','Selmer Paris'),
(6,'Clarinet','woodwind','good','Yamaha'),
(7,'Trumpet','brass','good','Rossetti'),
(8,'Clarinet','woodwind','bad','Mendini'),
(9,'Trumpet','brass','good','Cecilio'),
(10,'Trumpet','brass','bad','Allora');