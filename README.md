# Disney Explorer - Projekt Flutter

Aplikacja mobilna stworzona we Flutterze umożliwiająca przeglądanie i eksplorowanie postaci z uniwersum Disneya przy użyciu zewnętrznego API (https://disneyapi.dev/). Projekt spełnia wymagania akademickie na ocenę 4.0.

## Funkcje aplikacji

*   **Dwa ekrany (List / Details):**
    *   Ekran główny zawierający przewijaną listę wszystkich postaci.
    *   Ekran szczegółów wybranej postaci prezentujący jej nazwę, zdjęcie oraz listy filmów i seriali, w których wystąpiła.
*   **Obsługa zapytań REST:**
    *   Pobieranie listy postaci z endpointu `https://api.disneyapi.dev/character`.
    *   Pobieranie szczegółów konkretnej postaci z endpointu `https://api.disneyapi.dev/character/{id}`.
*   **Dostępność Offline (Lokalna Baza Danych):**
    *   Integracja lokalnej bazy danych NoSQL **Hive CE**.
    *   Podczas pierwszego uruchomienia dane są automatycznie pobierane z API i zapisywane lokalnie.
    *   W przypadku braku internetu aplikacja automatycznie ładuje dane z pamięci podręcznej Hive, informując użytkownika żółtym paskiem stanu w AppBarze o działaniu w trybie offline.
*   **Obsługa stanów ładowania:**
    *   Ekran główny oraz ekran szczegółów wyświetlają kręcący się wskaźnik postępu (`CircularProgressIndicator`) podczas oczekiwania na dane.
*   **Obsługa błędów:**
    *   Czytelny komunikat błędu sieciowego z ikoną braku połączenia oraz intuicyjnym przyciskiem "Spróbuj ponownie" (Retry), który odświeża żądanie.
    *   Bezpieczna obsługa ładowania zdjęć postaci (`errorBuilder` oraz `loadingBuilder` w `Image.network`) zapobiegająca awarii widoku w przypadku błędnych linków z zewnętrznych fandomów.
*   **Czysty i czytelny interfejs:**
    *   Zbudowany na bazie standardowych komponentów Material Design, gotowy do dalszego stylowania w Figmie.

## Jak uruchomić projekt

1.  Upewnij się, że masz zainstalowany system kontroli wersji Git oraz zainicjalizowany Flutter SDK.
2.  Pobierz zależności projektu (z poziomu katalogu głównego):
    ```bash
    flutter pub get
    ```
3.  Uruchom aplikację na podłączonym urządzeniu, emulatorze lub w przeglądarce:
    ```bash
    flutter run
    ```
