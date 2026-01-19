# Assumptions & Methodological Notes
# Supuestos y notas metodológicas

This document explains the assumptions made during the analysis
and the known limitations of the dataset.

Este documento explica los supuestos asumidos durante el análisis
y las limitaciones conocidas del dataset.

---

## 1. Dataset Grain  
**ES: Grano del dataset**

**EN**  
Each row represents a player’s performance for a given team on a specific date.

Grain:

**ES**  
Cada fila representa el rendimiento de un jugador para un equipo en una fecha concreta.

Grano:

**Implication / Implicación**
- Player names are expected to repeat across dates.
- This is not duplication; it reflects match-level data.

---

## 2. Match Identification  
**ES: Identificación de partidos**

**EN**  
The dataset does not include a match_id or opponent field.
Dates are assumed to uniquely represent matches for a given player and team.

**ES**  
El dataset no incluye un match_id ni el rival.
Se asume que la fecha identifica de forma única el partido para cada jugador y equipo.

**Limitation / Limitación**
- Multiple matches on the same date for the same team are not distinguishable.
- This scenario is considered low probability and acceptable for this analysis.

---

## 3. Minutes Thresholds  
**ES: Umbrales de minutos**

**EN**  
To reduce small-sample noise, most rankings apply a minimum minutes threshold
(e.g. 900 minutes).

**ES**  
Para reducir el ruido por muestras pequeñas, los rankings aplican un mínimo de minutos
(p. ej. 900 minutos).

**Rationale / Justificación**
- Avoids overrating players with very limited playing time
- Standard practice in scouting and performance analysis

---

## 4. Data Cleaning Strategy  
**ES: Estrategia de limpieza**

**EN**
- SAFE_CAST is used to prevent query failures caused by dirty input data
- Invalid values are converted to NULL instead of stopping execution

**ES**
- Se usa SAFE_CAST para evitar que datos sucios rompan las consultas
- Los valores inválidos se convierten en NULL de forma controlada

---

## 5. Position Handling  
**ES: Tratamiento de posiciones**

**EN**  
Players may appear in multiple positions across the season.
Aggregations are intentionally done by position to reflect role-specific performance.

**ES**  
Los jugadores pueden aparecer en distintas posiciones a lo largo de la temporada.
Las agregaciones se hacen por posición para reflejar el rendimiento por rol.

---

## 6. Team Context  
**ES: Contexto de equipo**

**EN**  
Player performance is influenced by team strength and playing style.
Team-level aggregates are used to contextualize individual metrics.

**ES**  
El rendimiento individual está influido por la fuerza y el estilo del equipo.
Se usan métricas de equipo para contextualizar los datos individuales.

---

## 7. Interpretation Disclaimer  
**ES: Nota de interpretación**

**EN**  
This project focuses on analytical patterns and relative comparisons,
not on definitive player valuation.

**ES**  
Este proyecto se centra en patrones analíticos y comparaciones relativas,
no en la valoración definitiva de jugadores.

---

## 8. Reproducibility  
**ES: Reproducibilidad**

**EN**  
All transformations are implemented in SQL and versioned in this repository.
Results can be fully reproduced from the raw dataset.

**ES**  
Todas las transformaciones están implementadas en SQL y versionadas en el repositorio.
Los resultados son completamente reproducibles desde los datos originales.
