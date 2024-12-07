- Task 1

CREATE DATABASE IF NOT EXISTS pandemic;
USE pandemic;

SELECT *
FROM infectious_cases 
LIMIT 10;

- Task 2

CREATE TABLE entities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    entity_name VARCHAR(255) NOT NULL,
    code VARCHAR(10) NOT NULL UNIQUE
);

INSERT INTO entities (entity_name, code)
SELECT DISTINCT Entity, Code
FROM infectious_cases;

CREATE TABLE IF NOT EXISTS infectious_cases_normalized (
    id INT PRIMARY KEY AUTO_INCREMENT,
    entity_id INT NOT NULL,
    year INT NOT NULL,
    polio_cases INT,
    cases_guinea_worm INT,
    number_yaws VARCHAR(50),
    number_rabies VARCHAR(50),
    number_malaria VARCHAR(50),
    number_hiv VARCHAR(50),
    number_tuberculosis VARCHAR(50),
    number_smallpox VARCHAR(50),
    number_cholera_cases VARCHAR(50),
    FOREIGN KEY(entity_id) REFERENCES entities(id)
);

INSERT INTO infectious_cases_normalized (
    entity_id, year, polio_cases, cases_guinea_worm, number_yaws, 
    number_rabies, number_malaria, number_hiv, number_tuberculosis, 
    number_smallpox, number_cholera_cases
)

SELECT 
    e.id,
    i.Year,
    i.polio_cases,
    i.cases_guinea_worm,
    i.Number_yaws,
    i.Number_rabies,
    i.Number_malaria,
    i.Number_hiv,
    i.Number_tuberculosis,
    i.Number_smallpox,
    i.Number_cholera_cases
FROM 
    infectious_cases i
JOIN 
    entities e 
ON 
    i.Entity = e.entity_name AND i.Code = e.code;

- Task 3

SELECT 
    e.entity_name,
    e.code,
    AVG(CAST(c.number_rabies AS UNSIGNED)) AS avg_rabies,
    MIN(CAST(c.number_rabies AS UNSIGNED)) AS min_rabies,
    MAX(CAST(c.number_rabies AS UNSIGNED)) AS max_rabies,
    SUM(CAST(c.number_rabies AS UNSIGNED)) AS total_rabies
FROM 
    infectious_cases_normalized c
JOIN 
    entities e 
ON 
    c.entity_id = e.id
WHERE 
    c.number_rabies IS NOT NULL AND c.number_rabies != ''
GROUP BY 
    e.entity_name, e.code
ORDER BY 
    avg_rabies DESC
LIMIT 10;

- Task 4

SELECT
    entity_id,
    MAKEDATE(year, 1) AS start_of_year,
    CURDATE() AS current_date_value,
    TIMESTAMPDIFF(YEAR, MAKEDATE(year, 1), CURDATE()) AS years_difference
FROM 
    infectious_cases_normalized;

- Task 5

- Task 1

CREATE DATABASE IF NOT EXISTS pandemic;
USE pandemic;

SELECT *
FROM infectious_cases 
LIMIT 10;

- Task 2

CREATE TABLE entities (
    id INT PRIMARY KEY AUTO_INCREMENT,
    entity_name VARCHAR(255) NOT NULL,
    code VARCHAR(10) NOT NULL UNIQUE
);

INSERT INTO entities (entity_name, code)
SELECT DISTINCT Entity, Code
FROM infectious_cases;

CREATE TABLE IF NOT EXISTS infectious_cases_normalized (
    id INT PRIMARY KEY AUTO_INCREMENT,
    entity_id INT NOT NULL,
    year INT NOT NULL,
    polio_cases INT,
    cases_guinea_worm INT,
    number_yaws VARCHAR(50),
    number_rabies VARCHAR(50),
    number_malaria VARCHAR(50),
    number_hiv VARCHAR(50),
    number_tuberculosis VARCHAR(50),
    number_smallpox VARCHAR(50),
    number_cholera_cases VARCHAR(50),
    FOREIGN KEY(entity_id) REFERENCES entities(id)
);

INSERT INTO infectious_cases_normalized (
    entity_id, year, polio_cases, cases_guinea_worm, number_yaws, 
    number_rabies, number_malaria, number_hiv, number_tuberculosis, 
    number_smallpox, number_cholera_cases
)

SELECT 
    e.id,
    i.Year,
    i.polio_cases,
    i.cases_guinea_worm,
    i.Number_yaws,
    i.Number_rabies,
    i.Number_malaria,
    i.Number_hiv,
    i.Number_tuberculosis,
    i.Number_smallpox,
    i.Number_cholera_cases
FROM 
    infectious_cases i
JOIN 
    entities e 
ON 
    i.Entity = e.entity_name AND i.Code = e.code;

- Task 3

SELECT 
    e.entity_name,
    e.code,
    AVG(CAST(c.number_rabies AS UNSIGNED)) AS avg_rabies,
    MIN(CAST(c.number_rabies AS UNSIGNED)) AS min_rabies,
    MAX(CAST(c.number_rabies AS UNSIGNED)) AS max_rabies,
    SUM(CAST(c.number_rabies AS UNSIGNED)) AS total_rabies
FROM 
    infectious_cases_normalized c
JOIN 
    entities e 
ON 
    c.entity_id = e.id
WHERE 
    c.number_rabies IS NOT NULL AND c.number_rabies != ''
GROUP BY 
    e.entity_name, e.code
ORDER BY 
    avg_rabies DESC
LIMIT 10;

- Task 4

SELECT
    entity_id,
    MAKEDATE(year, 1) AS start_of_year,
    CURDATE() AS current_date_value,
    TIMESTAMPDIFF(YEAR, MAKEDATE(year, 1), CURDATE()) AS years_difference
FROM 
    infectious_cases_normalized;

- Task 5

DELIMITER //

CREATE FUNCTION calculate_years_difference(input_year INT)
RETURNS INT
DETERMINISTIC
NO SQL
BEGIN
    DECLARE years_diff INT;
    SET years_diff = TIMESTAMPDIFF(YEAR, DATE(CONCAT(input_year, '-01-01')), CURDATE());
    RETURN years_diff;
END //

DELIMITER ;

SELECT entity_id, calculate_years_difference(year) AS years_difference
FROM infectious_cases_normalized;
