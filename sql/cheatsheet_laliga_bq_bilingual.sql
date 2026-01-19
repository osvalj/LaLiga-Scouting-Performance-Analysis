/* ============================================================================
   Project: LaLiga Scouting & Performance Analysis
   Author: Osval
   Engine: BigQuery (GoogleSQL)

   ES - Propósito:
   Este archivo es mi "cheat sheet" de SQL para un proyecto real de scouting:
   limpieza defensiva, agregaciones, joins, subqueries/CTEs, ventanas y checks de calidad.
   Está escrito para ser legible en entrevistas y reutilizable en proyectos futuros.

   EN - Purpose:
   This file is my SQL cheat sheet for a real scouting project:
   defensive cleaning, aggregations, joins, subqueries/CTEs, window functions and QA checks.
   It is intentionally verbose for interview readability and reuse.

   ES - Contexto del dataset:
   Una fila representa el rendimiento de un jugador en una fecha concreta (match date).
   Es normal que un jugador aparezca repetido en distintas fechas. Eso NO es duplicación.

   EN - Dataset context:
   One row represents a player's performance on a given match date.
   Player names repeat across dates by design; this is NOT duplication.
   ============================================================================ */

-- ---------------------------------------------------------------------------
-- 0) EDIT THESE IDENTIFIERS (only once)
-- ES: Ajusta estos identificadores a tu proyecto/dataset/tabla.
-- EN: Update these identifiers for your project/dataset/table.
-- ---------------------------------------------------------------------------

-- Source table (raw)
-- ES: Tabla original cargada desde CSV/JSON.
-- EN: Raw table loaded from CSV/JSON.
-- Example:
-- `proyecto-laliga-24-25.Laliga_24_25.LaLiga_24_25`
-- Replace below in the script consistently if your names differ.

-- ---------------------------------------------------------------------------
-- 1) QUICK PROFILING (df.info() equivalent)
-- ES: Antes de transformar, valido tamaño, esquema y ejemplos.
-- EN: Before transforming, I validate size, schema and sample rows.
-- Why / Por qué:
-- ES: Evita errores silenciosos (tipos incorrectos, columnas inesperadas).
-- EN: Prevents silent issues (wrong types, unexpected columns).
-- ---------------------------------------------------------------------------

-- 1.1 Row count / Conteo de filas
SELECT COUNT(*) AS total_rows
FROM `proyecto-laliga-24-25.Laliga_24_25.LaLiga_24_25`;

-- 1.2 Table schema (names + types) / Esquema (nombres + tipos)
SELECT column_name, data_type, is_nullable
FROM `proyecto-laliga-24-25.Laliga_24_25.INFORMATION_SCHEMA.COLUMNS`
WHERE table_name = 'LaLiga_24_25'
ORDER BY ordinal_position;

-- 1.3 Sample rows / Muestra de filas
SELECT *
FROM `proyecto-laliga-24-25.Laliga_24_25.LaLiga_24_25`
LIMIT 20;

-- ---------------------------------------------------------------------------
-- 2) STAGING TABLE (clean + typed)
-- ES: Creo una tabla staging tipada y estable para análisis.
-- EN: I create a typed, stable staging table for analysis.
-- Why / Por qué:
-- ES: Separar "raw" de "curated" hace el pipeline reproducible y auditable.
-- EN: Separating raw from curated makes the pipeline reproducible and auditable.
-- ES: Uso SAFE_CAST para que un dato sucio no rompa toda la query.
-- EN: SAFE_CAST prevents dirty values from breaking the entire query.
-- ES: TRIM evita bugs en filtros/joins por espacios invisibles.
-- EN: TRIM avoids join/filter bugs caused by invisible whitespace.
-- ---------------------------------------------------------------------------

CREATE OR REPLACE TABLE `proyecto-laliga-24-25.Laliga_24_25.stg_player_match` AS
SELECT
  SAFE_CAST(`Date` AS DATE) AS match_date,
  TRIM(CAST(`Player` AS STRING)) AS player_name,
  TRIM(CAST(`Team` AS STRING)) AS team,
  TRIM(CAST(`Nation` AS STRING)) AS nation,
  TRIM(CAST(`Position` AS STRING)) AS position,

  SAFE_CAST(`Minutes` AS INT64) AS minutes,
  SAFE_CAST(`Goals` AS INT64) AS goals,
  SAFE_CAST(`Assists` AS INT64) AS assists,

  SAFE_CAST(`Total Shoot` AS INT64) AS shots_total,
  SAFE_CAST(`Shoot on Target` AS INT64) AS shots_on_target,

  SAFE_CAST(`Expected Goals _xG_` AS FLOAT64) AS xg,
  SAFE_CAST(`Expected Assists _xAG_` AS FLOAT64) AS xag,

  -- ES: Clave del grano real (jugador-equipo-fecha). Sirve para QA y dedupe.
  -- EN: Dataset grain key (player-team-date). Useful for QA and deduping.
  TO_HEX(MD5(CONCAT(
    CAST(SAFE_CAST(`Date` AS DATE) AS STRING), '|',
    TRIM(CAST(`Team` AS STRING)), '|',
    TRIM(CAST(`Player` AS STRING))
  ))) AS player_team_date_key

