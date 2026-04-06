## 4. Zvuky

### Pravidla a koncepce
* **Styl:** Diegetické zvuky s důrazem na syrovost a lo-fi texturu, která doplňuje noir vizuál.
* **Charakter:** Krátké, úderné samply pro akce (výstřel, úder) a dlouhé atmosférické smyčky pro prostředí (vítr, kapání vody).


### Software a Hardware
* **Hardware:** Mobilní telefon (nahrávání v interiéru).
* **Software:** **Audacity** (střih, normalizace, odstranění šumu).
* **Postup:** Sběr autentických ruchů (foley) -> Import do PC -> Úprava délky a výšky tónu (pitch) -> Export do `.wav`


### Zvukové assety (SFX)

| Kategorie | Asset | Zdroj / Tvorba |
| :--- | :--- | :--- |
| **Pohyb** | `metal_walk.wav`, `jump.wav` | Nahrávka chůze po kovovém schodišti, upraveno v Audacity. |
| **Boj** | `shoot.wav`, `smack.wav` | Simulované rány (tlesknutí, úder do polštáře), vrstvení v editoru. |

| **Eventy** | `explosion_distance.wav` | Upravená nahrávka rány dveřmi  |



### Implementace v Godotu
* **AudioStreamPlayer2D:** Pro zvuky vázané na pozici (rány v dálce).
* **AudioStreamPlayer:** Pro globální zvuky a UI (výstřel hráče).

