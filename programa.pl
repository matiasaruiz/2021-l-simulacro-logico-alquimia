



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Resolucion %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1. Modelar los jugadores y elementos y agregarlos a la base de conocimiento, utilizando los ejemplos provistos.

jugador(Jugador) :- 
    tiene(Jugador, _).
 
elementos(ana, [agua, vapor, tierra, hierro]).
elementos(beto, Elementos) :- 
    elementos(ana, Elementos).
elementos(cata, [fuego, tierra, agua, aire]).

% tiene(Jugador, Elemento)

tiene(Persona, Elemento) :-
    elementos(Persona, ElementosQueTiene),
    member(Elemento, ElementosQueTiene).

requiere(pasto, [agua, tierra]).
requiere(hierro, [fuego, agua, tierra]).
requiere(huesos, [pasto, agua]).
requiere(presion, [hierro, vapor]).
requiere(vapor, [agua, fuego]).
requiere(playstation, [silicio, hierro, plastico]).
requiere(silicio, [tierra]).
requiere(plastico, [huesos, presion]).

requiereElemento(ElementoCompuesto, Material) :-
    requiere(ElementoCompuesto, Materiales),
    member(Material, Materiales).
  
cantidadDeIngredientes(ElementoCompuesto, Cantidad) :-
    requiere(ElementoCompuesto, Materiales),
    length(Materiales, Cantidad).
  
elemento(Elemento) :- 
    tiene(_, Elemento).
elemento(Elemento) :- 
    requiereElemento(Elemento, _).
elemento(Elemento) :- 
    requiereElemento(_, Elemento).


% 2. Saber si un jugador tieneIngredientesPara construir un elemento, 
%  que es cuando tiene ahora en su inventario todo lo que hace falta.
%  Por ejemplo, ana tiene los ingredientes para el pasto, pero no para el vapor. 
tieneIngredientesPara(Jugador, ElementoCompuesto) :-
    jugador(Jugador),
    requiere(ElementoCompuesto, _),
    forall(requiereElemento(ElementoCompuesto, Material), tiene(Jugador, Material)).

% 3. Saber si un elemento estaVivo. Se sabe que el agua, el fuego 
% y todo lo que fue construido a partir de alguno de ellos, están vivos. 
% Debe funcionar para cualquier nivel.
% Por ejemplo, la play station y los huesos están vivos, pero el silicio no.

estaVivo(agua).
estaVivo(fuego).
estaVivo(Elemento):-
    requiereElemento(Elemento, Ingrediente),
    estaVivo(Ingrediente).

:- begin_tests(estaVivo).
    tests(esta_vivo):-
        estaVivo(huesos).
    tests(esta_vivo_recursivo):-
        estaVivo(playStation).
    tests(no_esta_vivo, fail):-
        estaVivo(silicio).
    test(quien_esta_vivio, set(Quien=[agua,fuego,hierro,huesos,pasto,plastico,playStation,presion,vapor])):-
        estaVivo(Quien).
:- end_tests(estaVivo).

% 4. Conocer las personas que puedeConstruir un elemento, para lo que se necesita tener los ingredientes 
% ahora en el inventario y además contar con una o más herramientas que sirvan para construirlo. 

% Para los elementos vivos sirve el libro de la vida
% para los elementos no vivos el libro inerte). 
% las cucharas y círculos sirven cuando soportan la cantidad de ingredientes del elemento 
%       - las cucharas soportan tantos ingredientes como centímetros de longitud/10, 
%       - los círculos alquímicos soportan tantos ingredientes como metros de diámetro * cantidad de niveles
% Por ejemplo, beto puede construir el silicio (porque tiene tierra y tiene el libro inerte, 
% que le sirve para el silicio), 
% pero no puede construir la presión (porque a pesar de tener hierro y vapor, 
% no cuenta con herramientas que le sirvan para la presión). 
% Ana, por otro lado, sí puede construir silicio y presión.

% puedeConstruir(Elemento, Persona)
puedeConstruir(Persona, Elemento) :-
    tieneIngredientesPara(Persona, Elemento),
    tieneHerramientaParaConstruir(Persona, Elemento).
  
tieneHerramientaParaConstruir(Persona, Elemento) :-
    herramienta(Persona, Herramienta),
    sirveParaConstruir(Herramienta, Elemento).

sirveParaConstruir(libro(vida), Elemento) :- 
    estaVivo(Elemento).
sirveParaConstruir(libro(inerte), Elemento) :- 
    not(estaVivo(Elemento)).

sirveParaConstruir(Herramienta, Elemento) :- 
    cantidadSoportada(Herramienta, CantidadSoportada),
    cantidadDeIngredientes(Elemento, CantidadIngredientes),
    CantidadSoportada >= CantidadIngredientes.

% cantidadSoportada(Herramienta, Cantidad)
cantidadSoportada(cuchara(Longitud), Cantidad) :-
    Cantidad is Longitud / 10.
cantidadSoportada(circulo(Diametro, Niveles), Cantidad) :-
    Cantidad is Diametro / 100 * Niveles.
  

% 5. Saber si alguien es todopoderoso, que es cuando tiene todos los elementos primitivos 
% (los que no pueden construirse a partir de nada) y además cuenta con herramientas 
% que sirven para construir cada elemento que no tenga.
% Por ejemplo, cata es todopoderosa, pero beto no. 

todopoderoso(Persona) :-
    jugador(Persona),
    tieneTodosLosPrimitivos(Persona),
    tieneHerramientasParaFaltantes(Persona).
  
tieneTodosLosPrimitivos(Persona) :-
    forall(primitivo(Elemento), tiene(Persona, Elemento)).

primitivo(Elemento) :- 
    elemento(Elemento),
    not(requiereElemento(Elemento, _)).

tieneHerramientasParaFaltantes(Persona) :-
    forall(leFalta(Persona, Elemento), tieneHerramientaParaConstruir(Persona, Elemento)).

leFalta(Persona, Elemento) :-
    elemento(Elemento),
    not(tiene(Persona, Elemento)).
  
% 6. Conocer quienGana, que es quien puede construir más cosas.
% Por ejemplo, cata gana, pero beto no.

quienGana(Persona) :-
    jugador(Persona),
    forall(contrincante(Persona, Contrincante), contruyeMasCosas(Persona, Contrincante)).
  
contrincante(Persona, Contrincante) :-
    jugador(Persona), jugador(Contrincante),
    Persona \= Contrincante.

contruyeMasCosas(Ganador, Perdedor) :-
    cantidadDeElementosQuePuedeConstruir(Ganador, Mayor),
    cantidadDeElementosQuePuedeConstruir(Perdedor, Menor),
    Mayor > Menor.

cantidadDeElementosQuePuedeConstruir(Persona, Cantidad) :-
    findall(Elemento, puedeConstruir(Persona, Elemento), Elementos),
    list_to_set(Elementos, ElementosSinRepetidos),
    length(ElementosSinRepetidos, Cantidad).
  
