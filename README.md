# 🔥 unknown_exhaust – Fahrzeug-Sounds individuell anpassen!

Mit diesem Script könnt ihr die Auspuff-Sounds eurer Autos dauerhaft ändern – einfach per Item-Nutzung! 🎶🚗
- Dauerhafte Anpassung: Der Sound bleibt gespeichert.
- Item-basiertes System: Wechsel per einfachem Item-Use.
- Optional Jobgebunden: Nur bestimmte Berufe können Sounds ändern (wenn gewünscht).

# 📌 Voraussetzungen (Dependencies)
- ESX (getestet mit 1.10.5 und höher)
- oxmysql

# 🛠️ So funktioniert’s
In der Config könnt ihr einfach neue Items mit den zugehörigen Sounds definieren:
- ["itemname"] = "soundname", -- Beispiel
- ["sportexhaust"] = "drafter", -- Beispiel2

# 🚀 Anwendung im Spiel
- 1️⃣ Setzt euch in ein Fahrzeug, das in der owned_vehicles-Datenbank gespeichert ist.
- 2️⃣ Verwendet das entsprechende Item (z. B. ein Sportauspuff-Item).
- 3️⃣ Der neue Sound wird automatisch gespeichert und der alte Auspuff als Item zurückgegeben.
- 4️⃣ Falls ihr zurück zum Standard-Sound wollt, nutzt einfach das "defaultexhaust"-Item.

# ⚠️ Wichtig
- Solltet ihr ein Script zum Kennzeichen ändern haben, müsst ihr nach dem Kennzeichenwechsel folgendes Event ausführen:
- TriggerServerEvent("unknown:platechange", oldplate, newplate)

# Fazit
🎵 Perfekt für Mechaniker-RP oder einfach, um euren Autos eine persönliche Note zu geben! 🚀🔥
