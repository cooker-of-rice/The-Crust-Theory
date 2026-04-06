## 5. Hudba


### Software a Hardware
* **Generativní AI (Gemini):** Vytvoření základních hudebních motivů a smyček na základě textových zadání .
* **Hardware:** Standardní PC, výstup testován na sluchátkách pro kontrolu hloubky basů.



### Hudební assety

| Skladba | Účel |
| :--- | :--- 
| `city_brawl.mp3` | Bitva ve městě. |
| `boss_battle.mp3` | Souboj s bossem  a titulky|


### Implementace v Godotu
* **Looping:** Všechny hudební assety jsou importovány s příznakem **Loop**, aby byla zajištěna kontinuita během hraní.
* **Stream Management:**
    * `BossMusic`: Spouštěna skriptem při vstupu do arény nebo inicializaci bosse.
    * Hudba zůstává aktivní i během pětivteřinové stmívačky (`fade-out`) po smrti bosse pro zachování gradace.
* **Fading:** Přechody mezi tichem a hudbou jsou řešeny přes `Tween` u vlastnosti `volume_db`, aby zvuk nenastupoval skokově.
