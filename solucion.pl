%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% El asadito - Parcial
% NOMBRE: Leonardo Olmedo - lgo1980
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*
Necesitamos desarrollar una aplicación para un amigo que necesita organizar los asados que realiza semanalmente con sus amigos. Tenemos la siguiente información:
% define quiénes son amigos de nuestro cliente
*/
amigo(mati).
amigo(pablo).
amigo(leo).
amigo(fer).
amigo(flor).
amigo(ezequiel).
amigo(marina).

% define quiénes no se pueden ver
noSeBanca(leo, flor).
noSeBanca(pablo, fer).
noSeBanca(fer, leo).
noSeBanca(flor, fer).

% define cuáles son las comidas y cómo se componen
% functor achura contiene nombre, cantidad de calorías
% functor ensalada contiene nombre, lista de ingredientes
% functor morfi contiene nombre (el morfi es una comida principal)
comida(achura(chori, 200)). % ya sabemos que el chori no es achura
comida(achura(chinchu, 150)).
comida(ensalada(waldorf, [manzana, apio, nuez, mayo])).
comida(ensalada(mixta, [lechuga, tomate, cebolla])).
comida(morfi(vacio)).
comida(morfi(mondiola)).
comida(morfi(asado)).

% relacionamos la comida que se sirvió en cada asado
% cada asado se realizó en una única fecha posible: functor fecha + comida
asado(fecha(22,9,2011), chori).
asado(fecha(15,9,2011), mixta).
asado(fecha(22,9,2011), waldorf).
asado(fecha(15,9,2011), mondiola).
asado(fecha(22,9,2011), vacio).
asado(fecha(15,9,2011), chinchu).
% relacionamos quiénes asistieron a ese asado
asistio(fecha(15,9,2011), flor).
asistio(fecha(22,9,2011), marina).
asistio(fecha(15,9,2011), pablo).
asistio(fecha(22,9,2011), pablo).
asistio(fecha(15,9,2011), leo).
asistio(fecha(22,9,2011), flor).
asistio(fecha(15,9,2011), fer).
asistio(fecha(22,9,2011), mati).
% definimos qué le gusta a cada persona
leGusta(mati, chori).
leGusta(fer, mondiola).
leGusta(pablo, asado).
leGusta(mati, vacio).
leGusta(fer, vacio).
leGusta(mati, waldorf).
leGusta(flor, mixta).
%NOTA IMPORTANTE: Todos los predicados deben ser inversibles.
/*
1) Hacer lo que sea necesario para incorporar los siguientes conocimientos:*/
%a. A Ezequiel le gusta lo que le gusta a Mati y a Fer.
leGusta(ezequiel, Comida):-
  leGusta(fer,Comida).
leGusta(ezequiel, Comida):-
  leGusta(mati,Comida).
%b. A Marina le gusta todo lo que le gusta a Flor y la mondiola.
leGusta(marina, Comida):-
  leGusta(flor,Comida).
leGusta(marina, mondiola).
%c. A Leo no le gusta la ensalada waldorf.
%Aca no hay que hacer nada por el principio del universo cerrado, todo lo que no se define se asume falso

/*2) Definir el predicado asadoViolento/1 que relaciona la fecha del asado donde todos los asistentes 
tuvieron que soportar la presencia de alguien que no se bancan.
?- asadoViolento(FechaAsado).
FechaAsado = fecha(15, 9, 2011)
(Leo que fue no se banca a Flor que también fue, y lo mismo le pasó al resto)*/
/*asadoViolento(FechaAsado):-
  noSeBanca(Persona,PersonaQueNoSeBanca),
  asistio(FechaAsado, _),
  forall(noSeBanca(Persona,PersonaQueNoSeBanca),asistioElMismoDia(Persona,PersonaQueNoSeBanca,FechaAsado)).
asistioElMismoDia(Persona,PersonaQueNoSeBanca,FechaAsado):-
  asistio(FechaAsado,Persona),
  asistio(FechaAsado,PersonaQueNoSeBanca).*/
asadoViolento(FechaAsado):-
  noSeBanca(Persona,PersonaQueNoSeBanca),
  asistio(FechaAsado,Persona),
  asistio(FechaAsado,PersonaQueNoSeBanca).
  
%3) Definir el predicado calorías/2 que relaciona las calorías de una comida
%a. Las ensaladas tienen una caloría por ingrediente (la mixta, por ejemplo, tiene 3 calorías)
%b. Las achuras definen su propias calorías (el chori tiene 200 calorías)
%c. El morfi tiene siempre 200 calorías, no importa de qué morfi se trate
calorias(Comida,Calorias):-
  definirCalorias(Comida, Calorias).

definirCalorias(Comida, Calorias):-
  comida(ensalada(Comida,Ingredientes)),
  length(Ingredientes, Calorias).
