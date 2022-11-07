CREATE TABLE alunos(
	id SERIAL,
		nome VARCHAR(255),
		cpf CHAR(11),
		observação TEXT,
		idade INTEGER,
		dinheiro NUMERIC(10,2),
		altura REAL,
		ativo BOOLEAN,
		data_nascimento DATE,
		hora_aula TIME,
		matriculado_em TIMESTAMP
);

INSERT INTO alunos (
	nome,
	cpf,
	observação,
	idade,
	dinheiro,
	altura,
	ativo,
	data_nascimento,
	hora_aula,
	matriculado_em
) VALUES (
	'Diogo',
	'12345678901',
	'promoção combo cursoa',
	35,
	100.5,
	1.81,
	TRUE,
	'1984-08-27',
	'17:30:00',
	'2020-02-08 12:32:45'
);

SELECT * FROM alunos;

--Atualizando banco 

UPDATE alunos
	SET nome = 'Nico',
	cpf = '10987654321',
	observação = 'teste',
	idade = 38,
	dinheiro = 15.23,
	altura = 1.90,
	ativo = FALSE,
	data_nascimento = '1980-01-15',
	hora_aula = '13:00:00',
	matriculado_em = '2020-01-02 15:00:00'
WHERE id = 1;

--excluindo registro

DELETE 
	FROM alunos
	WHERE nome = 'Nico';
    
	
--Selecionando colunas específicas da tabela

--inserir novamente dados de Diogo

SELECT nome,
	   idade,
	   matriculado_em
	FROM alunos;

--usando o comando AS para trocar o nome de exibição dos campos na tabela

SELECT nome AS "Nome do Aluno",
	   idade,
	   matriculado_em AS "quando se matrículou"
	FROM alunos;
	

INSERT INTO alunos (nome) VALUES ('Vinícius Dias');
INSERT INTO alunos (nome) VALUES ( 'Nico Steppat');
INSERT INTO alunos (nome) VALUES ('João Roberto');
INSERT INTO alunos (NOME) VALUES ('Diego');
	
--Filtrando registros de campos do tipo texto

--filtro diferente de (<> ou !=) 

SELECT nome
	FROM alunos
WHERE nome <> 'Diogo';
	
--filtro parecido com (LIKE) 

SELECT nome
	FROM alunos
WHERE nome LIKE 'Diogo';


--usando _ "qualquer caractere naquela posição" 

SELECT nome
	FROM alunos
WHERE nome LIKE 'Di_go'; /*o filtro ignora o terceiro caractere entre o "Di" e o "go", ou seja, a tabela retornará tanto o "Diego", 
                                quanto o "Diogo".*/


--usando o _ com o comando NOT LIKE, ou seja, "não parece com" 

SELECT nome
	FROM alunos
WHERE nome NOT LIKE 'Di_go'; 


--o caractere % substitui todos os caracteres até o espaço que ele ocupa.

SELECT nome
	FROM alunos
WHERE nome LIKE 'D%';

SELECT * 
    FROM alunos
 WHERE nome LIKE '% %'; --retorna todos os nomes que possuem espaços
 
SELECT * 
    FROM alunos
 WHERE nome LIKE '%i%a%'; --apresenta os dados que tenham "i**", em alguma parte do texto, seguido por "a", em outra parte do texto 
 
--Importante: Com exceção do IS e do IS NOT, os operadores não retornam os resultados dos campos que estão nulos!


--Filtrando registros de campos do tipo numérico, data e booleano

SELECT *
	FROM alunos
WHERE cpf IS NULL;

SELECT *
	FROM alunos
WHERE cpf IS NOT NULL;

SELECT *
	FROM alunos
WHERE idade <> 36;

SELECT *
	FROM alunos
WHERE idade >= 35;

SELECT *
	FROM alunos
WHERE idade BETWEEN 20 AND 35;

--Todos esses filtros funcionam para os campos INTERGER, REAL, SERIAL, NUMERIC, DATE, TIME e TIMESTAMP.

--Já campo BOOLEAN usará apenas os filtros = e <>.


