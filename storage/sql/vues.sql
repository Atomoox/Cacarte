create materialized view public.geom_commune as
SELECT noeud_commune.gid,
       noeud_commune.geom
FROM noeud_commune;

alter materialized view public.geom_commune owner to tp1;

create index geom_commune_vue
    on public.geom_commune using gist (geom);

create index id_commune_vue
    on public.geom_commune (gid);

create materialized view public.geom_noeud_routier as
SELECT nr.gid,
       nr.geom
FROM noeud_routier nr;

alter materialized view public.geom_noeud_routier owner to tp1;

create index geom_noeud_routier_vue
    on public.geom_noeud_routier using gist (geom);

create index id_noeud_routier_vue
    on public.geom_noeud_routier (gid);

create materialized view public.geom_troncon_route as
SELECT troncon_route.gid,
       troncon_route.geom,
       troncon_route.longueur
FROM troncon_route;

alter materialized view public.geom_troncon_route owner to tp1;

create index geom_troncon_route_vue
    on public.geom_troncon_route using gist (geom);

create index id_troncon_route_vue
    on public.geom_troncon_route (gid);

create materialized view public.info_communes as
SELECT noeud_commune.gid,
       noeud_commune.id_rte500,
       noeud_commune.insee_comm,
       noeud_commune.nom_chf,
       noeud_commune.statut,
       noeud_commune.nom_comm,
       noeud_commune.superficie,
       noeud_commune.population,
       noeud_commune.id_nd_rte
FROM noeud_commune;

alter materialized view public.info_communes owner to tp1;

create index id_commune_vue_info
    on public.info_communes (gid);

create index nom_commune_vue_info
    on public.info_communes (nom_comm);

create materialized view public.info_noeud_routier as
SELECT nr.gid,
       nr.id_rte500,
       nr.nature,
       nr.insee_comm
FROM noeud_routier nr;

alter materialized view public.info_noeud_routier owner to tp1;

create index id_noeud_routier_vue_info
    on public.info_noeud_routier (gid);

create materialized view public.info_troncon_route as
SELECT troncon_route.gid,
       troncon_route.id_rte500,
       troncon_route.vocation,
       troncon_route.nb_chausse,
       troncon_route.nb_voies,
       troncon_route.etat,
       troncon_route.acces,
       troncon_route.res_vert,
       troncon_route.sens,
       troncon_route.num_route,
       troncon_route.res_europe,
       troncon_route.class_adm
FROM troncon_route;

alter materialized view public.info_troncon_route owner to tp1;

create index id_troncon_route_vue_info
    on public.info_troncon_route (gid);

create materialized view public.voisins_noeud as
SELECT nr1.gid AS noeud_routier,
       nr2.gid AS noeud_voisin,
       tr.gid  AS troncon_id,
       tr.longueur,
       tr.geom AS troncon_geom
FROM geom_troncon_route tr
         CROSS JOIN LATERAL ( SELECT nr.gid
                              FROM geom_noeud_routier nr
                              ORDER BY (nr.geom <-> st_startpoint(tr.geom))
                              LIMIT 1) nr1
         CROSS JOIN LATERAL ( SELECT nr.gid
                              FROM geom_noeud_routier nr
                              ORDER BY (nr.geom <-> st_endpoint(tr.geom))
                              LIMIT 1) nr2;

alter materialized view public.voisins_noeud owner to tp1;

create index id_noeud_routier_vue_voisin
    on public.voisins_noeud (noeud_routier);

create index id_noeud_voisin_vue_voisin
    on public.voisins_noeud (noeud_voisin);

create index id_troncon_vue_voisin
    on public.voisins_noeud (troncon_id);

create materialized view public.geom_noeud_routier_xy as
SELECT noeud_routier.gid,
       noeud_routier.geom,
       st_x(noeud_routier.geom) AS lon,
       st_y(noeud_routier.geom) AS lat
FROM noeud_routier;

alter materialized view public.geom_noeud_routier_xy owner to tp1;

