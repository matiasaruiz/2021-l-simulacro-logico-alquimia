



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Resolucion %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1. Modelar los jugadores y elementos y agregarlos a la base de conocimiento, utilizando los ejemplos provistos.
jugador(ana).
jugador(beto).
jugador(cata).

% tiene(Jugador, Elemento)
elementosDe(ana, [agua, agua, tierra, hierro]).
elementosDe(beto, [agua, agua, tierra, hierro]).
elementosDe(cata, [fuego, tierra, agua, aire]).

tiene(Persona, Elemento) :-
    elementosDe(Persona, ElementosQueTiene),
    member(Elemento, ElementosQueTiene).

% receta(Elemento, [Ingredientes])
receta(pasto, [agua, tierra]).
receta(hierro, [fuego, agua, tierra]).
receta(huesos, [pasto, agua]).
receta(vapor, [agua, fuego]).
receta(presion, [hierro, vapor]).
receta(silicio, [tierra]).
receta(plastico, [hierro, vapor]).
receta(playStation, [silicio, hierro, plastico]).

% 2. Saber si un jugador tieneIngredientesPara construir un elemento, 
%  que es cuando tiene ahora en su inventario todo lo que hace falta.
%  Por ejemplo, ana tiene los ingredientes para el pasto, pero no para el vapor. 

tieneIngredientesPara(Jugador, Receta):-
    jugador(Jugador),
    receta(Receta, _),
    forall(requiereElemento(Receta, Material), tiene(Jugador, Material)).

requiereElemento(Receta, Material) :-
    receta(Receta, Materiales),
    member(Material, Materiales).
  
:- begin_tests(tieneIngredientesPara).
    test(tiene_ingredientes_para_la_receta):-
        tieneIngredientesPara(ana, pasto).
    test(no_tiene_ingredientes_para_la_receta, fail):-
        tieneIngredientesPara(ana, vapor).
    test(que_puede_hacer, set(Que=[pasto,silicio])):-
        tieneIngredientesPara(ana, Que).
    
:- end_tests(tieneIngredientesPara).




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Base de Conocimientos %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


herramienta(ana, circulo(50,3)).
herramienta(ana, cuchara(40)).
herramienta(beto, circulo(20,1)).
herramienta(beto, libro(inerte)).
herramienta(cata, libro(vida)).
herramienta(cata, circulo(100,5)).

% Los círculos alquímicos tienen diámetro en cms y cantidad de niveles.
% Las cucharas tienen una longitud en cms.
% Hay distintos tipos de libro.
