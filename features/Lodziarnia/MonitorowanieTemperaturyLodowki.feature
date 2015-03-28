Funkcja: Monitorowanie temperatury lodówki
    Żeby utrzymywać odpowiednią temperaturę lodówek
    Jako pracownik lodziarni
    Muszę mieć możliwość sprawdzenia temperatury lodówki

Założenia:
    Mając termometr Monitora w lodówce

Scenariusz: Sprawdzenie temperatury lodówki
    Zakładając, że Monitor jest włączony
    Oraz, że temperatura w lodówce to "-10" stopni celsjusza
    Kiedy spojrzę na wyświetlacz
    Wtedy wyświetlacz powinien pokazywać "-10 'C"

Scenariusz: Włączenie Monitora
    Zakładając, że Monitor nie jest włączony
    Oraz, że temperatura lodówki to "-10" stopni celsjusza
    Kiedy przełączę włącznik na "1"
    I kiedy spojrzę na wyświetlacz
    Wtedy wyświetlacz powinien pokazywać "-10 'C"

Scenariusz: Wyłączenie Monitora
    Zakładając, że Monitor jest włączony
    Kiedy przełączę włącznik na "0"
    I kiedy spojrzę na wyświetlacz
    Wtedy wyświetlacz powinien być zgaszony
