## 2. Game Design

### Atributy entit
| Jednotka | HP | Rychlost | Poškození | Vlastnosti |
| :--- | :--- | :--- | :--- | :--- |
| **Hráč** | 5 | 200 | 1 | Wall-jump, Recoil |
| **Kultista** | 3 | 80 | 1 | Knockback, Stun |
| **Boss** | 15 | 50 | 1  2 | Charge, Slam|

### Mechaniky a prostředí
* **Gravitace:** 980 px/s².
* **Combat:** Projektily (hráč) vs. Melee (nepřátelé).
* **Knockback:** Síla 450 (horizontálně) a -150 (vertikálně).
* **Interakce:** Detekce Area2D, vizuální indikace šipkou.

### AI Logika
* **Kultista:** Chase (vzdálenost < 350) -> Attack (vzdálenost < 120) ->  Stun (při zásahu).
* **Boss:** Sekvenční smyčka. Střídá Charge (nemůže použít charge 2x za sebou) a Smash pro nepředvídatelnost. Pauza mezi útoky 2.5s.

### Scénář a UI
* **Dialogy:** Autowrap text, spouštěno signály (smrt nepřátel, časovače).
* **Konec:** Boss HP 0 -> 5s Fade-out (černá) ->  Titulky.

### Datová struktura (Dialogy)
1. **Intro:** "Tohle město pomalu chcípá." (Start + 1s).
2. **Event:** "Šlo to z venku. Musím to jít prověřit." (Po ráně).
3. **Outro:** "Ta rána... přišlo to z kanálu." (Všichni mrtví).