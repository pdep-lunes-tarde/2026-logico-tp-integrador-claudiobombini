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

%PARTE 2:

%punto 4

recuerdaMedio(Persona, Hazana, Anio, Medio) :-
    conocio(Persona, AnioConocio, Hazana, _, _, Medio),
    Anio >= AnioConocio,
    vivo(Persona, Anio),
    enMemoria(Medio, AnioConocio, Anio).

seRecuerdaEnPueblo(Pueblo, Hazana, Anio) :-
    persona(Persona, _, _, Pueblo),
    recuerda(Persona, Hazana, Anio).

hazanasDelPueblo(Pueblo, Anio, Hazanas) :-
    findall(Hazana, (persona(Persona, _, _, Pueblo), recuerda(Persona, Hazana, Anio)), HazanasConRepetidos),
    list_to_set(HazanasConRepetidos, Hazanas).

paginasLeidasEnPueblo(Pueblo, Anio, Total) :-
    findall(Paginas, (persona(Persona, _, _, Pueblo), conocio(Persona, Anio, _, _, _, leyo(Paginas))), ListaPaginas),
    sum_list(ListaPaginas, Total).

puebloMasLector(Pueblo, Anio) :-
    persona(_, _, _, Pueblo),
    paginasLeidasEnPueblo(Pueblo, Anio, Total),
    not((persona(_, _, _, OtroPueblo),
         OtroPueblo \= Pueblo,
         paginasLeidasEnPueblo(OtroPueblo, Anio, OtroTotal),
         OtroTotal > Total)).

hazanaRecordadaPorCancion(Pueblo, Hazana, Anio) :-
    persona(Persona, _, _, Pueblo),
    recuerdaMedio(Persona, Hazana, Anio, escucho).

puebloMusical(Pueblo, Anio) :-
    hazanasDelPueblo(Pueblo, Anio, Hazanas),
    Hazanas \= [],
    findall(Hazana, (member(Hazana, Hazanas), hazanaRecordadaPorCancion(Pueblo, Hazana, Anio)), HazanasPorCancion),
    length(Hazanas, TotalHazanas),
    length(HazanasPorCancion, TotalCanciones),
    TotalCanciones * 2 > TotalHazanas.

puebloChismoso(Pueblo, Anio) :-
    hazanasDelPueblo(Pueblo, Anio, Hazanas),
    Hazanas \= [],
    forall(member(Hazana, Hazanas), not(hazanaCorroborada(Hazana))).

hazanaImportante(Hazana, Pueblo, Anio) :-
    findall(Persona, (persona(Persona, _, _, Pueblo), vivo(Persona, Anio)), Habitantes),
    Habitantes \= [],
    forall(member(Persona, Habitantes), recuerda(Persona, Hazana, Anio)).

huboPresencial(Pueblo, Hazana) :-
    persona(Persona, _, _, Pueblo),
    conocio(Persona, _, Hazana, _, _, presencio).

puebloTiemposSinPrecedentes(Pueblo, Anio) :-
    hazanasDelPueblo(Pueblo, Anio, Hazanas),
    findall(Hazana, (member(Hazana, Hazanas), hazanaImportante(Hazana, Pueblo, Anio)), Importantes),
    forall(member(Hazana, Importantes), huboPresencial(Pueblo, Hazana)).


%Punto 5:

heroe(Persona) :-
    conocio(_, _, _, Heroes, _, _),
    member(Persona, Heroes). %pregunta si la persona esta en la lista de heroes de las hazanas que se conocieron

inspiro(Persona, Heroe) :-
    conocio(Heroe, _, _, Heroes, _, _),
    member(Persona, Heroes).

cadenaDeInspiracion([Origen, Otro]) :-
    inspiro(Origen, Otro). %si es directa osea 2 elementos

cadenaDeInspiracion([Origen, Siguiente | Resto]) :-
    inspiro(Origen, Siguiente), %el primero inspiro al siguiente
    cadenaDeInspiracion([Siguiente | Resto]), 
    not(member(Origen, [Siguiente | Resto])). %para evitar que se repitan personas


% Punto 6

esAntecesorDe(Antecesor, Heroe) :- %caso base, si Antecesor inspiro directamente a Heroe es antecesor
    inspiro(Antecesor, Heroe). 
esAntecesorDe(Antecesor, Heroe) :- %caso recursivo, si Antecesor inspiro a un "intermedio" y ese "intermedio" inspiro a Heroe, entonces Antecesor es antecesor de Heroe
    inspiro(Antecesor, Intermedio),
    esAntecesorDe(Intermedio, Heroe).

