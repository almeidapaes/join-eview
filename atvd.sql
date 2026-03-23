-- ========== QUESTÃO 1 ==========
-- Gere uma lista de todos os instrutores, mostrando sua ID, nome e 
-- número de seções que eles ministraram. Não se esqueça de mostrar o número de 
-- seções como 0 para os instrutores que não ministraram qualquer seção. 
-- Sua consulta deverá utilizar OUTER JOIN e não deverá utilizar subconsultas escalares.

SELECT 
    i.ID,
    i.name,
    COUNT(t.sec_id) AS 'Number of sections'
FROM 
    instructor i
LEFT OUTER JOIN 
    teaches t ON i.ID = t.ID
GROUP BY 
    i.ID, 
    i.name
ORDER BY 
    i.ID ASC;


-- ========== QUESTÃO 2 ==========
-- Escreva a mesma consulta do item anterior, mas usando uma 
-- subconsulta escalar, sem OUTER JOIN.

SELECT 
    i.ID,
    i.name,
    (
        SELECT COUNT(*)
        FROM teaches t
        WHERE t.ID = i.ID
    ) AS 'Number of sections'
FROM 
    instructor i
ORDER BY 
    i.ID ASC;


-- ========== QUESTÃO 3 ==========
-- Gere a lista de todas as seções de curso oferecidas na primavera de 2010,
-- junto com o nome dos instrutores ministrando a seção. Se uma seção tiver mais de 1 instrutor,
-- ela deverá aparecer uma vez no resultado para cada instrutor. Se não tiver instrutor algum,
-- ela ainda deverá aparecer no resultado, com o nome do instrutor definido como "".

SELECT 
    c.course_id,
    c.sec_id,
    i.ID,
    c.semester,
    c.YEAR,
    COALESCE(i.name, '') AS name
FROM 
    section c
LEFT OUTER JOIN 
    teaches t ON c.course_id = t.course_id AND c.sec_id = t.sec_id AND c.semester = t.semester AND c.YEAR = t.YEAR
LEFT OUTER JOIN 
    instructor i ON t.ID = i.ID
WHERE 
    c.semester = 'Spring' AND c.YEAR = 2010
ORDER BY 
    c.course_id, 
    c.sec_id;


-- ==============================================================================
-- Questão 4
-- Suponha que você tenha recebido uma relação grade_points (grade, points),
-- que oferece uma conversão de conceitos (letras) na relação takes para notas numéricas.
-- Os Pontos totais obtidos por um aluno para uma oferta de curso (section) são definidos como 
-- o número de créditos para o curso multiplicado pelos pontos numéricos para a nota que o aluno recebeu.

-- ==============================================================================
SELECT 
    aluno.ID, 
    aluno.name, 
    curso.title, 
    curso.dept_name, 
    matricula.grade, 
    CAST(CASE 
        WHEN matricula.grade = 'A+' THEN 4.0 
        WHEN matricula.grade = 'A'  THEN 3.7 
        WHEN matricula.grade = 'A-' THEN 3.3 
        WHEN matricula.grade = 'B+' THEN 3.0 
        WHEN matricula.grade = 'B'  THEN 2.7 
        WHEN matricula.grade = 'B-' THEN 2.3 
        WHEN matricula.grade = 'C+' THEN 2.0 
        WHEN matricula.grade = 'C'  THEN 1.7 
        WHEN matricula.grade = 'C-' THEN 1.3 
        WHEN matricula.grade = 'D+' THEN 1.0 
        WHEN matricula.grade = 'D'  THEN 0.7 
        WHEN matricula.grade = 'D-' THEN 0.3 
        WHEN matricula.grade = 'F'  THEN 0.0 
    END AS DECIMAL(4,1)) AS points,
    curso.credits, 
    CAST(curso.credits * CASE 
        WHEN matricula.grade = 'A+' THEN 4.0 
        WHEN matricula.grade = 'A'  THEN 3.7 
        WHEN matricula.grade = 'A-' THEN 3.3 
        WHEN matricula.grade = 'B+' THEN 3.0 
        WHEN matricula.grade = 'B'  THEN 2.7 
        WHEN matricula.grade = 'B-' THEN 2.3 
        WHEN matricula.grade = 'C+' THEN 2.0 
        WHEN matricula.grade = 'C'  THEN 1.7 
        WHEN matricula.grade = 'C-' THEN 1.3 
        WHEN matricula.grade = 'D+' THEN 1.0 
        WHEN matricula.grade = 'D'  THEN 0.7 
        WHEN matricula.grade = 'D-' THEN 0.3 
        WHEN matricula.grade = 'F'  THEN 0.0 
    END AS DECIMAL(4,1)) AS [Pontos totais]
FROM 
    student AS aluno
INNER JOIN 
    takes AS matricula ON aluno.ID = matricula.ID
INNER JOIN 
    course AS curso ON matricula.course_id = curso.course_id
WHERE 
    aluno.dept_name = curso.dept_name
    AND matricula.grade IS NOT NULL
ORDER BY 
    aluno.ID ASC;


-- ==============================================================================
-- Questão 5
-- View do coeficiente de rendimento.
-- ==============================================================================
CREATE VIEW coeficiente_rendimento AS
SELECT 
    aluno.ID, 
    aluno.name, 
    curso.title, 
    curso.dept_name, 
    matricula.grade, 
    CAST(CASE 
        WHEN matricula.grade = 'A+' THEN 4.0 
        WHEN matricula.grade = 'A'  THEN 3.7 
        WHEN matricula.grade = 'A-' THEN 3.3 
        WHEN matricula.grade = 'B+' THEN 3.0 
        WHEN matricula.grade = 'B'  THEN 2.7 
        WHEN matricula.grade = 'B-' THEN 2.3 
        WHEN matricula.grade = 'C+' THEN 2.0 
        WHEN matricula.grade = 'C'  THEN 1.7 
        WHEN matricula.grade = 'C-' THEN 1.3 
        WHEN matricula.grade = 'D+' THEN 1.0 
        WHEN matricula.grade = 'D'  THEN 0.7 
        WHEN matricula.grade = 'D-' THEN 0.3 
        WHEN matricula.grade = 'F'  THEN 0.0 
    END AS DECIMAL(4,1)) AS points,
    curso.credits, 
    CAST(curso.credits * CASE 
        WHEN matricula.grade = 'A+' THEN 4.0 
        WHEN matricula.grade = 'A'  THEN 3.7 
        WHEN matricula.grade = 'A-' THEN 3.3 
        WHEN matricula.grade = 'B+' THEN 3.0 
        WHEN matricula.grade = 'B'  THEN 2.7 
        WHEN matricula.grade = 'B-' THEN 2.3 
        WHEN matricula.grade = 'C+' THEN 2.0 
        WHEN matricula.grade = 'C'  THEN 1.7 
        WHEN matricula.grade = 'C-' THEN 1.3 
        WHEN matricula.grade = 'D+' THEN 1.0 
        WHEN matricula.grade = 'D'  THEN 0.7 
        WHEN matricula.grade = 'D-' THEN 0.3 
        WHEN matricula.grade = 'F'  THEN 0.0 
    END AS DECIMAL(4,1)) AS [Pontos totais]
FROM 
    student AS aluno
INNER JOIN 
    takes AS matricula ON aluno.ID = matricula.ID
INNER JOIN 
    course AS curso ON matricula.course_id = curso.course_id
WHERE 
    aluno.dept_name = curso.dept_name
    AND matricula.grade IS NOT NULL;