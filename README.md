# osm-noise-pollution
Approximate global noise pollution with OSM data and simplified noise model from Cities Skylines

The city building simulation [Cities Skylines](https://en.wikipedia.org/wiki/Cities:_Skylines) has the [concept of noise pollution](http://www.skylineswiki.com/Pollution#Noise_pollution)
affecting the value of properties. Something that exists in the real world as well.
We want to apply this simplified model back to the real world using global street and landuse data from [OpenStreetMap](https://openstreetmap.org).

## Noise Pollution Model in Cities Skylines

> Roads, industry, commercial zones, and various buildings (such as power plants and unique buildings) cause sound pollution. A high level of noise pollution reduces land value and citizen happiness.

![Cities Skylines Noise pollution](http://www.skylineswiki.com/images/2/2d/Noise_Pollution_Info_View_SS.png)

## Noise Pollution Model for the Real World

Because we don't have global traffic data we approxmiate noise pollution by traffic with the [size of the roads](http://wiki.openstreetmap.org/wiki/Highways). Assuming roads with higher capacity will have more cars and therefore produce more noise pollution.

We cannot easily do the smooth levelling pollution spread that cities skylines does but we instead work
with multiple levels of noise pollution.