definirCalorias(Comida, Calorias):-
  comida(achura(Comida,Calorias)).
definirCalorias(Comida, Calorias):-
  comida(morfi(Comida)),
  Calorias is 200.
/*Comida = waldorf, Calorias = 4 ; Comida = mixta, Calorias = 3 ;
Comida = chori, Calorias = 200 ; etc.*/

/*4) Relacionar los asados flojitos, son los asados en los que todo lo que hubo para comer no supera las 400 calorías.
?- asadoFlojito(FechaAsado).
FechaAsado = fecha(15, 9, 2011)
El asado del 22/09/2011 llegó a 404 calorías, mientras que el asado del 15/09 llegó a 353 calorías 
(3 de la ensalada mixta, 200 de la mondiola y 150 de los chinchu) por lo tanto fue un asado flojito*/
asadoFlojito(FechaAsado):-
  fechaAsado(FechaAsado),
  findall(Caloria,devolverCaloriasDelAsado(FechaAsado,Caloria),Calorias),
  sum_list(Calorias,Calorias1),
  Calorias1 < 400.

devolverCaloriasDelAsado(FechaAsado,Caloria):-
  asado(FechaAsado,Comida),
  calorias(Comida,Caloria).

%5) Al incorporar esta serie de hechos
hablo(fecha(15,09,2011), flor, pablo).
hablo(fecha(22,09,2011), flor, marina).
hablo(fecha(15,09,2011), pablo, leo).
hablo(fecha(22,09,2011), marina, pablo).
hablo(fecha(15,09,2011), leo, fer).
reservado(marina).
/*Definir el predicado chismeDe/3, que relaciona la fecha de un asado y dos personas cuando la primera conoce algún chisme de la segunda, porque
- la segunda le contó directamente a la primera (según predicado hablo/3), o
- alguien que sabe un chisme de la segunda persona le contó a la primera
siempre que el que hable al otro no sea reservado. El predicado debe funcionar a n niveles posibles. Considerar que en la conversación el primero le cuenta cosas que sabe al segundo.
?- chismeDe(fecha(15,09,2011), fer, flor).
true (porque flor habló con pablo que habló con leo que habló con fer)
?- chismeDe(fecha(22,09,2011), ConocedorChisme, ChismeDeQuien).
ConocedorChisme = marina, ChismeDeQuien = flor ;
false. (marina conoce los chismes de flor porque le contó, pero pablo no sabe nada de marina ni de flor porque marina es reservada). Nota importante: no repetir código.*/
chismeDe(FechaAsado, ConocedorChisme, ChismeDeQuien):-
  not(reservado(ConocedorChisme)),
  hablo(FechaAsado, ChismeDeQuien, ConocedorChisme).
chismeDe(FechaAsado, ConocedorChisme, ChismeDeQuien):-
  hablo(FechaAsado, OtroConocedorChisme, ConocedorChisme),
  chismeDe(FechaAsado, OtroConocedorChisme, ChismeDeQuien).

/*6) Definir el predicado disfruto/2, relaciona a una persona que pudo comer al menos 3 cosas que le gustan en un asado al que haya asistido.
?- disfruto(mati, FechaAsado).
FechaAsado = fecha(22, 9, 2011)
A mati le gusta el chori, la ensalada waldorf y el vacío, justo lo que sirvieron el 22/09/2011 (y él fue)*/
disfruto(Persona, FechaAsado):-
  fechaAsado(FechaAsado),
  asistioAlAsado(Persona),
  findall(Comida,comidaQueLeGusta(Persona,FechaAsado,Comida),Comidas),
  length(Comidas, CantidadComidasQueGustan),
  CantidadComidasQueGustan >= 3.

fechaAsado(FechaAsado):-
  asado(FechaAsado,_).

asistioAlAsado(Persona):-
  asistio(_, Persona).

comidaQueLeGusta(Persona,FechaAsado,Comida):-
  asado(FechaAsado,Comida),
  leGusta(Persona,Comida).

/*
7) Definir el predicado asadoRico/1, que debe relacionar un asado que tenga todas comidas ricas
a. los morfis son todos ricos
b. las ensaladas ricas son las que tienen más de 3 ingredientes
c. chori y morci son achuras ricas, el resto no
Se pide que genere todas las listas posibles de comidas ricas, sin incluir una lista sin comidas.
?- asadoRico(Comidas).
Comidas = [morfi(vacio)] ; Comidas = [morfi(mondiola), morfi(asado)] ; Comidas = [morfi(mondiola)] ; entre otros son posibles soluciones (tiene que haber comidas)
*/

asadoRico(ComidasPosibles):-
  findall(Comida,esComidaRica(Comida),Comidas),
  combinarComidasRicas(Comidas,ComidasPosibles).

esComidaRica(Comida):-
  comida(Comida),
  comidasRicas(Comida).

