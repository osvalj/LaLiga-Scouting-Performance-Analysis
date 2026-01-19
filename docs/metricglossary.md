# Metric Glossary / Glosario de Métricas

This document defines the main football analytics metrics used in this project.
It is intentionally bilingual (EN/ES) to be accessible to both technical and non-technical reviewers.

Este documento define las principales métricas de analítica futbolística usadas en el proyecto.
Es bilingüe a propósito para que sea entendible tanto por perfiles técnicos como no técnicos.

---

## xG — Expected Goals  
**ES: Goles esperados**

**EN**  
xG estimates the probability that a shot will result in a goal based on historical data
(distance, angle, body part, situation, defensive pressure, etc.).

**ES**  
xG estima la probabilidad de que un disparo termine en gol en función de datos históricos
(distancia, ángulo, parte del cuerpo, contexto de la jugada, presión defensiva, etc.).

**Interpretation / Interpretación**
- Goals > xG → overperformance (good finishing or variance)
- Goals < xG → underperformance (poor finishing or bad luck)

---

## xAG — Expected Assisted Goals  
**ES: Goles esperados asistidos**

**EN**  
xAG measures the quality of chances a player creates for teammates.
It sums the xG of shots that directly come from a player’s passes.

**ES**  
xAG mide la calidad de las ocasiones que un jugador genera para otros.
Es la suma del xG de los tiros que provienen directamente de sus pases.

**Why it matters / Por qué importa**
- Isolates chance creation from teammate finishing
- Useful to evaluate playmakers independently of assists

---

## Goals per 90 / Goles por 90

**EN**  
Normalizes goals scored to 90 minutes to make players with different playing time comparable.

**ES**  
Normaliza los goles a 90 minutos para poder comparar jugadores con distinto tiempo de juego.

---

## Shots on Target / Tiros a puerta

**EN**  
Shots that would result in a goal if not stopped by the goalkeeper or a defender.

**ES**  
Disparos que van entre los tres palos y obligan a intervención del portero o defensa.

---

## Shooting Efficiency  
**ES: Efectividad de cara a puerta**

**Definition used in this project / Definición usada en el proyecto**

**EN**  
Measures how often a shot on target becomes a goal.

**ES**  
Mide cuántos tiros a puerta terminan en gol.

> Note: The inverse ratio (shots per goal) answers a different question and is not used here.

---

## Carries  
**ES: Conducciones**

**EN**  
A carry occurs when a player moves the ball forward under control for a meaningful distance.

**ES**  
Una conducción ocurre cuando un jugador progresa con el balón controlado una distancia relevante.

**Context / Contexto**
- Not a pass
- Not a dribble
- Key metric for ball progression

---

## Progressive Carries  
**ES: Conducciones progresivas**

**EN**  
Carries that significantly advance the ball towards the opponent’s goal.

**ES**  
Conducciones que avanzan el balón de forma significativa hacia la portería rival.

---

## SCA — Shot-Creating Actions  
**ES: Acciones creadoras de tiro**

**EN**  
The two offensive actions immediately preceding a shot
(passes, dribbles, fouls drawn, etc.).

**ES**  
Las dos acciones ofensivas inmediatamente anteriores a un disparo
(pases, regates, faltas recibidas, etc.).

---

## GCA — Goal-Creating Actions  
**ES: Acciones creadoras de gol**

**EN**  
The two offensive actions immediately preceding a goal.

**ES**  
Las dos acciones ofensivas inmediatamente anteriores a un gol.

---

## Per 90 Metrics  
**ES: Métricas por 90 minutos**

**EN**  
All rate metrics are normalized per 90 minutes to ensure fair comparison.

**ES**  
Todas las métricas de ratio se normalizan a 90 minutos para asegurar comparaciones justas.

---

## Composite Metrics  
**ES: Métricas compuestas**

**Examples used in this project / Ejemplos usados en el proyecto**
- xG + xAG → Total offensive threat
- Goals / xG → Finishing efficiency
- Goals per 90 + xAG per 90 → Attacking impact

**EN**  
Composite metrics are used to capture multi-dimensional player profiles.

**ES**  
Las métricas compuestas permiten evaluar perfiles de jugador más completos.