SELECT *
	FROM alunos
WHERE ativo = TRUE;

SELECT *
	FROM alunos
WHERE ativo <> TRUE;

SELECT *
	FROM alunos
 WHERE ativo IS NULL;


--Filtrando utilizando operadores E e OU

SELECT *
	FROM alunos
 WHERE nome LIKE 'D%'
 	AND cpf IS NOT NULL;

SELECT *
	FROM alunos
 WHERE nome LIKE 'Diogo'
 	OR nome LIKE 'Rodrigo';
	
--TRABALHANDO COM RELACIONAMENTOS 
--Criando tabela com chave primária 

CREATE TABLE cursos(
	id INTEGER NOT NULL UNIQUE, --determinamos que "id" do curso não pode ser nulo e será um número único
		nome VARCHAR(255)NOT NULL
);

DROP TABLE cursos;

CREATE TABLE cursos(
	id INTEGER PRIMARY KEY,
		nome VARCHAR (255) NOT NULL
);

INSERT INTO cursos (id,nome) VALUES (1,'HTML');
INSERT INTO cursos (id,nome) VALUES (2, 'Javascript');

SELECT * FROM cursos;

--Criando tabela com chave estrangeira

DROP TABLE alunos;

CREATE TABLE alunos (
	id SERIAL PRIMARY KEY,
		nome VARCHAR(255) NOT NULL	
);

INSERT INTO alunos(nome) VALUES ('Diogo');
INSERT INTO alunos(nome) VALUES ('Vinícius'); 


CREATE TABLE tb_aluno_curso(
	alunos_id INTEGER,
		cursos_id INTEGER,
		PRIMARY KEY(alunos_id, cursos_id),
	
	FOREIGN KEY (alunos_id)
	 REFERENCES alunos(id),
	
	FOREIGN KEY (cursos_id)
	 REFERENCES cursos(id)
	
);

SELECT * FROM tb_aluno_curso;

INSERT INTO tb_aluno_curso(alunos_id,cursos_id) VALUES (1,1);
INSERT INTO tb_aluno_curso(alunos_id,cursos_id) VALUES (2,1);
INSERT INTO tb_aluno_curso(alunos_id,cursos_id) VALUES (3,1); /* msg erro pois  a chave estrangeira bloqueia a entrada de um registro que 
                                                                  não existe na tabela de destino, então usamos essa chave para evitar 
																    inconsistências no banco de dados.*/

--Consultas com relacionamentos

SELECT * 
	FROM alunos
	 JOIN tb_aluno_curso ON tb_aluno_curso.alunos_id = alunos.id
	  JOIN cursos ON cursos.id = tb_aluno_curso.cursos_id

INSERT INTO tb_aluno_curso(alunos_id,cursos_id)VALUES (2,2);

SELECT alunos.nome AS nome_aluno,              --seleciona apenas a coluna com nome do aluno e com o nome do curso
	   cursos.nome AS nome_curso
	FROM alunos
	 JOIN tb_aluno_curso ON tb_aluno_curso.alunos_id = alunos.id
	 	JOIN cursos ON cursos.id = tb_aluno_curso.cursos_id
		
SELECT alunos.nome AS "Nome do Aluno",
       cursos.nome AS "Nome do Curso"
	FROM alunos
	 JOIN tb_aluno_curso ON tb_aluno_curso.alunos_id = alunos.id
	 	JOIN cursos ON cursos.id = tb_aluno_curso.cursos_id
		

--LEFT, RIGHT, CROSS e FULL JOINS - comandos para juntar tabelas quando há informações faltando.

INSERT INTO alunos(nome) VALUES ('Nico');

INSERT INTO cursos (id, nome) VALUES (3,'CSS');

--LEFT JOIN - existe um dado na tabela da esquerda, mas não existe na tabela da direita
SELECT alunos.nome AS "Nome do Aluno",
       cursos.nome AS "Nome do Curso"
	FROM alunos
	 LEFT JOIN tb_aluno_curso ON tb_aluno_curso.alunos_id = alunos.id
	  LEFT JOIN cursos ON cursos.id = tb_aluno_curso.cursos_id