create unique index ix_nr_xy_gid
    on public.geom_noeud_routier_xy (gid);

create materialized view public.voisins_noeud_ultra as
SELECT voisins_noeud.noeud_routier,
       voisins_noeud.noeud_voisin,
       voisins_noeud.troncon_id,
       voisins_noeud.longueur,
       voisins_noeud.troncon_geom,
       gnrx1.lat AS nr_lat,
       gnrx1.lon AS nr_lon,
       gnrx2.lat AS nv_lat,
       gnrx2.lon AS nv_lon
FROM voisins_noeud
         JOIN geom_noeud_routier_xy gnrx1 ON voisins_noeud.noeud_routier = gnrx1.gid
         JOIN geom_noeud_routier_xy gnrx2 ON voisins_noeud.noeud_voisin = gnrx2.gid
WHERE voisins_noeud.noeud_routier <> voisins_noeud.noeud_voisin;

alter materialized view public.voisins_noeud_ultra owner to tp1;

create index ix_nr
    on public.voisins_noeud_ultra (noeud_routier);

create index ix_nv
    on public.voisins_noeud_ultra (noeud_voisin);

create materialized view public.voisins_jsonb as
SELECT abc.gid,
       jsonb_agg(abc.json) AS voisins
FROM (SELECT voisins_noeud_ultra.noeud_routier                                                         AS gid,
             jsonb_build_object('lat', voisins_noeud_ultra.nv_lat, 'lon', voisins_noeud_ultra.nv_lon, 'length',
                                voisins_noeud_ultra.longueur, 'gid', voisins_noeud_ultra.noeud_voisin) AS json
      FROM voisins_noeud_ultra
      UNION
      SELECT voisins_noeud_ultra.noeud_voisin                                                           AS gid,
             jsonb_build_object('lat', voisins_noeud_ultra.nr_lat, 'lon', voisins_noeud_ultra.nr_lon, 'length',
                                voisins_noeud_ultra.longueur, 'gid', voisins_noeud_ultra.noeud_routier) AS json
      FROM voisins_noeud_ultra) abc
GROUP BY abc.gid;

alter materialized view public.voisins_jsonb owner to tp1;

create unique index ix_voisins_jsb
    on public.voisins_jsonb (gid);

create materialized view public.population_commune as
SELECT a.nom_comm,
       a.population
FROM info_communes a
WHERE NOT (EXISTS(SELECT b.gid,
                         b.id_rte500,
                         b.insee_comm,
                         b.nom_chf,
                         b.statut,
                         b.nom_comm,
                         b.superficie,
                         b.population,
                         b.id_nd_rte
                  FROM info_communes b
                  WHERE a.nom_comm::text = b.nom_comm::text
                    AND b.population > a.population));

alter materialized view public.population_commune owner to tp1;

create index ix_pop_comm
    on public.population_commune (nom_comm);

create materialized view public.superficie_commune as
SELECT a.nom_comm,
       a.superficie
FROM info_communes a
WHERE NOT (EXISTS(SELECT b.gid,
                         b.id_rte500,
                         b.insee_comm,
                         b.nom_chf,
                         b.statut,
                         b.nom_comm,
                         b.superficie,
                         b.population,
                         b.id_nd_rte
                  FROM info_communes b
                  WHERE a.nom_comm::text = b.nom_comm::text
                    AND b.superficie > a.superficie));

alter materialized view public.superficie_commune owner to tp1;

create index ix_sup_comm
    on public.superficie_commune (nom_comm);

create materialized view public.nom_to_gid as
SELECT comm.nom_comm,
       inr.gid
FROM info_communes comm
         JOIN info_noeud_routier inr ON comm.id_nd_rte::text = inr.id_rte500::text
WHERE comm.superficie = ((SELECT max(comm2.superficie) AS max
                          FROM info_communes comm2
                          WHERE comm2.nom_comm::text = comm.nom_comm::text));

alter materialized view public.nom_to_gid owner to tp1;


