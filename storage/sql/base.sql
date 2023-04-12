create extension postgis;

create table noeud_commune
(
    gid        serial
        primary key,
    id_rte500  varchar(24),
    insee_comm varchar(5),
    nom_chf    varchar(200),
    statut     varchar(30),
    nom_comm   varchar(100),
    superficie double precision,
    population double precision,
    id_nd_rte  varchar(24),
    geom       geometry(Point, 4326)
);

create table noeud_routier
(
    gid        serial
        primary key,
    id_rte500  varchar(24),
    nature     varchar(80),
    insee_comm varchar(5),
    geom       geometry(Point, 4326)
);

create table troncon_route
(
    gid        serial
        primary key,
    id_rte500  varchar(24),
    vocation   varchar(80),
    nb_chausse varchar(80), 
    nb_voies   varchar(80),
    etat       varchar(80),
    acces      varchar(80),
    res_vert   varchar(80),
    sens       varchar(80),
    num_route  varchar(24),
    res_europe varchar(200),
    longueur   double precision,
    class_adm  varchar(20),
    geom       geometry(LineString, 4326)
);

CREATE TABLE utilisateur (
  id SERIAL PRIMARY KEY,
  login VARCHAR(255) NOT NULL,
  nom VARCHAR(255) NOT NULL,
  prenom VARCHAR(255) NOT NULL,
  mdp_hache VARCHAR(255) NOT NULL,
  est_admin BOOLEAN NOT NULL,
  email VARCHAR(255) NOT NULL,
  email_a_valider VARCHAR(255) NOT NULL,
  nonce VARCHAR(255) NOT NULL
);

create table path_history (
    user_id varchar(255),
    date timestamp,
    depart varchar(255),
    arrivee varchar(255),
    distance float,
    PRIMARY KEY (user_id, date)
);

COPY noeud_commune
FROM '/var/data/noeud_commune.csv'
DELIMITER ';'
CSV HEADER;

COPY noeud_routier
FROM '/var/data/noeud_routier.csv'
DELIMITER ';'
CSV HEADER;

COPY troncon_route
FROM '/var/data/troncon_route.csv'
DELIMITER ';'
CSV HEADER;