--RIGHT JOIN - existe um dado na tabela da direita, mas não existe na tabela da esquerda
SELECT alunos.nome AS "Nome do Aluno",
	   cursos.nome AS "Nome do Curso"
	FROM alunos
	 RIGHT JOIN tb_aluno_curso ON tb_aluno_curso.alunos_id = alunos.id
	  RIGHT JOIN cursos ON cursos.id = tb_aluno_curso.cursos_id
	  
	  
--FULL JOIN - considera todos os dados, mesmo que o campo da direita ou o campo da esquerda esteja nulo
SELECT alunos.nome AS "Nome do Aluno",
       cursos.nome AS "Nome do Curso"
    FROM alunos
	 FULL JOIN tb_aluno_curso ON tb_aluno_curso.alunos_id = alunos.id
	  FULL JOIN cursos ON cursos.id = tb_aluno_curso.cursos_id
	  
--CROSS JOIN que combina os dados de todas as tabelas, ou seja, multiplica os dados da tabela "A" pelos dados da tabela "B"
SELECT alunos.nome as "Nome do Aluno",
       cursos.nome as "Nome do Curso"
    FROM alunos
CROSS JOIN cursos

INSERT INTO alunos(nome) VALUES('João'); 


--USANDO CASCADE

--DELETE CASACADE

DROP TABLE tb_aluno_curso;  /*apagar a tabela existente e criá-la com essa nova função que ao apagarmos um dado de um banco, 
                                         o registro será apagado de todas as tabelas que o contém .*/

CREATE TABLE tb_aluno_curso(
	alunos_id INTEGER,
	cursos_id INTEGER,
	PRIMARY KEY (alunos_id,cursos_id),
	
	FOREIGN KEY(alunos_id)
	 REFERENCES alunos(id)
	 ON DELETE CASCADE,
	
	FOREIGN KEY(cursos_id)
	 REFERENCES cursos(id)
);

INSERT INTO tb_aluno_curso(alunos_id, cursos_id) VALUES (1,1);
INSERT INTO tb_aluno_curso(alunos_id, cursos_id) VALUES (2,1);
INSERT INTO tb_aluno_curso(alunos_id, cursos_id) VALUES (3,1);
INSERT INTO tb_aluno_curso(alunos_id, cursos_id) VALUES (1,3);

--executar Query com JOIN

DELETE FROM alunos WHERE id = 1;


--UPDATE CASCADE
/*exceutar a query drop table para apagar a tabela existente e criá-la com essa nova função que ao alterarmos um dado de um banco, 
                                         o registro será alterado em todas as tabelas que o contém .*/

