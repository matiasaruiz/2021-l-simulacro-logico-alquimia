



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% Resolucion %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1. Modelar los jugadores y elementos y agregarlos a la base de conocimiento, utilizando los ejemplos provistos.

% tiene(Jugador, Elemento)
tiene(ana, [agua, agua, tierra, hierro]).
tiene(beto, [agua, agua, tierra, hierro]).
tiene(cata, [fuego, tierra, agua, aire]).

% receta(Elemento, [Ingredientes])
receta(pasto, [agua, tierra]).
receta(hierro, [fuego, agua, tierra]).
receta(huesos, [pasto, agua]).
receta(vapor, [agua, fuego]).
receta(presion, [hierro, vapor]).
receta(silicio, [tierra]).
receta(plastico, [hierro, vapor]).
receta(playStation, [silicio, hierro, plastico])


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