comidasRicas(morfi(_)).
comidasRicas(ensalada(_,Ingredientes)):-
  length(Ingredientes,CantidadIngredientes),
  CantidadIngredientes > 3.
comidasRicas(achura(chori,_)).
comidasRicas(achura(morci,_)).

combinarComidasRicas([],[]).
combinarComidasRicas([Comida|ComidasRicas],[Comida|ComidasPosibles]):-
  combinarComidasRicas(ComidasRicas,ComidasPosibles).
combinarComidasRicas([_|ComidasRicas],ComidasPosibles):-
  combinarComidasRicas(ComidasRicas,ComidasPosibles).

:- begin_tests(utneanos).
  test(personas_que_le_gustan_el_vacio, set(Persona=[mati,fer,ezequiel])):-
    leGusta(Persona, vacio).
  test(personas_que_le_gustan_el_mixta, set(Persona=[flor,marina])):-
    leGusta(Persona, mixta).
  test(fecha_del_asado_que_fue_violento,set(FechaAsado=[fecha(15,9,2011)])):-
    distinct(asadoViolento(FechaAsado)).
  test(las_calorias_de_una_ensalada_mixta_debe_tener_tantas_calorias, set(Calorias=[3])):-
    calorias(mixta,Calorias).
  test(las_calorias_de_un_morfi_cualquiera_debe_tener_tantas_calorias, set(Comida=[chori,asado,vacio,mondiola])):-
    calorias(Comida, 200).
  test(fecha_del_asado_que_fue_flojito,set(FechaAsado=[fecha(15,9,2011)])):-
    asadoFlojito(FechaAsado).
  test(una_persona_conoce_un_chisme_de_otra,set(PersonaQueConoceChisme=[fer])):-
    chismeDe(fecha(15,09,2011), PersonaQueConoceChisme, pablo).
  test(una_persona_no_conoce_un_chisme_de_otra_por_reservado,fail):-
    chismeDe(fecha(22,09,2011), marina, flor).
  test(persona_que_disfruto_un_dia_particular_de_un_asado,set(FechaAsado=[fecha(22, 9, 2011)])):-
    distinct(disfruto(mati, FechaAsado)).
  test(combinacion_de_comidas_ricas,set(Comidas=[[],[morfi(asado)],[morfi(mondiola)],[morfi(mondiola),morfi(asado)],[morfi(vacio)],[morfi(vacio),morfi(asado)],[morfi(vacio),morfi(mondiola)],[morfi(vacio),morfi(mondiola),morfi(asado)],[achura(chori,200)],[achura(chori,200),morfi(asado)],[achura(chori,200),morfi(mondiola)],[achura(chori,200),morfi(mondiola),morfi(asado)],[achura(chori,200),morfi(vacio)],[achura(chori,200),morfi(vacio),morfi(asado)],[achura(chori,200),morfi(vacio),morfi(mondiola)],[achura(chori,200),morfi(vacio),morfi(mondiola),morfi(asado)],[achura(chori,200),ensalada(waldorf,[manzana,apio,nuez,mayo])],[achura(chori,200),ensalada(waldorf,[manzana,apio,nuez,mayo]),morfi(asado)],[achura(chori,200),ensalada(waldorf,[manzana,apio,nuez,mayo]),morfi(mondiola)],[achura(chori,200),ensalada(waldorf,[manzana,apio,nuez,mayo]),morfi(mondiola),morfi(asado)],[achura(chori,200),ensalada(waldorf,[manzana,apio,nuez,mayo]),morfi(vacio)],[achura(chori,200),ensalada(waldorf,[manzana,apio,nuez,mayo]),morfi(vacio),morfi(asado)],[achura(chori,200),ensalada(waldorf,[manzana,apio,nuez,mayo]),morfi(vacio),morfi(mondiola)],[achura(chori,200),ensalada(waldorf,[manzana,apio,nuez,mayo]),morfi(vacio),morfi(mondiola),morfi(asado)],[ensalada(waldorf,[manzana,apio,nuez,mayo])],[ensalada(waldorf,[manzana,apio,nuez,mayo]),morfi(asado)],[ensalada(waldorf,[manzana,apio,nuez,mayo]),morfi(mondiola)],[ensalada(waldorf,[manzana,apio,nuez,mayo]),morfi(mondiola),morfi(asado)],[ensalada(waldorf,[manzana,apio,nuez,mayo]),morfi(vacio)],[ensalada(waldorf,[manzana,apio,nuez,mayo]),morfi(vacio),morfi(asado)],[ensalada(waldorf,[manzana,apio,nuez,mayo]),morfi(vacio),morfi(mondiola)],[ensalada(waldorf,[manzana,apio,nuez,mayo]),morfi(vacio),morfi(mondiola),morfi(asado)]])):-
    asadoRico(Comidas).

:- end_tests(utneanos).