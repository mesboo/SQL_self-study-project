-- ============================================
-- MOVIES DATASET - ANALISI SQL
-- Dataset: The Movies Dataset (Kaggle)
-- Tabelle: movies, credits, ratings
-- ============================================


-- ============================================
-- SEZIONE 1: EDA (Exploratory Data Analysis)
-- ============================================

-- Conteggio delle righe nelle tre tabelle
SELECT COUNT(*) from movies;
SELECT COUNT(*) from credits;
SELECT COUNT(*) from ratings;

-- Conteggio dei valori non vuoti nelle colonne chiave di movies
-- Confrontare con il totale per identificare valori mancanti
SELECT COUNT(NULLIF(title,"")), 
	COUNT(NULLIF(budget,"")),
	COUNT(NULLIF(revenue,"")),
	COUNT(NULLIF(vote_average,"")),
	COUNT(NULLIF(release_date,""))
FROM movies;

-- Quanti film hanno budget = 0 (dati mancanti)
SELECT COUNT(*)
FROM movies
WHERE budget = 0;

-- Quanti film hanno revenue = 0
SELECT COUNT(*)
FROM movies
WHERE revenue = 0;

-- Verifica del tipo di dato delle colonne principali
SELECT 
	typeof(budget),
	typeof(revenue),
	typeof(vote_average),
	typeof(release_date)
FROM movies LIMIT 1;

-- Distribuzione dei film per lingua originale, ordinata per frequenza
SELECT original_language, COUNT(*) AS conteggio
FROM movies
GROUP BY original_language
ORDER BY conteggio DESC;


-- ============================================
-- SEZIONE 2: PULIZIA DEI DATI
-- ============================================

-- Eliminazione delle righe con title NULL (righe corrotte)
DELETE FROM movies
WHERE title ISNULL;

-- Eliminazione delle righe con valori numerici in original_language (righe corrotte)
DELETE FROM movies
WHERE original_language IN ('82.0', '68.0', '104.0');

-- Verifica: le righe corrotte sono state eliminate correttamente
SELECT * FROM movies
WHERE original_language IN ('82.0', '68.0', '104.0');


-- ============================================
-- SEZIONE 3: ANALISI
-- ============================================

-- [1] Top 10 film per budget più alto
SELECT title, budget
FROM movies
ORDER BY budget DESC
LIMIT 10;

-- [2] Film con voto medio superiore a 8 e almeno 500 voti
-- Il filtro su vote_count esclude film con poche valutazioni che potrebbero avere voti gonfiati
SELECT title, vote_average, vote_count
FROM movies
WHERE vote_average > 8 AND vote_count >= 500
ORDER BY vote_average DESC;

-- [3] Lingue originali con almeno 100 film, ordinate per frequenza
SELECT original_language, COUNT(*) AS conteggio
FROM movies
GROUP BY original_language
HAVING COUNT(*) >= 100
ORDER BY COUNT(*) DESC;

-- [4] Top 10 film per revenue più alta
SELECT title, revenue
FROM movies
ORDER BY revenue DESC
LIMIT 10;

-- [5] Top 10 film per ROI (rapporto revenue / budget)
-- Filtro budget > 10000 per escludere film con dati di budget non attendibili
SELECT title, revenue, budget, revenue/budget AS ROI
FROM movies
WHERE budget > 10000
ORDER BY revenue/budget DESC
LIMIT 10;

-- [6] Voto medio per anno di uscita
-- Inclusi solo gli anni con almeno 50 film per avere un campione significativo
SELECT strftime('%Y', release_date) AS anno, round(avg(vote_average),2) AS voto_medio, count(title) AS numero_film
FROM movies
GROUP BY strftime('%Y', release_date)
HAVING count(title) > 50;

-- [7] Top 10 film per numero di valutazioni utenti (JOIN movies + ratings)
-- Inclusi solo i film con almeno 50 valutazioni utenti
SELECT m.title, count(*) AS numero_voti, round(avg(r.rating),2) AS voto_medio_utenti
FROM movies m
INNER JOIN ratings r ON m.id = r.movieId
GROUP BY m.title
HAVING count(*) >= 50
ORDER BY count(*) DESC
LIMIT 10;

-- [8] Confronto tra voto ufficiale e voto medio utenti
-- Il delta positivo indica film più apprezzati dalla critica che dagli utenti, e viceversa
SELECT m.title, round(m.vote_average,2) AS voto_ufficiale, round(avg(r.rating),2) AS voto_medio_utenti,  (round(m.vote_average,2) - round(avg(r.rating),2)) AS delta
FROM movies m
INNER JOIN ratings r ON m.id = r.movieId
WHERE m.vote_average > 0
GROUP BY m.title
HAVING count(*) > 50
ORDER BY delta DESC;

-- [9] Budget medio e revenue media per decennio
-- Filtro su budget > 0 e revenue > 0 per escludere i film senza dati economici
SELECT (CAST(STRFTIME('%Y', release_date) AS INTEGER) / 10) * 10 AS decennio, round(avg(budget),2) AS budget_medio , round(avg(revenue),2) AS revenue_medie
FROM movies
WHERE budget > 0 AND revenue > 0
GROUP BY (CAST(STRFTIME('%Y', release_date) AS INTEGER) / 10) * 10
ORDER BY (CAST(STRFTIME('%Y', release_date) AS INTEGER) / 10) * 10 ASC;

-- [10] Top 10 film per popolarità
-- Filtro su vote_count > 100 per escludere film con poche valutazioni
SELECT title, popularity, vote_average, release_date
FROM movies
WHERE vote_count > 100
ORDER BY popularity DESC
LIMIT 10
