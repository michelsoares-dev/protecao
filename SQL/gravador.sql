--
-- PostgreSQL database dump
--

-- Dumped from database version 9.4.26
-- Dumped by pg_dump version 9.5.5

-- Started on 2020-09-09 20:50:27

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 1 (class 3079 OID 12723)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2947 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 173 (class 1259 OID 16387)
-- Name: id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE id OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 174 (class 1259 OID 16389)
-- Name: gravacoes; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE gravacoes (
    id integer DEFAULT nextval('id'::regclass) NOT NULL,
    data date,
    hora time without time zone,
    ramal character varying(6),
    numero character varying(25),
    duracao time without time zone,
    tipo numeric(2,0),
    nome_op character varying(70),
    cliente character varying(100),
    assunto character varying(100),
    comentario character varying(300),
    observacoes_sup character varying(300),
    arquivo character varying(200)
);


ALTER TABLE gravacoes OWNER TO postgres;

--
-- TOC entry 175 (class 1259 OID 16396)
-- Name: gravacoes_bkup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE gravacoes_bkup (
    id integer NOT NULL,
    data date,
    hora time without time zone,
    ramal character varying(6),
    numero character varying(25),
    duracao time without time zone,
    tipo numeric(2,0),
    nome_op character varying(70),
    cliente character varying(100),
    assunto character varying(100),
    comentario character varying(200),
    observacoes_sup character varying(200),
    arquivo character varying(200),
    bkup_cd character varying(20)
);


ALTER TABLE gravacoes_bkup OWNER TO postgres;

--
-- TOC entry 176 (class 1259 OID 16402)
-- Name: id_grupo; Type: SEQUENCE; Schema: public; Owner: gravador
--

CREATE SEQUENCE id_grupo
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 99999999999
    CACHE 1;


ALTER TABLE id_grupo OWNER TO gravador;

--
-- TOC entry 177 (class 1259 OID 16404)
-- Name: grupos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE grupos (
    id integer DEFAULT nextval('id_grupo'::regclass) NOT NULL,
    grupo character varying(50) NOT NULL
);


ALTER TABLE grupos OWNER TO postgres;

--
-- TOC entry 178 (class 1259 OID 16408)
-- Name: id_ramal; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE id_ramal
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    MAXVALUE 100000000
    CACHE 1
    CYCLE;


ALTER TABLE id_ramal OWNER TO postgres;

--
-- TOC entry 179 (class 1259 OID 16410)
-- Name: logo; Type: TABLE; Schema: public; Owner: gravador
--

CREATE TABLE logo (
    id integer NOT NULL,
    file bytea
);


ALTER TABLE logo OWNER TO gravador;

--
-- TOC entry 180 (class 1259 OID 16416)
-- Name: monitor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE monitor (
    ramal character varying(5),
    estado integer,
    data date,
    hora time without time zone,
    log_user character varying(50),
    usuario character varying(50),
    tipo_rec integer,
    rxdtmf character varying(26),
    callerid character varying(26),
    duracao numeric(19,0),
    tipo character varying(5)
);


ALTER TABLE monitor OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 16419)
-- Name: ramais; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ramais (
    id integer DEFAULT nextval('id_ramal'::regclass) NOT NULL,
    ramal character varying(6) NOT NULL,
    nome character varying(32),
    rec_min integer NOT NULL,
    popup_min integer NOT NULL,
    popup_timeout integer NOT NULL,
    grupo character varying(50) NOT NULL,
    auto_popup boolean DEFAULT false
);


ALTER TABLE ramais OWNER TO postgres;

--
-- TOC entry 182 (class 1259 OID 16424)
-- Name: ramais_ana; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ramais_ana (
    id integer NOT NULL,
    ramal character varying(6),
    tipo_rec character varying(10)
);


ALTER TABLE ramais_ana OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 16427)
-- Name: ramais_dig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ramais_dig (
    id integer NOT NULL,
    ramal character varying(6)
);


ALTER TABLE ramais_dig OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 16430)
-- Name: ramais_ipbx; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE ramais_ipbx (
    id integer NOT NULL,
    ramal character varying(6)
);


ALTER TABLE ramais_ipbx OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 16433)
-- Name: tipo_lig; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tipo_lig (
    id integer,
    tipo character varying(10)
);


ALTER TABLE tipo_lig OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 16436)
-- Name: tipo_users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE tipo_users (
    id integer NOT NULL,
    tipo character varying(100)
);


ALTER TABLE tipo_users OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 16439)
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE usuarios (
    id integer NOT NULL,
    usuario character varying(50) NOT NULL,
    senha character varying(100),
    tipo integer,
    grupo character varying(5)
);


