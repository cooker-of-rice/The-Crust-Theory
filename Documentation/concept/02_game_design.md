### **Herní styl**

2D **metroidvania s detektivní tematikou**.
Hráč objevuje město, sbírá indicie, odemyká nové cesty a rozhoduje o dalším postupu.
Namísto klasického „levelování“ postava získává přístup k novým oblastem díky **informacím** a **klíčovým předmětům**, ne biologickým změnám.

Základní herní smyčka:

> prozkoumej → zjisti informaci → odemkni novou oblast → čel rozhodnutí

---

### **Mechaniky**

* **Pohyb:** běh, skok, pád, wall-slide (později wall-jump)
* **Souboj:** jednoduchý melee útok, možnost úhybu
* **Interakce:** terminály, páky, zamčené dveře, environmentální hádanky
* **Rozhodování:** určité akce ovlivňují závěr (např. komu důvěřuješ)

---

### **Struktura dat**

| Objekt  | Atributy                          | Popis                                  |
| ------- | --------------------------------- | -------------------------------------- |
| Player  | health, stamina, speed, knowledge | fyzický a informační stav hráče        |
| Enemy   | health, pattern, alert            | základní chování nepřátel              |
| Item    | id, type, effect                  | klíčové předměty a informace           |
| Zone    | id, exits[], access_condition     | části města a jejich propojení         |
| Trigger | event_id, type, position          | aktivátory dialogů nebo změn prostředí |

---

### **Technická architektura**

| Komponenta                   | Popis                                           |
| ---------------------------- | ----------------------------------------------- |
| **Game (Node2D)**            | hlavní scéna, správa úrovní a přechodů          |
| **Player (CharacterBody2D)** | logika pohybu, kolize, animace                  |
| **World (TileMap)**          | prostředí a kolizní vrstvy                      |
| **Enemies / Items / UI**     | oddělené nody pro přehlednost                   |
| **Scripts (.gd)**            | dělené podle funkcí (pohyb, boj, interakce, UI) |

---

### **Estetika**

* **Paleta:** tlumené barvy, černá, šedá, teplé zdroje světla (oranžová, červená),
* **Styl:** městský rozklad, prázdné ulice, dešťové efekty, industriální ruiny,
* **Zvuk:** minimalistický ambient, syntetické hučení, vzdálené kroky,
* **Hudba:** spíš atmosférická než melodická, někde mezi jazzem a mechanickým šumem.

