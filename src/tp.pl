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

conocio(Persona, AnioConocio, Hazana, Heroes, Lugar, Manera) :-
    persona(Persona, _, AnioNacimiento, Pueblo),
    conmemora(Pueblo, Hazana, Heroes, Lugar, AnioComienzo, Manera),
    AnioConocio is max(AnioComienzo, AnioNacimiento).

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

enMemoria(festivo, _, _).

enMemoria(estatua(_, Nombre), _, Anio) :-
    buenEstado(Nombre, Anio).

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

limiteAntiguedad(marmol, 30).
limiteAntiguedad(bronce, 15).

anioReferencia(_, AnioConstruccion, AnioConstruccion). %el anio de construccion 
anioReferencia(Nombre, _, AnioMantenimiento) :- %cualquier anio donde hubo un mantenimiento
    mantenimiento(Nombre, AnioMantenimiento).

buenEstado(Nombre, Anio) :-
    conmemora(_, _, _, _, AnioConstruccion, estatua(Material, Nombre)),
    limiteAntiguedad(Material, Limite),
    anioReferencia(Nombre, AnioConstruccion, AnioReferencia), 
    AnioReferencia =< Anio,
    Anio =< AnioReferencia + Limite. %si un anioReferencia no cumple, entra a la clausula nuevamente en caso de tener uno/otro mantenimiento

:- begin_tests(tpIntegrador, []).

%punto 1
test("Una persona esta viva si no paso mas que su promedio de vida") :- vivo(kanne, 1370).
test("Una persona no esta viva si aun no nacio", [fail]) :- vivo(kanne, 1300).
test("Una persona no esta viva si paso su promedio de vida", [fail]) :- vivo(kanne, 2000).
test("Una persona esta viva justo en el limite de su promedio de vida") :- vivo(voll, 1550).
test("Una persona no esta viva pasado el limite de su promedio de vida", [fail]) :- vivo(voll, 1551).
test("Un elfo esta vivo sin importar el anio por ser inmortal") :- vivo(serie, 5000).
%punto 2
test("Una persona no recuerda una hazana antes de conocerla", [fail]) :- recuerda(lawine, destruirDemonioAura, 1380).
test("Una persona recuerda una hazana escuchada dentro de los 15 anios de conocerla") :- recuerda(lawine, destruirDemonioAura, 1400).
test("Una persona no recuerda una hazana escuchada luego de 15 anios de conocerla", [fail]) :- recuerda(lawine, destruirDemonioAura, 1410).
test("Una persona recuerda una hazana leida mientras no pasen mas anios que paginas tiene el libro") :- recuerda(voll, destruirDemonioAura, 1450).
test("Una persona no recuerda una hazana leida si pasaron mas anios que paginas tiene el libro", [fail]) :- recuerda(voll, destruirDemonioAura, 1460).
test("Una persona recuerda una hazana presenciada mientras siga viva") :- recuerda(wirbel, rescatarHermanaWirbel, 1430).
test("Una persona no recuerda una hazana presenciada si ya no esta viva", [fail]) :- recuerda(wirbel, rescatarHermanaWirbel, 1440).
test("Una hazana esta corroborada si todas las versiones conocidas coinciden") :- hazanaCorroborada(rescatarHermanaWirbel).
test("Una hazana no esta corroborada si hay versiones con distintos heroes o lugar", [fail]) :- hazanaCorroborada(destruirDemonioAura).
test("Una hazana paso al olvido si nadie la recuerda ese anio") :- pasoAlOlvido(destruirDemonioAura, 1460).
test("Una hazana no paso al olvido si alguien todavia la recuerda ese anio", [fail]) :- pasoAlOlvido(destruirDemonioAura, 1440).
%punto 3
test("Una persona recuerda una hazana conmemorada con una estatua en buen estado") :- recuerda(lawine, destruirReyDemonio, 1400).
test("Una persona no recuerda una hazana conmemorada con una estatua en mal estado", [fail]) :- recuerda(lawine, destruirReyDemonio, 1390).
test("Una persona recuerda una hazana conmemorada con un dia festivo") :- recuerda(fern, destruirReyDemonio, 1400).

:- end_tests(tpIntegrador).