ALTER TABLE usuarios OWNER TO postgres;

--
-- TOC entry 2926 (class 0 OID 16389)
-- Dependencies: 174
-- Data for Name: gravacoes; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO gravacoes VALUES (0, '2000-01-01', '00:00:00', '', '', '00:00:00', 0, '', '', '', '', '', '');


--
-- TOC entry 2927 (class 0 OID 16396)
-- Dependencies: 175
-- Data for Name: gravacoes_bkup; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO gravacoes_bkup VALUES (0, '2007-01-01', '00:00:00', '', '0', '00:00:00', 0, '', '', '', '', '', '', '');


--
-- TOC entry 2929 (class 0 OID 16404)
-- Dependencies: 177
-- Data for Name: grupos; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO grupos VALUES (0, 'TODOS');
INSERT INTO grupos VALUES (1, 'NENHUM');


--
-- TOC entry 2961 (class 0 OID 0)
-- Dependencies: 173
-- Name: id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('id', 1, false);


--
-- TOC entry 2962 (class 0 OID 0)
-- Dependencies: 176
-- Name: id_grupo; Type: SEQUENCE SET; Schema: public; Owner: gravador
--

SELECT pg_catalog.setval('id_grupo', 1, false);


--
-- TOC entry 2963 (class 0 OID 0)
-- Dependencies: 178
-- Name: id_ramal; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('id_ramal', 1, false);


--
-- TOC entry 2931 (class 0 OID 16410)
-- Dependencies: 179
-- Data for Name: logo; Type: TABLE DATA; Schema: public; Owner: gravador
--



--
-- TOC entry 2932 (class 0 OID 16416)
-- Dependencies: 180
-- Data for Name: monitor; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2933 (class 0 OID 16419)
-- Dependencies: 181
-- Data for Name: ramais; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2934 (class 0 OID 16424)
-- Dependencies: 182
-- Data for Name: ramais_ana; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2935 (class 0 OID 16427)
-- Dependencies: 183
-- Data for Name: ramais_dig; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2936 (class 0 OID 16430)
-- Dependencies: 184
-- Data for Name: ramais_ipbx; Type: TABLE DATA; Schema: public; Owner: postgres
--



--
-- TOC entry 2937 (class 0 OID 16433)
-- Dependencies: 185
-- Data for Name: tipo_lig; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO tipo_lig VALUES (4, 'OUTROS');
INSERT INTO tipo_lig VALUES (2, 'SAIDA');
INSERT INTO tipo_lig VALUES (0, 'INTERNO');
INSERT INTO tipo_lig VALUES (1, 'ENTRADA');


--
-- TOC entry 2938 (class 0 OID 16436)
-- Dependencies: 186
-- Data for Name: tipo_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO tipo_users VALUES (2, 'SUPERVISOR');
INSERT INTO tipo_users VALUES (3, 'ADMINISTRADOR');
INSERT INTO tipo_users VALUES (1, 'ASSISTENTE');


--
-- TOC entry 2939 (class 0 OID 16439)
-- Dependencies: 187
-- Data for Name: usuarios; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO usuarios VALUES (8, 'ADM', '7aUHOHdcCq8=', 3, '0');


--
-- TOC entry 2803 (class 2606 OID 16443)
-- Name: logo_pkey; Type: CONSTRAINT; Schema: public; Owner: gravador
--

ALTER TABLE ONLY logo
    ADD CONSTRAINT logo_pkey PRIMARY KEY (id);


--
-- TOC entry 2807 (class 2606 OID 16445)
-- Name: ramais_ana_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ramais_ana
    ADD CONSTRAINT ramais_ana_pkey PRIMARY KEY (id);


--
-- TOC entry 2809 (class 2606 OID 16447)
-- Name: ramais_dig_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ramais_dig
    ADD CONSTRAINT ramais_dig_pkey PRIMARY KEY (id);


--
-- TOC entry 2811 (class 2606 OID 16449)
-- Name: ramais_ipbx_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ramais_ipbx
    ADD CONSTRAINT ramais_ipbx_pkey PRIMARY KEY (id);


--
-- TOC entry 2805 (class 2606 OID 16451)
-- Name: ramais_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY ramais
    ADD CONSTRAINT ramais_pkey PRIMARY KEY (ramal);


--
-- TOC entry 2813 (class 2606 OID 16453)
-- Name: tipo_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tipo_users
    ADD CONSTRAINT tipo_users_pkey PRIMARY KEY (id);


--
-- TOC entry 2815 (class 2606 OID 16455)
-- Name: usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (usuario);


