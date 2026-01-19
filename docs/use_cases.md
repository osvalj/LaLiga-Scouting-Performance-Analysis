# Scouting Use Cases
# Casos de uso de scouting

This document describes the main analytical questions this project is designed to answer.
It connects the SQL outputs with real scouting and performance evaluation needs.

Este documento describe las principales preguntas analíticas que responde el proyecto,
conectando el SQL con necesidades reales de scouting y análisis de rendimiento.

---

## 1. Player Comparison by Position  
**ES: Comparación de jugadores por posición**

**EN**  
Which players perform best within the same position when normalized by minutes played?

**ES**  
¿Qué jugadores rinden mejor dentro de la misma posición, normalizando por minutos jugados?

**Metrics used / Métricas usadas**
- Goals per 90
- xG per 90
- xAG per 90
- Goals per shot on target

**Output tables**
- `mart_player_season_by_position`

---

## 2. Identifying Over- and Under-Performers  
**ES: Detección de sobre- y bajo-rendimiento**

**EN**  
Which players score more or fewer goals than expected given their shot quality?

**ES**  
¿Qué jugadores marcan más o menos goles de lo esperado según la calidad de sus ocasiones?

**Key ratios**
- Goals / xG
- Goals per shot on target

**Why it matters / Por qué importa**
- Separates finishing skill from chance quality
- Highlights potential regression or improvement

---

## 3. Playmaking and Chance Creation  
**ES: Creación de juego y ocasiones**

**EN**  
Which players consistently create high-quality chances for teammates?

**ES**  
¿Qué jugadores generan de forma consistente ocasiones de alta calidad para sus compañeros?

**Metrics**
- xAG
- xAG per 90
- SCA (Shot-Creating Actions)

---

## 4. Team Context and Dependency  
**ES: Contexto y dependencia del equipo**

**EN**  
How much does a team rely on a specific player for its offensive output?

**ES**  
¿Hasta qué punto un equipo depende de un jugador concreto para su producción ofensiva?

**Metrics**
- Player share of team goals
- Team goals per 90

**Output tables**
- `mart_team_season`
- `mart_player_season_enriched`

---

## 5. Recent Form Analysis  
**ES: Análisis de forma reciente**

**EN**  
Which players are currently in good or poor form over their last matches?

**ES**  
¿Qué jugadores atraviesan un buen o mal momento en sus últimos partidos?

**Approach**
- Rolling window (last 5 match dates)
- Per-90 normalization

**Output tables**
- `mart_player_form_last5`

---

## 6. Filtering Noise with Minutes Thresholds  
**ES: Control del ruido con umbrales de minutos**

**EN**  
How do rankings change when applying minimum playing time thresholds?

**ES**  
¿Cómo cambian los rankings al aplicar mínimos de minutos jugados?

**Rationale / Justificación**
- Prevents small-sample bias
- Reflects real scouting constraints

---

## 7. Typical Questions This Project Can Answer  
**ES: Preguntas típicas que responde el proyecto**

**EN**
- Who are the most efficient finishers by position?
- Which wingers combine ball progression with chance creation?
- Which players overperform their xG consistently?
- Who contributes disproportionately to team scoring?

**ES**
- ¿Quiénes son los finalizadores más eficientes por posición?
- ¿Qué extremos combinan progresión con creación?
- ¿Qué jugadores sobre-rinden respecto a su xG?
- ¿Quién aporta una parte desproporcionada de los goles del equipo?

---

## Scope Note / Nota de alcance

**EN**  
This project focuses on analytical patterns and relative insights.
It is not intended as a full recruitment or valuation model.

**ES**  
El proyecto se centra en patrones analíticos e insights relativos.
No pretende ser un modelo completo de fichajes o valoración.

