persona(denken, humano, 1290, auberst).
persona(voll, enano, 1200, ende).
persona(serie, elfo, 500, weise).
persona(fern, humano, 1370, weise).
persona(stark, humano, 1368, riegel).
persona(lawine, humano, 1372, auberst).
persona(kanne, humano, 1365, weise).
persona(wirbel, humano, 1350, klares).
persona(lernen, humano, 1315, auberst).
persona(frieren, elfo, 100, weise).
persona(eisen, enano, 1150, riegel).

promedioVida(humano, 80).
promedioVida(enano, 350).

esInmortal(elfo).

noMurio(Raza, AnioNacimiento, Anio):-
    promedioVida(Raza, AniosVida),
    Anio =< AnioNacimiento + AniosVida.

noMurio(Raza, _, _) :-
    esInmortal(Raza).

vivo(Persona, Anio):-
    persona(Persona, Raza, AnioNacimiento, _),
    Anio >= AnioNacimiento, %nacio
    noMurio(Raza, AnioNacimiento, Anio).


conocio(wirbel, 1390, rescatarHermanaWirbel, [stark, fern], klares, presencio).
conocio(frieren, 1390, rescatarHermanaWirbel, [stark, fern], klares, presencio).
conocio(kanne, 1375, recuperarGatoPerdido, [himmel, frieren], weise, presencio).
conocio(lawine, 1393, destruirDemonioAura, [frieren], weise, escucho).
conocio(voll, 1400, destruirDemonioAura, [denken], auberst, leyo(50)).
conocio(serie, 1335, destruirReyDemonio, [frieren, himmel, heiter, eisen], ende, leyo(100)).


recuerda(Persona, Hazana, Anio) :-
    conocio(Persona, AnioConocio, Hazana, _, _, Medio),
    Anio >= AnioConocio,
    vivo(Persona, Anio),
    enMemoria(Medio, AnioConocio, Anio).

enMemoria(presencio, _, _).

enMemoria(escucho, AnioConocio, Anio) :-
    Anio =< AnioConocio + 15.

enMemoria(leyo(Paginas), AnioConocio, Anio) :-
    Anio =< AnioConocio + Paginas.

dosVersionesDistintas(Hazana) :-
    conocio(_, _, Hazana, Heroes1, Lugar1, _),
    conocio(_, _, Hazana, Heroes2, Lugar2, _),
    not((Heroes1 = Heroes2, Lugar1 = Lugar2)).

hazanaCorroborada(Hazana) :-
    conocio(_, _, Hazana, _, _, _),
    not(dosVersionesDistintas(Hazana)).

pasoAlOlvido(Hazana, Anio) :-
    conocio(_, _, Hazana, _, _, _),
    not(recuerda(_, Hazana, Anio)).



conmemora(weise, destruirReyDemonio, [frieren, himmel, heiter, eisen], ende, 1340, festivo).
conmemora(auberst, destruirReyDemonio, [frieren, himmel, heiter, eisen], ende, 1370, estatua(bronce, equipoDeHeroes)).
conmemora(auberst, destruirSchlatOmnisciente, [heroeDelSur], ende, 1340, estatua(marmol, heroeDelSur)).

mantenimiento(equipoDeHeroes, 1400).
mantenimiento(equipoDeHeroes, 1450).
mantenimiento(heroeDelSur, 1410).

vigente(festivo, _, _).
vigente(estatua(Material, Nombre), AnioConstruccion, Anio) :-
    buenEstado(Material, Nombre, AnioConstruccion, Anio).

buenEstado(marmol, _, AnioConstruccion, Anio) :-
    Anio =< AnioConstruccion + 30.
buenEstado(marmol, Nombre, _, Anio) :-
    tuvoMantenimiento(Nombre, Anio).

buenEstado(bronce, _, AnioConstruccion, Anio) :-
    Anio =< AnioConstruccion + 15.
buenEstado(bronce, Nombre, _, Anio) :-
    tuvoMantenimiento(Nombre, Anio).

tuvoMantenimiento(Nombre, Anio) :-
    mantenimiento(Nombre, AnioMantenimiento),
    AnioMantenimiento =< Anio.


recuerda(Persona, Hazana, Anio) :-
    persona(Persona, _, AnioNacimiento, Pueblo),
    conmemora(Pueblo, Hazana, _, _, AnioComienzo, Manera),
    AnioConocio is max(AnioComienzo, AnioNacimiento),
    Anio >= AnioConocio,
    vivo(Persona, Anio),
    vigente(Manera, AnioComienzo, Anio).

:- begin_tests(tpIntegrador, []).

%punto 1
test(vivo_dentro_del_promedio_de_vida) :- vivo(kanne, 1370).
test(no_vivo_antes_de_nacer, [fail]) :- vivo(kanne, 1300).
test(no_vivo_luego_de_superar_promedio_de_vida, [fail]) :- vivo(kanne, 2000).
test(vivo_justo_en_el_limite_del_promedio_de_vida) :- vivo(voll, 1550).
test(no_vivo_pasado_el_limite_del_promedio_de_vida, [fail]) :- vivo(voll, 1551).
test(elfo_vivo_por_ser_inmortal) :- vivo(serie, 5000).
%punto 2
test(no_recuerda_hazana_antes_de_escuchar_la_cancion, [fail]) :- recuerda(lawine, destruirDemonioAura, 1380).
test(recuerda_hazana_escuchada_dentro_de_los_15_anios) :- recuerda(lawine, destruirDemonioAura, 1400).
test(no_recuerda_hazana_escuchada_luego_de_15_anios, [fail]) :- recuerda(lawine, destruirDemonioAura, 1410).
test(recuerda_hazana_leida_justo_en_el_limite_de_paginas) :- recuerda(voll, destruirDemonioAura, 1450).
test(no_recuerda_hazana_leida_pasado_el_limite_de_paginas, [fail]) :- recuerda(voll, destruirDemonioAura, 1460).
test(recuerda_hazana_presenciada_mientras_esta_vivo) :- recuerda(wirbel, rescatarHermanaWirbel, 1430).
test(no_recuerda_hazana_presenciada_si_ya_no_esta_vivo, [fail]) :- recuerda(wirbel, rescatarHermanaWirbel, 1440).
test(hazana_corroborada_cuando_todas_las_versiones_coinciden) :- hazanaCorroborada(rescatarHermanaWirbel).
test(hazana_no_corroborada_cuando_hay_versiones_distintas, [fail]) :- hazanaCorroborada(destruirDemonioAura).
test(hazana_paso_al_olvido_si_nadie_la_recuerda) :- pasoAlOlvido(destruirDemonioAura, 1460).
test(hazana_no_paso_al_olvido_si_alguien_la_recuerda, [fail]) :- pasoAlOlvido(destruirDemonioAura, 1440).
%punto 3
test(recuerda_hazana_por_estatua_en_buen_estado) :- recuerda(lawine, destruirReyDemonio, 1400).
test(no_recuerda_hazana_por_estatua_en_mal_estado, [fail]) :- recuerda(lawine, destruirReyDemonio, 1390).
test(recuerda_hazana_por_dia_festivo) :- recuerda(fern, destruirReyDemonio, 1400).

:- end_tests(tpIntegrador).