--
-- TOC entry 2946 (class 0 OID 0)
-- Dependencies: 7
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 2948 (class 0 OID 0)
-- Dependencies: 173
-- Name: id; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE id FROM PUBLIC;
REVOKE ALL ON SEQUENCE id FROM postgres;
GRANT ALL ON SEQUENCE id TO postgres;
GRANT ALL ON SEQUENCE id TO gravador;


--
-- TOC entry 2949 (class 0 OID 0)
-- Dependencies: 174
-- Name: gravacoes; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE gravacoes FROM PUBLIC;
REVOKE ALL ON TABLE gravacoes FROM postgres;
GRANT ALL ON TABLE gravacoes TO postgres;
GRANT ALL ON TABLE gravacoes TO gravador;


--
-- TOC entry 2950 (class 0 OID 0)
-- Dependencies: 175
-- Name: gravacoes_bkup; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE gravacoes_bkup FROM PUBLIC;
REVOKE ALL ON TABLE gravacoes_bkup FROM postgres;
GRANT ALL ON TABLE gravacoes_bkup TO postgres;
GRANT ALL ON TABLE gravacoes_bkup TO gravador;


--
-- TOC entry 2951 (class 0 OID 0)
-- Dependencies: 176
-- Name: id_grupo; Type: ACL; Schema: public; Owner: gravador
--

REVOKE ALL ON SEQUENCE id_grupo FROM PUBLIC;
REVOKE ALL ON SEQUENCE id_grupo FROM gravador;
GRANT ALL ON SEQUENCE id_grupo TO gravador;


--
-- TOC entry 2952 (class 0 OID 0)
-- Dependencies: 177
-- Name: grupos; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE grupos FROM PUBLIC;
REVOKE ALL ON TABLE grupos FROM postgres;
GRANT ALL ON TABLE grupos TO postgres;
GRANT ALL ON TABLE grupos TO gravador;


--
-- TOC entry 2953 (class 0 OID 0)
-- Dependencies: 178
-- Name: id_ramal; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE id_ramal FROM PUBLIC;
REVOKE ALL ON SEQUENCE id_ramal FROM postgres;
GRANT ALL ON SEQUENCE id_ramal TO postgres;
GRANT ALL ON SEQUENCE id_ramal TO gravador;


--
-- TOC entry 2954 (class 0 OID 0)
-- Dependencies: 180
-- Name: monitor; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE monitor FROM PUBLIC;
REVOKE ALL ON TABLE monitor FROM postgres;
GRANT ALL ON TABLE monitor TO postgres;
GRANT ALL ON TABLE monitor TO gravador;


--
-- TOC entry 2955 (class 0 OID 0)
-- Dependencies: 181
-- Name: ramais; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE ramais FROM PUBLIC;
REVOKE ALL ON TABLE ramais FROM postgres;
GRANT ALL ON TABLE ramais TO postgres;
GRANT ALL ON TABLE ramais TO gravador;


--
-- TOC entry 2956 (class 0 OID 0)
-- Dependencies: 182
-- Name: ramais_ana; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE ramais_ana FROM PUBLIC;
REVOKE ALL ON TABLE ramais_ana FROM postgres;
GRANT ALL ON TABLE ramais_ana TO postgres;
GRANT ALL ON TABLE ramais_ana TO gravador;


--
-- TOC entry 2957 (class 0 OID 0)
-- Dependencies: 183
-- Name: ramais_dig; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE ramais_dig FROM PUBLIC;
REVOKE ALL ON TABLE ramais_dig FROM postgres;
GRANT ALL ON TABLE ramais_dig TO postgres;
GRANT ALL ON TABLE ramais_dig TO gravador;


--
-- TOC entry 2958 (class 0 OID 0)
-- Dependencies: 185
-- Name: tipo_lig; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tipo_lig FROM PUBLIC;
REVOKE ALL ON TABLE tipo_lig FROM postgres;
GRANT ALL ON TABLE tipo_lig TO postgres;
GRANT ALL ON TABLE tipo_lig TO gravador;


--
-- TOC entry 2959 (class 0 OID 0)
-- Dependencies: 186
-- Name: tipo_users; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tipo_users FROM PUBLIC;
REVOKE ALL ON TABLE tipo_users FROM postgres;
GRANT ALL ON TABLE tipo_users TO postgres;
GRANT ALL ON TABLE tipo_users TO gravador;


--
-- TOC entry 2960 (class 0 OID 0)
-- Dependencies: 187
-- Name: usuarios; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE usuarios FROM PUBLIC;
REVOKE ALL ON TABLE usuarios FROM postgres;
GRANT ALL ON TABLE usuarios TO postgres;
GRANT ALL ON TABLE usuarios TO gravador;


-- Completed on 2020-09-09 20:50:33

--
-- PostgreSQL database dump complete
--

