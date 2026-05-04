--
-- PostgreSQL database dump
--

-- Dumped from database version 13.0 (Debian 13.0-1.pgdg100+1)
-- Dumped by pg_dump version 13.0 (Debian 13.0-1.pgdg100+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: director; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.director (
    id integer,
    name character varying
);


ALTER TABLE public.director OWNER TO postgres;

--
-- Name: movie; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movie (
    title character varying,
    directorid integer,
    genre character varying
);


ALTER TABLE public.movie OWNER TO postgres;

--
-- Data for Name: director; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.director (id, name) FROM stdin;
1	firstDirector
2	secondDirector
3	thirdDirector
4	fourthDirector
5	fifthDirector
\.


--
-- Data for Name: movie; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movie (title, directorid, genre) FROM stdin;
firstMovieWithFirstDirector	1	scifi
secondMovieWithFirstDirector	1	action
thirdMovieWithFirstDirector	1	scifi
fourthMovieWithFirstDirector	1	scifi
firstMovieWithSecondDirector	2	comedy
secondMovieWithSecondDirector	2	scifi
firstMovieWithFourthDirector	4	scifi
firstMovieWithFifthDirector	5	horror
\.


--
-- PostgreSQL database dump complete
--

