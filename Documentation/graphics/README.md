# The Crust Theory - Grafika
>autoři-Bican, Brož

Tady je info k vizuálu a nástrojům pro hru (The Crust Theory - 2D noir detektivka).

Tady je aktualizovaná sekce pro vizuální styl a technologický postup do tvého README. Držel jsem se čisté struktury bez příkras.

---

## Vizuální styl a art pipeline
Vizuál hry kombinuje low-fidelity skicování s generativním postprocesem pro dosažení high-fidelity pixel artu v noir estetice.

### Vizuální pravidla
* **Perspektiva:** Striktní 2D boční pohled (side-view).
* **Kompozice:** Interiéry jsou řešeny jako řezy budovou (cutaway).
* **Formát:** Pozadí v poměru stran 21:9 pro širokoúhlý filmový dojem.
* **Estetika:** 70. léta, vysoký kontrast.

### Technologický postup (Pipeline)
1. **Blockout (MS Paint):** Hrubé rozvržení kompozice levelů a objektů pomocí základních tvarů.
2. **Generativní AI:** Převod náčrtů na detailní pixel artové podklady na základě definovaných parametrů(agent který jen zpracuje ms paint náčrt).
3. **Postprodukce (Adobe Photoshop):** Retuš artefaktů, úprava barevné hloubky, ořezy a příprava vrstev (atlasů) pro import do engine.



## Hardware a nástroje
* **Vývojové prostředí:** PC (ovládání myší a klávesnicí).
* **Grafický software:** MS Paint (návrh), Adobe Photoshop (finální úprava).
* **Engine:** Godot 4.5.

---

## Aktuální implementace vizuálu
* Animované sprity pro hráče a nepřátele (Idle, Attack, Death).
* Implementovaný systém vrstev pro paralaxní pozadí a popředí.
* UI prvky (dialogová okna, titulky) vázané na CanvasLayer pro zachování čitelnosti.

Máme v README upravit ještě seznam konkrétních herních mechanik, nebo je tato technická část takto finální?
