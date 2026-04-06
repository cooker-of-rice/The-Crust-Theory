**Název projektu:** *The Crust Theory*
**Autor:** Karel M. Bican a Martin Brož
**Předmět:** Počítačové hry <br>
**Umístění kapitol:** /Documentation/chapters


## Popis projektu
The Crust Theory je 2D noir plošinovka. Hráč ovládá detektiva v lineárním prostředí města. Hra se zaměřuje na jednoduchý souboj, interakci s předměty a atmosférické vyprávění skrze dialogová okna.

---

## Cíl projektu
Vytvořit funkční prototyp obsahující:
* **Základní pohyb:** Chůze, skok, dash a wall-jump.
* **Soubojový systém:** Střelba z pistole se zpětným rázem, systém poškození a knockback nepřátel.
* **Interakce:** Detekce blízkosti objektů, dialogový systém.
* **Nepřátelé:** Základní AI kultisty (detekce hráče, útok na blízko) a skriptovaný souboj s bossem.

---

## Technické specifikace
* **Engine:** Godot 4.5
* **Jazyk:** GDScript
* **Grafika:** Pixel art, 2D sprity, práce se základním osvětlením a CanvasLayers pro UI.
* **Struktura:** Rozdělení na scény (kancelář, ulice, boss room) s přechody mezi nimi.

---

## Současný stav implementace
* Funkční hráč s fyzikou a combat handlem.
* Nepřátelé s animovanými stavy (Idle, Attack, Take Damage).
* Boss s logikou střídání útoků (Rush, Smash) a sekvencí ukončení hry.
* UI pro dialogy a černé stmívání obrazovky před titulky.
