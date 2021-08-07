/* Criar Tabela */

DROP TABLE IF EXISTS fBrasil

CREATE TABLE fBrasil 
(
Regiao VARCHAR(255),
Sigla VARCHAR(5)

);

/*Inserir dados na tabela */

INSERT INTO fBrasil VALUES
('Norte', 'AM'),
('Norte', 'RR'),
('Norte', 'AP'),
('Norte', 'PA'),
('Norte', 'TO'),
('Norte', 'RO'),
('Norte', 'AC'),
('Nordeste', 'MA'),
('Nordeste', 'PI'),
('Nordeste', 'CE'),
('Nordeste', 'RN'),
('Nordeste', 'PE'),
('Nordeste', 'PB'),
('Nordeste', 'SE'),
('Nordeste', 'AL'),
('Nordeste', 'BA'),
('Centro-Oeste', 'MT'),
('Centro-Oeste', 'MS'),
('Centro-Oeste', 'GO'),
('Sudeste', 'SP'),
('Sudeste', 'RJ'),
('Sudeste', 'ES'),
('Sudeste', 'MG'),
('Sul', 'PR'),
('Sul', 'RS'),
('Sul', 'SC')