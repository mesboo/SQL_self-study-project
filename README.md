# Movies Dataset — SQL Analysis

A beginner SQL project built while learning SQL independently.  
The goal was to practice core SQL concepts — filtering, aggregation, and joins — on a real-world dataset.

---

## Dataset

**The Movies Dataset** by Rounak Banik, available on [Kaggle](https://www.kaggle.com/datasets/rounakbanik/the-movies-dataset).

Tables used:
- `movies_metadata.csv` — metadata for ~45,000 films (budget, revenue, ratings, language, release date)
- `ratings_small.csv` — ~100,000 user ratings
- `credits.csv` — cast and crew information

---

## Tools

- **DB Browser for SQLite** — to import the CSV files and run queries

---

## What's in the project

The `movies_analysis.sql` file is divided into three sections:

**1. Exploratory Data Analysis (EDA)**
- Row counts for each table
- Missing values in key columns
- Data type verification
- Language distribution across the dataset

**2. Data Cleaning**
- Removed corrupted rows with NULL titles
- Removed rows with numeric values in the language column

**3. Analysis (10 queries)**
1. Top 10 films by budget
2. Films with average rating above 8 and at least 500 votes
3. Most represented languages (min. 100 films)
4. Top 10 films by revenue
5. Top 10 films by ROI (revenue / budget)
6. Average rating by release year
7. Top 10 films by number of user ratings (JOIN)
8. Official rating vs. user rating comparison (JOIN)
9. Average budget and revenue by decade
10. Top 10 most popular films

---

## Key findings

- ~80% of films have no budget data and ~84% have no revenue data — filtered out in economic analyses
- English-language films make up ~71% of the dataset
- Paranormal Activity and The Blair Witch Project have the highest ROI, both shot with minimal budgets
- Average revenue per film has grown steadily from $6M in the 1960s to $120M in the 2010s
- There is a consistent gap between official ratings and user ratings, especially for classic films

---

## Author

Diego — self-taught SQL learner.
