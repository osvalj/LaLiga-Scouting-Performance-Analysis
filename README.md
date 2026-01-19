# LaLiga Scouting & Performance Analysis (BigQuery SQL)

## Overview / Visión general

**EN**  
This project analyzes LaLiga player performance using BigQuery SQL, with a scouting-oriented approach.
The focus is on building a clean analytical layer from raw data and deriving interpretable performance metrics
for players, teams and positions.

**ES**  
Este proyecto analiza el rendimiento de jugadores de LaLiga usando BigQuery SQL, con un enfoque de scouting.
El objetivo es construir una capa analítica limpia a partir de datos raw y derivar métricas interpretables
para jugadores, equipos y posiciones.

---

## Project Goals / Objetivos del proyecto

**EN**
- Practice real-world SQL data cleaning and modeling
- Build player and team performance tables suitable for scouting
- Demonstrate analytical decision-making, not just SQL syntax
- Produce a portfolio-ready, reproducible analytics project

**ES**
- Practicar limpieza y modelado de datos reales en SQL
- Construir tablas de rendimiento para scouting
- Demostrar criterio analítico, no solo sintaxis SQL
- Crear un proyecto reproducible y enseñable en portfolio

---

## Dataset Summary / Resumen del dataset

**EN**
- Competition: LaLiga (Spain)
- Level: player-match (by date)
- Key fields: player, team, position, minutes, goals, xG, xAG, shots

**ES**
- Competición: LaLiga (España)
- Nivel: jugador-partido (por fecha)
- Campos clave: jugador, equipo, posición, minutos, goles, xG, xAG, tiros

> See `docs/assumptions.md` for detailed methodological notes.

---

## Data Pipeline / Flujo de datos

**EN**  
The pipeline separates raw ingestion from curated analytical tables.
Each layer has a clear responsibility.

**ES**  
El pipeline separa la ingesta raw de las tablas analíticas finales.
Cada capa tiene una responsabilidad clara.

---

## Repository Structure / Estructura del repositorio

---

## Key Design Decisions / Decisiones clave

**EN**
- Defensive SQL (`SAFE_CAST`, `NULLIF`, `SAFE_DIVIDE`)
- Explicit dataset grain (player + team + date)
- Aggregations by position to reflect role-based performance
- Minimum minutes thresholds to reduce small-sample noise

**ES**
- SQL defensivo (`SAFE_CAST`, `NULLIF`, `SAFE_DIVIDE`)
- Grano del dataset explícito (jugador + equipo + fecha)
- Agregaciones por posición para reflejar el rol
- Umbrales mínimos de minutos para reducir ruido

---

## Technologies Used / Tecnologías

- BigQuery (GoogleSQL)
- Git & GitHub
- Markdown for documentation

---

## Disclaimer / Nota final

**EN**  
This project is designed for analytical practice and relative comparison.
It does not aim to provide definitive player valuations.

**ES**  
Este proyecto está orientado a práctica analítica y comparaciones relativas.
No pretende ofrecer valoraciones definitivas de jugadores.


