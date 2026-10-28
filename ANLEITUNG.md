# Herzarchiv – Einrichtung

## Was bereits fertig ist
- Responsive Startseite mit Tannengrün, Salbei und Champagner
- Playlist- und Instagram-Schaltfläche (nach Eintragen der URLs)
- Dritter Bereich „Privater Bereich“ mit Login
- Vier Archivkategorien, neue Erinnerungen mit Text und Datei (max. 10 MB)
- Verstecktes Easter Egg: Herz im Footer fünfmal zügig anklicken
- Private Speicherung mit Supabase, sofern eingerichtet

## 1. Links einsetzen
Öffne `config.js` in einem Texteditor und setze `playlistUrl` und `instagramUrl` auf die vollständigen HTTPS-Links.

## 2. Supabase-Projekt anlegen
1. Auf https://supabase.com ein Projekt anlegen. Ein starkes Datenbankpasswort wählen.
2. Im SQL Editor den Inhalt von `setup.sql` ausführen.
3. Unter **Authentication > Providers** die E-Mail-Anmeldung aktiv lassen; **öffentliche Registrierung deaktivieren**, damit keine Fremden Accounts erstellen können.
4. Unter **Authentication > Users** zwei Benutzerkonten anlegen/einladen (je eines für euch). Für beide ein individuelles starkes Passwort vergeben. Eine sichere Einladungs-/Passwortsetzungsfunktion des Anbieters nutzen, keine Zugangsdaten im Quellcode hinterlegen.
5. Die beiden Benutzer-UUIDs aus Authentication > Users kopieren. Im SQL Editor einzeln ausführen:
   `insert into public.archive_members(user_id) values ('HIER-UUID-EINSETZEN');`
6. Unter **Project Settings / API** (Bezeichnungen können sich ändern) die **Project URL** und den **publishable/anon key** kopieren. In `config.js` als `supabaseUrl` und `supabaseAnonKey` eintragen. **Niemals service_role/secret key** in eine Webseite einfügen.
7. Anmeldung und Upload mit beiden Konten testen. Im Storage-Bereich muss der Bucket `memory-files` privat sein.

## 3. Passwort-Rätsel als physische Karte
Das Rätsel **nicht** auf der Webseite veröffentlichen. Empfehlenswert: Rätsel löst ein separates Einladungskennwort oder einen einmaligen Code aus. Die persönlichen Supabase-Login-Passwörter sollten stark und nicht öffentlich erratbar sein. Die erste Version unterstützt nur individuelle Benutzerkonten; ein automatischer Einmalcode-Einladungsablauf ist **noch nicht implementiert**. Bis dahin kannst du deinem Partner nach dem Rätsel die sichere Einladung/Einrichtung seines Kontos ermöglichen.

## 4. Webseite veröffentlichen
- Ein privates oder öffentliches GitHub-Repository erstellen, Dateien hochladen und eine statische Hosting-Lösung wie Cloudflare Pages oder GitHub Pages nutzen. Achtung: Eine statisch veröffentlichte Website ist öffentlich abrufbar, **private Inhalte bleiben ausschließlich im geschützten Supabase-Speicher**.
- Im Hosting HTTPS aktivieren und die öffentliche URL auf einem Smartphone testen.
- Für eine dauerhafte NFC-Adresse idealerweise eine eigene Domain nutzen. Die Domain regelmäßig verlängern.
- Prüfe nach dem Deployment, ob die E-Mail-Anmeldung und Dateiuploads funktionieren.

## 5. NFC-Objekt
- Holzblock aus Nussbaum, etwa 80 × 50 × 20 mm, mit Gravur „01 / us“ und „connection established.“
- NTAG213 (ca. 25 mm) in eine flache Aussparung **unter einer dünnen Holzabdeckung** einlegen. Kein Metall direkt über dem Tag.
- Vor dem Verkleben die Lesbarkeit mit mehreren Smartphones prüfen.
- Mit NFC Tools einen URL/URI-Datensatz mit der öffentlichen HTTPS-Adresse der Webseite schreiben und testen.
- NFC-Tag nicht dauerhaft schreibschützen, bis alles fertig getestet ist.

## 6. Datensicherung und Sicherheit
- Regelmäßig private Inhalte exportieren und getrennt sichern. Die Datenbank- und Storage-Backups des gewählten Tarifs prüfen; nicht auf automatische Backups verlassen.
- Kein echtes gemeinsames leicht erratbares Passwort verwenden. Passwort-Rätsel und Kontosicherheit trennen.
- Die App zeigt bereits bestehende Erinnerungen und erlaubt neue Uploads; Bearbeiten/Löschen, Einladungsautomatisierung, Videovorschau und automatische Erinnerungen „An diesem Tag“ sind zukünftige Erweiterungen.
- Externe Instagram-Beiträge können verschwinden oder zugriffsbeschränkt sein.

## Lokal ansehen
Für die Vorschau im Projektordner `python -m http.server 8000` ausführen und `http://localhost:8000` öffnen. Für die Anmeldung braucht es eine gültige Supabase-Konfiguration und eine Internetverbindung.
