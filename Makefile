.PHONY: all

all: postgres import-osm mapbox-studio export-vectortiles

postgres:
	docker build -t lukasmartinelli/osm-noise-pollution:postgres src/postgres

import-osm:
	docker build -t lukasmartinelli/osm-noise-pollution:import-osm src/import-osm

mapbox-studio:
	docker build -t lukasmartinelli/osm-noise-pollution:mapbox-studio src/mapbox-studio

export-vectortiles:
	docker build -t lukasmartinelli/osm-noise-pollution:export-vectortiles src/export-vectortiles
