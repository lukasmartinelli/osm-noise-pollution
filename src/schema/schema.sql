-------------------------------------------
DROP TABLE IF EXISTS public.countries CASCADE;
CREATE TABLE public.countries (
    name       varchar(30) NOT NULL,
    geometry   geometry NOT NULL
);

INSERT INTO public.countries
SELECT name, ST_UNION(geom) AS geometry
FROM import.swissboundaries3d_1_2_tlm_landesgebiet
GROUP BY name;
-------------------------------------------
DROP TABLE IF EXISTS public.cantons CASCADE;
CREATE TABLE public.cantons (
    id         integer PRIMARY KEY,
    name       varchar(30) NOT NULL,
    geometry   geometry NOT NULL
);

INSERT INTO public.cantons
SELECT kantonsnum AS id,
       name,
       ST_UNION(geom) AS geometry
FROM import.swissboundaries3d_1_2_tlm_kantonsgebiet
GROUP BY kantonsnum, name;

-------------------------------------------
DROP TABLE IF EXISTS public.districts CASCADE;
CREATE TABLE public.districts (
    id        integer PRIMARY KEY,
    canton_id integer REFERENCES public.cantons (id),
    name      varchar(50) NOT NULL,
    geometry   geometry NOT NULL
);

INSERT INTO public.districts
SELECT bezirksnum AS id,
       kantonsnum AS canton_id,
       name,
       ST_UNION(geom) AS geometry
FROM import.swissboundaries3d_1_2_tlm_bezirksgebiet
GROUP BY bezirksnum, kantonsnum, name;

-------------------------------------------
DROP TABLE IF EXISTS public.municipalities CASCADE;
CREATE TABLE public.municipalities (
    id          integer PRIMARY KEY,
    district_id integer REFERENCES public.districts (id),
    name        varchar(100) NOT NULL,
    geometry     geometry NOT NULL
);

INSERT INTO public.municipalities
SELECT bfs_nummer AS id,
       bezirksnum AS district_id,
       name,
       ST_UNION(geom) AS geometry
FROM import.swissboundaries3d_1_2_tlm_hoheitsgebiet
GROUP BY bfs_nummer, bezirksnum, name;