sinRepetidos([]). %caso base, la lista vacia no tiene repetidos
sinRepetidos([X|Xs]) :- %caso recursivo, pide recursivamente que X no este en el resto de la lista. 
    not(member(X, Xs)),
    sinRepetidos(Xs).

equipoDeSuenios(Heroe, Equipo) :-
    heroe(Heroe),
    sinRepetidos(Equipo), 
    length(Equipo, Largo), Largo >= 2, %minimo 2 personas en el equipo
    member(Heroe, Equipo), %el heroe debe estar en el equipo
    forall(member(Miembro, Equipo), (Miembro == Heroe ; esAntecesorDe(Miembro, Heroe))). %para cada miembro del equipo, debe ser el heroe o un antecesor de el


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
%punto 4
test("En un pueblo se recuerda una hazana si al menos un habitante la recuerda") :- seRecuerdaEnPueblo(weise, destruirReyDemonio, 1400).
test("En un pueblo se recuerda una hazana presenciada por un habitante") :- seRecuerdaEnPueblo(klares, rescatarHermanaWirbel, 1395).
test("En un pueblo no se recuerda una hazana que ningun habitante recuerda", [fail]) :- seRecuerdaEnPueblo(klares, destruirReyDemonio, 1395).
test("En un pueblo se cuentan las paginas leidas por sus habitantes en un anio") :- paginasLeidasEnPueblo(weise, 1335, 100).
test("En un pueblo no se leyeron paginas en un anio en que nadie leyo") :- paginasLeidasEnPueblo(weise, 1336, 0).
test("El pueblo mas lector es el que mas paginas leyo en ese anio") :- puebloMasLector(ende, 1400).
test("Un pueblo es musical si la mayoria de sus hazanas recordadas se conocen por canciones") :- puebloMusical(auberst, 1395).
test("Un pueblo no es musical si la mayoria de sus hazanas recordadas no se conocen por canciones", [fail]) :- puebloMusical(weise, 1400).
test("Un pueblo es chismoso si ninguna hazana que recuerda esta corroborada") :- puebloChismoso(ende, 1420).
test("Un pueblo no es chismoso si alguna hazana que recuerda esta corroborada", [fail]) :- puebloChismoso(weise, 1400).
test("Una hazana es importante para un pueblo si todos sus habitantes vivos la recuerdan") :- hazanaImportante(destruirReyDemonio, weise, 1400).
test("Una hazana no es importante para un pueblo si no todos sus habitantes vivos la recuerdan", [fail]) :- hazanaImportante(recuperarGatoPerdido, weise, 1400).
test("Un pueblo vive tiempos sin precedentes si sus hazanas importantes fueron presenciadas por algun habitante") :- puebloTiemposSinPrecedentes(klares, 1395).
test("Un pueblo no vive tiempos sin precedentes si alguna hazana importante no fue presenciada por ningun habitante", [fail]) :- puebloTiemposSinPrecedentes(weise, 1400).
%punto 5
test("Alguien es un heroe si participo en alguna hazana conocida") :- heroe(frieren).
test("Alguien no es un heroe si nunca participo en una hazana conocida", [fail]) :- heroe(wirbel).
test("Alguien inspiro a un heroe si participo en una hazana que el heroe conocio") :- inspiro(frieren, fern).
test("Alguien inspiro a un heroe si participo en otra hazana que el heroe conocio") :- inspiro(stark, frieren).
test("Nadie inspiro a un heroe que no conoce ninguna hazana", [fail]) :- inspiro(_, eisen).
test("Una cadena de inspiracion es valida si cada persona inspiro a la siguiente sin repetirse") :- cadenaDeInspiracion([himmel, fern, frieren, denken]).
test("Una cadena de inspiracion no es valida si uno no inspiro al otro", [fail]) :- cadenaDeInspiracion([denken, frieren]).
test("Una cadena de inspiracion no es valida si algun heroe se repite", [fail]) :- cadenaDeInspiracion([frieren, fern, frieren]).
%punto 6
test("Un equipo de los suenios es valido si incluye al heroe y a quien lo inspiro") :- equipoDeSuenios(frieren, [frieren, stark]).
test("El orden de los integrantes del equipo no afecta su validez") :- equipoDeSuenios(frieren, [stark, frieren]).
test("Un heroe solo no es un equipo de los suenios valido porque no incluye ningun antecesor", [fail]) :- equipoDeSuenios(frieren, [frieren]).
test("Un antecesor solo no es un equipo de los suenios valido porque no incluye al heroe", [fail]) :- equipoDeSuenios(frieren, [stark]).

:- end_tests(tpIntegrador).