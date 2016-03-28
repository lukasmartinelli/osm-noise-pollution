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

### Streets

We will work only with the [different highway tags](http://wiki.openstreetmap.org/wiki/Key:highway) ignoring speed limits
and country agnostic tags. The highway tags will control the noise pollution level emitted by the roads.

| Tag               | Noise Spread Level 1 | Noise Spread Level 2 | Noise Spread Level 3 |
|-------------------|----------------------|----------------------|----------------------|
| highway=motorway  | 50m                  | 100m                 | 150m                 |
| highway=trunk     | 40m                  | 70m                  | 100m                 |
| highway=primary   | 20m                  | 50m                  | 70m                  |
| highway=secondary | 10m                  | 20m                  | 30m                  |

## Develop

We use the Docker Compose based workflow we developed at [osm2vectortiles](https://github.com/osm2vectortiles/osm2vectortiles) to create an ETL workflow to get data in and out of PostGIS.

### Get Started

You need a complete OSM PBF data dump either from a [country extract](http://download.geofabrik.de/index.html) or of the [entire world](http://planet.osm.org/).

In this example we will work with my beloved Switzerland. Download the data and put it into the `data` directory.

```bash
wget --directory-prefix=./data http://download.geofabrik.de/europe/switzerland-latest.osm.pbf
```

Now we need to set up the database and import the data using the `import-osm` Docker container.

```bash
# This will automatically initialize the database
docker-compose up -d postgres

# Import the OSM data dump from the ./data folder
docker-compose run import-osm
```

Now let's import the SQL functions and views which analyse the OSM data.

```bash
docker-compose run schema
```

We can now export vector tiles containing the noise pollution geometries ready to
use for map visualizations with Mapnik or Mapbox GL.
If you want to change the export bounding box from Switzerland to a different
country you need to modify the `BBOX` env var in `docker-compose.yml`
for the `export-vectortiles` container.

```bash
docker-compose run export-vectortiles
```

And now we have all the data and code in place.
Let's look at it visually. Start Mapbox Studio and visit the port `3000` on your
Docker host.

```bash
docker-compose up mapbox-studio
```

Login and open the source project via `Browse` mounted at `/projects`. You should see `vector-datasource.tm2source`.
Open this project and navigate to the location of your extract to check the noise pollution visualized
in the vector data editor.


### Components

The different components that attach to the `postgres` container are all located in the `src` directory.

| Component         | Description
| postgres          | PostGIS data store for OSM data and to perform noise analysis
| import-osm        | Imposm3 based import tool with custom mapping to import selective OSM into the database and reconstruct it as GIS geometries
| schema            | Create views, functions and other tables from the imported data needed for the analysis.
| vector-datasource | Mapbox Studio Source project to generate vector tiles from the noise pollution geometries.
| export-vectortiles| Produce vector tiles for the noise pollution geometries from the `vector-datasource` using tilelive
| mapbox-studio     | Mapbox Studio in a Docker container with the mounted `vector-datasource` to interactively work with the vector tile project.
