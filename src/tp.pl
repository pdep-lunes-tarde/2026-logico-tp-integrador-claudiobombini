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

presencio(wirbel, 1390, rescatarHermanaWirbel, [stark, fern], klares).
presencio(frieren, 1390, rescatarHermanaWirbel, [stark, fern], klares).
presencio(kanne, 1375, recuperarGatoPerdido, [himmel, frieren], weise).

escucho(lawine, 1393, destruirDemonioAura, [frieren], weise).

%los hechos de "leyo" tienen un parametro adicional que son las paginas
leyo(voll, 1400, 50, destruirDemonioAura, [denken], auberst).
leyo(serie, 1335, 100, destruirReyDemonio, [frieren, himmel, heiter, eisen], ende).

%basicamente una persona conocio una hazana si la presencio, la escucho o la leyo
conocio(Persona, Anio, Hazana, Heroes, Lugar) :- presencio(Persona, Anio, Hazana, Heroes, Lugar).
conocio(Persona, Anio, Hazana, Heroes, Lugar) :- escucho(Persona, Anio, Hazana, Heroes, Lugar).
conocio(Persona, Anio, Hazana, Heroes, Lugar) :- leyo(Persona, Anio, _, Hazana, Heroes, Lugar).

%la persona recuerda una hazaña si la presencio y sigue viva, si la escucho y no pasaron mas de 15 años, o si la leyo y no pasaron mas años que paginas leyo
recuerda(Persona, Hazana, Anio) :-
    presencio(Persona, AnioConocio, Hazana, _, _),
    Anio >= AnioConocio,
    vivo(Persona, Anio).

recuerda(Persona, Hazana, Anio) :-
    escucho(Persona, AnioConocio, Hazana, _, _),
    Anio >= AnioConocio,
    Anio =< AnioConocio + 15.

recuerda(Persona, Hazana, Anio) :-
    leyo(Persona, AnioConocio, Paginas, Hazana, _, _),
    Anio >= AnioConocio,
    Anio =< AnioConocio + Paginas.

dosVersionesDistintas(Hazana) :-
    conocio(_, _, Hazana, Heroes1, Lugar1),
    conocio(_, _, Hazana, Heroes2, Lugar2),
    (Heroes1 \= Heroes2 ; Lugar1 \= Lugar2).

hazanaCorroborada(Hazana) :-
    conocio(_, _, Hazana, _, _),
    not(dosVersionesDistintas(Hazana)).

pasoAlOlvido(Hazana, Anio) :-
    not(recuerda(_, Hazana, Anio)).



% diaFestivo(Pueblo, Hazana, Heroes, Lugar, AnioInicio)
diaFestivo(weise, destruirReyDemonio, [frieren, himmel, heiter, eisen], ende, 1340).

% estatua(Pueblo, NombreEstatua, Material, AnioConstruccion, Hazana, Heroes, Lugar)
estatua(auberst, elEquipoDeHeroes, bronce, 1370, destruirReyDemonio, [frieren, himmel, heiter, eisen], ende).
estatua(auberst, elHeroeDelSur, marmol, 1340, destruirSchlatElOmnisciente, [heroeDelSur], ende).

% mantenimiento(NombreEstatua, Anio)
mantenimiento(elEquipoDeHeroes, 1400).
mantenimiento(elEquipoDeHeroes, 1450).
mantenimiento(elHeroeDelSur, 1410).

limiteBuenEstado(marmol, 30).
limiteBuenEstado(bronce, 15).

% un "evento de cuidado" de una estatua es su construccion o un mantenimiento
eventoEstatua(NombreEstatua, Anio) :-
    estatua(_, NombreEstatua, _, Anio, _, _, _).
eventoEstatua(NombreEstatua, Anio) :-
    mantenimiento(NombreEstatua, Anio).

buenEstado(NombreEstatua, AnioConsulta) :-
    estatua(_, NombreEstatua, Material, _, _, _, _),
    limiteBuenEstado(Material, Limite),
    eventoEstatua(NombreEstatua, AnioEvento),
    AnioEvento =< AnioConsulta,
    AnioConsulta =< AnioEvento + Limite.


conocio(Persona, AnioConocio, Hazana, Heroes, Lugar) :-
    persona(Persona, _, AnioNacimiento, Pueblo),
    diaFestivo(Pueblo, Hazana, Heroes, Lugar, AnioInicio),
    AnioConocio is max(AnioInicio, AnioNacimiento).

conocio(Persona, AnioConocio, Hazana, Heroes, Lugar) :-
    persona(Persona, _, AnioNacimiento, Pueblo),
    estatua(Pueblo, _, _, AnioConstruccion, Hazana, Heroes, Lugar),
    AnioConocio is max(AnioConstruccion, AnioNacimiento).


recuerda(Persona, Hazana, Anio) :-
    persona(Persona, _, _, Pueblo),
    diaFestivo(Pueblo, Hazana, _, _, AnioInicio),
    Anio >= AnioInicio,
    vivo(Persona, Anio).

recuerda(Persona, Hazana, Anio) :-
    persona(Persona, _, _, Pueblo),
    estatua(Pueblo, NombreEstatua, _, _, Hazana, _, _),
    buenEstado(NombreEstatua, Anio).

:- begin_tests(tpIntegrador, []).

%punto 1
test(kanne_viva_1370) :- vivo(kanne, 1370).
test(kanne_no_viva_1300, [fail]) :- vivo(kanne, 1300).
test(kanne_no_viva_2000, [fail]) :- vivo(kanne, 2000).
test(voll_vivo_1550) :- vivo(voll, 1550).
test(voll_no_vivo_1551, [fail]) :- vivo(voll, 1551).
test(serie_viva_5000) :- vivo(serie, 5000).
%punto 2
test(lawine_no_recuerda_1380, [fail]) :- recuerda(lawine, destruirDemonioAura, 1380).
test(lawine_recuerda_1400) :- recuerda(lawine, destruirDemonioAura, 1400).
test(lawine_no_recuerda_1410, [fail]) :- recuerda(lawine, destruirDemonioAura, 1410).
test(voll_recuerda_1450) :- recuerda(voll, destruirDemonioAura, 1450).
test(voll_no_recuerda_1460, [fail]) :- recuerda(voll, destruirDemonioAura, 1460).
test(wirbel_recuerda_1430) :- recuerda(wirbel, rescatarHermanaWirbel, 1430).
test(wirbel_no_recuerda_1440, [fail]) :- recuerda(wirbel, rescatarHermanaWirbel, 1440).
test(rescate_corroborada) :- hazanaCorroborada(rescatarHermanaWirbel).
test(aura_no_corroborada, [fail]) :- hazanaCorroborada(destruirDemonioAura).
test(aura_olvido_1460) :- pasoAlOlvido(destruirDemonioAura, 1460).
test(aura_no_olvido_1440, [fail]) :- pasoAlOlvido(destruirDemonioAura, 1440).
%punto 3
test(lawine_recuerda_reydemonio_1400) :- recuerda(lawine, destruirReyDemonio, 1400).
test(lawine_no_recuerda_reydemonio_1390, [fail]) :- recuerda(lawine, destruirReyDemonio, 1390).
test(fern_recuerda_reydemonio_1400) :- recuerda(fern, destruirReyDemonio, 1400).

:- end_tests(tpIntegrador).