FROM `proyecto-laliga-24-25.Laliga_24_25.LaLiga_24_25`
WHERE `Player` IS NOT NULL
  AND `Team` IS NOT NULL
  AND `Date` IS NOT NULL;

-- ---------------------------------------------------------------------------
-- 3) DATA QUALITY CHECKS (nulls, casting, duplicates)
-- ES: Chequeos rápidos para asegurar coherencia antes de modelar.
-- EN: Quick checks to validate consistency before modeling.
-- Why / Por qué:
-- ES: Con datos reales, la calidad no se asume; se mide.
-- EN: With real-world data, quality is not assumed; it's measured.
-- ---------------------------------------------------------------------------

-- 3.1 Null counts on critical fields / Nulos en campos críticos
SELECT
  COUNT(*) AS rows_total,
  COUNTIF(match_date IS NULL) AS null_match_date,
  COUNTIF(player_name IS NULL OR player_name = '') AS null_player_name,
  COUNTIF(team IS NULL OR team = '') AS null_team,
  COUNTIF(position IS NULL OR position = '') AS null_position
FROM `proyecto-laliga-24-25.Laliga_24_25.stg_player_match`;

-- 3.2 Duplicates by grain key / Duplicados por clave de grano
-- ES: Un "duplicado real" es repetir la misma clave player-team-date.
-- EN: A "true duplicate" repeats the same player-team-date key.
SELECT
  player_team_date_key,
  COUNT(*) AS cnt
FROM `proyecto-laliga-24-25.Laliga_24_25.stg_player_match`
GROUP BY 1
HAVING COUNT(*) > 1
ORDER BY cnt DESC;

-- 3.3 Casting failure example / Ejemplo de fallos de casteo
-- ES: Si raw tiene valor pero SAFE_CAST devuelve NULL, hay dato sucio.
-- EN: If raw has a value but SAFE_CAST returns NULL, it's dirty data.
SELECT
  COUNTIF(`Expected Goals _xG_` IS NOT NULL) AS raw_xg_not_null,
  COUNTIF(SAFE_CAST(`Expected Goals _xG_` AS FLOAT64) IS NULL AND `Expected Goals _xG_` IS NOT NULL) AS xg_cast_failed
FROM `proyecto-laliga-24-25.Laliga_24_25.LaLiga_24_25`;

-- ---------------------------------------------------------------------------
-- 4) CORE MART: PLAYER SEASON BY POSITION
-- ES: Agrego por jugador + equipo + posición para scouting real.
-- EN: Aggregate by player + team + position for realistic scouting.
-- Why / Por qué:
-- ES: Un jugador puede rendir distinto según rol/posición. Por eso no lo "aplasto".
-- EN: Players can perform differently by role/position; I avoid flattening too early.
-- ES: Normalizo métricas por 90 para comparar jugadores con minutos distintos.
-- EN: Per-90 normalization makes players comparable across different minutes.
-- ---------------------------------------------------------------------------

CREATE OR REPLACE TABLE `proyecto-laliga-24-25.Laliga_24_25.mart_player_season_by_position` AS
SELECT
  player_name,
  team,
  nation,
  position,

  COUNT(*) AS appearances_rows,
  COUNTIF(minutes > 0) AS matches_played,
  SUM(minutes) AS minutes,

  SUM(goals) AS goals,
  SUM(assists) AS assists,
  SUM(xg) AS xg,
  SUM(xag) AS xag,
  SUM(shots_total) AS shots_total,
  SUM(shots_on_target) AS shots_on_target,

  -- ES: Métricas per90 (robustas contra división por cero)
  -- EN: Per-90 metrics (safe against divide-by-zero)
  ROUND(SUM(goals) * 90.0 / NULLIF(SUM(minutes), 0), 3) AS goals_per90,
  ROUND(SUM(assists) * 90.0 / NULLIF(SUM(minutes), 0), 3) AS assists_per90,
  ROUND(SUM(xg) * 90.0 / NULLIF(SUM(minutes), 0), 3) AS xg_per90,
  ROUND(SUM(xag) * 90.0 / NULLIF(SUM(minutes), 0), 3) AS xag_per90,

  -- ES: Efectividad: goles por tiro a puerta (no al revés)
  -- EN: Efficiency: goals per shot on target (not the other way around)
  ROUND(SAFE_DIVIDE(SUM(goals), NULLIF(SUM(shots_on_target), 0)), 3) AS goals_per_shot_on_target

