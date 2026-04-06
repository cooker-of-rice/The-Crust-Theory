

## 1. Základní koncepce

### Úvodní studie (Proveditelnost a zdroje)
Projekt je realizovatelný jako samostatná práce s využitím generativních nástrojů pro urychlení produkce grafických aktiv. 
* **Lidské zdroje:** 1 vývojář (programování, level design, prompt engineering, postprodukce).
* **Časový rámec:** Prototyp s uzavřenou herní smyčkou (Kancelář -> Město -> Boss -> Titulky).
* **Hardware:** Standardní PC, ovládání myší a klávesnicí.

### Hrubý popis a záměr
* **Žánr:** 2D noir akční plošinovka.
* **Perspektiva:** Boční pohled (side-view), interiéry formou řezu budovou (cutaway).
* **Záměr:** Vytvořit krátký lineární zážitek definovaný audiovizuální atmosférou 70. let a.
* **Pointa:** Hráč v roli detektiva Millera postupuje skrze městské lokace k finálnímu střetu s entitou v kanálech. Příběh je podáván skrze textové interakce a environmentální detaily.

### Technologie a architektura
* **Engine:** Godot 4.5.
* **Jazyk:** GDScript (objektově orientovaný přístup).
* **Grafika:** (MS Paint blockout -> AI generace -> Photoshop retuš. 
* **Audio:** AudioStreamPlayer systém pro dynamické SFX a smyčkovaný soundtrack.

### Architektura scény
Hra je rozdělena na nezávislé scény, které jsou propojeny skriptovanými přechody:
1.  **Office.tscn:** Úvodní sekvence, tutoriál pohybu a interakce.
2.  **City.tscn:** Hlavní úroveň s AI nepřáteli a sběrem stop.
3.  **BossRoom.tscn:** Uzavřená aréna s bossem.
4.  **Credits.tscn:** UI scéna se stmívačkou a ukončením aplikace.

### Klíčové mechaniky (Hratelnost)
* **Pohyb:**pohyb s implementací gravitace a wall-jumpu.
* **Combat:** Projektilový systém se zpětným rázem (recoil) u hráče a knockbackem u nepřátel.
* **Interakce:** Area2D detekce objektů (Dveře) s vizuální indikací (šipka).