CREATE TABLE tb_aluno_curso(
	alunos_id INTEGER,
	cursos_id INTEGER,
	PRIMARY KEY(alunos_id,cursos_id),
	
	FOREIGN KEY(alunos_id)
	REFERENCES alunos(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE,
	
	FOREIGN KEY(cursos_id)
	REFERENCES cursos(id)
);

INSERT INTO tb_aluno_curso (alunos_id, cursos_id) VALUES (2,1);
INSERT INTO tb_aluno_curso (alunos_id, cursos_id) VALUES (3,1);

SELECT * FROM tb_aluno_curso;

UPDATE alunos SET id=20 WHERE id=2;


--Ordenando as consultas [ORDER BY]

CREATE TABLE funcionarios(
	id SERIAL PRIMARY KEY,
	matricula VARCHAR(10),
	nome VARCHAR(255),
	sobrenome VARCHAR(255)
);

INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M001', 'Diogo', 'Mascarenhas');
INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M002', 'Vinícius', 'Dias');
INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M003', 'Nico', 'Steppat');
INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M004', 'João', 'Roberto');
INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M005', 'Diogo', 'Mascarenhas');
INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M006', 'Alberto', 'Martins');

SELECT * 
	FROM funcionarios
	ORDER BY nome;
	
SELECT * 
	FROM funcionarios
	ORDER BY nome, matricula DESC;

INSERT INTO funcionarios (matricula, nome, sobrenome) VALUES ('M007', 'Diogo', 'Oliveira');

SELECT * 
	FROM funcionarios
	ORDER BY 4;

SELECT *
    FROM funcionarios
    ORDER BY 3, 4, 2;
	

SELECT alunos.nome AS "Nome do Aluno",
       cursos.nome AS "Nome do Curso"
	FROM alunos
	 JOIN tb_aluno_curso ON tb_aluno_curso.alunos_id = alunos.id
	 	JOIN cursos ON cursos.id = tb_aluno_curso.cursos_id
	ORDER BY alunos.nome --precisa especificar a tabela pois as duas possuem nome como campo
	

--LIMITANDO AS CONSULTAS

-- LIMIT - limita a quantidade de dados retornados
-- OFFSET - Informa a quantidade de dados que devem ser avançados antes do retorno */

SELECT * FROM funcionarios LIMIT 5; /*somente os cinco primeiros registros serão exibidos*/

SELECT * FROM funcionarios ORDER BY nome LIMIT 5; /*Para retornarmos os resultados de forma ordenada, utilizamos o ORDER BY antes do LIMIT*/

SELECT * FROM funcionarios ORDER BY id LIMIT 5 OFFSET 1; /*exibição de cinco resultados que estão após a linha "1" do banco de dados*/


--FUNÇÕES DE AGREGAÇÃO

-- COUNT - Retorna a quantidade de registros
-- SUM -   Retorna a soma dos registros
-- MAX -   Retorna o maior valor dos registros
-- MIN -   Retorna o menor valor dos registros
-- AVG -   Retorna a média dos registros


SELECT COUNT (id),
	   SUM (id),
	   MAX (id),
	   MIN (id),
	   ROUND(AVG(id),0)
FROM funcionarios;

--AGRUPANDO CONSULTAS 

SELECT DISTINCT nome FROM funcionarios ORDER BY nome;

SELECT DISTINCT nome, sobrenome FROM funcionarios ORDER BY nome;

SELECT
	  nome,
	  sobrenome,
	  COUNT(*)
	FROM funcionarios
	GROUP BY nome, sobrenome
	ORDER BY nome;


SELECT
	  nome,
	  sobrenome,
	  COUNT(*)
	FROM funcionarios
	GROUP BY 1,2
	ORDER BY nome;
	
SELECT cursos.nome
        COUNT(alunos.id)
    FROM alunos
    JOIN tb_aluno_curso ON alunos.id = tb-aluno_curso.alunos_id
    JOIN cursos ON cursos.id = tb-aluno_curso.cursos_id
    GROUP BY 1
    ORDER BY 1

--Filtrando consultas agrupadas

SELECT *
	FROM cursos
	LEFT JOIN tb_aluno_curso ON tb_aluno_curso.cursos_id = cursos.id
	LEFT JOIN alunos ON alunos.id = tb-aluno_curso.alunos_id


SELECT *
	   COUNT(aluno.id)
	FROM cursos
	LEFT JOIN tb_aluno_curso ON tb_aluno_curso.cursos_id = cursos.id
	LEFT JOIN alunos ON alunos.id = tb-aluno_curso.alunos_id
GROUP BY 1	


SELECT *
	FROM cursos
	LEFT JOIN tb_aluno_curso ON tb_aluno_curso.cursos_id = cursos.id
	LEFT JOIN alunos ON alunos.id = tb-aluno_curso.alunos_id
GROUP BY 1
	HAVING COUNT (aluno.id) = 0
	
SELECT *
	FROM cursos
	LEFT JOIN tb_aluno_curso ON tb_aluno_curso.cursos_id = cursos.id
	LEFT JOIN alunos ON alunos.id = tb-aluno_curso.alunos_id
GROUP BY 1
	HAVING COUNT (aluno.id) >1
	
	
SELECT nome
    FROM funcionarios
    GROUP BY nome
    HAVING COUNT(id) > 1;
	
SELECT nome,
       COUNT(id)
    FROM funcionarios
    GROUP BY nome
    HAVING COUNT(id) > 1;