FROM `proyecto-laliga-24-25.Laliga_24_25.stg_player_match`
GROUP BY player_name, team, nation, position;

-- ---------------------------------------------------------------------------
-- 5) JOIN EXAMPLE: TEAM CONTEXT (team-level aggregates)
-- ES: Creo contexto de equipo y lo uno para scouting contextual (no solo individuo).
-- EN: Build team context and join it for contextual scouting (not only individual).
-- Why / Por qué:
-- ES: Un jugador en un equipo dominante genera stats distintos a uno en equipo débil.
-- EN: Team style/strength influences player stats; context helps interpretation.
-- ---------------------------------------------------------------------------

CREATE OR REPLACE TABLE `proyecto-laliga-24-25.Laliga_24_25.mart_team_season` AS
SELECT
  team,
  SUM(minutes) AS team_minutes,
  SUM(goals) AS team_goals,
  SUM(xg) AS team_xg,
  ROUND(SUM(goals) * 90.0 / NULLIF(SUM(minutes), 0), 3) AS team_goals_per90
FROM `proyecto-laliga-24-25.Laliga_24_25.stg_player_match`
GROUP BY team;

-- Join player season with team context / Join del mart de jugador con contexto de equipo
CREATE OR REPLACE TABLE `proyecto-laliga-24-25.Laliga_24_25.mart_player_season_enriched` AS
SELECT
  p.*,
  t.team_goals_per90,
  ROUND(SAFE_DIVIDE(p.goals, NULLIF(t.team_goals, 0)), 4) AS share_of_team_goals
FROM `proyecto-laliga-24-25.Laliga_24_25.mart_player_season_by_position` p
LEFT JOIN `proyecto-laliga-24-25.Laliga_24_25.mart_team_season` t
USING (team);

-- ---------------------------------------------------------------------------
-- 6) SUBQUERY/CTE EXAMPLE: TOP PLAYERS BY POSITION WITH MINUTES THRESHOLD
-- ES: Ranking por posición aplicando mínimos de minutos (evita ruido).
-- EN: Position ranking with minutes threshold (reduces small-sample noise).
-- Why / Por qué:
-- ES: Sin mínimo de minutos, un jugador con 90' puede salir top por varianza.
-- EN: Without a minutes threshold, a 90' player can rank top due to variance.
-- ---------------------------------------------------------------------------

WITH eligible AS (
  SELECT *
  FROM `proyecto-laliga-24-25.Laliga_24_25.mart_player_season_enriched`
  WHERE minutes >= 900
),
ranked AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY position
      ORDER BY (xg_per90 + xag_per90) DESC
    ) AS rn
  FROM eligible
)
SELECT
  position,
  rn,
  player_name,
  team,
  minutes,
  xg_per90,
  xag_per90,
  ROUND(xg_per90 + xag_per90, 3) AS threat_per90
FROM ranked
WHERE rn <= 10
ORDER BY position, rn;

-- ---------------------------------------------------------------------------
-- 7) WINDOW FUNCTION EXAMPLE: FORM (last 5 matches/dates)
-- ES: "Forma" reciente por jugador-equipo usando ventanas.
-- EN: Recent "form" by player-team using window functions.
-- Why / Por qué:
-- ES: El scouting no es solo temporada completa; forma reciente importa.
-- EN: Scouting is not only season totals; recent form matters.
-- ---------------------------------------------------------------------------

CREATE OR REPLACE TABLE `proyecto-laliga-24-25.Laliga_24_25.mart_player_form_last5` AS
WITH base AS (
  SELECT
    player_name,
    team,
    match_date,
    minutes,
    goals,
    xg,
    SUM(goals) OVER (PARTITION BY player_name, team ORDER BY match_date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS goals_last5,
    SUM(xg) OVER (PARTITION BY player_name, team ORDER BY match_date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS xg_last5,
    SUM(minutes) OVER (PARTITION BY player_name, team ORDER BY match_date ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS minutes_last5
  FROM `proyecto-laliga-24-25.Laliga_24_25.stg_player_match`
)
SELECT
  player_name,
  team,
  match_date,
  goals_last5,
  xg_last5,
  minutes_last5,
  ROUND(goals_last5 * 90.0 / NULLIF(minutes_last5,0), 3) AS goals_per90_last5,
  ROUND(xg_last5 * 90.0 / NULLIF(minutes_last5,0), 3) AS xg_per90_last5
FROM base;
