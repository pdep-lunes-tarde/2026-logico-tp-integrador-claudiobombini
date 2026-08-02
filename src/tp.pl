

persona(denken, humano, 1290, auberst).
persona(voll, enano, 1200, ende).
persona(serie, elfa, 500, weise).
persona(fern, humana, 1370, weise).
persona(stark, humano, 1368, riegel).
persona(lawine, humana, 1372, auberst).
persona(kanne, humana, 1365, weise).
persona(wirbel, humano, 1350, klares).
persona(lernen, humano, 1315, auberst).
persona(frieren, elfa, 100, weise).
persona(eisen, enano, 1150, riegel).

promedioVida(humano, 80).
promedioVida(humana, 80).
promedioVida(enano, 350).

vivo(Persona, Anio):-
    persona(Persona, Raza, AnioNacimiento, _),
    promedioVida(Raza, AniosVida),
    Anio >= AnioNacimiento, %nacio
    Anio =< AnioNacimiento + AniosVida. %todavia no murio

vivo(Persona, Anio):-
    persona(Persona, elfa, AnioNacimiento, _),
    Anio >= AnioNacimiento. %solo tiene que haber nacido porque no mueren 

:- begin_tests(tpIntegrador, []).


:- end_tests(tpIntegrador).
