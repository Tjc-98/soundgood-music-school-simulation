--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

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
-- Name: adminstrator; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adminstrator (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    person_number bigint NOT NULL,
    street character varying(100),
    city character varying(100),
    zip_code character varying(100)
);


ALTER TABLE public.adminstrator OWNER TO postgres;

--
-- Name: adminstrator_contact_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.adminstrator_contact_info (
    adminstrator_id integer NOT NULL,
    telefon_number character varying(25) NOT NULL,
    email_address character varying(100) NOT NULL
);


ALTER TABLE public.adminstrator_contact_info OWNER TO postgres;

--
-- Name: adminstrator_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.adminstrator_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.adminstrator_id_seq OWNER TO postgres;

--
-- Name: adminstrator_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.adminstrator_id_seq OWNED BY public.adminstrator.id;


--
-- Name: audition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audition (
    id integer NOT NULL,
    student_id integer NOT NULL,
    instructor_id integer NOT NULL,
    instrument_id integer NOT NULL,
    decision character varying(20) NOT NULL
);


ALTER TABLE public.audition OWNER TO postgres;

--
-- Name: instructor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    person_number bigint NOT NULL,
    street character varying(100) NOT NULL,
    city character varying(100) NOT NULL,
    zip_code integer NOT NULL
);


ALTER TABLE public.instructor OWNER TO postgres;

--
-- Name: available_instructors; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.available_instructors AS
 SELECT instructor.id,
    instructor.first_name,
    instructor.last_name,
    instructor.person_number
   FROM public.instructor
  GROUP BY instructor.id, instructor.first_name, instructor.last_name, instructor.person_number
  ORDER BY instructor.last_name, instructor.first_name;


ALTER TABLE public.available_instructors OWNER TO postgres;

--
-- Name: ensemble; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ensemble (
    id integer NOT NULL,
    genre character varying(100) NOT NULL,
    instructor_id integer NOT NULL,
    minimum_enrolled_students smallint NOT NULL,
    maximum_enrolled_students smallint NOT NULL,
    enrolled_students smallint NOT NULL,
    number_of_instruments smallint NOT NULL,
    ensemble_level character varying(15) NOT NULL
);


ALTER TABLE public.ensemble OWNER TO postgres;

--
-- Name: ensemble_schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ensemble_schedule (
    id integer NOT NULL,
    ensemble_id integer NOT NULL,
    start_date timestamp without time zone NOT NULL,
    week_day character varying(15)
);


ALTER TABLE public.ensemble_schedule OWNER TO postgres;

--
-- Name: average_ensembles; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.average_ensembles AS
 SELECT date_part('year'::text, ensemble_schedule.start_date) AS year,
    (((count(ensemble_schedule.id))::numeric / (12)::numeric))::numeric(1000,0) AS average_ensembles
   FROM public.ensemble_schedule,
    public.ensemble
  WHERE (ensemble_schedule.ensemble_id = ensemble.id)
  GROUP BY (date_part('year'::text, ensemble_schedule.start_date))
  ORDER BY (date_part('year'::text, ensemble_schedule.start_date));


ALTER TABLE public.average_ensembles OWNER TO postgres;

--
-- Name: lesson; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesson (
    id integer NOT NULL,
    instructor_id integer NOT NULL,
    instrument_kind character varying(15) NOT NULL,
    lesson_type character varying(15) NOT NULL,
    minimum_number_of_students smallint NOT NULL,
    maximum_number_of_students smallint NOT NULL,
    enrolled_students_number smallint NOT NULL,
    lesson_level character varying(15) NOT NULL
);


ALTER TABLE public.lesson OWNER TO postgres;

--
-- Name: lesson_schedule; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesson_schedule (
    id integer NOT NULL,
    lesson_id integer NOT NULL,
    start_date timestamp without time zone NOT NULL,
    week_day character varying(15) NOT NULL
);


ALTER TABLE public.lesson_schedule OWNER TO postgres;

--
-- Name: average_group_lessons; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.average_group_lessons AS
 SELECT date_part('year'::text, lesson_schedule.start_date) AS year,
    (((count(lesson_schedule.id))::numeric / (12)::numeric))::numeric(1000,0) AS average_group_lessons
   FROM public.lesson_schedule,
    public.lesson
  WHERE ((lesson_schedule.lesson_id = lesson.id) AND ((lesson.lesson_type)::text = 'group'::text))
  GROUP BY (date_part('year'::text, lesson_schedule.start_date))
  ORDER BY (date_part('year'::text, lesson_schedule.start_date));


ALTER TABLE public.average_group_lessons OWNER TO postgres;

--
-- Name: average_ind_lessons; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.average_ind_lessons AS
 SELECT date_part('year'::text, lesson_schedule.start_date) AS year,
    (((count(lesson_schedule.id))::numeric / (12)::numeric))::numeric(1000,0) AS average_ind_lessons
   FROM public.lesson_schedule,
    public.lesson
  WHERE ((lesson_schedule.lesson_id = lesson.id) AND ((lesson.lesson_type)::text = 'individual'::text))
  GROUP BY (date_part('year'::text, lesson_schedule.start_date))
  ORDER BY (date_part('year'::text, lesson_schedule.start_date));


ALTER TABLE public.average_ind_lessons OWNER TO postgres;

--
-- Name: instrument; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument (
    id integer NOT NULL,
    kind character varying(100) NOT NULL,
    type character varying(100) NOT NULL,
    condition character varying(100),
    brand character varying(100)
);


ALTER TABLE public.instrument OWNER TO postgres;

--
-- Name: instrument_rental; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instrument_rental (
    id integer NOT NULL,
    instrument_id integer NOT NULL,
    student_id integer NOT NULL,
    rental_date date NOT NULL,
    return_date date NOT NULL,
    rental_period smallint NOT NULL,
    delivery_method character varying(20) NOT NULL,
    terminated boolean NOT NULL,
    date_of_termination date
);


ALTER TABLE public.instrument_rental OWNER TO postgres;

--
-- Name: average_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.average_rentals AS
 SELECT date_part('year'::text, instrument_rental.rental_date) AS year,
    (((count(instrument_rental.id))::numeric / (12)::numeric))::numeric(1000,2) AS average_rental
   FROM public.instrument_rental,
    public.instrument
  WHERE (instrument_rental.instrument_id = instrument.id)
  GROUP BY (date_part('year'::text, instrument_rental.rental_date))
  ORDER BY (date_part('year'::text, instrument_rental.rental_date));


ALTER TABLE public.average_rentals OWNER TO postgres;

--
-- Name: clarinet_average_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.clarinet_average_rentals AS
 SELECT date_part('year'::text, instrument_rental.rental_date) AS year,
    (((count(instrument_rental.id))::numeric / (12)::numeric))::numeric(1000,2) AS clarinet_average_rental
   FROM public.instrument_rental,
    public.instrument
  WHERE ((instrument_rental.instrument_id = instrument.id) AND ((instrument.kind)::text = 'Clarinet'::text))
  GROUP BY (date_part('year'::text, instrument_rental.rental_date))
  ORDER BY (date_part('year'::text, instrument_rental.rental_date));


ALTER TABLE public.clarinet_average_rentals OWNER TO postgres;

--
-- Name: clarinet_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.clarinet_rentals AS
 SELECT date_part('year'::text, instrument_rental.rental_date) AS year,
    date_part('month'::text, instrument_rental.rental_date) AS month,
    count(instrument_rental.id) AS clarinet_rental_kind,
    instrument.kind AS istrument_kind
   FROM public.instrument_rental,
    public.instrument
  WHERE (instrument_rental.instrument_id = instrument.id)
  GROUP BY (date_part('year'::text, instrument_rental.rental_date)), (date_part('month'::text, instrument_rental.rental_date)), instrument.kind
 HAVING ((instrument.kind)::text = 'Clarinet'::text)
  ORDER BY (date_part('year'::text, instrument_rental.rental_date)), (date_part('month'::text, instrument_rental.rental_date));


ALTER TABLE public.clarinet_rentals OWNER TO postgres;

--
-- Name: drums_average_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.drums_average_rentals AS
 SELECT date_part('year'::text, instrument_rental.rental_date) AS year,
    (((count(instrument_rental.id))::numeric / (12)::numeric))::numeric(1000,2) AS drums_average_rental
   FROM public.instrument_rental,
    public.instrument
  WHERE ((instrument_rental.instrument_id = instrument.id) AND ((instrument.kind)::text = 'Drums'::text))
  GROUP BY (date_part('year'::text, instrument_rental.rental_date))
  ORDER BY (date_part('year'::text, instrument_rental.rental_date));


ALTER TABLE public.drums_average_rentals OWNER TO postgres;

--
-- Name: drums_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.drums_rentals AS
 SELECT date_part('year'::text, instrument_rental.rental_date) AS year,
    date_part('month'::text, instrument_rental.rental_date) AS month,
    count(instrument_rental.id) AS drums_rental_kind,
    instrument.kind AS istrument_kind
   FROM public.instrument_rental,
    public.instrument
  WHERE (instrument_rental.instrument_id = instrument.id)
  GROUP BY (date_part('year'::text, instrument_rental.rental_date)), (date_part('month'::text, instrument_rental.rental_date)), instrument.kind
 HAVING ((instrument.kind)::text = 'Drums'::text)
  ORDER BY (date_part('year'::text, instrument_rental.rental_date)), (date_part('month'::text, instrument_rental.rental_date));


ALTER TABLE public.drums_rentals OWNER TO postgres;

--
-- Name: ensemble_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ensemble_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ensemble_id_seq OWNER TO postgres;

--
-- Name: ensemble_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ensemble_id_seq OWNED BY public.ensemble.id;


--
-- Name: ensmeble_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ensmeble_schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ensmeble_schedule_id_seq OWNER TO postgres;

--
-- Name: ensmeble_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ensmeble_schedule_id_seq OWNED BY public.ensemble_schedule.id;


--
-- Name: given_ensembles_by_instructor; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.given_ensembles_by_instructor AS
 SELECT date_part('year'::text, ensemble_schedule.start_date) AS year,
    date_part('month'::text, ensemble_schedule.start_date) AS month,
    instructor.id,
    instructor.first_name,
    instructor.last_name,
    instructor.person_number,
    count(ensemble_schedule.ensemble_id) AS total_given_ensembles
   FROM ((public.instructor
     JOIN public.ensemble ON ((ensemble.instructor_id = instructor.id)))
     JOIN public.ensemble_schedule ON ((ensemble.id = ensemble_schedule.ensemble_id)))
  WHERE ((date_part('year'::text, ensemble_schedule.start_date) = date_part('year'::text, CURRENT_DATE)) AND (date_part('month'::text, ensemble_schedule.start_date) = date_part('month'::text, CURRENT_DATE)))
  GROUP BY (date_part('year'::text, ensemble_schedule.start_date)), (date_part('month'::text, ensemble_schedule.start_date)), instructor.id, instructor.first_name, instructor.last_name, instructor.person_number
  ORDER BY (count(ensemble_schedule.ensemble_id)) DESC;


ALTER TABLE public.given_ensembles_by_instructor OWNER TO postgres;

--
-- Name: given_ensembles_by_instructor_previous_month; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.given_ensembles_by_instructor_previous_month AS
 SELECT date_part('year'::text, ensemble_schedule.start_date) AS year,
    date_part('month'::text, ensemble_schedule.start_date) AS month,
    instructor.id,
    instructor.first_name,
    instructor.last_name,
    instructor.person_number,
    count(ensemble_schedule.ensemble_id) AS total_given_ensembles
   FROM ((public.instructor
     JOIN public.ensemble ON ((ensemble.instructor_id = instructor.id)))
     JOIN public.ensemble_schedule ON ((ensemble.id = ensemble_schedule.ensemble_id)))
  WHERE ((date_part('year'::text, ensemble_schedule.start_date) = date_part('year'::text, (CURRENT_DATE - '1 mon'::interval))) AND (date_part('month'::text, ensemble_schedule.start_date) = date_part('month'::text, (CURRENT_DATE - '1 mon'::interval))))
  GROUP BY (date_part('year'::text, ensemble_schedule.start_date)), (date_part('month'::text, ensemble_schedule.start_date)), instructor.id, instructor.first_name, instructor.last_name, instructor.person_number
  ORDER BY (count(ensemble_schedule.ensemble_id)) DESC;


ALTER TABLE public.given_ensembles_by_instructor_previous_month OWNER TO postgres;

--
-- Name: given_lessons; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.given_lessons AS
 SELECT date_part('year'::text, lesson_schedule.start_date) AS year,
    date_part('month'::text, lesson_schedule.start_date) AS month,
    count(lesson_schedule.id) AS given_lessons
   FROM public.lesson_schedule
  GROUP BY (date_part('year'::text, lesson_schedule.start_date)), (date_part('month'::text, lesson_schedule.start_date))
  ORDER BY (date_part('year'::text, lesson_schedule.start_date)), (date_part('month'::text, lesson_schedule.start_date));


ALTER TABLE public.given_lessons OWNER TO postgres;

--
-- Name: given_lessons_by_instructor; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.given_lessons_by_instructor AS
 SELECT date_part('year'::text, lesson_schedule.start_date) AS year,
    date_part('month'::text, lesson_schedule.start_date) AS month,
    instructor.id,
    instructor.first_name,
    instructor.last_name,
    instructor.person_number,
    count(lesson_schedule.lesson_id) AS total_given_lessons
   FROM ((public.instructor
     JOIN public.lesson ON ((lesson.instructor_id = instructor.id)))
     JOIN public.lesson_schedule ON ((lesson.id = lesson_schedule.lesson_id)))
  WHERE ((date_part('year'::text, lesson_schedule.start_date) = date_part('year'::text, CURRENT_DATE)) AND (date_part('month'::text, lesson_schedule.start_date) = date_part('month'::text, CURRENT_DATE)))
  GROUP BY (date_part('year'::text, lesson_schedule.start_date)), (date_part('month'::text, lesson_schedule.start_date)), instructor.id, instructor.first_name, instructor.last_name, instructor.person_number
  ORDER BY (count(lesson_schedule.lesson_id)) DESC;


ALTER TABLE public.given_lessons_by_instructor OWNER TO postgres;

--
-- Name: given_lessons_by_instructor_previous_month; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.given_lessons_by_instructor_previous_month AS
 SELECT date_part('year'::text, lesson_schedule.start_date) AS year,
    date_part('month'::text, lesson_schedule.start_date) AS month,
    instructor.first_name,
    instructor.id,
    instructor.last_name,
    instructor.person_number,
    count(lesson_schedule.lesson_id) AS total_given_lessons
   FROM ((public.instructor
     JOIN public.lesson ON ((lesson.instructor_id = instructor.id)))
     JOIN public.lesson_schedule ON ((lesson.id = lesson_schedule.lesson_id)))
  WHERE ((date_part('year'::text, lesson_schedule.start_date) = date_part('year'::text, (CURRENT_DATE - '1 mon'::interval))) AND (date_part('month'::text, lesson_schedule.start_date) = date_part('month'::text, (CURRENT_DATE - '1 mon'::interval))))
  GROUP BY (date_part('year'::text, lesson_schedule.start_date)), (date_part('month'::text, lesson_schedule.start_date)), instructor.id, instructor.first_name, instructor.last_name, instructor.person_number
  ORDER BY (count(lesson_schedule.lesson_id)) DESC;


ALTER TABLE public.given_lessons_by_instructor_previous_month OWNER TO postgres;

--
-- Name: group_total_given_lessons; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.group_total_given_lessons AS
 SELECT date_part('year'::text, lesson_schedule.start_date) AS year,
    date_part('month'::text, lesson_schedule.start_date) AS month,
    count(lesson_schedule.id) AS given_lessons,
    lesson.lesson_type
   FROM public.lesson,
    public.lesson_schedule
  WHERE ((lesson_schedule.lesson_id = lesson.id) AND ((lesson.lesson_type)::text = 'group'::text))
  GROUP BY (date_part('year'::text, lesson_schedule.start_date)), (date_part('month'::text, lesson_schedule.start_date)), lesson.lesson_type
  ORDER BY (date_part('year'::text, lesson_schedule.start_date)), (date_part('month'::text, lesson_schedule.start_date));


ALTER TABLE public.group_total_given_lessons OWNER TO postgres;

--
-- Name: individual_total_given_lessons; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.individual_total_given_lessons AS
 SELECT date_part('year'::text, lesson_schedule.start_date) AS year,
    date_part('month'::text, lesson_schedule.start_date) AS month,
    count(lesson_schedule.id) AS given_lessons,
    lesson.lesson_type
   FROM public.lesson,
    public.lesson_schedule
  WHERE ((lesson_schedule.lesson_id = lesson.id) AND ((lesson.lesson_type)::text = 'individual'::text))
  GROUP BY (date_part('year'::text, lesson_schedule.start_date)), (date_part('month'::text, lesson_schedule.start_date)), lesson.lesson_type
  ORDER BY (date_part('year'::text, lesson_schedule.start_date)), (date_part('month'::text, lesson_schedule.start_date));


ALTER TABLE public.individual_total_given_lessons OWNER TO postgres;

--
-- Name: instructor_contact_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor_contact_info (
    instructor_id integer NOT NULL,
    telefon_number bigint NOT NULL,
    email_address character varying(100) NOT NULL
);


ALTER TABLE public.instructor_contact_info OWNER TO postgres;

--
-- Name: instructor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instructor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instructor_id_seq OWNER TO postgres;

--
-- Name: instructor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instructor_id_seq OWNED BY public.instructor.id;


--
-- Name: instructor_salary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructor_salary (
    instructor_id integer NOT NULL,
    lesson_schedule_id integer,
    ensemble_schedule_id integer
);


ALTER TABLE public.instructor_salary OWNER TO postgres;

--
-- Name: instrument_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instrument_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instrument_id_seq OWNER TO postgres;

--
-- Name: instrument_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrument_id_seq OWNED BY public.instrument.id;


--
-- Name: stock; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.stock (
    instrument_id integer NOT NULL,
    amount integer NOT NULL,
    instrument_rental_fee smallint NOT NULL,
    rented_instruments smallint NOT NULL
);


ALTER TABLE public.stock OWNER TO postgres;

--
-- Name: instrument_lowest_monthly_fee; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.instrument_lowest_monthly_fee AS
 SELECT data1.instrument_kind,
    data1.instrument_fee,
    data1.lesson_type,
    data1.start_date,
    data1.available_instruments
   FROM ( SELECT DISTINCT ON (lesson.instrument_kind) lesson.instrument_kind,
            stock.instrument_rental_fee AS instrument_fee,
            lesson.lesson_type,
            lesson_schedule.start_date,
                CASE
                    WHEN ((stock.amount - stock.rented_instruments) = 0) THEN 'Not available'::text
                    ELSE 'Available'::text
                END AS available_instruments
           FROM ((((public.instrument_rental
             JOIN public.instrument ON ((instrument_rental.instrument_id = instrument.id)))
             JOIN public.stock ON ((instrument.id = stock.instrument_id)))
             JOIN public.lesson ON (((lesson.instrument_kind)::text = (instrument.kind)::text)))
             JOIN public.lesson_schedule ON ((lesson_schedule.lesson_id = lesson.id)))
          WHERE ((lesson_schedule.start_date >= CURRENT_DATE) AND ((lesson.lesson_type)::text = 'group'::text))
          ORDER BY lesson.instrument_kind, lesson_schedule.start_date, stock.instrument_rental_fee) data1
  ORDER BY data1.instrument_fee
 LIMIT 3
  WITH NO DATA;


ALTER TABLE public.instrument_lowest_monthly_fee OWNER TO postgres;

--
-- Name: instrument_rental_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.instrument_rental_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instrument_rental_id_seq OWNER TO postgres;

--
-- Name: instrument_rental_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.instrument_rental_id_seq OWNED BY public.instrument_rental.id;


--
-- Name: lesson_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lesson_id_seq OWNER TO postgres;

--
-- Name: lesson_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_id_seq OWNED BY public.lesson.id;


--
-- Name: lesson_price; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.lesson_price (
    id integer NOT NULL,
    lesson_id integer NOT NULL,
    lesson_price smallint NOT NULL
);


ALTER TABLE public.lesson_price OWNER TO postgres;

--
-- Name: lesson_price_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_price_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lesson_price_id_seq OWNER TO postgres;

--
-- Name: lesson_price_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_price_id_seq OWNED BY public.lesson_price.id;


--
-- Name: lesson_schedule_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.lesson_schedule_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lesson_schedule_id_seq OWNER TO postgres;

--
-- Name: lesson_schedule_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.lesson_schedule_id_seq OWNED BY public.lesson_schedule.id;


--
-- Name: next_week_ensembles_list; Type: MATERIALIZED VIEW; Schema: public; Owner: postgres
--

CREATE MATERIALIZED VIEW public.next_week_ensembles_list AS
 SELECT ensemble.id,
    ensemble_schedule.week_day,
    ensemble_schedule.start_date,
    ensemble.genre,
        CASE
            WHEN ((ensemble.maximum_enrolled_students - ensemble.enrolled_students) = 0) THEN 'Full booked'::text
            WHEN (((ensemble.maximum_enrolled_students - ensemble.enrolled_students) = 1) OR ((ensemble.maximum_enrolled_students - ensemble.enrolled_students) = 2)) THEN '1-2 seats'::text
            ELSE 'has more seats left'::text
        END AS available_seats
   FROM (public.ensemble_schedule
     JOIN public.ensemble ON ((ensemble_schedule.ensemble_id = ensemble.id)))
  WHERE ((ensemble_schedule.start_date <= (CURRENT_DATE + '14 days'::interval)) AND (ensemble_schedule.start_date >= (CURRENT_DATE + '7 days'::interval)))
  ORDER BY ensemble.genre, ensemble_schedule.start_date
  WITH NO DATA;


ALTER TABLE public.next_week_ensembles_list OWNER TO postgres;

--
-- Name: parent; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.parent (
    student_id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    person_number bigint NOT NULL,
    street character varying(100),
    city character varying(100),
    zip_code integer,
    telefon_number bigint NOT NULL,
    email_address character varying(100)
);


ALTER TABLE public.parent OWNER TO postgres;

--
-- Name: piano_average_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.piano_average_rentals AS
 SELECT date_part('year'::text, instrument_rental.rental_date) AS year,
    (((count(instrument_rental.id))::numeric / (12)::numeric))::numeric(1000,2) AS piano_average_rental
   FROM public.instrument_rental,
    public.instrument
  WHERE ((instrument_rental.instrument_id = instrument.id) AND ((instrument.kind)::text = 'Piano'::text))
  GROUP BY (date_part('year'::text, instrument_rental.rental_date))
  ORDER BY (date_part('year'::text, instrument_rental.rental_date));


ALTER TABLE public.piano_average_rentals OWNER TO postgres;

--
-- Name: piano_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.piano_rentals AS
 SELECT date_part('year'::text, instrument_rental.rental_date) AS year,
    date_part('month'::text, instrument_rental.rental_date) AS month,
    count(instrument_rental.id) AS piano_rental_kind,
    instrument.kind AS istrument_kind
   FROM public.instrument_rental,
    public.instrument
  WHERE (instrument_rental.instrument_id = instrument.id)
  GROUP BY (date_part('year'::text, instrument_rental.rental_date)), (date_part('month'::text, instrument_rental.rental_date)), instrument.kind
 HAVING ((instrument.kind)::text = 'Piano'::text)
  ORDER BY (date_part('year'::text, instrument_rental.rental_date)), (date_part('month'::text, instrument_rental.rental_date));


ALTER TABLE public.piano_rentals OWNER TO postgres;

--
-- Name: saxophone_average_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.saxophone_average_rentals AS
 SELECT date_part('year'::text, instrument_rental.rental_date) AS year,
    (((count(instrument_rental.id))::numeric / (12)::numeric))::numeric(1000,2) AS saxophone_average_rental
   FROM public.instrument_rental,
    public.instrument
  WHERE ((instrument_rental.instrument_id = instrument.id) AND ((instrument.kind)::text = 'Saxophone'::text))
  GROUP BY (date_part('year'::text, instrument_rental.rental_date))
  ORDER BY (date_part('year'::text, instrument_rental.rental_date));


ALTER TABLE public.saxophone_average_rentals OWNER TO postgres;

--
-- Name: saxophone_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.saxophone_rentals AS
 SELECT date_part('year'::text, instrument_rental.rental_date) AS year,
    date_part('month'::text, instrument_rental.rental_date) AS month,
    count(instrument_rental.id) AS saxophone_rental_kind,
    instrument.kind AS istrument_kind
   FROM public.instrument_rental,
    public.instrument
  WHERE (instrument_rental.instrument_id = instrument.id)
  GROUP BY (date_part('year'::text, instrument_rental.rental_date)), (date_part('month'::text, instrument_rental.rental_date)), instrument.kind
 HAVING ((instrument.kind)::text = 'Saxophone'::text)
  ORDER BY (date_part('year'::text, instrument_rental.rental_date)), (date_part('month'::text, instrument_rental.rental_date));


ALTER TABLE public.saxophone_rentals OWNER TO postgres;

--
-- Name: siblings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.siblings (
    id integer NOT NULL,
    student_id integer NOT NULL,
    sibling_id integer NOT NULL
);


ALTER TABLE public.siblings OWNER TO postgres;

--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student (
    id integer NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    person_number bigint NOT NULL,
    age smallint NOT NULL,
    skill_level character varying(25) NOT NULL,
    street character varying(50) NOT NULL,
    city character varying(50) NOT NULL,
    zip_code integer NOT NULL,
    instrument_kind character varying(100) NOT NULL
);


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: student_application; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_application (
    id integer NOT NULL,
    student_id integer NOT NULL,
    enrollment_date date NOT NULL
);


ALTER TABLE public.student_application OWNER TO postgres;

--
-- Name: student_application_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_application_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_application_id_seq OWNER TO postgres;

--
-- Name: student_application_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_application_id_seq OWNED BY public.student_application.id;


--
-- Name: student_contact_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_contact_info (
    student_id integer NOT NULL,
    telefon_number bigint NOT NULL,
    email_address character varying(100)
);


ALTER TABLE public.student_contact_info OWNER TO postgres;

--
-- Name: student_payment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_payment (
    id integer NOT NULL,
    student_id integer NOT NULL,
    individual_lessons_amount smallint,
    advanced_lessons_amount smallint,
    ensembles_amount smallint,
    group_lessons_amount smallint,
    weekend_lessons_amount smallint,
    payment_date date
);


ALTER TABLE public.student_payment OWNER TO postgres;

--
-- Name: student_payment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_payment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_payment_id_seq OWNER TO postgres;

--
-- Name: student_payment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_payment_id_seq OWNED BY public.student_payment.id;


--
-- Name: student_student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_student_id_seq OWNER TO postgres;

--
-- Name: student_student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_student_id_seq OWNED BY public.student.id;


--
-- Name: table_average_all_lessons; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.table_average_all_lessons AS
 SELECT date_part('year'::text, lesson_schedule.start_date) AS year
   FROM public.lesson_schedule,
    public.lesson
  GROUP BY (date_part('year'::text, lesson_schedule.start_date))
  ORDER BY (date_part('year'::text, lesson_schedule.start_date));


ALTER TABLE public.table_average_all_lessons OWNER TO postgres;

--
-- Name: total_given_ensembles; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.total_given_ensembles AS
 SELECT date_part('year'::text, ensemble_schedule.start_date) AS ensemble_year,
    date_part('month'::text, ensemble_schedule.start_date) AS ensemble_month,
    count(ensemble_schedule.id) AS given_ensembles,
    'ensembles'::text AS ensemble_type
   FROM public.ensemble,
    public.ensemble_schedule
  WHERE (ensemble_schedule.ensemble_id = ensemble.id)
  GROUP BY (date_part('year'::text, ensemble_schedule.start_date)), (date_part('month'::text, ensemble_schedule.start_date)), 'ensembles'::text
  ORDER BY (date_part('year'::text, ensemble_schedule.start_date)), (date_part('month'::text, ensemble_schedule.start_date));


ALTER TABLE public.total_given_ensembles OWNER TO postgres;

--
-- Name: total_given_lessons_by_instructor; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.total_given_lessons_by_instructor AS
 SELECT given_lessons_by_instructor.year,
    given_lessons_by_instructor.month
   FROM public.given_lessons_by_instructor
  GROUP BY given_lessons_by_instructor.year, given_lessons_by_instructor.month
 HAVING (given_lessons_by_instructor.year = date_part('year'::text, CURRENT_DATE))
  ORDER BY given_lessons_by_instructor.year;


ALTER TABLE public.total_given_lessons_by_instructor OWNER TO postgres;

--
-- Name: total_given_lessons_by_instructor_current_month; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.total_given_lessons_by_instructor_current_month AS
 SELECT given_lessons_by_instructor.first_name,
    given_lessons_by_instructor.last_name,
    given_lessons_by_instructor.person_number,
    instructor.id,
    (given_lessons_by_instructor.total_given_lessons + given_ensembles_by_instructor.total_given_ensembles) AS total_lessons_for_current_month
   FROM public.given_ensembles_by_instructor,
    public.given_lessons_by_instructor,
    public.instructor
  WHERE ((instructor.id = given_lessons_by_instructor.id) AND (instructor.id = given_ensembles_by_instructor.id))
  GROUP BY (given_lessons_by_instructor.total_given_lessons + given_ensembles_by_instructor.total_given_ensembles), given_lessons_by_instructor.first_name, given_lessons_by_instructor.last_name, given_lessons_by_instructor.person_number, instructor.id
  ORDER BY (given_lessons_by_instructor.total_given_lessons + given_ensembles_by_instructor.total_given_ensembles) DESC;


ALTER TABLE public.total_given_lessons_by_instructor_current_month OWNER TO postgres;

--
-- Name: total_given_lessons_by_instructor_previous_month; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.total_given_lessons_by_instructor_previous_month AS
 SELECT instructor.id,
    given_lessons_by_instructor_previous_month.first_name,
    given_lessons_by_instructor_previous_month.last_name,
    given_lessons_by_instructor_previous_month.person_number,
    (given_lessons_by_instructor_previous_month.total_given_lessons + given_ensembles_by_instructor_previous_month.total_given_ensembles) AS total_lessons_for_previous_month
   FROM public.instructor,
    public.given_lessons_by_instructor_previous_month,
    public.given_ensembles_by_instructor_previous_month
  WHERE ((instructor.id = given_lessons_by_instructor_previous_month.id) AND (instructor.id = given_ensembles_by_instructor_previous_month.id))
  GROUP BY (given_lessons_by_instructor_previous_month.total_given_lessons + given_ensembles_by_instructor_previous_month.total_given_ensembles), given_lessons_by_instructor_previous_month.first_name, given_lessons_by_instructor_previous_month.last_name, given_lessons_by_instructor_previous_month.person_number, instructor.id
  ORDER BY (given_lessons_by_instructor_previous_month.total_given_lessons + given_ensembles_by_instructor_previous_month.total_given_ensembles) DESC
 LIMIT 3;


ALTER TABLE public.total_given_lessons_by_instructor_previous_month OWNER TO postgres;

--
-- Name: total_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.total_rentals AS
 SELECT date_part('year'::text, instrument_rental.rental_date) AS year,
    date_part('month'::text, instrument_rental.rental_date) AS month,
    count(instrument_rental.id) AS total_rentals
   FROM public.instrument_rental
  GROUP BY (date_part('year'::text, instrument_rental.rental_date)), (date_part('month'::text, instrument_rental.rental_date))
  ORDER BY (date_part('year'::text, instrument_rental.rental_date));


ALTER TABLE public.total_rentals OWNER TO postgres;

--
-- Name: trumpet_average_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trumpet_average_rentals AS
 SELECT date_part('year'::text, instrument_rental.rental_date) AS year,
    (((count(instrument_rental.id))::numeric / (12)::numeric))::numeric(1000,2) AS trumpet_average_rental
   FROM public.instrument_rental,
    public.instrument
  WHERE ((instrument_rental.instrument_id = instrument.id) AND ((instrument.kind)::text = 'Trumpet'::text))
  GROUP BY (date_part('year'::text, instrument_rental.rental_date))
  ORDER BY (date_part('year'::text, instrument_rental.rental_date));


ALTER TABLE public.trumpet_average_rentals OWNER TO postgres;

--
-- Name: trumpet_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.trumpet_rentals AS
 SELECT date_part('year'::text, instrument_rental.rental_date) AS year,
    date_part('month'::text, instrument_rental.rental_date) AS month,
    count(instrument_rental.id) AS trumpet_rental_kind,
    instrument.kind AS istrument_kind
   FROM public.instrument_rental,
    public.instrument
  WHERE (instrument_rental.instrument_id = instrument.id)
  GROUP BY (date_part('year'::text, instrument_rental.rental_date)), (date_part('month'::text, instrument_rental.rental_date)), instrument.kind
 HAVING ((instrument.kind)::text = 'Trumpet'::text)
  ORDER BY (date_part('year'::text, instrument_rental.rental_date)), (date_part('month'::text, instrument_rental.rental_date));


ALTER TABLE public.trumpet_rentals OWNER TO postgres;

--
-- Name: violin_average_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.violin_average_rentals AS
 SELECT date_part('year'::text, instrument_rental.rental_date) AS year,
    (((count(instrument_rental.id))::numeric / (12)::numeric))::numeric(1000,2) AS violin_average_rental
   FROM public.instrument_rental,
    public.instrument
  WHERE ((instrument_rental.instrument_id = instrument.id) AND ((instrument.kind)::text = 'Violin'::text))
  GROUP BY (date_part('year'::text, instrument_rental.rental_date))
  ORDER BY (date_part('year'::text, instrument_rental.rental_date));


ALTER TABLE public.violin_average_rentals OWNER TO postgres;

--
-- Name: violin_rentals; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.violin_rentals AS
 SELECT date_part('year'::text, instrument_rental.rental_date) AS year,
    date_part('month'::text, instrument_rental.rental_date) AS month,
    count(instrument_rental.id) AS violin_rental_kind,
    instrument.kind AS istrument_kind
   FROM public.instrument_rental,
    public.instrument
  WHERE (instrument_rental.instrument_id = instrument.id)
  GROUP BY (date_part('year'::text, instrument_rental.rental_date)), (date_part('month'::text, instrument_rental.rental_date)), instrument.kind
 HAVING ((instrument.kind)::text = 'Violin'::text)
  ORDER BY (date_part('year'::text, instrument_rental.rental_date)), (date_part('month'::text, instrument_rental.rental_date));


ALTER TABLE public.violin_rentals OWNER TO postgres;

--
-- Name: adminstrator id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adminstrator ALTER COLUMN id SET DEFAULT nextval('public.adminstrator_id_seq'::regclass);


--
-- Name: ensemble id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble ALTER COLUMN id SET DEFAULT nextval('public.ensemble_id_seq'::regclass);


--
-- Name: ensemble_schedule id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble_schedule ALTER COLUMN id SET DEFAULT nextval('public.ensmeble_schedule_id_seq'::regclass);


--
-- Name: instructor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor ALTER COLUMN id SET DEFAULT nextval('public.instructor_id_seq'::regclass);


--
-- Name: instrument id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument ALTER COLUMN id SET DEFAULT nextval('public.instrument_id_seq'::regclass);


--
-- Name: instrument_rental id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental ALTER COLUMN id SET DEFAULT nextval('public.instrument_rental_id_seq'::regclass);


--
-- Name: lesson id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson ALTER COLUMN id SET DEFAULT nextval('public.lesson_id_seq'::regclass);


--
-- Name: lesson_price id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_price ALTER COLUMN id SET DEFAULT nextval('public.lesson_price_id_seq'::regclass);


--
-- Name: lesson_schedule id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_schedule ALTER COLUMN id SET DEFAULT nextval('public.lesson_schedule_id_seq'::regclass);


--
-- Name: student id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student ALTER COLUMN id SET DEFAULT nextval('public.student_student_id_seq'::regclass);


--
-- Name: student_application id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_application ALTER COLUMN id SET DEFAULT nextval('public.student_application_id_seq'::regclass);


--
-- Name: student_payment id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_payment ALTER COLUMN id SET DEFAULT nextval('public.student_payment_id_seq'::regclass);


--
-- Data for Name: adminstrator; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adminstrator (id, first_name, last_name, person_number, street, city, zip_code) FROM stdin;
1	Marcus	Hansson	7811104586	Klockarvagen	Tumba	14789
2	Johan	Goransson	8712154675	Kompangatan	Sodertalje	14598
\.


--
-- Data for Name: adminstrator_contact_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.adminstrator_contact_info (adminstrator_id, telefon_number, email_address) FROM stdin;
1	784951672	marcus@marcus.com
2	498875126	johan@johan.com
\.


--
-- Data for Name: audition; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audition (id, student_id, instructor_id, instrument_id, decision) FROM stdin;
\.


--
-- Data for Name: ensemble; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ensemble (id, genre, instructor_id, minimum_enrolled_students, maximum_enrolled_students, enrolled_students, number_of_instruments, ensemble_level) FROM stdin;
1	Alternative Rock	9	2	30	20	20	intermediate
2	Crossover Thrash	13	2	30	10	10	advanced
3	Grunge	5	2	30	21	21	advanced
4	Hard Rock	2	2	30	12	12	intermediate
5	Alternative Rock	9	2	30	6	6	beginner
6	Grunge	7	2	30	19	19	beginner
7	Hard Rock	15	2	30	20	20	intermediate
8	Crossover Thrash	2	2	30	4	4	intermediate
9	Experimental Rock	11	2	30	27	27	intermediate
10	Alternative Rock	15	2	30	4	4	intermediate
11	Alternative Rock	4	2	30	13	13	advanced
12	Britpunk	11	2	30	22	22	beginner
13	Experimental Rock	1	2	30	19	19	advanced
14	Britpunk	13	2	30	14	14	advanced
15	Crossover Thrash	10	2	30	22	22	intermediate
16	Indie Rock	8	2	30	20	20	intermediate
17	Crossover Thrash	12	2	30	28	28	intermediate
18	Art Punk	3	2	30	24	24	intermediate
19	Experimental Rock	8	2	30	11	11	beginner
20	Experimental Rock	9	2	30	14	14	advanced
21	Crossover Thrash	3	2	30	29	29	beginner
22	College Rock	8	2	30	19	19	intermediate
23	Art Punk	6	2	30	6	6	advanced
24	Crossover Thrash	7	2	30	15	15	beginner
25	Grunge	3	2	30	25	25	intermediate
26	Art Punk	3	2	30	8	8	beginner
27	Experimental Rock	3	2	30	15	15	beginner
28	Crossover Thrash	8	2	30	22	22	advanced
29	Experimental Rock	14	2	30	15	15	advanced
30	Hard Rock	7	2	30	29	29	intermediate
31	Alternative Rock	15	2	30	27	27	advanced
32	Art Punk	4	2	30	10	10	advanced
33	Crossover Thrash	11	2	30	22	22	advanced
34	Alternative Rock	7	2	30	14	14	advanced
35	Crossover Thrash	5	2	30	3	3	intermediate
36	Art Punk	11	2	30	5	5	beginner
37	Hard Rock	7	2	30	21	21	beginner
38	Experimental Rock	3	2	30	19	19	beginner
39	Indie Rock	7	2	30	14	14	intermediate
40	Art Punk	15	2	30	30	30	intermediate
\.


--
-- Data for Name: ensemble_schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.ensemble_schedule (id, ensemble_id, start_date, week_day) FROM stdin;
4901	27	2021-01-21 08:30:00	thursday
4902	12	2021-01-15 14:30:00	friday
4903	14	2021-01-26 11:15:00	tuesday
4904	13	2021-01-12 17:45:00	tuesday
4905	24	2021-01-18 14:00:00	monday
4906	13	2021-01-18 08:45:00	monday
4907	40	2021-01-21 16:15:00	thursday
4908	15	2021-01-29 08:30:00	friday
4909	21	2021-01-30 12:15:00	saturday
4910	33	2021-01-19 11:00:00	tuesday
4911	10	2021-01-26 16:00:00	tuesday
4912	26	2021-01-26 16:45:00	tuesday
4913	3	2021-01-13 15:15:00	wednesday
4914	18	2021-01-03 16:00:00	sunday
4915	7	2021-01-18 15:00:00	monday
4916	30	2021-01-18 09:15:00	monday
4917	37	2021-01-19 09:45:00	tuesday
4918	26	2021-01-06 12:15:00	wednesday
4919	25	2021-01-09 09:15:00	saturday
4920	39	2021-01-15 11:15:00	friday
4921	6	2021-01-20 12:45:00	wednesday
4922	21	2021-01-09 10:30:00	saturday
4923	34	2021-01-24 09:45:00	sunday
4924	7	2021-01-07 16:45:00	thursday
4925	31	2021-01-12 12:00:00	tuesday
4926	3	2021-01-04 08:15:00	monday
4927	22	2021-01-25 15:45:00	monday
4928	25	2021-01-18 12:45:00	monday
4929	27	2021-01-12 09:30:00	tuesday
4930	25	2021-01-29 13:15:00	friday
4931	6	2021-01-09 09:30:00	saturday
4932	39	2021-01-01 14:00:00	friday
4933	22	2021-01-15 16:45:00	friday
4934	32	2021-01-28 16:45:00	thursday
4935	13	2021-01-08 14:00:00	friday
4936	12	2021-01-24 12:45:00	sunday
4937	24	2021-01-11 13:15:00	monday
4938	4	2021-01-10 13:00:00	sunday
4939	38	2021-01-27 08:45:00	wednesday
4940	2	2021-01-03 17:30:00	sunday
4941	30	2021-01-23 09:15:00	saturday
4942	5	2021-01-08 15:15:00	friday
4943	11	2021-01-16 09:45:00	saturday
4944	12	2021-01-10 14:15:00	sunday
4945	33	2021-01-08 16:00:00	friday
4946	24	2021-01-11 08:45:00	monday
4947	38	2021-01-04 09:00:00	monday
4948	28	2021-01-30 09:15:00	saturday
4949	28	2021-01-12 16:45:00	tuesday
4950	38	2021-02-26 14:00:00	friday
4951	19	2021-02-19 13:30:00	friday
4952	37	2021-02-21 16:15:00	sunday
4953	17	2021-02-20 11:15:00	saturday
4954	10	2021-02-09 15:30:00	tuesday
4955	19	2021-02-16 16:00:00	tuesday
4956	25	2021-02-13 13:30:00	saturday
4957	19	2021-02-11 09:15:00	thursday
4958	39	2021-02-19 12:15:00	friday
4959	18	2021-02-11 12:30:00	thursday
4960	11	2021-02-20 12:30:00	saturday
4961	12	2021-02-15 17:45:00	monday
4962	30	2021-02-16 15:45:00	tuesday
4963	17	2021-02-21 09:15:00	sunday
4964	29	2021-02-09 12:45:00	tuesday
4965	23	2021-02-16 08:15:00	tuesday
4966	19	2021-02-24 16:30:00	wednesday
4967	19	2021-02-10 13:00:00	wednesday
4968	9	2021-02-03 13:15:00	wednesday
4969	23	2021-02-23 14:00:00	tuesday
4970	16	2021-02-23 14:45:00	tuesday
4971	2	2021-02-27 15:15:00	saturday
4972	3	2021-02-14 10:15:00	sunday
4973	37	2021-02-15 17:15:00	monday
4974	32	2021-02-18 10:30:00	thursday
4975	26	2021-02-04 14:15:00	thursday
4976	13	2021-02-09 15:30:00	tuesday
4977	21	2021-02-22 09:45:00	monday
4978	36	2021-02-06 12:00:00	saturday
4979	28	2021-02-22 13:00:00	monday
4980	25	2021-02-26 15:15:00	friday
4981	9	2021-02-28 10:00:00	sunday
4982	32	2021-02-24 11:45:00	wednesday
4983	4	2021-02-01 16:45:00	monday
4984	34	2021-02-14 10:15:00	sunday
4985	11	2021-02-09 14:00:00	tuesday
4986	6	2021-02-06 10:45:00	saturday
4987	27	2021-02-18 09:00:00	thursday
4988	17	2021-02-11 12:45:00	thursday
4989	5	2021-02-27 11:45:00	saturday
4990	17	2021-02-19 10:00:00	friday
4991	12	2021-02-21 17:45:00	sunday
4992	3	2021-02-15 13:45:00	monday
4993	20	2021-02-01 13:00:00	monday
4994	34	2021-02-03 12:15:00	wednesday
4995	10	2021-02-11 11:00:00	thursday
4996	33	2021-02-17 15:45:00	wednesday
4997	24	2021-02-28 15:45:00	sunday
4998	29	2021-02-18 14:30:00	thursday
4999	7	2021-02-01 12:30:00	monday
5000	29	2021-02-24 13:30:00	wednesday
5001	12	2021-02-05 14:45:00	friday
5002	36	2021-02-12 09:15:00	friday
5003	29	2021-02-18 08:30:00	thursday
5004	11	2021-02-05 12:45:00	friday
5005	35	2021-02-15 11:30:00	monday
5006	17	2021-02-11 12:15:00	thursday
5007	40	2021-02-27 08:30:00	saturday
5008	5	2021-02-20 16:15:00	saturday
5009	24	2021-02-28 13:30:00	sunday
5010	31	2021-02-10 12:00:00	wednesday
5011	33	2021-02-25 15:45:00	thursday
5012	4	2021-02-26 16:15:00	friday
5013	28	2021-02-28 10:00:00	sunday
5014	9	2021-02-02 11:15:00	tuesday
5015	35	2021-03-08 09:00:00	monday
5016	21	2021-03-16 16:15:00	tuesday
5017	3	2021-03-14 14:00:00	sunday
5018	25	2021-03-04 15:00:00	thursday
5019	9	2021-03-15 11:30:00	monday
5020	40	2021-03-11 16:15:00	thursday
5021	22	2021-03-25 12:00:00	thursday
5022	17	2021-03-22 12:30:00	monday
5023	13	2021-03-12 08:15:00	friday
5024	2	2021-03-05 15:00:00	friday
5025	33	2021-03-29 12:30:00	monday
5026	28	2021-03-27 08:30:00	saturday
5027	18	2021-03-04 08:15:00	thursday
5028	27	2021-03-08 10:15:00	monday
5029	6	2021-03-13 11:30:00	saturday
5030	5	2021-03-10 16:15:00	wednesday
5031	9	2021-03-02 09:15:00	tuesday
5032	16	2021-03-28 10:00:00	sunday
5033	31	2021-03-03 12:30:00	wednesday
5034	13	2021-03-30 15:15:00	tuesday
5035	31	2021-03-05 10:30:00	friday
5036	25	2021-03-19 08:45:00	friday
5037	31	2021-03-20 10:15:00	saturday
5038	9	2021-03-03 16:45:00	wednesday
5039	20	2021-03-12 10:15:00	friday
5040	35	2021-03-12 10:00:00	friday
5041	17	2021-03-15 15:45:00	monday
5042	17	2021-03-02 09:00:00	tuesday
5043	4	2021-03-12 14:00:00	friday
5044	22	2021-03-21 17:30:00	sunday
5045	38	2021-03-03 10:15:00	wednesday
5046	8	2021-03-07 10:15:00	sunday
5047	17	2021-03-17 14:00:00	wednesday
5048	6	2021-03-20 09:15:00	saturday
5049	26	2021-03-01 13:00:00	monday
5050	10	2021-03-24 16:45:00	wednesday
5051	14	2021-03-24 15:15:00	wednesday
5052	14	2021-03-16 17:15:00	tuesday
5053	6	2021-03-10 13:00:00	wednesday
5054	16	2021-03-27 09:15:00	saturday
5055	37	2021-03-12 12:45:00	friday
5056	39	2021-03-09 17:15:00	tuesday
5057	22	2021-03-26 16:30:00	friday
5058	29	2021-03-29 12:30:00	monday
5059	16	2021-03-02 14:15:00	tuesday
5060	20	2021-03-17 13:30:00	wednesday
5061	11	2021-03-16 17:45:00	tuesday
5062	35	2021-03-11 15:30:00	thursday
5063	26	2021-03-11 13:30:00	thursday
5064	17	2021-03-28 15:15:00	sunday
5065	25	2021-03-24 15:30:00	wednesday
5066	38	2021-03-10 11:30:00	wednesday
5067	39	2021-03-12 15:15:00	friday
5068	30	2021-03-11 11:15:00	thursday
5069	34	2021-03-11 17:15:00	thursday
5070	7	2021-03-21 16:30:00	sunday
5071	23	2021-03-14 09:15:00	sunday
5072	7	2021-03-14 12:00:00	sunday
5073	24	2021-04-28 10:00:00	wednesday
5074	9	2021-04-12 09:00:00	monday
5075	22	2021-04-20 10:00:00	tuesday
5076	30	2021-04-26 15:15:00	monday
5077	38	2021-04-24 16:45:00	saturday
5078	14	2021-04-20 11:45:00	tuesday
5079	21	2021-04-13 10:00:00	tuesday
5080	39	2021-04-08 12:00:00	thursday
5081	23	2021-04-14 08:00:00	wednesday
5082	9	2021-04-22 14:45:00	thursday
5083	9	2021-04-28 09:30:00	wednesday
5084	10	2021-04-20 16:30:00	tuesday
5085	20	2021-04-18 12:15:00	sunday
5086	5	2021-04-02 10:15:00	friday
5087	34	2021-04-16 16:15:00	friday
5088	11	2021-04-17 17:15:00	saturday
5089	25	2021-04-30 12:00:00	friday
5090	36	2021-04-15 13:15:00	thursday
5091	21	2021-04-24 11:45:00	saturday
5092	4	2021-04-22 09:00:00	thursday
5093	23	2021-04-13 10:00:00	tuesday
5094	16	2021-04-03 14:45:00	saturday
5095	2	2021-04-23 13:00:00	friday
5096	40	2021-04-20 17:30:00	tuesday
5097	34	2021-04-18 16:30:00	sunday
5098	13	2021-04-13 14:45:00	tuesday
5099	5	2021-04-14 11:15:00	wednesday
5100	25	2021-04-15 08:30:00	thursday
5101	27	2021-04-03 09:15:00	saturday
5102	19	2021-04-14 16:15:00	wednesday
5103	8	2021-04-08 09:30:00	thursday
5104	18	2021-04-01 13:00:00	thursday
5105	30	2021-04-22 09:30:00	thursday
5106	31	2021-04-01 09:45:00	thursday
5107	30	2021-04-30 16:45:00	friday
5108	21	2021-04-18 11:45:00	sunday
5109	37	2021-04-16 17:45:00	friday
5110	34	2021-04-20 12:15:00	tuesday
5111	24	2021-04-03 13:00:00	saturday
5112	21	2021-04-15 14:45:00	thursday
5113	27	2021-04-22 09:45:00	thursday
5114	31	2021-04-25 15:15:00	sunday
5115	35	2021-04-11 15:15:00	sunday
5116	28	2021-04-24 09:30:00	saturday
5117	9	2021-04-04 08:00:00	sunday
5118	33	2021-04-20 12:15:00	tuesday
5119	23	2021-04-14 13:30:00	wednesday
5120	29	2021-04-17 14:45:00	saturday
5121	10	2021-04-12 14:30:00	monday
5122	26	2021-04-14 16:30:00	wednesday
5123	40	2021-04-28 12:00:00	wednesday
5124	26	2021-04-22 14:00:00	thursday
5125	25	2021-04-27 15:15:00	tuesday
5126	28	2021-04-15 14:45:00	thursday
5127	40	2021-04-18 14:15:00	sunday
5128	14	2021-04-26 17:15:00	monday
5129	17	2021-05-02 11:00:00	sunday
5130	2	2021-05-14 14:45:00	friday
5131	34	2021-05-05 11:15:00	wednesday
5132	35	2021-05-19 17:30:00	wednesday
5133	35	2021-05-11 15:00:00	tuesday
5134	38	2021-05-05 09:15:00	wednesday
5135	8	2021-05-21 15:45:00	friday
5136	36	2021-05-06 16:45:00	thursday
5137	19	2021-05-10 15:45:00	monday
5138	20	2021-05-20 13:45:00	thursday
5139	36	2021-05-13 14:15:00	thursday
5140	19	2021-05-07 14:30:00	friday
5141	11	2021-05-08 12:15:00	saturday
5142	13	2021-05-21 14:15:00	friday
5143	34	2021-05-08 14:30:00	saturday
5144	18	2021-05-02 13:30:00	sunday
5145	13	2021-05-02 09:30:00	sunday
5146	36	2021-05-03 15:30:00	monday
5147	11	2021-05-18 08:15:00	tuesday
5148	37	2021-05-20 13:30:00	thursday
5149	20	2021-05-04 10:30:00	tuesday
5150	11	2021-05-09 11:45:00	sunday
5151	18	2021-05-03 12:45:00	monday
5152	6	2021-05-12 10:00:00	wednesday
5153	18	2021-05-06 15:15:00	thursday
5154	22	2021-05-30 16:00:00	sunday
5155	26	2021-05-13 12:00:00	thursday
5156	15	2021-05-05 09:30:00	wednesday
5157	2	2021-05-18 14:30:00	tuesday
5158	6	2021-05-28 12:15:00	friday
5159	37	2021-05-29 09:15:00	saturday
5160	18	2021-05-19 17:30:00	wednesday
5161	14	2021-05-29 09:00:00	saturday
5162	30	2021-05-10 12:30:00	monday
5163	29	2021-05-04 17:30:00	tuesday
5164	11	2021-05-16 08:15:00	sunday
5165	2	2021-05-11 13:00:00	tuesday
5166	24	2021-05-15 13:00:00	saturday
5167	30	2021-06-16 09:30:00	wednesday
5168	28	2021-06-08 14:00:00	tuesday
5169	14	2021-06-15 17:45:00	tuesday
5170	15	2021-06-22 10:30:00	tuesday
5171	9	2021-06-18 15:30:00	friday
5172	6	2021-06-14 09:45:00	monday
5173	39	2021-06-29 10:00:00	tuesday
5174	14	2021-06-18 15:15:00	friday
5175	9	2021-06-14 14:30:00	monday
5176	30	2021-06-28 09:15:00	monday
5177	29	2021-06-21 17:15:00	monday
5178	23	2021-06-09 09:45:00	wednesday
5179	25	2021-06-05 14:45:00	saturday
5180	5	2021-06-05 09:45:00	saturday
5181	21	2021-06-15 15:30:00	tuesday
5182	28	2021-06-18 17:15:00	friday
5183	19	2021-06-01 08:15:00	tuesday
5184	13	2021-06-14 08:15:00	monday
5185	8	2021-06-17 13:45:00	thursday
5186	33	2021-06-30 08:30:00	wednesday
5187	26	2021-06-25 10:45:00	friday
5188	18	2021-06-08 14:45:00	tuesday
5189	1	2021-06-11 10:00:00	friday
5190	14	2021-06-29 11:45:00	tuesday
5191	40	2021-06-18 17:00:00	friday
5192	21	2021-06-08 17:00:00	tuesday
5193	26	2021-06-14 10:15:00	monday
5194	8	2021-06-16 14:00:00	wednesday
5195	23	2021-06-02 09:30:00	wednesday
5196	26	2021-06-25 10:45:00	friday
5197	22	2021-06-27 13:30:00	sunday
5198	40	2021-06-07 17:15:00	monday
5199	26	2021-06-13 12:15:00	sunday
5200	34	2021-06-24 14:30:00	thursday
5201	24	2021-06-02 10:45:00	wednesday
5202	9	2021-06-06 08:00:00	sunday
5203	5	2021-06-10 17:30:00	thursday
5204	25	2021-06-05 15:15:00	saturday
5205	9	2021-06-02 10:45:00	wednesday
5206	30	2021-06-05 16:30:00	saturday
5207	32	2021-06-07 14:15:00	monday
5208	16	2021-06-07 09:45:00	monday
5209	5	2021-06-02 10:15:00	wednesday
5210	9	2021-06-15 10:30:00	tuesday
5211	30	2021-06-25 17:30:00	friday
5212	27	2021-06-09 14:45:00	wednesday
5213	13	2021-06-28 15:30:00	monday
5214	28	2021-06-28 15:15:00	monday
5215	11	2021-06-28 11:45:00	monday
5216	11	2021-06-19 10:15:00	saturday
5217	21	2021-06-25 11:45:00	friday
5218	2	2021-06-03 11:15:00	thursday
5219	17	2021-06-13 13:45:00	sunday
5220	35	2021-06-18 12:00:00	friday
5221	31	2021-07-20 15:30:00	tuesday
5222	5	2021-07-15 10:15:00	thursday
5223	33	2021-07-12 13:00:00	monday
5224	7	2021-07-22 08:30:00	thursday
5225	37	2021-07-23 13:15:00	friday
5226	33	2021-07-29 15:30:00	thursday
5227	31	2021-07-18 08:30:00	sunday
5228	31	2021-07-29 17:45:00	thursday
5229	10	2021-07-28 12:15:00	wednesday
5230	23	2021-07-07 13:45:00	wednesday
5231	30	2021-07-04 12:00:00	sunday
5232	39	2021-07-21 11:30:00	wednesday
5233	40	2021-07-26 15:00:00	monday
5234	2	2021-07-17 16:45:00	saturday
5235	7	2021-07-14 11:00:00	wednesday
5236	34	2021-07-15 15:15:00	thursday
5237	10	2021-07-06 11:00:00	tuesday
5238	12	2021-07-23 10:30:00	friday
5239	20	2021-07-10 12:30:00	saturday
5240	17	2021-07-14 15:30:00	wednesday
5241	10	2021-07-14 09:45:00	wednesday
5242	33	2021-07-22 09:15:00	thursday
5243	26	2021-07-05 10:45:00	monday
5244	31	2021-07-23 12:00:00	friday
5245	20	2021-07-22 09:00:00	thursday
5246	18	2021-07-14 08:00:00	wednesday
5247	2	2021-07-07 15:30:00	wednesday
5248	39	2021-07-06 17:30:00	tuesday
5249	16	2021-07-07 09:15:00	wednesday
5250	25	2021-07-06 08:30:00	tuesday
5251	22	2021-07-23 16:15:00	friday
5252	11	2021-07-22 17:45:00	thursday
5253	3	2021-07-10 12:00:00	saturday
5254	3	2021-07-09 12:45:00	friday
5255	1	2021-07-23 16:15:00	friday
5256	14	2021-07-09 10:45:00	friday
5257	38	2021-07-01 15:45:00	thursday
5258	24	2021-07-24 14:30:00	saturday
5259	22	2021-07-05 08:15:00	monday
5260	35	2021-07-25 13:00:00	sunday
5261	11	2021-07-14 16:15:00	wednesday
5262	36	2021-07-19 14:45:00	monday
5263	31	2021-07-02 12:45:00	friday
5264	27	2021-07-09 12:15:00	friday
5265	30	2021-07-26 15:45:00	monday
5266	17	2021-07-24 10:45:00	saturday
5267	39	2021-07-19 08:00:00	monday
5268	25	2021-08-17 16:15:00	tuesday
5269	17	2021-08-16 08:15:00	monday
5270	25	2021-08-09 14:45:00	monday
5271	40	2021-08-29 13:15:00	sunday
5272	40	2021-08-29 15:00:00	sunday
5273	15	2021-08-25 17:45:00	wednesday
5274	31	2021-08-20 11:15:00	friday
5275	28	2021-08-22 08:15:00	sunday
5276	34	2021-08-17 14:15:00	tuesday
5277	17	2021-08-27 11:45:00	friday
5278	38	2021-08-30 15:45:00	monday
5279	39	2021-08-14 13:00:00	saturday
5280	10	2021-08-07 11:30:00	saturday
5281	18	2021-08-17 12:00:00	tuesday
5282	24	2021-08-19 16:30:00	thursday
5283	18	2021-08-02 09:45:00	monday
5284	18	2021-08-07 08:30:00	saturday
5285	14	2021-08-05 10:15:00	thursday
5286	31	2021-08-02 15:00:00	monday
5287	40	2021-08-02 12:00:00	monday
5288	13	2021-08-21 13:00:00	saturday
5289	13	2021-08-30 15:45:00	monday
5290	14	2021-08-30 14:30:00	monday
5291	20	2021-08-12 11:45:00	thursday
5292	37	2021-08-26 11:15:00	thursday
5293	4	2021-08-05 11:30:00	thursday
5294	39	2021-08-02 14:45:00	monday
5295	40	2021-08-05 14:15:00	thursday
5296	29	2021-08-16 14:30:00	monday
5297	4	2021-08-29 11:45:00	sunday
5298	38	2021-08-02 15:15:00	monday
5299	22	2021-08-12 17:30:00	thursday
5300	39	2021-08-14 13:30:00	saturday
5301	7	2021-08-17 16:45:00	tuesday
5302	20	2021-08-26 16:00:00	thursday
5303	2	2021-08-20 15:30:00	friday
5304	6	2021-08-27 08:00:00	friday
5305	25	2021-08-29 08:30:00	sunday
5306	12	2021-08-30 09:00:00	monday
5307	29	2021-08-13 10:45:00	friday
5308	4	2021-08-26 08:00:00	thursday
5309	28	2021-08-03 10:30:00	tuesday
5310	25	2021-08-25 09:30:00	wednesday
5311	2	2021-08-23 16:15:00	monday
5312	11	2021-08-13 08:45:00	friday
5313	3	2021-08-24 08:30:00	tuesday
5314	20	2021-08-13 14:00:00	friday
5315	36	2021-08-06 08:00:00	friday
5316	23	2021-08-24 16:30:00	tuesday
5317	15	2021-08-20 08:15:00	friday
5318	25	2021-08-29 11:00:00	sunday
5319	13	2021-08-04 12:15:00	wednesday
5320	10	2021-08-27 08:30:00	friday
5321	19	2021-08-05 10:45:00	thursday
5322	10	2021-08-04 12:00:00	wednesday
5323	8	2021-08-19 14:45:00	thursday
5324	6	2021-08-25 12:45:00	wednesday
5325	10	2021-08-06 12:30:00	friday
5326	18	2021-08-21 10:30:00	saturday
5327	22	2021-08-15 15:30:00	sunday
5328	13	2021-08-25 14:00:00	wednesday
5329	31	2021-08-04 12:45:00	wednesday
5330	26	2021-08-19 13:45:00	thursday
5331	12	2021-08-22 12:30:00	sunday
5332	11	2021-08-19 17:30:00	thursday
5333	36	2021-08-16 08:30:00	monday
5334	22	2021-09-08 09:00:00	wednesday
5335	26	2021-09-30 15:15:00	thursday
5336	2	2021-09-18 15:00:00	saturday
5337	19	2021-09-27 11:45:00	monday
5338	40	2021-09-16 13:30:00	thursday
5339	20	2021-09-03 13:00:00	friday
5340	27	2021-09-06 15:15:00	monday
5341	6	2021-09-15 08:15:00	wednesday
5342	34	2021-09-01 13:30:00	wednesday
5343	12	2021-09-05 15:00:00	sunday
5344	3	2021-09-24 13:15:00	friday
5345	1	2021-09-22 08:15:00	wednesday
5346	39	2021-09-04 11:45:00	saturday
5347	21	2021-09-22 10:15:00	wednesday
5348	19	2021-09-29 16:45:00	wednesday
5349	30	2021-09-29 12:15:00	wednesday
5350	2	2021-09-16 17:00:00	thursday
5351	17	2021-09-06 14:45:00	monday
5352	13	2021-09-10 16:00:00	friday
5353	32	2021-09-11 15:15:00	saturday
5354	37	2021-09-29 17:30:00	wednesday
5355	26	2021-09-29 11:45:00	wednesday
5356	29	2021-09-11 17:00:00	saturday
5357	8	2021-09-12 08:15:00	sunday
5358	18	2021-09-25 10:15:00	saturday
5359	3	2021-09-05 15:00:00	sunday
5360	28	2021-09-24 15:30:00	friday
5361	33	2021-09-10 11:15:00	friday
5362	36	2021-09-08 09:30:00	wednesday
5363	40	2021-09-30 12:45:00	thursday
5364	38	2021-09-03 13:00:00	friday
5365	31	2021-09-04 17:15:00	saturday
5366	14	2021-09-10 17:15:00	friday
5367	17	2021-09-10 10:30:00	friday
5368	4	2021-09-01 15:30:00	wednesday
5369	18	2021-09-09 08:15:00	thursday
5370	26	2021-09-01 12:45:00	wednesday
5371	18	2021-09-18 16:00:00	saturday
5372	34	2021-09-04 12:45:00	saturday
5373	7	2021-09-29 08:15:00	wednesday
5374	18	2021-09-29 10:00:00	wednesday
5375	20	2021-09-10 15:45:00	friday
5376	33	2021-09-11 14:45:00	saturday
5377	15	2021-09-06 14:15:00	monday
5378	9	2021-09-11 08:00:00	saturday
5379	36	2021-09-26 14:30:00	sunday
5380	13	2021-09-19 12:15:00	sunday
5381	12	2021-09-27 13:30:00	monday
5382	10	2021-09-23 17:30:00	thursday
5383	19	2021-09-16 09:15:00	thursday
5384	39	2021-09-17 08:00:00	friday
5385	35	2021-09-17 08:15:00	friday
5386	38	2021-09-10 09:15:00	friday
5387	3	2021-09-28 16:45:00	tuesday
5388	35	2021-09-03 11:00:00	friday
5389	12	2021-09-22 14:15:00	wednesday
5390	17	2021-10-29 15:45:00	friday
5391	7	2021-10-12 09:00:00	tuesday
5392	10	2021-10-25 14:45:00	monday
5393	34	2021-10-08 13:45:00	friday
5394	21	2021-10-01 14:15:00	friday
5395	26	2021-10-23 13:00:00	saturday
5396	31	2021-10-06 14:30:00	wednesday
5397	24	2021-10-05 12:15:00	tuesday
5398	13	2021-10-24 09:30:00	sunday
5399	22	2021-10-01 11:45:00	friday
5400	37	2021-10-02 09:45:00	saturday
5401	1	2021-10-03 08:30:00	sunday
5402	34	2021-10-29 08:30:00	friday
5403	38	2021-10-06 10:15:00	wednesday
5404	23	2021-10-30 08:15:00	saturday
5405	38	2021-10-05 12:00:00	tuesday
5406	24	2021-10-13 13:30:00	wednesday
5407	3	2021-10-13 15:30:00	wednesday
5408	6	2021-10-05 17:00:00	tuesday
5409	3	2021-10-10 13:00:00	sunday
5410	33	2021-10-05 12:15:00	tuesday
5411	26	2021-10-13 15:15:00	wednesday
5412	5	2021-10-12 11:15:00	tuesday
5413	17	2021-10-22 17:45:00	friday
5414	24	2021-10-21 13:00:00	thursday
5415	3	2021-10-07 12:45:00	thursday
5416	31	2021-10-15 14:45:00	friday
5417	36	2021-10-05 12:00:00	tuesday
5418	14	2021-10-01 11:45:00	friday
5419	2	2021-10-05 14:00:00	tuesday
5420	7	2021-10-06 15:00:00	wednesday
5421	6	2021-10-21 17:00:00	thursday
5422	31	2021-10-18 10:15:00	monday
5423	17	2021-10-09 11:45:00	saturday
5424	22	2021-10-25 10:30:00	monday
5425	33	2021-10-16 09:15:00	saturday
5426	21	2021-10-29 15:45:00	friday
5427	35	2021-10-20 12:30:00	wednesday
5428	39	2021-10-05 09:15:00	tuesday
5429	24	2021-10-13 12:00:00	wednesday
5430	18	2021-10-19 08:30:00	tuesday
5431	2	2021-10-12 12:30:00	tuesday
5432	37	2021-10-20 12:00:00	wednesday
5433	5	2021-10-24 12:30:00	sunday
5434	25	2021-10-03 10:30:00	sunday
5435	24	2021-10-24 12:15:00	sunday
5436	18	2021-10-19 13:45:00	tuesday
5437	11	2021-10-10 13:00:00	sunday
5438	13	2021-10-10 13:00:00	sunday
5439	33	2021-10-14 16:30:00	thursday
5440	1	2021-10-25 15:30:00	monday
5441	21	2021-10-21 17:30:00	thursday
5442	8	2021-10-17 12:00:00	sunday
5443	14	2021-10-29 12:45:00	friday
5444	20	2021-10-09 17:30:00	saturday
5445	28	2021-10-07 11:00:00	thursday
5446	4	2021-10-10 12:30:00	sunday
5447	2	2021-10-25 10:15:00	monday
5448	14	2021-10-09 09:45:00	saturday
5449	36	2021-11-20 11:15:00	saturday
5450	4	2021-11-30 11:15:00	tuesday
5451	40	2021-11-23 16:30:00	tuesday
5452	34	2021-11-07 10:15:00	sunday
5453	39	2021-11-02 16:15:00	tuesday
5454	27	2021-11-25 12:45:00	thursday
5455	34	2021-11-07 12:45:00	sunday
5456	8	2021-11-07 10:30:00	sunday
5457	39	2021-11-20 10:00:00	saturday
5458	35	2021-11-29 08:30:00	monday
5459	11	2021-11-22 17:15:00	monday
5460	29	2021-11-12 17:15:00	friday
5461	22	2021-11-29 11:15:00	monday
5462	14	2021-11-14 15:45:00	sunday
5463	28	2021-11-18 17:30:00	thursday
5464	27	2021-11-06 10:00:00	saturday
5465	40	2021-11-25 17:15:00	thursday
5466	39	2021-11-09 13:15:00	tuesday
5467	17	2021-11-30 16:45:00	tuesday
5468	12	2021-11-07 10:45:00	sunday
5469	23	2021-11-07 10:45:00	sunday
5470	17	2021-11-14 13:30:00	sunday
5471	5	2021-11-04 13:45:00	thursday
5472	3	2021-11-27 14:45:00	saturday
5473	6	2021-11-08 13:15:00	monday
5474	13	2021-11-11 14:30:00	thursday
5475	17	2021-11-15 14:15:00	monday
5476	34	2021-11-01 13:45:00	monday
5477	30	2021-11-04 13:00:00	thursday
5478	7	2021-11-14 11:15:00	sunday
5479	40	2021-11-23 10:15:00	tuesday
5480	28	2021-11-12 09:00:00	friday
5481	11	2021-11-18 12:00:00	thursday
5482	1	2021-11-18 12:15:00	thursday
5483	28	2021-11-15 13:00:00	monday
5484	3	2021-11-27 13:15:00	saturday
5485	30	2021-11-23 14:15:00	tuesday
5486	14	2021-11-13 17:00:00	saturday
5487	17	2021-11-03 12:30:00	wednesday
5488	33	2021-11-12 09:15:00	friday
5489	27	2021-11-25 09:45:00	thursday
5490	31	2021-11-16 08:15:00	tuesday
5491	17	2021-11-04 11:00:00	thursday
5492	18	2021-11-08 12:00:00	monday
5493	35	2021-11-08 13:30:00	monday
5494	8	2021-11-18 10:45:00	thursday
5495	37	2021-12-04 17:00:00	saturday
5496	32	2021-12-17 09:30:00	friday
5497	2	2021-12-03 12:45:00	friday
5498	27	2021-12-30 08:45:00	thursday
5499	9	2021-12-10 15:45:00	friday
5500	13	2021-12-25 09:45:00	saturday
5501	26	2021-12-03 08:30:00	friday
5502	2	2021-12-04 16:15:00	saturday
5503	15	2021-12-24 17:45:00	friday
5504	3	2021-12-30 13:15:00	thursday
5505	37	2021-12-24 17:15:00	friday
5506	17	2021-12-03 10:30:00	friday
5507	10	2021-12-13 10:45:00	monday
5508	30	2021-12-25 17:30:00	saturday
5509	14	2021-12-10 12:45:00	friday
5510	17	2021-12-24 09:45:00	friday
5511	4	2021-12-17 11:15:00	friday
5512	16	2021-12-17 09:30:00	friday
5513	15	2021-12-20 14:45:00	monday
5514	20	2021-12-08 17:30:00	wednesday
5515	7	2021-12-07 09:30:00	tuesday
5516	26	2021-12-21 10:15:00	tuesday
5517	28	2021-12-16 12:45:00	thursday
5518	39	2021-12-19 10:00:00	sunday
5519	23	2021-12-22 08:30:00	wednesday
5520	9	2021-12-27 14:45:00	monday
5521	21	2021-12-28 17:00:00	tuesday
5522	26	2021-12-05 13:45:00	sunday
5523	21	2021-12-03 08:45:00	friday
5524	22	2021-12-02 12:00:00	thursday
5525	31	2021-12-15 17:45:00	wednesday
5526	9	2021-12-21 12:00:00	tuesday
5527	12	2021-12-15 08:00:00	wednesday
5528	35	2021-12-01 10:30:00	wednesday
5529	34	2021-12-05 16:45:00	sunday
5530	14	2021-12-01 08:45:00	wednesday
5531	39	2021-12-25 15:45:00	saturday
5532	36	2021-12-07 13:30:00	tuesday
5533	35	2021-12-20 09:45:00	monday
5534	3	2021-12-15 09:45:00	wednesday
5535	32	2021-12-19 17:00:00	sunday
5536	34	2021-12-14 12:45:00	tuesday
5537	19	2021-12-05 10:30:00	sunday
5538	27	2021-12-02 17:00:00	thursday
5539	34	2021-12-12 09:45:00	sunday
5540	25	2021-12-08 14:15:00	wednesday
5541	5	2021-12-07 08:45:00	tuesday
5542	25	2021-12-17 17:15:00	friday
5543	14	2021-12-13 10:30:00	monday
5544	26	2021-12-23 08:15:00	thursday
5545	3	2021-12-03 14:45:00	friday
5546	22	2021-12-09 15:00:00	thursday
5547	9	2021-12-01 15:15:00	wednesday
5548	33	2021-12-20 17:00:00	monday
5549	32	2021-12-28 11:00:00	tuesday
5550	6	2021-12-06 09:15:00	monday
1	11	2014-01-30 11:00:00	thursday
2	30	2014-01-07 10:45:00	tuesday
3	37	2014-01-30 16:45:00	thursday
4	34	2014-01-17 15:15:00	friday
5	30	2014-01-17 09:00:00	friday
6	29	2014-01-20 16:30:00	monday
7	6	2014-01-15 14:00:00	wednesday
8	37	2014-01-21 12:15:00	tuesday
9	14	2014-01-01 12:30:00	wednesday
10	24	2014-01-15 09:15:00	wednesday
11	20	2014-01-26 16:30:00	sunday
12	9	2014-01-11 15:00:00	saturday
13	6	2014-01-29 08:45:00	wednesday
14	3	2014-01-09 10:15:00	thursday
15	4	2014-01-05 09:30:00	sunday
16	26	2014-01-11 16:45:00	saturday
17	32	2014-01-16 10:00:00	thursday
18	7	2014-01-22 16:45:00	wednesday
19	14	2014-01-28 10:30:00	tuesday
20	10	2014-01-12 11:00:00	sunday
21	30	2014-01-09 11:30:00	thursday
22	15	2014-01-05 12:00:00	sunday
23	15	2014-01-26 10:30:00	sunday
24	36	2014-01-01 09:15:00	wednesday
25	27	2014-01-01 09:45:00	wednesday
26	14	2014-01-01 17:00:00	wednesday
27	24	2014-01-24 12:30:00	friday
28	17	2014-01-21 15:00:00	tuesday
29	11	2014-01-03 10:45:00	friday
30	39	2014-01-09 17:15:00	thursday
31	20	2014-01-09 13:15:00	thursday
32	5	2014-01-11 10:30:00	saturday
33	30	2014-01-13 16:45:00	monday
34	19	2014-01-02 08:45:00	thursday
35	29	2014-01-11 14:30:00	saturday
36	34	2014-01-19 16:45:00	sunday
37	40	2014-01-03 09:45:00	friday
38	29	2014-01-15 14:15:00	wednesday
39	14	2014-01-07 10:45:00	tuesday
40	34	2014-01-08 09:00:00	wednesday
41	18	2014-01-01 08:45:00	wednesday
42	24	2014-01-06 16:15:00	monday
43	33	2014-01-25 13:30:00	saturday
44	33	2014-01-09 16:45:00	thursday
45	25	2014-01-09 13:30:00	thursday
46	7	2014-01-22 12:45:00	wednesday
47	26	2014-01-22 17:30:00	wednesday
48	39	2014-01-28 08:15:00	tuesday
49	30	2014-01-05 08:00:00	sunday
50	11	2014-01-13 09:30:00	monday
51	1	2014-01-09 12:15:00	thursday
52	1	2014-01-20 13:30:00	monday
53	19	2014-01-03 12:00:00	friday
54	23	2014-01-03 16:30:00	friday
55	11	2014-01-03 14:15:00	friday
56	9	2014-01-11 08:00:00	saturday
57	27	2014-01-23 13:45:00	thursday
58	22	2014-02-24 09:00:00	monday
59	40	2014-02-03 15:00:00	monday
60	16	2014-02-28 08:45:00	friday
61	1	2014-02-21 15:15:00	friday
62	2	2014-02-23 13:00:00	sunday
63	37	2014-02-11 17:15:00	tuesday
64	26	2014-02-02 11:45:00	sunday
65	23	2014-02-06 11:15:00	thursday
66	14	2014-02-20 11:15:00	thursday
67	19	2014-02-09 14:30:00	sunday
68	16	2014-02-02 10:00:00	sunday
69	8	2014-02-19 15:45:00	wednesday
70	4	2014-02-21 16:45:00	friday
71	5	2014-02-26 17:30:00	wednesday
72	31	2014-02-10 13:45:00	monday
73	13	2014-02-17 17:15:00	monday
74	39	2014-02-16 14:45:00	sunday
75	13	2014-02-11 09:30:00	tuesday
76	23	2014-02-28 15:00:00	friday
77	11	2014-02-09 14:15:00	sunday
78	33	2014-02-28 12:30:00	friday
79	14	2014-02-24 13:45:00	monday
80	27	2014-02-04 11:15:00	tuesday
81	2	2014-02-12 15:30:00	wednesday
82	5	2014-02-20 14:45:00	thursday
83	3	2014-02-17 14:45:00	monday
84	39	2014-02-23 15:00:00	sunday
85	38	2014-02-17 17:00:00	monday
86	13	2014-02-05 13:15:00	wednesday
87	5	2014-02-11 17:00:00	tuesday
88	12	2014-02-21 12:15:00	friday
89	33	2014-02-22 14:00:00	saturday
90	20	2014-02-07 09:00:00	friday
91	23	2014-02-03 13:30:00	monday
92	37	2014-02-27 09:00:00	thursday
93	30	2014-02-10 16:45:00	monday
94	36	2014-02-07 10:15:00	friday
95	5	2014-02-09 17:00:00	sunday
96	5	2014-02-17 10:45:00	monday
97	23	2014-02-14 11:45:00	friday
98	23	2014-02-10 12:45:00	monday
99	32	2014-02-01 17:45:00	saturday
100	5	2014-02-19 11:30:00	wednesday
101	38	2014-02-24 16:45:00	monday
102	9	2014-02-11 13:15:00	tuesday
103	10	2014-02-01 17:00:00	saturday
104	9	2014-02-15 09:45:00	saturday
105	39	2014-02-06 12:30:00	thursday
106	12	2014-02-12 12:30:00	wednesday
107	31	2014-02-07 10:15:00	friday
108	3	2014-02-24 14:15:00	monday
109	35	2014-02-02 09:00:00	sunday
110	26	2014-02-01 08:15:00	saturday
111	9	2014-02-10 09:30:00	monday
112	38	2014-02-07 12:45:00	friday
113	13	2014-02-21 12:45:00	friday
114	22	2014-02-10 15:00:00	monday
115	34	2014-02-18 09:15:00	tuesday
116	27	2014-02-25 14:30:00	tuesday
117	40	2014-02-26 13:15:00	wednesday
118	2	2014-02-12 12:30:00	wednesday
119	37	2014-02-18 15:15:00	tuesday
120	6	2014-02-26 09:30:00	wednesday
121	22	2014-02-03 17:30:00	monday
122	8	2014-02-07 11:45:00	friday
123	29	2014-02-12 11:15:00	wednesday
124	1	2014-03-27 13:45:00	thursday
125	1	2014-03-21 08:45:00	friday
126	28	2014-03-14 14:15:00	friday
127	35	2014-03-18 08:45:00	tuesday
128	6	2014-03-27 15:45:00	thursday
129	13	2014-03-29 11:15:00	saturday
130	7	2014-03-18 08:30:00	tuesday
131	11	2014-03-22 08:00:00	saturday
132	25	2014-03-09 16:45:00	sunday
133	11	2014-03-23 11:15:00	sunday
134	21	2014-03-04 08:45:00	tuesday
135	6	2014-03-01 14:15:00	saturday
136	26	2014-03-07 09:15:00	friday
137	14	2014-03-21 16:15:00	friday
138	16	2014-03-20 11:45:00	thursday
139	40	2014-03-22 17:30:00	saturday
140	38	2014-03-06 08:00:00	thursday
141	17	2014-03-22 12:00:00	saturday
142	1	2014-03-12 12:00:00	wednesday
143	3	2014-03-27 08:30:00	thursday
144	23	2014-03-10 14:00:00	monday
145	38	2014-03-14 08:45:00	friday
146	5	2014-03-28 15:15:00	friday
147	17	2014-03-23 11:15:00	sunday
148	22	2014-03-25 17:45:00	tuesday
149	40	2014-03-04 11:45:00	tuesday
150	5	2014-03-03 09:45:00	monday
151	37	2014-03-05 09:15:00	wednesday
152	23	2014-03-19 13:45:00	wednesday
153	1	2014-03-30 13:30:00	sunday
154	35	2014-03-25 08:15:00	tuesday
155	33	2014-03-05 10:15:00	wednesday
156	35	2014-03-01 11:15:00	saturday
157	27	2014-03-21 08:30:00	friday
158	11	2014-03-11 11:15:00	tuesday
159	32	2014-03-03 09:00:00	monday
160	22	2014-03-07 11:15:00	friday
161	26	2014-03-27 14:00:00	thursday
162	30	2014-03-16 08:45:00	sunday
163	4	2014-03-09 10:30:00	sunday
164	3	2014-03-01 17:15:00	saturday
165	23	2014-03-17 16:30:00	monday
166	24	2014-03-01 12:30:00	saturday
167	25	2014-03-15 13:15:00	saturday
168	34	2014-03-27 10:45:00	thursday
169	13	2014-03-19 16:15:00	wednesday
170	34	2014-03-08 13:00:00	saturday
171	23	2014-03-22 10:45:00	saturday
172	32	2014-03-24 09:45:00	monday
173	30	2014-03-16 08:15:00	sunday
174	23	2014-03-05 17:15:00	wednesday
175	3	2014-03-15 17:15:00	saturday
176	38	2014-03-24 16:15:00	monday
177	38	2014-03-16 14:30:00	sunday
178	3	2014-03-16 12:15:00	sunday
179	38	2014-03-24 17:45:00	monday
180	15	2014-03-04 17:45:00	tuesday
181	39	2014-03-02 09:00:00	sunday
182	6	2014-03-16 17:15:00	sunday
183	34	2014-04-16 12:00:00	wednesday
184	22	2014-04-17 17:15:00	thursday
185	10	2014-04-02 08:00:00	wednesday
186	12	2014-04-20 14:00:00	sunday
187	27	2014-04-08 11:00:00	tuesday
188	20	2014-04-24 08:15:00	thursday
189	19	2014-04-25 13:45:00	friday
190	24	2014-04-05 14:15:00	saturday
191	19	2014-04-16 09:45:00	wednesday
192	5	2014-04-09 16:30:00	wednesday
193	13	2014-04-11 14:30:00	friday
194	11	2014-04-23 11:45:00	wednesday
195	36	2014-04-17 10:15:00	thursday
196	27	2014-04-18 15:30:00	friday
197	25	2014-04-13 10:45:00	sunday
198	8	2014-04-15 08:30:00	tuesday
199	26	2014-04-16 14:45:00	wednesday
200	24	2014-04-29 14:15:00	tuesday
201	18	2014-04-11 10:30:00	friday
202	19	2014-04-29 16:30:00	tuesday
203	37	2014-04-13 09:15:00	sunday
204	24	2014-04-07 10:30:00	monday
205	10	2014-04-24 17:30:00	thursday
206	4	2014-04-15 17:30:00	tuesday
207	9	2014-04-24 09:45:00	thursday
208	28	2014-04-06 10:45:00	sunday
209	37	2014-04-23 17:45:00	wednesday
210	7	2014-04-09 13:45:00	wednesday
211	25	2014-04-14 15:30:00	monday
212	31	2014-04-15 17:00:00	tuesday
213	12	2014-04-20 11:15:00	sunday
214	22	2014-04-26 08:00:00	saturday
215	22	2014-04-04 13:30:00	friday
216	27	2014-04-27 13:00:00	sunday
217	18	2014-04-15 12:45:00	tuesday
218	4	2014-04-21 16:30:00	monday
219	28	2014-04-01 08:30:00	tuesday
220	35	2014-04-19 08:30:00	saturday
221	18	2014-04-07 13:45:00	monday
222	36	2014-04-23 14:00:00	wednesday
223	13	2014-04-17 09:30:00	thursday
224	34	2014-04-21 12:00:00	monday
225	30	2014-04-20 16:45:00	sunday
226	31	2014-04-26 12:00:00	saturday
227	27	2014-04-21 13:15:00	monday
228	10	2014-04-13 12:15:00	sunday
229	9	2014-04-29 17:30:00	tuesday
230	32	2014-04-12 11:15:00	saturday
231	17	2014-04-11 11:00:00	friday
232	29	2014-04-17 08:45:00	thursday
233	5	2014-04-14 14:00:00	monday
234	10	2014-04-25 11:30:00	friday
235	1	2014-04-22 17:00:00	tuesday
236	38	2014-04-11 10:00:00	friday
237	20	2014-04-17 13:30:00	thursday
238	15	2014-04-02 14:45:00	wednesday
239	38	2014-04-21 12:00:00	monday
240	32	2014-04-14 14:30:00	monday
241	18	2014-04-14 14:15:00	monday
242	2	2014-04-21 12:00:00	monday
243	3	2014-04-18 08:15:00	friday
244	5	2014-04-26 14:15:00	saturday
245	40	2014-04-11 14:00:00	friday
246	29	2014-04-09 17:00:00	wednesday
247	1	2014-05-09 10:30:00	friday
248	31	2014-05-22 17:45:00	thursday
249	1	2014-05-26 14:45:00	monday
250	35	2014-05-11 13:30:00	sunday
251	12	2014-05-27 15:45:00	tuesday
252	1	2014-05-11 17:45:00	sunday
253	8	2014-05-10 13:15:00	saturday
254	30	2014-05-22 16:15:00	thursday
255	37	2014-05-09 14:30:00	friday
256	38	2014-05-14 16:45:00	wednesday
257	31	2014-05-09 16:15:00	friday
258	17	2014-05-06 08:45:00	tuesday
259	32	2014-05-02 10:30:00	friday
260	31	2014-05-01 09:15:00	thursday
261	16	2014-05-07 10:30:00	wednesday
262	6	2014-05-11 12:45:00	sunday
263	15	2014-05-11 11:15:00	sunday
264	32	2014-05-20 11:00:00	tuesday
265	31	2014-05-02 15:30:00	friday
266	15	2014-05-01 10:30:00	thursday
267	20	2014-05-27 11:15:00	tuesday
268	36	2014-05-29 08:00:00	thursday
269	37	2014-05-26 11:15:00	monday
270	32	2014-05-25 11:00:00	sunday
271	34	2014-05-26 13:45:00	monday
272	35	2014-05-01 17:15:00	thursday
273	29	2014-05-25 08:45:00	sunday
274	27	2014-05-05 10:45:00	monday
275	19	2014-05-11 08:30:00	sunday
276	26	2014-05-12 13:15:00	monday
277	10	2014-05-03 13:15:00	saturday
278	10	2014-05-24 12:45:00	saturday
279	26	2014-05-22 14:30:00	thursday
280	10	2014-05-09 14:45:00	friday
281	38	2014-05-01 08:30:00	thursday
282	40	2014-05-11 10:30:00	sunday
283	26	2014-05-12 15:30:00	monday
284	29	2014-05-25 14:30:00	sunday
285	20	2014-05-30 09:45:00	friday
286	22	2014-05-09 15:30:00	friday
287	4	2014-05-12 17:00:00	monday
288	24	2014-05-23 16:15:00	friday
289	37	2014-05-27 17:00:00	tuesday
290	9	2014-05-18 10:00:00	sunday
291	36	2014-05-17 14:00:00	saturday
292	19	2014-05-20 12:30:00	tuesday
293	6	2014-05-18 17:45:00	sunday
294	10	2014-05-10 08:00:00	saturday
295	11	2014-05-23 15:00:00	friday
296	26	2014-05-08 12:30:00	thursday
297	23	2014-05-27 17:15:00	tuesday
298	11	2014-05-03 13:15:00	saturday
299	5	2014-05-14 14:00:00	wednesday
300	15	2014-05-23 09:45:00	friday
301	20	2014-05-22 14:30:00	thursday
302	32	2014-05-30 14:15:00	friday
303	28	2014-05-21 12:00:00	wednesday
304	4	2014-05-25 10:45:00	sunday
305	31	2014-05-11 17:45:00	sunday
306	11	2014-06-28 17:15:00	saturday
307	2	2014-06-05 14:30:00	thursday
308	37	2014-06-07 09:00:00	saturday
309	27	2014-06-27 13:15:00	friday
310	14	2014-06-26 13:30:00	thursday
311	2	2014-06-28 15:30:00	saturday
312	18	2014-06-08 17:15:00	sunday
313	10	2014-06-21 12:15:00	saturday
314	3	2014-06-10 11:00:00	tuesday
315	38	2014-06-12 16:15:00	thursday
316	32	2014-06-22 13:15:00	sunday
317	14	2014-06-04 14:00:00	wednesday
318	6	2014-06-23 10:30:00	monday
319	17	2014-06-14 11:15:00	saturday
320	9	2014-06-07 16:00:00	saturday
321	2	2014-06-29 13:00:00	sunday
322	16	2014-06-11 13:30:00	wednesday
323	38	2014-06-27 16:15:00	friday
324	38	2014-06-21 10:15:00	saturday
325	10	2014-06-11 15:45:00	wednesday
326	21	2014-06-28 08:45:00	saturday
327	30	2014-06-27 12:30:00	friday
328	18	2014-06-01 11:45:00	sunday
329	6	2014-06-02 10:15:00	monday
330	14	2014-06-28 17:30:00	saturday
331	13	2014-06-22 16:45:00	sunday
332	9	2014-06-12 08:00:00	thursday
333	2	2014-06-04 15:00:00	wednesday
334	15	2014-06-30 15:00:00	monday
335	4	2014-06-27 14:15:00	friday
336	4	2014-06-03 14:30:00	tuesday
337	32	2014-06-09 15:00:00	monday
338	1	2014-06-17 08:15:00	tuesday
339	15	2014-06-01 16:45:00	sunday
340	30	2014-06-02 15:45:00	monday
341	2	2014-06-15 11:15:00	sunday
342	32	2014-06-04 15:00:00	wednesday
343	24	2014-06-02 12:00:00	monday
344	18	2014-06-05 13:00:00	thursday
345	12	2014-06-28 11:00:00	saturday
346	13	2014-06-17 14:30:00	tuesday
347	25	2014-06-30 16:00:00	monday
348	10	2014-06-25 16:45:00	wednesday
349	15	2014-06-19 13:15:00	thursday
350	27	2014-06-23 10:00:00	monday
351	21	2014-06-18 09:30:00	wednesday
352	32	2014-06-27 11:45:00	friday
353	30	2014-06-08 09:15:00	sunday
354	14	2014-06-10 10:45:00	tuesday
355	6	2014-06-13 11:45:00	friday
356	15	2014-06-06 15:45:00	friday
357	36	2014-06-17 16:15:00	tuesday
358	6	2014-06-06 11:45:00	friday
359	40	2014-07-07 11:15:00	monday
360	1	2014-07-30 11:15:00	wednesday
361	19	2014-07-02 13:15:00	wednesday
362	39	2014-07-17 17:00:00	thursday
363	35	2014-07-28 17:15:00	monday
364	2	2014-07-30 11:15:00	wednesday
365	6	2014-07-11 11:00:00	friday
366	4	2014-07-19 15:15:00	saturday
367	27	2014-07-13 15:00:00	sunday
368	11	2014-07-01 09:00:00	tuesday
369	30	2014-07-24 17:15:00	thursday
370	30	2014-07-22 17:45:00	tuesday
371	11	2014-07-27 15:30:00	sunday
372	39	2014-07-26 14:45:00	saturday
373	32	2014-07-14 10:00:00	monday
374	32	2014-07-11 14:30:00	friday
375	5	2014-07-22 13:00:00	tuesday
376	32	2014-07-05 11:00:00	saturday
377	28	2014-07-07 10:45:00	monday
378	21	2014-07-26 12:15:00	saturday
379	27	2014-07-20 10:30:00	sunday
380	9	2014-07-20 10:00:00	sunday
381	30	2014-07-08 17:00:00	tuesday
382	40	2014-07-18 12:30:00	friday
383	7	2014-07-03 16:45:00	thursday
384	29	2014-07-04 15:45:00	friday
385	24	2014-07-23 09:30:00	wednesday
386	2	2014-07-24 12:45:00	thursday
387	38	2014-07-24 12:45:00	thursday
388	6	2014-07-24 14:15:00	thursday
389	5	2014-07-09 17:30:00	wednesday
390	14	2014-07-01 12:30:00	tuesday
391	31	2014-07-04 09:30:00	friday
392	14	2014-07-03 14:30:00	thursday
393	23	2014-07-20 09:30:00	sunday
394	23	2014-07-23 16:00:00	wednesday
395	8	2014-07-09 14:45:00	wednesday
396	25	2014-07-28 16:30:00	monday
397	32	2014-07-19 11:45:00	saturday
398	31	2014-07-30 08:45:00	wednesday
399	1	2014-07-30 08:45:00	wednesday
400	23	2014-07-10 17:15:00	thursday
401	28	2014-07-30 14:45:00	wednesday
402	9	2014-07-14 17:30:00	monday
403	37	2014-07-02 09:15:00	wednesday
404	13	2014-07-06 09:00:00	sunday
405	20	2014-07-04 13:30:00	friday
406	31	2014-07-12 14:45:00	saturday
407	24	2014-07-07 13:15:00	monday
408	12	2014-07-18 12:15:00	friday
409	19	2014-07-21 12:15:00	monday
410	4	2014-07-29 17:30:00	tuesday
411	27	2014-07-26 17:15:00	saturday
412	32	2014-07-03 08:45:00	thursday
413	12	2014-08-13 10:45:00	wednesday
414	18	2014-08-25 09:45:00	monday
415	24	2014-08-04 11:45:00	monday
416	1	2014-08-23 15:15:00	saturday
417	17	2014-08-19 14:15:00	tuesday
418	12	2014-08-12 12:30:00	tuesday
419	3	2014-08-25 10:45:00	monday
420	36	2014-08-18 09:30:00	monday
421	13	2014-08-22 12:30:00	friday
422	36	2014-08-16 16:45:00	saturday
423	14	2014-08-27 11:45:00	wednesday
424	34	2014-08-30 15:00:00	saturday
425	17	2014-08-06 09:00:00	wednesday
426	37	2014-08-28 11:00:00	thursday
427	19	2014-08-04 15:30:00	monday
428	22	2014-08-30 10:30:00	saturday
429	9	2014-08-22 11:15:00	friday
430	1	2014-08-21 15:15:00	thursday
431	29	2014-08-22 09:00:00	friday
432	19	2014-08-16 11:00:00	saturday
433	8	2014-08-14 09:15:00	thursday
434	3	2014-08-21 08:15:00	thursday
435	14	2014-08-18 15:15:00	monday
436	10	2014-08-16 09:30:00	saturday
437	23	2014-08-22 09:15:00	friday
438	13	2014-08-09 16:00:00	saturday
439	26	2014-08-25 14:00:00	monday
440	7	2014-08-18 09:30:00	monday
441	33	2014-08-21 08:15:00	thursday
442	26	2014-08-25 09:00:00	monday
443	9	2014-08-17 08:00:00	sunday
444	28	2014-08-05 13:30:00	tuesday
445	1	2014-08-04 16:15:00	monday
446	4	2014-08-01 08:30:00	friday
447	15	2014-08-14 08:45:00	thursday
448	36	2014-08-21 13:30:00	thursday
449	24	2014-08-05 08:30:00	tuesday
450	21	2014-08-27 17:30:00	wednesday
451	7	2014-08-03 10:30:00	sunday
452	40	2014-08-15 15:15:00	friday
453	19	2014-08-09 14:00:00	saturday
454	33	2014-08-04 10:15:00	monday
455	3	2014-08-27 08:15:00	wednesday
456	36	2014-08-18 09:30:00	monday
457	26	2014-08-24 17:45:00	sunday
458	2	2014-08-29 15:45:00	friday
459	37	2014-08-02 10:15:00	saturday
460	2	2014-08-07 15:30:00	thursday
461	33	2014-08-05 09:00:00	tuesday
462	26	2014-08-13 08:30:00	wednesday
463	24	2014-09-02 09:00:00	tuesday
464	21	2014-09-28 12:30:00	sunday
465	18	2014-09-28 11:15:00	sunday
466	3	2014-09-02 09:30:00	tuesday
467	6	2014-09-28 13:15:00	sunday
468	22	2014-09-22 17:30:00	monday
469	8	2014-09-08 09:00:00	monday
470	25	2014-09-06 14:00:00	saturday
471	26	2014-09-09 11:45:00	tuesday
472	33	2014-09-06 11:30:00	saturday
473	13	2014-09-25 15:00:00	thursday
474	37	2014-09-04 11:15:00	thursday
475	14	2014-09-15 11:30:00	monday
476	8	2014-09-25 15:45:00	thursday
477	19	2014-09-28 12:00:00	sunday
478	35	2014-09-29 11:00:00	monday
479	37	2014-09-26 11:00:00	friday
480	13	2014-09-05 14:00:00	friday
481	6	2014-09-13 12:15:00	saturday
482	5	2014-09-11 08:45:00	thursday
483	10	2014-09-23 17:00:00	tuesday
484	27	2014-09-22 12:00:00	monday
485	39	2014-09-11 11:00:00	thursday
486	20	2014-09-27 09:15:00	saturday
487	30	2014-09-09 09:45:00	tuesday
488	13	2014-09-07 11:15:00	sunday
489	17	2014-09-07 08:00:00	sunday
490	29	2014-09-10 12:00:00	wednesday
491	29	2014-09-16 08:00:00	tuesday
492	21	2014-09-04 15:30:00	thursday
493	31	2014-09-18 10:45:00	thursday
494	1	2014-09-28 12:30:00	sunday
495	9	2014-09-24 13:00:00	wednesday
496	21	2014-09-12 13:00:00	friday
497	27	2014-09-01 15:00:00	monday
498	34	2014-09-25 10:30:00	thursday
499	20	2014-09-22 14:45:00	monday
500	16	2014-09-21 16:15:00	sunday
501	24	2014-09-23 12:15:00	tuesday
502	28	2014-09-06 11:15:00	saturday
503	40	2014-09-03 17:45:00	wednesday
504	25	2014-09-23 12:30:00	tuesday
505	31	2014-09-06 13:45:00	saturday
506	40	2014-09-20 10:00:00	saturday
507	26	2014-09-20 10:00:00	saturday
508	34	2014-09-08 11:15:00	monday
509	37	2014-09-17 16:45:00	wednesday
510	9	2014-09-02 12:15:00	tuesday
511	26	2014-09-16 15:45:00	tuesday
512	5	2014-09-02 08:30:00	tuesday
513	18	2014-09-19 08:30:00	friday
514	19	2014-09-28 16:00:00	sunday
515	19	2014-09-24 10:45:00	wednesday
516	5	2014-09-20 17:45:00	saturday
517	26	2014-09-21 10:15:00	sunday
518	6	2014-09-08 15:30:00	monday
519	32	2014-09-30 15:15:00	tuesday
520	20	2014-09-19 13:15:00	friday
521	7	2014-09-18 10:45:00	thursday
522	22	2014-09-30 17:00:00	tuesday
523	36	2014-09-11 08:15:00	thursday
524	30	2014-09-24 17:00:00	wednesday
525	20	2014-10-13 14:15:00	monday
526	22	2014-10-25 14:30:00	saturday
527	24	2014-10-21 16:30:00	tuesday
528	28	2014-10-02 17:45:00	thursday
529	27	2014-10-18 12:30:00	saturday
530	31	2014-10-20 10:45:00	monday
531	16	2014-10-01 08:45:00	wednesday
532	25	2014-10-23 11:45:00	thursday
533	14	2014-10-26 11:30:00	sunday
534	13	2014-10-05 11:45:00	sunday
535	38	2014-10-06 17:00:00	monday
536	7	2014-10-18 08:15:00	saturday
537	25	2014-10-06 14:45:00	monday
538	9	2014-10-28 09:00:00	tuesday
539	11	2014-10-29 14:15:00	wednesday
540	10	2014-10-15 17:15:00	wednesday
541	21	2014-10-07 14:30:00	tuesday
542	6	2014-10-23 12:15:00	thursday
543	4	2014-10-22 10:15:00	wednesday
544	27	2014-10-09 10:00:00	thursday
545	13	2014-10-14 13:15:00	tuesday
546	31	2014-10-13 16:30:00	monday
547	34	2014-10-13 12:15:00	monday
548	29	2014-10-15 13:45:00	wednesday
549	36	2014-10-12 11:15:00	sunday
550	15	2014-10-07 16:15:00	tuesday
551	1	2014-10-17 13:45:00	friday
552	18	2014-10-07 10:30:00	tuesday
553	28	2014-10-16 12:15:00	thursday
554	39	2014-10-09 12:45:00	thursday
555	33	2014-10-05 11:15:00	sunday
556	13	2014-10-09 16:30:00	thursday
557	15	2014-10-25 15:00:00	saturday
558	34	2014-10-02 15:15:00	thursday
559	6	2014-10-08 14:00:00	wednesday
560	25	2014-10-09 17:30:00	thursday
561	9	2014-10-18 13:30:00	saturday
562	11	2014-10-02 11:30:00	thursday
563	11	2014-10-13 14:00:00	monday
564	24	2014-10-02 17:45:00	thursday
565	19	2014-10-28 15:00:00	tuesday
566	20	2014-10-21 11:45:00	tuesday
567	1	2014-10-08 13:15:00	wednesday
568	4	2014-11-02 16:00:00	sunday
569	24	2014-11-24 09:45:00	monday
570	32	2014-11-03 12:30:00	monday
571	4	2014-11-10 15:30:00	monday
572	33	2014-11-13 08:15:00	thursday
573	3	2014-11-01 11:00:00	saturday
574	17	2014-11-11 17:30:00	tuesday
575	14	2014-11-25 10:30:00	tuesday
576	31	2014-11-25 16:15:00	tuesday
577	22	2014-11-14 09:30:00	friday
578	18	2014-11-08 13:15:00	saturday
579	17	2014-11-04 16:45:00	tuesday
580	11	2014-11-09 09:15:00	sunday
581	20	2014-11-19 14:00:00	wednesday
582	13	2014-11-11 11:00:00	tuesday
583	31	2014-11-07 14:30:00	friday
584	22	2014-11-05 14:15:00	wednesday
585	14	2014-11-12 17:45:00	wednesday
586	29	2014-11-26 08:30:00	wednesday
587	37	2014-11-06 09:45:00	thursday
588	4	2014-11-02 17:30:00	sunday
589	9	2014-11-21 14:45:00	friday
590	20	2014-11-26 11:45:00	wednesday
591	11	2014-11-18 10:00:00	tuesday
592	21	2014-11-07 10:45:00	friday
593	21	2014-11-09 15:15:00	sunday
594	13	2014-11-13 08:30:00	thursday
595	36	2014-11-26 08:00:00	wednesday
596	30	2014-11-09 11:15:00	sunday
597	14	2014-11-01 11:00:00	saturday
598	26	2014-11-25 11:45:00	tuesday
599	3	2014-11-10 10:45:00	monday
600	16	2014-11-02 10:15:00	sunday
601	6	2014-11-30 08:45:00	sunday
602	14	2014-11-18 10:45:00	tuesday
603	19	2014-11-19 11:30:00	wednesday
604	6	2014-11-19 09:15:00	wednesday
605	40	2014-11-24 10:30:00	monday
606	11	2014-11-03 09:00:00	monday
607	37	2014-11-07 16:45:00	friday
608	11	2014-11-23 11:15:00	sunday
609	14	2014-11-13 10:30:00	thursday
610	20	2014-11-03 16:45:00	monday
611	21	2014-11-17 13:00:00	monday
612	24	2014-11-23 11:30:00	sunday
613	18	2014-11-29 12:45:00	saturday
614	27	2014-11-11 15:30:00	tuesday
615	29	2014-11-07 16:30:00	friday
616	17	2014-11-17 12:30:00	monday
617	24	2014-11-15 12:30:00	saturday
618	18	2014-11-21 12:00:00	friday
619	7	2014-11-15 14:45:00	saturday
620	32	2014-11-05 13:45:00	wednesday
621	33	2014-11-18 12:30:00	tuesday
622	21	2014-11-19 17:00:00	wednesday
623	30	2014-11-21 10:45:00	friday
624	8	2014-11-22 15:45:00	saturday
625	40	2014-11-12 11:00:00	wednesday
626	14	2014-11-23 13:30:00	sunday
627	28	2014-11-07 15:30:00	friday
628	10	2014-11-23 12:45:00	sunday
629	32	2014-11-02 10:00:00	sunday
630	39	2014-11-18 13:45:00	tuesday
631	20	2014-11-18 16:00:00	tuesday
632	18	2014-11-21 16:45:00	friday
633	11	2014-11-18 09:30:00	tuesday
634	2	2014-11-28 09:45:00	friday
635	40	2014-11-27 09:30:00	thursday
636	10	2014-12-22 13:00:00	monday
637	3	2014-12-27 10:30:00	saturday
638	11	2014-12-12 13:15:00	friday
639	28	2014-12-14 09:30:00	sunday
640	4	2014-12-20 16:30:00	saturday
641	4	2014-12-14 17:00:00	sunday
642	4	2014-12-23 08:45:00	tuesday
643	16	2014-12-25 16:00:00	thursday
644	12	2014-12-25 10:45:00	thursday
645	15	2014-12-15 13:45:00	monday
646	15	2014-12-20 15:00:00	saturday
647	25	2014-12-26 11:00:00	friday
648	26	2014-12-10 13:15:00	wednesday
649	39	2014-12-22 13:30:00	monday
650	22	2014-12-09 15:00:00	tuesday
651	40	2014-12-28 09:45:00	sunday
652	3	2014-12-09 09:15:00	tuesday
653	7	2014-12-02 10:15:00	tuesday
654	37	2014-12-26 09:15:00	friday
655	15	2014-12-22 17:45:00	monday
656	32	2014-12-19 15:45:00	friday
657	17	2014-12-19 08:00:00	friday
658	21	2014-12-25 09:30:00	thursday
659	18	2014-12-24 15:45:00	wednesday
660	29	2014-12-05 13:15:00	friday
661	40	2014-12-25 09:45:00	thursday
662	10	2014-12-19 14:00:00	friday
663	35	2014-12-01 16:00:00	monday
664	18	2014-12-08 13:45:00	monday
665	6	2014-12-03 13:00:00	wednesday
666	5	2014-12-16 16:15:00	tuesday
667	36	2014-12-18 08:15:00	thursday
668	28	2014-12-13 10:00:00	saturday
669	5	2014-12-16 15:45:00	tuesday
670	2	2014-12-07 16:15:00	sunday
671	32	2014-12-01 08:30:00	monday
672	4	2014-12-25 14:15:00	thursday
673	17	2014-12-04 12:30:00	thursday
674	34	2014-12-03 08:00:00	wednesday
675	2	2014-12-09 10:45:00	tuesday
676	21	2014-12-17 16:45:00	wednesday
677	3	2014-12-18 17:45:00	thursday
678	17	2014-12-08 09:30:00	monday
679	35	2014-12-27 16:00:00	saturday
680	34	2014-12-14 16:15:00	sunday
681	38	2014-12-02 15:15:00	tuesday
682	8	2014-12-01 14:30:00	monday
683	23	2014-12-25 08:30:00	thursday
684	29	2014-12-18 17:00:00	thursday
685	13	2014-12-15 13:00:00	monday
686	35	2014-12-13 16:15:00	saturday
687	23	2014-12-21 10:30:00	sunday
688	40	2014-12-14 09:15:00	sunday
689	9	2014-12-11 11:15:00	thursday
690	35	2014-12-17 14:15:00	wednesday
691	39	2014-12-17 09:15:00	wednesday
692	14	2014-12-21 11:45:00	sunday
693	15	2014-12-05 15:30:00	friday
694	12	2014-12-04 08:15:00	thursday
695	9	2014-12-27 13:00:00	saturday
696	33	2014-12-17 12:45:00	wednesday
697	7	2014-12-17 11:30:00	wednesday
698	31	2014-12-09 08:45:00	tuesday
699	7	2014-12-26 15:45:00	friday
700	21	2014-12-27 16:45:00	saturday
701	34	2015-01-12 16:45:00	monday
702	12	2015-01-16 14:00:00	friday
703	28	2015-01-24 09:30:00	saturday
704	18	2015-01-19 14:15:00	monday
705	37	2015-01-19 14:30:00	monday
706	8	2015-01-16 13:00:00	friday
707	15	2015-01-30 17:15:00	friday
708	13	2015-01-30 17:30:00	friday
709	20	2015-01-04 17:15:00	sunday
710	7	2015-01-26 13:15:00	monday
711	23	2015-01-09 14:15:00	friday
712	9	2015-01-01 16:00:00	thursday
713	40	2015-01-05 08:45:00	monday
714	20	2015-01-24 15:45:00	saturday
715	38	2015-01-17 13:45:00	saturday
716	30	2015-01-09 13:00:00	friday
717	12	2015-01-30 08:45:00	friday
718	40	2015-01-20 11:15:00	tuesday
719	6	2015-01-02 14:00:00	friday
720	9	2015-01-01 14:15:00	thursday
721	11	2015-01-28 15:15:00	wednesday
722	14	2015-01-23 11:00:00	friday
723	18	2015-01-22 16:00:00	thursday
724	12	2015-01-06 08:45:00	tuesday
725	15	2015-01-05 13:45:00	monday
726	17	2015-01-09 13:15:00	friday
727	36	2015-01-03 15:45:00	saturday
728	16	2015-01-08 08:45:00	thursday
729	26	2015-01-14 15:45:00	wednesday
730	35	2015-01-21 17:45:00	wednesday
731	32	2015-01-01 15:00:00	thursday
732	1	2015-01-21 11:15:00	wednesday
733	16	2015-01-11 11:00:00	sunday
734	31	2015-01-22 14:45:00	thursday
735	6	2015-01-29 10:00:00	thursday
736	16	2015-02-17 13:30:00	tuesday
737	2	2015-02-17 10:15:00	tuesday
738	7	2015-02-18 15:15:00	wednesday
739	27	2015-02-11 13:30:00	wednesday
740	26	2015-02-15 16:45:00	sunday
741	27	2015-02-04 09:45:00	wednesday
742	30	2015-02-20 12:45:00	friday
743	7	2015-02-06 16:00:00	friday
744	23	2015-02-21 16:45:00	saturday
745	38	2015-02-23 12:30:00	monday
746	30	2015-02-05 16:00:00	thursday
747	7	2015-02-10 16:15:00	tuesday
748	3	2015-02-28 09:30:00	saturday
749	5	2015-02-02 15:00:00	monday
750	26	2015-02-20 09:15:00	friday
751	28	2015-02-01 12:45:00	sunday
752	15	2015-02-15 15:30:00	sunday
753	10	2015-02-02 13:45:00	monday
754	4	2015-02-14 17:30:00	saturday
755	9	2015-02-07 13:30:00	saturday
756	7	2015-02-03 17:00:00	tuesday
757	1	2015-02-15 13:30:00	sunday
758	39	2015-02-04 09:45:00	wednesday
759	16	2015-02-01 16:30:00	sunday
760	5	2015-02-09 14:30:00	monday
761	27	2015-02-26 16:00:00	thursday
762	5	2015-02-25 14:30:00	wednesday
763	36	2015-02-10 11:45:00	tuesday
764	20	2015-02-21 09:00:00	saturday
765	12	2015-02-07 10:45:00	saturday
766	9	2015-02-03 11:00:00	tuesday
767	39	2015-02-24 14:30:00	tuesday
768	22	2015-02-27 09:00:00	friday
769	28	2015-02-15 13:45:00	sunday
770	37	2015-02-13 17:15:00	friday
771	4	2015-02-23 08:15:00	monday
772	29	2015-02-21 09:45:00	saturday
773	33	2015-02-06 09:45:00	friday
774	4	2015-02-01 12:45:00	sunday
775	14	2015-02-23 11:45:00	monday
776	28	2015-02-06 15:00:00	friday
777	26	2015-02-05 11:45:00	thursday
778	40	2015-02-03 17:30:00	tuesday
779	22	2015-02-26 12:00:00	thursday
780	21	2015-03-24 15:00:00	tuesday
781	20	2015-03-28 16:45:00	saturday
782	35	2015-03-01 08:45:00	sunday
783	8	2015-03-25 14:00:00	wednesday
784	20	2015-03-18 17:45:00	wednesday
785	40	2015-03-30 09:30:00	monday
786	33	2015-03-08 09:15:00	sunday
787	5	2015-03-23 16:30:00	monday
788	18	2015-03-23 13:15:00	monday
789	18	2015-03-01 12:00:00	sunday
790	12	2015-03-09 10:30:00	monday
791	1	2015-03-04 16:00:00	wednesday
792	1	2015-03-26 15:15:00	thursday
793	11	2015-03-04 17:30:00	wednesday
794	30	2015-03-25 09:45:00	wednesday
795	14	2015-03-18 12:15:00	wednesday
796	30	2015-03-21 12:00:00	saturday
797	30	2015-03-19 16:30:00	thursday
798	9	2015-03-02 14:15:00	monday
799	14	2015-03-14 15:45:00	saturday
800	9	2015-03-18 11:45:00	wednesday
801	30	2015-03-15 14:30:00	sunday
802	1	2015-03-03 09:00:00	tuesday
803	4	2015-03-21 15:15:00	saturday
804	38	2015-03-13 17:45:00	friday
805	37	2015-03-21 08:30:00	saturday
806	24	2015-03-16 12:30:00	monday
807	3	2015-03-03 15:15:00	tuesday
808	7	2015-03-05 11:15:00	thursday
809	5	2015-03-29 10:00:00	sunday
810	23	2015-03-19 16:00:00	thursday
811	20	2015-04-06 16:15:00	monday
812	38	2015-04-18 16:00:00	saturday
813	26	2015-04-23 14:45:00	thursday
814	35	2015-04-02 09:30:00	thursday
815	18	2015-04-15 11:15:00	wednesday
816	23	2015-04-03 08:15:00	friday
817	13	2015-04-09 09:00:00	thursday
818	29	2015-04-13 10:45:00	monday
819	1	2015-04-23 11:00:00	thursday
820	10	2015-04-05 13:00:00	sunday
821	25	2015-04-02 13:00:00	thursday
822	39	2015-04-14 15:45:00	tuesday
823	2	2015-04-03 17:45:00	friday
824	28	2015-04-11 17:15:00	saturday
825	33	2015-04-27 17:30:00	monday
826	29	2015-04-03 13:00:00	friday
827	31	2015-04-12 09:15:00	sunday
828	22	2015-04-11 09:00:00	saturday
829	7	2015-04-12 08:15:00	sunday
830	8	2015-04-21 11:45:00	tuesday
831	4	2015-04-10 16:45:00	friday
832	27	2015-04-28 14:45:00	tuesday
833	29	2015-04-30 14:45:00	thursday
834	28	2015-04-14 12:30:00	tuesday
835	11	2015-04-07 08:00:00	tuesday
836	6	2015-04-24 12:00:00	friday
837	7	2015-04-28 13:30:00	tuesday
838	26	2015-04-02 11:30:00	thursday
839	38	2015-04-16 13:15:00	thursday
840	33	2015-04-03 15:15:00	friday
841	38	2015-04-27 16:15:00	monday
842	30	2015-04-28 11:30:00	tuesday
843	8	2015-04-13 15:15:00	monday
844	14	2015-04-05 10:00:00	sunday
845	6	2015-04-22 11:15:00	wednesday
846	1	2015-04-30 17:30:00	thursday
847	36	2015-04-10 16:30:00	friday
848	24	2015-05-25 15:45:00	monday
849	8	2015-05-26 16:30:00	tuesday
850	30	2015-05-17 16:45:00	sunday
851	19	2015-05-20 09:00:00	wednesday
852	26	2015-05-04 17:00:00	monday
853	23	2015-05-07 08:45:00	thursday
854	9	2015-05-28 12:00:00	thursday
855	40	2015-05-10 14:30:00	sunday
856	37	2015-05-05 09:45:00	tuesday
857	14	2015-05-24 13:30:00	sunday
858	2	2015-05-16 17:30:00	saturday
859	23	2015-05-09 12:30:00	saturday
860	21	2015-05-30 13:15:00	saturday
861	30	2015-05-22 13:15:00	friday
862	13	2015-05-09 11:00:00	saturday
863	1	2015-05-19 11:30:00	tuesday
864	28	2015-05-14 09:45:00	thursday
865	20	2015-05-12 08:45:00	tuesday
866	13	2015-05-23 10:30:00	saturday
867	16	2015-05-29 10:45:00	friday
868	29	2015-05-21 14:45:00	thursday
869	16	2015-05-17 17:45:00	sunday
870	11	2015-05-02 10:15:00	saturday
871	40	2015-05-05 16:00:00	tuesday
872	1	2015-05-13 11:00:00	wednesday
873	6	2015-05-30 15:30:00	saturday
874	18	2015-05-29 09:15:00	friday
875	27	2015-05-18 12:45:00	monday
876	12	2015-05-12 10:15:00	tuesday
877	32	2015-05-10 14:15:00	sunday
878	13	2015-05-23 15:30:00	saturday
879	19	2015-05-19 10:30:00	tuesday
880	32	2015-05-15 17:15:00	friday
881	17	2015-05-04 08:45:00	monday
882	7	2015-05-23 17:45:00	saturday
883	3	2015-05-05 13:30:00	tuesday
884	7	2015-05-04 14:15:00	monday
885	35	2015-05-05 11:30:00	tuesday
886	1	2015-05-08 09:30:00	friday
887	14	2015-05-23 15:15:00	saturday
888	21	2015-05-20 14:30:00	wednesday
889	9	2015-05-30 14:30:00	saturday
890	38	2015-05-12 08:00:00	tuesday
891	29	2015-05-29 15:15:00	friday
892	34	2015-05-22 11:45:00	friday
893	4	2015-05-02 16:45:00	saturday
894	9	2015-05-08 08:00:00	friday
895	27	2015-06-11 09:15:00	thursday
896	11	2015-06-25 15:15:00	thursday
897	32	2015-06-02 15:30:00	tuesday
898	28	2015-06-29 16:45:00	monday
899	12	2015-06-14 17:15:00	sunday
900	10	2015-06-29 10:45:00	monday
901	24	2015-06-23 13:15:00	tuesday
902	34	2015-06-17 13:30:00	wednesday
903	33	2015-06-15 15:00:00	monday
904	24	2015-06-28 10:30:00	sunday
905	21	2015-06-26 08:30:00	friday
906	21	2015-06-13 10:00:00	saturday
907	4	2015-06-29 08:45:00	monday
908	1	2015-06-26 12:15:00	friday
909	34	2015-06-28 09:00:00	sunday
910	40	2015-06-13 10:00:00	saturday
911	25	2015-06-21 14:00:00	sunday
912	38	2015-06-04 15:00:00	thursday
913	25	2015-06-10 16:30:00	wednesday
914	38	2015-06-21 16:00:00	sunday
915	2	2015-06-09 10:00:00	tuesday
916	20	2015-06-20 16:45:00	saturday
917	38	2015-06-15 11:45:00	monday
918	31	2015-06-27 17:15:00	saturday
919	9	2015-06-05 14:45:00	friday
920	27	2015-06-07 15:30:00	sunday
921	26	2015-06-21 11:30:00	sunday
922	9	2015-06-26 16:30:00	friday
923	1	2015-06-27 11:15:00	saturday
924	14	2015-06-24 16:45:00	wednesday
925	33	2015-06-30 17:15:00	tuesday
926	27	2015-06-29 13:30:00	monday
927	29	2015-06-15 14:30:00	monday
928	25	2015-06-28 11:45:00	sunday
929	36	2015-06-28 12:00:00	sunday
930	34	2015-06-21 14:15:00	sunday
931	38	2015-06-02 16:30:00	tuesday
932	29	2015-07-01 10:30:00	wednesday
933	6	2015-07-04 16:30:00	saturday
934	40	2015-07-26 17:30:00	sunday
935	24	2015-07-15 16:15:00	wednesday
936	29	2015-07-11 15:30:00	saturday
937	2	2015-07-29 17:15:00	wednesday
938	15	2015-07-21 14:30:00	tuesday
939	12	2015-07-14 16:15:00	tuesday
940	28	2015-07-28 17:45:00	tuesday
941	9	2015-07-30 09:30:00	thursday
942	10	2015-07-07 17:00:00	tuesday
943	22	2015-07-13 17:00:00	monday
944	19	2015-07-11 17:45:00	saturday
945	24	2015-07-13 17:00:00	monday
946	11	2015-07-17 16:30:00	friday
947	40	2015-07-29 09:30:00	wednesday
948	14	2015-07-22 12:00:00	wednesday
949	7	2015-07-30 16:15:00	thursday
950	37	2015-07-03 17:45:00	friday
951	28	2015-07-03 16:15:00	friday
952	7	2015-07-02 15:15:00	thursday
953	34	2015-07-13 14:00:00	monday
954	33	2015-07-26 14:15:00	sunday
955	4	2015-07-29 10:30:00	wednesday
956	9	2015-07-22 09:00:00	wednesday
957	20	2015-07-03 08:00:00	friday
958	28	2015-07-29 10:15:00	wednesday
959	13	2015-07-15 17:45:00	wednesday
960	37	2015-07-29 16:15:00	wednesday
961	5	2015-07-01 11:45:00	wednesday
962	31	2015-07-25 10:45:00	saturday
963	15	2015-07-29 15:30:00	wednesday
964	39	2015-07-19 08:45:00	sunday
965	26	2015-07-15 11:15:00	wednesday
966	5	2015-07-26 08:15:00	sunday
967	5	2015-07-11 13:45:00	saturday
968	9	2015-07-07 09:45:00	tuesday
969	13	2015-07-08 17:45:00	wednesday
970	15	2015-07-26 16:15:00	sunday
971	10	2015-07-18 15:30:00	saturday
972	37	2015-07-21 14:30:00	tuesday
973	40	2015-08-28 17:30:00	friday
974	34	2015-08-17 15:15:00	monday
975	33	2015-08-12 10:15:00	wednesday
976	39	2015-08-01 10:30:00	saturday
977	21	2015-08-24 16:15:00	monday
978	31	2015-08-16 16:30:00	sunday
979	3	2015-08-16 17:45:00	sunday
980	7	2015-08-11 17:30:00	tuesday
981	39	2015-08-10 08:30:00	monday
982	24	2015-08-01 08:45:00	saturday
983	28	2015-08-26 08:45:00	wednesday
984	18	2015-08-30 17:15:00	sunday
985	1	2015-08-09 15:00:00	sunday
986	33	2015-08-16 16:15:00	sunday
987	22	2015-08-10 11:45:00	monday
988	34	2015-08-25 13:30:00	tuesday
989	37	2015-08-04 08:15:00	tuesday
990	35	2015-08-05 14:30:00	wednesday
991	35	2015-08-28 16:45:00	friday
992	16	2015-08-21 15:45:00	friday
993	14	2015-08-15 10:45:00	saturday
994	10	2015-08-27 15:15:00	thursday
995	14	2015-08-24 16:00:00	monday
996	16	2015-08-13 11:45:00	thursday
997	21	2015-08-02 15:00:00	sunday
998	15	2015-08-26 11:30:00	wednesday
999	9	2015-08-01 17:45:00	saturday
1000	35	2015-08-19 14:30:00	wednesday
1001	7	2015-08-20 17:45:00	thursday
1002	6	2015-08-25 13:45:00	tuesday
1003	15	2015-08-29 08:15:00	saturday
1004	21	2015-08-02 08:00:00	sunday
1005	20	2015-08-03 08:45:00	monday
1006	16	2015-08-07 15:45:00	friday
1007	3	2015-08-27 16:00:00	thursday
1008	17	2015-08-02 14:30:00	sunday
1009	32	2015-08-28 13:00:00	friday
1010	1	2015-08-01 14:30:00	saturday
1011	14	2015-08-03 15:30:00	monday
1012	23	2015-08-18 16:30:00	tuesday
1013	29	2015-08-05 16:00:00	wednesday
1014	2	2015-09-19 17:30:00	saturday
1015	35	2015-09-21 13:15:00	monday
1016	4	2015-09-17 11:45:00	thursday
1017	6	2015-09-01 15:00:00	tuesday
1018	39	2015-09-13 17:15:00	sunday
1019	14	2015-09-19 08:15:00	saturday
1020	17	2015-09-17 15:30:00	thursday
1021	29	2015-09-22 10:45:00	tuesday
1022	17	2015-09-15 15:15:00	tuesday
1023	8	2015-09-22 14:00:00	tuesday
1024	9	2015-09-22 17:45:00	tuesday
1025	36	2015-09-21 10:30:00	monday
1026	28	2015-09-04 13:15:00	friday
1027	35	2015-09-01 12:30:00	tuesday
1028	15	2015-09-12 08:30:00	saturday
1029	15	2015-09-30 12:00:00	wednesday
1030	17	2015-09-19 17:00:00	saturday
1031	28	2015-09-10 12:45:00	thursday
1032	20	2015-09-10 16:00:00	thursday
1033	7	2015-09-28 10:45:00	monday
1034	3	2015-09-11 12:45:00	friday
1035	18	2015-09-07 15:45:00	monday
1036	28	2015-09-22 17:30:00	tuesday
1037	31	2015-09-17 16:15:00	thursday
1038	29	2015-09-26 14:30:00	saturday
1039	35	2015-09-15 12:30:00	tuesday
1040	25	2015-09-17 14:45:00	thursday
1041	34	2015-09-12 09:30:00	saturday
1042	2	2015-09-03 08:00:00	thursday
1043	23	2015-09-05 16:45:00	saturday
1044	29	2015-09-20 13:30:00	sunday
1045	2	2015-09-10 13:00:00	thursday
1046	19	2015-09-14 09:45:00	monday
1047	25	2015-09-29 09:15:00	tuesday
1048	28	2015-09-14 09:15:00	monday
1049	2	2015-09-07 10:45:00	monday
1050	27	2015-09-09 12:00:00	wednesday
1051	36	2015-09-13 08:45:00	sunday
1052	15	2015-09-15 08:00:00	tuesday
1053	11	2015-09-07 11:15:00	monday
1054	29	2015-09-28 12:00:00	monday
1055	35	2015-09-24 15:00:00	thursday
1056	17	2015-09-25 09:45:00	friday
1057	10	2015-09-23 14:00:00	wednesday
1058	36	2015-09-12 14:30:00	saturday
1059	40	2015-09-25 13:00:00	friday
1060	4	2015-09-02 08:00:00	wednesday
1061	31	2015-09-27 12:45:00	sunday
1062	33	2015-10-06 15:15:00	tuesday
1063	12	2015-10-18 08:45:00	sunday
1064	27	2015-10-03 12:00:00	saturday
1065	6	2015-10-02 12:00:00	friday
1066	7	2015-10-13 12:00:00	tuesday
1067	12	2015-10-05 10:15:00	monday
1068	9	2015-10-18 16:30:00	sunday
1069	25	2015-10-26 12:45:00	monday
1070	33	2015-10-29 13:00:00	thursday
1071	1	2015-10-07 09:30:00	wednesday
1072	24	2015-10-06 16:00:00	tuesday
1073	11	2015-10-23 16:45:00	friday
1074	9	2015-10-22 17:30:00	thursday
1075	14	2015-10-11 13:30:00	sunday
1076	10	2015-10-01 09:15:00	thursday
1077	30	2015-10-04 12:30:00	sunday
1078	2	2015-10-12 10:15:00	monday
1079	5	2015-10-19 16:45:00	monday
1080	26	2015-10-25 12:15:00	sunday
1081	36	2015-10-14 08:45:00	wednesday
1082	22	2015-10-24 12:00:00	saturday
1083	34	2015-10-20 12:45:00	tuesday
1084	27	2015-10-10 11:45:00	saturday
1085	16	2015-10-10 08:30:00	saturday
1086	16	2015-10-26 13:30:00	monday
1087	13	2015-10-16 14:45:00	friday
1088	23	2015-10-17 14:15:00	saturday
1089	30	2015-10-30 17:00:00	friday
1090	26	2015-10-23 15:45:00	friday
1091	10	2015-10-22 15:00:00	thursday
1092	8	2015-10-01 16:15:00	thursday
1093	14	2015-10-12 08:30:00	monday
1094	31	2015-10-08 17:00:00	thursday
1095	12	2015-10-09 10:00:00	friday
1096	9	2015-10-07 16:15:00	wednesday
1097	35	2015-10-30 10:30:00	friday
1098	17	2015-10-08 12:00:00	thursday
1099	4	2015-10-16 12:45:00	friday
1100	21	2015-10-01 09:00:00	thursday
1101	9	2015-11-19 08:15:00	thursday
1102	3	2015-11-23 17:30:00	monday
1103	30	2015-11-06 08:45:00	friday
1104	37	2015-11-16 15:30:00	monday
1105	18	2015-11-10 11:15:00	tuesday
1106	23	2015-11-10 08:45:00	tuesday
1107	36	2015-11-02 11:15:00	monday
1108	5	2015-11-10 08:15:00	tuesday
1109	39	2015-11-02 15:00:00	monday
1110	24	2015-11-02 08:30:00	monday
1111	32	2015-11-20 15:15:00	friday
1112	15	2015-11-13 12:15:00	friday
1113	37	2015-11-05 14:30:00	thursday
1114	40	2015-11-15 09:00:00	sunday
1115	37	2015-11-30 17:15:00	monday
1116	6	2015-11-29 11:15:00	sunday
1117	20	2015-11-25 14:00:00	wednesday
1118	1	2015-11-08 15:45:00	sunday
1119	29	2015-11-01 15:30:00	sunday
1120	36	2015-11-23 15:15:00	monday
1121	32	2015-11-10 14:15:00	tuesday
1122	39	2015-11-04 14:45:00	wednesday
1123	3	2015-11-09 11:00:00	monday
1124	18	2015-11-14 11:15:00	saturday
1125	27	2015-11-10 12:45:00	tuesday
1126	20	2015-11-06 15:30:00	friday
1127	18	2015-11-18 11:30:00	wednesday
1128	37	2015-11-13 12:00:00	friday
1129	39	2015-11-03 08:45:00	tuesday
1130	18	2015-11-27 09:45:00	friday
1131	19	2015-11-11 11:00:00	wednesday
1132	15	2015-11-14 15:15:00	saturday
1133	8	2015-11-09 09:15:00	monday
1134	4	2015-11-09 13:45:00	monday
1135	2	2015-11-19 12:00:00	thursday
1136	1	2015-11-14 09:30:00	saturday
1137	15	2015-11-08 12:00:00	sunday
1138	11	2015-11-16 16:15:00	monday
1139	8	2015-11-21 13:00:00	saturday
1140	39	2015-11-13 13:15:00	friday
1141	40	2015-11-14 15:00:00	saturday
1142	4	2015-11-02 14:45:00	monday
1143	17	2015-11-24 08:30:00	tuesday
1144	27	2015-11-08 15:00:00	sunday
1145	36	2015-11-13 13:00:00	friday
1146	24	2015-11-26 16:15:00	thursday
1147	39	2015-11-16 15:00:00	monday
1148	23	2015-11-02 15:45:00	monday
1149	22	2015-11-21 08:15:00	saturday
1150	9	2015-11-08 10:45:00	sunday
1151	4	2015-11-15 09:15:00	sunday
1152	39	2015-11-29 09:00:00	sunday
1153	9	2015-11-06 14:00:00	friday
1154	35	2015-11-10 08:45:00	tuesday
1155	27	2015-11-06 13:30:00	friday
1156	27	2015-11-10 16:45:00	tuesday
1157	22	2015-12-04 14:45:00	friday
1158	15	2015-12-16 16:00:00	wednesday
1159	22	2015-12-23 16:45:00	wednesday
1160	32	2015-12-02 13:30:00	wednesday
1161	2	2015-12-03 09:00:00	thursday
1162	1	2015-12-17 16:30:00	thursday
1163	17	2015-12-11 17:45:00	friday
1164	23	2015-12-14 14:45:00	monday
1165	13	2015-12-15 15:30:00	tuesday
1166	11	2015-12-30 08:00:00	wednesday
1167	4	2015-12-22 12:00:00	tuesday
1168	28	2015-12-23 13:15:00	wednesday
1169	19	2015-12-18 10:30:00	friday
1170	6	2015-12-06 08:45:00	sunday
1171	3	2015-12-17 12:00:00	thursday
1172	7	2015-12-25 11:30:00	friday
1173	15	2015-12-10 08:45:00	thursday
1174	23	2015-12-29 16:00:00	tuesday
1175	1	2015-12-09 11:30:00	wednesday
1176	29	2015-12-08 08:45:00	tuesday
1177	9	2015-12-20 08:15:00	sunday
1178	22	2015-12-20 09:15:00	sunday
1179	8	2015-12-04 15:30:00	friday
1180	23	2015-12-14 14:00:00	monday
1181	38	2015-12-15 13:00:00	tuesday
1182	32	2015-12-08 13:30:00	tuesday
1183	26	2015-12-10 12:15:00	thursday
1184	32	2015-12-21 17:45:00	monday
1185	16	2015-12-18 10:30:00	friday
1186	13	2015-12-06 13:00:00	sunday
1187	25	2015-12-08 08:15:00	tuesday
1188	3	2015-12-08 14:45:00	tuesday
1189	40	2015-12-02 11:30:00	wednesday
1190	25	2015-12-18 10:15:00	friday
1191	25	2015-12-16 09:45:00	wednesday
1192	34	2015-12-09 14:15:00	wednesday
1193	27	2015-12-14 14:00:00	monday
1194	15	2015-12-29 15:15:00	tuesday
1195	12	2015-12-09 09:30:00	wednesday
1196	15	2015-12-16 15:00:00	wednesday
1197	1	2015-12-08 17:45:00	tuesday
1198	32	2015-12-05 13:45:00	saturday
1199	21	2015-12-01 13:30:00	tuesday
1200	29	2015-12-04 09:00:00	friday
1201	39	2016-01-10 13:15:00	sunday
1202	14	2016-01-18 14:00:00	monday
1203	1	2016-01-30 09:15:00	saturday
1204	10	2016-01-30 14:45:00	saturday
1205	18	2016-01-02 17:00:00	saturday
1206	34	2016-01-29 16:00:00	friday
1207	9	2016-01-01 12:30:00	friday
1208	2	2016-01-14 15:45:00	thursday
1209	32	2016-01-24 13:00:00	sunday
1210	9	2016-01-25 08:45:00	monday
1211	13	2016-01-10 12:45:00	sunday
1212	34	2016-01-17 13:15:00	sunday
1213	22	2016-01-30 12:45:00	saturday
1214	23	2016-01-14 11:00:00	thursday
1215	10	2016-01-03 14:15:00	sunday
1216	14	2016-01-22 09:00:00	friday
1217	36	2016-01-20 15:30:00	wednesday
1218	22	2016-01-24 11:00:00	sunday
1219	33	2016-01-23 16:15:00	saturday
1220	32	2016-01-27 15:30:00	wednesday
1221	30	2016-01-14 10:00:00	thursday
1222	24	2016-01-14 09:00:00	thursday
1223	20	2016-01-12 17:00:00	tuesday
1224	18	2016-01-23 13:30:00	saturday
1225	14	2016-02-20 17:00:00	saturday
1226	7	2016-02-15 09:45:00	monday
1227	8	2016-02-18 10:30:00	thursday
1228	8	2016-02-27 13:45:00	saturday
1229	31	2016-02-26 17:45:00	friday
1230	23	2016-02-28 15:30:00	sunday
1231	36	2016-02-12 14:15:00	friday
1232	26	2016-02-03 08:15:00	wednesday
1233	11	2016-02-12 15:30:00	friday
1234	17	2016-02-23 15:00:00	tuesday
1235	22	2016-02-11 16:30:00	thursday
1236	37	2016-02-07 17:15:00	sunday
1237	28	2016-02-06 08:15:00	saturday
1238	17	2016-02-03 13:30:00	wednesday
1239	38	2016-02-16 14:15:00	tuesday
1240	18	2016-02-27 10:45:00	saturday
1241	6	2016-02-20 14:45:00	saturday
1242	40	2016-02-06 17:45:00	saturday
1243	15	2016-02-04 16:00:00	thursday
1244	21	2016-02-08 15:15:00	monday
1245	26	2016-02-15 12:30:00	monday
1246	10	2016-02-08 11:30:00	monday
1247	37	2016-02-07 09:15:00	sunday
1248	22	2016-02-02 15:00:00	tuesday
1249	19	2016-03-23 11:30:00	wednesday
1250	8	2016-03-27 17:15:00	sunday
1251	32	2016-03-11 10:00:00	friday
1252	26	2016-03-04 10:15:00	friday
1253	36	2016-03-24 15:30:00	thursday
1254	22	2016-03-16 14:00:00	wednesday
1255	29	2016-03-21 09:45:00	monday
1256	26	2016-03-09 12:45:00	wednesday
1257	7	2016-03-10 13:15:00	thursday
1258	29	2016-03-06 10:30:00	sunday
1259	37	2016-03-30 08:00:00	wednesday
1260	17	2016-03-18 09:00:00	friday
1261	14	2016-03-27 15:45:00	sunday
1262	33	2016-03-12 14:00:00	saturday
1263	35	2016-03-20 15:15:00	sunday
1264	10	2016-03-17 10:00:00	thursday
1265	29	2016-03-05 14:45:00	saturday
1266	3	2016-03-20 13:15:00	sunday
1267	17	2016-03-09 12:30:00	wednesday
1268	6	2016-03-16 08:00:00	wednesday
1269	5	2016-03-13 14:00:00	sunday
1270	7	2016-03-29 10:45:00	tuesday
1271	10	2016-03-07 14:45:00	monday
1272	17	2016-03-28 13:15:00	monday
1273	17	2016-03-11 08:45:00	friday
1274	30	2016-03-03 08:00:00	thursday
1275	32	2016-03-16 11:15:00	wednesday
1276	13	2016-03-12 11:30:00	saturday
1277	12	2016-03-07 12:00:00	monday
1278	35	2016-03-24 16:15:00	thursday
1279	30	2016-03-05 16:00:00	saturday
1280	37	2016-04-13 11:30:00	wednesday
1281	40	2016-04-27 16:45:00	wednesday
1282	26	2016-04-15 11:15:00	friday
1283	7	2016-04-25 09:15:00	monday
1284	2	2016-04-11 10:30:00	monday
1285	24	2016-04-29 15:15:00	friday
1286	35	2016-04-09 14:00:00	saturday
1287	20	2016-04-26 12:00:00	tuesday
1288	32	2016-04-28 13:30:00	thursday
1289	30	2016-04-03 15:30:00	sunday
1290	26	2016-04-03 13:00:00	sunday
1291	25	2016-04-05 13:00:00	tuesday
1292	25	2016-04-15 12:15:00	friday
1293	36	2016-04-28 12:00:00	thursday
1294	34	2016-04-09 17:30:00	saturday
1295	39	2016-04-22 12:45:00	friday
1296	24	2016-04-08 16:45:00	friday
1297	13	2016-04-02 08:15:00	saturday
1298	12	2016-04-02 14:15:00	saturday
1299	10	2016-04-24 12:15:00	sunday
1300	22	2016-04-06 12:45:00	wednesday
1301	20	2016-04-20 16:00:00	wednesday
1302	3	2016-04-24 11:45:00	sunday
1303	4	2016-04-03 11:30:00	sunday
1304	31	2016-04-24 12:00:00	sunday
1305	19	2016-04-26 15:15:00	tuesday
1306	26	2016-04-13 14:00:00	wednesday
1307	7	2016-04-27 12:00:00	wednesday
1308	5	2016-04-17 12:30:00	sunday
1309	13	2016-05-11 15:45:00	wednesday
1310	27	2016-05-25 09:15:00	wednesday
1311	6	2016-05-06 14:30:00	friday
1312	10	2016-05-15 13:45:00	sunday
1313	20	2016-05-17 16:30:00	tuesday
1314	1	2016-05-13 08:45:00	friday
1315	19	2016-05-30 10:00:00	monday
1316	18	2016-05-15 12:00:00	sunday
1317	26	2016-05-14 13:30:00	saturday
1318	14	2016-05-26 08:30:00	thursday
1319	34	2016-05-01 15:45:00	sunday
1320	29	2016-05-19 10:45:00	thursday
1321	19	2016-05-19 08:30:00	thursday
1322	37	2016-05-01 11:45:00	sunday
1323	27	2016-05-12 09:00:00	thursday
1324	32	2016-05-03 17:15:00	tuesday
1325	32	2016-05-05 10:15:00	thursday
1326	17	2016-05-18 12:30:00	wednesday
1327	34	2016-05-10 12:45:00	tuesday
1328	36	2016-05-05 17:15:00	thursday
1329	28	2016-05-28 16:30:00	saturday
1330	10	2016-05-04 11:45:00	wednesday
1331	2	2016-05-05 13:15:00	thursday
1332	37	2016-05-10 17:45:00	tuesday
1333	2	2016-05-13 14:15:00	friday
1334	6	2016-05-13 13:00:00	friday
1335	37	2016-05-14 10:30:00	saturday
1336	35	2016-06-14 14:15:00	tuesday
1337	28	2016-06-17 10:45:00	friday
1338	36	2016-06-14 14:45:00	tuesday
1339	37	2016-06-08 08:30:00	wednesday
1340	27	2016-06-20 16:00:00	monday
1341	5	2016-06-10 09:00:00	friday
1342	18	2016-06-27 11:45:00	monday
1343	20	2016-06-03 12:15:00	friday
1344	30	2016-06-21 08:30:00	tuesday
1345	22	2016-06-10 14:15:00	friday
1346	31	2016-06-17 09:15:00	friday
1347	15	2016-06-22 13:45:00	wednesday
1348	31	2016-06-12 13:30:00	sunday
1349	28	2016-06-04 10:00:00	saturday
1350	16	2016-06-23 09:00:00	thursday
1351	14	2016-06-22 16:30:00	wednesday
1352	17	2016-06-13 15:00:00	monday
1353	39	2016-06-25 17:15:00	saturday
1354	15	2016-06-16 16:00:00	thursday
1355	4	2016-06-25 11:00:00	saturday
1356	37	2016-06-14 15:30:00	tuesday
1357	35	2016-06-11 15:15:00	saturday
1358	6	2016-06-12 16:00:00	sunday
1359	28	2016-06-17 13:30:00	friday
1360	31	2016-06-29 17:30:00	wednesday
1361	2	2016-06-08 12:15:00	wednesday
1362	40	2016-06-06 09:00:00	monday
1363	9	2016-06-25 12:00:00	saturday
1364	1	2016-06-29 16:30:00	wednesday
1365	31	2016-06-23 09:15:00	thursday
1366	15	2016-06-27 12:45:00	monday
1367	12	2016-06-08 13:00:00	wednesday
1368	6	2016-06-08 10:15:00	wednesday
1369	27	2016-06-08 11:15:00	wednesday
1370	6	2016-07-20 16:45:00	wednesday
1371	25	2016-07-24 14:45:00	sunday
1372	23	2016-07-05 16:15:00	tuesday
1373	27	2016-07-25 15:15:00	monday
1374	38	2016-07-19 11:00:00	tuesday
1375	17	2016-07-29 11:15:00	friday
1376	24	2016-07-05 14:45:00	tuesday
1377	39	2016-07-27 17:15:00	wednesday
1378	12	2016-07-24 13:45:00	sunday
1379	24	2016-07-14 10:15:00	thursday
1380	3	2016-07-07 14:15:00	thursday
1381	3	2016-07-21 11:15:00	thursday
1382	9	2016-07-21 13:15:00	thursday
1383	8	2016-07-06 16:00:00	wednesday
1384	11	2016-07-07 11:30:00	thursday
1385	33	2016-07-05 17:00:00	tuesday
1386	15	2016-07-03 13:00:00	sunday
1387	3	2016-07-11 13:15:00	monday
1388	9	2016-07-25 17:00:00	monday
1389	12	2016-07-04 10:15:00	monday
1390	2	2016-07-30 09:00:00	saturday
1391	4	2016-07-11 08:30:00	monday
1392	9	2016-07-23 16:30:00	saturday
1393	38	2016-07-12 11:30:00	tuesday
1394	4	2016-07-12 09:00:00	tuesday
1395	38	2016-07-19 11:45:00	tuesday
1396	21	2016-07-14 11:00:00	thursday
1397	25	2016-07-14 08:15:00	thursday
1398	23	2016-07-24 16:30:00	sunday
1399	34	2016-07-18 12:15:00	monday
1400	31	2016-07-18 15:30:00	monday
1401	9	2016-07-28 11:30:00	thursday
1402	5	2016-07-20 08:00:00	wednesday
1403	11	2016-07-04 13:15:00	monday
1404	26	2016-07-26 08:00:00	tuesday
1405	7	2016-07-13 11:45:00	wednesday
1406	10	2016-07-13 16:45:00	wednesday
1407	13	2016-07-25 08:30:00	monday
1408	9	2016-07-21 10:30:00	thursday
1409	14	2016-07-30 16:30:00	saturday
1410	39	2016-07-01 11:00:00	friday
1411	33	2016-07-28 08:30:00	thursday
1412	14	2016-07-18 17:30:00	monday
1413	25	2016-07-10 13:30:00	sunday
1414	16	2016-07-24 09:15:00	sunday
1415	9	2016-07-12 14:00:00	tuesday
1416	35	2016-07-11 15:15:00	monday
1417	18	2016-07-26 15:30:00	tuesday
1418	6	2016-07-17 14:15:00	sunday
1419	25	2016-07-22 10:15:00	friday
1420	19	2016-08-11 16:00:00	thursday
1421	20	2016-08-21 16:15:00	sunday
1422	21	2016-08-16 16:00:00	tuesday
1423	35	2016-08-04 12:15:00	thursday
1424	1	2016-08-14 17:30:00	sunday
1425	9	2016-08-17 08:00:00	wednesday
1426	38	2016-08-07 15:45:00	sunday
1427	25	2016-08-19 16:00:00	friday
1428	30	2016-08-30 11:30:00	tuesday
1429	35	2016-08-27 14:30:00	saturday
1430	13	2016-08-28 10:45:00	sunday
1431	22	2016-08-05 14:45:00	friday
1432	7	2016-08-05 09:45:00	friday
1433	37	2016-08-22 10:15:00	monday
1434	35	2016-08-22 15:30:00	monday
1435	28	2016-08-25 08:15:00	thursday
1436	4	2016-08-10 11:15:00	wednesday
1437	10	2016-08-21 16:15:00	sunday
1438	4	2016-08-24 15:15:00	wednesday
1439	39	2016-08-18 12:30:00	thursday
1440	24	2016-08-12 11:15:00	friday
1441	20	2016-08-13 09:45:00	saturday
1442	33	2016-08-11 10:00:00	thursday
1443	15	2016-08-19 10:30:00	friday
1444	7	2016-08-02 11:45:00	tuesday
1445	30	2016-08-15 15:45:00	monday
1446	5	2016-08-29 09:30:00	monday
1447	17	2016-08-03 09:30:00	wednesday
1448	26	2016-08-30 10:30:00	tuesday
1449	26	2016-08-07 16:00:00	sunday
1450	27	2016-08-13 08:00:00	saturday
1451	29	2016-08-08 14:30:00	monday
1452	4	2016-08-23 11:45:00	tuesday
1453	2	2016-08-02 10:45:00	tuesday
1454	6	2016-08-11 16:30:00	thursday
1455	32	2016-09-01 12:30:00	thursday
1456	7	2016-09-15 08:15:00	thursday
1457	18	2016-09-05 14:15:00	monday
1458	31	2016-09-24 12:15:00	saturday
1459	35	2016-09-30 12:30:00	friday
1460	39	2016-09-30 13:00:00	friday
1461	11	2016-09-07 15:00:00	wednesday
1462	33	2016-09-14 17:15:00	wednesday
1463	9	2016-09-14 11:15:00	wednesday
1464	37	2016-09-30 17:00:00	friday
1465	8	2016-09-11 17:00:00	sunday
1466	8	2016-09-24 16:00:00	saturday
1467	12	2016-09-12 08:00:00	monday
1468	20	2016-09-22 13:15:00	thursday
1469	12	2016-09-04 14:00:00	sunday
1470	12	2016-09-09 17:15:00	friday
1471	15	2016-09-29 14:00:00	thursday
1472	30	2016-09-24 10:00:00	saturday
1473	17	2016-09-05 08:15:00	monday
1474	9	2016-09-04 16:00:00	sunday
1475	36	2016-09-10 17:00:00	saturday
1476	30	2016-09-15 16:45:00	thursday
1477	17	2016-09-25 10:00:00	sunday
1478	17	2016-09-08 10:00:00	thursday
1479	31	2016-09-29 15:00:00	thursday
1480	39	2016-09-18 10:30:00	sunday
1481	16	2016-09-09 11:45:00	friday
1482	23	2016-09-17 08:15:00	saturday
1483	16	2016-09-28 14:15:00	wednesday
1484	3	2016-09-24 17:00:00	saturday
1485	15	2016-09-10 17:00:00	saturday
1486	38	2016-09-01 10:15:00	thursday
1487	4	2016-09-14 08:00:00	wednesday
1488	36	2016-10-20 17:45:00	thursday
1489	9	2016-10-09 10:15:00	sunday
1490	6	2016-10-20 10:30:00	thursday
1491	4	2016-10-30 13:45:00	sunday
1492	38	2016-10-03 14:00:00	monday
1493	1	2016-10-09 08:45:00	sunday
1494	21	2016-10-01 12:45:00	saturday
1495	26	2016-10-14 09:15:00	friday
1496	9	2016-10-18 15:45:00	tuesday
1497	9	2016-10-25 12:45:00	tuesday
1498	19	2016-10-07 14:15:00	friday
1499	26	2016-10-26 08:15:00	wednesday
1500	2	2016-10-05 11:15:00	wednesday
1501	36	2016-10-13 16:30:00	thursday
1502	11	2016-10-15 15:15:00	saturday
1503	6	2016-10-11 09:30:00	tuesday
1504	18	2016-10-17 09:15:00	monday
1505	27	2016-10-07 16:00:00	friday
1506	24	2016-10-19 12:15:00	wednesday
1507	32	2016-10-24 11:00:00	monday
1508	12	2016-10-24 13:30:00	monday
1509	11	2016-10-01 11:15:00	saturday
1510	4	2016-10-22 09:15:00	saturday
1511	27	2016-10-03 13:45:00	monday
1512	19	2016-10-08 09:15:00	saturday
1513	4	2016-10-18 12:30:00	tuesday
1514	2	2016-10-08 13:30:00	saturday
1515	10	2016-10-26 10:15:00	wednesday
1516	9	2016-10-27 15:15:00	thursday
1517	18	2016-10-13 10:30:00	thursday
1518	4	2016-10-19 12:30:00	wednesday
1519	14	2016-10-24 17:15:00	monday
1520	24	2016-10-03 13:30:00	monday
1521	31	2016-10-21 13:45:00	friday
1522	12	2016-10-17 14:15:00	monday
1523	11	2016-11-24 09:45:00	thursday
1524	27	2016-11-16 12:15:00	wednesday
1525	6	2016-11-26 15:00:00	saturday
1526	30	2016-11-16 10:45:00	wednesday
1527	26	2016-11-24 11:45:00	thursday
1528	4	2016-11-22 08:00:00	tuesday
1529	25	2016-11-20 14:00:00	sunday
1530	28	2016-11-04 10:30:00	friday
1531	15	2016-11-02 17:15:00	wednesday
1532	31	2016-11-08 11:15:00	tuesday
1533	34	2016-11-27 15:45:00	sunday
1534	32	2016-11-29 10:45:00	tuesday
1535	19	2016-11-21 17:15:00	monday
1536	5	2016-11-20 13:15:00	sunday
1537	13	2016-11-30 17:00:00	wednesday
1538	13	2016-11-02 08:00:00	wednesday
1539	2	2016-11-14 16:15:00	monday
1540	17	2016-11-19 17:45:00	saturday
1541	35	2016-11-20 08:15:00	sunday
1542	37	2016-11-19 09:30:00	saturday
1543	38	2016-11-03 09:30:00	thursday
1544	29	2016-11-10 16:15:00	thursday
1545	31	2016-11-19 17:15:00	saturday
1546	10	2016-11-16 15:30:00	wednesday
1547	2	2016-11-04 09:45:00	friday
1548	13	2016-11-06 14:15:00	sunday
1549	4	2016-11-08 17:30:00	tuesday
1550	8	2016-11-04 11:45:00	friday
1551	7	2016-11-05 17:00:00	saturday
1552	34	2016-11-23 17:00:00	wednesday
1553	36	2016-11-08 12:00:00	tuesday
1554	25	2016-11-17 11:30:00	thursday
1555	16	2016-11-13 13:45:00	sunday
1556	23	2016-11-28 11:30:00	monday
1557	33	2016-11-23 15:15:00	wednesday
1558	31	2016-11-30 16:00:00	wednesday
1559	32	2016-11-14 08:15:00	monday
1560	6	2016-11-29 08:45:00	tuesday
1561	39	2016-11-19 14:00:00	saturday
1562	4	2016-11-20 17:45:00	sunday
1563	2	2016-12-03 08:00:00	saturday
1564	26	2016-12-06 10:15:00	tuesday
1565	39	2016-12-11 14:00:00	sunday
1566	28	2016-12-26 11:45:00	monday
1567	15	2016-12-14 12:45:00	wednesday
1568	6	2016-12-13 14:30:00	tuesday
1569	37	2016-12-17 13:00:00	saturday
1570	16	2016-12-18 17:00:00	sunday
1571	27	2016-12-19 15:45:00	monday
1572	28	2016-12-03 17:45:00	saturday
1573	33	2016-12-23 11:30:00	friday
1574	12	2016-12-22 16:45:00	thursday
1575	16	2016-12-08 16:45:00	thursday
1576	14	2016-12-09 08:45:00	friday
1577	25	2016-12-04 15:30:00	sunday
1578	2	2016-12-10 11:30:00	saturday
1579	40	2016-12-23 11:15:00	friday
1580	7	2016-12-28 14:00:00	wednesday
1581	28	2016-12-07 08:15:00	wednesday
1582	27	2016-12-13 09:15:00	tuesday
1583	6	2016-12-16 15:00:00	friday
1584	26	2016-12-20 14:15:00	tuesday
1585	7	2016-12-18 08:00:00	sunday
1586	36	2016-12-15 14:00:00	thursday
1587	20	2016-12-28 14:15:00	wednesday
1588	33	2016-12-20 14:45:00	tuesday
1589	35	2016-12-18 17:45:00	sunday
1590	5	2016-12-04 17:45:00	sunday
1591	21	2016-12-12 13:00:00	monday
1592	6	2016-12-16 14:45:00	friday
1593	36	2016-12-03 11:15:00	saturday
1594	11	2016-12-12 10:15:00	monday
1595	3	2016-12-20 16:45:00	tuesday
1596	4	2016-12-03 10:30:00	saturday
1597	27	2016-12-12 15:00:00	monday
1598	38	2016-12-02 15:45:00	friday
1599	34	2016-12-25 17:15:00	sunday
1600	30	2016-12-16 17:30:00	friday
1601	29	2017-01-06 11:00:00	friday
1602	10	2017-01-05 14:30:00	thursday
1603	10	2017-01-14 17:00:00	saturday
1604	3	2017-01-17 08:15:00	tuesday
1605	38	2017-01-27 09:00:00	friday
1606	21	2017-01-27 13:30:00	friday
1607	19	2017-01-07 15:45:00	saturday
1608	7	2017-01-12 11:00:00	thursday
1609	7	2017-01-08 16:15:00	sunday
1610	13	2017-01-22 11:30:00	sunday
1611	40	2017-01-05 15:30:00	thursday
1612	26	2017-01-10 15:30:00	tuesday
1613	33	2017-01-01 12:00:00	sunday
1614	21	2017-01-18 16:30:00	wednesday
1615	21	2017-01-05 08:30:00	thursday
1616	22	2017-01-13 10:45:00	friday
1617	32	2017-01-22 13:45:00	sunday
1618	31	2017-01-09 17:00:00	monday
1619	19	2017-01-12 16:30:00	thursday
1620	12	2017-01-11 14:30:00	wednesday
1621	31	2017-01-19 14:00:00	thursday
1622	5	2017-01-21 16:45:00	saturday
1623	6	2017-01-01 14:15:00	sunday
1624	25	2017-01-06 15:45:00	friday
1625	30	2017-01-30 15:45:00	monday
1626	11	2017-01-28 14:00:00	saturday
1627	23	2017-01-22 10:30:00	sunday
1628	38	2017-01-08 13:45:00	sunday
1629	34	2017-01-22 09:45:00	sunday
1630	10	2017-01-17 13:15:00	tuesday
1631	26	2017-01-28 10:30:00	saturday
1632	38	2017-01-20 14:15:00	friday
1633	20	2017-01-08 16:15:00	sunday
1634	29	2017-01-18 16:00:00	wednesday
1635	16	2017-01-25 16:30:00	wednesday
1636	4	2017-01-05 16:30:00	thursday
1637	15	2017-01-21 11:30:00	saturday
1638	23	2017-01-23 09:00:00	monday
1639	36	2017-01-23 17:45:00	monday
1640	17	2017-01-23 09:45:00	monday
1641	5	2017-01-19 14:30:00	thursday
1642	2	2017-01-24 14:45:00	tuesday
1643	1	2017-01-14 12:15:00	saturday
1644	16	2017-01-26 15:30:00	thursday
1645	2	2017-01-08 12:00:00	sunday
1646	25	2017-01-01 08:45:00	sunday
1647	26	2017-01-14 14:30:00	saturday
1648	29	2017-01-23 08:00:00	monday
1649	7	2017-01-22 12:00:00	sunday
1650	6	2017-01-10 11:00:00	tuesday
1651	40	2017-01-09 10:00:00	monday
1652	40	2017-01-05 15:30:00	thursday
1653	31	2017-01-23 08:45:00	monday
1654	3	2017-01-28 17:45:00	saturday
1655	14	2017-01-10 11:45:00	tuesday
1656	30	2017-01-14 11:30:00	saturday
1657	36	2017-01-26 14:45:00	thursday
1658	27	2017-01-25 14:45:00	wednesday
1659	7	2017-01-01 13:45:00	sunday
1660	16	2017-01-04 09:15:00	wednesday
1661	2	2017-02-17 14:15:00	friday
1662	25	2017-02-28 15:00:00	tuesday
1663	6	2017-02-01 10:45:00	wednesday
1664	1	2017-02-23 15:15:00	thursday
1665	25	2017-02-27 11:30:00	monday
1666	8	2017-02-05 17:15:00	sunday
1667	28	2017-02-09 10:15:00	thursday
1668	35	2017-02-14 08:45:00	tuesday
1669	38	2017-02-05 14:30:00	sunday
1670	40	2017-02-07 10:45:00	tuesday
1671	36	2017-02-12 15:30:00	sunday
1672	33	2017-02-15 14:45:00	wednesday
1673	35	2017-02-16 16:00:00	thursday
1674	6	2017-02-02 12:00:00	thursday
1675	9	2017-02-10 13:15:00	friday
1676	13	2017-02-01 13:45:00	wednesday
1677	17	2017-02-08 14:15:00	wednesday
1678	36	2017-02-11 14:30:00	saturday
1679	13	2017-02-25 12:00:00	saturday
1680	34	2017-02-22 13:00:00	wednesday
1681	12	2017-02-19 08:45:00	sunday
1682	35	2017-02-02 14:45:00	thursday
1683	27	2017-02-27 14:30:00	monday
1684	35	2017-02-04 08:30:00	saturday
1685	13	2017-02-21 12:00:00	tuesday
1686	15	2017-02-19 12:15:00	sunday
1687	5	2017-02-03 16:00:00	friday
1688	9	2017-02-23 09:00:00	thursday
1689	33	2017-02-05 14:00:00	sunday
1690	34	2017-02-09 13:15:00	thursday
1691	38	2017-02-08 08:45:00	wednesday
1692	40	2017-02-03 12:30:00	friday
1693	40	2017-02-18 15:15:00	saturday
1694	7	2017-02-09 13:30:00	thursday
1695	32	2017-02-10 09:15:00	friday
1696	33	2017-02-14 10:00:00	tuesday
1697	38	2017-02-10 11:15:00	friday
1698	32	2017-02-15 12:00:00	wednesday
1699	30	2017-02-07 12:00:00	tuesday
1700	32	2017-02-19 11:45:00	sunday
1701	28	2017-02-07 10:30:00	tuesday
1702	16	2017-02-28 08:30:00	tuesday
1703	10	2017-02-27 17:30:00	monday
1704	7	2017-02-19 11:30:00	sunday
1705	22	2017-02-21 14:45:00	tuesday
1706	24	2017-02-28 14:00:00	tuesday
1707	39	2017-02-23 10:00:00	thursday
1708	16	2017-02-14 14:30:00	tuesday
1709	30	2017-02-05 11:00:00	sunday
1710	21	2017-02-16 09:15:00	thursday
1711	23	2017-02-02 15:30:00	thursday
1712	14	2017-02-26 10:00:00	sunday
1713	7	2017-02-23 16:00:00	thursday
1714	7	2017-02-08 11:45:00	wednesday
1715	5	2017-02-22 08:00:00	wednesday
1716	28	2017-02-06 08:15:00	monday
1717	3	2017-02-11 09:00:00	saturday
1718	26	2017-02-05 08:30:00	sunday
1719	19	2017-02-02 14:30:00	thursday
1720	11	2017-02-27 09:15:00	monday
1721	28	2017-02-11 14:45:00	saturday
1722	40	2017-02-27 14:15:00	monday
1723	12	2017-02-08 17:30:00	wednesday
1724	14	2017-02-21 17:45:00	tuesday
1725	37	2017-02-22 08:00:00	wednesday
1726	20	2017-02-20 08:45:00	monday
1727	2	2017-02-28 10:30:00	tuesday
1728	9	2017-02-26 08:00:00	sunday
1729	40	2017-02-06 16:45:00	monday
1730	39	2017-02-13 15:30:00	monday
1731	31	2017-02-10 11:30:00	friday
1732	20	2017-02-25 08:00:00	saturday
1733	9	2017-02-18 08:00:00	saturday
1734	14	2017-02-19 12:30:00	sunday
1735	7	2017-02-27 15:30:00	monday
1736	36	2017-02-03 09:45:00	friday
1737	33	2017-02-07 11:45:00	tuesday
1738	1	2017-02-14 15:45:00	tuesday
1739	20	2017-02-08 12:15:00	wednesday
1740	34	2017-02-20 11:45:00	monday
1741	34	2017-02-06 14:00:00	monday
1742	4	2017-03-09 14:00:00	thursday
1743	40	2017-03-16 10:15:00	thursday
1744	17	2017-03-24 16:00:00	friday
1745	1	2017-03-03 14:15:00	friday
1746	1	2017-03-24 11:45:00	friday
1747	29	2017-03-09 15:30:00	thursday
1748	19	2017-03-16 17:30:00	thursday
1749	30	2017-03-20 14:00:00	monday
1750	27	2017-03-28 11:15:00	tuesday
1751	31	2017-03-20 15:00:00	monday
1752	11	2017-03-29 11:30:00	wednesday
1753	13	2017-03-03 10:00:00	friday
1754	36	2017-03-19 15:45:00	sunday
1755	8	2017-03-03 11:00:00	friday
1756	35	2017-03-07 13:00:00	tuesday
1757	16	2017-03-10 11:00:00	friday
1758	31	2017-03-08 13:45:00	wednesday
1759	33	2017-03-04 16:00:00	saturday
1760	14	2017-03-20 08:30:00	monday
1761	25	2017-03-22 13:00:00	wednesday
1762	37	2017-03-25 13:15:00	saturday
1763	23	2017-03-16 16:45:00	thursday
1764	23	2017-03-15 12:45:00	wednesday
1765	4	2017-03-05 10:30:00	sunday
1766	18	2017-03-05 08:15:00	sunday
1767	27	2017-03-02 10:15:00	thursday
1768	39	2017-03-09 11:00:00	thursday
1769	17	2017-03-02 17:00:00	thursday
1770	1	2017-03-17 16:30:00	friday
1771	23	2017-03-23 12:00:00	thursday
1772	2	2017-03-16 13:30:00	thursday
1773	37	2017-03-15 15:30:00	wednesday
1774	18	2017-03-26 14:00:00	sunday
1775	39	2017-03-13 16:30:00	monday
1776	10	2017-03-04 11:00:00	saturday
1777	9	2017-03-17 14:00:00	friday
1778	34	2017-03-07 11:30:00	tuesday
1779	36	2017-03-28 09:45:00	tuesday
1780	25	2017-03-20 08:15:00	monday
1781	40	2017-03-18 08:15:00	saturday
1782	35	2017-03-11 13:30:00	saturday
1783	2	2017-03-09 10:30:00	thursday
1784	26	2017-03-11 12:15:00	saturday
1785	29	2017-03-30 12:30:00	thursday
1786	23	2017-03-02 08:15:00	thursday
1787	2	2017-03-09 16:45:00	thursday
1788	15	2017-03-04 17:15:00	saturday
1789	10	2017-03-11 15:30:00	saturday
1790	8	2017-03-13 13:45:00	monday
1791	24	2017-03-19 08:45:00	sunday
1792	3	2017-03-20 11:15:00	monday
1793	25	2017-03-25 16:30:00	saturday
1794	9	2017-03-21 12:30:00	tuesday
1795	29	2017-03-05 08:15:00	sunday
1796	40	2017-03-25 14:30:00	saturday
1797	5	2017-04-15 11:00:00	saturday
1798	37	2017-04-11 09:00:00	tuesday
1799	36	2017-04-15 11:30:00	saturday
1800	33	2017-04-28 09:30:00	friday
1801	1	2017-04-08 16:30:00	saturday
1802	38	2017-04-14 15:15:00	friday
1803	9	2017-04-07 11:15:00	friday
1804	17	2017-04-11 10:45:00	tuesday
1805	22	2017-04-07 14:15:00	friday
1806	23	2017-04-13 08:45:00	thursday
1807	20	2017-04-12 15:45:00	wednesday
1808	1	2017-04-25 12:30:00	tuesday
1809	16	2017-04-04 17:00:00	tuesday
1810	10	2017-04-24 17:45:00	monday
1811	9	2017-04-26 13:45:00	wednesday
1812	21	2017-04-01 15:15:00	saturday
1813	25	2017-04-16 12:30:00	sunday
1814	33	2017-04-22 13:00:00	saturday
1815	3	2017-04-06 13:15:00	thursday
1816	39	2017-04-06 14:30:00	thursday
1817	28	2017-04-11 11:45:00	tuesday
1818	8	2017-04-30 14:15:00	sunday
1819	19	2017-04-11 11:45:00	tuesday
1820	17	2017-04-11 08:45:00	tuesday
1821	10	2017-04-04 11:00:00	tuesday
1822	16	2017-04-21 14:45:00	friday
1823	28	2017-04-28 17:00:00	friday
1824	14	2017-04-24 14:30:00	monday
1825	31	2017-04-28 14:45:00	friday
1826	28	2017-04-08 10:30:00	saturday
1827	25	2017-04-14 14:30:00	friday
1828	24	2017-04-07 11:30:00	friday
1829	13	2017-04-25 17:30:00	tuesday
1830	31	2017-04-20 17:00:00	thursday
1831	21	2017-04-02 17:45:00	sunday
1832	10	2017-04-07 15:30:00	friday
1833	14	2017-04-24 17:15:00	monday
1834	35	2017-04-20 13:30:00	thursday
1835	25	2017-04-04 08:15:00	tuesday
1836	14	2017-04-21 09:30:00	friday
1837	22	2017-04-26 12:45:00	wednesday
1838	34	2017-04-13 13:15:00	thursday
1839	32	2017-04-09 10:45:00	sunday
1840	39	2017-04-18 15:30:00	tuesday
1841	37	2017-04-10 12:15:00	monday
1842	24	2017-04-12 13:15:00	wednesday
1843	21	2017-04-09 15:00:00	sunday
1844	24	2017-04-04 11:45:00	tuesday
1845	40	2017-04-05 15:30:00	wednesday
1846	6	2017-04-24 10:15:00	monday
1847	26	2017-04-22 11:45:00	saturday
1848	2	2017-04-02 17:30:00	sunday
1849	9	2017-04-23 12:00:00	sunday
1850	39	2017-04-08 14:45:00	saturday
1851	10	2017-04-28 15:00:00	friday
1852	33	2017-04-06 15:00:00	thursday
1853	9	2017-04-12 10:30:00	wednesday
1854	30	2017-04-05 15:45:00	wednesday
1855	24	2017-04-22 08:30:00	saturday
1856	39	2017-04-13 14:45:00	thursday
1857	28	2017-04-10 14:00:00	monday
1858	5	2017-04-24 16:30:00	monday
1859	20	2017-04-05 15:00:00	wednesday
1860	14	2017-04-14 16:30:00	friday
1861	19	2017-04-26 13:15:00	wednesday
1862	31	2017-05-03 09:45:00	wednesday
1863	28	2017-05-10 17:45:00	wednesday
1864	17	2017-05-15 08:15:00	monday
1865	11	2017-05-22 10:00:00	monday
1866	38	2017-05-04 10:00:00	thursday
1867	7	2017-05-25 16:45:00	thursday
1868	34	2017-05-18 14:45:00	thursday
1869	28	2017-05-15 09:00:00	monday
1870	20	2017-05-09 10:00:00	tuesday
1871	35	2017-05-07 09:15:00	sunday
1872	4	2017-05-02 17:30:00	tuesday
1873	25	2017-05-18 16:15:00	thursday
1874	4	2017-05-09 10:00:00	tuesday
1875	7	2017-05-24 12:00:00	wednesday
1876	9	2017-05-28 16:30:00	sunday
1877	6	2017-05-22 08:15:00	monday
1878	1	2017-05-09 13:00:00	tuesday
1879	40	2017-05-30 12:45:00	tuesday
1880	21	2017-05-24 08:45:00	wednesday
1881	4	2017-05-25 12:45:00	thursday
1882	13	2017-05-06 09:00:00	saturday
1883	40	2017-05-11 13:00:00	thursday
1884	16	2017-05-15 08:45:00	monday
1885	6	2017-05-14 12:45:00	sunday
1886	35	2017-05-14 14:30:00	sunday
1887	33	2017-05-26 13:45:00	friday
1888	31	2017-05-07 14:45:00	sunday
1889	7	2017-05-30 15:00:00	tuesday
1890	21	2017-05-17 10:00:00	wednesday
1891	14	2017-05-30 08:15:00	tuesday
1892	2	2017-05-13 16:45:00	saturday
1893	16	2017-05-30 15:15:00	tuesday
1894	21	2017-05-13 15:00:00	saturday
1895	1	2017-05-08 10:00:00	monday
1896	38	2017-05-27 11:00:00	saturday
1897	5	2017-05-28 13:30:00	sunday
1898	7	2017-05-29 15:30:00	monday
1899	21	2017-05-14 15:15:00	sunday
1900	36	2017-05-13 08:15:00	saturday
1901	16	2017-05-26 17:00:00	friday
1902	4	2017-05-26 13:15:00	friday
1903	36	2017-05-06 15:00:00	saturday
1904	39	2017-05-13 14:45:00	saturday
1905	28	2017-05-27 14:00:00	saturday
1906	7	2017-05-12 09:00:00	friday
1907	40	2017-05-30 08:00:00	tuesday
1908	25	2017-05-27 17:00:00	saturday
1909	2	2017-05-02 08:45:00	tuesday
1910	19	2017-05-30 13:30:00	tuesday
1911	29	2017-05-15 15:15:00	monday
1912	13	2017-05-30 13:15:00	tuesday
1913	30	2017-05-12 16:15:00	friday
1914	18	2017-05-19 12:30:00	friday
1915	5	2017-05-19 09:15:00	friday
1916	6	2017-06-27 10:45:00	tuesday
1917	26	2017-06-25 14:15:00	sunday
1918	38	2017-06-21 12:30:00	wednesday
1919	9	2017-06-19 14:30:00	monday
1920	5	2017-06-28 10:45:00	wednesday
1921	32	2017-06-25 09:15:00	sunday
1922	19	2017-06-10 14:45:00	saturday
1923	22	2017-06-26 14:15:00	monday
1924	21	2017-06-05 14:00:00	monday
1925	4	2017-06-21 10:45:00	wednesday
1926	10	2017-06-11 11:45:00	sunday
1927	21	2017-06-01 17:00:00	thursday
1928	2	2017-06-24 11:30:00	saturday
1929	39	2017-06-17 09:15:00	saturday
1930	39	2017-06-06 13:15:00	tuesday
1931	16	2017-06-08 15:00:00	thursday
1932	13	2017-06-18 12:45:00	sunday
1933	35	2017-06-02 17:15:00	friday
1934	27	2017-06-05 13:00:00	monday
1935	27	2017-06-11 13:00:00	sunday
1936	32	2017-06-11 16:45:00	sunday
1937	29	2017-06-28 17:45:00	wednesday
1938	25	2017-06-19 09:45:00	monday
1939	15	2017-06-30 12:15:00	friday
1940	23	2017-06-16 12:00:00	friday
1941	13	2017-06-28 10:30:00	wednesday
1942	11	2017-06-27 11:45:00	tuesday
1943	8	2017-06-04 08:30:00	sunday
1944	20	2017-06-15 13:15:00	thursday
1945	23	2017-06-29 09:15:00	thursday
1946	21	2017-06-23 12:15:00	friday
1947	40	2017-06-25 09:30:00	sunday
1948	18	2017-06-04 15:15:00	sunday
1949	36	2017-06-03 10:15:00	saturday
1950	16	2017-06-26 16:30:00	monday
1951	8	2017-06-06 14:45:00	tuesday
1952	18	2017-06-17 08:00:00	saturday
1953	32	2017-06-16 13:00:00	friday
1954	8	2017-06-28 17:45:00	wednesday
1955	29	2017-06-28 16:15:00	wednesday
1956	39	2017-06-29 15:30:00	thursday
1957	38	2017-06-20 12:00:00	tuesday
1958	22	2017-06-06 12:15:00	tuesday
1959	23	2017-06-04 11:30:00	sunday
1960	28	2017-06-25 11:00:00	sunday
1961	38	2017-06-08 14:45:00	thursday
1962	37	2017-06-04 17:30:00	sunday
1963	34	2017-06-24 17:30:00	saturday
1964	12	2017-06-15 15:15:00	thursday
1965	29	2017-06-05 08:00:00	monday
1966	24	2017-06-29 12:00:00	thursday
1967	9	2017-06-14 14:00:00	wednesday
1968	40	2017-06-05 08:30:00	monday
1969	4	2017-06-09 11:15:00	friday
1970	17	2017-06-25 11:30:00	sunday
1971	29	2017-06-08 08:30:00	thursday
1972	36	2017-06-15 16:30:00	thursday
1973	30	2017-06-02 15:45:00	friday
1974	26	2017-06-05 17:45:00	monday
1975	10	2017-06-11 15:30:00	sunday
1976	10	2017-06-13 16:45:00	tuesday
1977	30	2017-06-10 08:00:00	saturday
1978	23	2017-06-27 09:00:00	tuesday
1979	33	2017-06-24 14:15:00	saturday
1980	12	2017-06-28 10:15:00	wednesday
1981	37	2017-06-28 15:30:00	wednesday
1982	17	2017-06-26 15:45:00	monday
1983	13	2017-06-16 14:30:00	friday
1984	13	2017-06-07 15:45:00	wednesday
1985	23	2017-06-10 13:30:00	saturday
1986	11	2017-06-10 15:15:00	saturday
1987	26	2017-07-05 15:00:00	wednesday
1988	31	2017-07-04 14:45:00	tuesday
1989	30	2017-07-29 12:15:00	saturday
1990	24	2017-07-17 16:00:00	monday
1991	16	2017-07-12 09:15:00	wednesday
1992	29	2017-07-01 16:30:00	saturday
1993	12	2017-07-04 16:30:00	tuesday
1994	10	2017-07-10 15:30:00	monday
1995	19	2017-07-25 11:30:00	tuesday
1996	34	2017-07-29 15:00:00	saturday
1997	5	2017-07-04 15:45:00	tuesday
1998	19	2017-07-12 15:15:00	wednesday
1999	13	2017-07-10 14:00:00	monday
2000	31	2017-07-27 12:15:00	thursday
2001	18	2017-07-03 08:45:00	monday
2002	7	2017-07-27 14:45:00	thursday
2003	17	2017-07-23 09:45:00	sunday
2004	16	2017-07-21 15:30:00	friday
2005	22	2017-07-09 14:30:00	sunday
2006	23	2017-07-16 15:45:00	sunday
2007	34	2017-07-30 09:45:00	sunday
2008	30	2017-07-15 13:30:00	saturday
2009	11	2017-07-17 16:00:00	monday
2010	23	2017-07-04 11:30:00	tuesday
2011	1	2017-07-13 08:00:00	thursday
2012	5	2017-07-18 16:15:00	tuesday
2013	12	2017-07-29 12:45:00	saturday
2014	8	2017-07-27 09:30:00	thursday
2015	9	2017-07-02 09:15:00	sunday
2016	15	2017-07-27 14:15:00	thursday
2017	36	2017-07-06 14:30:00	thursday
2018	37	2017-07-19 17:00:00	wednesday
2019	21	2017-07-22 16:45:00	saturday
2020	30	2017-07-04 12:15:00	tuesday
2021	5	2017-07-28 11:00:00	friday
2022	32	2017-07-25 17:30:00	tuesday
2023	7	2017-07-25 10:00:00	tuesday
2024	37	2017-07-15 09:15:00	saturday
2025	25	2017-07-23 08:00:00	sunday
2026	13	2017-07-25 13:45:00	tuesday
2027	34	2017-07-21 09:45:00	friday
2028	14	2017-07-03 08:30:00	monday
2029	35	2017-07-11 17:30:00	tuesday
2030	21	2017-07-29 17:15:00	saturday
2031	16	2017-07-07 10:45:00	friday
2032	20	2017-07-03 12:15:00	monday
2033	22	2017-07-12 11:15:00	wednesday
2034	12	2017-07-16 14:00:00	sunday
2035	20	2017-07-05 15:00:00	wednesday
2036	26	2017-07-10 10:45:00	monday
2037	4	2017-07-17 14:15:00	monday
2038	27	2017-07-09 12:15:00	sunday
2039	40	2017-07-26 16:30:00	wednesday
2040	17	2017-07-27 09:15:00	thursday
2041	39	2017-07-19 11:15:00	wednesday
2042	37	2017-07-25 13:45:00	tuesday
2043	39	2017-07-21 17:45:00	friday
2044	12	2017-07-18 12:45:00	tuesday
2045	26	2017-07-27 16:00:00	thursday
2046	21	2017-07-18 08:45:00	tuesday
2047	35	2017-07-01 15:00:00	saturday
2048	15	2017-07-10 12:00:00	monday
2049	32	2017-07-17 12:30:00	monday
2050	29	2017-07-08 09:30:00	saturday
2051	7	2017-07-30 12:45:00	sunday
2052	19	2017-07-05 14:15:00	wednesday
2053	2	2017-07-12 12:15:00	wednesday
2054	7	2017-07-19 10:15:00	wednesday
2055	21	2017-07-20 15:30:00	thursday
2056	11	2017-07-12 17:45:00	wednesday
2057	28	2017-07-04 14:45:00	tuesday
2058	39	2017-07-02 16:30:00	sunday
2059	24	2017-07-05 10:30:00	wednesday
2060	25	2017-07-24 15:45:00	monday
2061	17	2017-07-05 15:00:00	wednesday
2062	6	2017-07-04 09:30:00	tuesday
2063	26	2017-08-24 14:30:00	thursday
2064	24	2017-08-24 11:15:00	thursday
2065	25	2017-08-17 17:45:00	thursday
2066	31	2017-08-06 15:45:00	sunday
2067	38	2017-08-13 09:15:00	sunday
2068	34	2017-08-11 11:00:00	friday
2069	1	2017-08-23 14:00:00	wednesday
2070	5	2017-08-14 15:30:00	monday
2071	5	2017-08-13 16:30:00	sunday
2072	2	2017-08-04 13:30:00	friday
2073	2	2017-08-24 11:00:00	thursday
2074	26	2017-08-22 15:00:00	tuesday
2075	28	2017-08-09 10:30:00	wednesday
2076	2	2017-08-16 11:00:00	wednesday
2077	22	2017-08-17 17:15:00	thursday
2078	1	2017-08-12 11:30:00	saturday
2079	20	2017-08-28 12:45:00	monday
2080	22	2017-08-29 09:15:00	tuesday
2081	34	2017-08-21 12:00:00	monday
2082	4	2017-08-06 10:15:00	sunday
2083	32	2017-08-26 14:00:00	saturday
2084	6	2017-08-24 17:30:00	thursday
2085	30	2017-08-20 13:45:00	sunday
2086	5	2017-08-28 17:45:00	monday
2087	17	2017-08-15 09:15:00	tuesday
2088	7	2017-08-27 15:45:00	sunday
2089	6	2017-08-15 12:00:00	tuesday
2090	7	2017-08-02 08:30:00	wednesday
2091	36	2017-08-25 17:15:00	friday
2092	10	2017-08-13 16:45:00	sunday
2093	28	2017-08-16 17:30:00	wednesday
2094	13	2017-08-22 10:15:00	tuesday
2095	34	2017-08-11 09:30:00	friday
2096	34	2017-08-03 09:15:00	thursday
2097	18	2017-08-12 15:00:00	saturday
2098	1	2017-08-28 12:30:00	monday
2099	37	2017-08-22 09:45:00	tuesday
2100	25	2017-08-08 11:45:00	tuesday
2101	12	2017-08-24 12:00:00	thursday
2102	6	2017-08-02 11:45:00	wednesday
2103	33	2017-08-19 16:00:00	saturday
2104	18	2017-08-08 13:45:00	tuesday
2105	27	2017-08-22 13:15:00	tuesday
2106	30	2017-08-10 13:45:00	thursday
2107	15	2017-08-04 14:15:00	friday
2108	31	2017-08-25 16:00:00	friday
2109	17	2017-08-30 13:30:00	wednesday
2110	11	2017-08-08 12:30:00	tuesday
2111	27	2017-08-14 09:30:00	monday
2112	19	2017-08-20 15:30:00	sunday
2113	3	2017-08-18 14:45:00	friday
2114	17	2017-08-24 12:15:00	thursday
2115	23	2017-08-19 13:45:00	saturday
2116	1	2017-08-12 10:30:00	saturday
2117	9	2017-08-15 11:15:00	tuesday
2118	9	2017-08-17 09:45:00	thursday
2119	36	2017-08-09 11:45:00	wednesday
2120	34	2017-08-25 10:15:00	friday
2121	22	2017-08-13 17:45:00	sunday
2122	14	2017-08-20 17:00:00	sunday
2123	39	2017-08-06 11:00:00	sunday
2124	2	2017-08-23 13:15:00	wednesday
2125	30	2017-08-07 09:30:00	monday
2126	19	2017-08-26 15:30:00	saturday
2127	32	2017-08-17 08:30:00	thursday
2128	10	2017-08-01 17:00:00	tuesday
2129	26	2017-08-06 12:30:00	sunday
2130	34	2017-08-30 12:00:00	wednesday
2131	4	2017-09-19 12:15:00	tuesday
2132	22	2017-09-22 08:00:00	friday
2133	21	2017-09-05 16:45:00	tuesday
2134	13	2017-09-05 17:30:00	tuesday
2135	27	2017-09-07 14:45:00	thursday
2136	16	2017-09-14 12:45:00	thursday
2137	18	2017-09-24 11:30:00	sunday
2138	24	2017-09-03 14:15:00	sunday
2139	1	2017-09-07 16:30:00	thursday
2140	26	2017-09-01 17:00:00	friday
2141	19	2017-09-23 15:00:00	saturday
2142	20	2017-09-03 15:15:00	sunday
2143	25	2017-09-24 11:45:00	sunday
2144	15	2017-09-08 17:15:00	friday
2145	10	2017-09-21 17:00:00	thursday
2146	20	2017-09-05 08:15:00	tuesday
2147	20	2017-09-08 14:30:00	friday
2148	33	2017-09-22 12:30:00	friday
2149	34	2017-09-08 12:00:00	friday
2150	19	2017-09-21 12:45:00	thursday
2151	30	2017-09-15 14:30:00	friday
2152	11	2017-09-21 12:00:00	thursday
2153	21	2017-09-25 17:00:00	monday
2154	35	2017-09-13 08:15:00	wednesday
2155	24	2017-09-10 13:00:00	sunday
2156	8	2017-09-29 15:30:00	friday
2157	23	2017-09-28 10:00:00	thursday
2158	15	2017-09-05 09:30:00	tuesday
2159	37	2017-09-16 12:15:00	saturday
2160	33	2017-09-16 17:30:00	saturday
2161	17	2017-09-17 09:15:00	sunday
2162	17	2017-09-21 10:30:00	thursday
2163	8	2017-09-08 12:00:00	friday
2164	34	2017-09-09 09:15:00	saturday
2165	6	2017-09-16 17:45:00	saturday
2166	3	2017-09-06 14:15:00	wednesday
2167	28	2017-09-30 11:45:00	saturday
2168	12	2017-09-28 10:15:00	thursday
2169	32	2017-09-03 11:30:00	sunday
2170	24	2017-09-24 15:30:00	sunday
2171	26	2017-09-14 10:15:00	thursday
2172	35	2017-09-24 16:15:00	sunday
2173	26	2017-09-29 11:45:00	friday
2174	20	2017-09-08 17:45:00	friday
2175	5	2017-09-27 17:00:00	wednesday
2176	33	2017-09-23 16:30:00	saturday
2177	23	2017-09-29 16:30:00	friday
2178	31	2017-09-14 12:00:00	thursday
2179	8	2017-09-30 10:00:00	saturday
2180	16	2017-09-09 14:30:00	saturday
2181	33	2017-09-20 09:00:00	wednesday
2182	4	2017-09-05 17:00:00	tuesday
2183	29	2017-09-24 10:45:00	sunday
2184	19	2017-09-24 13:00:00	sunday
2185	2	2017-09-10 10:15:00	sunday
2186	31	2017-09-11 17:00:00	monday
2187	15	2017-09-26 10:15:00	tuesday
2188	5	2017-09-14 09:15:00	thursday
2189	6	2017-09-22 08:30:00	friday
2190	2	2017-09-06 13:00:00	wednesday
2191	1	2017-09-17 17:30:00	sunday
2192	23	2017-09-25 12:00:00	monday
2193	6	2017-09-04 09:00:00	monday
2194	38	2017-09-19 17:15:00	tuesday
2195	12	2017-09-20 17:45:00	wednesday
2196	20	2017-09-24 08:00:00	sunday
2197	12	2017-09-18 16:00:00	monday
2198	7	2017-09-25 15:30:00	monday
2199	11	2017-09-11 17:15:00	monday
2200	8	2017-09-21 14:00:00	thursday
2201	28	2017-10-22 12:00:00	sunday
2202	16	2017-10-19 09:15:00	thursday
2203	9	2017-10-23 13:00:00	monday
2204	11	2017-10-23 12:45:00	monday
2205	17	2017-10-05 15:45:00	thursday
2206	33	2017-10-11 10:30:00	wednesday
2207	32	2017-10-02 16:30:00	monday
2208	18	2017-10-30 09:00:00	monday
2209	19	2017-10-13 12:15:00	friday
2210	23	2017-10-11 09:30:00	wednesday
2211	11	2017-10-19 16:00:00	thursday
2212	38	2017-10-28 11:30:00	saturday
2213	15	2017-10-07 08:45:00	saturday
2214	20	2017-10-16 08:30:00	monday
2215	12	2017-10-16 09:45:00	monday
2216	26	2017-10-13 16:00:00	friday
2217	14	2017-10-24 11:15:00	tuesday
2218	18	2017-10-16 16:15:00	monday
2219	22	2017-10-12 12:15:00	thursday
2220	24	2017-10-22 16:45:00	sunday
2221	35	2017-10-23 13:30:00	monday
2222	3	2017-10-04 17:45:00	wednesday
2223	35	2017-10-20 08:00:00	friday
2224	27	2017-10-08 11:45:00	sunday
2225	9	2017-10-01 11:45:00	sunday
2226	10	2017-10-06 14:15:00	friday
2227	21	2017-10-29 08:00:00	sunday
2228	5	2017-10-03 16:15:00	tuesday
2229	9	2017-10-09 14:00:00	monday
2230	10	2017-10-17 09:45:00	tuesday
2231	32	2017-10-28 15:00:00	saturday
2232	17	2017-10-27 14:30:00	friday
2233	7	2017-10-06 11:00:00	friday
2234	37	2017-10-26 11:30:00	thursday
2235	38	2017-10-13 13:30:00	friday
2236	10	2017-10-22 13:30:00	sunday
2237	37	2017-10-26 12:15:00	thursday
2238	30	2017-10-15 14:45:00	sunday
2239	25	2017-10-02 15:45:00	monday
2240	1	2017-10-14 15:00:00	saturday
2241	38	2017-10-16 17:30:00	monday
2242	39	2017-10-06 11:30:00	friday
2243	4	2017-10-09 13:45:00	monday
2244	18	2017-10-30 10:45:00	monday
2245	35	2017-10-16 14:15:00	monday
2246	26	2017-10-07 14:15:00	saturday
2247	1	2017-10-11 12:30:00	wednesday
2248	15	2017-10-13 12:15:00	friday
2249	16	2017-10-20 16:45:00	friday
2250	18	2017-10-07 14:00:00	saturday
2251	10	2017-10-25 12:15:00	wednesday
2252	2	2017-10-25 10:00:00	wednesday
2253	39	2017-10-04 10:45:00	wednesday
2254	2	2017-10-09 17:15:00	monday
2255	11	2017-10-12 11:30:00	thursday
2256	21	2017-10-04 11:15:00	wednesday
2257	3	2017-10-06 08:45:00	friday
2258	13	2017-10-29 14:45:00	sunday
2259	38	2017-10-10 11:00:00	tuesday
2260	36	2017-10-25 17:00:00	wednesday
2261	5	2017-10-06 16:00:00	friday
2262	11	2017-10-28 15:15:00	saturday
2263	36	2017-10-13 11:15:00	friday
2264	1	2017-10-23 14:30:00	monday
2265	25	2017-10-04 09:15:00	wednesday
2266	1	2017-10-26 10:15:00	thursday
2267	10	2017-10-25 17:45:00	wednesday
2268	31	2017-10-29 13:15:00	sunday
2269	33	2017-10-19 09:00:00	thursday
2270	9	2017-10-24 08:00:00	tuesday
2271	33	2017-10-20 09:15:00	friday
2272	23	2017-11-18 13:00:00	saturday
2273	15	2017-11-21 10:45:00	tuesday
2274	12	2017-11-30 09:15:00	thursday
2275	27	2017-11-01 14:30:00	wednesday
2276	13	2017-11-12 16:00:00	sunday
2277	14	2017-11-29 17:45:00	wednesday
2278	6	2017-11-01 15:30:00	wednesday
2279	20	2017-11-26 10:00:00	sunday
2280	18	2017-11-07 16:30:00	tuesday
2281	33	2017-11-08 10:30:00	wednesday
2282	26	2017-11-18 13:45:00	saturday
2283	13	2017-11-18 16:15:00	saturday
2284	34	2017-11-12 15:15:00	sunday
2285	10	2017-11-21 14:00:00	tuesday
2286	33	2017-11-28 16:15:00	tuesday
2287	2	2017-11-13 11:30:00	monday
2288	38	2017-11-20 16:45:00	monday
2289	19	2017-11-08 13:45:00	wednesday
2290	29	2017-11-04 10:15:00	saturday
2291	28	2017-11-14 16:30:00	tuesday
2292	2	2017-11-29 08:00:00	wednesday
2293	31	2017-11-18 09:30:00	saturday
2294	35	2017-11-27 14:30:00	monday
2295	39	2017-11-21 09:30:00	tuesday
2296	24	2017-11-28 11:45:00	tuesday
2297	1	2017-11-07 13:30:00	tuesday
2298	36	2017-11-09 13:00:00	thursday
2299	4	2017-11-16 12:45:00	thursday
2300	26	2017-11-17 15:00:00	friday
2301	19	2017-11-27 15:30:00	monday
2302	18	2017-11-29 10:30:00	wednesday
2303	15	2017-11-21 13:15:00	tuesday
2304	3	2017-11-27 12:45:00	monday
2305	15	2017-11-06 15:30:00	monday
2306	24	2017-11-11 11:15:00	saturday
2307	9	2017-11-13 16:30:00	monday
2308	6	2017-11-13 14:30:00	monday
2309	40	2017-11-07 16:15:00	tuesday
2310	17	2017-11-13 12:00:00	monday
2311	22	2017-11-15 14:45:00	wednesday
2312	20	2017-11-28 16:15:00	tuesday
2313	32	2017-11-15 11:30:00	wednesday
2314	7	2017-11-03 13:45:00	friday
2315	15	2017-11-24 17:45:00	friday
2316	16	2017-11-07 12:00:00	tuesday
2317	11	2017-11-07 12:30:00	tuesday
2318	5	2017-11-03 08:00:00	friday
2319	23	2017-11-02 16:30:00	thursday
2320	22	2017-11-07 11:15:00	tuesday
2321	18	2017-11-11 11:15:00	saturday
2322	29	2017-11-15 15:30:00	wednesday
2323	2	2017-11-22 10:30:00	wednesday
2324	39	2017-11-12 11:15:00	sunday
2325	40	2017-11-08 12:45:00	wednesday
2326	25	2017-11-12 13:15:00	sunday
2327	32	2017-11-14 12:15:00	tuesday
2328	37	2017-11-15 17:00:00	wednesday
2329	23	2017-11-14 10:30:00	tuesday
2330	13	2017-11-07 17:45:00	tuesday
2331	21	2017-11-24 13:00:00	friday
2332	4	2017-11-10 10:45:00	friday
2333	19	2017-11-01 12:45:00	wednesday
2334	18	2017-11-15 16:15:00	wednesday
2335	36	2017-11-04 11:30:00	saturday
2336	30	2017-11-12 09:15:00	sunday
2337	13	2017-11-15 15:45:00	wednesday
2338	11	2017-11-05 12:15:00	sunday
2339	22	2017-11-25 14:30:00	saturday
2340	13	2017-11-18 09:30:00	saturday
2341	32	2017-11-17 13:00:00	friday
2342	19	2017-11-28 17:45:00	tuesday
2343	6	2017-12-06 10:00:00	wednesday
2344	20	2017-12-11 10:45:00	monday
2345	14	2017-12-20 10:45:00	wednesday
2346	12	2017-12-17 11:45:00	sunday
2347	31	2017-12-23 16:30:00	saturday
2348	14	2017-12-30 15:00:00	saturday
2349	18	2017-12-09 13:00:00	saturday
2350	32	2017-12-15 13:15:00	friday
2351	11	2017-12-25 08:30:00	monday
2352	4	2017-12-01 08:15:00	friday
2353	31	2017-12-11 09:30:00	monday
2354	3	2017-12-13 14:45:00	wednesday
2355	21	2017-12-20 15:30:00	wednesday
2356	18	2017-12-08 11:30:00	friday
2357	7	2017-12-24 12:30:00	sunday
2358	22	2017-12-30 15:30:00	saturday
2359	24	2017-12-18 10:15:00	monday
2360	33	2017-12-16 16:30:00	saturday
2361	20	2017-12-27 11:45:00	wednesday
2362	36	2017-12-19 14:15:00	tuesday
2363	5	2017-12-25 08:15:00	monday
2364	37	2017-12-12 15:30:00	tuesday
2365	2	2017-12-28 17:45:00	thursday
2366	32	2017-12-25 09:45:00	monday
2367	7	2017-12-28 13:15:00	thursday
2368	31	2017-12-26 09:30:00	tuesday
2369	1	2017-12-01 14:45:00	friday
2370	12	2017-12-23 11:45:00	saturday
2371	33	2017-12-22 13:45:00	friday
2372	19	2017-12-12 10:45:00	tuesday
2373	14	2017-12-14 17:15:00	thursday
2374	11	2017-12-12 15:00:00	tuesday
2375	37	2017-12-10 14:30:00	sunday
2376	35	2017-12-13 11:45:00	wednesday
2377	10	2017-12-24 14:45:00	sunday
2378	15	2017-12-07 10:30:00	thursday
2379	38	2017-12-16 14:00:00	saturday
2380	17	2017-12-10 10:15:00	sunday
2381	9	2017-12-10 14:30:00	sunday
2382	34	2017-12-13 10:30:00	wednesday
2383	22	2017-12-05 12:30:00	tuesday
2384	32	2017-12-21 10:45:00	thursday
2385	11	2017-12-23 08:00:00	saturday
2386	7	2017-12-20 12:00:00	wednesday
2387	40	2017-12-05 12:15:00	tuesday
2388	19	2017-12-06 14:15:00	wednesday
2389	29	2017-12-02 16:00:00	saturday
2390	1	2017-12-19 15:30:00	tuesday
2391	30	2017-12-30 13:30:00	saturday
2392	19	2017-12-10 17:45:00	sunday
2393	24	2017-12-22 09:00:00	friday
2394	10	2017-12-27 17:45:00	wednesday
2395	27	2017-12-16 17:00:00	saturday
2396	28	2017-12-10 08:45:00	sunday
2397	39	2017-12-01 14:00:00	friday
2398	13	2017-12-24 08:30:00	sunday
2399	1	2017-12-02 10:30:00	saturday
2400	39	2017-12-08 15:00:00	friday
2401	7	2018-01-16 15:00:00	tuesday
2402	30	2018-01-15 12:30:00	monday
2403	20	2018-01-19 09:45:00	friday
2404	16	2018-01-13 11:45:00	saturday
2405	21	2018-01-10 16:15:00	wednesday
2406	4	2018-01-10 12:15:00	wednesday
2407	29	2018-01-29 08:00:00	monday
2408	1	2018-01-19 15:45:00	friday
2409	22	2018-01-23 15:15:00	tuesday
2410	24	2018-01-27 10:15:00	saturday
2411	1	2018-01-12 12:45:00	friday
2412	5	2018-01-13 13:30:00	saturday
2413	36	2018-01-25 12:00:00	thursday
2414	36	2018-01-03 08:45:00	wednesday
2415	3	2018-01-24 09:15:00	wednesday
2416	14	2018-01-07 13:00:00	sunday
2417	9	2018-01-22 10:45:00	monday
2418	28	2018-01-22 14:30:00	monday
2419	38	2018-01-21 13:15:00	sunday
2420	40	2018-01-13 15:30:00	saturday
2421	32	2018-01-01 14:00:00	monday
2422	16	2018-01-05 15:30:00	friday
2423	3	2018-01-05 09:45:00	friday
2424	4	2018-01-05 13:00:00	friday
2425	3	2018-01-26 13:00:00	friday
2426	29	2018-01-13 10:00:00	saturday
2427	15	2018-01-20 16:15:00	saturday
2428	6	2018-01-16 17:00:00	tuesday
2429	14	2018-01-04 12:15:00	thursday
2430	20	2018-01-09 17:45:00	tuesday
2431	10	2018-01-30 14:15:00	tuesday
2432	16	2018-01-05 15:00:00	friday
2433	1	2018-01-29 17:45:00	monday
2434	17	2018-01-20 10:00:00	saturday
2435	16	2018-01-03 13:00:00	wednesday
2436	35	2018-01-13 13:45:00	saturday
2437	16	2018-01-22 15:30:00	monday
2438	4	2018-01-16 16:30:00	tuesday
2439	20	2018-01-03 15:15:00	wednesday
2440	4	2018-01-16 17:45:00	tuesday
2441	30	2018-01-12 10:30:00	friday
2442	34	2018-01-27 09:45:00	saturday
2443	6	2018-01-19 17:15:00	friday
2444	27	2018-01-13 08:45:00	saturday
2445	21	2018-01-15 14:30:00	monday
2446	20	2018-01-09 17:00:00	tuesday
2447	11	2018-01-18 12:30:00	thursday
2448	37	2018-01-17 12:15:00	wednesday
2449	15	2018-01-29 15:15:00	monday
2450	5	2018-01-02 14:00:00	tuesday
2451	13	2018-01-07 11:15:00	sunday
2452	34	2018-01-25 10:00:00	thursday
2453	38	2018-01-29 13:45:00	monday
2454	8	2018-01-05 15:15:00	friday
2455	21	2018-01-27 14:15:00	saturday
2456	6	2018-01-21 13:45:00	sunday
2457	38	2018-01-05 12:00:00	friday
2458	7	2018-01-22 17:15:00	monday
2459	8	2018-01-13 17:00:00	saturday
2460	36	2018-01-14 16:15:00	sunday
2461	25	2018-01-12 16:15:00	friday
2462	12	2018-01-27 16:45:00	saturday
2463	30	2018-02-15 12:45:00	thursday
2464	29	2018-02-02 12:45:00	friday
2465	26	2018-02-24 12:15:00	saturday
2466	2	2018-02-05 14:00:00	monday
2467	19	2018-02-16 12:30:00	friday
2468	5	2018-02-15 16:00:00	thursday
2469	34	2018-02-10 11:15:00	saturday
2470	19	2018-02-20 12:00:00	tuesday
2471	25	2018-02-18 16:45:00	sunday
2472	13	2018-02-23 17:45:00	friday
2473	4	2018-02-13 08:30:00	tuesday
2474	27	2018-02-25 11:30:00	sunday
2475	10	2018-02-09 15:00:00	friday
2476	8	2018-02-16 16:30:00	friday
2477	12	2018-02-07 16:15:00	wednesday
2478	27	2018-02-24 16:00:00	saturday
2479	2	2018-02-15 16:45:00	thursday
2480	17	2018-02-16 11:45:00	friday
2481	34	2018-02-26 08:30:00	monday
2482	38	2018-02-01 17:30:00	thursday
2483	19	2018-02-20 16:15:00	tuesday
2484	3	2018-02-26 17:15:00	monday
2485	3	2018-02-06 13:45:00	tuesday
2486	30	2018-02-26 17:00:00	monday
2487	22	2018-02-16 11:00:00	friday
2488	15	2018-02-20 10:15:00	tuesday
2489	24	2018-02-03 09:15:00	saturday
2490	14	2018-02-14 09:00:00	wednesday
2491	15	2018-02-24 13:00:00	saturday
2492	16	2018-02-09 17:30:00	friday
2493	36	2018-02-02 11:45:00	friday
2494	9	2018-02-02 15:45:00	friday
2495	8	2018-02-04 14:15:00	sunday
2496	9	2018-02-16 10:15:00	friday
2497	1	2018-02-24 09:15:00	saturday
2498	17	2018-02-03 13:30:00	saturday
2499	20	2018-02-17 13:15:00	saturday
2500	12	2018-02-26 15:30:00	monday
2501	10	2018-02-21 10:00:00	wednesday
2502	40	2018-02-09 08:00:00	friday
2503	5	2018-02-23 10:00:00	friday
2504	4	2018-02-11 16:30:00	sunday
2505	33	2018-02-26 10:15:00	monday
2506	10	2018-02-05 13:00:00	monday
2507	5	2018-02-15 13:00:00	thursday
2508	28	2018-02-25 14:00:00	sunday
2509	25	2018-02-14 13:30:00	wednesday
2510	31	2018-02-27 09:15:00	tuesday
2511	24	2018-02-01 17:00:00	thursday
2512	29	2018-02-18 11:15:00	sunday
2513	5	2018-02-23 09:30:00	friday
2514	20	2018-02-07 16:00:00	wednesday
2515	39	2018-02-18 09:45:00	sunday
2516	10	2018-02-25 08:15:00	sunday
2517	6	2018-02-17 11:15:00	saturday
2518	10	2018-02-19 08:15:00	monday
2519	5	2018-02-06 15:45:00	tuesday
2520	6	2018-02-25 09:00:00	sunday
2521	40	2018-02-16 09:00:00	friday
2522	21	2018-02-22 16:00:00	thursday
2523	21	2018-02-02 16:45:00	friday
2524	11	2018-02-22 13:00:00	thursday
2525	28	2018-02-26 10:00:00	monday
2526	37	2018-02-02 15:45:00	friday
2527	17	2018-02-14 13:00:00	wednesday
2528	12	2018-02-02 14:15:00	friday
2529	30	2018-02-02 17:45:00	friday
2530	15	2018-02-18 17:30:00	sunday
2531	19	2018-02-03 08:45:00	saturday
2532	11	2018-02-05 13:30:00	monday
2533	24	2018-02-05 15:45:00	monday
2534	28	2018-02-07 11:00:00	wednesday
2535	39	2018-02-09 12:15:00	friday
2536	27	2018-02-04 17:00:00	sunday
2537	36	2018-02-07 15:15:00	wednesday
2538	23	2018-02-25 14:00:00	sunday
2539	22	2018-02-05 09:15:00	monday
2540	30	2018-02-02 17:15:00	friday
2541	29	2018-02-21 11:00:00	wednesday
2542	19	2018-02-06 14:15:00	tuesday
2543	4	2018-02-27 08:45:00	tuesday
2544	30	2018-02-09 10:00:00	friday
2545	22	2018-02-24 17:30:00	saturday
2546	25	2018-03-16 14:30:00	friday
2547	2	2018-03-02 13:30:00	friday
2548	23	2018-03-08 13:30:00	thursday
2549	24	2018-03-30 10:45:00	friday
2550	29	2018-03-27 16:30:00	tuesday
2551	11	2018-03-18 13:30:00	sunday
2552	11	2018-03-09 09:15:00	friday
2553	6	2018-03-04 16:45:00	sunday
2554	17	2018-03-01 11:00:00	thursday
2555	25	2018-03-20 13:00:00	tuesday
2556	20	2018-03-18 14:00:00	sunday
2557	12	2018-03-15 12:15:00	thursday
2558	40	2018-03-17 11:30:00	saturday
2559	40	2018-03-12 13:30:00	monday
2560	29	2018-03-11 11:45:00	sunday
2561	34	2018-03-13 15:00:00	tuesday
2562	19	2018-03-06 11:15:00	tuesday
2563	17	2018-03-25 12:15:00	sunday
2564	24	2018-03-01 13:45:00	thursday
2565	5	2018-03-06 12:15:00	tuesday
2566	14	2018-03-01 13:45:00	thursday
2567	32	2018-03-17 10:15:00	saturday
2568	31	2018-03-13 17:00:00	tuesday
2569	22	2018-03-09 17:45:00	friday
2570	11	2018-03-18 09:45:00	sunday
2571	30	2018-03-01 09:15:00	thursday
2572	14	2018-03-14 13:30:00	wednesday
2573	40	2018-03-03 10:00:00	saturday
2574	29	2018-03-02 16:00:00	friday
2575	30	2018-03-01 08:45:00	thursday
2576	15	2018-03-28 13:45:00	wednesday
2577	21	2018-03-22 14:45:00	thursday
2578	37	2018-03-25 12:15:00	sunday
2579	19	2018-03-14 09:30:00	wednesday
2580	19	2018-03-04 09:00:00	sunday
2581	16	2018-03-16 13:00:00	friday
2582	39	2018-03-09 11:00:00	friday
2583	15	2018-03-04 14:00:00	sunday
2584	23	2018-03-28 15:15:00	wednesday
2585	35	2018-03-26 10:30:00	monday
2586	13	2018-03-18 10:00:00	sunday
2587	12	2018-03-30 10:15:00	friday
2588	28	2018-03-02 14:15:00	friday
2589	1	2018-03-29 14:30:00	thursday
2590	1	2018-03-12 10:45:00	monday
2591	38	2018-03-25 11:30:00	sunday
2592	4	2018-03-11 14:30:00	sunday
2593	21	2018-03-05 12:15:00	monday
2594	22	2018-03-08 15:00:00	thursday
2595	30	2018-03-10 13:00:00	saturday
2596	19	2018-03-18 16:00:00	sunday
2597	40	2018-03-19 11:00:00	monday
2598	31	2018-03-27 13:00:00	tuesday
2599	23	2018-03-18 15:45:00	sunday
2600	18	2018-03-20 08:15:00	tuesday
2601	14	2018-03-05 12:15:00	monday
2602	6	2018-03-26 12:15:00	monday
2603	28	2018-03-20 14:30:00	tuesday
2604	5	2018-03-15 09:15:00	thursday
2605	33	2018-03-04 11:15:00	sunday
2606	37	2018-03-25 16:15:00	sunday
2607	39	2018-03-14 12:45:00	wednesday
2608	37	2018-03-27 12:00:00	tuesday
2609	27	2018-03-25 17:00:00	sunday
2610	23	2018-03-21 13:00:00	wednesday
2611	27	2018-03-25 10:45:00	sunday
2612	30	2018-03-21 14:30:00	wednesday
2613	31	2018-03-11 16:30:00	sunday
2614	31	2018-03-21 08:45:00	wednesday
2615	9	2018-03-13 16:30:00	tuesday
2616	17	2018-03-06 09:30:00	tuesday
2617	23	2018-03-04 16:15:00	sunday
2618	15	2018-03-16 08:45:00	friday
2619	37	2018-03-19 12:15:00	monday
2620	26	2018-03-29 16:00:00	thursday
2621	14	2018-03-20 15:00:00	tuesday
2622	9	2018-03-30 10:00:00	friday
2623	10	2018-03-04 15:15:00	sunday
2624	34	2018-03-30 15:45:00	friday
2625	38	2018-03-30 15:45:00	friday
2626	32	2018-03-20 16:30:00	tuesday
2627	1	2018-03-15 12:30:00	thursday
2628	21	2018-03-03 15:45:00	saturday
2629	18	2018-04-07 09:15:00	saturday
2630	22	2018-04-28 16:00:00	saturday
2631	29	2018-04-15 11:45:00	sunday
2632	36	2018-04-14 14:00:00	saturday
2633	29	2018-04-22 09:30:00	sunday
2634	15	2018-04-08 14:30:00	sunday
2635	25	2018-04-03 12:45:00	tuesday
2636	34	2018-04-28 15:45:00	saturday
2637	24	2018-04-13 08:30:00	friday
2638	28	2018-04-04 13:45:00	wednesday
2639	14	2018-04-08 15:30:00	sunday
2640	27	2018-04-15 10:00:00	sunday
2641	7	2018-04-16 12:45:00	monday
2642	24	2018-04-25 14:00:00	wednesday
2643	1	2018-04-17 13:15:00	tuesday
2644	7	2018-04-06 12:30:00	friday
2645	36	2018-04-14 10:15:00	saturday
2646	21	2018-04-21 17:30:00	saturday
2647	18	2018-04-09 17:30:00	monday
2648	34	2018-04-14 16:15:00	saturday
2649	17	2018-04-08 13:45:00	sunday
2650	31	2018-04-24 08:15:00	tuesday
2651	13	2018-04-05 12:45:00	thursday
2652	23	2018-04-24 15:15:00	tuesday
2653	17	2018-04-29 08:45:00	sunday
2654	23	2018-04-14 12:00:00	saturday
2655	13	2018-04-19 16:45:00	thursday
2656	23	2018-04-03 10:00:00	tuesday
2657	22	2018-04-25 13:30:00	wednesday
2658	40	2018-04-16 14:00:00	monday
2659	18	2018-04-23 16:30:00	monday
2660	21	2018-04-06 11:30:00	friday
2661	11	2018-04-07 09:15:00	saturday
2662	20	2018-04-03 09:45:00	tuesday
2663	1	2018-04-17 17:30:00	tuesday
2664	28	2018-04-23 12:00:00	monday
2665	18	2018-04-01 12:45:00	sunday
2666	14	2018-04-12 09:00:00	thursday
2667	20	2018-04-15 17:30:00	sunday
2668	22	2018-04-29 16:15:00	sunday
2669	14	2018-04-04 15:30:00	wednesday
2670	25	2018-04-19 15:00:00	thursday
2671	36	2018-04-16 08:00:00	monday
2672	14	2018-04-24 13:45:00	tuesday
2673	2	2018-04-07 16:00:00	saturday
2674	23	2018-04-01 12:45:00	sunday
2675	14	2018-04-19 09:45:00	thursday
2676	23	2018-04-18 16:00:00	wednesday
2677	31	2018-04-23 15:00:00	monday
2678	10	2018-04-02 16:15:00	monday
2679	18	2018-04-25 10:45:00	wednesday
2680	10	2018-04-13 14:15:00	friday
2681	17	2018-04-07 12:15:00	saturday
2682	30	2018-04-13 17:15:00	friday
2683	28	2018-04-05 09:00:00	thursday
2684	26	2018-04-02 08:30:00	monday
2685	18	2018-04-21 12:30:00	saturday
2686	3	2018-04-01 16:15:00	sunday
2687	6	2018-04-02 14:00:00	monday
2688	34	2018-04-20 10:00:00	friday
2689	28	2018-04-03 17:45:00	tuesday
2690	6	2018-04-19 14:30:00	thursday
2691	10	2018-04-29 12:15:00	sunday
2692	36	2018-04-30 11:15:00	monday
2693	34	2018-04-04 14:00:00	wednesday
2694	24	2018-04-03 12:00:00	tuesday
2695	20	2018-04-19 14:30:00	thursday
2696	27	2018-04-12 14:30:00	thursday
2697	30	2018-04-23 09:15:00	monday
2698	21	2018-04-13 16:30:00	friday
2699	29	2018-04-07 12:15:00	saturday
2700	1	2018-04-13 15:15:00	friday
2701	19	2018-04-04 13:45:00	wednesday
2702	29	2018-04-02 08:45:00	monday
2703	9	2018-04-12 08:00:00	thursday
2704	1	2018-04-03 10:30:00	tuesday
2705	19	2018-04-05 09:00:00	thursday
2706	13	2018-04-24 13:30:00	tuesday
2707	33	2018-04-27 09:00:00	friday
2708	21	2018-04-12 16:00:00	thursday
2709	18	2018-04-21 08:45:00	saturday
2710	6	2018-04-30 16:15:00	monday
2711	16	2018-04-14 09:45:00	saturday
2712	16	2018-04-20 10:15:00	friday
2713	40	2018-04-13 09:00:00	friday
2714	11	2018-04-22 11:15:00	sunday
2715	33	2018-04-26 17:30:00	thursday
2716	4	2018-04-24 10:15:00	tuesday
2717	34	2018-04-11 16:45:00	wednesday
2718	7	2018-04-28 13:45:00	saturday
2719	21	2018-05-26 08:15:00	saturday
2720	35	2018-05-19 14:00:00	saturday
2721	32	2018-05-01 08:15:00	tuesday
2722	19	2018-05-22 16:45:00	tuesday
2723	9	2018-05-02 10:45:00	wednesday
2724	1	2018-05-18 08:45:00	friday
2725	31	2018-05-11 15:15:00	friday
2726	3	2018-05-06 16:45:00	sunday
2727	5	2018-05-20 17:30:00	sunday
2728	16	2018-05-29 14:30:00	tuesday
2729	24	2018-05-25 17:00:00	friday
2730	25	2018-05-15 12:00:00	tuesday
2731	22	2018-05-20 08:30:00	sunday
2732	26	2018-05-30 09:15:00	wednesday
2733	38	2018-05-08 08:30:00	tuesday
2734	8	2018-05-20 15:15:00	sunday
2735	4	2018-05-03 16:30:00	thursday
2736	1	2018-05-19 13:15:00	saturday
2737	19	2018-05-06 10:15:00	sunday
2738	33	2018-05-24 15:45:00	thursday
2739	11	2018-05-06 14:45:00	sunday
2740	1	2018-05-01 17:45:00	tuesday
2741	26	2018-05-14 09:15:00	monday
2742	32	2018-05-11 10:15:00	friday
2743	28	2018-05-15 08:00:00	tuesday
2744	36	2018-05-14 17:45:00	monday
2745	38	2018-05-12 16:45:00	saturday
2746	23	2018-05-28 14:30:00	monday
2747	4	2018-05-25 16:15:00	friday
2748	4	2018-05-03 12:00:00	thursday
2749	8	2018-05-26 17:30:00	saturday
2750	24	2018-05-01 11:45:00	tuesday
2751	28	2018-05-14 08:45:00	monday
2752	35	2018-05-05 09:15:00	saturday
2753	12	2018-05-26 15:15:00	saturday
2754	30	2018-05-20 11:45:00	sunday
2755	22	2018-05-17 17:00:00	thursday
2756	5	2018-05-07 14:45:00	monday
2757	3	2018-05-09 15:15:00	wednesday
2758	36	2018-05-15 09:15:00	tuesday
2759	21	2018-05-09 10:15:00	wednesday
2760	20	2018-05-27 17:15:00	sunday
2761	25	2018-05-22 17:15:00	tuesday
2762	28	2018-05-19 10:15:00	saturday
2763	36	2018-05-30 16:00:00	wednesday
2764	25	2018-05-09 08:30:00	wednesday
2765	31	2018-05-09 11:45:00	wednesday
2766	8	2018-05-21 17:00:00	monday
2767	29	2018-05-06 17:00:00	sunday
2768	1	2018-05-07 15:30:00	monday
2769	10	2018-05-17 15:00:00	thursday
2770	12	2018-05-30 15:45:00	wednesday
2771	27	2018-05-04 17:45:00	friday
2772	36	2018-05-02 13:15:00	wednesday
2773	17	2018-05-25 08:00:00	friday
2774	8	2018-05-12 11:45:00	saturday
2775	16	2018-05-06 10:45:00	sunday
2776	15	2018-05-04 12:30:00	friday
2777	26	2018-05-01 12:30:00	tuesday
2778	9	2018-05-22 17:30:00	tuesday
2779	6	2018-05-13 13:45:00	sunday
2780	26	2018-05-02 17:45:00	wednesday
2781	29	2018-05-19 14:15:00	saturday
2782	40	2018-05-22 15:30:00	tuesday
2783	40	2018-05-03 17:45:00	thursday
2784	2	2018-05-03 08:45:00	thursday
2785	5	2018-05-29 15:00:00	tuesday
2786	16	2018-05-20 17:30:00	sunday
2787	25	2018-05-07 11:15:00	monday
2788	7	2018-05-16 11:45:00	wednesday
2789	5	2018-06-25 15:30:00	monday
2790	20	2018-06-18 12:15:00	monday
2791	28	2018-06-27 10:00:00	wednesday
2792	30	2018-06-13 12:45:00	wednesday
2793	8	2018-06-26 08:30:00	tuesday
2794	30	2018-06-15 17:00:00	friday
2795	25	2018-06-30 09:30:00	saturday
2796	23	2018-06-14 17:30:00	thursday
2797	24	2018-06-11 14:30:00	monday
2798	32	2018-06-27 17:45:00	wednesday
2799	21	2018-06-16 08:45:00	saturday
2800	39	2018-06-07 09:00:00	thursday
2801	30	2018-06-18 17:30:00	monday
2802	37	2018-06-23 16:15:00	saturday
2803	2	2018-06-10 15:45:00	sunday
2804	30	2018-06-09 15:15:00	saturday
2805	23	2018-06-17 12:00:00	sunday
2806	15	2018-06-30 12:00:00	saturday
2807	25	2018-06-28 16:00:00	thursday
2808	32	2018-06-17 16:30:00	sunday
2809	28	2018-06-12 15:45:00	tuesday
2810	10	2018-06-11 16:30:00	monday
2811	38	2018-06-23 10:45:00	saturday
2812	40	2018-06-14 12:15:00	thursday
2813	24	2018-06-04 15:00:00	monday
2814	15	2018-06-18 17:00:00	monday
2815	36	2018-06-09 16:45:00	saturday
2816	39	2018-06-22 12:45:00	friday
2817	37	2018-06-25 13:00:00	monday
2818	9	2018-06-13 15:00:00	wednesday
2819	3	2018-06-07 09:15:00	thursday
2820	32	2018-06-18 12:45:00	monday
2821	22	2018-06-12 12:45:00	tuesday
2822	10	2018-06-10 08:45:00	sunday
2823	16	2018-06-08 17:15:00	friday
2824	30	2018-06-10 10:45:00	sunday
2825	30	2018-06-05 16:30:00	tuesday
2826	30	2018-06-28 12:30:00	thursday
2827	37	2018-06-06 14:30:00	wednesday
2828	12	2018-06-24 08:15:00	sunday
2829	30	2018-06-16 12:00:00	saturday
2830	6	2018-06-23 08:30:00	saturday
2831	28	2018-06-13 08:30:00	wednesday
2832	27	2018-06-02 08:30:00	saturday
2833	2	2018-06-28 16:30:00	thursday
2834	12	2018-06-04 15:00:00	monday
2835	31	2018-06-12 11:45:00	tuesday
2836	30	2018-06-29 15:45:00	friday
2837	27	2018-06-19 11:45:00	tuesday
2838	5	2018-06-10 08:45:00	sunday
2839	9	2018-06-05 13:00:00	tuesday
2840	32	2018-06-04 08:00:00	monday
2841	21	2018-06-11 09:00:00	monday
2842	1	2018-06-28 09:30:00	thursday
2843	5	2018-06-25 09:00:00	monday
2844	27	2018-06-06 08:45:00	wednesday
2845	26	2018-06-19 12:00:00	tuesday
2846	36	2018-06-08 08:15:00	friday
2847	29	2018-06-14 08:45:00	thursday
2848	34	2018-06-03 16:30:00	sunday
2849	20	2018-06-01 10:00:00	friday
2850	32	2018-06-07 11:30:00	thursday
2851	4	2018-06-12 15:45:00	tuesday
2852	8	2018-06-11 12:30:00	monday
2853	38	2018-06-21 13:15:00	thursday
2854	23	2018-06-20 14:45:00	wednesday
2855	28	2018-06-04 08:45:00	monday
2856	21	2018-06-10 12:00:00	sunday
2857	34	2018-06-18 17:30:00	monday
2858	4	2018-06-06 15:15:00	wednesday
2859	15	2018-06-05 10:45:00	tuesday
2860	23	2018-06-21 16:15:00	thursday
2861	27	2018-07-17 12:00:00	tuesday
2862	34	2018-07-23 17:00:00	monday
2863	33	2018-07-24 12:15:00	tuesday
2864	30	2018-07-08 08:00:00	sunday
2865	28	2018-07-04 11:00:00	wednesday
2866	35	2018-07-03 13:45:00	tuesday
2867	35	2018-07-21 14:45:00	saturday
2868	29	2018-07-04 12:30:00	wednesday
2869	30	2018-07-03 13:45:00	tuesday
2870	1	2018-07-11 08:15:00	wednesday
2871	16	2018-07-06 10:15:00	friday
2872	31	2018-07-26 08:30:00	thursday
2873	13	2018-07-21 11:15:00	saturday
2874	15	2018-07-28 15:45:00	saturday
2875	11	2018-07-10 11:45:00	tuesday
2876	6	2018-07-01 16:45:00	sunday
2877	18	2018-07-17 10:15:00	tuesday
2878	32	2018-07-29 15:45:00	sunday
2879	21	2018-07-15 09:30:00	sunday
2880	20	2018-07-27 13:15:00	friday
2881	1	2018-07-26 17:30:00	thursday
2882	5	2018-07-24 10:15:00	tuesday
2883	3	2018-07-27 14:00:00	friday
2884	29	2018-07-02 10:15:00	monday
2885	28	2018-07-26 09:15:00	thursday
2886	10	2018-07-21 10:15:00	saturday
2887	13	2018-07-14 12:45:00	saturday
2888	35	2018-07-14 11:00:00	saturday
2889	13	2018-07-07 08:30:00	saturday
2890	33	2018-07-08 12:30:00	sunday
2891	24	2018-07-08 10:00:00	sunday
2892	16	2018-07-24 12:00:00	tuesday
2893	7	2018-07-22 15:00:00	sunday
2894	29	2018-07-08 15:00:00	sunday
2895	20	2018-07-15 11:00:00	sunday
2896	7	2018-07-16 12:00:00	monday
2897	20	2018-07-07 12:45:00	saturday
2898	15	2018-07-26 09:45:00	thursday
2899	29	2018-07-11 11:00:00	wednesday
2900	34	2018-07-03 10:30:00	tuesday
2901	23	2018-07-14 09:30:00	saturday
2902	35	2018-07-28 11:30:00	saturday
2903	13	2018-07-27 08:00:00	friday
2904	27	2018-07-20 13:15:00	friday
2905	3	2018-07-20 10:30:00	friday
2906	27	2018-07-28 09:45:00	saturday
2907	22	2018-07-14 13:15:00	saturday
2908	6	2018-07-20 10:15:00	friday
2909	9	2018-07-14 16:45:00	saturday
2910	10	2018-07-18 09:45:00	wednesday
2911	20	2018-07-27 16:45:00	friday
2912	13	2018-07-21 14:45:00	saturday
2913	5	2018-07-11 11:30:00	wednesday
2914	9	2018-07-01 08:45:00	sunday
2915	40	2018-07-27 14:00:00	friday
2916	2	2018-07-29 16:00:00	sunday
2917	40	2018-07-15 16:15:00	sunday
2918	36	2018-07-01 17:00:00	sunday
2919	14	2018-07-29 08:45:00	sunday
2920	31	2018-07-06 17:15:00	friday
2921	14	2018-07-26 09:15:00	thursday
2922	5	2018-07-24 16:45:00	tuesday
2923	31	2018-07-26 12:45:00	thursday
2924	24	2018-07-09 11:30:00	monday
2925	33	2018-07-23 13:30:00	monday
2926	14	2018-07-22 15:15:00	sunday
2927	6	2018-07-19 14:00:00	thursday
2928	39	2018-07-19 12:45:00	thursday
2929	35	2018-07-25 10:15:00	wednesday
2930	3	2018-07-18 08:30:00	wednesday
2931	30	2018-07-25 09:00:00	wednesday
2932	21	2018-07-13 12:00:00	friday
2933	7	2018-07-04 15:15:00	wednesday
2934	36	2018-07-18 11:45:00	wednesday
2935	24	2018-08-16 11:30:00	thursday
2936	31	2018-08-23 13:30:00	thursday
2937	31	2018-08-06 15:30:00	monday
2938	22	2018-08-15 16:15:00	wednesday
2939	9	2018-08-22 08:30:00	wednesday
2940	37	2018-08-26 12:30:00	sunday
2941	6	2018-08-16 09:45:00	thursday
2942	26	2018-08-02 08:15:00	thursday
2943	1	2018-08-01 17:45:00	wednesday
2944	36	2018-08-10 16:30:00	friday
2945	23	2018-08-13 17:00:00	monday
2946	12	2018-08-02 16:45:00	thursday
2947	4	2018-08-25 08:45:00	saturday
2948	13	2018-08-17 14:15:00	friday
2949	3	2018-08-23 16:00:00	thursday
2950	20	2018-08-07 09:45:00	tuesday
2951	13	2018-08-16 16:00:00	thursday
2952	34	2018-08-17 16:30:00	friday
2953	30	2018-08-18 12:30:00	saturday
2954	7	2018-08-11 11:30:00	saturday
2955	4	2018-08-22 10:45:00	wednesday
2956	15	2018-08-03 17:45:00	friday
2957	9	2018-08-07 17:00:00	tuesday
2958	22	2018-08-04 16:45:00	saturday
2959	22	2018-08-25 12:00:00	saturday
2960	5	2018-08-26 17:30:00	sunday
2961	40	2018-08-25 17:00:00	saturday
2962	36	2018-08-11 13:30:00	saturday
2963	13	2018-08-03 08:15:00	friday
2964	23	2018-08-03 09:00:00	friday
2965	37	2018-08-24 14:30:00	friday
2966	20	2018-08-28 08:30:00	tuesday
2967	2	2018-08-10 11:00:00	friday
2968	17	2018-08-12 15:15:00	sunday
2969	10	2018-08-14 14:15:00	tuesday
2970	7	2018-08-04 14:00:00	saturday
2971	34	2018-08-17 12:15:00	friday
2972	19	2018-08-06 11:45:00	monday
2973	18	2018-08-22 11:45:00	wednesday
2974	9	2018-08-04 11:45:00	saturday
2975	13	2018-08-10 13:45:00	friday
2976	1	2018-08-13 10:15:00	monday
2977	15	2018-08-17 08:00:00	friday
2978	12	2018-08-01 08:45:00	wednesday
2979	39	2018-08-30 14:15:00	thursday
2980	22	2018-08-21 09:30:00	tuesday
2981	36	2018-08-25 10:15:00	saturday
2982	3	2018-08-03 15:15:00	friday
2983	10	2018-08-05 15:45:00	sunday
2984	35	2018-08-23 09:00:00	thursday
2985	36	2018-08-14 14:45:00	tuesday
2986	39	2018-08-15 17:15:00	wednesday
2987	17	2018-08-01 13:45:00	wednesday
2988	27	2018-08-06 09:00:00	monday
2989	40	2018-08-21 09:15:00	tuesday
2990	28	2018-08-20 15:30:00	monday
2991	5	2018-08-20 12:30:00	monday
2992	34	2018-08-07 11:45:00	tuesday
2993	28	2018-08-19 12:45:00	sunday
2994	28	2018-08-19 17:15:00	sunday
2995	27	2018-08-04 08:00:00	saturday
2996	16	2018-08-22 10:45:00	wednesday
2997	2	2018-08-16 14:30:00	thursday
2998	26	2018-08-02 09:00:00	thursday
2999	35	2018-08-27 17:30:00	monday
3000	17	2018-08-07 08:30:00	tuesday
3001	27	2018-08-29 11:30:00	wednesday
3002	31	2018-08-16 10:30:00	thursday
3003	9	2018-08-26 10:15:00	sunday
3004	39	2018-08-07 15:30:00	tuesday
3005	28	2018-08-13 16:00:00	monday
3006	7	2018-08-27 08:45:00	monday
3007	7	2018-08-19 16:00:00	sunday
3008	13	2018-08-23 11:15:00	thursday
3009	6	2018-08-18 15:30:00	saturday
3010	36	2018-08-19 11:45:00	sunday
3011	8	2018-08-25 09:00:00	saturday
3012	14	2018-08-10 10:00:00	friday
3013	28	2018-08-16 17:15:00	thursday
3014	8	2018-08-24 10:00:00	friday
3015	6	2018-08-10 09:15:00	friday
3016	27	2018-08-13 16:30:00	monday
3017	9	2018-09-29 10:15:00	saturday
3018	31	2018-09-01 11:30:00	saturday
3019	3	2018-09-07 09:45:00	friday
3020	23	2018-09-19 11:15:00	wednesday
3021	30	2018-09-14 12:30:00	friday
3022	17	2018-09-23 09:00:00	sunday
3023	19	2018-09-26 15:45:00	wednesday
3024	13	2018-09-07 13:45:00	friday
3025	38	2018-09-28 13:30:00	friday
3026	19	2018-09-17 15:00:00	monday
3027	39	2018-09-22 16:15:00	saturday
3028	39	2018-09-29 15:45:00	saturday
3029	5	2018-09-25 08:15:00	tuesday
3030	38	2018-09-28 08:30:00	friday
3031	10	2018-09-01 15:30:00	saturday
3032	32	2018-09-28 11:15:00	friday
3033	3	2018-09-26 17:30:00	wednesday
3034	5	2018-09-28 12:15:00	friday
3035	15	2018-09-24 14:45:00	monday
3036	34	2018-09-28 12:00:00	friday
3037	21	2018-09-06 17:45:00	thursday
3038	35	2018-09-14 08:30:00	friday
3039	40	2018-09-15 13:45:00	saturday
3040	24	2018-09-18 10:00:00	tuesday
3041	4	2018-09-23 09:15:00	sunday
3042	2	2018-09-23 13:00:00	sunday
3043	15	2018-09-25 09:15:00	tuesday
3044	12	2018-09-30 16:30:00	sunday
3045	27	2018-09-05 14:15:00	wednesday
3046	36	2018-09-17 09:00:00	monday
3047	32	2018-09-28 17:15:00	friday
3048	33	2018-09-25 13:45:00	tuesday
3049	20	2018-09-06 11:45:00	thursday
3050	4	2018-09-13 16:30:00	thursday
3051	4	2018-09-23 12:00:00	sunday
3052	9	2018-09-08 14:00:00	saturday
3053	18	2018-09-24 12:45:00	monday
3054	5	2018-09-29 17:00:00	saturday
3055	31	2018-09-12 16:00:00	wednesday
3056	23	2018-09-26 09:00:00	wednesday
3057	39	2018-09-28 09:30:00	friday
3058	24	2018-09-06 14:30:00	thursday
3059	26	2018-09-10 09:00:00	monday
3060	21	2018-09-30 11:15:00	sunday
3061	30	2018-09-21 15:15:00	friday
3062	1	2018-09-29 17:15:00	saturday
3063	24	2018-09-27 11:45:00	thursday
3064	37	2018-09-26 10:15:00	wednesday
3065	18	2018-09-01 10:30:00	saturday
3066	2	2018-09-12 09:15:00	wednesday
3067	3	2018-09-20 15:45:00	thursday
3068	11	2018-09-26 17:30:00	wednesday
3069	20	2018-09-26 11:15:00	wednesday
3070	14	2018-09-14 13:15:00	friday
3071	15	2018-09-03 16:15:00	monday
3072	9	2018-09-02 14:30:00	sunday
3073	40	2018-09-01 13:30:00	saturday
3074	38	2018-09-04 11:30:00	tuesday
3075	37	2018-09-07 17:15:00	friday
3076	1	2018-09-25 10:15:00	tuesday
3077	8	2018-09-09 13:30:00	sunday
3078	14	2018-10-13 12:15:00	saturday
3079	9	2018-10-26 14:45:00	friday
3080	30	2018-10-26 09:45:00	friday
3081	22	2018-10-26 11:30:00	friday
3082	32	2018-10-12 09:30:00	friday
3083	20	2018-10-03 15:00:00	wednesday
3084	25	2018-10-06 12:15:00	saturday
3085	36	2018-10-28 15:00:00	sunday
3086	23	2018-10-09 16:30:00	tuesday
3087	17	2018-10-04 12:30:00	thursday
3088	39	2018-10-01 16:15:00	monday
3089	23	2018-10-08 10:00:00	monday
3090	36	2018-10-25 17:15:00	thursday
3091	19	2018-10-26 08:30:00	friday
3092	25	2018-10-23 16:15:00	tuesday
3093	15	2018-10-27 16:15:00	saturday
3094	3	2018-10-19 17:00:00	friday
3095	12	2018-10-25 10:15:00	thursday
3096	17	2018-10-18 09:45:00	thursday
3097	7	2018-10-21 16:00:00	sunday
3098	6	2018-10-30 12:00:00	tuesday
3099	30	2018-10-20 08:45:00	saturday
3100	35	2018-10-30 09:45:00	tuesday
3101	2	2018-10-02 15:45:00	tuesday
3102	31	2018-10-26 16:15:00	friday
3103	21	2018-10-20 14:15:00	saturday
3104	25	2018-10-26 08:00:00	friday
3105	35	2018-10-07 14:00:00	sunday
3106	33	2018-10-15 08:30:00	monday
3107	2	2018-10-30 15:15:00	tuesday
3108	28	2018-10-18 15:00:00	thursday
3109	11	2018-10-25 08:30:00	thursday
3110	23	2018-10-26 10:00:00	friday
3111	8	2018-10-19 09:45:00	friday
3112	9	2018-10-03 11:45:00	wednesday
3113	6	2018-10-05 08:45:00	friday
3114	11	2018-10-12 17:30:00	friday
3115	18	2018-10-02 17:15:00	tuesday
3116	16	2018-10-21 17:45:00	sunday
3117	37	2018-10-24 16:30:00	wednesday
3118	31	2018-10-20 17:15:00	saturday
3119	26	2018-10-03 14:15:00	wednesday
3120	6	2018-10-09 08:15:00	tuesday
3121	20	2018-10-30 17:15:00	tuesday
3122	6	2018-10-02 11:30:00	tuesday
3123	11	2018-10-17 14:00:00	wednesday
3124	19	2018-10-29 17:30:00	monday
3125	13	2018-10-11 17:45:00	thursday
3126	19	2018-10-12 13:15:00	friday
3127	38	2018-10-28 17:30:00	sunday
3128	12	2018-10-23 09:30:00	tuesday
3129	2	2018-10-12 10:00:00	friday
3130	15	2018-10-27 14:30:00	saturday
3131	32	2018-10-17 14:45:00	wednesday
3132	33	2018-10-07 13:00:00	sunday
3133	30	2018-10-26 08:15:00	friday
3134	39	2018-10-17 13:30:00	wednesday
3135	25	2018-10-21 09:30:00	sunday
3136	7	2018-10-28 13:30:00	sunday
3137	12	2018-10-08 15:45:00	monday
3138	35	2018-10-25 17:15:00	thursday
3139	13	2018-10-21 11:45:00	sunday
3140	14	2018-10-15 10:30:00	monday
3141	29	2018-10-12 14:30:00	friday
3142	30	2018-10-21 13:45:00	sunday
3143	30	2018-10-18 14:30:00	thursday
3144	26	2018-10-19 14:30:00	friday
3145	21	2018-10-21 17:45:00	sunday
3146	36	2018-10-28 09:15:00	sunday
3147	39	2018-10-11 13:45:00	thursday
3148	38	2018-10-24 10:00:00	wednesday
3149	13	2018-10-23 17:15:00	tuesday
3150	22	2018-10-03 17:30:00	wednesday
3151	1	2018-10-30 13:00:00	tuesday
3152	19	2018-10-15 10:30:00	monday
3153	9	2018-10-03 12:45:00	wednesday
3154	7	2018-11-30 17:00:00	friday
3155	33	2018-11-01 16:45:00	thursday
3156	12	2018-11-24 16:45:00	saturday
3157	18	2018-11-16 15:15:00	friday
3158	1	2018-11-21 16:45:00	wednesday
3159	15	2018-11-04 11:15:00	sunday
3160	13	2018-11-25 12:00:00	sunday
3161	28	2018-11-03 11:00:00	saturday
3162	16	2018-11-08 11:30:00	thursday
3163	7	2018-11-27 11:30:00	tuesday
3164	14	2018-11-06 12:00:00	tuesday
3165	17	2018-11-18 11:30:00	sunday
3166	21	2018-11-14 13:45:00	wednesday
3167	28	2018-11-18 12:00:00	sunday
3168	27	2018-11-22 09:15:00	thursday
3169	19	2018-11-01 17:30:00	thursday
3170	27	2018-11-26 12:00:00	monday
3171	38	2018-11-22 08:30:00	thursday
3172	38	2018-11-20 08:15:00	tuesday
3173	37	2018-11-17 08:15:00	saturday
3174	12	2018-11-28 10:30:00	wednesday
3175	34	2018-11-12 17:15:00	monday
3176	26	2018-11-14 15:00:00	wednesday
3177	2	2018-11-19 16:15:00	monday
3178	27	2018-11-14 13:00:00	wednesday
3179	26	2018-11-29 14:00:00	thursday
3180	2	2018-11-13 17:30:00	tuesday
3181	35	2018-11-20 08:30:00	tuesday
3182	3	2018-11-24 15:45:00	saturday
3183	15	2018-11-28 14:15:00	wednesday
3184	7	2018-11-23 08:00:00	friday
3185	4	2018-11-17 14:15:00	saturday
3186	38	2018-11-01 13:30:00	thursday
3187	14	2018-11-23 10:30:00	friday
3188	36	2018-11-28 10:30:00	wednesday
3189	38	2018-11-10 08:15:00	saturday
3190	30	2018-11-15 09:45:00	thursday
3191	31	2018-11-12 15:00:00	monday
3192	20	2018-11-26 12:15:00	monday
3193	21	2018-11-01 14:30:00	thursday
3194	14	2018-11-20 15:15:00	tuesday
3195	22	2018-11-25 16:15:00	sunday
3196	25	2018-11-06 11:15:00	tuesday
3197	10	2018-11-15 11:30:00	thursday
3198	33	2018-11-08 14:15:00	thursday
3199	13	2018-11-25 09:45:00	sunday
3200	30	2018-11-03 10:15:00	saturday
3201	9	2018-11-05 13:15:00	monday
3202	17	2018-11-14 16:45:00	wednesday
3203	14	2018-11-05 14:15:00	monday
3204	21	2018-11-22 14:15:00	thursday
3205	36	2018-11-07 17:00:00	wednesday
3206	16	2018-11-04 08:15:00	sunday
3207	21	2018-11-20 15:00:00	tuesday
3208	25	2018-11-19 15:00:00	monday
3209	13	2018-11-09 15:30:00	friday
3210	9	2018-11-13 11:00:00	tuesday
3211	3	2018-11-03 15:30:00	saturday
3212	36	2018-11-01 16:30:00	thursday
3213	15	2018-11-22 10:00:00	thursday
3214	15	2018-11-26 13:00:00	monday
3215	4	2018-11-09 12:30:00	friday
3216	17	2018-11-30 15:45:00	friday
3217	29	2018-11-01 09:30:00	thursday
3218	4	2018-11-06 17:15:00	tuesday
3219	9	2018-11-17 08:15:00	saturday
3220	10	2018-11-16 09:45:00	friday
3221	40	2018-11-14 09:00:00	wednesday
3222	2	2018-11-25 09:00:00	sunday
3223	13	2018-11-23 14:00:00	friday
3224	18	2018-11-05 14:30:00	monday
3225	4	2018-11-15 11:30:00	thursday
3226	20	2018-11-04 15:00:00	sunday
3227	3	2018-11-24 11:15:00	saturday
3228	27	2018-11-26 13:30:00	monday
3229	26	2018-11-25 09:15:00	sunday
3230	20	2018-11-02 12:15:00	friday
3231	29	2018-11-13 13:15:00	tuesday
3232	16	2018-11-12 13:30:00	monday
3233	38	2018-11-21 14:00:00	wednesday
3234	14	2018-11-12 13:45:00	monday
3235	13	2018-11-09 09:30:00	friday
3236	19	2018-12-30 13:30:00	sunday
3237	34	2018-12-13 10:30:00	thursday
3238	35	2018-12-24 14:30:00	monday
3239	38	2018-12-21 12:15:00	friday
3240	22	2018-12-16 16:45:00	sunday
3241	40	2018-12-21 15:00:00	friday
3242	6	2018-12-24 16:45:00	monday
3243	36	2018-12-28 08:45:00	friday
3244	13	2018-12-06 10:15:00	thursday
3245	3	2018-12-09 09:15:00	sunday
3246	9	2018-12-27 13:15:00	thursday
3247	15	2018-12-28 10:45:00	friday
3248	18	2018-12-06 09:45:00	thursday
3249	29	2018-12-21 12:15:00	friday
3250	8	2018-12-18 16:30:00	tuesday
3251	11	2018-12-24 17:00:00	monday
3252	7	2018-12-21 14:00:00	friday
3253	9	2018-12-12 12:45:00	wednesday
3254	36	2018-12-04 15:15:00	tuesday
3255	10	2018-12-06 09:00:00	thursday
3256	6	2018-12-05 09:30:00	wednesday
3257	17	2018-12-13 08:30:00	thursday
3258	32	2018-12-07 15:45:00	friday
3259	38	2018-12-13 11:00:00	thursday
3260	19	2018-12-19 17:45:00	wednesday
3261	40	2018-12-22 16:00:00	saturday
3262	38	2018-12-27 16:30:00	thursday
3263	11	2018-12-08 16:30:00	saturday
3264	8	2018-12-22 09:30:00	saturday
3265	17	2018-12-21 15:45:00	friday
3266	9	2018-12-12 12:30:00	wednesday
3267	10	2018-12-11 16:00:00	tuesday
3268	14	2018-12-29 14:00:00	saturday
3269	6	2018-12-12 12:00:00	wednesday
3270	4	2018-12-21 08:15:00	friday
3271	30	2018-12-20 08:00:00	thursday
3272	10	2018-12-24 17:30:00	monday
3273	40	2018-12-16 09:45:00	sunday
3274	9	2018-12-06 10:30:00	thursday
3275	34	2018-12-08 17:15:00	saturday
3276	21	2018-12-27 09:15:00	thursday
3277	20	2018-12-12 08:30:00	wednesday
3278	2	2018-12-22 16:45:00	saturday
3279	40	2018-12-29 14:00:00	saturday
3280	9	2018-12-06 09:30:00	thursday
3281	19	2018-12-04 13:15:00	tuesday
3282	26	2018-12-08 11:30:00	saturday
3283	3	2018-12-22 14:00:00	saturday
3284	18	2018-12-04 14:15:00	tuesday
3285	8	2018-12-17 09:15:00	monday
3286	4	2018-12-03 16:30:00	monday
3287	13	2018-12-17 17:30:00	monday
3288	1	2018-12-13 16:30:00	thursday
3289	13	2018-12-24 08:45:00	monday
3290	34	2018-12-10 09:00:00	monday
3291	16	2018-12-16 17:00:00	sunday
3292	34	2018-12-28 15:30:00	friday
3293	37	2018-12-01 17:00:00	saturday
3294	6	2018-12-26 16:15:00	wednesday
3295	23	2018-12-08 12:30:00	saturday
3296	14	2018-12-22 09:30:00	saturday
3297	27	2018-12-21 11:15:00	friday
3298	35	2018-12-02 11:15:00	sunday
3299	29	2018-12-30 15:45:00	sunday
3300	33	2018-12-29 10:15:00	saturday
3301	9	2019-01-03 09:00:00	thursday
3302	2	2019-01-28 09:00:00	monday
3303	20	2019-01-30 08:45:00	wednesday
3304	16	2019-01-23 09:00:00	wednesday
3305	30	2019-01-04 08:45:00	friday
3306	10	2019-01-17 14:45:00	thursday
3307	38	2019-01-19 12:30:00	saturday
3308	20	2019-01-07 09:00:00	monday
3309	22	2019-01-17 17:15:00	thursday
3310	36	2019-01-29 12:45:00	tuesday
3311	1	2019-01-12 17:15:00	saturday
3312	19	2019-01-28 11:00:00	monday
3313	37	2019-01-21 09:45:00	monday
3314	35	2019-01-06 12:30:00	sunday
3315	24	2019-01-04 13:00:00	friday
3316	31	2019-01-19 08:15:00	saturday
3317	29	2019-01-13 14:15:00	sunday
3318	39	2019-01-16 15:15:00	wednesday
3319	30	2019-01-08 13:45:00	tuesday
3320	19	2019-01-30 16:15:00	wednesday
3321	16	2019-01-21 10:00:00	monday
3322	29	2019-01-11 13:00:00	friday
3323	36	2019-01-10 17:15:00	thursday
3324	10	2019-01-13 12:15:00	sunday
3325	26	2019-01-23 08:15:00	wednesday
3326	15	2019-01-23 10:45:00	wednesday
3327	29	2019-01-19 16:00:00	saturday
3328	21	2019-01-09 12:00:00	wednesday
3329	4	2019-01-15 17:45:00	tuesday
3330	14	2019-01-04 11:30:00	friday
3331	28	2019-01-07 10:00:00	monday
3332	23	2019-01-15 16:00:00	tuesday
3333	32	2019-01-02 15:15:00	wednesday
3334	15	2019-01-22 16:45:00	tuesday
3335	3	2019-01-22 10:15:00	tuesday
3336	20	2019-01-12 14:15:00	saturday
3337	19	2019-01-22 10:45:00	tuesday
3338	10	2019-01-17 10:15:00	thursday
3339	21	2019-01-16 17:30:00	wednesday
3340	13	2019-01-21 14:00:00	monday
3341	37	2019-01-21 10:30:00	monday
3342	35	2019-01-25 14:45:00	friday
3343	13	2019-01-02 14:30:00	wednesday
3344	20	2019-01-10 12:30:00	thursday
3345	18	2019-01-09 14:45:00	wednesday
3346	12	2019-01-12 10:30:00	saturday
3347	35	2019-01-29 17:45:00	tuesday
3348	21	2019-01-21 17:15:00	monday
3349	11	2019-01-29 08:30:00	tuesday
3350	7	2019-01-02 15:00:00	wednesday
3351	13	2019-01-12 15:45:00	saturday
3352	2	2019-01-05 11:45:00	saturday
3353	29	2019-01-21 16:15:00	monday
3354	32	2019-01-12 16:15:00	saturday
3355	34	2019-01-01 17:30:00	tuesday
3356	37	2019-01-27 09:15:00	sunday
3357	40	2019-01-18 17:30:00	friday
3358	8	2019-01-21 12:30:00	monday
3359	8	2019-01-29 11:00:00	tuesday
3360	1	2019-01-29 12:30:00	tuesday
3361	39	2019-01-13 12:00:00	sunday
3362	19	2019-01-30 10:00:00	wednesday
3363	14	2019-01-22 13:00:00	tuesday
3364	9	2019-01-09 12:15:00	wednesday
3365	22	2019-01-09 13:00:00	wednesday
3366	2	2019-01-25 17:15:00	friday
3367	25	2019-01-12 16:45:00	saturday
3368	14	2019-01-06 11:30:00	sunday
3369	14	2019-01-26 17:30:00	saturday
3370	8	2019-01-30 09:15:00	wednesday
3371	35	2019-01-13 09:15:00	sunday
3372	12	2019-01-29 17:30:00	tuesday
3373	34	2019-01-17 11:15:00	thursday
3374	24	2019-01-15 12:15:00	tuesday
3375	14	2019-01-24 14:00:00	thursday
3376	20	2019-01-20 11:30:00	sunday
3377	37	2019-01-09 11:00:00	wednesday
3378	3	2019-01-29 10:45:00	tuesday
3379	5	2019-01-30 13:30:00	wednesday
3380	2	2019-01-07 17:30:00	monday
3381	8	2019-01-09 09:30:00	wednesday
3382	38	2019-02-23 09:45:00	saturday
3383	26	2019-02-22 12:00:00	friday
3384	32	2019-02-04 10:30:00	monday
3385	23	2019-02-25 10:15:00	monday
3386	25	2019-02-09 13:00:00	saturday
3387	16	2019-02-14 15:45:00	thursday
3388	16	2019-02-17 15:00:00	sunday
3389	20	2019-02-25 16:15:00	monday
3390	8	2019-02-28 13:00:00	thursday
3391	17	2019-02-26 09:30:00	tuesday
3392	12	2019-02-11 08:30:00	monday
3393	18	2019-02-20 11:45:00	wednesday
3394	14	2019-02-13 17:30:00	wednesday
3395	23	2019-02-26 14:15:00	tuesday
3396	1	2019-02-10 17:45:00	sunday
3397	34	2019-02-21 10:45:00	thursday
3398	12	2019-02-10 11:15:00	sunday
3399	38	2019-02-11 11:00:00	monday
3400	23	2019-02-17 14:15:00	sunday
3401	40	2019-02-09 16:00:00	saturday
3402	20	2019-02-05 14:45:00	tuesday
3403	40	2019-02-09 12:30:00	saturday
3404	1	2019-02-22 09:00:00	friday
3405	22	2019-02-04 15:00:00	monday
3406	35	2019-02-12 16:45:00	tuesday
3407	6	2019-02-09 12:15:00	saturday
3408	26	2019-02-01 11:15:00	friday
3409	6	2019-02-12 14:15:00	tuesday
3410	34	2019-02-20 10:30:00	wednesday
3411	5	2019-02-20 14:30:00	wednesday
3412	37	2019-02-22 17:00:00	friday
3413	28	2019-02-01 16:15:00	friday
3414	3	2019-02-24 12:00:00	sunday
3415	38	2019-02-17 10:15:00	sunday
3416	3	2019-02-26 12:45:00	tuesday
3417	1	2019-02-26 13:00:00	tuesday
3418	17	2019-02-14 17:00:00	thursday
3419	27	2019-02-18 08:00:00	monday
3420	16	2019-02-26 15:30:00	tuesday
3421	39	2019-02-01 11:15:00	friday
3422	31	2019-02-21 11:00:00	thursday
3423	32	2019-02-15 16:30:00	friday
3424	30	2019-02-18 15:00:00	monday
3425	11	2019-02-27 13:45:00	wednesday
3426	7	2019-02-03 11:15:00	sunday
3427	38	2019-02-28 08:30:00	thursday
3428	39	2019-02-07 11:30:00	thursday
3429	29	2019-02-19 17:45:00	tuesday
3430	28	2019-02-11 13:00:00	monday
3431	1	2019-02-22 09:15:00	friday
3432	14	2019-02-08 16:45:00	friday
3433	25	2019-02-02 09:45:00	saturday
3434	32	2019-02-03 10:15:00	sunday
3435	3	2019-02-21 09:15:00	thursday
3436	21	2019-02-03 08:30:00	sunday
3437	24	2019-02-17 13:15:00	sunday
3438	21	2019-02-18 14:15:00	monday
3439	5	2019-02-19 11:00:00	tuesday
3440	23	2019-02-24 15:00:00	sunday
3441	6	2019-02-19 14:45:00	tuesday
3442	6	2019-02-06 17:45:00	wednesday
3443	4	2019-02-06 13:00:00	wednesday
3444	39	2019-02-15 08:30:00	friday
3445	6	2019-02-23 17:00:00	saturday
3446	30	2019-02-06 16:00:00	wednesday
3447	8	2019-02-21 17:45:00	thursday
3448	14	2019-02-10 14:15:00	sunday
3449	8	2019-02-04 16:15:00	monday
3450	16	2019-02-04 13:00:00	monday
3451	29	2019-02-11 11:45:00	monday
3452	40	2019-02-04 10:30:00	monday
3453	9	2019-02-22 17:45:00	friday
3454	4	2019-02-27 12:30:00	wednesday
3455	30	2019-02-16 09:00:00	saturday
3456	38	2019-02-14 15:30:00	thursday
3457	34	2019-02-10 11:30:00	sunday
3458	15	2019-02-25 16:15:00	monday
3459	20	2019-02-18 17:15:00	monday
3460	20	2019-02-28 17:00:00	thursday
3461	38	2019-02-21 17:45:00	thursday
3462	11	2019-02-17 08:00:00	sunday
3463	35	2019-02-22 11:45:00	friday
3464	4	2019-02-07 11:00:00	thursday
3465	8	2019-02-20 14:00:00	wednesday
3466	1	2019-02-21 10:30:00	thursday
3467	28	2019-02-18 13:00:00	monday
3468	40	2019-02-24 17:15:00	sunday
3469	1	2019-02-21 10:15:00	thursday
3470	29	2019-03-24 17:30:00	sunday
3471	18	2019-03-26 14:30:00	tuesday
3472	2	2019-03-27 14:45:00	wednesday
3473	13	2019-03-11 15:00:00	monday
3474	2	2019-03-24 09:45:00	sunday
3475	25	2019-03-15 15:30:00	friday
3476	7	2019-03-23 17:30:00	saturday
3477	14	2019-03-06 13:45:00	wednesday
3478	40	2019-03-22 16:30:00	friday
3479	9	2019-03-17 14:30:00	sunday
3480	7	2019-03-21 13:45:00	thursday
3481	23	2019-03-14 17:45:00	thursday
3482	36	2019-03-12 17:00:00	tuesday
3483	14	2019-03-03 15:00:00	sunday
3484	29	2019-03-21 15:45:00	thursday
3485	9	2019-03-19 10:00:00	tuesday
3486	16	2019-03-01 09:45:00	friday
3487	34	2019-03-10 08:15:00	sunday
3488	29	2019-03-23 13:15:00	saturday
3489	40	2019-03-12 14:00:00	tuesday
3490	6	2019-03-15 12:30:00	friday
3491	33	2019-03-10 15:00:00	sunday
3492	39	2019-03-14 13:00:00	thursday
3493	38	2019-03-04 11:30:00	monday
3494	32	2019-03-02 13:30:00	saturday
3495	19	2019-03-24 15:45:00	sunday
3496	40	2019-03-01 08:15:00	friday
3497	37	2019-03-28 12:15:00	thursday
3498	33	2019-03-17 09:30:00	sunday
3499	36	2019-03-09 15:15:00	saturday
3500	17	2019-03-19 13:15:00	tuesday
3501	8	2019-03-25 10:45:00	monday
3502	4	2019-03-21 10:00:00	thursday
3503	6	2019-03-19 14:15:00	tuesday
3504	4	2019-03-18 12:15:00	monday
3505	34	2019-03-24 08:30:00	sunday
3506	3	2019-03-08 17:15:00	friday
3507	4	2019-03-12 09:15:00	tuesday
3508	13	2019-03-03 15:00:00	sunday
3509	37	2019-03-05 12:45:00	tuesday
3510	17	2019-03-15 15:00:00	friday
3511	32	2019-03-15 12:30:00	friday
3512	14	2019-03-30 16:00:00	saturday
3513	3	2019-03-12 15:15:00	tuesday
3514	32	2019-03-23 12:30:00	saturday
3515	37	2019-03-03 13:15:00	sunday
3516	25	2019-03-22 17:45:00	friday
3517	7	2019-03-16 08:15:00	saturday
3518	26	2019-03-06 17:30:00	wednesday
3519	13	2019-03-15 12:00:00	friday
3520	18	2019-03-18 13:00:00	monday
3521	28	2019-03-29 17:45:00	friday
3522	26	2019-03-04 16:15:00	monday
3523	11	2019-03-03 17:15:00	sunday
3524	33	2019-03-26 14:15:00	tuesday
3525	20	2019-03-28 10:15:00	thursday
3526	4	2019-03-25 13:30:00	monday
3527	17	2019-03-02 15:30:00	saturday
3528	26	2019-03-18 14:45:00	monday
3529	1	2019-03-26 08:45:00	tuesday
3530	32	2019-03-08 13:15:00	friday
3531	34	2019-03-19 13:00:00	tuesday
3532	40	2019-03-01 17:30:00	friday
3533	22	2019-03-06 14:30:00	wednesday
3534	2	2019-03-06 14:30:00	wednesday
3535	40	2019-03-05 10:30:00	tuesday
3536	5	2019-03-04 15:15:00	monday
3537	6	2019-03-04 09:00:00	monday
3538	27	2019-03-14 11:00:00	thursday
3539	30	2019-03-16 16:00:00	saturday
3540	10	2019-03-18 09:45:00	monday
3541	2	2019-03-19 15:15:00	tuesday
3542	40	2019-03-18 14:45:00	monday
3543	38	2019-03-28 08:00:00	thursday
3544	20	2019-03-24 16:45:00	sunday
3545	38	2019-03-15 08:00:00	friday
3546	33	2019-03-22 16:45:00	friday
3547	27	2019-03-09 12:00:00	saturday
3548	36	2019-03-27 16:00:00	wednesday
3549	37	2019-04-10 14:15:00	wednesday
3550	27	2019-04-22 09:15:00	monday
3551	31	2019-04-20 13:30:00	saturday
3552	13	2019-04-09 10:45:00	tuesday
3553	15	2019-04-30 16:45:00	tuesday
3554	38	2019-04-15 13:15:00	monday
3555	13	2019-04-15 15:00:00	monday
3556	1	2019-04-19 12:30:00	friday
3557	9	2019-04-28 15:00:00	sunday
3558	30	2019-04-04 15:45:00	thursday
3559	30	2019-04-27 16:30:00	saturday
3560	36	2019-04-21 10:30:00	sunday
3561	12	2019-04-04 11:00:00	thursday
3562	5	2019-04-12 16:30:00	friday
3563	39	2019-04-15 12:15:00	monday
3564	30	2019-04-20 10:45:00	saturday
3565	3	2019-04-11 16:45:00	thursday
3566	37	2019-04-11 15:45:00	thursday
3567	25	2019-04-21 10:15:00	sunday
3568	3	2019-04-03 08:00:00	wednesday
3569	40	2019-04-26 09:30:00	friday
3570	26	2019-04-03 16:15:00	wednesday
3571	31	2019-04-08 13:30:00	monday
3572	22	2019-04-23 16:15:00	tuesday
3573	38	2019-04-07 16:00:00	sunday
3574	13	2019-04-14 17:30:00	sunday
3575	18	2019-04-17 16:00:00	wednesday
3576	9	2019-04-14 10:15:00	sunday
3577	8	2019-04-20 15:00:00	saturday
3578	26	2019-04-16 10:00:00	tuesday
3579	23	2019-04-25 16:45:00	thursday
3580	13	2019-04-12 11:00:00	friday
3581	16	2019-04-13 15:00:00	saturday
3582	10	2019-04-07 12:00:00	sunday
3583	31	2019-04-17 11:30:00	wednesday
3584	7	2019-04-20 08:15:00	saturday
3585	32	2019-04-27 09:00:00	saturday
3586	8	2019-04-29 14:00:00	monday
3587	12	2019-04-08 11:45:00	monday
3588	24	2019-04-17 14:00:00	wednesday
3589	12	2019-04-29 15:30:00	monday
3590	23	2019-04-28 13:45:00	sunday
3591	2	2019-04-15 16:15:00	monday
3592	19	2019-04-29 08:45:00	monday
3593	21	2019-04-05 14:30:00	friday
3594	8	2019-04-06 13:30:00	saturday
3595	3	2019-04-30 14:00:00	tuesday
3596	2	2019-04-30 17:45:00	tuesday
3597	21	2019-04-07 15:45:00	sunday
3598	40	2019-04-24 08:00:00	wednesday
3599	32	2019-04-12 08:45:00	friday
3600	17	2019-04-13 12:00:00	saturday
3601	1	2019-04-27 17:30:00	saturday
3602	7	2019-04-18 12:30:00	thursday
3603	14	2019-04-27 09:45:00	saturday
3604	16	2019-04-13 15:45:00	saturday
3605	25	2019-04-08 12:15:00	monday
3606	25	2019-04-26 09:15:00	friday
3607	13	2019-04-09 12:00:00	tuesday
3608	35	2019-04-11 17:45:00	thursday
3609	8	2019-04-08 09:45:00	monday
3610	17	2019-04-06 09:30:00	saturday
3611	2	2019-04-30 12:15:00	tuesday
3612	29	2019-04-16 16:45:00	tuesday
3613	18	2019-04-14 08:00:00	sunday
3614	15	2019-04-08 15:30:00	monday
3615	37	2019-04-25 15:15:00	thursday
3616	16	2019-04-20 10:45:00	saturday
3617	8	2019-04-30 13:00:00	tuesday
3618	32	2019-04-10 12:30:00	wednesday
3619	27	2019-04-11 16:30:00	thursday
3620	14	2019-04-13 14:30:00	saturday
3621	5	2019-04-22 15:45:00	monday
3622	14	2019-04-29 17:30:00	monday
3623	20	2019-04-27 13:45:00	saturday
3624	17	2019-04-09 09:45:00	tuesday
3625	12	2019-04-01 14:45:00	monday
3626	10	2019-05-22 08:30:00	wednesday
3627	36	2019-05-17 08:00:00	friday
3628	13	2019-05-18 14:15:00	saturday
3629	23	2019-05-14 16:30:00	tuesday
3630	1	2019-05-14 09:15:00	tuesday
3631	22	2019-05-19 13:30:00	sunday
3632	12	2019-05-13 16:15:00	monday
3633	16	2019-05-18 12:45:00	saturday
3634	35	2019-05-08 16:15:00	wednesday
3635	11	2019-05-05 13:00:00	sunday
3636	1	2019-05-11 17:30:00	saturday
3637	18	2019-05-30 13:30:00	thursday
3638	20	2019-05-25 16:00:00	saturday
3639	31	2019-05-13 09:30:00	monday
3640	13	2019-05-14 12:45:00	tuesday
3641	15	2019-05-27 13:45:00	monday
3642	14	2019-05-15 10:30:00	wednesday
3643	35	2019-05-28 14:00:00	tuesday
3644	3	2019-05-14 16:45:00	tuesday
3645	35	2019-05-07 08:15:00	tuesday
3646	20	2019-05-15 08:15:00	wednesday
3647	2	2019-05-16 13:15:00	thursday
3648	7	2019-05-20 08:00:00	monday
3649	23	2019-05-10 11:30:00	friday
3650	15	2019-05-09 16:30:00	thursday
3651	7	2019-05-30 12:45:00	thursday
3652	25	2019-05-09 11:30:00	thursday
3653	22	2019-05-17 16:00:00	friday
3654	36	2019-05-18 16:30:00	saturday
3655	37	2019-05-12 08:30:00	sunday
3656	6	2019-05-27 17:45:00	monday
3657	26	2019-05-04 12:15:00	saturday
3658	19	2019-05-20 17:15:00	monday
3659	37	2019-05-01 15:30:00	wednesday
3660	15	2019-05-16 16:45:00	thursday
3661	14	2019-05-20 12:15:00	monday
3662	32	2019-05-25 15:00:00	saturday
3663	2	2019-05-17 13:15:00	friday
3664	39	2019-05-30 09:30:00	thursday
3665	5	2019-05-25 16:00:00	saturday
3666	13	2019-05-09 12:00:00	thursday
3667	7	2019-05-28 10:00:00	tuesday
3668	8	2019-05-30 17:45:00	thursday
3669	33	2019-05-25 14:15:00	saturday
3670	37	2019-05-20 15:45:00	monday
3671	38	2019-05-10 12:30:00	friday
3672	29	2019-05-11 10:00:00	saturday
3673	28	2019-05-12 11:30:00	sunday
3674	18	2019-05-26 17:15:00	sunday
3675	2	2019-05-24 15:45:00	friday
3676	8	2019-05-05 14:30:00	sunday
3677	10	2019-05-21 10:15:00	tuesday
3678	6	2019-05-26 09:15:00	sunday
3679	22	2019-05-29 09:15:00	wednesday
3680	4	2019-05-11 09:15:00	saturday
3681	12	2019-05-13 10:45:00	monday
3682	29	2019-05-16 09:15:00	thursday
3683	3	2019-05-18 08:45:00	saturday
3684	28	2019-05-14 13:15:00	tuesday
3685	12	2019-05-20 11:15:00	monday
3686	32	2019-05-27 11:45:00	monday
3687	12	2019-05-29 17:45:00	wednesday
3688	33	2019-05-24 13:30:00	friday
3689	31	2019-05-13 09:15:00	monday
3690	26	2019-05-29 15:15:00	wednesday
3691	4	2019-05-13 16:00:00	monday
3692	15	2019-05-14 13:15:00	tuesday
3693	21	2019-05-04 08:00:00	saturday
3694	38	2019-05-29 17:30:00	wednesday
3695	21	2019-05-29 10:15:00	wednesday
3696	7	2019-05-29 16:15:00	wednesday
3697	9	2019-05-14 14:45:00	tuesday
3698	38	2019-05-07 09:30:00	tuesday
3699	18	2019-05-19 15:00:00	sunday
3700	21	2019-05-27 12:15:00	monday
3701	39	2019-05-28 12:15:00	tuesday
3702	20	2019-05-18 08:45:00	saturday
3703	37	2019-05-22 12:15:00	wednesday
3704	35	2019-05-16 09:30:00	thursday
3705	16	2019-05-25 16:00:00	saturday
3706	28	2019-05-12 09:30:00	sunday
3707	25	2019-05-16 16:15:00	thursday
3708	11	2019-05-04 13:45:00	saturday
3709	15	2019-05-20 08:45:00	monday
3710	39	2019-05-12 11:00:00	sunday
3711	16	2019-05-16 08:00:00	thursday
3712	24	2019-05-09 12:30:00	thursday
3713	15	2019-05-07 16:30:00	tuesday
3714	1	2019-06-08 12:30:00	saturday
3715	12	2019-06-05 10:00:00	wednesday
3716	5	2019-06-18 17:15:00	tuesday
3717	1	2019-06-02 13:45:00	sunday
3718	11	2019-06-23 15:15:00	sunday
3719	1	2019-06-29 17:15:00	saturday
3720	35	2019-06-26 11:30:00	wednesday
3721	34	2019-06-01 08:15:00	saturday
3722	40	2019-06-13 11:15:00	thursday
3723	25	2019-06-18 09:30:00	tuesday
3724	37	2019-06-29 08:45:00	saturday
3725	34	2019-06-19 13:15:00	wednesday
3726	2	2019-06-27 16:00:00	thursday
3727	38	2019-06-02 17:30:00	sunday
3728	15	2019-06-21 10:15:00	friday
3729	28	2019-06-30 10:15:00	sunday
3730	37	2019-06-13 17:00:00	thursday
3731	11	2019-06-10 13:00:00	monday
3732	1	2019-06-27 11:00:00	thursday
3733	19	2019-06-21 08:45:00	friday
3734	2	2019-06-14 12:45:00	friday
3735	10	2019-06-06 10:15:00	thursday
3736	24	2019-06-04 09:15:00	tuesday
3737	10	2019-06-13 12:15:00	thursday
3738	5	2019-06-22 10:15:00	saturday
3739	5	2019-06-17 10:30:00	monday
3740	5	2019-06-08 12:45:00	saturday
3741	11	2019-06-25 12:30:00	tuesday
3742	31	2019-06-08 14:30:00	saturday
3743	8	2019-06-10 10:15:00	monday
3744	19	2019-06-27 14:00:00	thursday
3745	17	2019-06-03 13:45:00	monday
3746	35	2019-06-15 14:30:00	saturday
3747	5	2019-06-14 17:45:00	friday
3748	36	2019-06-04 15:15:00	tuesday
3749	37	2019-06-11 11:45:00	tuesday
3750	12	2019-06-13 11:15:00	thursday
3751	13	2019-06-25 08:30:00	tuesday
3752	11	2019-06-26 16:15:00	wednesday
3753	27	2019-06-05 10:45:00	wednesday
3754	20	2019-06-12 10:15:00	wednesday
3755	13	2019-06-21 12:30:00	friday
3756	2	2019-06-29 08:15:00	saturday
3757	37	2019-06-22 13:30:00	saturday
3758	37	2019-06-08 12:00:00	saturday
3759	22	2019-06-03 17:00:00	monday
3760	5	2019-06-27 16:30:00	thursday
3761	13	2019-06-04 09:00:00	tuesday
3762	27	2019-06-14 14:00:00	friday
3763	10	2019-06-07 09:00:00	friday
3764	20	2019-06-03 09:00:00	monday
3765	6	2019-06-10 10:30:00	monday
3766	31	2019-06-21 17:45:00	friday
3767	5	2019-06-04 13:00:00	tuesday
3768	20	2019-06-08 15:45:00	saturday
3769	35	2019-06-29 12:45:00	saturday
3770	28	2019-06-09 17:00:00	sunday
3771	40	2019-06-05 12:00:00	wednesday
3772	21	2019-06-04 14:30:00	tuesday
3773	22	2019-06-06 09:30:00	thursday
3774	13	2019-06-19 16:15:00	wednesday
3775	7	2019-06-13 09:00:00	thursday
3776	36	2019-06-11 09:00:00	tuesday
3777	17	2019-06-23 10:00:00	sunday
3778	20	2019-06-05 12:45:00	wednesday
3779	3	2019-06-10 17:30:00	monday
3780	26	2019-06-04 14:30:00	tuesday
3781	31	2019-06-01 14:00:00	saturday
3782	28	2019-06-16 10:00:00	sunday
3783	16	2019-06-01 11:00:00	saturday
3784	2	2019-06-26 14:15:00	wednesday
3785	27	2019-06-26 11:00:00	wednesday
3786	22	2019-06-07 09:15:00	friday
3787	7	2019-06-10 10:15:00	monday
3788	22	2019-06-02 12:30:00	sunday
3789	23	2019-06-04 09:30:00	tuesday
3790	7	2019-06-23 12:30:00	sunday
3791	36	2019-06-17 17:45:00	monday
3792	25	2019-07-03 09:45:00	wednesday
3793	21	2019-07-11 15:45:00	thursday
3794	31	2019-07-07 15:00:00	sunday
3795	8	2019-07-01 08:00:00	monday
3796	29	2019-07-24 17:15:00	wednesday
3797	8	2019-07-18 15:15:00	thursday
3798	10	2019-07-30 10:00:00	tuesday
3799	39	2019-07-29 12:15:00	monday
3800	29	2019-07-19 10:30:00	friday
3801	10	2019-07-24 10:45:00	wednesday
3802	26	2019-07-22 09:45:00	monday
3803	34	2019-07-04 15:30:00	thursday
3804	28	2019-07-19 09:45:00	friday
3805	31	2019-07-28 15:45:00	sunday
3806	34	2019-07-19 14:45:00	friday
3807	5	2019-07-18 16:30:00	thursday
3808	19	2019-07-14 08:00:00	sunday
3809	40	2019-07-20 12:15:00	saturday
3810	19	2019-07-07 17:00:00	sunday
3811	17	2019-07-22 11:15:00	monday
3812	22	2019-07-19 10:00:00	friday
3813	8	2019-07-23 15:15:00	tuesday
3814	34	2019-07-14 17:30:00	sunday
3815	25	2019-07-09 10:45:00	tuesday
3816	31	2019-07-09 14:45:00	tuesday
3817	33	2019-07-21 15:30:00	sunday
3818	23	2019-07-02 15:45:00	tuesday
3819	40	2019-07-21 09:15:00	sunday
3820	16	2019-07-27 15:30:00	saturday
3821	23	2019-07-06 15:30:00	saturday
3822	38	2019-07-18 16:15:00	thursday
3823	25	2019-07-21 08:00:00	sunday
3824	28	2019-07-23 10:15:00	tuesday
3825	35	2019-07-10 09:00:00	wednesday
3826	10	2019-07-15 08:00:00	monday
3827	37	2019-07-23 11:30:00	tuesday
3828	13	2019-07-05 10:00:00	friday
3829	40	2019-07-24 13:15:00	wednesday
3830	3	2019-07-08 11:00:00	monday
3831	15	2019-07-30 10:45:00	tuesday
3832	38	2019-07-06 15:45:00	saturday
3833	32	2019-07-08 10:45:00	monday
3834	14	2019-07-02 13:45:00	tuesday
3835	10	2019-07-07 17:15:00	sunday
3836	9	2019-07-07 08:15:00	sunday
3837	7	2019-07-23 14:00:00	tuesday
3838	37	2019-07-08 09:45:00	monday
3839	40	2019-07-03 09:00:00	wednesday
3840	33	2019-07-03 15:45:00	wednesday
3841	29	2019-07-20 14:30:00	saturday
3842	1	2019-07-05 14:45:00	friday
3843	28	2019-07-10 11:00:00	wednesday
3844	17	2019-07-09 08:30:00	tuesday
3845	15	2019-07-12 09:30:00	friday
3846	7	2019-07-12 13:45:00	friday
3847	1	2019-07-20 15:00:00	saturday
3848	10	2019-07-07 09:15:00	sunday
3849	38	2019-07-05 13:15:00	friday
3850	39	2019-07-24 08:30:00	wednesday
3851	40	2019-07-03 09:45:00	wednesday
3852	16	2019-07-22 14:30:00	monday
3853	30	2019-07-25 10:00:00	thursday
3854	29	2019-07-23 09:15:00	tuesday
3855	4	2019-07-04 15:00:00	thursday
3856	29	2019-07-18 14:30:00	thursday
3857	31	2019-07-18 17:15:00	thursday
3858	19	2019-07-09 11:15:00	tuesday
3859	40	2019-07-28 15:45:00	sunday
3860	35	2019-07-14 13:30:00	sunday
3861	6	2019-07-23 17:45:00	tuesday
3862	27	2019-07-24 11:30:00	wednesday
3863	6	2019-07-16 14:15:00	tuesday
3864	29	2019-07-22 10:15:00	monday
3865	20	2019-07-02 11:00:00	tuesday
3866	9	2019-07-15 09:30:00	monday
3867	9	2019-07-22 10:45:00	monday
3868	21	2019-07-30 13:15:00	tuesday
3869	21	2019-07-28 15:00:00	sunday
3870	38	2019-07-17 16:45:00	wednesday
3871	35	2019-07-25 14:45:00	thursday
3872	38	2019-07-19 15:45:00	friday
3873	9	2019-07-18 11:00:00	thursday
3874	22	2019-07-23 08:15:00	tuesday
3875	23	2019-07-11 10:30:00	thursday
3876	26	2019-07-04 16:30:00	thursday
3877	29	2019-07-27 13:00:00	saturday
3878	26	2019-07-20 09:30:00	saturday
3879	31	2019-08-20 15:30:00	tuesday
3880	13	2019-08-11 14:45:00	sunday
3881	2	2019-08-27 09:30:00	tuesday
3882	5	2019-08-19 10:30:00	monday
3883	30	2019-08-21 09:15:00	wednesday
3884	39	2019-08-19 15:45:00	monday
3885	35	2019-08-22 17:00:00	thursday
3886	34	2019-08-29 10:30:00	thursday
3887	6	2019-08-25 09:45:00	sunday
3888	37	2019-08-28 16:30:00	wednesday
3889	3	2019-08-08 16:15:00	thursday
3890	3	2019-08-26 15:45:00	monday
3891	9	2019-08-07 08:30:00	wednesday
3892	23	2019-08-09 09:45:00	friday
3893	11	2019-08-22 09:45:00	thursday
3894	10	2019-08-09 08:15:00	friday
3895	27	2019-08-03 13:15:00	saturday
3896	34	2019-08-20 09:30:00	tuesday
3897	15	2019-08-24 17:30:00	saturday
3898	2	2019-08-19 15:15:00	monday
3899	38	2019-08-29 17:45:00	thursday
3900	23	2019-08-11 13:15:00	sunday
3901	25	2019-08-21 11:45:00	wednesday
3902	23	2019-08-20 14:00:00	tuesday
3903	28	2019-08-14 08:00:00	wednesday
3904	17	2019-08-28 11:45:00	wednesday
3905	36	2019-08-22 14:45:00	thursday
3906	17	2019-08-28 10:15:00	wednesday
3907	40	2019-08-19 10:00:00	monday
3908	34	2019-08-11 17:30:00	sunday
3909	33	2019-08-28 12:45:00	wednesday
3910	12	2019-08-17 10:00:00	saturday
3911	11	2019-08-25 12:45:00	sunday
3912	37	2019-08-09 11:30:00	friday
3913	28	2019-08-11 17:30:00	sunday
3914	2	2019-08-04 14:00:00	sunday
3915	18	2019-08-04 08:15:00	sunday
3916	37	2019-08-15 15:30:00	thursday
3917	15	2019-08-16 17:45:00	friday
3918	21	2019-08-28 08:30:00	wednesday
3919	22	2019-08-25 09:30:00	sunday
3920	11	2019-08-27 12:30:00	tuesday
3921	20	2019-08-29 15:00:00	thursday
3922	17	2019-08-05 14:00:00	monday
3923	33	2019-08-07 16:00:00	wednesday
3924	35	2019-08-25 13:30:00	sunday
3925	39	2019-08-02 12:15:00	friday
3926	7	2019-08-22 17:00:00	thursday
3927	31	2019-08-23 16:45:00	friday
3928	22	2019-08-25 09:15:00	sunday
3929	16	2019-08-05 10:15:00	monday
3930	34	2019-08-09 12:30:00	friday
3931	26	2019-08-11 10:00:00	sunday
3932	8	2019-08-14 15:15:00	wednesday
3933	28	2019-08-09 09:45:00	friday
3934	37	2019-08-03 14:00:00	saturday
3935	35	2019-08-29 09:45:00	thursday
3936	3	2019-08-21 12:45:00	wednesday
3937	20	2019-08-23 10:15:00	friday
3938	2	2019-08-12 11:15:00	monday
3939	23	2019-08-17 08:45:00	saturday
3940	9	2019-08-16 13:45:00	friday
3941	12	2019-08-10 13:15:00	saturday
3942	20	2019-08-05 13:15:00	monday
3943	6	2019-08-12 08:45:00	monday
3944	4	2019-08-22 17:00:00	thursday
3945	20	2019-08-07 12:30:00	wednesday
3946	13	2019-08-12 10:15:00	monday
3947	5	2019-08-10 15:00:00	saturday
3948	17	2019-08-30 12:15:00	friday
3949	33	2019-08-16 12:00:00	friday
3950	7	2019-08-04 13:45:00	sunday
3951	37	2019-08-11 10:45:00	sunday
3952	8	2019-08-28 08:30:00	wednesday
3953	20	2019-08-08 15:30:00	thursday
3954	29	2019-08-13 13:30:00	tuesday
3955	16	2019-08-03 08:45:00	saturday
3956	36	2019-08-19 08:45:00	monday
3957	8	2019-08-17 10:00:00	saturday
3958	2	2019-08-24 10:45:00	saturday
3959	17	2019-08-13 08:30:00	tuesday
3960	40	2019-08-20 13:15:00	tuesday
3961	24	2019-09-18 13:30:00	wednesday
3962	17	2019-09-01 14:30:00	sunday
3963	36	2019-09-12 11:00:00	thursday
3964	23	2019-09-25 14:15:00	wednesday
3965	22	2019-09-02 14:00:00	monday
3966	26	2019-09-01 13:45:00	sunday
3967	33	2019-09-14 14:30:00	saturday
3968	35	2019-09-02 10:30:00	monday
3969	4	2019-09-27 10:15:00	friday
3970	26	2019-09-10 08:30:00	tuesday
3971	37	2019-09-12 16:45:00	thursday
3972	29	2019-09-15 17:45:00	sunday
3973	21	2019-09-27 15:30:00	friday
3974	11	2019-09-25 15:00:00	wednesday
3975	40	2019-09-12 16:15:00	thursday
3976	18	2019-09-16 08:00:00	monday
3977	3	2019-09-10 11:45:00	tuesday
3978	38	2019-09-22 12:15:00	sunday
3979	6	2019-09-11 16:00:00	wednesday
3980	11	2019-09-26 13:00:00	thursday
3981	26	2019-09-19 15:00:00	thursday
3982	23	2019-09-06 12:00:00	friday
3983	26	2019-09-12 17:45:00	thursday
3984	35	2019-09-08 17:15:00	sunday
3985	35	2019-09-06 16:00:00	friday
3986	33	2019-09-01 08:30:00	sunday
3987	21	2019-09-22 09:30:00	sunday
3988	28	2019-09-04 09:30:00	wednesday
3989	17	2019-09-18 16:45:00	wednesday
3990	4	2019-09-20 17:00:00	friday
3991	26	2019-09-01 12:45:00	sunday
3992	25	2019-09-10 10:00:00	tuesday
3993	22	2019-09-08 12:15:00	sunday
3994	21	2019-09-19 11:45:00	thursday
3995	12	2019-09-23 11:00:00	monday
3996	21	2019-09-29 17:30:00	sunday
3997	30	2019-09-03 09:45:00	tuesday
3998	14	2019-09-09 14:45:00	monday
3999	38	2019-09-18 13:30:00	wednesday
4000	17	2019-09-06 14:45:00	friday
4001	10	2019-09-17 13:45:00	tuesday
4002	33	2019-09-22 08:15:00	sunday
4003	25	2019-09-11 17:30:00	wednesday
4004	9	2019-09-15 17:00:00	sunday
4005	5	2019-09-06 11:15:00	friday
4006	8	2019-09-03 11:15:00	tuesday
4007	40	2019-09-20 08:30:00	friday
4008	6	2019-09-08 11:45:00	sunday
4009	1	2019-09-30 11:45:00	monday
4010	38	2019-09-04 15:15:00	wednesday
4011	6	2019-09-10 14:00:00	tuesday
4012	4	2019-09-10 09:45:00	tuesday
4013	1	2019-09-02 16:45:00	monday
4014	6	2019-09-09 13:00:00	monday
4015	29	2019-09-15 10:00:00	sunday
4016	13	2019-09-24 17:00:00	tuesday
4017	40	2019-09-02 15:15:00	monday
4018	26	2019-09-15 10:15:00	sunday
4019	32	2019-09-09 10:15:00	monday
4020	19	2019-09-24 17:00:00	tuesday
4021	32	2019-09-29 08:45:00	sunday
4022	29	2019-09-11 15:45:00	wednesday
4023	18	2019-09-13 17:15:00	friday
4024	33	2019-09-16 17:30:00	monday
4025	35	2019-09-29 15:00:00	sunday
4026	17	2019-09-22 08:30:00	sunday
4027	12	2019-09-20 11:00:00	friday
4028	25	2019-09-03 17:15:00	tuesday
4029	4	2019-09-26 08:00:00	thursday
4030	32	2019-09-18 11:30:00	wednesday
4031	1	2019-09-09 09:30:00	monday
4032	6	2019-09-22 14:45:00	sunday
4033	6	2019-09-06 08:00:00	friday
4034	38	2019-09-07 12:00:00	saturday
4035	28	2019-09-02 09:30:00	monday
4036	19	2019-09-04 16:30:00	wednesday
4037	3	2019-09-08 08:30:00	sunday
4038	4	2019-09-02 08:30:00	monday
4039	7	2019-09-20 15:30:00	friday
4040	25	2019-09-04 17:15:00	wednesday
4041	21	2019-09-15 15:45:00	sunday
4042	13	2019-09-23 08:15:00	monday
4043	37	2019-09-30 15:15:00	monday
4044	4	2019-09-20 09:30:00	friday
4045	31	2019-09-22 14:45:00	sunday
4046	4	2019-09-12 13:00:00	thursday
4047	8	2019-09-17 13:45:00	tuesday
4048	21	2019-09-11 14:45:00	wednesday
4049	20	2019-09-25 10:00:00	wednesday
4050	34	2019-10-07 15:00:00	monday
4051	10	2019-10-03 12:00:00	thursday
4052	40	2019-10-21 15:30:00	monday
4053	29	2019-10-15 17:15:00	tuesday
4054	20	2019-10-16 16:30:00	wednesday
4055	39	2019-10-26 09:45:00	saturday
4056	7	2019-10-03 15:45:00	thursday
4057	6	2019-10-24 17:00:00	thursday
4058	35	2019-10-29 16:30:00	tuesday
4059	9	2019-10-14 14:30:00	monday
4060	28	2019-10-26 14:30:00	saturday
4061	17	2019-10-30 12:30:00	wednesday
4062	9	2019-10-04 16:15:00	friday
4063	2	2019-10-22 09:45:00	tuesday
4064	10	2019-10-15 13:15:00	tuesday
4065	1	2019-10-25 10:45:00	friday
4066	33	2019-10-08 13:45:00	tuesday
4067	21	2019-10-28 17:15:00	monday
4068	35	2019-10-07 10:15:00	monday
4069	15	2019-10-22 09:30:00	tuesday
4070	14	2019-10-02 13:00:00	wednesday
4071	12	2019-10-06 15:45:00	sunday
4072	18	2019-10-15 17:00:00	tuesday
4073	31	2019-10-22 12:00:00	tuesday
4074	18	2019-10-23 08:00:00	wednesday
4075	33	2019-10-22 12:30:00	tuesday
4076	10	2019-10-26 12:15:00	saturday
4077	35	2019-10-24 16:00:00	thursday
4078	31	2019-10-01 13:15:00	tuesday
4079	24	2019-10-23 17:00:00	wednesday
4080	20	2019-10-12 17:45:00	saturday
4081	22	2019-10-02 12:30:00	wednesday
4082	17	2019-10-24 08:00:00	thursday
4083	19	2019-10-02 16:00:00	wednesday
4084	36	2019-10-06 12:45:00	sunday
4085	1	2019-10-29 11:30:00	tuesday
4086	25	2019-10-24 08:30:00	thursday
4087	4	2019-10-21 12:00:00	monday
4088	27	2019-10-30 13:45:00	wednesday
4089	40	2019-10-29 08:45:00	tuesday
4090	27	2019-10-05 14:00:00	saturday
4091	13	2019-10-24 11:45:00	thursday
4092	37	2019-10-07 17:45:00	monday
4093	29	2019-10-16 13:30:00	wednesday
4094	24	2019-10-01 08:30:00	tuesday
4095	26	2019-10-06 10:30:00	sunday
4096	12	2019-10-23 11:45:00	wednesday
4097	2	2019-10-26 08:45:00	saturday
4098	35	2019-10-12 14:00:00	saturday
4099	5	2019-10-15 09:15:00	tuesday
4100	26	2019-10-20 10:30:00	sunday
4101	19	2019-10-26 15:00:00	saturday
4102	23	2019-10-16 09:30:00	wednesday
4103	31	2019-10-05 15:30:00	saturday
4104	18	2019-10-05 13:45:00	saturday
4105	16	2019-10-26 11:45:00	saturday
4106	29	2019-10-17 10:30:00	thursday
4107	5	2019-10-01 10:45:00	tuesday
4108	38	2019-10-27 17:30:00	sunday
4109	30	2019-10-15 13:00:00	tuesday
4110	34	2019-10-11 16:45:00	friday
4111	16	2019-10-30 12:00:00	wednesday
4112	33	2019-10-25 09:45:00	friday
4113	22	2019-10-20 15:30:00	sunday
4114	22	2019-10-08 13:45:00	tuesday
4115	18	2019-10-02 11:15:00	wednesday
4116	38	2019-10-22 11:30:00	tuesday
4117	20	2019-10-12 13:00:00	saturday
4118	37	2019-10-24 14:00:00	thursday
4119	23	2019-10-03 13:00:00	thursday
4120	30	2019-10-30 12:00:00	wednesday
4121	32	2019-10-13 16:15:00	sunday
4122	2	2019-10-19 10:15:00	saturday
4123	24	2019-10-13 11:00:00	sunday
4124	29	2019-10-13 14:15:00	sunday
4125	7	2019-10-27 14:15:00	sunday
4126	37	2019-10-08 09:15:00	tuesday
4127	17	2019-10-16 08:45:00	wednesday
4128	4	2019-10-22 11:45:00	tuesday
4129	26	2019-10-08 15:00:00	tuesday
4130	35	2019-10-05 10:00:00	saturday
4131	35	2019-10-14 16:00:00	monday
4132	15	2019-11-30 14:45:00	saturday
4133	36	2019-11-22 13:45:00	friday
4134	22	2019-11-12 11:00:00	tuesday
4135	25	2019-11-01 15:45:00	friday
4136	16	2019-11-05 10:30:00	tuesday
4137	40	2019-11-30 13:00:00	saturday
4138	16	2019-11-01 15:00:00	friday
4139	15	2019-11-02 08:00:00	saturday
4140	17	2019-11-07 16:15:00	thursday
4141	23	2019-11-22 16:30:00	friday
4142	3	2019-11-12 12:30:00	tuesday
4143	37	2019-11-09 12:45:00	saturday
4144	5	2019-11-14 13:30:00	thursday
4145	14	2019-11-24 12:00:00	sunday
4146	26	2019-11-21 13:00:00	thursday
4147	39	2019-11-14 08:45:00	thursday
4148	6	2019-11-12 17:15:00	tuesday
4149	37	2019-11-19 13:15:00	tuesday
4150	32	2019-11-25 10:45:00	monday
4151	32	2019-11-04 15:00:00	monday
4152	7	2019-11-12 17:15:00	tuesday
4153	7	2019-11-15 16:15:00	friday
4154	15	2019-11-30 17:15:00	saturday
4155	33	2019-11-17 10:15:00	sunday
4156	35	2019-11-29 12:30:00	friday
4157	8	2019-11-17 12:30:00	sunday
4158	34	2019-11-07 15:30:00	thursday
4159	38	2019-11-02 14:45:00	saturday
4160	11	2019-11-03 15:30:00	sunday
4161	24	2019-11-29 08:00:00	friday
4162	10	2019-11-14 08:00:00	thursday
4163	40	2019-11-28 16:30:00	thursday
4164	19	2019-11-13 15:30:00	wednesday
4165	36	2019-11-15 10:45:00	friday
4166	36	2019-11-11 16:30:00	monday
4167	2	2019-11-24 12:30:00	sunday
4168	21	2019-11-13 14:00:00	wednesday
4169	6	2019-11-05 16:45:00	tuesday
4170	16	2019-11-08 13:45:00	friday
4171	15	2019-11-02 17:30:00	saturday
4172	18	2019-11-24 08:15:00	sunday
4173	39	2019-11-24 12:15:00	sunday
4174	26	2019-11-25 08:00:00	monday
4175	1	2019-11-17 12:00:00	sunday
4176	31	2019-11-10 10:15:00	sunday
4177	11	2019-11-09 11:00:00	saturday
4178	28	2019-11-18 14:30:00	monday
4179	28	2019-11-16 08:30:00	saturday
4180	29	2019-11-23 17:00:00	saturday
4181	4	2019-11-19 12:00:00	tuesday
4182	25	2019-11-16 17:45:00	saturday
4183	8	2019-11-10 09:15:00	sunday
4184	31	2019-11-05 09:00:00	tuesday
4185	28	2019-11-06 10:15:00	wednesday
4186	11	2019-11-29 13:15:00	friday
4187	9	2019-11-09 15:00:00	saturday
4188	8	2019-11-08 10:45:00	friday
4189	31	2019-11-21 12:45:00	thursday
4190	12	2019-11-16 17:30:00	saturday
4191	17	2019-11-21 12:45:00	thursday
4192	1	2019-11-02 12:00:00	saturday
4193	5	2019-11-08 14:30:00	friday
4194	32	2019-11-29 11:00:00	friday
4195	3	2019-11-22 14:45:00	friday
4196	37	2019-11-26 11:45:00	tuesday
4197	19	2019-11-27 09:15:00	wednesday
4198	40	2019-11-13 13:15:00	wednesday
4199	17	2019-11-09 10:30:00	saturday
4200	40	2019-11-05 08:30:00	tuesday
4201	26	2019-11-08 08:00:00	friday
4202	7	2019-11-26 16:30:00	tuesday
4203	14	2019-11-24 08:15:00	sunday
4204	26	2019-11-05 11:30:00	tuesday
4205	22	2019-11-18 11:00:00	monday
4206	16	2019-11-29 08:45:00	friday
4207	20	2019-11-23 15:15:00	saturday
4208	24	2019-11-09 11:15:00	saturday
4209	23	2019-11-14 15:15:00	thursday
4210	37	2019-11-28 15:00:00	thursday
4211	14	2019-11-04 08:45:00	monday
4212	35	2019-11-14 16:15:00	thursday
4213	34	2019-11-17 16:15:00	sunday
4214	40	2019-11-26 09:00:00	tuesday
4215	14	2019-11-14 17:00:00	thursday
4216	22	2019-11-28 12:30:00	thursday
4217	40	2019-11-18 10:15:00	monday
4218	13	2019-11-07 11:15:00	thursday
4219	15	2019-11-27 08:30:00	wednesday
4220	35	2019-11-12 13:45:00	tuesday
4221	28	2019-11-21 09:30:00	thursday
4222	29	2019-11-22 14:15:00	friday
4223	3	2019-11-17 15:45:00	sunday
4224	5	2019-11-19 15:30:00	tuesday
4225	1	2019-12-19 14:45:00	thursday
4226	20	2019-12-25 16:45:00	wednesday
4227	21	2019-12-28 08:00:00	saturday
4228	30	2019-12-19 17:00:00	thursday
4229	24	2019-12-14 17:30:00	saturday
4230	11	2019-12-23 17:00:00	monday
4231	7	2019-12-05 12:45:00	thursday
4232	33	2019-12-26 12:45:00	thursday
4233	5	2019-12-20 08:00:00	friday
4234	37	2019-12-22 17:45:00	sunday
4235	27	2019-12-15 09:45:00	sunday
4236	33	2019-12-05 16:00:00	thursday
4237	18	2019-12-03 14:45:00	tuesday
4238	12	2019-12-05 11:45:00	thursday
4239	13	2019-12-26 12:45:00	thursday
4240	7	2019-12-13 11:30:00	friday
4241	34	2019-12-18 10:00:00	wednesday
4242	12	2019-12-08 12:15:00	sunday
4243	39	2019-12-11 15:00:00	wednesday
4244	23	2019-12-14 11:00:00	saturday
4245	38	2019-12-12 12:30:00	thursday
4246	30	2019-12-08 13:00:00	sunday
4247	3	2019-12-26 13:15:00	thursday
4248	11	2019-12-20 14:15:00	friday
4249	18	2019-12-30 15:30:00	monday
4250	22	2019-12-29 16:45:00	sunday
4251	4	2019-12-06 16:30:00	friday
4252	37	2019-12-19 16:15:00	thursday
4253	40	2019-12-04 08:15:00	wednesday
4254	13	2019-12-10 09:00:00	tuesday
4255	19	2019-12-15 16:00:00	sunday
4256	23	2019-12-03 09:30:00	tuesday
4257	27	2019-12-05 16:00:00	thursday
4258	6	2019-12-09 13:00:00	monday
4259	21	2019-12-19 11:45:00	thursday
4260	38	2019-12-05 15:45:00	thursday
4261	20	2019-12-01 08:30:00	sunday
4262	12	2019-12-15 15:15:00	sunday
4263	27	2019-12-27 13:00:00	friday
4264	18	2019-12-08 11:45:00	sunday
4265	31	2019-12-10 14:30:00	tuesday
4266	17	2019-12-01 16:00:00	sunday
4267	39	2019-12-10 17:45:00	tuesday
4268	6	2019-12-05 12:30:00	thursday
4269	6	2019-12-06 11:15:00	friday
4270	7	2019-12-08 14:45:00	sunday
4271	5	2019-12-07 10:00:00	saturday
4272	21	2019-12-03 13:00:00	tuesday
4273	11	2019-12-05 10:30:00	thursday
4274	18	2019-12-07 14:30:00	saturday
4275	15	2019-12-28 12:00:00	saturday
4276	10	2019-12-28 15:15:00	saturday
4277	17	2019-12-06 12:30:00	friday
4278	19	2019-12-13 09:30:00	friday
4279	6	2019-12-18 08:15:00	wednesday
4280	6	2019-12-12 08:15:00	thursday
4281	27	2019-12-28 13:45:00	saturday
4282	29	2019-12-28 13:00:00	saturday
4283	15	2019-12-10 14:00:00	tuesday
4284	37	2019-12-22 10:30:00	sunday
4285	11	2019-12-26 15:15:00	thursday
4286	11	2019-12-17 15:00:00	tuesday
4287	26	2019-12-17 14:00:00	tuesday
4288	24	2019-12-19 12:15:00	thursday
4289	27	2019-12-04 14:45:00	wednesday
4290	7	2019-12-24 14:45:00	tuesday
4291	12	2019-12-21 13:45:00	saturday
4292	35	2019-12-11 14:15:00	wednesday
4293	14	2019-12-07 12:15:00	saturday
4294	36	2019-12-18 12:15:00	wednesday
4295	21	2019-12-08 08:15:00	sunday
4296	32	2019-12-13 15:45:00	friday
4297	7	2019-12-24 14:30:00	tuesday
4298	35	2019-12-18 17:30:00	wednesday
4299	2	2019-12-24 12:45:00	tuesday
4300	1	2019-12-27 16:45:00	friday
4301	14	2020-01-18 10:15:00	saturday
4302	37	2020-01-30 17:30:00	thursday
4303	38	2020-01-23 09:30:00	thursday
4304	29	2020-01-23 12:00:00	thursday
4305	37	2020-01-24 12:15:00	friday
4306	21	2020-01-06 12:15:00	monday
4307	28	2020-01-04 15:15:00	saturday
4308	26	2020-01-16 14:00:00	thursday
4309	36	2020-01-07 16:45:00	tuesday
4310	27	2020-01-01 11:30:00	wednesday
4311	34	2020-01-20 08:00:00	monday
4312	35	2020-01-02 13:45:00	thursday
4313	37	2020-01-20 13:45:00	monday
4314	19	2020-01-04 09:15:00	saturday
4315	36	2020-01-01 17:45:00	wednesday
4316	34	2020-01-01 09:00:00	wednesday
4317	9	2020-01-29 15:00:00	wednesday
4318	23	2020-01-05 08:00:00	sunday
4319	2	2020-01-02 11:00:00	thursday
4320	26	2020-01-18 15:30:00	saturday
4321	21	2020-01-05 12:15:00	sunday
4322	8	2020-01-01 09:15:00	wednesday
4323	9	2020-01-08 12:15:00	wednesday
4324	30	2020-01-14 16:00:00	tuesday
4325	1	2020-01-07 08:00:00	tuesday
4326	19	2020-01-29 15:45:00	wednesday
4327	1	2020-01-13 14:00:00	monday
4328	40	2020-01-08 10:45:00	wednesday
4329	1	2020-01-12 10:45:00	sunday
4330	40	2020-01-28 16:30:00	tuesday
4331	31	2020-01-15 08:30:00	wednesday
4332	26	2020-01-30 14:15:00	thursday
4333	23	2020-01-17 17:15:00	friday
4334	4	2020-01-10 12:45:00	friday
4335	28	2020-01-21 10:45:00	tuesday
4336	31	2020-01-27 11:45:00	monday
4337	37	2020-01-21 11:45:00	tuesday
4338	31	2020-01-05 15:45:00	sunday
4339	35	2020-01-30 09:15:00	thursday
4340	2	2020-01-10 10:15:00	friday
4341	39	2020-01-08 10:45:00	wednesday
4342	38	2020-01-07 13:00:00	tuesday
4343	22	2020-01-09 12:30:00	thursday
4344	20	2020-01-14 15:00:00	tuesday
4345	30	2020-01-27 09:00:00	monday
4346	1	2020-01-19 09:30:00	sunday
4347	40	2020-01-13 14:30:00	monday
4348	10	2020-01-17 12:15:00	friday
4349	30	2020-01-19 13:30:00	sunday
4350	29	2020-01-13 13:30:00	monday
4351	27	2020-02-07 17:00:00	friday
4352	36	2020-02-20 14:15:00	thursday
4353	24	2020-02-13 09:45:00	thursday
4354	26	2020-02-10 16:00:00	monday
4355	27	2020-02-07 17:30:00	friday
4356	5	2020-02-01 16:00:00	saturday
4357	23	2020-02-10 13:15:00	monday
4358	20	2020-02-15 14:15:00	saturday
4359	16	2020-02-18 09:30:00	tuesday
4360	17	2020-02-08 08:15:00	saturday
4361	21	2020-02-09 16:45:00	sunday
4362	22	2020-02-15 08:15:00	saturday
4363	39	2020-02-02 11:45:00	sunday
4364	1	2020-02-21 10:30:00	friday
4365	14	2020-02-02 09:15:00	sunday
4366	25	2020-02-28 16:00:00	friday
4367	32	2020-02-18 10:45:00	tuesday
4368	16	2020-02-25 10:30:00	tuesday
4369	11	2020-02-07 14:15:00	friday
4370	24	2020-02-26 17:15:00	wednesday
4371	8	2020-02-19 13:45:00	wednesday
4372	40	2020-02-08 15:00:00	saturday
4373	24	2020-02-22 16:00:00	saturday
4374	15	2020-02-17 14:30:00	monday
4375	40	2020-02-26 10:30:00	wednesday
4376	13	2020-02-02 14:30:00	sunday
4377	6	2020-02-25 09:30:00	tuesday
4378	38	2020-02-14 12:30:00	friday
4379	19	2020-02-15 09:00:00	saturday
4380	40	2020-02-21 16:15:00	friday
4381	24	2020-02-16 10:15:00	sunday
4382	9	2020-02-01 08:15:00	saturday
4383	19	2020-02-02 16:15:00	sunday
4384	20	2020-02-12 13:45:00	wednesday
4385	17	2020-02-24 15:00:00	monday
4386	2	2020-02-16 10:15:00	sunday
4387	35	2020-02-20 10:45:00	thursday
4388	3	2020-02-28 15:00:00	friday
4389	27	2020-02-22 11:15:00	saturday
4390	13	2020-02-13 12:15:00	thursday
4391	29	2020-02-10 13:30:00	monday
4392	16	2020-02-14 15:45:00	friday
4393	40	2020-02-17 16:45:00	monday
4394	10	2020-02-11 09:30:00	tuesday
4395	21	2020-02-15 16:30:00	saturday
4396	6	2020-02-27 10:00:00	thursday
4397	36	2020-02-02 15:00:00	sunday
4398	13	2020-03-29 15:45:00	sunday
4399	27	2020-03-08 10:15:00	sunday
4400	23	2020-03-19 10:15:00	thursday
4401	32	2020-03-23 14:45:00	monday
4402	16	2020-03-21 17:00:00	saturday
4403	4	2020-03-27 08:30:00	friday
4404	13	2020-03-17 10:45:00	tuesday
4405	16	2020-03-30 16:00:00	monday
4406	14	2020-03-24 10:45:00	tuesday
4407	16	2020-03-16 14:45:00	monday
4408	20	2020-03-23 13:45:00	monday
4409	12	2020-03-29 16:30:00	sunday
4410	33	2020-03-22 09:15:00	sunday
4411	4	2020-03-26 10:15:00	thursday
4412	28	2020-03-17 09:45:00	tuesday
4413	1	2020-03-21 14:30:00	saturday
4414	4	2020-03-28 16:15:00	saturday
4415	1	2020-03-21 13:45:00	saturday
4416	18	2020-03-21 09:30:00	saturday
4417	1	2020-03-19 09:15:00	thursday
4418	17	2020-03-19 08:15:00	thursday
4419	18	2020-03-10 17:30:00	tuesday
4420	39	2020-03-04 11:30:00	wednesday
4421	38	2020-03-18 12:30:00	wednesday
4422	27	2020-03-04 16:30:00	wednesday
4423	9	2020-03-11 17:00:00	wednesday
4424	30	2020-03-07 08:45:00	saturday
4425	18	2020-03-03 16:00:00	tuesday
4426	4	2020-03-09 12:15:00	monday
4427	17	2020-03-25 10:30:00	wednesday
4428	2	2020-03-23 11:00:00	monday
4429	32	2020-03-09 10:00:00	monday
4430	23	2020-03-18 09:00:00	wednesday
4431	28	2020-03-16 12:00:00	monday
4432	37	2020-03-03 14:45:00	tuesday
4433	35	2020-03-27 13:00:00	friday
4434	14	2020-03-14 15:30:00	saturday
4435	38	2020-03-15 15:00:00	sunday
4436	33	2020-03-15 08:45:00	sunday
4437	38	2020-03-02 15:45:00	monday
4438	12	2020-03-17 10:45:00	tuesday
4439	23	2020-03-22 09:45:00	sunday
4440	25	2020-03-14 08:30:00	saturday
4441	1	2020-03-06 12:30:00	friday
4442	27	2020-03-20 11:45:00	friday
4443	12	2020-03-12 13:15:00	thursday
4444	39	2020-03-05 12:00:00	thursday
4445	9	2020-03-19 12:30:00	thursday
4446	14	2020-03-29 08:15:00	sunday
4447	22	2020-03-18 15:00:00	wednesday
4448	39	2020-03-16 08:15:00	monday
4449	8	2020-03-01 09:00:00	sunday
4450	39	2020-03-26 17:45:00	thursday
4451	23	2020-03-28 12:45:00	saturday
4452	18	2020-03-29 09:15:00	sunday
4453	23	2020-04-25 13:45:00	saturday
4454	16	2020-04-16 14:15:00	thursday
4455	35	2020-04-18 11:45:00	saturday
4456	35	2020-04-23 11:45:00	thursday
4457	10	2020-04-02 17:45:00	thursday
4458	21	2020-04-25 16:15:00	saturday
4459	20	2020-04-04 16:30:00	saturday
4460	36	2020-04-01 08:00:00	wednesday
4461	11	2020-04-18 12:15:00	saturday
4462	16	2020-04-07 13:45:00	tuesday
4463	12	2020-04-08 09:30:00	wednesday
4464	1	2020-04-20 11:00:00	monday
4465	5	2020-04-18 17:45:00	saturday
4466	3	2020-04-30 10:00:00	thursday
4467	30	2020-04-09 12:45:00	thursday
4468	35	2020-04-10 17:30:00	friday
4469	34	2020-04-10 08:30:00	friday
4470	16	2020-04-29 11:00:00	wednesday
4471	29	2020-04-28 17:00:00	tuesday
4472	37	2020-04-12 10:30:00	sunday
4473	5	2020-04-11 14:30:00	saturday
4474	19	2020-04-03 17:45:00	friday
4475	26	2020-04-17 13:00:00	friday
4476	33	2020-04-02 09:45:00	thursday
4477	15	2020-04-18 08:45:00	saturday
4478	6	2020-04-19 13:00:00	sunday
4479	9	2020-04-22 13:00:00	wednesday
4480	2	2020-04-10 13:30:00	friday
4481	13	2020-04-23 10:00:00	thursday
4482	18	2020-04-17 14:30:00	friday
4483	11	2020-04-07 10:15:00	tuesday
4484	3	2020-04-18 15:30:00	saturday
4485	15	2020-04-16 15:15:00	thursday
4486	20	2020-04-08 09:45:00	wednesday
4487	20	2020-04-23 17:30:00	thursday
4488	38	2020-04-29 08:30:00	wednesday
4489	17	2020-04-02 09:15:00	thursday
4490	37	2020-04-26 09:30:00	sunday
4491	6	2020-04-07 11:45:00	tuesday
4492	5	2020-04-16 16:15:00	thursday
4493	21	2020-04-17 15:00:00	friday
4494	39	2020-05-01 15:00:00	friday
4495	35	2020-05-07 09:15:00	thursday
4496	20	2020-05-30 16:30:00	saturday
4497	5	2020-05-25 11:30:00	monday
4498	6	2020-05-03 16:30:00	sunday
4499	22	2020-05-14 14:15:00	thursday
4500	3	2020-05-23 11:45:00	saturday
4501	21	2020-05-29 14:00:00	friday
4502	11	2020-05-03 14:45:00	sunday
4503	17	2020-05-23 12:30:00	saturday
4504	23	2020-05-24 08:00:00	sunday
4505	31	2020-05-06 14:00:00	wednesday
4506	18	2020-05-06 12:00:00	wednesday
4507	39	2020-05-02 08:30:00	saturday
4508	17	2020-05-17 15:30:00	sunday
4509	20	2020-05-12 11:30:00	tuesday
4510	36	2020-05-16 10:45:00	saturday
4511	18	2020-05-22 10:45:00	friday
4512	4	2020-05-10 14:00:00	sunday
4513	24	2020-05-02 08:15:00	saturday
4514	29	2020-05-14 14:15:00	thursday
4515	30	2020-05-16 10:15:00	saturday
4516	27	2020-05-15 11:15:00	friday
4517	21	2020-05-16 11:45:00	saturday
4518	6	2020-05-30 10:15:00	saturday
4519	27	2020-05-02 10:30:00	saturday
4520	32	2020-05-23 10:45:00	saturday
4521	30	2020-05-11 08:30:00	monday
4522	11	2020-05-16 08:15:00	saturday
4523	30	2020-05-30 15:45:00	saturday
4524	37	2020-05-26 14:00:00	tuesday
4525	13	2020-05-21 12:15:00	thursday
4526	37	2020-05-22 09:45:00	friday
4527	16	2020-05-16 15:00:00	saturday
4528	29	2020-05-19 16:30:00	tuesday
4529	28	2020-05-17 08:15:00	sunday
4530	31	2020-05-11 10:45:00	monday
4531	3	2020-05-20 13:45:00	wednesday
4532	10	2020-05-15 11:45:00	friday
4533	31	2020-05-15 12:15:00	friday
4534	5	2020-05-05 08:15:00	tuesday
4535	27	2020-05-25 17:45:00	monday
4536	24	2020-05-17 09:45:00	sunday
4537	7	2020-05-25 11:00:00	monday
4538	39	2020-05-22 11:15:00	friday
4539	26	2020-06-02 14:45:00	tuesday
4540	32	2020-06-07 12:30:00	sunday
4541	7	2020-06-02 17:00:00	tuesday
4542	9	2020-06-20 10:30:00	saturday
4543	18	2020-06-15 15:00:00	monday
4544	29	2020-06-27 08:45:00	saturday
4545	34	2020-06-05 14:30:00	friday
4546	6	2020-06-04 15:45:00	thursday
4547	22	2020-06-16 15:45:00	tuesday
4548	17	2020-06-23 16:00:00	tuesday
4549	10	2020-06-26 15:30:00	friday
4550	31	2020-06-25 16:15:00	thursday
4551	25	2020-06-02 15:30:00	tuesday
4552	32	2020-06-02 15:45:00	tuesday
4553	18	2020-06-08 13:15:00	monday
4554	15	2020-06-16 11:00:00	tuesday
4555	28	2020-06-06 13:30:00	saturday
4556	11	2020-06-06 12:30:00	saturday
4557	3	2020-06-18 12:15:00	thursday
4558	25	2020-06-07 12:00:00	sunday
4559	3	2020-06-24 09:00:00	wednesday
4560	12	2020-06-20 08:15:00	saturday
4561	33	2020-06-24 09:00:00	wednesday
4562	39	2020-06-17 10:45:00	wednesday
4563	23	2020-06-06 14:00:00	saturday
4564	24	2020-06-05 17:45:00	friday
4565	15	2020-06-18 09:00:00	thursday
4566	21	2020-06-11 16:00:00	thursday
4567	20	2020-06-25 11:45:00	thursday
4568	23	2020-06-26 15:30:00	friday
4569	14	2020-06-01 16:00:00	monday
4570	27	2020-06-20 13:45:00	saturday
4571	12	2020-06-30 14:30:00	tuesday
4572	29	2020-06-19 15:15:00	friday
4573	1	2020-06-15 17:45:00	monday
4574	29	2020-06-06 10:45:00	saturday
4575	25	2020-06-26 13:45:00	friday
4576	4	2020-06-09 15:15:00	tuesday
4577	19	2020-06-03 16:30:00	wednesday
4578	29	2020-06-08 17:15:00	monday
4579	38	2020-06-02 08:45:00	tuesday
4580	38	2020-06-07 10:45:00	sunday
4581	21	2020-06-09 10:15:00	tuesday
4582	14	2020-06-26 16:15:00	friday
4583	13	2020-06-28 09:45:00	sunday
4584	30	2020-06-12 09:30:00	friday
4585	4	2020-06-01 09:30:00	monday
4586	2	2020-06-08 17:15:00	monday
4587	17	2020-06-28 09:00:00	sunday
4588	31	2020-07-26 14:15:00	sunday
4589	16	2020-07-24 12:15:00	friday
4590	12	2020-07-07 08:30:00	tuesday
4591	37	2020-07-13 14:45:00	monday
4592	19	2020-07-18 15:30:00	saturday
4593	21	2020-07-09 09:15:00	thursday
4594	30	2020-07-02 13:30:00	thursday
4595	26	2020-07-24 13:30:00	friday
4596	28	2020-07-30 17:45:00	thursday
4597	29	2020-07-29 13:15:00	wednesday
4598	27	2020-07-30 14:45:00	thursday
4599	4	2020-07-06 09:45:00	monday
4600	13	2020-07-26 08:15:00	sunday
4601	11	2020-07-24 14:15:00	friday
4602	21	2020-07-23 09:45:00	thursday
4603	20	2020-07-11 11:45:00	saturday
4604	9	2020-07-08 14:15:00	wednesday
4605	17	2020-07-20 15:00:00	monday
4606	39	2020-07-16 09:00:00	thursday
4607	14	2020-07-08 13:15:00	wednesday
4608	17	2020-07-21 14:00:00	tuesday
4609	10	2020-07-03 17:15:00	friday
4610	19	2020-07-27 13:30:00	monday
4611	28	2020-07-21 16:30:00	tuesday
4612	9	2020-07-22 11:30:00	wednesday
4613	31	2020-07-30 10:45:00	thursday
4614	20	2020-07-16 09:00:00	thursday
4615	24	2020-07-03 12:15:00	friday
4616	11	2020-07-10 17:45:00	friday
4617	28	2020-07-30 13:15:00	thursday
4618	12	2020-07-19 17:15:00	sunday
4619	5	2020-07-05 08:30:00	sunday
4620	26	2020-07-07 15:00:00	tuesday
4621	4	2020-07-08 13:00:00	wednesday
4622	13	2020-07-29 10:45:00	wednesday
4623	5	2020-07-04 10:45:00	saturday
4624	31	2020-07-26 16:15:00	sunday
4625	40	2020-07-18 13:45:00	saturday
4626	27	2020-07-09 11:15:00	thursday
4627	11	2020-07-01 14:30:00	wednesday
4628	30	2020-08-09 10:15:00	sunday
4629	34	2020-08-30 14:45:00	sunday
4630	16	2020-08-08 13:45:00	saturday
4631	10	2020-08-17 13:30:00	monday
4632	9	2020-08-20 09:45:00	thursday
4633	23	2020-08-12 11:15:00	wednesday
4634	22	2020-08-10 17:15:00	monday
4635	19	2020-08-26 10:15:00	wednesday
4636	11	2020-08-13 16:30:00	thursday
4637	8	2020-08-02 10:00:00	sunday
4638	39	2020-08-08 08:00:00	saturday
4639	26	2020-08-15 10:00:00	saturday
4640	13	2020-08-19 09:30:00	wednesday
4641	39	2020-08-16 09:15:00	sunday
4642	23	2020-08-17 16:15:00	monday
4643	16	2020-08-16 10:15:00	sunday
4644	11	2020-08-30 16:45:00	sunday
4645	31	2020-08-22 16:15:00	saturday
4646	16	2020-08-29 17:15:00	saturday
4647	33	2020-08-28 08:45:00	friday
4648	7	2020-08-16 10:45:00	sunday
4649	11	2020-08-24 08:15:00	monday
4650	35	2020-08-25 14:00:00	tuesday
4651	15	2020-08-03 12:15:00	monday
4652	3	2020-08-17 08:15:00	monday
4653	6	2020-08-28 16:45:00	friday
4654	21	2020-08-09 10:45:00	sunday
4655	36	2020-08-17 14:15:00	monday
4656	2	2020-08-20 10:45:00	thursday
4657	8	2020-08-08 12:45:00	saturday
4658	31	2020-08-25 11:45:00	tuesday
4659	35	2020-08-23 08:15:00	sunday
4660	39	2020-08-13 15:15:00	thursday
4661	6	2020-08-30 17:30:00	sunday
4662	19	2020-08-01 17:45:00	saturday
4663	38	2020-08-04 13:00:00	tuesday
4664	20	2020-08-23 08:30:00	sunday
4665	33	2020-08-10 12:30:00	monday
4666	13	2020-08-18 09:45:00	tuesday
4667	40	2020-08-11 16:15:00	tuesday
4668	11	2020-08-25 08:15:00	tuesday
4669	37	2020-09-12 14:30:00	saturday
4670	22	2020-09-01 10:30:00	tuesday
4671	12	2020-09-13 09:45:00	sunday
4672	39	2020-09-16 15:45:00	wednesday
4673	3	2020-09-05 09:15:00	saturday
4674	10	2020-09-13 11:30:00	sunday
4675	3	2020-09-26 15:30:00	saturday
4676	19	2020-09-04 13:15:00	friday
4677	30	2020-09-25 13:00:00	friday
4678	10	2020-09-20 10:15:00	sunday
4679	25	2020-09-08 14:45:00	tuesday
4680	1	2020-09-19 17:15:00	saturday
4681	25	2020-09-04 09:30:00	friday
4682	10	2020-09-19 10:30:00	saturday
4683	39	2020-09-24 17:00:00	thursday
4684	19	2020-09-17 12:15:00	thursday
4685	6	2020-09-14 10:15:00	monday
4686	19	2020-09-20 09:45:00	sunday
4687	33	2020-09-05 10:45:00	saturday
4688	20	2020-09-11 08:45:00	friday
4689	8	2020-09-11 15:30:00	friday
4690	17	2020-09-01 16:15:00	tuesday
4691	33	2020-09-07 11:15:00	monday
4692	7	2020-09-05 17:30:00	saturday
4693	8	2020-09-09 16:45:00	wednesday
4694	37	2020-09-22 17:00:00	tuesday
4695	9	2020-09-24 14:45:00	thursday
4696	21	2020-09-06 17:00:00	sunday
4697	2	2020-09-19 17:15:00	saturday
4698	35	2020-09-08 12:45:00	tuesday
4699	28	2020-09-14 12:15:00	monday
4700	2	2020-09-19 17:00:00	saturday
4701	9	2020-09-01 12:30:00	tuesday
4702	4	2020-09-06 12:00:00	sunday
4703	4	2020-09-07 15:15:00	monday
4704	16	2020-09-21 12:15:00	monday
4705	22	2020-09-07 14:15:00	monday
4706	11	2020-09-05 10:45:00	saturday
4707	37	2020-09-10 10:45:00	thursday
4708	10	2020-09-30 08:30:00	wednesday
4709	12	2020-09-15 16:45:00	tuesday
4710	27	2020-09-01 11:45:00	tuesday
4711	39	2020-09-01 14:30:00	tuesday
4712	9	2020-09-21 15:45:00	monday
4713	37	2020-09-13 12:00:00	sunday
4714	39	2020-09-17 12:15:00	thursday
4715	30	2020-09-21 14:30:00	monday
4716	33	2020-09-24 11:00:00	thursday
4717	29	2020-09-03 08:00:00	thursday
4718	32	2020-09-12 09:00:00	saturday
4719	13	2020-09-12 11:00:00	saturday
4720	36	2020-09-27 13:30:00	sunday
4721	5	2020-09-10 08:45:00	thursday
4722	9	2020-09-07 09:15:00	monday
4723	6	2020-10-30 13:45:00	friday
4724	5	2020-10-13 09:45:00	tuesday
4725	1	2020-10-16 13:45:00	friday
4726	38	2020-10-06 14:30:00	tuesday
4727	35	2020-10-11 12:00:00	sunday
4728	5	2020-10-26 09:15:00	monday
4729	18	2020-10-20 11:15:00	tuesday
4730	39	2020-10-25 08:45:00	sunday
4731	22	2020-10-18 13:15:00	sunday
4732	40	2020-10-06 17:45:00	tuesday
4733	19	2020-10-20 16:30:00	tuesday
4734	32	2020-10-26 09:30:00	monday
4735	27	2020-10-06 15:45:00	tuesday
4736	40	2020-10-15 13:45:00	thursday
4737	7	2020-10-23 11:00:00	friday
4738	19	2020-10-06 13:15:00	tuesday
4739	12	2020-10-29 14:45:00	thursday
4740	31	2020-10-25 10:15:00	sunday
4741	39	2020-10-03 15:00:00	saturday
4742	19	2020-10-25 16:00:00	sunday
4743	36	2020-10-19 16:30:00	monday
4744	16	2020-10-19 13:15:00	monday
4745	24	2020-10-19 11:15:00	monday
4746	26	2020-10-20 16:15:00	tuesday
4747	12	2020-10-18 09:30:00	sunday
4748	38	2020-10-19 15:45:00	monday
4749	26	2020-10-03 17:30:00	saturday
4750	19	2020-10-08 13:30:00	thursday
4751	39	2020-10-03 11:30:00	saturday
4752	35	2020-10-15 16:30:00	thursday
4753	10	2020-10-19 09:15:00	monday
4754	40	2020-10-24 08:15:00	saturday
4755	17	2020-10-17 11:00:00	saturday
4756	1	2020-10-11 14:00:00	sunday
4757	24	2020-10-24 13:45:00	saturday
4758	4	2020-10-08 13:00:00	thursday
4759	11	2020-10-20 15:00:00	tuesday
4760	19	2020-10-08 09:00:00	thursday
4761	40	2020-10-21 09:30:00	wednesday
4762	34	2020-10-04 15:30:00	sunday
4763	15	2020-10-27 16:30:00	tuesday
4764	28	2020-10-17 15:00:00	saturday
4765	28	2020-10-10 13:45:00	saturday
4766	34	2020-10-14 12:15:00	wednesday
4767	9	2020-10-23 12:45:00	friday
4768	14	2020-10-11 08:00:00	sunday
4769	6	2020-10-06 14:00:00	tuesday
4770	25	2020-10-17 09:15:00	saturday
4771	11	2020-10-22 10:00:00	thursday
4772	19	2020-10-28 13:15:00	wednesday
4773	18	2020-10-27 09:45:00	tuesday
4774	33	2020-10-30 11:00:00	friday
4775	23	2020-10-19 13:45:00	monday
4776	38	2020-10-05 15:00:00	monday
4777	9	2020-10-04 17:15:00	sunday
4778	4	2020-10-02 17:00:00	friday
4779	8	2020-10-21 10:30:00	wednesday
4780	10	2020-10-20 11:45:00	tuesday
4781	30	2020-10-25 10:15:00	sunday
4782	5	2020-11-04 13:00:00	wednesday
4783	24	2020-11-10 11:30:00	tuesday
4784	16	2020-11-04 12:15:00	wednesday
4785	36	2020-11-07 09:30:00	saturday
4786	14	2020-11-12 16:30:00	thursday
4787	19	2020-11-18 13:45:00	wednesday
4788	12	2020-11-06 17:45:00	friday
4789	13	2020-11-26 13:30:00	thursday
4790	34	2020-11-07 12:45:00	saturday
4791	33	2020-11-12 14:45:00	thursday
4792	40	2020-11-05 14:45:00	thursday
4793	28	2020-11-02 12:15:00	monday
4794	27	2020-11-14 16:15:00	saturday
4795	14	2020-11-11 12:30:00	wednesday
4796	23	2020-11-11 09:45:00	wednesday
4797	35	2020-11-08 12:30:00	sunday
4798	3	2020-11-17 10:15:00	tuesday
4799	29	2020-11-27 17:00:00	friday
4800	34	2020-11-26 10:30:00	thursday
4801	4	2020-11-25 14:00:00	wednesday
4802	14	2020-11-07 09:45:00	saturday
4803	8	2020-11-12 17:30:00	thursday
4804	21	2020-11-18 09:00:00	wednesday
4805	19	2020-11-25 12:00:00	wednesday
4806	14	2020-11-27 17:00:00	friday
4807	25	2020-11-27 10:45:00	friday
4808	34	2020-11-18 12:00:00	wednesday
4809	17	2020-11-13 14:30:00	friday
4810	21	2020-11-22 09:15:00	sunday
4811	35	2020-11-13 14:45:00	friday
4812	27	2020-11-14 14:00:00	saturday
4813	1	2020-11-05 16:30:00	thursday
4814	13	2020-11-08 08:45:00	sunday
4815	8	2020-11-14 13:30:00	saturday
4816	28	2020-11-29 16:30:00	sunday
4817	22	2020-11-14 13:30:00	saturday
4818	2	2020-11-08 11:00:00	sunday
4819	35	2020-11-16 08:30:00	monday
4820	30	2020-11-18 11:15:00	wednesday
4821	9	2020-11-24 14:15:00	tuesday
4822	22	2020-11-18 13:00:00	wednesday
4823	30	2020-11-04 08:30:00	wednesday
4824	36	2020-11-04 10:30:00	wednesday
4825	23	2020-11-08 08:45:00	sunday
4826	18	2020-11-12 16:45:00	thursday
4827	12	2020-11-27 10:15:00	friday
4828	40	2020-11-15 08:00:00	sunday
4829	16	2020-11-12 08:15:00	thursday
4830	35	2020-11-14 09:45:00	saturday
4831	32	2020-11-17 09:00:00	tuesday
4832	21	2020-11-01 17:15:00	sunday
4833	17	2020-11-03 17:00:00	tuesday
4834	26	2020-11-27 14:00:00	friday
4835	11	2020-11-18 17:15:00	wednesday
4836	6	2020-11-13 15:00:00	friday
4837	10	2020-11-04 17:30:00	wednesday
4838	1	2020-11-10 11:30:00	tuesday
4839	25	2020-11-07 08:15:00	saturday
4840	13	2020-11-04 14:45:00	wednesday
4841	31	2020-11-24 14:00:00	tuesday
4842	28	2020-12-28 12:15:00	monday
4843	28	2020-12-05 17:15:00	saturday
4844	4	2020-12-23 17:15:00	wednesday
4845	2	2020-12-02 14:15:00	wednesday
4846	28	2020-12-23 12:30:00	wednesday
4847	30	2020-12-21 12:15:00	monday
4848	14	2020-12-24 17:45:00	thursday
4849	5	2020-12-23 10:00:00	wednesday
4850	5	2020-12-15 14:45:00	tuesday
4851	33	2020-12-29 10:30:00	tuesday
4852	30	2020-12-17 14:30:00	thursday
4853	36	2020-12-03 17:00:00	thursday
4854	40	2020-12-06 17:00:00	sunday
4855	2	2020-12-22 12:00:00	tuesday
4856	21	2020-12-02 16:15:00	wednesday
4857	32	2020-12-17 08:15:00	thursday
4858	9	2020-12-09 10:15:00	wednesday
4859	25	2020-12-08 17:00:00	tuesday
4860	39	2020-12-26 08:30:00	saturday
4861	5	2020-12-20 11:15:00	sunday
4862	17	2020-12-30 11:30:00	wednesday
4863	1	2020-12-06 17:15:00	sunday
4864	7	2020-12-15 12:00:00	tuesday
4865	4	2020-12-11 16:00:00	friday
4866	11	2020-12-24 09:00:00	thursday
4867	5	2020-12-25 16:45:00	friday
4868	13	2020-12-08 17:00:00	tuesday
4869	32	2020-12-21 15:00:00	monday
4870	3	2020-12-14 14:00:00	monday
4871	40	2020-12-02 13:45:00	wednesday
4872	30	2020-12-26 10:00:00	saturday
4873	3	2020-12-27 14:30:00	sunday
4874	17	2020-12-29 17:00:00	tuesday
4875	19	2020-12-26 16:45:00	saturday
4876	35	2020-12-16 13:00:00	wednesday
4877	25	2020-12-15 11:45:00	tuesday
4878	1	2020-12-25 12:45:00	friday
4879	34	2020-12-09 10:00:00	wednesday
4880	39	2020-12-30 14:45:00	wednesday
4881	12	2020-12-12 09:00:00	saturday
4882	14	2020-12-10 13:15:00	thursday
4883	30	2020-12-10 16:15:00	thursday
4884	12	2020-12-30 10:15:00	wednesday
4885	21	2020-12-05 15:00:00	saturday
4886	33	2020-12-20 14:00:00	sunday
4887	3	2020-12-19 10:15:00	saturday
4888	22	2020-12-18 10:30:00	friday
4889	24	2020-12-11 12:30:00	friday
4890	13	2020-12-20 17:15:00	sunday
4891	27	2020-12-15 16:30:00	tuesday
4892	30	2020-12-09 16:15:00	wednesday
4893	7	2020-12-03 08:15:00	thursday
4894	13	2020-12-18 09:45:00	friday
4895	40	2020-12-25 14:00:00	friday
4896	30	2020-12-14 14:00:00	monday
4897	13	2020-12-24 17:45:00	thursday
4898	12	2020-12-26 11:45:00	saturday
4899	30	2020-12-12 15:30:00	saturday
4900	3	2020-12-29 08:30:00	tuesday
\.


--
-- Data for Name: instructor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instructor (id, first_name, last_name, person_number, street, city, zip_code) FROM stdin;
1	Moltas	Blom	199108260317	Föreningsgatan 30	SKÄRPLINGE	81065
2	Norea	Gunnarsson	196211079162	Barrgatan 21	GLOMMERSTRÄSK	93081
3	Dani	Carlsson	197206179892	Änggårda Anga 70	GRUMS	66400
4	Sanja	Gunnarsson	197303269968	Törneby 49	ÅTORP	69350
5	Alexia	Berggren	197511219581	Långlöt 6	BYXELKROK	38075
6	Alwin	Nyström	199011255958	Idvägen 17	VADSTENA	59200
7	Noelia	Lindqvist	196907107764	Alingsåsvägen 84	HEDARED	50580
8	Jack	Göransson	197006182773	Mållångsbo 67	PAJALA	98451
9	Kalle	Holmgren	198712053951	Östbygatan 65	KUNGSÖR	73693
10	Alwin	Söderberg	198709085412	Hantverkarg 55	RUNMARÖ	13038
11	Susanna	Eliasson	198207099121	Stackekärr 38	HARMÅNGER	82075
12	Petrus	Pettersson	198809199691	Messlingen 74	LILLHÄRDAL	84080
13	Elvin	Karlsson	198505221518	Lidbovägen 34	LILLPITE	94017
14	Alex	Hellström	199106277636	Edeby 73	VAGNHÄRAD	61070
15	Anastasija	Gunnarsson	195607194601	Nybyvägen 7	ANKARSRUM	59090
\.


--
-- Data for Name: instructor_contact_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instructor_contact_info (instructor_id, telefon_number, email_address) FROM stdin;
1	214738017	itstatus@mac.com
2	586635387	yruan@live.com
3	49668733	emcleod@me.com
4	725554326	evans@icloud.com
5	615436897	gerlo@verizon.net
6	71765586	demmel@msn.com
7	390917779	kwilliams@yahoo.ca
8	811451703	tellis@gmail.com
9	978092316	koudas@aol.com
10	750747904	madler@optonline.net
11	15830134	thrymm@gmail.com
12	30878462	stecoop@aol.com
13	410690770	biglou@yahoo.com
14	335090313	augusto@hotmail.com
15	419644510	munson@verizon.net
\.


--
-- Data for Name: instructor_salary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instructor_salary (instructor_id, lesson_schedule_id, ensemble_schedule_id) FROM stdin;
\.


--
-- Data for Name: instrument; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrument (id, kind, type, condition, brand) FROM stdin;
1	Piano	string	good	Bechstein
2	Piano	string	good	FAZIOLI
3	Violin	string	good	Stentor
4	Drums	percussion	very good	YAMAHA
5	Saxophone	brass	good	Selmer Paris
6	Clarinet	woodwind	good	Yamaha
7	Trumpet	brass	good	Rossetti
8	Clarinet	woodwind	bad	Mendini
9	Trumpet	brass	good	Cecilio
10	Trumpet	brass	bad	Allora
\.


--
-- Data for Name: instrument_rental; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instrument_rental (id, instrument_id, student_id, rental_date, return_date, rental_period, delivery_method, terminated, date_of_termination) FROM stdin;
354	5	21	2020-12-31	2021-07-31	7	Deliver to house	t	2021-01-02
430	6	6	2021-01-02	2021-06-02	5	Deliver to house	t	2021-01-02
425	5	23	2021-01-02	2021-08-02	7	Pick up	t	2021-01-02
320	5	25	2020-04-26	2021-03-26	11	Deliver to house	t	2021-01-02
1	6	19	2014-01-19	2014-08-19	7	Pick up	t	2014-05-19
2	1	24	2014-01-10	2014-11-10	10	Deliver to house	f	\N
3	8	20	2014-01-14	2014-02-14	1	Pick up	f	\N
4	3	26	2014-01-16	2014-02-16	1	Deliver to house	f	\N
5	5	6	2014-01-07	2014-06-07	5	Deliver to house	f	\N
6	5	17	2014-02-08	2015-01-08	11	Pick up	t	2014-06-08
7	1	25	2014-02-23	2014-10-23	8	Pick up	f	\N
8	4	29	2014-02-17	2014-12-17	10	Pick up	f	\N
9	10	17	2014-02-09	2015-01-09	11	Deliver to house	f	\N
10	4	6	2014-02-28	2014-11-28	9	Pick up	f	\N
11	10	22	2014-03-11	2014-05-11	2	Deliver to house	t	2014-04-11
12	5	3	2014-03-21	2014-10-21	7	Pick up	f	\N
13	9	30	2014-03-05	2014-12-05	9	Deliver to house	f	\N
14	8	28	2014-03-06	2014-05-06	2	Pick up	f	\N
15	10	14	2014-03-20	2015-01-20	10	Pick up	f	\N
16	6	27	2014-03-19	2015-01-19	10	Deliver to house	t	2014-07-19
17	3	7	2014-03-18	2014-04-18	1	Deliver to house	f	\N
18	8	23	2014-04-11	2014-11-11	7	Pick up	f	\N
19	8	15	2014-04-01	2015-04-01	12	Pick up	f	\N
20	2	29	2014-04-07	2015-01-07	9	Deliver to house	f	\N
21	10	1	2014-04-27	2014-06-27	2	Pick up	t	2014-05-27
22	3	19	2014-05-26	2015-01-26	8	Deliver to house	f	\N
23	4	8	2014-05-01	2014-06-01	1	Deliver to house	f	\N
24	7	4	2014-06-19	2014-10-19	4	Deliver to house	f	\N
25	10	13	2014-06-05	2015-04-05	10	Pick up	f	\N
26	6	18	2014-06-24	2014-10-24	4	Pick up	t	2014-07-24
27	7	24	2014-06-16	2015-05-16	11	Deliver to house	f	\N
28	2	15	2014-06-15	2014-08-15	2	Deliver to house	f	\N
29	7	2	2014-06-15	2015-04-15	10	Deliver to house	f	\N
30	8	2	2014-06-15	2015-05-15	11	Deliver to house	f	\N
31	2	30	2014-07-01	2015-05-01	10	Deliver to house	t	2014-08-01
32	1	14	2014-07-28	2015-01-28	6	Deliver to house	f	\N
33	6	11	2014-08-16	2015-01-16	5	Deliver to house	f	\N
34	2	10	2014-09-17	2015-02-17	5	Pick up	f	\N
35	9	22	2014-09-06	2014-11-06	2	Deliver to house	f	\N
36	6	11	2014-09-24	2014-10-24	1	Pick up	f	\N
37	4	12	2014-09-23	2015-09-23	12	Pick up	f	\N
38	4	4	2014-09-15	2014-10-15	1	Deliver to house	f	\N
39	9	21	2014-09-05	2014-11-05	2	Pick up	f	\N
40	6	13	2014-10-21	2014-11-21	1	Pick up	f	\N
41	4	3	2014-10-04	2015-03-04	5	Pick up	t	2014-12-04
42	8	8	2014-10-22	2015-08-22	10	Pick up	f	\N
43	3	5	2014-10-04	2015-01-04	3	Pick up	f	\N
44	5	23	2014-11-25	2015-11-25	12	Deliver to house	f	\N
45	10	26	2014-12-28	2015-04-28	4	Pick up	f	\N
46	1	20	2014-12-13	2015-06-13	6	Pick up	t	2015-03-13
47	2	12	2014-12-03	2015-03-03	3	Pick up	f	\N
48	3	16	2014-12-06	2015-11-06	11	Deliver to house	f	\N
49	8	9	2014-12-07	2015-03-07	3	Pick up	f	\N
50	6	18	2014-12-05	2015-08-05	8	Pick up	f	\N
51	9	8	2015-01-11	2015-09-11	8	Deliver to house	t	2015-05-11
52	6	16	2015-01-15	2015-06-15	5	Pick up	f	\N
53	5	24	2015-01-27	2015-12-27	11	Deliver to house	f	\N
54	4	19	2015-01-07	2015-04-07	3	Pick up	f	\N
55	10	14	2015-01-24	2015-07-24	6	Deliver to house	f	\N
56	1	29	2015-01-28	2015-02-28	1	Pick up	f	\N
57	4	29	2015-02-06	2016-02-06	12	Deliver to house	f	\N
58	3	30	2015-02-10	2015-03-10	1	Pick up	f	\N
59	9	28	2015-02-21	2015-07-21	5	Pick up	f	\N
60	9	9	2015-02-23	2015-07-23	5	Deliver to house	f	\N
61	1	8	2015-02-20	2015-07-20	5	Pick up	t	2015-05-20
62	10	4	2015-02-26	2015-11-26	9	Deliver to house	f	\N
63	4	19	2015-02-16	2015-10-16	8	Deliver to house	f	\N
64	3	15	2015-02-11	2016-01-11	11	Pick up	f	\N
65	2	10	2015-02-06	2016-01-06	11	Deliver to house	f	\N
66	7	20	2015-02-28	2015-11-28	9	Deliver to house	t	2015-05-28
67	4	9	2015-03-18	2015-11-18	8	Pick up	f	\N
68	7	5	2015-03-24	2015-12-24	9	Pick up	f	\N
69	4	3	2015-03-07	2015-08-07	5	Deliver to house	f	\N
70	10	12	2015-03-05	2015-09-05	6	Pick up	f	\N
71	1	15	2015-04-04	2016-03-04	11	Pick up	t	2015-07-04
72	6	7	2015-04-25	2016-04-25	12	Pick up	f	\N
73	5	2	2015-04-24	2015-09-24	5	Deliver to house	f	\N
74	3	3	2015-04-21	2016-01-21	9	Pick up	f	\N
75	9	5	2015-04-28	2015-06-28	2	Pick up	f	\N
76	10	23	2015-05-26	2016-04-26	11	Deliver to house	t	2015-08-26
77	1	6	2015-05-12	2015-09-12	4	Deliver to house	f	\N
78	2	25	2015-05-24	2015-11-24	6	Deliver to house	f	\N
79	6	24	2015-06-19	2016-01-19	7	Pick up	f	\N
80	10	16	2015-06-06	2015-08-06	2	Deliver to house	f	\N
81	8	26	2015-06-14	2015-12-14	6	Deliver to house	t	2015-07-14
82	8	26	2015-06-09	2015-08-09	2	Pick up	f	\N
83	10	13	2015-06-28	2016-06-28	12	Deliver to house	f	\N
84	2	27	2015-07-03	2016-02-03	7	Pick up	f	\N
85	1	13	2015-07-24	2016-02-24	7	Deliver to house	f	\N
86	10	21	2015-07-03	2015-08-03	1	Pick up	t	2015-07-03
87	1	18	2015-07-03	2015-09-03	2	Pick up	f	\N
88	8	23	2015-07-27	2015-11-27	4	Pick up	f	\N
89	10	14	2015-08-16	2016-03-16	7	Pick up	f	\N
90	1	25	2015-08-19	2016-02-19	6	Pick up	f	\N
91	10	18	2015-08-05	2016-06-05	10	Pick up	t	2015-09-05
92	5	1	2015-09-10	2015-12-10	3	Pick up	f	\N
93	10	11	2015-09-26	2016-06-26	9	Pick up	f	\N
94	1	30	2015-09-25	2015-12-25	3	Pick up	f	\N
95	6	7	2015-09-15	2015-11-15	2	Pick up	f	\N
96	2	12	2015-10-10	2016-02-10	4	Pick up	t	2015-12-10
97	4	22	2015-10-28	2016-01-28	3	Pick up	f	\N
98	3	1	2015-10-20	2016-06-20	8	Pick up	f	\N
99	10	22	2015-10-06	2015-11-06	1	Pick up	f	\N
100	6	2	2015-11-08	2016-08-08	9	Deliver to house	f	\N
101	4	17	2015-11-17	2016-10-17	11	Deliver to house	t	2016-05-17
102	1	17	2015-11-13	2016-06-13	7	Pick up	f	\N
427	1	24	2021-01-02	2021-06-02	5	Pick up	f	\N
103	7	4	2015-11-05	2016-03-05	4	Pick up	f	\N
104	2	21	2015-11-16	2016-11-16	12	Pick up	f	\N
105	2	11	2015-11-18	2016-10-18	11	Deliver to house	f	\N
106	8	27	2015-12-22	2016-10-22	10	Deliver to house	t	2016-05-22
107	2	20	2015-12-18	2016-08-18	8	Deliver to house	f	\N
108	8	28	2015-12-13	2016-09-13	9	Deliver to house	f	\N
109	6	10	2015-12-16	2016-11-16	11	Deliver to house	f	\N
110	10	6	2015-12-24	2016-10-24	10	Deliver to house	f	\N
111	9	19	2016-01-12	2016-08-12	7	Deliver to house	t	2016-05-12
112	4	26	2016-01-11	2016-06-11	5	Deliver to house	f	\N
113	4	27	2016-01-20	2016-12-20	11	Deliver to house	f	\N
114	2	24	2016-01-12	2016-04-12	3	Deliver to house	f	\N
115	1	16	2016-01-23	2016-08-23	7	Deliver to house	f	\N
116	9	6	2016-02-27	2016-04-27	2	Pick up	t	2016-03-27
117	6	12	2016-02-28	2016-04-28	2	Deliver to house	f	\N
118	6	27	2016-02-01	2017-01-01	11	Deliver to house	f	\N
119	8	13	2016-02-01	2016-05-01	3	Deliver to house	f	\N
120	10	15	2016-02-21	2016-05-21	3	Deliver to house	f	\N
121	7	30	2016-03-07	2016-07-07	4	Pick up	t	2016-05-07
122	10	4	2016-03-03	2017-03-03	12	Pick up	f	\N
123	7	10	2016-03-12	2017-03-12	12	Deliver to house	f	\N
124	5	3	2016-03-24	2016-09-24	6	Pick up	f	\N
125	2	19	2016-03-05	2017-03-05	12	Pick up	f	\N
126	4	8	2016-04-04	2016-12-04	8	Pick up	t	2016-08-04
127	4	10	2016-04-13	2017-01-13	9	Pick up	f	\N
128	7	28	2016-05-24	2017-05-24	12	Deliver to house	f	\N
129	4	13	2016-05-24	2016-09-24	4	Deliver to house	f	\N
130	6	14	2016-05-16	2017-02-16	9	Pick up	f	\N
131	4	11	2016-05-07	2017-02-07	9	Pick up	t	2016-07-07
132	5	22	2016-06-05	2017-01-05	7	Pick up	f	\N
133	10	23	2016-06-19	2017-03-19	9	Deliver to house	f	\N
134	3	24	2016-06-26	2016-12-26	6	Pick up	f	\N
135	3	11	2016-06-18	2017-01-18	7	Deliver to house	f	\N
136	9	5	2016-07-25	2017-07-25	12	Pick up	t	2016-08-25
137	7	17	2016-07-15	2016-10-15	3	Pick up	f	\N
138	9	12	2016-07-06	2017-03-06	8	Pick up	f	\N
139	9	15	2016-08-25	2016-09-25	1	Pick up	f	\N
140	3	18	2016-08-04	2016-10-04	2	Pick up	f	\N
141	5	3	2016-08-10	2016-12-10	4	Deliver to house	t	2016-09-10
142	8	20	2016-08-27	2017-04-27	8	Deliver to house	f	\N
143	10	2	2016-09-18	2017-03-18	6	Pick up	f	\N
144	10	7	2016-09-22	2017-05-22	8	Deliver to house	f	\N
145	1	17	2016-09-12	2016-11-12	2	Pick up	f	\N
146	8	29	2016-10-10	2017-02-10	4	Deliver to house	t	2016-12-10
147	10	9	2016-10-19	2016-12-19	2	Deliver to house	f	\N
148	8	1	2016-10-26	2017-05-26	7	Deliver to house	f	\N
149	2	21	2016-10-18	2017-06-18	8	Pick up	f	\N
150	8	16	2016-10-03	2017-09-03	11	Deliver to house	f	\N
151	7	20	2016-10-10	2016-11-10	1	Pick up	t	2016-12-10
152	8	25	2016-11-07	2017-09-07	10	Pick up	f	\N
153	2	26	2016-11-07	2017-01-07	2	Pick up	f	\N
154	8	29	2016-11-17	2017-10-17	11	Pick up	f	\N
155	5	21	2016-12-06	2017-03-06	3	Pick up	f	\N
156	2	18	2017-01-03	2017-07-03	6	Pick up	t	2017-05-03
157	1	25	2017-01-05	2017-10-05	9	Pick up	f	\N
158	10	29	2017-01-09	2017-07-09	6	Deliver to house	f	\N
159	1	5	2017-02-04	2017-03-04	1	Deliver to house	f	\N
160	10	29	2017-02-03	2017-12-03	10	Pick up	f	\N
161	7	6	2017-02-22	2017-06-22	4	Deliver to house	t	2017-03-22
162	1	3	2017-02-19	2018-01-19	11	Pick up	f	\N
163	2	15	2017-02-13	2017-05-13	3	Deliver to house	f	\N
164	3	4	2017-02-05	2017-06-05	4	Deliver to house	f	\N
165	9	17	2017-03-20	2017-12-20	9	Pick up	f	\N
166	10	22	2017-03-12	2017-10-12	7	Pick up	t	2017-05-12
167	7	27	2017-03-07	2018-02-07	11	Deliver to house	f	\N
168	8	2	2017-04-19	2017-07-19	3	Deliver to house	f	\N
169	1	19	2017-04-10	2018-02-10	10	Pick up	f	\N
170	9	25	2017-04-20	2018-01-20	9	Deliver to house	f	\N
171	7	5	2017-04-10	2017-05-10	1	Deliver to house	t	2017-04-10
172	9	28	2017-04-08	2018-02-08	10	Deliver to house	f	\N
173	5	10	2017-05-02	2018-01-02	8	Pick up	f	\N
174	1	13	2017-05-12	2017-06-12	1	Pick up	f	\N
175	9	14	2017-05-26	2018-01-26	8	Deliver to house	f	\N
176	2	26	2017-06-05	2017-10-05	4	Pick up	t	2017-08-05
177	3	14	2017-06-09	2018-03-09	9	Pick up	f	\N
178	7	13	2017-06-04	2017-09-04	3	Pick up	f	\N
179	2	21	2017-06-13	2018-05-13	11	Deliver to house	f	\N
180	4	20	2017-06-25	2018-02-25	8	Pick up	f	\N
181	2	30	2017-07-10	2018-06-10	11	Deliver to house	t	2017-10-10
182	10	26	2017-07-09	2017-09-09	2	Pick up	f	\N
183	9	27	2017-07-24	2018-02-24	7	Deliver to house	f	\N
184	8	28	2017-07-05	2018-01-05	6	Pick up	f	\N
185	3	9	2017-07-03	2017-08-03	1	Deliver to house	f	\N
186	6	18	2017-07-20	2018-03-20	8	Deliver to house	t	2017-09-20
187	5	16	2017-07-27	2017-08-27	1	Pick up	f	\N
188	6	21	2017-08-22	2018-02-22	6	Deliver to house	f	\N
189	1	11	2017-08-09	2018-07-09	11	Pick up	f	\N
190	4	7	2017-08-01	2017-11-01	3	Pick up	f	\N
191	3	2	2017-08-18	2018-08-18	12	Pick up	t	2017-09-18
192	8	1	2017-08-06	2018-02-06	6	Pick up	f	\N
193	7	8	2017-08-22	2018-02-22	6	Deliver to house	f	\N
194	1	4	2017-08-26	2018-01-26	5	Pick up	f	\N
195	4	23	2017-09-05	2018-07-05	10	Deliver to house	f	\N
196	2	10	2017-09-11	2018-03-11	6	Pick up	t	2017-12-11
197	4	12	2017-09-12	2018-02-12	5	Deliver to house	f	\N
198	3	17	2017-10-16	2017-11-16	1	Pick up	f	\N
199	9	24	2017-10-10	2018-10-10	12	Pick up	f	\N
200	4	1	2017-10-08	2017-11-08	1	Pick up	f	\N
201	4	19	2017-10-19	2018-06-19	8	Deliver to house	t	2017-12-19
202	3	16	2017-11-12	2018-08-12	9	Pick up	f	\N
203	9	24	2017-11-22	2018-03-22	4	Pick up	f	\N
204	6	3	2017-12-10	2018-03-10	3	Pick up	f	\N
205	6	15	2017-12-12	2018-04-12	4	Pick up	f	\N
206	7	9	2017-12-21	2018-09-21	9	Pick up	t	2018-02-21
207	1	6	2017-12-18	2018-02-18	2	Deliver to house	f	\N
208	7	22	2017-12-11	2018-10-11	10	Deliver to house	f	\N
209	5	7	2018-01-13	2018-06-13	5	Deliver to house	t	2018-05-13
210	6	29	2018-01-20	2018-07-20	6	Deliver to house	f	\N
211	9	4	2018-02-22	2018-07-22	5	Pick up	f	\N
212	4	7	2018-02-10	2018-07-10	5	Deliver to house	f	\N
213	6	30	2018-02-15	2019-01-15	11	Deliver to house	f	\N
214	8	17	2018-02-09	2018-07-09	5	Pick up	t	2018-04-09
215	7	20	2018-03-26	2018-07-26	4	Deliver to house	f	\N
216	7	30	2018-03-06	2019-01-06	10	Pick up	f	\N
217	9	16	2018-03-26	2018-10-26	7	Pick up	f	\N
218	5	5	2018-04-16	2019-03-16	11	Pick up	f	\N
219	10	25	2018-04-17	2018-10-17	6	Pick up	t	2018-08-17
220	5	23	2018-05-10	2019-05-10	12	Pick up	f	\N
221	5	8	2018-05-02	2018-07-02	2	Pick up	f	\N
222	7	17	2018-05-05	2018-08-05	3	Pick up	f	\N
223	5	19	2018-05-26	2018-07-26	2	Pick up	f	\N
224	5	12	2018-05-28	2019-05-28	12	Deliver to house	t	2018-08-28
225	1	5	2018-06-17	2019-06-17	12	Deliver to house	f	\N
226	1	1	2018-06-07	2018-11-07	5	Pick up	f	\N
227	8	4	2018-06-09	2018-08-09	2	Deliver to house	f	\N
228	9	20	2018-06-13	2019-06-13	12	Deliver to house	f	\N
229	9	23	2018-07-26	2018-09-26	2	Deliver to house	t	2018-08-26
230	1	29	2018-07-07	2019-05-07	10	Pick up	f	\N
231	2	27	2018-07-01	2019-02-01	7	Pick up	f	\N
232	5	6	2018-07-07	2019-02-07	7	Pick up	f	\N
233	2	2	2018-07-07	2019-04-07	9	Deliver to house	f	\N
234	7	10	2018-08-16	2019-05-16	9	Deliver to house	t	2018-12-16
235	10	21	2018-08-17	2019-05-17	9	Pick up	f	\N
236	9	24	2018-08-23	2018-10-23	2	Pick up	f	\N
237	9	11	2018-08-16	2019-08-16	12	Pick up	f	\N
238	6	9	2018-08-07	2019-01-07	5	Pick up	f	\N
239	1	12	2018-09-26	2018-11-26	2	Pick up	t	2018-10-26
240	5	3	2018-09-13	2018-11-13	2	Pick up	f	\N
241	1	24	2018-10-16	2019-06-16	8	Deliver to house	f	\N
242	10	22	2018-10-15	2019-06-15	8	Pick up	f	\N
243	2	13	2018-10-01	2019-04-01	6	Deliver to house	f	\N
244	3	26	2018-10-01	2019-07-01	9	Pick up	t	2018-12-01
245	6	2	2018-10-01	2019-10-01	12	Pick up	f	\N
246	9	18	2018-10-23	2019-10-23	12	Deliver to house	f	\N
247	2	22	2018-11-07	2018-12-07	1	Deliver to house	f	\N
248	6	10	2018-11-10	2019-04-10	5	Pick up	f	\N
249	10	11	2018-11-22	2019-06-22	7	Pick up	t	2018-12-22
250	9	21	2018-11-05	2019-09-05	10	Deliver to house	f	\N
251	8	16	2018-12-09	2019-08-09	8	Deliver to house	f	\N
252	4	15	2018-12-28	2019-08-28	8	Pick up	f	\N
253	5	6	2018-12-28	2019-08-28	8	Deliver to house	f	\N
254	6	28	2018-12-27	2019-06-27	6	Deliver to house	t	2019-05-27
255	9	14	2018-12-13	2019-10-13	10	Deliver to house	f	\N
256	5	27	2018-12-22	2019-10-22	10	Pick up	f	\N
257	10	5	2019-01-18	2019-03-18	2	Pick up	t	2019-02-18
258	10	7	2019-01-10	2019-06-10	5	Deliver to house	f	\N
259	6	21	2019-01-15	2019-03-15	2	Pick up	f	\N
260	7	16	2019-01-08	2020-01-08	12	Pick up	f	\N
261	7	8	2019-02-28	2019-07-28	5	Deliver to house	f	\N
262	6	1	2019-02-20	2019-09-20	7	Pick up	t	2019-05-20
263	9	12	2019-02-03	2019-03-03	1	Pick up	f	\N
264	8	22	2019-02-18	2020-02-18	12	Deliver to house	f	\N
265	6	12	2019-02-04	2019-03-04	1	Pick up	f	\N
266	1	16	2019-02-02	2019-07-02	5	Deliver to house	f	\N
267	3	15	2019-02-09	2019-08-09	6	Pick up	t	2019-04-09
268	7	2	2019-03-18	2020-01-18	10	Deliver to house	f	\N
269	10	10	2019-03-17	2019-12-17	9	Deliver to house	f	\N
270	3	2	2019-03-14	2019-10-14	7	Deliver to house	f	\N
271	10	13	2019-03-07	2019-07-07	4	Deliver to house	f	\N
272	7	20	2019-03-05	2019-05-05	2	Deliver to house	t	2019-04-05
273	8	14	2019-03-14	2019-09-14	6	Pick up	f	\N
274	6	13	2019-03-13	2020-02-13	11	Pick up	f	\N
275	4	19	2019-03-10	2020-01-10	10	Pick up	f	\N
276	3	3	2019-03-07	2020-02-07	11	Deliver to house	f	\N
277	7	20	2019-03-21	2019-07-21	4	Pick up	t	2019-06-21
278	8	14	2019-03-02	2019-05-02	2	Pick up	f	\N
279	10	5	2019-04-14	2020-02-14	10	Deliver to house	f	\N
280	9	4	2019-04-13	2019-10-13	6	Deliver to house	f	\N
281	2	11	2019-04-25	2019-10-25	6	Deliver to house	f	\N
282	10	23	2019-04-12	2019-12-12	8	Pick up	t	2019-08-12
283	1	28	2019-04-08	2019-09-08	5	Deliver to house	f	\N
284	9	4	2019-05-25	2020-03-25	10	Deliver to house	f	\N
285	6	30	2019-05-07	2019-12-07	7	Deliver to house	f	\N
286	5	24	2019-05-07	2019-12-07	7	Deliver to house	f	\N
287	8	7	2019-05-27	2020-05-27	12	Deliver to house	t	2019-08-27
288	4	6	2019-06-15	2019-11-15	5	Deliver to house	f	\N
289	1	11	2019-06-09	2020-03-09	9	Pick up	f	\N
290	10	26	2019-06-05	2020-02-05	8	Pick up	f	\N
291	8	1	2019-06-14	2019-07-14	1	Deliver to house	f	\N
292	6	29	2019-06-13	2019-12-13	6	Pick up	t	2019-10-13
293	9	3	2019-06-02	2020-02-02	8	Pick up	f	\N
294	3	23	2019-06-25	2019-09-25	3	Pick up	f	\N
295	2	18	2019-07-25	2019-09-25	2	Pick up	f	\N
296	3	25	2019-07-15	2019-11-15	4	Pick up	f	\N
297	10	8	2019-07-15	2019-12-15	5	Pick up	t	2019-09-15
298	8	17	2019-08-20	2020-02-20	6	Pick up	f	\N
299	2	10	2019-08-28	2020-04-28	8	Deliver to house	f	\N
300	10	25	2019-09-06	2020-04-06	7	Pick up	f	\N
301	10	29	2019-09-03	2019-10-03	1	Pick up	f	\N
302	4	15	2019-09-17	2020-06-17	9	Pick up	t	2019-12-17
303	1	9	2019-10-21	2020-03-21	5	Deliver to house	f	\N
304	4	19	2019-11-16	2020-09-16	10	Pick up	f	\N
305	6	17	2019-11-27	2020-04-27	5	Pick up	f	\N
306	9	9	2019-12-24	2020-05-24	5	Deliver to house	f	\N
307	10	27	2019-12-09	2020-10-09	10	Pick up	t	2020-05-09
308	6	14	2020-01-19	2020-09-19	8	Pick up	t	2020-05-19
309	5	18	2020-01-08	2020-05-08	4	Deliver to house	f	\N
310	5	24	2020-01-07	2020-12-07	11	Pick up	f	\N
311	2	9	2020-01-21	2020-08-21	7	Deliver to house	f	\N
312	6	15	2020-01-19	2020-08-19	7	Pick up	f	\N
313	2	1	2020-02-09	2020-08-09	6	Deliver to house	t	2020-05-09
314	5	11	2020-02-20	2021-01-20	11	Deliver to house	f	\N
315	8	5	2020-03-22	2020-05-22	2	Deliver to house	f	\N
316	9	9	2020-03-12	2021-01-12	10	Deliver to house	f	\N
317	8	18	2020-03-16	2020-07-16	4	Pick up	f	\N
318	7	7	2020-04-17	2020-05-17	1	Deliver to house	t	2020-04-17
319	3	29	2020-04-06	2020-05-06	1	Deliver to house	f	\N
321	8	13	2020-04-19	2020-07-19	3	Pick up	f	\N
322	3	8	2020-04-15	2020-10-15	6	Deliver to house	f	\N
323	10	23	2020-04-11	2020-07-11	3	Deliver to house	t	2020-05-11
324	5	6	2020-05-23	2021-03-23	10	Deliver to house	f	\N
325	2	12	2020-05-06	2021-04-06	11	Pick up	f	\N
326	2	26	2020-05-05	2020-11-05	6	Deliver to house	f	\N
327	4	10	2020-05-05	2020-06-05	1	Deliver to house	f	\N
328	4	17	2020-05-05	2021-03-05	10	Deliver to house	t	2020-09-05
329	6	8	2020-06-17	2021-02-17	8	Deliver to house	f	\N
331	6	28	2020-06-04	2021-06-04	12	Deliver to house	f	\N
332	4	21	2020-07-25	2020-08-25	1	Pick up	f	\N
333	7	27	2020-07-17	2020-11-17	4	Deliver to house	t	2020-10-17
334	10	3	2020-07-19	2020-10-19	3	Deliver to house	f	\N
335	2	29	2020-07-07	2021-02-07	7	Pick up	f	\N
336	6	16	2020-08-05	2020-11-05	3	Pick up	f	\N
337	4	26	2020-08-16	2021-07-16	11	Pick up	f	\N
338	7	22	2020-08-24	2021-04-24	8	Deliver to house	t	2020-12-24
339	4	27	2020-08-25	2021-08-25	12	Pick up	f	\N
340	8	4	2020-09-10	2020-10-10	1	Deliver to house	f	\N
341	6	10	2020-09-28	2020-10-28	1	Pick up	f	\N
342	9	19	2020-10-20	2021-09-20	11	Pick up	f	\N
343	7	11	2020-10-09	2021-01-09	3	Deliver to house	t	2020-12-09
344	4	30	2020-10-25	2021-07-25	9	Deliver to house	f	\N
345	3	19	2020-10-12	2021-06-12	8	Pick up	f	\N
346	8	14	2020-10-19	2020-11-19	1	Deliver to house	f	\N
347	3	5	2020-10-06	2020-11-06	1	Pick up	f	\N
348	9	21	2020-11-14	2021-10-14	11	Deliver to house	t	2020-12-14
349	2	12	2020-11-20	2021-09-20	10	Pick up	f	\N
350	5	2	2020-11-26	2021-01-26	2	Pick up	f	\N
351	3	20	2020-11-25	2021-02-25	3	Pick up	f	\N
353	6	22	2020-12-02	2021-05-02	5	Deliver to house	t	2021-02-02
330	10	25	2020-06-07	2021-01-07	7	Deliver to house	t	2021-01-02
352	4	15	2020-12-08	2021-11-08	11	Pick up	t	2021-01-02
428	1	15	2021-01-02	2021-06-02	5	Deliver to house	f	\N
429	5	16	2021-01-02	2021-11-02	10	Pick up	f	\N
431	9	24	2021-01-03	2021-05-03	4	Deliver to house	f	\N
432	1	25	2021-01-03	2021-06-03	5	Pick up	f	\N
426	7	25	2021-01-02	2021-09-02	8	Pick up	t	2021-01-03
\.


--
-- Data for Name: lesson; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesson (id, instructor_id, instrument_kind, lesson_type, minimum_number_of_students, maximum_number_of_students, enrolled_students_number, lesson_level) FROM stdin;
1	13	Drums	group	2	30	16	intermediate
2	7	Saxophone	individual	1	1	1	advanced
3	10	Saxophone	individual	1	1	1	advanced
4	2	Trumpet	individual	1	1	1	beginner
5	15	Saxophone	individual	1	1	1	advanced
6	11	Violin	group	2	30	24	advanced
7	4	Drums	individual	1	1	1	beginner
8	2	Piano	group	2	30	19	intermediate
9	1	Clarinet	individual	1	1	1	advanced
10	12	Trumpet	individual	1	1	1	beginner
11	5	Drums	individual	1	1	1	intermediate
12	10	Drums	group	2	30	9	advanced
13	7	Piano	group	2	30	18	beginner
14	5	Trumpet	group	2	30	17	advanced
15	3	Drums	group	2	30	12	advanced
16	8	Violin	individual	1	1	1	beginner
17	7	Saxophone	group	2	30	17	beginner
18	9	Violin	group	2	30	10	advanced
19	11	Trumpet	group	2	30	18	beginner
20	8	Saxophone	individual	1	1	1	beginner
21	8	Trumpet	group	2	30	13	intermediate
22	14	Trumpet	group	2	30	17	intermediate
23	3	Saxophone	group	2	30	26	advanced
24	9	Piano	group	2	30	12	advanced
25	15	Drums	individual	1	1	1	advanced
26	13	Trumpet	individual	1	1	1	beginner
27	11	Drums	group	2	30	5	beginner
28	15	Saxophone	group	2	30	30	beginner
29	9	Violin	individual	1	1	1	beginner
30	4	Clarinet	individual	1	1	1	beginner
31	9	Piano	individual	1	1	1	intermediate
32	9	Saxophone	individual	1	1	1	advanced
33	12	Clarinet	group	2	30	22	beginner
34	4	Drums	group	2	30	19	advanced
35	2	Trumpet	group	2	30	8	advanced
36	10	Violin	group	2	30	6	advanced
37	13	Trumpet	individual	1	1	1	beginner
38	9	Saxophone	group	2	30	11	intermediate
39	3	Violin	individual	1	1	1	beginner
40	10	Trumpet	group	2	30	6	advanced
\.


--
-- Data for Name: lesson_price; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesson_price (id, lesson_id, lesson_price) FROM stdin;
\.


--
-- Data for Name: lesson_schedule; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.lesson_schedule (id, lesson_id, start_date, week_day) FROM stdin;
1	8	2014-01-30 14:15:00	thursday
2	3	2014-01-27 08:15:00	monday
3	24	2014-01-27 17:30:00	monday
4	26	2014-01-26 10:15:00	sunday
5	10	2014-01-19 08:30:00	sunday
6	1	2014-01-08 15:45:00	wednesday
7	8	2014-01-25 15:00:00	saturday
8	21	2014-01-12 08:15:00	sunday
9	18	2014-01-22 10:00:00	wednesday
10	19	2014-01-08 16:00:00	wednesday
11	12	2014-01-30 08:00:00	thursday
12	5	2014-01-21 11:45:00	tuesday
13	27	2014-01-27 09:00:00	monday
14	12	2014-01-17 12:30:00	friday
15	14	2014-01-25 08:30:00	saturday
16	28	2014-01-25 15:30:00	saturday
17	6	2014-01-05 15:15:00	sunday
18	28	2014-01-06 10:00:00	monday
19	40	2014-01-09 14:15:00	thursday
20	5	2014-01-01 09:00:00	wednesday
21	15	2014-01-06 14:45:00	monday
22	32	2014-01-17 14:45:00	friday
23	36	2014-01-26 09:30:00	sunday
24	34	2014-01-19 17:45:00	sunday
25	8	2014-01-13 16:30:00	monday
26	34	2014-01-09 11:00:00	thursday
27	6	2014-01-01 13:45:00	wednesday
28	39	2014-01-09 16:45:00	thursday
29	3	2014-01-14 12:30:00	tuesday
30	11	2014-01-05 12:15:00	sunday
31	8	2014-01-21 12:45:00	tuesday
32	36	2014-01-25 16:00:00	saturday
33	36	2014-01-05 15:45:00	sunday
34	32	2014-01-23 13:00:00	thursday
35	27	2014-01-02 16:45:00	thursday
36	22	2014-01-10 12:30:00	friday
37	28	2014-01-24 11:15:00	friday
38	9	2014-01-05 10:45:00	sunday
39	4	2014-01-29 13:45:00	wednesday
40	6	2014-01-09 11:00:00	thursday
41	5	2014-01-02 12:00:00	thursday
42	10	2014-01-14 14:30:00	tuesday
43	36	2014-01-17 12:00:00	friday
44	14	2014-01-18 16:15:00	saturday
45	20	2014-01-03 17:45:00	friday
46	29	2014-01-22 13:45:00	wednesday
47	13	2014-01-19 14:00:00	sunday
48	2	2014-01-19 16:30:00	sunday
49	1	2014-01-12 10:00:00	sunday
50	37	2014-01-20 09:30:00	monday
51	19	2014-01-20 12:15:00	monday
52	20	2014-01-20 17:30:00	monday
53	40	2014-01-06 17:45:00	monday
54	27	2014-01-02 08:00:00	thursday
55	39	2014-01-08 13:00:00	wednesday
56	14	2014-01-20 17:15:00	monday
57	26	2014-01-23 16:30:00	thursday
58	28	2014-01-20 17:30:00	monday
59	5	2014-01-01 13:15:00	wednesday
60	19	2014-01-20 11:30:00	monday
61	36	2014-01-07 14:45:00	tuesday
62	8	2014-01-07 17:30:00	tuesday
63	30	2014-01-13 14:15:00	monday
64	30	2014-01-14 08:30:00	tuesday
65	14	2014-01-26 17:45:00	sunday
66	3	2014-01-06 17:00:00	monday
67	22	2014-01-27 16:15:00	monday
68	16	2014-01-28 08:15:00	tuesday
69	11	2014-01-09 12:00:00	thursday
70	39	2014-01-01 15:30:00	wednesday
71	6	2014-01-12 09:30:00	sunday
72	13	2014-01-11 13:00:00	saturday
73	39	2014-01-07 12:30:00	tuesday
74	15	2014-01-21 09:00:00	tuesday
75	2	2014-01-03 13:45:00	friday
76	22	2014-01-22 11:00:00	wednesday
77	35	2014-01-26 11:00:00	sunday
78	5	2014-01-20 08:30:00	monday
79	35	2014-01-10 10:15:00	friday
80	15	2014-01-27 10:45:00	monday
81	26	2014-01-02 08:15:00	thursday
82	19	2014-01-28 15:30:00	tuesday
83	28	2014-01-20 10:45:00	monday
84	26	2014-01-29 13:00:00	wednesday
85	7	2014-01-07 16:30:00	tuesday
86	13	2014-01-18 14:45:00	saturday
87	40	2014-01-29 16:45:00	wednesday
88	25	2014-01-11 09:00:00	saturday
89	19	2014-02-24 09:45:00	monday
90	20	2014-02-27 08:30:00	thursday
91	2	2014-02-23 11:15:00	sunday
92	39	2014-02-13 13:00:00	thursday
93	10	2014-02-13 09:15:00	thursday
94	19	2014-02-01 11:00:00	saturday
95	27	2014-02-14 09:00:00	friday
96	38	2014-02-18 12:45:00	tuesday
97	30	2014-02-03 11:00:00	monday
98	21	2014-02-13 11:30:00	thursday
99	31	2014-02-21 12:15:00	friday
100	25	2014-02-25 11:15:00	tuesday
101	2	2014-02-05 11:30:00	wednesday
102	28	2014-02-17 15:00:00	monday
103	7	2014-02-03 15:15:00	monday
104	19	2014-02-24 17:30:00	monday
105	39	2014-02-22 13:15:00	saturday
106	27	2014-02-16 12:15:00	sunday
107	30	2014-02-25 13:30:00	tuesday
108	21	2014-02-15 15:45:00	saturday
109	9	2014-02-28 10:45:00	friday
110	27	2014-02-13 14:15:00	thursday
111	23	2014-02-23 17:45:00	sunday
112	34	2014-02-07 09:00:00	friday
113	18	2014-02-25 12:15:00	tuesday
114	17	2014-02-20 10:00:00	thursday
115	4	2014-02-22 14:00:00	saturday
116	22	2014-02-19 12:15:00	wednesday
117	20	2014-02-09 14:00:00	sunday
118	29	2014-02-19 13:30:00	wednesday
119	16	2014-02-18 10:00:00	tuesday
120	2	2014-02-01 16:15:00	saturday
121	34	2014-02-05 13:45:00	wednesday
122	19	2014-02-13 15:15:00	thursday
123	14	2014-02-13 08:00:00	thursday
124	25	2014-02-10 17:45:00	monday
125	15	2014-02-21 12:30:00	friday
126	21	2014-02-24 13:00:00	monday
127	15	2014-02-26 12:15:00	wednesday
128	29	2014-02-28 11:45:00	friday
129	37	2014-02-02 17:45:00	sunday
130	30	2014-02-07 11:45:00	friday
131	30	2014-02-21 11:45:00	friday
132	33	2014-02-22 13:45:00	saturday
133	38	2014-02-04 11:15:00	tuesday
134	23	2014-02-28 14:30:00	friday
135	38	2014-02-28 17:45:00	friday
136	7	2014-02-15 13:00:00	saturday
137	22	2014-02-23 15:00:00	sunday
138	21	2014-02-27 10:45:00	thursday
139	25	2014-02-23 13:15:00	sunday
140	2	2014-02-16 14:15:00	sunday
141	5	2014-02-01 13:45:00	saturday
142	8	2014-02-19 10:30:00	wednesday
143	26	2014-02-10 15:00:00	monday
144	28	2014-02-05 16:15:00	wednesday
145	8	2014-02-21 09:00:00	friday
146	12	2014-02-23 10:00:00	sunday
147	19	2014-02-27 11:00:00	thursday
148	33	2014-02-20 14:15:00	thursday
149	16	2014-02-20 10:00:00	thursday
150	12	2014-02-10 09:00:00	monday
151	31	2014-02-04 11:30:00	tuesday
152	1	2014-02-04 08:45:00	tuesday
153	32	2014-02-07 11:00:00	friday
154	40	2014-02-24 09:45:00	monday
155	24	2014-02-28 16:00:00	friday
156	17	2014-02-06 09:45:00	thursday
157	19	2014-02-26 17:00:00	wednesday
158	13	2014-02-15 17:30:00	saturday
159	33	2014-02-25 16:45:00	tuesday
160	26	2014-02-19 12:45:00	wednesday
161	18	2014-02-10 16:15:00	monday
162	21	2014-02-03 08:15:00	monday
163	20	2014-02-02 12:15:00	sunday
164	22	2014-02-14 16:45:00	friday
165	26	2014-02-27 10:15:00	thursday
166	1	2014-02-16 12:15:00	sunday
167	11	2014-02-10 12:45:00	monday
168	17	2014-02-06 13:15:00	thursday
169	3	2014-02-05 09:30:00	wednesday
170	37	2014-02-02 12:00:00	sunday
171	2	2014-02-26 13:00:00	wednesday
172	21	2014-02-25 09:30:00	tuesday
173	24	2014-02-06 11:30:00	thursday
174	12	2014-02-15 11:45:00	saturday
175	35	2014-02-18 11:15:00	tuesday
176	29	2014-03-10 17:45:00	monday
177	29	2014-03-11 12:45:00	tuesday
178	39	2014-03-13 12:30:00	thursday
179	16	2014-03-26 11:00:00	wednesday
180	34	2014-03-05 10:15:00	wednesday
181	27	2014-03-05 17:00:00	wednesday
182	25	2014-03-29 16:15:00	saturday
183	12	2014-03-18 12:45:00	tuesday
184	23	2014-03-01 17:15:00	saturday
185	13	2014-03-25 17:00:00	tuesday
186	4	2014-03-16 12:15:00	sunday
187	9	2014-03-03 11:30:00	monday
188	8	2014-03-13 13:15:00	thursday
189	29	2014-03-21 15:15:00	friday
190	28	2014-03-01 12:45:00	saturday
191	25	2014-03-14 14:00:00	friday
192	21	2014-03-08 12:00:00	saturday
193	30	2014-03-22 08:45:00	saturday
194	10	2014-03-30 12:30:00	sunday
195	16	2014-03-05 08:30:00	wednesday
196	35	2014-03-12 11:00:00	wednesday
197	11	2014-03-04 17:00:00	tuesday
198	34	2014-03-03 08:30:00	monday
199	8	2014-03-01 13:00:00	saturday
200	19	2014-03-19 08:00:00	wednesday
201	38	2014-03-18 12:45:00	tuesday
202	21	2014-03-16 13:15:00	sunday
203	10	2014-03-16 10:45:00	sunday
204	39	2014-03-08 10:45:00	saturday
205	25	2014-03-15 13:15:00	saturday
206	30	2014-03-03 16:00:00	monday
207	35	2014-03-09 13:15:00	sunday
208	28	2014-03-02 17:00:00	sunday
209	8	2014-03-04 16:45:00	tuesday
210	7	2014-03-05 11:30:00	wednesday
211	20	2014-03-25 13:15:00	tuesday
212	25	2014-03-23 15:45:00	sunday
213	36	2014-03-25 16:30:00	tuesday
214	36	2014-03-05 17:30:00	wednesday
215	23	2014-03-29 14:00:00	saturday
216	36	2014-03-25 16:45:00	tuesday
217	15	2014-03-20 14:00:00	thursday
218	23	2014-03-10 15:30:00	monday
219	8	2014-03-15 12:15:00	saturday
220	13	2014-03-21 12:00:00	friday
221	22	2014-03-13 12:30:00	thursday
222	17	2014-03-27 15:45:00	thursday
223	32	2014-03-12 13:30:00	wednesday
224	23	2014-03-30 14:00:00	sunday
225	25	2014-03-05 16:00:00	wednesday
226	6	2014-03-17 08:00:00	monday
227	3	2014-03-11 14:30:00	tuesday
228	38	2014-03-25 09:15:00	tuesday
229	20	2014-03-10 11:15:00	monday
230	40	2014-03-24 13:45:00	monday
231	10	2014-03-24 15:30:00	monday
232	10	2014-03-13 09:30:00	thursday
233	16	2014-03-13 11:15:00	thursday
234	26	2014-03-16 12:30:00	sunday
235	1	2014-03-20 13:30:00	thursday
236	8	2014-03-28 12:45:00	friday
237	17	2014-03-07 13:30:00	friday
238	14	2014-03-03 12:00:00	monday
239	17	2014-03-02 14:00:00	sunday
240	9	2014-03-20 10:00:00	thursday
241	33	2014-03-03 14:30:00	monday
242	7	2014-03-21 16:45:00	friday
243	30	2014-03-11 13:15:00	tuesday
244	40	2014-03-21 10:45:00	friday
245	27	2014-03-01 16:15:00	saturday
246	6	2014-03-18 10:15:00	tuesday
247	17	2014-03-14 10:15:00	friday
248	7	2014-03-11 08:00:00	tuesday
249	33	2014-03-05 13:45:00	wednesday
250	7	2014-03-27 14:00:00	thursday
251	29	2014-03-17 14:00:00	monday
252	33	2014-03-17 11:15:00	monday
253	13	2014-03-07 08:30:00	friday
254	13	2014-03-20 13:30:00	thursday
255	14	2014-03-30 10:30:00	sunday
256	40	2014-03-16 17:30:00	sunday
257	2	2014-03-22 12:00:00	saturday
258	17	2014-04-25 11:00:00	friday
259	12	2014-04-12 15:15:00	saturday
260	7	2014-04-28 09:15:00	monday
261	18	2014-04-22 11:45:00	tuesday
262	30	2014-04-08 14:45:00	tuesday
263	19	2014-04-01 09:15:00	tuesday
264	9	2014-04-17 09:15:00	thursday
265	25	2014-04-24 17:30:00	thursday
266	6	2014-04-01 13:00:00	tuesday
267	38	2014-04-16 11:00:00	wednesday
268	15	2014-04-06 16:45:00	sunday
269	32	2014-04-28 13:45:00	monday
270	21	2014-04-18 14:15:00	friday
271	22	2014-04-02 16:15:00	wednesday
272	29	2014-04-12 09:00:00	saturday
273	2	2014-04-24 17:30:00	thursday
274	12	2014-04-18 16:45:00	friday
275	38	2014-04-16 10:15:00	wednesday
276	4	2014-04-23 11:45:00	wednesday
277	25	2014-04-18 08:45:00	friday
278	7	2014-04-07 09:15:00	monday
279	1	2014-04-06 12:15:00	sunday
280	24	2014-04-01 16:30:00	tuesday
281	40	2014-04-19 13:00:00	saturday
282	39	2014-04-06 08:45:00	sunday
283	18	2014-04-18 12:00:00	friday
284	19	2014-04-30 17:00:00	wednesday
285	18	2014-04-28 14:30:00	monday
286	7	2014-04-07 08:45:00	monday
287	26	2014-04-20 14:15:00	sunday
288	31	2014-04-27 10:00:00	sunday
289	17	2014-04-08 13:00:00	tuesday
290	10	2014-04-09 16:30:00	wednesday
291	4	2014-04-01 15:30:00	tuesday
292	23	2014-04-25 17:00:00	friday
293	8	2014-04-09 15:00:00	wednesday
294	18	2014-04-04 13:30:00	friday
295	11	2014-04-27 12:30:00	sunday
296	21	2014-04-16 14:30:00	wednesday
297	32	2014-04-08 17:45:00	tuesday
298	9	2014-04-01 12:30:00	tuesday
299	17	2014-04-13 12:15:00	sunday
300	37	2014-04-09 11:00:00	wednesday
301	29	2014-04-25 08:15:00	friday
302	2	2014-04-22 15:45:00	tuesday
303	1	2014-04-02 12:45:00	wednesday
304	31	2014-04-01 14:15:00	tuesday
305	16	2014-04-28 10:30:00	monday
306	25	2014-04-13 08:15:00	sunday
307	21	2014-04-13 10:15:00	sunday
308	39	2014-04-08 11:45:00	tuesday
309	6	2014-04-01 17:30:00	tuesday
310	14	2014-04-27 17:30:00	sunday
311	24	2014-04-18 17:45:00	friday
312	24	2014-04-07 10:45:00	monday
313	39	2014-04-11 08:30:00	friday
314	37	2014-04-09 10:30:00	wednesday
315	36	2014-04-19 11:45:00	saturday
316	12	2014-04-17 16:30:00	thursday
317	30	2014-04-20 16:30:00	sunday
318	32	2014-04-13 11:30:00	sunday
319	12	2014-04-16 16:45:00	wednesday
320	13	2014-04-18 16:45:00	friday
321	31	2014-04-03 13:45:00	thursday
322	25	2014-04-30 09:15:00	wednesday
323	26	2014-04-26 08:30:00	saturday
324	37	2014-05-06 13:30:00	tuesday
325	27	2014-05-03 10:30:00	saturday
326	28	2014-05-16 13:30:00	friday
327	17	2014-05-19 14:30:00	monday
328	17	2014-05-07 14:30:00	wednesday
329	13	2014-05-30 17:45:00	friday
330	26	2014-05-26 16:30:00	monday
331	11	2014-05-11 09:45:00	sunday
332	25	2014-05-13 09:30:00	tuesday
333	16	2014-05-02 15:45:00	friday
334	14	2014-05-04 08:15:00	sunday
335	27	2014-05-04 12:15:00	sunday
336	16	2014-05-19 16:15:00	monday
337	30	2014-05-01 10:15:00	thursday
338	27	2014-05-29 14:45:00	thursday
339	27	2014-05-23 12:00:00	friday
340	1	2014-05-20 12:15:00	tuesday
341	17	2014-05-17 09:00:00	saturday
342	19	2014-05-05 17:15:00	monday
343	6	2014-05-15 09:15:00	thursday
344	23	2014-05-04 14:00:00	sunday
345	12	2014-05-30 14:30:00	friday
346	17	2014-05-04 11:00:00	sunday
347	6	2014-05-15 14:30:00	thursday
348	11	2014-05-29 10:15:00	thursday
349	1	2014-05-05 16:30:00	monday
350	15	2014-05-13 14:45:00	tuesday
351	21	2014-05-17 13:45:00	saturday
352	33	2014-05-02 10:30:00	friday
353	12	2014-05-21 13:00:00	wednesday
354	31	2014-05-07 13:00:00	wednesday
355	23	2014-05-22 09:15:00	thursday
356	26	2014-05-16 16:00:00	friday
357	29	2014-05-11 10:00:00	sunday
358	5	2014-05-14 08:15:00	wednesday
359	38	2014-05-26 12:15:00	monday
360	18	2014-05-19 12:00:00	monday
361	9	2014-05-27 09:45:00	tuesday
362	34	2014-05-11 09:00:00	sunday
363	36	2014-05-01 16:30:00	thursday
364	11	2014-05-09 17:45:00	friday
365	2	2014-05-10 11:00:00	saturday
366	33	2014-05-30 08:00:00	friday
367	19	2014-05-23 09:30:00	friday
368	31	2014-05-05 13:00:00	monday
369	1	2014-05-12 08:00:00	monday
370	37	2014-05-06 16:30:00	tuesday
371	7	2014-05-17 14:30:00	saturday
372	1	2014-05-30 09:00:00	friday
373	26	2014-05-07 16:45:00	wednesday
374	8	2014-05-03 14:00:00	saturday
375	2	2014-05-22 15:15:00	thursday
376	20	2014-05-28 09:30:00	wednesday
377	7	2014-05-19 12:45:00	monday
378	12	2014-05-06 17:15:00	tuesday
379	13	2014-05-13 08:30:00	tuesday
380	25	2014-05-19 10:45:00	monday
381	2	2014-05-16 17:30:00	friday
382	37	2014-05-29 10:45:00	thursday
383	5	2014-05-30 08:00:00	friday
384	27	2014-05-10 13:30:00	saturday
385	38	2014-05-11 13:15:00	sunday
386	4	2014-05-29 16:15:00	thursday
387	10	2014-05-10 17:15:00	saturday
388	6	2014-05-10 13:45:00	saturday
389	30	2014-05-19 12:45:00	monday
390	28	2014-05-01 17:00:00	thursday
391	9	2014-05-14 10:30:00	wednesday
392	3	2014-05-29 12:30:00	thursday
393	4	2014-05-11 10:30:00	sunday
394	8	2014-05-08 13:15:00	thursday
395	19	2014-05-09 08:45:00	friday
396	28	2014-05-15 09:45:00	thursday
397	10	2014-05-11 14:30:00	sunday
398	34	2014-05-17 10:15:00	saturday
399	2	2014-05-09 10:00:00	friday
400	37	2014-05-17 12:30:00	saturday
401	19	2014-05-28 17:30:00	wednesday
402	36	2014-05-03 13:30:00	saturday
403	2	2014-05-04 12:30:00	sunday
404	40	2014-05-06 08:30:00	tuesday
405	10	2014-05-27 15:45:00	tuesday
406	34	2014-05-08 13:00:00	thursday
407	28	2014-06-28 12:45:00	saturday
408	39	2014-06-17 11:15:00	tuesday
409	25	2014-06-03 16:15:00	tuesday
410	21	2014-06-05 12:45:00	thursday
411	28	2014-06-10 14:45:00	tuesday
412	37	2014-06-13 15:15:00	friday
413	26	2014-06-30 15:30:00	monday
414	9	2014-06-19 15:30:00	thursday
415	27	2014-06-16 16:15:00	monday
416	28	2014-06-22 10:30:00	sunday
417	32	2014-06-03 12:00:00	tuesday
418	23	2014-06-19 17:15:00	thursday
419	4	2014-06-03 11:45:00	tuesday
420	32	2014-06-11 11:45:00	wednesday
421	29	2014-06-10 13:45:00	tuesday
422	34	2014-06-20 09:15:00	friday
423	3	2014-06-06 15:30:00	friday
424	33	2014-06-20 12:45:00	friday
425	21	2014-06-25 14:15:00	wednesday
426	12	2014-06-15 11:45:00	sunday
427	32	2014-06-14 13:45:00	saturday
428	28	2014-06-18 08:00:00	wednesday
429	9	2014-06-16 14:45:00	monday
430	9	2014-06-12 13:45:00	thursday
431	39	2014-06-27 10:00:00	friday
432	9	2014-06-04 11:00:00	wednesday
433	20	2014-06-12 14:45:00	thursday
434	19	2014-06-10 14:15:00	tuesday
435	3	2014-06-01 17:30:00	sunday
436	13	2014-06-29 08:15:00	sunday
437	17	2014-06-01 08:45:00	sunday
438	11	2014-06-08 11:15:00	sunday
439	21	2014-06-18 11:15:00	wednesday
440	17	2014-06-04 14:45:00	wednesday
441	9	2014-06-23 14:45:00	monday
442	5	2014-06-13 11:00:00	friday
443	8	2014-06-05 12:15:00	thursday
444	40	2014-06-01 12:30:00	sunday
445	16	2014-06-02 11:45:00	monday
446	19	2014-06-16 10:30:00	monday
447	15	2014-06-02 16:30:00	monday
448	20	2014-06-30 16:00:00	monday
449	24	2014-06-07 10:15:00	saturday
450	16	2014-06-20 16:15:00	friday
451	13	2014-06-28 17:45:00	saturday
452	40	2014-06-24 15:45:00	tuesday
453	35	2014-06-29 12:15:00	sunday
454	6	2014-06-18 13:45:00	wednesday
455	19	2014-06-24 16:15:00	tuesday
456	15	2014-06-04 17:15:00	wednesday
457	13	2014-06-07 17:45:00	saturday
458	8	2014-06-01 08:00:00	sunday
459	36	2014-06-18 11:45:00	wednesday
460	34	2014-06-19 15:00:00	thursday
461	38	2014-06-06 14:00:00	friday
462	39	2014-06-30 14:00:00	monday
463	3	2014-06-24 17:45:00	tuesday
464	36	2014-06-28 11:45:00	saturday
465	19	2014-06-08 12:45:00	sunday
466	31	2014-06-08 10:00:00	sunday
467	26	2014-06-20 09:45:00	friday
468	25	2014-06-13 15:30:00	friday
469	6	2014-06-26 09:30:00	thursday
470	19	2014-06-02 13:15:00	monday
471	36	2014-06-27 11:00:00	friday
472	10	2014-06-23 17:15:00	monday
473	16	2014-06-12 13:15:00	thursday
474	12	2014-06-15 16:00:00	sunday
475	3	2014-06-29 14:30:00	sunday
476	25	2014-06-14 16:15:00	saturday
477	13	2014-06-18 17:15:00	wednesday
478	13	2014-06-18 13:15:00	wednesday
479	26	2014-06-17 09:45:00	tuesday
480	10	2014-06-11 14:45:00	wednesday
481	6	2014-06-20 14:45:00	friday
482	32	2014-06-25 08:30:00	wednesday
483	3	2014-06-24 17:45:00	tuesday
484	7	2014-06-06 12:30:00	friday
485	7	2014-06-27 11:00:00	friday
486	33	2014-06-16 09:00:00	monday
487	17	2014-06-27 16:00:00	friday
488	34	2014-06-29 12:30:00	sunday
489	35	2014-06-06 16:45:00	friday
490	33	2014-06-03 15:45:00	tuesday
491	6	2014-07-14 17:45:00	monday
492	30	2014-07-07 09:45:00	monday
493	26	2014-07-14 17:30:00	monday
494	20	2014-07-27 10:15:00	sunday
495	21	2014-07-03 10:45:00	thursday
496	22	2014-07-29 08:45:00	tuesday
497	9	2014-07-03 16:00:00	thursday
498	19	2014-07-21 16:00:00	monday
499	8	2014-07-29 10:15:00	tuesday
500	19	2014-07-11 14:30:00	friday
501	17	2014-07-22 11:45:00	tuesday
502	17	2014-07-10 14:30:00	thursday
503	2	2014-07-02 17:00:00	wednesday
504	25	2014-07-16 09:45:00	wednesday
505	29	2014-07-15 12:45:00	tuesday
506	40	2014-07-28 09:30:00	monday
507	5	2014-07-05 13:00:00	saturday
508	25	2014-07-10 16:15:00	thursday
509	8	2014-07-28 14:30:00	monday
510	28	2014-07-01 11:00:00	tuesday
511	4	2014-07-04 14:00:00	friday
512	15	2014-07-28 13:30:00	monday
513	3	2014-07-05 14:30:00	saturday
514	39	2014-07-27 15:30:00	sunday
515	17	2014-07-19 14:45:00	saturday
516	20	2014-07-28 09:15:00	monday
517	2	2014-07-14 17:30:00	monday
518	18	2014-07-25 16:30:00	friday
519	7	2014-07-25 08:30:00	friday
520	20	2014-07-16 14:15:00	wednesday
521	7	2014-07-28 16:00:00	monday
522	9	2014-07-10 13:30:00	thursday
523	39	2014-07-10 11:00:00	thursday
524	1	2014-07-14 08:45:00	monday
525	5	2014-07-10 10:00:00	thursday
526	39	2014-07-10 14:30:00	thursday
527	6	2014-07-04 09:00:00	friday
528	14	2014-07-18 09:45:00	friday
529	37	2014-07-07 15:15:00	monday
530	36	2014-07-08 17:15:00	tuesday
531	21	2014-07-05 13:30:00	saturday
532	12	2014-07-21 12:00:00	monday
533	3	2014-07-05 11:00:00	saturday
534	13	2014-07-25 14:15:00	friday
535	15	2014-07-25 15:15:00	friday
536	22	2014-07-28 09:15:00	monday
537	17	2014-07-01 14:15:00	tuesday
538	12	2014-07-07 15:30:00	monday
539	5	2014-07-06 13:45:00	sunday
540	31	2014-07-17 15:15:00	thursday
541	17	2014-07-03 16:30:00	thursday
542	19	2014-07-18 08:30:00	friday
543	28	2014-07-16 12:00:00	wednesday
544	2	2014-07-28 08:30:00	monday
545	15	2014-07-05 17:15:00	saturday
546	36	2014-07-15 10:30:00	tuesday
547	29	2014-07-14 11:30:00	monday
548	40	2014-07-05 15:00:00	saturday
549	11	2014-07-19 14:30:00	saturday
550	2	2014-07-08 10:15:00	tuesday
551	18	2014-07-28 11:45:00	monday
552	13	2014-07-07 13:15:00	monday
553	2	2014-07-20 12:15:00	sunday
554	40	2014-07-24 17:15:00	thursday
555	31	2014-07-11 17:30:00	friday
556	27	2014-07-22 13:45:00	tuesday
557	29	2014-07-23 16:00:00	wednesday
558	24	2014-07-25 17:15:00	friday
559	13	2014-07-18 15:30:00	friday
560	20	2014-07-19 14:15:00	saturday
561	16	2014-07-21 14:30:00	monday
562	5	2014-07-17 14:30:00	thursday
563	24	2014-07-22 16:15:00	tuesday
564	3	2014-07-04 14:15:00	friday
565	35	2014-07-24 12:00:00	thursday
566	24	2014-07-11 11:30:00	friday
567	25	2014-07-22 08:15:00	tuesday
568	2	2014-07-25 17:00:00	friday
569	35	2014-07-19 13:15:00	saturday
570	6	2014-07-16 08:15:00	wednesday
571	36	2014-07-09 12:15:00	wednesday
572	20	2014-07-10 10:30:00	thursday
573	9	2014-07-12 16:30:00	saturday
574	31	2014-07-08 11:00:00	tuesday
575	10	2014-07-25 08:15:00	friday
576	3	2014-07-26 08:45:00	saturday
577	9	2014-07-27 17:30:00	sunday
578	15	2014-07-20 13:45:00	sunday
579	39	2014-07-07 13:45:00	monday
580	19	2014-07-22 11:45:00	tuesday
581	3	2014-07-24 17:45:00	thursday
582	40	2014-07-12 12:45:00	saturday
583	36	2014-07-03 13:45:00	thursday
584	36	2014-07-16 15:45:00	wednesday
585	28	2014-07-06 15:15:00	sunday
586	5	2014-07-29 15:45:00	tuesday
587	13	2014-07-17 14:45:00	thursday
588	11	2014-07-06 14:45:00	sunday
589	37	2014-07-05 14:15:00	saturday
590	32	2014-07-23 16:45:00	wednesday
591	19	2014-07-29 12:30:00	tuesday
592	25	2014-08-10 08:00:00	sunday
593	9	2014-08-08 14:00:00	friday
594	27	2014-08-11 12:15:00	monday
595	18	2014-08-22 16:30:00	friday
596	8	2014-08-20 16:00:00	wednesday
597	10	2014-08-30 17:30:00	saturday
598	34	2014-08-19 08:45:00	tuesday
599	3	2014-08-02 08:00:00	saturday
600	36	2014-08-19 13:00:00	tuesday
601	28	2014-08-08 14:45:00	friday
602	22	2014-08-15 14:45:00	friday
603	9	2014-08-17 17:45:00	sunday
604	39	2014-08-28 12:30:00	thursday
605	8	2014-08-22 08:45:00	friday
606	2	2014-08-14 08:30:00	thursday
607	7	2014-08-25 15:30:00	monday
608	4	2014-08-23 14:45:00	saturday
609	17	2014-08-28 17:15:00	thursday
610	1	2014-08-01 13:00:00	friday
611	16	2014-08-05 09:45:00	tuesday
612	20	2014-08-04 16:15:00	monday
613	1	2014-08-22 17:30:00	friday
614	21	2014-08-24 13:00:00	sunday
615	37	2014-08-06 10:45:00	wednesday
616	34	2014-08-30 17:00:00	saturday
617	12	2014-08-23 08:45:00	saturday
618	1	2014-08-26 09:00:00	tuesday
619	33	2014-08-27 12:30:00	wednesday
620	9	2014-08-06 14:30:00	wednesday
621	3	2014-08-15 09:45:00	friday
622	38	2014-08-19 08:30:00	tuesday
623	7	2014-08-12 11:15:00	tuesday
624	20	2014-08-06 17:00:00	wednesday
625	1	2014-08-09 10:15:00	saturday
626	9	2014-08-22 10:15:00	friday
627	10	2014-08-26 17:00:00	tuesday
628	5	2014-08-26 13:00:00	tuesday
629	24	2014-08-08 15:00:00	friday
630	34	2014-08-10 11:15:00	sunday
631	19	2014-08-12 14:00:00	tuesday
632	29	2014-08-15 08:45:00	friday
633	11	2014-08-21 13:00:00	thursday
634	29	2014-08-17 16:45:00	sunday
635	37	2014-08-09 13:15:00	saturday
636	9	2014-08-08 08:45:00	friday
637	13	2014-08-20 17:45:00	wednesday
638	28	2014-08-07 14:00:00	thursday
639	11	2014-08-21 08:45:00	thursday
640	18	2014-08-01 13:30:00	friday
641	16	2014-08-16 09:45:00	saturday
642	26	2014-08-05 12:45:00	tuesday
643	23	2014-08-21 12:15:00	thursday
644	35	2014-08-22 16:15:00	friday
645	22	2014-08-20 17:15:00	wednesday
646	17	2014-08-23 10:15:00	saturday
647	20	2014-08-15 11:00:00	friday
648	14	2014-08-08 15:00:00	friday
649	34	2014-08-23 13:15:00	saturday
650	19	2014-08-29 16:00:00	friday
651	4	2014-08-11 15:15:00	monday
652	22	2014-08-24 17:30:00	sunday
653	23	2014-08-11 08:15:00	monday
654	35	2014-08-20 14:00:00	wednesday
655	2	2014-08-26 10:00:00	tuesday
656	14	2014-08-29 08:30:00	friday
657	39	2014-08-14 17:30:00	thursday
658	20	2014-08-25 17:15:00	monday
659	32	2014-08-21 12:15:00	thursday
660	15	2014-08-24 15:15:00	sunday
661	28	2014-08-09 17:30:00	saturday
662	25	2014-08-07 10:00:00	thursday
663	17	2014-08-05 17:45:00	tuesday
664	13	2014-08-25 08:15:00	monday
665	1	2014-08-29 15:15:00	friday
666	34	2014-08-28 16:30:00	thursday
667	15	2014-08-16 09:45:00	saturday
668	9	2014-08-07 10:00:00	thursday
669	9	2014-08-07 12:30:00	thursday
670	36	2014-08-14 09:00:00	thursday
671	21	2014-09-24 10:45:00	wednesday
672	7	2014-09-18 14:30:00	thursday
673	5	2014-09-01 14:15:00	monday
674	1	2014-09-05 15:15:00	friday
675	29	2014-09-30 13:15:00	tuesday
676	9	2014-09-21 15:00:00	sunday
677	25	2014-09-19 09:00:00	friday
678	26	2014-09-22 09:30:00	monday
679	10	2014-09-25 16:15:00	thursday
680	1	2014-09-23 09:00:00	tuesday
681	39	2014-09-03 08:30:00	wednesday
682	28	2014-09-02 10:30:00	tuesday
683	30	2014-09-28 08:00:00	sunday
684	18	2014-09-11 12:00:00	thursday
685	10	2014-09-20 10:45:00	saturday
686	31	2014-09-12 16:00:00	friday
687	3	2014-09-18 16:00:00	thursday
688	38	2014-09-14 09:30:00	sunday
689	35	2014-09-01 15:45:00	monday
690	39	2014-09-30 12:30:00	tuesday
691	5	2014-09-10 17:45:00	wednesday
692	16	2014-09-17 15:00:00	wednesday
693	14	2014-09-16 10:15:00	tuesday
694	14	2014-09-14 12:15:00	sunday
695	6	2014-09-29 16:00:00	monday
696	3	2014-09-03 17:15:00	wednesday
697	29	2014-09-15 15:00:00	monday
698	22	2014-09-18 10:00:00	thursday
699	16	2014-09-13 08:30:00	saturday
700	40	2014-09-08 14:45:00	monday
701	27	2014-09-24 14:00:00	wednesday
702	19	2014-09-08 16:15:00	monday
703	29	2014-09-17 08:15:00	wednesday
704	35	2014-09-29 12:45:00	monday
705	25	2014-09-10 08:30:00	wednesday
706	30	2014-09-14 10:15:00	sunday
707	25	2014-09-26 13:30:00	friday
708	29	2014-09-28 16:45:00	sunday
709	3	2014-09-07 14:15:00	sunday
710	19	2014-09-22 13:00:00	monday
711	6	2014-09-28 11:30:00	sunday
712	26	2014-09-26 08:00:00	friday
713	27	2014-09-23 16:45:00	tuesday
714	27	2014-09-30 17:15:00	tuesday
715	38	2014-09-26 11:15:00	friday
716	4	2014-09-24 11:15:00	wednesday
717	3	2014-09-30 16:15:00	tuesday
718	25	2014-09-06 08:45:00	saturday
719	11	2014-09-14 15:00:00	sunday
720	5	2014-09-29 09:00:00	monday
721	31	2014-09-17 16:45:00	wednesday
722	23	2014-09-26 08:15:00	friday
723	1	2014-09-01 08:00:00	monday
724	40	2014-09-03 10:45:00	wednesday
725	23	2014-09-08 14:45:00	monday
726	9	2014-09-26 10:45:00	friday
727	33	2014-09-16 15:30:00	tuesday
728	7	2014-09-04 08:15:00	thursday
729	40	2014-09-20 14:00:00	saturday
730	17	2014-09-08 13:45:00	monday
731	39	2014-09-09 15:00:00	tuesday
732	13	2014-09-03 09:30:00	wednesday
733	35	2014-09-18 15:45:00	thursday
734	32	2014-09-08 15:00:00	monday
735	21	2014-09-10 09:30:00	wednesday
736	5	2014-09-21 16:15:00	sunday
737	36	2014-09-13 12:30:00	saturday
738	2	2014-09-13 08:45:00	saturday
739	20	2014-09-25 09:45:00	thursday
740	24	2014-09-22 10:15:00	monday
741	35	2014-09-15 08:45:00	monday
742	17	2014-09-19 16:15:00	friday
743	33	2014-09-29 11:30:00	monday
744	18	2014-09-04 13:45:00	thursday
745	5	2014-09-24 17:15:00	wednesday
746	16	2014-09-20 10:30:00	saturday
747	4	2014-09-30 08:00:00	tuesday
748	37	2014-09-12 13:30:00	friday
749	19	2014-09-24 11:45:00	wednesday
750	1	2014-09-12 11:15:00	friday
751	33	2014-09-27 10:15:00	saturday
752	2	2014-09-09 16:15:00	tuesday
753	16	2014-09-06 15:15:00	saturday
754	39	2014-09-11 14:30:00	thursday
755	35	2014-09-06 12:00:00	saturday
756	22	2014-09-21 17:00:00	sunday
757	39	2014-09-12 17:30:00	friday
758	27	2014-09-09 11:45:00	tuesday
759	11	2014-09-13 14:15:00	saturday
760	26	2014-09-04 10:30:00	thursday
761	9	2014-10-03 10:30:00	friday
762	2	2014-10-13 16:45:00	monday
763	5	2014-10-11 11:15:00	saturday
764	9	2014-10-16 12:15:00	thursday
765	27	2014-10-02 14:45:00	thursday
766	20	2014-10-29 11:00:00	wednesday
767	18	2014-10-29 12:15:00	wednesday
768	6	2014-10-17 17:45:00	friday
769	5	2014-10-06 12:00:00	monday
770	29	2014-10-11 13:00:00	saturday
771	21	2014-10-26 12:45:00	sunday
772	10	2014-10-26 16:30:00	sunday
773	34	2014-10-29 12:00:00	wednesday
774	15	2014-10-27 13:00:00	monday
775	34	2014-10-14 13:45:00	tuesday
776	24	2014-10-06 15:00:00	monday
777	30	2014-10-10 13:45:00	friday
778	4	2014-10-07 16:30:00	tuesday
779	25	2014-10-06 10:15:00	monday
780	28	2014-10-21 09:30:00	tuesday
781	2	2014-10-28 12:30:00	tuesday
782	24	2014-10-11 10:30:00	saturday
783	6	2014-10-23 11:30:00	thursday
784	6	2014-10-16 09:00:00	thursday
785	8	2014-10-18 15:30:00	saturday
786	36	2014-10-08 15:30:00	wednesday
787	12	2014-10-30 11:15:00	thursday
788	19	2014-10-05 12:45:00	sunday
789	21	2014-10-02 16:15:00	thursday
790	20	2014-10-20 08:15:00	monday
791	28	2014-10-27 12:00:00	monday
792	12	2014-10-11 08:30:00	saturday
793	17	2014-10-01 13:30:00	wednesday
794	9	2014-10-20 10:30:00	monday
795	9	2014-10-22 13:45:00	wednesday
796	28	2014-10-20 10:45:00	monday
797	32	2014-10-19 17:15:00	sunday
798	38	2014-10-14 09:00:00	tuesday
799	14	2014-10-03 10:45:00	friday
800	13	2014-10-22 16:00:00	wednesday
801	28	2014-10-06 13:45:00	monday
802	14	2014-10-19 12:45:00	sunday
803	13	2014-10-23 17:00:00	thursday
804	2	2014-10-25 12:45:00	saturday
805	7	2014-10-08 17:00:00	wednesday
806	11	2014-10-05 09:45:00	sunday
807	1	2014-10-16 16:15:00	thursday
808	37	2014-10-17 10:45:00	friday
809	5	2014-10-04 15:30:00	saturday
810	15	2014-10-16 12:30:00	thursday
811	13	2014-10-01 13:30:00	wednesday
812	1	2014-10-06 08:45:00	monday
813	30	2014-10-25 14:00:00	saturday
814	22	2014-10-15 10:15:00	wednesday
815	34	2014-10-17 09:30:00	friday
816	9	2014-10-11 10:15:00	saturday
817	15	2014-10-06 13:15:00	monday
818	33	2014-10-25 08:30:00	saturday
819	19	2014-10-01 09:00:00	wednesday
820	22	2014-10-04 14:45:00	saturday
821	25	2014-10-08 13:15:00	wednesday
822	35	2014-10-09 08:45:00	thursday
823	19	2014-10-11 17:00:00	saturday
824	20	2014-10-20 16:00:00	monday
825	16	2014-10-03 16:00:00	friday
826	31	2014-10-29 13:00:00	wednesday
827	12	2014-10-09 17:00:00	thursday
828	12	2014-10-25 13:45:00	saturday
829	12	2014-10-18 17:00:00	saturday
830	23	2014-10-05 14:00:00	sunday
831	33	2014-10-27 08:15:00	monday
832	2	2014-10-23 16:15:00	thursday
833	10	2014-10-02 09:15:00	thursday
834	37	2014-10-08 10:00:00	wednesday
835	36	2014-10-08 11:00:00	wednesday
836	24	2014-10-14 14:00:00	tuesday
837	19	2014-10-19 14:00:00	sunday
838	13	2014-10-28 09:45:00	tuesday
839	23	2014-10-30 11:15:00	thursday
840	40	2014-11-21 14:15:00	friday
841	26	2014-11-08 12:00:00	saturday
842	40	2014-11-24 09:30:00	monday
843	7	2014-11-07 14:00:00	friday
844	21	2014-11-09 08:30:00	sunday
845	18	2014-11-27 10:30:00	thursday
846	34	2014-11-16 14:45:00	sunday
847	27	2014-11-13 16:45:00	thursday
848	34	2014-11-22 12:15:00	saturday
849	12	2014-11-15 12:45:00	saturday
850	19	2014-11-27 12:15:00	thursday
851	40	2014-11-05 13:45:00	wednesday
852	32	2014-11-18 13:15:00	tuesday
853	36	2014-11-21 16:00:00	friday
854	25	2014-11-02 15:30:00	sunday
855	40	2014-11-02 11:45:00	sunday
856	18	2014-11-13 16:15:00	thursday
857	12	2014-11-04 15:30:00	tuesday
858	35	2014-11-17 12:15:00	monday
859	37	2014-11-13 15:15:00	thursday
860	4	2014-11-29 17:00:00	saturday
861	39	2014-11-12 08:45:00	wednesday
862	22	2014-11-24 14:15:00	monday
863	10	2014-11-22 11:15:00	saturday
864	6	2014-11-29 08:00:00	saturday
865	22	2014-11-27 13:00:00	thursday
866	27	2014-11-05 14:45:00	wednesday
867	16	2014-11-16 13:45:00	sunday
868	21	2014-11-02 15:00:00	sunday
869	37	2014-11-23 11:45:00	sunday
870	22	2014-11-01 11:00:00	saturday
871	36	2014-11-27 11:45:00	thursday
872	2	2014-11-06 10:00:00	thursday
873	22	2014-11-19 13:15:00	wednesday
874	16	2014-11-19 08:30:00	wednesday
875	31	2014-11-25 13:15:00	tuesday
876	32	2014-11-03 12:00:00	monday
877	4	2014-11-21 09:45:00	friday
878	20	2014-11-03 17:00:00	monday
879	12	2014-11-19 11:30:00	wednesday
880	9	2014-11-26 17:00:00	wednesday
881	8	2014-11-02 15:30:00	sunday
882	13	2014-11-04 14:00:00	tuesday
883	4	2014-11-17 11:45:00	monday
884	8	2014-11-06 12:00:00	thursday
885	38	2014-11-27 08:30:00	thursday
886	37	2014-11-08 15:00:00	saturday
887	28	2014-11-17 13:45:00	monday
888	31	2014-11-18 15:00:00	tuesday
889	32	2014-11-17 08:15:00	monday
890	22	2014-11-24 17:15:00	monday
891	13	2014-11-23 16:30:00	sunday
892	9	2014-11-19 11:30:00	wednesday
893	8	2014-11-06 15:30:00	thursday
894	4	2014-11-10 10:00:00	monday
895	9	2014-11-11 14:45:00	tuesday
896	9	2014-11-21 13:15:00	friday
897	9	2014-11-20 15:15:00	thursday
898	16	2014-11-17 12:15:00	monday
899	28	2014-11-06 16:45:00	thursday
900	8	2014-11-24 10:45:00	monday
901	22	2014-11-20 17:45:00	thursday
902	29	2014-11-10 11:15:00	monday
903	39	2014-11-21 10:15:00	friday
904	34	2014-11-21 08:30:00	friday
905	1	2014-11-17 11:15:00	monday
906	38	2014-11-02 13:30:00	sunday
907	22	2014-11-05 11:00:00	wednesday
908	9	2014-11-19 10:45:00	wednesday
909	12	2014-11-30 10:15:00	sunday
910	37	2014-11-06 10:15:00	thursday
911	2	2014-11-16 12:15:00	sunday
912	15	2014-11-16 08:30:00	sunday
913	26	2014-11-29 09:45:00	saturday
914	12	2014-11-09 13:00:00	sunday
915	39	2014-11-24 16:00:00	monday
916	7	2014-11-27 17:00:00	thursday
917	38	2014-11-02 10:45:00	sunday
918	15	2014-11-27 17:00:00	thursday
919	14	2014-11-19 10:30:00	wednesday
920	3	2014-11-04 11:45:00	tuesday
921	25	2014-11-26 10:00:00	wednesday
922	15	2014-11-23 09:15:00	sunday
923	27	2014-11-22 09:15:00	saturday
924	6	2014-11-08 10:45:00	saturday
925	32	2014-11-29 14:30:00	saturday
926	8	2014-11-03 12:00:00	monday
927	15	2014-11-27 10:45:00	thursday
928	2	2014-11-30 08:00:00	sunday
929	27	2014-11-22 12:15:00	saturday
930	3	2014-11-21 15:00:00	friday
931	14	2014-11-07 16:30:00	friday
932	18	2014-11-23 12:30:00	sunday
933	21	2014-12-03 08:00:00	wednesday
934	35	2014-12-25 14:15:00	thursday
935	1	2014-12-03 17:00:00	wednesday
936	33	2014-12-16 08:15:00	tuesday
937	34	2014-12-07 11:30:00	sunday
938	3	2014-12-13 12:00:00	saturday
939	19	2014-12-26 11:15:00	friday
940	32	2014-12-02 15:45:00	tuesday
941	11	2014-12-17 09:30:00	wednesday
942	36	2014-12-15 14:15:00	monday
943	32	2014-12-10 10:15:00	wednesday
944	27	2014-12-07 09:15:00	sunday
945	3	2014-12-09 13:15:00	tuesday
946	27	2014-12-14 14:15:00	sunday
947	24	2014-12-15 08:15:00	monday
948	20	2014-12-12 13:30:00	friday
949	12	2014-12-07 11:15:00	sunday
950	32	2014-12-05 09:30:00	friday
951	7	2014-12-23 17:45:00	tuesday
952	5	2014-12-01 10:00:00	monday
953	18	2014-12-03 10:15:00	wednesday
954	15	2014-12-11 17:30:00	thursday
955	8	2014-12-05 09:00:00	friday
956	40	2014-12-03 15:00:00	wednesday
957	30	2014-12-24 12:30:00	wednesday
958	27	2014-12-27 09:45:00	saturday
959	36	2014-12-01 08:15:00	monday
960	2	2014-12-23 10:15:00	tuesday
961	11	2014-12-01 10:30:00	monday
962	36	2014-12-08 11:15:00	monday
963	30	2014-12-15 11:30:00	monday
964	27	2014-12-16 16:45:00	tuesday
965	35	2014-12-18 11:15:00	thursday
966	31	2014-12-03 08:15:00	wednesday
967	9	2014-12-19 16:15:00	friday
968	6	2014-12-27 11:15:00	saturday
969	17	2014-12-13 15:15:00	saturday
970	38	2014-12-07 16:30:00	sunday
971	23	2014-12-28 14:00:00	sunday
972	30	2014-12-04 10:00:00	thursday
973	16	2014-12-08 08:15:00	monday
974	10	2014-12-03 15:30:00	wednesday
975	19	2014-12-17 17:30:00	wednesday
976	38	2014-12-13 13:45:00	saturday
977	18	2014-12-14 10:30:00	sunday
978	7	2014-12-02 14:30:00	tuesday
979	16	2014-12-11 16:15:00	thursday
980	7	2014-12-05 14:00:00	friday
981	25	2014-12-03 12:15:00	wednesday
982	40	2014-12-21 15:00:00	sunday
983	7	2014-12-16 14:30:00	tuesday
984	21	2014-12-01 09:00:00	monday
985	33	2014-12-11 11:00:00	thursday
986	14	2014-12-21 08:45:00	sunday
987	11	2014-12-19 10:30:00	friday
988	26	2014-12-17 15:30:00	wednesday
989	10	2014-12-22 10:15:00	monday
990	28	2014-12-01 11:30:00	monday
991	39	2014-12-12 17:15:00	friday
992	32	2014-12-01 08:45:00	monday
993	9	2014-12-03 12:45:00	wednesday
994	28	2014-12-05 13:00:00	friday
995	37	2014-12-21 10:45:00	sunday
996	10	2014-12-30 11:45:00	tuesday
997	23	2014-12-12 13:00:00	friday
998	26	2014-12-03 15:45:00	wednesday
999	8	2014-12-04 12:30:00	thursday
1000	2	2014-12-05 14:15:00	friday
1001	26	2015-01-05 15:45:00	monday
1002	18	2015-01-01 17:45:00	thursday
1003	38	2015-01-12 16:45:00	monday
1004	26	2015-01-15 17:30:00	thursday
1005	36	2015-01-25 15:15:00	sunday
1006	39	2015-01-11 11:15:00	sunday
1007	24	2015-01-20 17:00:00	tuesday
1008	1	2015-01-22 11:45:00	thursday
1009	40	2015-01-08 09:30:00	thursday
1010	19	2015-01-29 08:15:00	thursday
1011	10	2015-01-12 15:45:00	monday
1012	24	2015-01-09 12:15:00	friday
1013	40	2015-01-19 10:15:00	monday
1014	40	2015-01-06 16:00:00	tuesday
1015	36	2015-01-21 11:15:00	wednesday
1016	26	2015-01-10 17:30:00	saturday
1017	30	2015-01-08 12:00:00	thursday
1018	34	2015-01-02 08:00:00	friday
1019	11	2015-01-18 17:30:00	sunday
1020	18	2015-01-05 13:45:00	monday
1021	5	2015-01-19 12:00:00	monday
1022	10	2015-01-16 12:00:00	friday
1023	15	2015-01-21 12:00:00	wednesday
1024	1	2015-01-30 16:30:00	friday
1025	40	2015-01-04 16:15:00	sunday
1026	19	2015-01-30 17:15:00	friday
1027	5	2015-01-27 15:15:00	tuesday
1028	11	2015-01-02 12:15:00	friday
1029	40	2015-01-12 11:00:00	monday
1030	40	2015-01-01 10:15:00	thursday
1031	13	2015-01-19 13:45:00	monday
1032	33	2015-01-06 09:45:00	tuesday
1033	33	2015-01-29 15:30:00	thursday
1034	18	2015-01-05 09:45:00	monday
1035	27	2015-01-15 09:45:00	thursday
1036	7	2015-01-14 13:45:00	wednesday
1037	29	2015-02-06 09:00:00	friday
1038	14	2015-02-17 09:00:00	tuesday
1039	26	2015-02-26 15:00:00	thursday
1040	7	2015-02-12 17:45:00	thursday
1041	7	2015-02-16 14:15:00	monday
1042	20	2015-02-13 15:30:00	friday
1043	27	2015-02-14 11:30:00	saturday
1044	27	2015-02-05 11:15:00	thursday
1045	8	2015-02-02 15:45:00	monday
1046	33	2015-02-12 17:00:00	thursday
1047	26	2015-02-05 12:15:00	thursday
1048	38	2015-02-28 14:15:00	saturday
1049	4	2015-02-08 13:00:00	sunday
1050	37	2015-02-20 11:45:00	friday
1051	24	2015-02-01 12:15:00	sunday
1052	10	2015-02-17 11:30:00	tuesday
1053	5	2015-02-18 08:30:00	wednesday
1054	28	2015-02-12 14:00:00	thursday
1055	16	2015-02-21 14:30:00	saturday
1056	2	2015-02-22 15:15:00	sunday
1057	38	2015-02-06 17:30:00	friday
1058	16	2015-02-06 16:00:00	friday
1059	5	2015-02-16 15:30:00	monday
1060	1	2015-02-14 08:30:00	saturday
1061	40	2015-02-15 15:00:00	sunday
1062	11	2015-02-10 15:15:00	tuesday
1063	10	2015-02-03 12:45:00	tuesday
1064	32	2015-02-22 11:00:00	sunday
1065	7	2015-02-07 14:30:00	saturday
1066	17	2015-02-07 12:45:00	saturday
1067	24	2015-02-14 08:45:00	saturday
1068	18	2015-02-14 12:15:00	saturday
1069	37	2015-02-05 11:30:00	thursday
1070	19	2015-02-20 09:00:00	friday
1071	10	2015-02-18 12:00:00	wednesday
1072	3	2015-02-24 16:45:00	tuesday
1073	28	2015-02-22 16:00:00	sunday
1074	28	2015-02-28 12:00:00	saturday
1075	19	2015-02-23 09:45:00	monday
1076	20	2015-02-19 11:30:00	thursday
1077	40	2015-02-07 08:15:00	saturday
1078	15	2015-02-07 09:45:00	saturday
1079	13	2015-02-19 14:15:00	thursday
1080	16	2015-02-16 09:00:00	monday
1081	25	2015-02-24 14:30:00	tuesday
1082	14	2015-02-11 13:45:00	wednesday
1083	3	2015-02-13 09:30:00	friday
1084	25	2015-02-07 16:45:00	saturday
1085	28	2015-02-21 14:30:00	saturday
1086	20	2015-02-23 09:30:00	monday
1087	8	2015-02-21 11:45:00	saturday
1088	25	2015-02-14 16:00:00	saturday
1089	19	2015-02-28 12:00:00	saturday
1090	19	2015-02-09 13:15:00	monday
1091	28	2015-02-25 16:30:00	wednesday
1092	21	2015-02-20 16:45:00	friday
1093	39	2015-02-09 14:00:00	monday
1094	13	2015-02-16 13:15:00	monday
1095	37	2015-02-17 16:15:00	tuesday
1096	5	2015-02-14 13:15:00	saturday
1097	11	2015-02-15 09:45:00	sunday
1098	14	2015-03-06 13:30:00	friday
1099	19	2015-03-19 17:15:00	thursday
1100	12	2015-03-05 17:00:00	thursday
1101	35	2015-03-12 16:00:00	thursday
1102	23	2015-03-23 14:15:00	monday
1103	33	2015-03-15 17:30:00	sunday
1104	30	2015-03-18 12:15:00	wednesday
1105	16	2015-03-17 08:30:00	tuesday
1106	35	2015-03-27 11:45:00	friday
1107	1	2015-03-23 12:30:00	monday
1108	11	2015-03-11 13:45:00	wednesday
1109	5	2015-03-29 10:15:00	sunday
1110	13	2015-03-24 15:15:00	tuesday
1111	8	2015-03-02 16:00:00	monday
1112	24	2015-03-06 09:00:00	friday
1113	29	2015-03-29 17:30:00	sunday
1114	7	2015-03-14 09:15:00	saturday
1115	29	2015-03-10 09:15:00	tuesday
1116	6	2015-03-18 11:30:00	wednesday
1117	2	2015-03-25 17:30:00	wednesday
1118	27	2015-03-02 14:45:00	monday
1119	37	2015-03-28 10:15:00	saturday
1120	39	2015-03-07 12:30:00	saturday
1121	22	2015-03-23 10:00:00	monday
1122	29	2015-03-02 12:30:00	monday
1123	26	2015-03-21 17:00:00	saturday
1124	23	2015-03-07 08:00:00	saturday
1125	12	2015-03-01 10:15:00	sunday
1126	6	2015-03-02 09:30:00	monday
1127	38	2015-03-24 15:15:00	tuesday
1128	24	2015-03-19 08:00:00	thursday
1129	30	2015-03-24 17:00:00	tuesday
1130	1	2015-03-04 11:30:00	wednesday
1131	28	2015-03-23 11:45:00	monday
1132	13	2015-03-10 14:15:00	tuesday
1133	32	2015-03-12 11:45:00	thursday
1134	1	2015-03-28 17:00:00	saturday
1135	38	2015-03-24 10:45:00	tuesday
1136	7	2015-03-09 14:15:00	monday
1137	27	2015-03-06 17:30:00	friday
1138	32	2015-03-22 09:30:00	sunday
1139	38	2015-03-01 09:15:00	sunday
1140	1	2015-03-22 12:30:00	sunday
1141	18	2015-03-09 16:00:00	monday
1142	33	2015-03-02 15:30:00	monday
1143	32	2015-03-09 09:00:00	monday
1144	23	2015-03-26 17:45:00	thursday
1145	31	2015-03-20 11:00:00	friday
1146	13	2015-03-06 16:45:00	friday
1147	30	2015-03-25 15:15:00	wednesday
1148	25	2015-03-29 17:30:00	sunday
1149	22	2015-03-28 17:15:00	saturday
1150	1	2015-03-02 09:00:00	monday
1151	34	2015-04-07 10:00:00	tuesday
1152	28	2015-04-22 13:00:00	wednesday
1153	39	2015-04-13 17:00:00	monday
1154	21	2015-04-26 16:00:00	sunday
1155	38	2015-04-24 08:30:00	friday
1156	9	2015-04-22 15:30:00	wednesday
1157	31	2015-04-13 11:30:00	monday
1158	5	2015-04-12 16:00:00	sunday
1159	6	2015-04-02 10:30:00	thursday
1160	10	2015-04-06 16:45:00	monday
1161	32	2015-04-22 17:30:00	wednesday
1162	11	2015-04-20 09:00:00	monday
1163	36	2015-04-26 08:45:00	sunday
1164	35	2015-04-07 12:30:00	tuesday
1165	27	2015-04-15 15:15:00	wednesday
1166	26	2015-04-20 15:30:00	monday
1167	17	2015-04-05 08:15:00	sunday
1168	38	2015-04-15 10:45:00	wednesday
1169	4	2015-04-13 12:15:00	monday
1170	4	2015-04-26 09:45:00	sunday
1171	10	2015-04-06 12:00:00	monday
1172	38	2015-04-22 11:45:00	wednesday
1173	21	2015-04-28 13:00:00	tuesday
1174	3	2015-04-06 12:00:00	monday
1175	23	2015-04-09 12:15:00	thursday
1176	12	2015-04-25 14:00:00	saturday
1177	8	2015-04-02 10:30:00	thursday
1178	3	2015-04-06 16:00:00	monday
1179	21	2015-04-23 10:00:00	thursday
1180	11	2015-04-13 15:00:00	monday
1181	24	2015-04-09 11:45:00	thursday
1182	13	2015-04-14 17:30:00	tuesday
1183	37	2015-04-09 12:00:00	thursday
1184	39	2015-04-24 11:45:00	friday
1185	24	2015-04-12 11:45:00	sunday
1186	12	2015-04-24 13:15:00	friday
1187	9	2015-04-23 10:30:00	thursday
1188	24	2015-04-24 08:00:00	friday
1189	1	2015-04-26 12:30:00	sunday
1190	35	2015-04-14 09:15:00	tuesday
1191	37	2015-04-10 09:15:00	friday
1192	27	2015-04-24 10:30:00	friday
1193	40	2015-04-08 08:00:00	wednesday
1194	36	2015-04-30 10:45:00	thursday
1195	34	2015-04-19 09:00:00	sunday
1196	17	2015-05-21 09:15:00	thursday
1197	21	2015-05-08 15:00:00	friday
1198	1	2015-05-17 13:15:00	sunday
1199	27	2015-05-11 15:15:00	monday
1200	37	2015-05-21 17:30:00	thursday
1201	3	2015-05-20 10:15:00	wednesday
1202	6	2015-05-15 14:30:00	friday
1203	36	2015-05-21 12:15:00	thursday
1204	33	2015-05-06 17:30:00	wednesday
1205	30	2015-05-01 08:45:00	friday
1206	4	2015-05-04 11:30:00	monday
1207	13	2015-05-01 12:45:00	friday
1208	16	2015-05-09 12:45:00	saturday
1209	39	2015-05-06 09:30:00	wednesday
1210	6	2015-05-10 08:15:00	sunday
1211	2	2015-05-27 11:30:00	wednesday
1212	4	2015-05-17 08:45:00	sunday
1213	33	2015-05-24 17:45:00	sunday
1214	23	2015-05-07 10:00:00	thursday
1215	30	2015-05-20 17:15:00	wednesday
1216	24	2015-05-16 11:30:00	saturday
1217	30	2015-05-07 13:15:00	thursday
1218	1	2015-05-17 12:30:00	sunday
1219	34	2015-05-14 12:30:00	thursday
1220	39	2015-05-12 16:30:00	tuesday
1221	18	2015-05-30 12:30:00	saturday
1222	7	2015-05-11 17:00:00	monday
1223	17	2015-05-04 17:00:00	monday
1224	26	2015-05-03 14:00:00	sunday
1225	30	2015-05-28 11:15:00	thursday
1226	35	2015-05-11 09:15:00	monday
1227	15	2015-05-23 12:15:00	saturday
1228	29	2015-05-19 10:30:00	tuesday
1229	5	2015-05-04 16:15:00	monday
1230	7	2015-05-28 08:00:00	thursday
1231	20	2015-05-20 16:45:00	wednesday
1232	9	2015-05-03 09:30:00	sunday
1233	25	2015-05-16 09:15:00	saturday
1234	38	2015-05-26 15:30:00	tuesday
1235	20	2015-05-17 11:15:00	sunday
1236	34	2015-05-01 13:45:00	friday
1237	38	2015-05-16 10:45:00	saturday
1238	35	2015-05-16 15:45:00	saturday
1239	33	2015-05-08 10:00:00	friday
1240	2	2015-05-12 13:15:00	tuesday
1241	21	2015-05-05 16:00:00	tuesday
1242	24	2015-05-12 16:00:00	tuesday
1243	6	2015-05-11 11:15:00	monday
1244	35	2015-05-18 17:00:00	monday
1245	24	2015-05-08 14:30:00	friday
1246	24	2015-05-24 13:30:00	sunday
1247	30	2015-05-19 10:15:00	tuesday
1248	8	2015-05-13 12:00:00	wednesday
1249	12	2015-05-18 11:45:00	monday
1250	29	2015-05-01 08:45:00	friday
1251	34	2015-05-10 13:00:00	sunday
1252	19	2015-05-09 10:30:00	saturday
1253	25	2015-05-18 10:15:00	monday
1254	1	2015-05-06 11:00:00	wednesday
1255	5	2015-05-01 15:30:00	friday
1256	40	2015-06-24 09:45:00	wednesday
1257	35	2015-06-23 11:15:00	tuesday
1258	16	2015-06-14 15:00:00	sunday
1259	10	2015-06-03 16:00:00	wednesday
1260	23	2015-06-16 13:30:00	tuesday
1261	36	2015-06-10 17:45:00	wednesday
1262	19	2015-06-07 09:00:00	sunday
1263	11	2015-06-07 14:30:00	sunday
1264	36	2015-06-16 11:15:00	tuesday
1265	6	2015-06-07 15:00:00	sunday
1266	37	2015-06-13 13:30:00	saturday
1267	19	2015-06-09 12:15:00	tuesday
1268	34	2015-06-24 13:15:00	wednesday
1269	20	2015-06-21 15:30:00	sunday
1270	9	2015-06-15 12:00:00	monday
1271	12	2015-06-11 08:45:00	thursday
1272	35	2015-06-23 14:00:00	tuesday
1273	9	2015-06-12 12:30:00	friday
1274	25	2015-06-09 13:30:00	tuesday
1275	25	2015-06-13 17:00:00	saturday
1276	9	2015-06-03 13:45:00	wednesday
1277	30	2015-06-26 16:15:00	friday
1278	40	2015-06-24 14:15:00	wednesday
1279	12	2015-06-12 16:15:00	friday
1280	30	2015-06-14 11:45:00	sunday
1281	39	2015-06-27 16:00:00	saturday
1282	7	2015-06-26 10:15:00	friday
1283	8	2015-06-08 14:00:00	monday
1284	31	2015-06-23 13:00:00	tuesday
1285	23	2015-06-30 11:00:00	tuesday
1286	27	2015-06-28 16:00:00	sunday
1287	31	2015-06-13 08:15:00	saturday
1288	4	2015-06-13 15:00:00	saturday
1289	6	2015-06-25 17:45:00	thursday
1290	28	2015-06-16 16:00:00	tuesday
1291	20	2015-06-25 17:15:00	thursday
1292	40	2015-06-12 09:15:00	friday
1293	9	2015-06-02 17:15:00	tuesday
1294	30	2015-06-17 13:00:00	wednesday
1295	33	2015-06-21 16:30:00	sunday
1296	30	2015-06-04 16:00:00	thursday
1297	33	2015-06-19 13:15:00	friday
1298	35	2015-06-27 09:30:00	saturday
1299	8	2015-06-22 16:45:00	monday
1300	1	2015-06-15 16:45:00	monday
1301	33	2015-06-15 12:15:00	monday
1302	22	2015-06-03 09:30:00	wednesday
1303	37	2015-06-05 12:45:00	friday
1304	10	2015-06-01 16:00:00	monday
1305	3	2015-06-06 11:45:00	saturday
1306	24	2015-06-28 11:30:00	sunday
1307	26	2015-06-08 12:30:00	monday
1308	13	2015-06-07 15:15:00	sunday
1309	19	2015-06-05 12:15:00	friday
1310	14	2015-06-08 09:30:00	monday
1311	33	2015-06-02 14:15:00	tuesday
1312	35	2015-06-18 16:30:00	thursday
1313	10	2015-06-29 12:45:00	monday
1314	40	2015-06-15 14:45:00	monday
1315	12	2015-06-19 08:45:00	friday
1316	16	2015-06-20 09:45:00	saturday
1317	35	2015-06-19 16:15:00	friday
1318	10	2015-07-19 17:15:00	sunday
1319	7	2015-07-17 14:15:00	friday
1320	14	2015-07-17 17:45:00	friday
1321	24	2015-07-25 17:00:00	saturday
1322	6	2015-07-13 10:00:00	monday
1323	20	2015-07-02 08:30:00	thursday
1324	15	2015-07-14 10:30:00	tuesday
1325	36	2015-07-16 08:15:00	thursday
1326	7	2015-07-24 11:00:00	friday
1327	21	2015-07-13 16:45:00	monday
1328	30	2015-07-14 15:30:00	tuesday
1329	18	2015-07-03 15:45:00	friday
1330	23	2015-07-30 16:45:00	thursday
1331	28	2015-07-23 14:45:00	thursday
1332	14	2015-07-09 14:15:00	thursday
1333	20	2015-07-15 13:45:00	wednesday
1334	32	2015-07-02 12:30:00	thursday
1335	21	2015-07-29 11:15:00	wednesday
1336	24	2015-07-21 12:15:00	tuesday
1337	36	2015-07-20 09:00:00	monday
1338	6	2015-07-18 09:00:00	saturday
1339	17	2015-07-23 11:30:00	thursday
1340	31	2015-07-03 16:45:00	friday
1341	30	2015-07-06 12:15:00	monday
1342	10	2015-07-01 13:45:00	wednesday
1343	4	2015-07-14 15:00:00	tuesday
1344	15	2015-07-06 15:45:00	monday
1345	26	2015-07-06 08:00:00	monday
1346	23	2015-07-11 13:45:00	saturday
1347	8	2015-07-29 11:00:00	wednesday
1348	25	2015-07-07 17:30:00	tuesday
1349	37	2015-07-16 11:15:00	thursday
1350	8	2015-07-01 14:45:00	wednesday
1351	38	2015-07-07 12:00:00	tuesday
1352	23	2015-07-19 17:00:00	sunday
1353	16	2015-07-11 09:00:00	saturday
1354	39	2015-07-24 12:00:00	friday
1355	11	2015-07-24 11:45:00	friday
1356	37	2015-07-24 09:30:00	friday
1357	15	2015-07-21 10:15:00	tuesday
1358	39	2015-07-21 16:15:00	tuesday
1359	15	2015-07-20 17:15:00	monday
1360	21	2015-07-04 12:00:00	saturday
1361	26	2015-07-08 13:45:00	wednesday
1362	18	2015-07-15 10:15:00	wednesday
1363	7	2015-07-29 14:45:00	wednesday
1364	25	2015-07-10 16:30:00	friday
1365	38	2015-07-10 15:00:00	friday
1366	18	2015-07-01 08:45:00	wednesday
1367	19	2015-07-28 13:45:00	tuesday
1368	28	2015-07-26 13:15:00	sunday
1369	4	2015-07-19 17:00:00	sunday
1370	2	2015-07-07 13:15:00	tuesday
1371	24	2015-07-17 09:00:00	friday
1372	8	2015-07-24 09:15:00	friday
1373	15	2015-07-02 09:30:00	thursday
1374	29	2015-07-28 10:45:00	tuesday
1375	30	2015-07-23 12:30:00	thursday
1376	17	2015-08-07 15:15:00	friday
1377	2	2015-08-22 13:30:00	saturday
1378	5	2015-08-05 09:45:00	wednesday
1379	1	2015-08-09 11:00:00	sunday
1380	31	2015-08-24 13:30:00	monday
1381	30	2015-08-14 14:15:00	friday
1382	37	2015-08-17 09:15:00	monday
1383	4	2015-08-30 12:15:00	sunday
1384	39	2015-08-06 14:15:00	thursday
1385	31	2015-08-07 16:15:00	friday
1386	39	2015-08-27 17:45:00	thursday
1387	8	2015-08-14 15:45:00	friday
1388	9	2015-08-21 16:00:00	friday
1389	15	2015-08-15 16:15:00	saturday
1390	5	2015-08-02 09:45:00	sunday
1391	16	2015-08-23 11:30:00	sunday
1392	34	2015-08-03 10:15:00	monday
1393	9	2015-08-01 10:45:00	saturday
1394	19	2015-08-07 13:45:00	friday
1395	16	2015-08-05 14:45:00	wednesday
1396	35	2015-08-15 11:00:00	saturday
1397	30	2015-08-19 17:15:00	wednesday
1398	18	2015-08-19 12:15:00	wednesday
1399	32	2015-08-17 10:15:00	monday
1400	31	2015-08-13 10:00:00	thursday
1401	34	2015-08-02 15:00:00	sunday
1402	21	2015-08-15 16:00:00	saturday
1403	20	2015-08-29 15:45:00	saturday
1404	24	2015-08-01 11:15:00	saturday
1405	7	2015-08-28 17:00:00	friday
1406	7	2015-08-24 10:30:00	monday
1407	22	2015-08-01 16:15:00	saturday
1408	17	2015-08-30 17:15:00	sunday
1409	39	2015-08-24 16:45:00	monday
1410	10	2015-08-15 15:30:00	saturday
1411	25	2015-08-23 13:45:00	sunday
1412	12	2015-08-19 10:45:00	wednesday
1413	30	2015-08-23 10:45:00	sunday
1414	40	2015-08-25 17:00:00	tuesday
1415	32	2015-08-10 11:45:00	monday
1416	5	2015-08-06 09:30:00	thursday
1417	37	2015-08-24 13:00:00	monday
1418	37	2015-08-07 16:45:00	friday
1419	28	2015-08-15 16:00:00	saturday
1420	28	2015-08-21 16:00:00	friday
1421	14	2015-08-16 13:00:00	sunday
1422	34	2015-08-16 09:45:00	sunday
1423	40	2015-08-10 13:15:00	monday
1424	22	2015-08-21 15:30:00	friday
1425	6	2015-08-07 11:00:00	friday
1426	26	2015-08-13 12:15:00	thursday
1427	15	2015-08-08 15:15:00	saturday
1428	12	2015-08-05 14:45:00	wednesday
1429	5	2015-08-15 10:45:00	saturday
1430	24	2015-08-05 09:15:00	wednesday
1431	11	2015-08-05 15:30:00	wednesday
1432	8	2015-08-14 10:00:00	friday
1433	39	2015-08-20 15:45:00	thursday
1434	14	2015-09-17 10:15:00	thursday
1435	39	2015-09-04 16:15:00	friday
1436	14	2015-09-03 09:15:00	thursday
1437	21	2015-09-13 17:00:00	sunday
1438	7	2015-09-18 16:00:00	friday
1439	21	2015-09-12 16:45:00	saturday
1440	40	2015-09-08 12:00:00	tuesday
1441	4	2015-09-28 09:15:00	monday
1442	20	2015-09-29 08:15:00	tuesday
1443	8	2015-09-14 11:45:00	monday
1444	8	2015-09-27 11:15:00	sunday
1445	4	2015-09-30 17:45:00	wednesday
1446	34	2015-09-29 10:15:00	tuesday
1447	18	2015-09-02 11:00:00	wednesday
1448	9	2015-09-07 11:15:00	monday
1449	16	2015-09-18 15:00:00	friday
1450	25	2015-09-22 16:00:00	tuesday
1451	14	2015-09-24 11:45:00	thursday
1452	38	2015-09-01 17:15:00	tuesday
1453	4	2015-09-19 12:45:00	saturday
1454	5	2015-09-03 17:45:00	thursday
1455	14	2015-09-11 11:15:00	friday
1456	8	2015-09-29 12:30:00	tuesday
1457	33	2015-09-19 17:15:00	saturday
1458	32	2015-09-07 09:30:00	monday
1459	21	2015-09-09 09:45:00	wednesday
1460	18	2015-09-17 10:45:00	thursday
1461	34	2015-09-03 14:45:00	thursday
1462	37	2015-09-03 11:15:00	thursday
1463	29	2015-09-15 17:30:00	tuesday
1464	24	2015-09-19 10:00:00	saturday
1465	18	2015-09-10 16:30:00	thursday
1466	14	2015-09-18 12:45:00	friday
1467	33	2015-09-09 11:15:00	wednesday
1468	27	2015-09-03 12:30:00	thursday
1469	10	2015-09-07 09:00:00	monday
1470	13	2015-09-13 08:15:00	sunday
1471	11	2015-09-23 15:15:00	wednesday
1472	37	2015-09-08 11:00:00	tuesday
1473	6	2015-09-18 13:00:00	friday
1474	6	2015-09-20 13:15:00	sunday
1475	5	2015-09-14 11:30:00	monday
1476	10	2015-09-29 17:00:00	tuesday
1477	24	2015-09-09 13:45:00	wednesday
1478	34	2015-09-18 12:30:00	friday
1479	3	2015-09-02 10:00:00	wednesday
1480	28	2015-09-08 16:45:00	tuesday
1481	3	2015-09-15 10:00:00	tuesday
1482	36	2015-09-04 10:00:00	friday
1483	39	2015-09-03 12:30:00	thursday
1484	21	2015-09-27 14:15:00	sunday
1485	16	2015-09-11 12:00:00	friday
1486	31	2015-09-20 12:30:00	sunday
1487	35	2015-09-23 16:30:00	wednesday
1488	9	2015-09-08 16:45:00	tuesday
1489	35	2015-10-02 09:00:00	friday
1490	21	2015-10-20 10:00:00	tuesday
1491	9	2015-10-14 10:45:00	wednesday
1492	40	2015-10-07 12:45:00	wednesday
1493	6	2015-10-16 09:15:00	friday
1494	32	2015-10-11 17:45:00	sunday
1495	5	2015-10-14 15:15:00	wednesday
1496	22	2015-10-21 09:15:00	wednesday
1497	19	2015-10-25 16:00:00	sunday
1498	36	2015-10-13 08:30:00	tuesday
1499	25	2015-10-29 12:00:00	thursday
1500	30	2015-10-10 11:45:00	saturday
1501	6	2015-10-07 16:00:00	wednesday
1502	34	2015-10-12 13:15:00	monday
1503	30	2015-10-12 09:30:00	monday
1504	25	2015-10-11 17:15:00	sunday
1505	16	2015-10-03 10:00:00	saturday
1506	30	2015-10-29 08:45:00	thursday
1507	1	2015-10-01 12:00:00	thursday
1508	19	2015-10-10 11:30:00	saturday
1509	35	2015-10-15 17:00:00	thursday
1510	16	2015-10-27 14:30:00	tuesday
1511	27	2015-10-03 11:00:00	saturday
1512	14	2015-10-01 15:45:00	thursday
1513	28	2015-10-22 10:45:00	thursday
1514	5	2015-10-20 11:00:00	tuesday
1515	14	2015-10-05 14:15:00	monday
1516	36	2015-10-14 17:45:00	wednesday
1517	27	2015-10-09 08:00:00	friday
1518	7	2015-10-21 11:45:00	wednesday
1519	38	2015-10-18 16:15:00	sunday
1520	8	2015-10-09 08:30:00	friday
1521	4	2015-10-05 08:15:00	monday
1522	24	2015-10-28 12:45:00	wednesday
1523	12	2015-10-27 09:15:00	tuesday
1524	12	2015-10-10 12:00:00	saturday
1525	16	2015-10-03 10:45:00	saturday
1526	18	2015-10-20 09:30:00	tuesday
1527	20	2015-10-27 08:00:00	tuesday
1528	27	2015-10-08 10:45:00	thursday
1529	20	2015-10-24 16:30:00	saturday
1530	17	2015-10-23 09:45:00	friday
1531	7	2015-10-10 15:15:00	saturday
1532	39	2015-10-23 15:45:00	friday
1533	16	2015-10-01 14:45:00	thursday
1534	22	2015-10-12 15:00:00	monday
1535	17	2015-10-17 16:15:00	saturday
1536	4	2015-10-16 17:45:00	friday
1537	23	2015-10-07 13:45:00	wednesday
1538	12	2015-10-05 08:15:00	monday
1539	19	2015-10-30 13:30:00	friday
1540	10	2015-10-01 10:30:00	thursday
1541	29	2015-10-08 12:30:00	thursday
1542	30	2015-10-13 09:45:00	tuesday
1543	9	2015-10-23 08:00:00	friday
1544	6	2015-11-20 14:45:00	friday
1545	27	2015-11-25 10:15:00	wednesday
1546	13	2015-11-04 16:45:00	wednesday
1547	12	2015-11-12 17:30:00	thursday
1548	17	2015-11-12 17:15:00	thursday
1549	4	2015-11-19 13:00:00	thursday
1550	22	2015-11-09 13:45:00	monday
1551	39	2015-11-18 12:30:00	wednesday
1552	29	2015-11-06 12:00:00	friday
1553	11	2015-11-30 17:15:00	monday
1554	33	2015-11-24 08:45:00	tuesday
1555	22	2015-11-17 13:45:00	tuesday
1556	30	2015-11-20 17:30:00	friday
1557	17	2015-11-05 17:00:00	thursday
1558	3	2015-11-14 10:45:00	saturday
1559	17	2015-11-11 15:45:00	wednesday
1560	38	2015-11-24 10:45:00	tuesday
1561	34	2015-11-12 14:15:00	thursday
1562	12	2015-11-25 15:45:00	wednesday
1563	12	2015-11-12 15:45:00	thursday
1564	16	2015-11-15 09:15:00	sunday
1565	24	2015-11-06 14:45:00	friday
1566	8	2015-11-30 17:00:00	monday
1567	18	2015-11-09 13:00:00	monday
1568	21	2015-11-14 12:00:00	saturday
1569	38	2015-11-12 09:30:00	thursday
1570	25	2015-11-21 13:15:00	saturday
1571	20	2015-11-15 15:15:00	sunday
1572	32	2015-11-11 16:45:00	wednesday
1573	13	2015-11-17 09:15:00	tuesday
1574	9	2015-11-22 08:45:00	sunday
1575	29	2015-11-11 13:30:00	wednesday
1576	36	2015-11-04 16:45:00	wednesday
1577	1	2015-11-27 13:15:00	friday
1578	4	2015-11-28 08:45:00	saturday
1579	32	2015-11-23 16:45:00	monday
1580	12	2015-11-04 10:45:00	wednesday
1581	4	2015-11-24 10:15:00	tuesday
1582	27	2015-11-20 13:30:00	friday
1583	23	2015-11-24 09:15:00	tuesday
1584	10	2015-11-12 09:15:00	thursday
1585	24	2015-11-15 09:45:00	sunday
1586	26	2015-11-04 15:30:00	wednesday
1587	13	2015-11-19 09:00:00	thursday
1588	31	2015-11-14 15:45:00	saturday
1589	16	2015-11-04 12:15:00	wednesday
1590	17	2015-11-15 15:45:00	sunday
1591	13	2015-11-23 09:45:00	monday
1592	24	2015-11-30 14:30:00	monday
1593	23	2015-11-08 17:15:00	sunday
1594	38	2015-11-12 12:00:00	thursday
1595	32	2015-11-06 09:00:00	friday
1596	30	2015-11-13 16:45:00	friday
1597	39	2015-11-25 10:00:00	wednesday
1598	32	2015-11-19 17:15:00	thursday
1599	33	2015-11-19 15:15:00	thursday
1600	20	2015-11-12 13:30:00	thursday
1601	34	2015-11-11 13:30:00	wednesday
1602	4	2015-12-10 12:45:00	thursday
1603	19	2015-12-28 15:15:00	monday
1604	12	2015-12-11 14:30:00	friday
1605	20	2015-12-20 15:30:00	sunday
1606	27	2015-12-24 08:00:00	thursday
1607	24	2015-12-01 15:15:00	tuesday
1608	17	2015-12-26 16:30:00	saturday
1609	37	2015-12-06 14:15:00	sunday
1610	33	2015-12-03 16:15:00	thursday
1611	11	2015-12-19 09:15:00	saturday
1612	6	2015-12-02 13:30:00	wednesday
1613	18	2015-12-28 16:30:00	monday
1614	23	2015-12-29 16:15:00	tuesday
1615	30	2015-12-13 10:00:00	sunday
1616	36	2015-12-11 09:15:00	friday
1617	36	2015-12-05 12:45:00	saturday
1618	8	2015-12-15 16:15:00	tuesday
1619	28	2015-12-30 15:00:00	wednesday
1620	7	2015-12-25 15:00:00	friday
1621	38	2015-12-22 12:45:00	tuesday
1622	23	2015-12-28 09:00:00	monday
1623	7	2015-12-18 09:45:00	friday
1624	8	2015-12-07 12:30:00	monday
1625	3	2015-12-13 15:15:00	sunday
1626	22	2015-12-19 13:30:00	saturday
1627	2	2015-12-11 14:00:00	friday
1628	19	2015-12-21 13:30:00	monday
1629	37	2015-12-19 09:00:00	saturday
1630	39	2015-12-18 12:30:00	friday
1631	15	2015-12-08 11:15:00	tuesday
1632	34	2015-12-21 11:15:00	monday
1633	30	2015-12-24 09:45:00	thursday
1634	38	2015-12-19 10:00:00	saturday
1635	16	2015-12-04 10:45:00	friday
1636	15	2015-12-12 12:00:00	saturday
1637	17	2015-12-26 17:30:00	saturday
1638	36	2015-12-26 14:15:00	saturday
1639	17	2015-12-30 14:15:00	wednesday
1640	21	2015-12-29 15:30:00	tuesday
1641	24	2015-12-03 08:45:00	thursday
1642	12	2015-12-09 09:00:00	wednesday
1643	36	2015-12-01 13:00:00	tuesday
1644	22	2015-12-11 12:15:00	friday
1645	15	2015-12-08 12:00:00	tuesday
1646	17	2015-12-22 08:45:00	tuesday
1647	3	2015-12-28 17:30:00	monday
1648	21	2015-12-14 15:15:00	monday
1649	23	2015-12-26 10:00:00	saturday
1650	37	2015-12-07 10:30:00	monday
1651	40	2016-01-29 16:00:00	friday
1652	30	2016-01-24 08:30:00	sunday
1653	13	2016-01-01 08:15:00	friday
1654	14	2016-01-04 13:00:00	monday
1655	8	2016-01-27 15:15:00	wednesday
1656	14	2016-01-07 15:30:00	thursday
1657	28	2016-01-29 16:15:00	friday
1658	6	2016-01-10 09:00:00	sunday
1659	21	2016-01-19 16:00:00	tuesday
1660	39	2016-01-07 17:45:00	thursday
1661	34	2016-01-10 13:15:00	sunday
1662	29	2016-01-15 15:45:00	friday
1663	26	2016-01-16 09:30:00	saturday
1664	4	2016-01-05 14:15:00	tuesday
1665	1	2016-01-22 11:15:00	friday
1666	36	2016-01-12 11:30:00	tuesday
1667	10	2016-01-11 17:30:00	monday
1668	30	2016-01-30 09:00:00	saturday
1669	11	2016-01-09 13:15:00	saturday
1670	38	2016-01-27 16:30:00	wednesday
1671	6	2016-01-13 09:00:00	wednesday
1672	17	2016-01-25 13:45:00	monday
1673	28	2016-01-25 12:30:00	monday
1674	22	2016-01-18 10:00:00	monday
1675	33	2016-01-01 16:00:00	friday
1676	39	2016-01-19 10:00:00	tuesday
1677	29	2016-01-12 14:15:00	tuesday
1678	14	2016-01-29 09:15:00	friday
1679	39	2016-01-09 12:30:00	saturday
1680	34	2016-01-20 13:15:00	wednesday
1681	33	2016-01-21 11:15:00	thursday
1682	33	2016-01-11 08:00:00	monday
1683	17	2016-01-11 15:45:00	monday
1684	37	2016-01-02 11:00:00	saturday
1685	11	2016-01-01 17:00:00	friday
1686	1	2016-01-08 14:45:00	friday
1687	17	2016-01-10 09:45:00	sunday
1688	27	2016-01-29 16:45:00	friday
1689	21	2016-01-29 17:30:00	friday
1690	17	2016-01-11 08:15:00	monday
1691	11	2016-01-07 16:45:00	thursday
1692	38	2016-01-22 15:00:00	friday
1693	34	2016-01-12 11:45:00	tuesday
1694	35	2016-01-13 11:00:00	wednesday
1695	9	2016-01-16 17:30:00	saturday
1696	16	2016-01-25 14:45:00	monday
1697	36	2016-01-21 11:45:00	thursday
1698	10	2016-01-27 13:15:00	wednesday
1699	37	2016-01-11 11:15:00	monday
1700	28	2016-01-13 12:30:00	wednesday
1701	29	2016-01-13 12:00:00	wednesday
1702	32	2016-01-21 17:00:00	thursday
1703	34	2016-01-21 09:00:00	thursday
1704	37	2016-01-01 14:15:00	friday
1705	32	2016-01-09 13:45:00	saturday
1706	32	2016-01-21 13:45:00	thursday
1707	11	2016-01-03 08:45:00	sunday
1708	12	2016-01-30 16:00:00	saturday
1709	40	2016-01-15 13:15:00	friday
1710	20	2016-01-21 16:30:00	thursday
1711	1	2016-01-21 17:00:00	thursday
1712	37	2016-01-18 11:45:00	monday
1713	15	2016-01-11 14:30:00	monday
1714	39	2016-01-24 14:45:00	sunday
1715	40	2016-01-05 13:15:00	tuesday
1716	10	2016-01-17 10:45:00	sunday
1717	8	2016-01-13 16:15:00	wednesday
1718	11	2016-01-02 09:30:00	saturday
1719	33	2016-01-05 09:45:00	tuesday
1720	6	2016-01-15 13:00:00	friday
1721	5	2016-01-06 17:30:00	wednesday
1722	35	2016-01-10 15:30:00	sunday
1723	24	2016-01-17 15:00:00	sunday
1724	27	2016-01-22 12:15:00	friday
1725	16	2016-01-19 12:30:00	tuesday
1726	25	2016-01-16 10:30:00	saturday
1727	15	2016-01-06 13:15:00	wednesday
1728	3	2016-01-13 14:00:00	wednesday
1729	37	2016-01-08 12:15:00	friday
1730	39	2016-01-26 11:30:00	tuesday
1731	16	2016-01-25 08:30:00	monday
1732	17	2016-01-16 13:00:00	saturday
1733	21	2016-01-10 15:15:00	sunday
1734	17	2016-01-09 11:00:00	saturday
1735	21	2016-01-14 11:15:00	thursday
1736	23	2016-01-12 09:30:00	tuesday
1737	27	2016-01-06 12:00:00	wednesday
1738	33	2016-01-24 12:45:00	sunday
1739	35	2016-02-05 11:30:00	friday
1740	32	2016-02-01 09:15:00	monday
1741	34	2016-02-04 10:00:00	thursday
1742	1	2016-02-06 13:45:00	saturday
1743	10	2016-02-13 11:45:00	saturday
1744	23	2016-02-27 16:30:00	saturday
1745	20	2016-02-28 11:45:00	sunday
1746	11	2016-02-01 12:15:00	monday
1747	21	2016-02-11 15:30:00	thursday
1748	30	2016-02-07 08:30:00	sunday
1749	4	2016-02-08 16:00:00	monday
1750	3	2016-02-23 16:30:00	tuesday
1751	31	2016-02-11 16:00:00	thursday
1752	8	2016-02-20 10:45:00	saturday
1753	27	2016-02-25 12:00:00	thursday
1754	3	2016-02-06 17:15:00	saturday
1755	19	2016-02-02 16:45:00	tuesday
1756	30	2016-02-13 11:30:00	saturday
1757	37	2016-02-02 11:15:00	tuesday
1758	37	2016-02-25 11:45:00	thursday
1759	26	2016-02-07 12:15:00	sunday
1760	28	2016-02-28 12:45:00	sunday
1761	5	2016-02-25 08:45:00	thursday
1762	35	2016-02-22 14:15:00	monday
1763	8	2016-02-12 11:00:00	friday
1764	4	2016-02-04 08:30:00	thursday
1765	4	2016-02-01 12:30:00	monday
1766	33	2016-02-08 13:30:00	monday
1767	15	2016-02-05 10:30:00	friday
1768	32	2016-02-15 15:15:00	monday
1769	21	2016-02-28 08:45:00	sunday
1770	8	2016-02-14 12:30:00	sunday
1771	33	2016-02-02 15:15:00	tuesday
1772	11	2016-02-16 12:15:00	tuesday
1773	18	2016-02-17 15:00:00	wednesday
1774	20	2016-02-09 08:45:00	tuesday
1775	9	2016-02-12 15:00:00	friday
1776	24	2016-02-08 10:45:00	monday
1777	15	2016-02-10 15:30:00	wednesday
1778	38	2016-02-26 13:15:00	friday
1779	1	2016-02-08 14:45:00	monday
1780	33	2016-02-23 12:30:00	tuesday
1781	37	2016-02-06 10:00:00	saturday
1782	2	2016-02-24 08:30:00	wednesday
1783	4	2016-02-14 15:00:00	sunday
1784	8	2016-02-11 08:45:00	thursday
1785	24	2016-02-19 16:30:00	friday
1786	17	2016-02-16 09:00:00	tuesday
1787	37	2016-02-27 08:30:00	saturday
1788	16	2016-02-16 12:45:00	tuesday
1789	1	2016-02-08 08:45:00	monday
1790	7	2016-02-04 09:45:00	thursday
1791	37	2016-02-02 13:45:00	tuesday
1792	28	2016-02-25 12:00:00	thursday
1793	19	2016-02-11 12:45:00	thursday
1794	29	2016-02-19 14:00:00	friday
1795	40	2016-02-17 10:45:00	wednesday
1796	29	2016-02-25 12:45:00	thursday
1797	17	2016-02-15 08:45:00	monday
1798	31	2016-02-14 14:00:00	sunday
1799	39	2016-02-16 08:15:00	tuesday
1800	15	2016-02-06 11:30:00	saturday
1801	37	2016-02-06 10:30:00	saturday
1802	38	2016-02-25 15:00:00	thursday
1803	6	2016-02-16 13:45:00	tuesday
1804	36	2016-02-06 12:15:00	saturday
1805	33	2016-02-07 17:45:00	sunday
1806	37	2016-02-17 16:30:00	wednesday
1807	31	2016-02-16 16:15:00	tuesday
1808	31	2016-02-01 16:00:00	monday
1809	9	2016-02-12 08:00:00	friday
1810	24	2016-02-18 17:15:00	thursday
1811	28	2016-02-18 09:30:00	thursday
1812	9	2016-02-08 11:30:00	monday
1813	6	2016-02-08 13:45:00	monday
1814	39	2016-02-26 11:15:00	friday
1815	15	2016-02-02 09:15:00	tuesday
1816	30	2016-02-07 11:15:00	sunday
1817	27	2016-02-21 14:30:00	sunday
1818	6	2016-02-03 08:30:00	wednesday
1819	21	2016-02-24 08:00:00	wednesday
1820	32	2016-02-03 16:00:00	wednesday
1821	11	2016-03-06 10:00:00	sunday
1822	24	2016-03-26 09:45:00	saturday
1823	38	2016-03-04 16:15:00	friday
1824	26	2016-03-07 13:30:00	monday
1825	32	2016-03-23 15:45:00	wednesday
1826	30	2016-03-08 10:00:00	tuesday
1827	13	2016-03-17 17:45:00	thursday
1828	37	2016-03-06 15:45:00	sunday
1829	36	2016-03-19 11:00:00	saturday
1830	11	2016-03-30 16:00:00	wednesday
1831	14	2016-03-28 17:15:00	monday
1832	37	2016-03-20 09:15:00	sunday
1833	19	2016-03-20 15:15:00	sunday
1834	26	2016-03-26 16:15:00	saturday
1835	1	2016-03-10 17:00:00	thursday
1836	36	2016-03-17 12:00:00	thursday
1837	14	2016-03-06 15:45:00	sunday
1838	6	2016-03-03 09:15:00	thursday
1839	11	2016-03-14 15:15:00	monday
1840	36	2016-03-24 10:30:00	thursday
1841	9	2016-03-16 11:30:00	wednesday
1842	16	2016-03-25 09:00:00	friday
1843	13	2016-03-06 08:00:00	sunday
1844	25	2016-03-25 11:30:00	friday
1845	5	2016-03-21 17:00:00	monday
1846	11	2016-03-20 11:45:00	sunday
1847	17	2016-03-06 09:00:00	sunday
1848	27	2016-03-03 16:15:00	thursday
1849	21	2016-03-22 12:45:00	tuesday
1850	2	2016-03-15 11:15:00	tuesday
1851	19	2016-03-17 13:00:00	thursday
1852	7	2016-03-20 13:15:00	sunday
1853	19	2016-03-15 11:00:00	tuesday
1854	23	2016-03-18 16:00:00	friday
1855	21	2016-03-18 11:45:00	friday
1856	23	2016-03-08 13:30:00	tuesday
1857	27	2016-03-04 10:30:00	friday
1858	21	2016-03-17 12:45:00	thursday
1859	1	2016-03-21 11:15:00	monday
1860	28	2016-03-27 15:45:00	sunday
1861	39	2016-03-06 15:45:00	sunday
1862	22	2016-03-14 14:45:00	monday
1863	27	2016-03-06 14:15:00	sunday
1864	1	2016-03-25 11:15:00	friday
1865	32	2016-03-25 10:30:00	friday
1866	13	2016-03-17 15:15:00	thursday
1867	27	2016-03-04 16:30:00	friday
1868	34	2016-03-21 15:30:00	monday
1869	26	2016-03-05 12:15:00	saturday
1870	36	2016-03-26 14:45:00	saturday
1871	21	2016-03-17 14:00:00	thursday
1872	32	2016-03-14 16:30:00	monday
1873	23	2016-03-11 08:45:00	friday
1874	22	2016-03-09 14:00:00	wednesday
1875	12	2016-03-19 09:30:00	saturday
1876	22	2016-03-09 08:30:00	wednesday
1877	34	2016-03-22 11:15:00	tuesday
1878	29	2016-03-27 17:30:00	sunday
1879	10	2016-03-09 10:00:00	wednesday
1880	31	2016-03-22 15:30:00	tuesday
1881	5	2016-03-21 10:30:00	monday
1882	4	2016-03-02 11:30:00	wednesday
1883	8	2016-03-07 08:00:00	monday
1884	13	2016-03-26 10:00:00	saturday
1885	26	2016-03-26 14:15:00	saturday
1886	21	2016-03-15 09:00:00	tuesday
1887	35	2016-03-03 15:30:00	thursday
1888	26	2016-03-05 12:30:00	saturday
1889	29	2016-03-03 11:45:00	thursday
1890	19	2016-03-21 11:15:00	monday
1891	4	2016-03-06 15:45:00	sunday
1892	25	2016-03-29 17:15:00	tuesday
1893	31	2016-03-22 17:30:00	tuesday
1894	16	2016-03-23 10:15:00	wednesday
1895	38	2016-03-29 09:00:00	tuesday
1896	36	2016-03-08 14:00:00	tuesday
1897	19	2016-03-13 14:15:00	sunday
1898	30	2016-03-10 13:30:00	thursday
1899	19	2016-03-17 08:45:00	thursday
1900	31	2016-03-17 10:00:00	thursday
1901	36	2016-03-08 09:00:00	tuesday
1902	1	2016-03-11 12:15:00	friday
1903	31	2016-03-10 14:45:00	thursday
1904	35	2016-03-17 09:45:00	thursday
1905	20	2016-03-05 16:00:00	saturday
1906	35	2016-03-15 13:00:00	tuesday
1907	34	2016-03-08 09:30:00	tuesday
1908	11	2016-03-05 13:30:00	saturday
1909	22	2016-04-08 11:15:00	friday
1910	6	2016-04-08 08:30:00	friday
1911	40	2016-04-12 15:15:00	tuesday
1912	1	2016-04-29 11:15:00	friday
1913	4	2016-04-20 13:45:00	wednesday
1914	20	2016-04-27 17:45:00	wednesday
1915	4	2016-04-09 14:45:00	saturday
1916	33	2016-04-08 15:30:00	friday
1917	16	2016-04-04 17:15:00	monday
1918	33	2016-04-03 15:30:00	sunday
1919	32	2016-04-10 13:00:00	sunday
1920	12	2016-04-10 11:45:00	sunday
1921	37	2016-04-11 13:45:00	monday
1922	15	2016-04-20 14:00:00	wednesday
1923	29	2016-04-23 14:30:00	saturday
1924	28	2016-04-18 16:00:00	monday
1925	14	2016-04-04 12:15:00	monday
1926	32	2016-04-25 15:45:00	monday
1927	8	2016-04-19 16:45:00	tuesday
1928	30	2016-04-21 09:30:00	thursday
1929	13	2016-04-12 16:30:00	tuesday
1930	14	2016-04-24 14:45:00	sunday
1931	10	2016-04-26 14:30:00	tuesday
1932	18	2016-04-06 10:00:00	wednesday
1933	37	2016-04-14 13:00:00	thursday
1934	37	2016-04-06 10:30:00	wednesday
1935	14	2016-04-11 11:00:00	monday
1936	36	2016-04-27 10:15:00	wednesday
1937	40	2016-04-29 14:15:00	friday
1938	38	2016-04-06 10:30:00	wednesday
1939	38	2016-04-13 08:15:00	wednesday
1940	38	2016-04-24 16:00:00	sunday
1941	32	2016-04-20 10:00:00	wednesday
1942	5	2016-04-24 13:30:00	sunday
1943	6	2016-04-10 13:15:00	sunday
1944	10	2016-04-15 11:00:00	friday
1945	17	2016-04-15 11:15:00	friday
1946	19	2016-04-22 08:45:00	friday
1947	14	2016-04-14 14:30:00	thursday
1948	19	2016-04-27 11:15:00	wednesday
1949	28	2016-04-26 13:00:00	tuesday
1950	28	2016-04-02 15:45:00	saturday
1951	18	2016-04-26 16:15:00	tuesday
1952	28	2016-04-28 10:45:00	thursday
1953	28	2016-04-25 16:45:00	monday
1954	17	2016-04-05 10:15:00	tuesday
1955	5	2016-04-11 16:45:00	monday
1956	38	2016-04-09 17:15:00	saturday
1957	12	2016-04-12 13:00:00	tuesday
1958	14	2016-04-01 16:30:00	friday
1959	33	2016-04-03 14:00:00	sunday
1960	22	2016-04-05 11:30:00	tuesday
1961	6	2016-04-11 09:15:00	monday
1962	12	2016-04-13 11:00:00	wednesday
1963	16	2016-04-04 14:45:00	monday
1964	12	2016-04-03 08:15:00	sunday
1965	4	2016-04-25 17:15:00	monday
1966	39	2016-04-13 16:30:00	wednesday
1967	20	2016-04-01 16:00:00	friday
1968	35	2016-04-01 08:45:00	friday
1969	10	2016-04-08 09:45:00	friday
1970	32	2016-04-27 17:45:00	wednesday
1971	25	2016-04-29 12:15:00	friday
1972	39	2016-04-07 15:30:00	thursday
1973	1	2016-04-16 15:45:00	saturday
1974	19	2016-04-26 17:00:00	tuesday
1975	1	2016-04-30 15:00:00	saturday
1976	25	2016-04-04 16:30:00	monday
1977	36	2016-04-03 13:45:00	sunday
1978	33	2016-04-23 11:00:00	saturday
1979	7	2016-04-23 11:00:00	saturday
1980	4	2016-04-04 14:30:00	monday
1981	14	2016-04-01 12:45:00	friday
1982	21	2016-04-27 12:00:00	wednesday
1983	36	2016-04-08 15:30:00	friday
1984	2	2016-04-14 17:00:00	thursday
1985	17	2016-04-16 15:15:00	saturday
1986	11	2016-04-22 10:30:00	friday
1987	27	2016-04-06 17:45:00	wednesday
1988	23	2016-04-20 11:00:00	wednesday
1989	8	2016-04-09 13:15:00	saturday
1990	3	2016-04-27 08:45:00	wednesday
1991	24	2016-04-03 17:15:00	sunday
1992	36	2016-04-20 17:15:00	wednesday
1993	21	2016-04-14 15:30:00	thursday
1994	33	2016-04-21 16:00:00	thursday
1995	27	2016-04-05 11:45:00	tuesday
1996	20	2016-04-16 17:30:00	saturday
1997	34	2016-04-06 12:00:00	wednesday
1998	23	2016-04-03 11:45:00	sunday
1999	33	2016-04-02 17:45:00	saturday
2000	25	2016-04-28 16:30:00	thursday
2001	35	2016-04-15 10:15:00	friday
2002	33	2016-04-03 09:15:00	sunday
2003	11	2016-04-24 14:45:00	sunday
2004	7	2016-04-27 09:30:00	wednesday
2005	17	2016-04-05 11:45:00	tuesday
2006	31	2016-04-23 17:00:00	saturday
2007	12	2016-04-04 16:00:00	monday
2008	39	2016-04-04 12:30:00	monday
2009	23	2016-05-26 17:00:00	thursday
2010	37	2016-05-09 13:00:00	monday
2011	6	2016-05-23 12:00:00	monday
2012	35	2016-05-20 13:15:00	friday
2013	23	2016-05-06 17:00:00	friday
2014	5	2016-05-30 17:30:00	monday
2015	36	2016-05-23 13:30:00	monday
2016	8	2016-05-05 13:15:00	thursday
2017	37	2016-05-23 13:00:00	monday
2018	2	2016-05-16 09:15:00	monday
2019	32	2016-05-19 16:45:00	thursday
2020	30	2016-05-24 09:45:00	tuesday
2021	3	2016-05-14 17:30:00	saturday
2022	38	2016-05-24 13:45:00	tuesday
2023	29	2016-05-18 16:15:00	wednesday
2024	1	2016-05-25 12:00:00	wednesday
2025	2	2016-05-25 08:30:00	wednesday
2026	12	2016-05-25 10:30:00	wednesday
2027	22	2016-05-30 09:00:00	monday
2028	19	2016-05-14 12:00:00	saturday
2029	22	2016-05-01 13:30:00	sunday
2030	31	2016-05-28 15:45:00	saturday
2031	4	2016-05-09 16:30:00	monday
2032	6	2016-05-29 17:45:00	sunday
2033	34	2016-05-26 16:00:00	thursday
2034	15	2016-05-11 10:15:00	wednesday
2035	3	2016-05-21 09:45:00	saturday
2036	13	2016-05-03 15:45:00	tuesday
2037	30	2016-05-05 08:15:00	thursday
2038	18	2016-05-16 08:00:00	monday
2039	36	2016-05-16 17:30:00	monday
2040	11	2016-05-16 10:30:00	monday
2041	31	2016-05-06 16:45:00	friday
2042	15	2016-05-09 17:00:00	monday
2043	27	2016-05-14 16:00:00	saturday
2044	17	2016-05-07 12:45:00	saturday
2045	15	2016-05-16 14:00:00	monday
2046	36	2016-05-19 09:30:00	thursday
2047	2	2016-05-02 13:45:00	monday
2048	19	2016-05-01 08:30:00	sunday
2049	32	2016-05-03 13:00:00	tuesday
2050	8	2016-05-26 11:45:00	thursday
2051	27	2016-05-28 09:15:00	saturday
2052	20	2016-05-23 09:45:00	monday
2053	36	2016-05-08 16:15:00	sunday
2054	32	2016-05-26 12:30:00	thursday
2055	33	2016-05-29 13:30:00	sunday
2056	4	2016-05-06 12:30:00	friday
2057	22	2016-05-19 15:15:00	thursday
2058	6	2016-05-11 15:30:00	wednesday
2059	31	2016-05-07 17:45:00	saturday
2060	32	2016-05-29 10:45:00	sunday
2061	17	2016-05-21 15:45:00	saturday
2062	4	2016-05-28 13:15:00	saturday
2063	30	2016-05-04 14:45:00	wednesday
2064	33	2016-05-13 14:15:00	friday
2065	15	2016-05-22 08:45:00	sunday
2066	29	2016-05-14 08:00:00	saturday
2067	1	2016-05-15 10:15:00	sunday
2068	2	2016-05-20 10:45:00	friday
2069	27	2016-05-13 17:30:00	friday
2070	11	2016-05-22 15:00:00	sunday
2071	12	2016-05-09 14:45:00	monday
2072	5	2016-05-25 12:15:00	wednesday
2073	23	2016-05-20 08:30:00	friday
2074	40	2016-05-02 14:30:00	monday
2075	32	2016-05-14 16:45:00	saturday
2076	30	2016-05-22 15:00:00	sunday
2077	5	2016-05-12 08:30:00	thursday
2078	16	2016-05-03 17:15:00	tuesday
2079	31	2016-05-26 12:30:00	thursday
2080	22	2016-05-25 08:15:00	wednesday
2081	8	2016-05-25 15:15:00	wednesday
2082	21	2016-05-19 12:15:00	thursday
2083	37	2016-05-28 12:00:00	saturday
2084	24	2016-05-28 08:45:00	saturday
2085	27	2016-05-24 15:45:00	tuesday
2086	17	2016-05-28 15:15:00	saturday
2087	4	2016-05-05 13:15:00	thursday
2088	30	2016-05-29 15:30:00	sunday
2089	1	2016-05-04 09:00:00	wednesday
2090	6	2016-05-08 12:15:00	sunday
2091	6	2016-05-29 17:45:00	sunday
2092	3	2016-05-02 12:30:00	monday
2093	2	2016-05-08 15:45:00	sunday
2094	8	2016-05-28 11:45:00	saturday
2095	22	2016-05-16 09:00:00	monday
2096	18	2016-06-15 16:30:00	wednesday
2097	11	2016-06-17 15:15:00	friday
2098	9	2016-06-19 12:30:00	sunday
2099	22	2016-06-15 13:00:00	wednesday
2100	13	2016-06-19 08:45:00	sunday
2101	14	2016-06-18 14:30:00	saturday
2102	11	2016-06-18 12:15:00	saturday
2103	10	2016-06-17 09:45:00	friday
2104	14	2016-06-20 09:30:00	monday
2105	28	2016-06-19 12:00:00	sunday
2106	8	2016-06-13 13:30:00	monday
2107	18	2016-06-14 09:30:00	tuesday
2108	25	2016-06-07 09:00:00	tuesday
2109	25	2016-06-05 11:00:00	sunday
2110	36	2016-06-09 08:30:00	thursday
2111	19	2016-06-30 13:00:00	thursday
2112	22	2016-06-01 14:30:00	wednesday
2113	8	2016-06-18 12:45:00	saturday
2114	40	2016-06-21 11:30:00	tuesday
2115	5	2016-06-22 14:00:00	wednesday
2116	2	2016-06-09 08:45:00	thursday
2117	2	2016-06-01 16:15:00	wednesday
2118	24	2016-06-08 11:30:00	wednesday
2119	21	2016-06-30 11:30:00	thursday
2120	14	2016-06-27 16:15:00	monday
2121	2	2016-06-29 09:15:00	wednesday
2122	13	2016-06-10 17:00:00	friday
2123	4	2016-06-20 08:45:00	monday
2124	22	2016-06-14 17:00:00	tuesday
2125	34	2016-06-03 14:30:00	friday
2126	19	2016-06-17 10:45:00	friday
2127	5	2016-06-11 17:00:00	saturday
2128	18	2016-06-28 09:15:00	tuesday
2129	14	2016-06-18 11:00:00	saturday
2130	35	2016-06-19 13:45:00	sunday
2131	10	2016-06-11 16:45:00	saturday
2132	15	2016-06-01 16:45:00	wednesday
2133	7	2016-06-09 10:00:00	thursday
2134	17	2016-06-17 17:15:00	friday
2135	30	2016-06-24 11:30:00	friday
2136	14	2016-06-03 17:30:00	friday
2137	8	2016-06-08 10:00:00	wednesday
2138	30	2016-06-05 15:45:00	sunday
2139	27	2016-06-23 16:15:00	thursday
2140	26	2016-06-07 08:15:00	tuesday
2141	28	2016-06-24 16:15:00	friday
2142	14	2016-06-24 10:00:00	friday
2143	20	2016-06-29 17:30:00	wednesday
2144	38	2016-06-18 16:00:00	saturday
2145	30	2016-06-14 14:30:00	tuesday
2146	2	2016-06-05 16:45:00	sunday
2147	4	2016-06-27 16:15:00	monday
2148	27	2016-06-21 10:15:00	tuesday
2149	38	2016-06-03 10:15:00	friday
2150	29	2016-06-15 11:00:00	wednesday
2151	4	2016-06-12 12:30:00	sunday
2152	21	2016-06-12 08:30:00	sunday
2153	25	2016-06-30 08:45:00	thursday
2154	34	2016-06-14 15:30:00	tuesday
2155	8	2016-06-11 14:00:00	saturday
2156	6	2016-06-20 14:45:00	monday
2157	40	2016-06-28 11:45:00	tuesday
2158	12	2016-06-28 16:00:00	tuesday
2159	10	2016-06-18 09:00:00	saturday
2160	33	2016-06-21 09:00:00	tuesday
2161	7	2016-06-03 12:00:00	friday
2162	28	2016-06-11 12:45:00	saturday
2163	12	2016-06-16 16:00:00	thursday
2164	39	2016-06-21 16:30:00	tuesday
2165	23	2016-06-29 10:45:00	wednesday
2166	21	2016-06-02 17:30:00	thursday
2167	9	2016-06-27 13:00:00	monday
2168	28	2016-06-10 17:45:00	friday
2169	27	2016-06-12 15:00:00	sunday
2170	3	2016-06-01 09:30:00	wednesday
2171	27	2016-06-06 10:30:00	monday
2172	26	2016-06-13 16:30:00	monday
2173	38	2016-06-04 12:30:00	saturday
2174	22	2016-06-22 13:00:00	wednesday
2175	21	2016-06-22 12:15:00	wednesday
2176	35	2016-06-07 12:30:00	tuesday
2177	10	2016-06-03 16:30:00	friday
2178	18	2016-06-15 09:45:00	wednesday
2179	25	2016-06-04 09:00:00	saturday
2180	3	2016-06-03 09:00:00	friday
2181	1	2016-06-09 17:45:00	thursday
2182	17	2016-07-17 08:45:00	sunday
2183	26	2016-07-30 12:15:00	saturday
2184	3	2016-07-28 08:00:00	thursday
2185	15	2016-07-22 15:30:00	friday
2186	14	2016-07-25 16:30:00	monday
2187	11	2016-07-14 08:45:00	thursday
2188	5	2016-07-04 10:00:00	monday
2189	5	2016-07-14 13:30:00	thursday
2190	27	2016-07-15 12:45:00	friday
2191	21	2016-07-03 15:30:00	sunday
2192	22	2016-07-30 17:00:00	saturday
2193	22	2016-07-09 13:45:00	saturday
2194	35	2016-07-06 09:15:00	wednesday
2195	20	2016-07-26 17:30:00	tuesday
2196	6	2016-07-18 17:15:00	monday
2197	5	2016-07-13 11:30:00	wednesday
2198	25	2016-07-26 12:45:00	tuesday
2199	10	2016-07-03 12:00:00	sunday
2200	9	2016-07-26 13:00:00	tuesday
2201	4	2016-07-16 11:30:00	saturday
2202	22	2016-07-10 16:30:00	sunday
2203	25	2016-07-08 12:00:00	friday
2204	32	2016-07-26 16:30:00	tuesday
2205	22	2016-07-08 12:45:00	friday
2206	37	2016-07-13 14:00:00	wednesday
2207	20	2016-07-26 14:15:00	tuesday
2208	8	2016-07-01 11:00:00	friday
2209	37	2016-07-20 11:30:00	wednesday
2210	1	2016-07-26 13:30:00	tuesday
2211	13	2016-07-30 13:30:00	saturday
2212	33	2016-07-06 10:45:00	wednesday
2213	19	2016-07-17 14:45:00	sunday
2214	4	2016-07-19 16:45:00	tuesday
2215	39	2016-07-02 10:15:00	saturday
2216	22	2016-07-18 11:15:00	monday
2217	3	2016-07-28 15:30:00	thursday
2218	1	2016-07-16 13:15:00	saturday
2219	28	2016-07-18 10:45:00	monday
2220	19	2016-07-08 14:00:00	friday
2221	8	2016-07-27 09:30:00	wednesday
2222	18	2016-07-08 13:30:00	friday
2223	8	2016-07-23 16:45:00	saturday
2224	9	2016-07-07 11:45:00	thursday
2225	20	2016-07-10 08:00:00	sunday
2226	9	2016-07-29 11:30:00	friday
2227	19	2016-07-24 13:30:00	sunday
2228	35	2016-07-27 14:45:00	wednesday
2229	10	2016-07-07 09:30:00	thursday
2230	18	2016-07-28 12:00:00	thursday
2231	26	2016-07-07 10:30:00	thursday
2232	4	2016-07-24 14:45:00	sunday
2233	4	2016-07-23 09:45:00	saturday
2234	39	2016-07-15 15:45:00	friday
2235	30	2016-07-12 13:00:00	tuesday
2236	29	2016-07-27 08:45:00	wednesday
2237	28	2016-07-09 08:30:00	saturday
2238	18	2016-07-18 08:30:00	monday
2239	33	2016-07-17 16:45:00	sunday
2240	18	2016-07-02 17:30:00	saturday
2241	22	2016-07-30 16:30:00	saturday
2242	14	2016-07-12 17:30:00	tuesday
2243	7	2016-07-26 12:15:00	tuesday
2244	37	2016-07-16 12:15:00	saturday
2245	35	2016-07-20 12:15:00	wednesday
2246	21	2016-07-17 14:15:00	sunday
2247	34	2016-07-02 10:30:00	saturday
2248	33	2016-07-22 08:00:00	friday
2249	38	2016-07-27 11:30:00	wednesday
2250	1	2016-07-03 12:30:00	sunday
2251	12	2016-07-25 15:15:00	monday
2252	39	2016-07-09 11:45:00	saturday
2253	26	2016-07-28 10:30:00	thursday
2254	38	2016-07-08 14:45:00	friday
2255	32	2016-07-22 10:00:00	friday
2256	3	2016-08-07 15:30:00	sunday
2257	17	2016-08-09 17:00:00	tuesday
2258	30	2016-08-03 12:00:00	wednesday
2259	17	2016-08-07 17:30:00	sunday
2260	23	2016-08-25 08:00:00	thursday
2261	14	2016-08-22 14:00:00	monday
2262	11	2016-08-05 08:15:00	friday
2263	24	2016-08-26 13:30:00	friday
2264	29	2016-08-29 17:15:00	monday
2265	34	2016-08-14 11:45:00	sunday
2266	15	2016-08-27 17:45:00	saturday
2267	1	2016-08-03 16:30:00	wednesday
2268	1	2016-08-05 17:00:00	friday
2269	9	2016-08-30 13:00:00	tuesday
2270	38	2016-08-05 12:30:00	friday
2271	5	2016-08-11 17:30:00	thursday
2272	28	2016-08-01 14:45:00	monday
2273	30	2016-08-08 13:15:00	monday
2274	9	2016-08-22 14:30:00	monday
2275	8	2016-08-11 09:15:00	thursday
2276	8	2016-08-20 10:30:00	saturday
2277	34	2016-08-17 14:30:00	wednesday
2278	20	2016-08-28 12:45:00	sunday
2279	28	2016-08-15 13:00:00	monday
2280	10	2016-08-23 12:45:00	tuesday
2281	40	2016-08-27 12:30:00	saturday
2282	9	2016-08-13 08:00:00	saturday
2283	35	2016-08-01 13:15:00	monday
2284	26	2016-08-19 08:00:00	friday
2285	34	2016-08-15 17:15:00	monday
2286	33	2016-08-09 17:45:00	tuesday
2287	15	2016-08-15 10:00:00	monday
2288	4	2016-08-02 16:45:00	tuesday
2289	20	2016-08-15 17:45:00	monday
2290	9	2016-08-07 17:15:00	sunday
2291	13	2016-08-20 12:00:00	saturday
2292	25	2016-08-27 09:15:00	saturday
2293	31	2016-08-26 09:45:00	friday
2294	33	2016-08-02 09:15:00	tuesday
2295	5	2016-08-07 10:30:00	sunday
2296	14	2016-08-06 11:15:00	saturday
2297	15	2016-08-08 14:30:00	monday
2298	30	2016-08-06 13:00:00	saturday
2299	34	2016-08-14 10:00:00	sunday
2300	27	2016-08-15 17:30:00	monday
2301	13	2016-08-22 13:00:00	monday
2302	32	2016-08-30 10:45:00	tuesday
2303	23	2016-08-09 12:00:00	tuesday
2304	19	2016-08-10 15:30:00	wednesday
2305	36	2016-08-16 11:45:00	tuesday
2306	20	2016-08-06 11:30:00	saturday
2307	23	2016-08-01 12:00:00	monday
2308	26	2016-08-06 16:00:00	saturday
2309	15	2016-08-23 17:00:00	tuesday
2310	34	2016-08-10 15:30:00	wednesday
2311	36	2016-08-10 15:00:00	wednesday
2312	25	2016-08-15 14:00:00	monday
2313	32	2016-08-01 17:30:00	monday
2314	6	2016-08-30 09:15:00	tuesday
2315	39	2016-08-25 15:00:00	thursday
2316	11	2016-08-30 10:00:00	tuesday
2317	17	2016-08-07 15:30:00	sunday
2318	35	2016-08-13 11:00:00	saturday
2319	37	2016-08-14 15:15:00	sunday
2320	3	2016-08-20 15:00:00	saturday
2321	30	2016-08-17 13:00:00	wednesday
2322	10	2016-08-03 09:15:00	wednesday
2323	15	2016-08-07 09:30:00	sunday
2324	2	2016-08-10 15:15:00	wednesday
2325	32	2016-08-06 10:45:00	saturday
2326	6	2016-09-14 12:45:00	wednesday
2327	16	2016-09-06 08:30:00	tuesday
2328	12	2016-09-06 08:15:00	tuesday
2329	10	2016-09-14 15:45:00	wednesday
2330	11	2016-09-16 16:00:00	friday
2331	10	2016-09-24 12:30:00	saturday
2332	11	2016-09-18 11:30:00	sunday
2333	7	2016-09-06 13:15:00	tuesday
2334	33	2016-09-30 12:00:00	friday
2335	24	2016-09-30 09:30:00	friday
2336	10	2016-09-28 14:15:00	wednesday
2337	17	2016-09-14 16:15:00	wednesday
2338	28	2016-09-01 15:30:00	thursday
2339	13	2016-09-22 17:00:00	thursday
2340	18	2016-09-29 08:15:00	thursday
2341	34	2016-09-01 08:30:00	thursday
2342	15	2016-09-26 16:00:00	monday
2343	26	2016-09-22 10:15:00	thursday
2344	15	2016-09-25 15:30:00	sunday
2345	30	2016-09-01 15:45:00	thursday
2346	3	2016-09-05 12:45:00	monday
2347	3	2016-09-29 13:30:00	thursday
2348	19	2016-09-01 16:00:00	thursday
2349	6	2016-09-10 15:00:00	saturday
2350	19	2016-09-23 08:45:00	friday
2351	9	2016-09-20 08:45:00	tuesday
2352	32	2016-09-20 17:15:00	tuesday
2353	38	2016-09-19 10:45:00	monday
2354	18	2016-09-05 15:45:00	monday
2355	40	2016-09-05 11:00:00	monday
2356	26	2016-09-17 17:15:00	saturday
2357	23	2016-09-11 15:30:00	sunday
2358	10	2016-09-20 16:00:00	tuesday
2359	2	2016-09-25 12:45:00	sunday
2360	25	2016-09-02 13:30:00	friday
2361	12	2016-09-06 11:00:00	tuesday
2362	30	2016-09-12 15:00:00	monday
2363	1	2016-09-18 13:30:00	sunday
2364	34	2016-09-04 15:15:00	sunday
2365	23	2016-09-11 17:45:00	sunday
2366	16	2016-09-10 17:15:00	saturday
2367	32	2016-09-29 08:45:00	thursday
2368	22	2016-09-10 16:15:00	saturday
2369	36	2016-09-05 17:30:00	monday
2370	11	2016-09-30 08:15:00	friday
2371	33	2016-09-25 11:30:00	sunday
2372	9	2016-09-13 15:15:00	tuesday
2373	21	2016-09-04 08:00:00	sunday
2374	9	2016-09-12 08:15:00	monday
2375	31	2016-09-29 15:30:00	thursday
2376	27	2016-09-01 08:30:00	thursday
2377	19	2016-09-06 11:00:00	tuesday
2378	29	2016-09-03 15:30:00	saturday
2379	21	2016-09-29 08:30:00	thursday
2380	1	2016-09-29 15:00:00	thursday
2381	26	2016-09-15 16:15:00	thursday
2382	1	2016-09-18 17:30:00	sunday
2383	36	2016-09-09 17:45:00	friday
2384	12	2016-09-11 13:30:00	sunday
2385	12	2016-09-06 11:30:00	tuesday
2386	32	2016-09-24 08:30:00	saturday
2387	8	2016-09-18 11:15:00	sunday
2388	7	2016-09-11 17:15:00	sunday
2389	36	2016-09-30 17:30:00	friday
2390	20	2016-09-29 16:45:00	thursday
2391	26	2016-09-15 13:30:00	thursday
2392	5	2016-09-27 12:15:00	tuesday
2393	36	2016-09-10 08:30:00	saturday
2394	40	2016-09-16 11:00:00	friday
2395	38	2016-09-07 10:45:00	wednesday
2396	16	2016-09-26 16:45:00	monday
2397	14	2016-09-04 12:15:00	sunday
2398	38	2016-09-17 14:45:00	saturday
2399	38	2016-09-01 16:15:00	thursday
2400	10	2016-09-07 11:15:00	wednesday
2401	30	2016-09-12 17:00:00	monday
2402	33	2016-10-14 15:45:00	friday
2403	28	2016-10-16 15:45:00	sunday
2404	22	2016-10-25 15:45:00	tuesday
2405	5	2016-10-30 16:30:00	sunday
2406	35	2016-10-23 09:30:00	sunday
2407	27	2016-10-16 14:45:00	sunday
2408	38	2016-10-28 16:30:00	friday
2409	23	2016-10-15 08:30:00	saturday
2410	7	2016-10-01 15:45:00	saturday
2411	13	2016-10-08 14:15:00	saturday
2412	30	2016-10-21 12:45:00	friday
2413	4	2016-10-14 11:45:00	friday
2414	15	2016-10-19 14:30:00	wednesday
2415	29	2016-10-10 11:15:00	monday
2416	7	2016-10-24 16:00:00	monday
2417	33	2016-10-10 17:45:00	monday
2418	21	2016-10-15 09:15:00	saturday
2419	14	2016-10-19 11:45:00	wednesday
2420	4	2016-10-25 13:15:00	tuesday
2421	24	2016-10-19 14:30:00	wednesday
2422	21	2016-10-08 11:15:00	saturday
2423	17	2016-10-16 12:30:00	sunday
2424	39	2016-10-18 12:15:00	tuesday
2425	35	2016-10-07 15:00:00	friday
2426	25	2016-10-04 17:30:00	tuesday
2427	26	2016-10-12 08:00:00	wednesday
2428	19	2016-10-14 14:45:00	friday
2429	20	2016-10-18 10:30:00	tuesday
2430	11	2016-10-13 12:30:00	thursday
2431	2	2016-10-21 14:15:00	friday
2432	11	2016-10-17 16:30:00	monday
2433	14	2016-10-08 11:15:00	saturday
2434	13	2016-10-21 16:45:00	friday
2435	37	2016-10-03 10:15:00	monday
2436	1	2016-10-15 08:45:00	saturday
2437	36	2016-10-01 10:15:00	saturday
2438	11	2016-10-19 16:00:00	wednesday
2439	29	2016-10-25 11:00:00	tuesday
2440	40	2016-10-30 16:45:00	sunday
2441	40	2016-10-19 13:15:00	wednesday
2442	14	2016-10-23 12:00:00	sunday
2443	36	2016-10-22 16:45:00	saturday
2444	33	2016-10-13 10:00:00	thursday
2445	5	2016-10-06 11:00:00	thursday
2446	26	2016-10-29 14:15:00	saturday
2447	37	2016-10-18 14:30:00	tuesday
2448	24	2016-10-26 15:00:00	wednesday
2449	21	2016-10-16 14:45:00	sunday
2450	17	2016-10-17 14:45:00	monday
2451	34	2016-10-07 08:30:00	friday
2452	14	2016-10-02 16:45:00	sunday
2453	2	2016-10-18 14:45:00	tuesday
2454	12	2016-10-18 14:30:00	tuesday
2455	6	2016-10-24 12:30:00	monday
2456	32	2016-10-06 11:00:00	thursday
2457	8	2016-10-23 14:45:00	sunday
2458	24	2016-10-29 12:30:00	saturday
2459	20	2016-10-18 16:45:00	tuesday
2460	30	2016-10-21 08:45:00	friday
2461	16	2016-10-12 08:15:00	wednesday
2462	21	2016-10-21 10:45:00	friday
2463	13	2016-10-22 15:00:00	saturday
2464	12	2016-10-23 12:15:00	sunday
2465	29	2016-10-12 11:30:00	wednesday
2466	32	2016-10-12 16:30:00	wednesday
2467	21	2016-10-21 08:15:00	friday
2468	35	2016-10-30 11:00:00	sunday
2469	2	2016-10-06 14:00:00	thursday
2470	9	2016-10-05 11:00:00	wednesday
2471	5	2016-10-19 15:30:00	wednesday
2472	31	2016-10-12 15:00:00	wednesday
2473	1	2016-10-28 11:30:00	friday
2474	5	2016-10-22 09:45:00	saturday
2475	25	2016-10-26 10:15:00	wednesday
2476	35	2016-10-08 10:00:00	saturday
2477	28	2016-10-28 16:45:00	friday
2478	28	2016-10-21 11:45:00	friday
2479	3	2016-10-16 15:00:00	sunday
2480	7	2016-11-18 17:45:00	friday
2481	31	2016-11-10 16:00:00	thursday
2482	3	2016-11-02 16:30:00	wednesday
2483	21	2016-11-29 14:00:00	tuesday
2484	40	2016-11-11 17:45:00	friday
2485	19	2016-11-02 10:00:00	wednesday
2486	26	2016-11-22 17:45:00	tuesday
2487	2	2016-11-24 10:30:00	thursday
2488	15	2016-11-20 12:15:00	sunday
2489	4	2016-11-30 14:00:00	wednesday
2490	37	2016-11-06 15:00:00	sunday
2491	36	2016-11-08 17:15:00	tuesday
2492	15	2016-11-30 16:45:00	wednesday
2493	26	2016-11-15 14:15:00	tuesday
2494	7	2016-11-05 13:00:00	saturday
2495	14	2016-11-07 16:15:00	monday
2496	34	2016-11-19 10:15:00	saturday
2497	35	2016-11-29 15:30:00	tuesday
2498	1	2016-11-03 12:30:00	thursday
2499	3	2016-11-11 08:15:00	friday
2500	12	2016-11-18 13:00:00	friday
2501	38	2016-11-29 13:15:00	tuesday
2502	38	2016-11-19 17:30:00	saturday
2503	36	2016-11-11 14:30:00	friday
2504	14	2016-11-05 10:30:00	saturday
2505	24	2016-11-13 15:00:00	sunday
2506	33	2016-11-22 12:45:00	tuesday
2507	5	2016-11-10 09:00:00	thursday
2508	27	2016-11-12 09:15:00	saturday
2509	26	2016-11-11 14:30:00	friday
2510	37	2016-11-13 16:15:00	sunday
2511	40	2016-11-18 10:30:00	friday
2512	21	2016-11-07 14:15:00	monday
2513	32	2016-11-20 12:00:00	sunday
2514	3	2016-11-26 15:45:00	saturday
2515	31	2016-11-19 10:45:00	saturday
2516	24	2016-11-13 09:30:00	sunday
2517	3	2016-11-29 10:00:00	tuesday
2518	22	2016-11-29 16:45:00	tuesday
2519	28	2016-11-03 17:00:00	thursday
2520	36	2016-11-07 11:30:00	monday
2521	14	2016-11-21 15:30:00	monday
2522	1	2016-11-02 17:00:00	wednesday
2523	19	2016-11-15 16:15:00	tuesday
2524	6	2016-11-18 11:00:00	friday
2525	11	2016-11-10 15:45:00	thursday
2526	23	2016-11-12 08:15:00	saturday
2527	6	2016-11-20 14:30:00	sunday
2528	32	2016-11-08 12:30:00	tuesday
2529	14	2016-11-30 10:30:00	wednesday
2530	33	2016-11-29 17:00:00	tuesday
2531	8	2016-11-28 10:45:00	monday
2532	3	2016-11-10 17:00:00	thursday
2533	33	2016-11-18 17:15:00	friday
2534	34	2016-11-14 15:45:00	monday
2535	26	2016-11-02 09:30:00	wednesday
2536	19	2016-11-18 15:45:00	friday
2537	37	2016-11-10 16:45:00	thursday
2538	13	2016-11-30 12:00:00	wednesday
2539	39	2016-11-13 11:00:00	sunday
2540	9	2016-11-08 10:00:00	tuesday
2541	38	2016-11-11 12:15:00	friday
2542	36	2016-11-08 09:15:00	tuesday
2543	27	2016-11-25 09:00:00	friday
2544	34	2016-11-10 14:30:00	thursday
2545	39	2016-11-07 12:45:00	monday
2546	26	2016-11-16 12:45:00	wednesday
2547	30	2016-11-10 11:15:00	thursday
2548	6	2016-11-25 10:45:00	friday
2549	1	2016-11-25 10:45:00	friday
2550	33	2016-11-30 12:45:00	wednesday
2551	21	2016-11-24 08:15:00	thursday
2552	8	2016-11-22 17:30:00	tuesday
2553	6	2016-11-19 14:15:00	saturday
2554	28	2016-11-02 17:15:00	wednesday
2555	33	2016-11-08 14:00:00	tuesday
2556	36	2016-11-08 15:00:00	tuesday
2557	19	2016-11-24 11:15:00	thursday
2558	37	2016-11-09 16:30:00	wednesday
2559	21	2016-11-27 14:00:00	sunday
2560	27	2016-11-19 11:45:00	saturday
2561	1	2016-11-14 12:45:00	monday
2562	39	2016-11-26 16:00:00	saturday
2563	35	2016-11-29 09:30:00	tuesday
2564	16	2016-11-04 14:00:00	friday
2565	2	2016-12-08 08:30:00	thursday
2566	4	2016-12-16 12:15:00	friday
2567	30	2016-12-26 16:15:00	monday
2568	14	2016-12-23 08:00:00	friday
2569	1	2016-12-14 17:45:00	wednesday
2570	38	2016-12-05 09:30:00	monday
2571	24	2016-12-05 13:30:00	monday
2572	7	2016-12-03 14:00:00	saturday
2573	1	2016-12-09 09:30:00	friday
2574	1	2016-12-04 10:00:00	sunday
2575	4	2016-12-19 11:45:00	monday
2576	21	2016-12-07 10:30:00	wednesday
2577	12	2016-12-03 12:00:00	saturday
2578	39	2016-12-29 10:30:00	thursday
2579	29	2016-12-22 16:15:00	thursday
2580	19	2016-12-12 17:30:00	monday
2581	37	2016-12-05 15:45:00	monday
2582	2	2016-12-20 12:00:00	tuesday
2583	28	2016-12-12 17:30:00	monday
2584	11	2016-12-20 17:30:00	tuesday
2585	38	2016-12-11 15:45:00	sunday
2586	29	2016-12-27 12:45:00	tuesday
2587	13	2016-12-18 10:15:00	sunday
2588	25	2016-12-29 11:00:00	thursday
2589	17	2016-12-26 13:45:00	monday
2590	34	2016-12-07 16:30:00	wednesday
2591	34	2016-12-23 09:45:00	friday
2592	38	2016-12-05 17:30:00	monday
2593	33	2016-12-12 13:15:00	monday
2594	19	2016-12-17 12:00:00	saturday
2595	37	2016-12-15 16:30:00	thursday
2596	28	2016-12-07 13:15:00	wednesday
2597	26	2016-12-20 13:00:00	tuesday
2598	36	2016-12-06 16:45:00	tuesday
2599	24	2016-12-22 08:15:00	thursday
2600	40	2016-12-29 12:00:00	thursday
2601	36	2016-12-02 17:00:00	friday
2602	23	2016-12-26 10:45:00	monday
2603	32	2016-12-07 11:45:00	wednesday
2604	26	2016-12-24 12:15:00	saturday
2605	26	2016-12-05 16:30:00	monday
2606	30	2016-12-16 08:15:00	friday
2607	13	2016-12-07 12:30:00	wednesday
2608	22	2016-12-25 16:45:00	sunday
2609	24	2016-12-02 11:15:00	friday
2610	11	2016-12-04 12:00:00	sunday
2611	18	2016-12-12 08:30:00	monday
2612	38	2016-12-21 12:45:00	wednesday
2613	16	2016-12-24 08:15:00	saturday
2614	2	2016-12-18 13:00:00	sunday
2615	34	2016-12-10 14:30:00	saturday
2616	28	2016-12-14 14:00:00	wednesday
2617	27	2016-12-26 11:45:00	monday
2618	4	2016-12-06 11:00:00	tuesday
2619	40	2016-12-22 17:00:00	thursday
2620	4	2016-12-19 17:00:00	monday
2621	6	2016-12-19 14:15:00	monday
2622	29	2016-12-15 11:30:00	thursday
2623	29	2016-12-21 14:30:00	wednesday
2624	14	2016-12-26 15:45:00	monday
2625	9	2016-12-17 08:45:00	saturday
2626	6	2016-12-16 09:30:00	friday
2627	37	2016-12-21 14:45:00	wednesday
2628	31	2016-12-15 10:30:00	thursday
2629	8	2016-12-25 09:45:00	sunday
2630	19	2016-12-14 14:30:00	wednesday
2631	33	2016-12-28 14:45:00	wednesday
2632	8	2016-12-10 10:45:00	saturday
2633	29	2016-12-07 11:00:00	wednesday
2634	14	2016-12-23 15:45:00	friday
2635	37	2016-12-15 12:15:00	thursday
2636	28	2016-12-11 15:30:00	sunday
2637	2	2016-12-20 12:15:00	tuesday
2638	8	2016-12-17 13:15:00	saturday
2639	19	2016-12-23 16:30:00	friday
2640	30	2016-12-28 12:15:00	wednesday
2641	11	2016-12-23 12:00:00	friday
2642	21	2016-12-14 12:45:00	wednesday
2643	21	2016-12-05 14:45:00	monday
2644	16	2016-12-07 14:45:00	wednesday
2645	33	2016-12-05 14:45:00	monday
2646	40	2016-12-07 17:30:00	wednesday
2647	22	2016-12-10 08:30:00	saturday
2648	12	2016-12-13 08:30:00	tuesday
2649	32	2016-12-07 10:30:00	wednesday
2650	10	2016-12-04 15:00:00	sunday
2651	4	2017-01-10 13:00:00	tuesday
2652	4	2017-01-05 13:15:00	thursday
2653	18	2017-01-16 17:15:00	monday
2654	30	2017-01-15 15:15:00	sunday
2655	17	2017-01-01 08:00:00	sunday
2656	21	2017-01-26 17:30:00	thursday
2657	23	2017-01-11 08:15:00	wednesday
2658	19	2017-01-13 08:15:00	friday
2659	12	2017-01-23 09:30:00	monday
2660	39	2017-01-27 08:45:00	friday
2661	26	2017-01-13 13:45:00	friday
2662	15	2017-01-17 16:00:00	tuesday
2663	15	2017-01-03 09:45:00	tuesday
2664	13	2017-01-01 15:30:00	sunday
2665	32	2017-01-17 13:30:00	tuesday
2666	35	2017-01-29 15:00:00	sunday
2667	13	2017-01-24 17:45:00	tuesday
2668	1	2017-01-22 13:15:00	sunday
2669	1	2017-01-01 11:00:00	sunday
2670	12	2017-01-07 14:45:00	saturday
2671	9	2017-01-16 12:00:00	monday
2672	22	2017-01-26 12:00:00	thursday
2673	26	2017-01-08 08:30:00	sunday
2674	27	2017-01-24 15:45:00	tuesday
2675	20	2017-01-19 12:30:00	thursday
2676	31	2017-01-18 14:15:00	wednesday
2677	3	2017-01-19 12:45:00	thursday
2678	10	2017-01-29 08:30:00	sunday
2679	26	2017-01-06 17:00:00	friday
2680	6	2017-01-19 13:00:00	thursday
2681	32	2017-01-07 11:00:00	saturday
2682	13	2017-01-17 11:30:00	tuesday
2683	37	2017-01-28 16:00:00	saturday
2684	37	2017-01-04 10:15:00	wednesday
2685	3	2017-01-19 15:15:00	thursday
2686	21	2017-01-22 13:30:00	sunday
2687	23	2017-01-06 11:15:00	friday
2688	7	2017-01-15 16:00:00	sunday
2689	6	2017-01-18 17:30:00	wednesday
2690	6	2017-01-04 13:45:00	wednesday
2691	10	2017-01-24 13:15:00	tuesday
2692	31	2017-01-26 11:30:00	thursday
2693	29	2017-01-28 10:30:00	saturday
2694	33	2017-01-23 08:45:00	monday
2695	19	2017-01-15 13:45:00	sunday
2696	38	2017-01-05 15:30:00	thursday
2697	17	2017-01-26 17:45:00	thursday
2698	2	2017-01-06 11:15:00	friday
2699	18	2017-01-05 14:00:00	thursday
2700	8	2017-01-29 17:15:00	sunday
2701	38	2017-01-25 08:00:00	wednesday
2702	18	2017-01-05 16:00:00	thursday
2703	2	2017-01-25 16:00:00	wednesday
2704	40	2017-01-22 17:15:00	sunday
2705	13	2017-01-02 09:15:00	monday
2706	20	2017-01-27 10:15:00	friday
2707	6	2017-01-18 17:15:00	wednesday
2708	14	2017-01-01 12:45:00	sunday
2709	1	2017-01-24 10:15:00	tuesday
2710	20	2017-01-03 15:30:00	tuesday
2711	1	2017-01-21 08:15:00	saturday
2712	7	2017-01-29 17:45:00	sunday
2713	28	2017-01-26 11:15:00	thursday
2714	2	2017-01-24 14:30:00	tuesday
2715	28	2017-01-09 17:45:00	monday
2716	28	2017-01-23 16:45:00	monday
2717	18	2017-01-10 12:15:00	tuesday
2718	26	2017-01-02 13:15:00	monday
2719	19	2017-01-14 13:15:00	saturday
2720	24	2017-01-17 13:00:00	tuesday
2721	13	2017-01-29 12:00:00	sunday
2722	15	2017-01-11 14:45:00	wednesday
2723	39	2017-01-25 13:45:00	wednesday
2724	37	2017-01-25 17:15:00	wednesday
2725	38	2017-01-12 10:00:00	thursday
2726	34	2017-01-25 15:30:00	wednesday
2727	12	2017-01-14 17:45:00	saturday
2728	7	2017-01-23 17:30:00	monday
2729	25	2017-01-04 17:45:00	wednesday
2730	6	2017-01-17 16:30:00	tuesday
2731	28	2017-01-22 17:15:00	sunday
2732	7	2017-01-26 17:15:00	thursday
2733	16	2017-01-12 09:45:00	thursday
2734	14	2017-01-11 12:15:00	wednesday
2735	1	2017-01-20 09:45:00	friday
2736	31	2017-01-25 13:00:00	wednesday
2737	14	2017-01-03 10:15:00	tuesday
2738	13	2017-01-09 16:45:00	monday
2739	7	2017-01-23 10:30:00	monday
2740	12	2017-01-08 17:45:00	sunday
2741	37	2017-01-02 16:30:00	monday
2742	4	2017-02-25 10:15:00	saturday
2743	30	2017-02-04 10:15:00	saturday
2744	38	2017-02-03 08:15:00	friday
2745	16	2017-02-16 12:45:00	thursday
2746	38	2017-02-12 17:30:00	sunday
2747	10	2017-02-23 12:15:00	thursday
2748	9	2017-02-20 08:45:00	monday
2749	40	2017-02-02 15:30:00	thursday
2750	22	2017-02-27 09:00:00	monday
2751	14	2017-02-22 15:15:00	wednesday
2752	23	2017-02-20 13:15:00	monday
2753	9	2017-02-11 12:15:00	saturday
2754	14	2017-02-19 16:30:00	sunday
2755	35	2017-02-18 08:00:00	saturday
2756	26	2017-02-19 09:00:00	sunday
2757	6	2017-02-16 17:15:00	thursday
2758	17	2017-02-16 09:45:00	thursday
2759	37	2017-02-24 17:30:00	friday
2760	21	2017-02-26 12:45:00	sunday
2761	24	2017-02-04 12:00:00	saturday
2762	34	2017-02-03 09:00:00	friday
2763	22	2017-02-16 12:15:00	thursday
2764	35	2017-02-12 09:30:00	sunday
2765	2	2017-02-16 08:15:00	thursday
2766	9	2017-02-04 17:45:00	saturday
2767	32	2017-02-22 16:15:00	wednesday
2768	30	2017-02-16 13:45:00	thursday
2769	14	2017-02-22 14:30:00	wednesday
2770	20	2017-02-21 14:15:00	tuesday
2771	21	2017-02-19 13:45:00	sunday
2772	40	2017-02-28 17:00:00	tuesday
2773	8	2017-02-04 10:45:00	saturday
2774	11	2017-02-08 08:45:00	wednesday
2775	26	2017-02-12 14:30:00	sunday
2776	20	2017-02-14 15:30:00	tuesday
2777	1	2017-02-24 13:00:00	friday
2778	25	2017-02-24 12:00:00	friday
2779	39	2017-02-17 12:00:00	friday
2780	37	2017-02-10 13:30:00	friday
2781	5	2017-02-19 15:30:00	sunday
2782	32	2017-02-24 12:00:00	friday
2783	31	2017-02-14 15:15:00	tuesday
2784	5	2017-02-05 13:00:00	sunday
2785	5	2017-02-12 14:45:00	sunday
2786	20	2017-02-17 09:00:00	friday
2787	13	2017-02-16 09:15:00	thursday
2788	38	2017-02-27 15:45:00	monday
2789	36	2017-02-12 13:00:00	sunday
2790	7	2017-02-23 15:45:00	thursday
2791	4	2017-02-08 14:15:00	wednesday
2792	3	2017-02-13 11:00:00	monday
2793	36	2017-02-25 09:00:00	saturday
2794	11	2017-02-15 11:45:00	wednesday
2795	29	2017-02-14 15:45:00	tuesday
2796	6	2017-02-06 14:30:00	monday
2797	17	2017-02-05 08:15:00	sunday
2798	19	2017-02-26 10:00:00	sunday
2799	36	2017-02-26 08:45:00	sunday
2800	27	2017-02-05 17:45:00	sunday
2801	13	2017-02-06 09:15:00	monday
2802	1	2017-02-03 17:30:00	friday
2803	11	2017-02-09 14:45:00	thursday
2804	3	2017-02-16 17:00:00	thursday
2805	9	2017-02-21 11:30:00	tuesday
2806	32	2017-02-16 09:30:00	thursday
2807	28	2017-02-04 08:45:00	saturday
2808	9	2017-02-26 11:15:00	sunday
2809	25	2017-02-25 13:15:00	saturday
2810	34	2017-02-28 16:00:00	tuesday
2811	2	2017-02-23 16:15:00	thursday
2812	39	2017-02-17 10:00:00	friday
2813	23	2017-02-24 17:30:00	friday
2814	9	2017-02-21 08:45:00	tuesday
2815	31	2017-02-14 12:30:00	tuesday
2816	9	2017-02-15 14:45:00	wednesday
2817	30	2017-02-09 11:00:00	thursday
2818	33	2017-02-19 08:30:00	sunday
2819	6	2017-02-23 12:15:00	thursday
2820	32	2017-02-16 17:00:00	thursday
2821	8	2017-02-09 13:15:00	thursday
2822	28	2017-02-15 16:30:00	wednesday
2823	33	2017-02-05 08:00:00	sunday
2824	39	2017-02-16 09:45:00	thursday
2825	32	2017-02-26 13:00:00	sunday
2826	19	2017-02-20 11:15:00	monday
2827	12	2017-03-04 11:15:00	saturday
2828	8	2017-03-07 11:45:00	tuesday
2829	39	2017-03-18 13:00:00	saturday
2830	19	2017-03-03 10:30:00	friday
2831	15	2017-03-21 16:45:00	tuesday
2832	30	2017-03-03 08:30:00	friday
2833	18	2017-03-10 16:00:00	friday
2834	21	2017-03-24 16:45:00	friday
2835	15	2017-03-06 16:45:00	monday
2836	4	2017-03-03 10:00:00	friday
2837	1	2017-03-06 09:00:00	monday
2838	11	2017-03-16 10:30:00	thursday
2839	29	2017-03-07 16:30:00	tuesday
2840	20	2017-03-26 11:30:00	sunday
2841	8	2017-03-02 09:00:00	thursday
2842	25	2017-03-21 13:30:00	tuesday
2843	3	2017-03-04 09:00:00	saturday
2844	32	2017-03-18 14:30:00	saturday
2845	17	2017-03-17 08:15:00	friday
2846	16	2017-03-01 10:15:00	wednesday
2847	21	2017-03-13 10:00:00	monday
2848	35	2017-03-21 17:30:00	tuesday
2849	31	2017-03-28 16:45:00	tuesday
2850	20	2017-03-02 14:30:00	thursday
2851	29	2017-03-18 12:00:00	saturday
2852	40	2017-03-21 10:15:00	tuesday
2853	35	2017-03-27 15:45:00	monday
2854	23	2017-03-07 09:30:00	tuesday
2855	13	2017-03-10 11:00:00	friday
2856	9	2017-03-09 12:45:00	thursday
2857	26	2017-03-21 10:45:00	tuesday
2858	2	2017-03-05 11:00:00	sunday
2859	24	2017-03-22 09:15:00	wednesday
2860	24	2017-03-19 15:00:00	sunday
2861	20	2017-03-10 12:45:00	friday
2862	26	2017-03-14 10:30:00	tuesday
2863	17	2017-03-12 11:00:00	sunday
2864	16	2017-03-05 12:15:00	sunday
2865	21	2017-03-01 13:15:00	wednesday
2866	23	2017-03-29 12:00:00	wednesday
2867	25	2017-03-05 12:00:00	sunday
2868	20	2017-03-29 17:00:00	wednesday
2869	31	2017-03-12 15:45:00	sunday
2870	13	2017-03-22 13:00:00	wednesday
2871	28	2017-03-18 17:15:00	saturday
2872	5	2017-03-14 13:30:00	tuesday
2873	13	2017-03-06 12:45:00	monday
2874	31	2017-03-03 13:15:00	friday
2875	27	2017-03-15 15:45:00	wednesday
2876	7	2017-03-25 16:45:00	saturday
2877	33	2017-03-01 13:00:00	wednesday
2878	14	2017-03-14 10:15:00	tuesday
2879	26	2017-03-23 14:45:00	thursday
2880	5	2017-03-21 13:30:00	tuesday
2881	13	2017-03-22 14:00:00	wednesday
2882	6	2017-03-08 14:15:00	wednesday
2883	19	2017-03-23 17:30:00	thursday
2884	7	2017-03-23 17:15:00	thursday
2885	37	2017-03-05 09:30:00	sunday
2886	8	2017-03-04 16:30:00	saturday
2887	40	2017-03-13 08:15:00	monday
2888	18	2017-03-23 08:15:00	thursday
2889	10	2017-03-27 15:30:00	monday
2890	15	2017-03-29 09:00:00	wednesday
2891	4	2017-03-13 14:00:00	monday
2892	23	2017-03-08 16:45:00	wednesday
2893	15	2017-03-04 17:00:00	saturday
2894	15	2017-03-29 11:00:00	wednesday
2895	9	2017-03-30 12:45:00	thursday
2896	17	2017-03-14 08:45:00	tuesday
2897	15	2017-03-24 17:45:00	friday
2898	24	2017-03-05 08:15:00	sunday
2899	34	2017-03-05 13:00:00	sunday
2900	34	2017-03-11 08:30:00	saturday
2901	12	2017-03-14 08:45:00	tuesday
2902	30	2017-03-21 09:15:00	tuesday
2903	18	2017-03-08 12:00:00	wednesday
2904	21	2017-03-17 17:15:00	friday
2905	33	2017-03-07 09:15:00	tuesday
2906	19	2017-03-15 13:45:00	wednesday
2907	2	2017-03-25 13:00:00	saturday
2908	29	2017-03-25 09:00:00	saturday
2909	31	2017-03-19 11:00:00	sunday
2910	3	2017-03-11 17:45:00	saturday
2911	37	2017-03-23 16:15:00	thursday
2912	28	2017-03-21 09:00:00	tuesday
2913	3	2017-03-09 12:45:00	thursday
2914	38	2017-03-06 10:30:00	monday
2915	7	2017-03-03 12:45:00	friday
2916	13	2017-03-13 09:45:00	monday
2917	13	2017-03-18 16:30:00	saturday
2918	32	2017-03-13 12:15:00	monday
2919	25	2017-03-05 10:00:00	sunday
2920	25	2017-03-23 16:45:00	thursday
2921	1	2017-03-22 14:00:00	wednesday
2922	35	2017-04-29 16:00:00	saturday
2923	6	2017-04-23 16:00:00	sunday
2924	4	2017-04-17 17:45:00	monday
2925	1	2017-04-25 11:00:00	tuesday
2926	34	2017-04-02 16:45:00	sunday
2927	24	2017-04-16 16:15:00	sunday
2928	16	2017-04-21 08:45:00	friday
2929	32	2017-04-14 14:45:00	friday
2930	39	2017-04-28 09:30:00	friday
2931	25	2017-04-15 16:45:00	saturday
2932	39	2017-04-29 14:45:00	saturday
2933	23	2017-04-03 17:30:00	monday
2934	29	2017-04-29 09:15:00	saturday
2935	22	2017-04-25 10:00:00	tuesday
2936	28	2017-04-26 08:30:00	wednesday
2937	11	2017-04-18 08:45:00	tuesday
2938	6	2017-04-11 13:15:00	tuesday
2939	15	2017-04-24 17:30:00	monday
2940	34	2017-04-16 12:45:00	sunday
2941	28	2017-04-22 11:15:00	saturday
2942	5	2017-04-19 09:45:00	wednesday
2943	39	2017-04-15 09:30:00	saturday
2944	26	2017-04-08 16:15:00	saturday
2945	6	2017-04-16 09:45:00	sunday
2946	36	2017-04-15 11:00:00	saturday
2947	10	2017-04-12 09:00:00	wednesday
2948	1	2017-04-11 09:00:00	tuesday
2949	20	2017-04-13 17:45:00	thursday
2950	22	2017-04-16 15:15:00	sunday
2951	40	2017-04-04 16:00:00	tuesday
2952	39	2017-04-20 14:00:00	thursday
2953	22	2017-04-15 16:45:00	saturday
2954	13	2017-04-16 08:00:00	sunday
2955	30	2017-04-16 13:45:00	sunday
2956	23	2017-04-03 16:45:00	monday
2957	1	2017-04-28 16:45:00	friday
2958	12	2017-04-14 08:15:00	friday
2959	5	2017-04-03 16:00:00	monday
2960	29	2017-04-11 09:00:00	tuesday
2961	39	2017-04-06 11:30:00	thursday
2962	37	2017-04-08 14:30:00	saturday
2963	39	2017-04-20 14:15:00	thursday
2964	26	2017-04-02 11:15:00	sunday
2965	9	2017-04-16 16:00:00	sunday
2966	3	2017-04-12 10:45:00	wednesday
2967	24	2017-04-27 09:15:00	thursday
2968	17	2017-04-26 16:00:00	wednesday
2969	3	2017-04-17 10:15:00	monday
2970	40	2017-04-14 17:30:00	friday
2971	18	2017-04-21 14:30:00	friday
2972	37	2017-04-29 12:45:00	saturday
2973	8	2017-04-24 14:30:00	monday
2974	31	2017-04-23 15:45:00	sunday
2975	16	2017-04-08 15:00:00	saturday
2976	31	2017-04-18 13:30:00	tuesday
2977	1	2017-04-29 16:45:00	saturday
2978	1	2017-04-16 15:00:00	sunday
2979	19	2017-04-19 16:45:00	wednesday
2980	19	2017-04-13 14:45:00	thursday
2981	1	2017-04-20 15:45:00	thursday
2982	35	2017-04-21 10:00:00	friday
2983	22	2017-04-09 16:45:00	sunday
2984	35	2017-04-09 16:00:00	sunday
2985	26	2017-04-17 16:15:00	monday
2986	30	2017-04-21 11:30:00	friday
2987	5	2017-04-13 16:45:00	thursday
2988	9	2017-04-25 08:15:00	tuesday
2989	32	2017-04-18 13:30:00	tuesday
2990	37	2017-04-10 10:45:00	monday
2991	32	2017-04-14 09:45:00	friday
2992	1	2017-04-21 11:00:00	friday
2993	4	2017-04-21 11:15:00	friday
2994	25	2017-04-18 12:30:00	tuesday
2995	28	2017-04-16 16:15:00	sunday
2996	36	2017-04-29 12:45:00	saturday
2997	34	2017-04-30 09:45:00	sunday
2998	39	2017-04-03 15:45:00	monday
2999	26	2017-04-19 11:45:00	wednesday
3000	13	2017-05-05 13:45:00	friday
3001	19	2017-05-11 15:15:00	thursday
3002	32	2017-05-10 16:00:00	wednesday
3003	20	2017-05-24 10:00:00	wednesday
3004	22	2017-05-01 12:45:00	monday
3005	18	2017-05-16 15:00:00	tuesday
3006	30	2017-05-17 11:45:00	wednesday
3007	7	2017-05-06 17:15:00	saturday
3008	26	2017-05-11 13:30:00	thursday
3009	25	2017-05-01 14:30:00	monday
3010	37	2017-05-30 15:30:00	tuesday
3011	18	2017-05-22 16:45:00	monday
3012	20	2017-05-08 09:45:00	monday
3013	28	2017-05-04 15:00:00	thursday
3014	23	2017-05-19 10:30:00	friday
3015	11	2017-05-19 10:00:00	friday
3016	6	2017-05-11 17:15:00	thursday
3017	21	2017-05-01 13:30:00	monday
3018	37	2017-05-01 12:15:00	monday
3019	34	2017-05-21 10:30:00	sunday
3020	34	2017-05-09 17:30:00	tuesday
3021	37	2017-05-10 16:45:00	wednesday
3022	28	2017-05-03 09:00:00	wednesday
3023	34	2017-05-02 16:45:00	tuesday
3024	3	2017-05-12 17:45:00	friday
3025	32	2017-05-04 13:15:00	thursday
3026	36	2017-05-28 11:15:00	sunday
3027	15	2017-05-05 11:30:00	friday
3028	4	2017-05-29 08:00:00	monday
3029	8	2017-05-04 15:15:00	thursday
3030	34	2017-05-10 09:15:00	wednesday
3031	1	2017-05-23 11:30:00	tuesday
3032	7	2017-05-14 12:45:00	sunday
3033	40	2017-05-13 14:45:00	saturday
3034	6	2017-05-26 10:00:00	friday
3035	37	2017-05-20 11:30:00	saturday
3036	6	2017-05-05 17:45:00	friday
3037	2	2017-05-14 14:30:00	sunday
3038	21	2017-05-08 10:45:00	monday
3039	20	2017-05-06 09:00:00	saturday
3040	28	2017-05-22 13:45:00	monday
3041	9	2017-05-24 12:45:00	wednesday
3042	23	2017-05-04 13:15:00	thursday
3043	33	2017-05-06 09:15:00	saturday
3044	36	2017-05-30 13:30:00	tuesday
3045	38	2017-05-25 08:45:00	thursday
3046	32	2017-05-15 08:15:00	monday
3047	6	2017-05-01 11:30:00	monday
3048	15	2017-05-27 14:30:00	saturday
3049	21	2017-05-16 15:45:00	tuesday
3050	11	2017-05-29 10:00:00	monday
3051	30	2017-05-17 08:00:00	wednesday
3052	9	2017-05-29 08:45:00	monday
3053	33	2017-05-13 14:15:00	saturday
3054	17	2017-05-06 10:45:00	saturday
3055	19	2017-05-20 10:30:00	saturday
3056	20	2017-05-08 17:45:00	monday
3057	19	2017-05-10 15:45:00	wednesday
3058	38	2017-05-28 17:00:00	sunday
3059	40	2017-05-04 16:45:00	thursday
3060	11	2017-05-10 12:00:00	wednesday
3061	30	2017-05-13 08:15:00	saturday
3062	3	2017-05-27 14:15:00	saturday
3063	24	2017-05-27 17:30:00	saturday
3064	15	2017-05-23 12:00:00	tuesday
3065	28	2017-05-24 16:00:00	wednesday
3066	35	2017-05-26 10:45:00	friday
3067	12	2017-05-04 12:00:00	thursday
3068	28	2017-05-01 16:45:00	monday
3069	1	2017-05-25 13:15:00	thursday
3070	1	2017-05-12 14:00:00	friday
3071	16	2017-05-20 12:15:00	saturday
3072	4	2017-05-28 10:15:00	sunday
3073	38	2017-05-25 15:30:00	thursday
3074	16	2017-05-12 10:00:00	friday
3075	13	2017-05-03 11:15:00	wednesday
3076	26	2017-05-21 12:30:00	sunday
3077	15	2017-05-04 13:15:00	thursday
3078	1	2017-06-22 14:30:00	thursday
3079	39	2017-06-01 13:00:00	thursday
3080	39	2017-06-06 08:00:00	tuesday
3081	13	2017-06-09 16:15:00	friday
3082	7	2017-06-02 10:15:00	friday
3083	24	2017-06-20 17:00:00	tuesday
3084	15	2017-06-12 13:00:00	monday
3085	3	2017-06-04 17:30:00	sunday
3086	13	2017-06-14 16:15:00	wednesday
3087	18	2017-06-24 14:15:00	saturday
3088	12	2017-06-12 08:30:00	monday
3089	36	2017-06-30 10:30:00	friday
3090	21	2017-06-05 11:45:00	monday
3091	32	2017-06-20 14:45:00	tuesday
3092	16	2017-06-11 14:30:00	sunday
3093	25	2017-06-15 12:15:00	thursday
3094	2	2017-06-01 12:00:00	thursday
3095	36	2017-06-24 09:00:00	saturday
3096	38	2017-06-11 14:30:00	sunday
3097	23	2017-06-09 14:00:00	friday
3098	7	2017-06-17 08:15:00	saturday
3099	34	2017-06-23 11:45:00	friday
3100	1	2017-06-30 17:15:00	friday
3101	38	2017-06-06 09:30:00	tuesday
3102	29	2017-06-30 14:45:00	friday
3103	34	2017-06-25 08:15:00	sunday
3104	35	2017-06-24 15:00:00	saturday
3105	35	2017-06-18 12:00:00	sunday
3106	23	2017-06-18 14:00:00	sunday
3107	32	2017-06-20 17:30:00	tuesday
3108	22	2017-06-04 08:30:00	sunday
3109	38	2017-06-23 13:30:00	friday
3110	16	2017-06-24 12:15:00	saturday
3111	15	2017-06-10 12:45:00	saturday
3112	29	2017-06-09 15:30:00	friday
3113	19	2017-06-04 15:00:00	sunday
3114	34	2017-06-21 09:30:00	wednesday
3115	1	2017-06-17 12:45:00	saturday
3116	35	2017-06-19 09:15:00	monday
3117	4	2017-06-11 09:45:00	sunday
3118	40	2017-06-14 12:45:00	wednesday
3119	24	2017-06-10 13:30:00	saturday
3120	10	2017-06-28 10:00:00	wednesday
3121	11	2017-06-11 12:15:00	sunday
3122	12	2017-06-28 08:45:00	wednesday
3123	22	2017-06-20 17:45:00	tuesday
3124	28	2017-06-08 15:30:00	thursday
3125	20	2017-06-08 08:45:00	thursday
3126	25	2017-06-26 14:45:00	monday
3127	8	2017-06-09 08:45:00	friday
3128	4	2017-06-30 17:45:00	friday
3129	32	2017-06-17 17:15:00	saturday
3130	9	2017-06-11 17:15:00	sunday
3131	38	2017-06-25 08:45:00	sunday
3132	28	2017-06-16 16:00:00	friday
3133	2	2017-06-30 11:15:00	friday
3134	30	2017-06-05 12:00:00	monday
3135	27	2017-06-27 08:15:00	tuesday
3136	32	2017-06-24 09:00:00	saturday
3137	29	2017-06-28 08:15:00	wednesday
3138	36	2017-06-11 10:15:00	sunday
3139	34	2017-06-19 13:15:00	monday
3140	33	2017-06-18 10:15:00	sunday
3141	27	2017-06-01 16:15:00	thursday
3142	21	2017-06-29 09:00:00	thursday
3143	38	2017-06-02 09:15:00	friday
3144	18	2017-06-19 10:00:00	monday
3145	7	2017-06-30 14:30:00	friday
3146	27	2017-06-07 10:30:00	wednesday
3147	16	2017-06-18 12:15:00	sunday
3148	22	2017-06-23 11:30:00	friday
3149	3	2017-06-08 09:45:00	thursday
3150	17	2017-06-23 15:15:00	friday
3151	36	2017-06-11 10:45:00	sunday
3152	6	2017-06-15 08:30:00	thursday
3153	33	2017-06-22 08:45:00	thursday
3154	9	2017-06-24 15:45:00	saturday
3155	11	2017-06-11 15:15:00	sunday
3156	14	2017-06-16 11:30:00	friday
3157	29	2017-06-19 17:45:00	monday
3158	37	2017-06-23 12:30:00	friday
3159	9	2017-06-27 09:00:00	tuesday
3160	8	2017-06-21 08:45:00	wednesday
3161	32	2017-06-06 12:45:00	tuesday
3162	9	2017-06-19 08:15:00	monday
3163	16	2017-06-24 12:30:00	saturday
3164	14	2017-06-12 12:45:00	monday
3165	13	2017-06-21 16:30:00	wednesday
3166	15	2017-06-26 11:45:00	monday
3167	2	2017-06-14 12:15:00	wednesday
3168	20	2017-06-15 11:30:00	thursday
3169	31	2017-06-05 16:00:00	monday
3170	32	2017-06-23 09:00:00	friday
3171	26	2017-06-03 08:45:00	saturday
3172	19	2017-06-12 13:30:00	monday
3173	15	2017-06-06 13:45:00	tuesday
3174	17	2017-06-16 15:15:00	friday
3175	3	2017-06-28 17:45:00	wednesday
3176	37	2017-06-22 09:15:00	thursday
3177	10	2017-06-23 17:15:00	friday
3178	11	2017-06-21 10:30:00	wednesday
3179	6	2017-07-07 08:30:00	friday
3180	7	2017-07-21 08:45:00	friday
3181	1	2017-07-10 13:30:00	monday
3182	40	2017-07-08 14:15:00	saturday
3183	14	2017-07-26 12:30:00	wednesday
3184	33	2017-07-10 08:45:00	monday
3185	38	2017-07-30 14:15:00	sunday
3186	4	2017-07-23 12:45:00	sunday
3187	23	2017-07-02 11:15:00	sunday
3188	7	2017-07-08 13:15:00	saturday
3189	20	2017-07-28 08:15:00	friday
3190	24	2017-07-28 16:45:00	friday
3191	34	2017-07-15 09:15:00	saturday
3192	2	2017-07-20 13:15:00	thursday
3193	30	2017-07-11 10:00:00	tuesday
3194	24	2017-07-13 08:15:00	thursday
3195	17	2017-07-21 09:15:00	friday
3196	15	2017-07-12 12:30:00	wednesday
3197	22	2017-07-28 17:45:00	friday
3198	21	2017-07-21 17:30:00	friday
3199	32	2017-07-15 17:00:00	saturday
3200	30	2017-07-21 12:30:00	friday
3201	14	2017-07-26 09:15:00	wednesday
3202	3	2017-07-26 16:00:00	wednesday
3203	33	2017-07-08 12:45:00	saturday
3204	18	2017-07-07 14:15:00	friday
3205	10	2017-07-13 10:45:00	thursday
3206	35	2017-07-02 10:30:00	sunday
3207	22	2017-07-07 17:45:00	friday
3208	39	2017-07-16 11:15:00	sunday
3209	35	2017-07-16 13:00:00	sunday
3210	33	2017-07-02 12:30:00	sunday
3211	18	2017-07-29 17:45:00	saturday
3212	38	2017-07-24 08:15:00	monday
3213	5	2017-07-09 11:45:00	sunday
3214	30	2017-07-16 08:45:00	sunday
3215	23	2017-07-26 12:15:00	wednesday
3216	26	2017-07-18 17:30:00	tuesday
3217	9	2017-07-01 09:30:00	saturday
3218	6	2017-07-03 09:15:00	monday
3219	1	2017-07-30 16:00:00	sunday
3220	6	2017-07-11 10:00:00	tuesday
3221	10	2017-07-05 15:00:00	wednesday
3222	26	2017-07-16 13:00:00	sunday
3223	40	2017-07-02 08:45:00	sunday
3224	27	2017-07-04 16:45:00	tuesday
3225	26	2017-07-12 16:00:00	wednesday
3226	6	2017-07-23 13:30:00	sunday
3227	17	2017-07-10 14:15:00	monday
3228	22	2017-07-17 15:15:00	monday
3229	29	2017-07-25 09:15:00	tuesday
3230	19	2017-07-27 11:30:00	thursday
3231	36	2017-07-18 15:00:00	tuesday
3232	31	2017-07-03 09:15:00	monday
3233	5	2017-07-09 16:15:00	sunday
3234	4	2017-07-19 11:45:00	wednesday
3235	6	2017-07-23 16:15:00	sunday
3236	1	2017-07-14 11:00:00	friday
3237	27	2017-07-17 08:30:00	monday
3238	4	2017-07-16 17:15:00	sunday
3239	24	2017-07-14 11:30:00	friday
3240	39	2017-07-16 13:15:00	sunday
3241	3	2017-07-22 15:00:00	saturday
3242	38	2017-07-17 09:15:00	monday
3243	13	2017-07-04 10:15:00	tuesday
3244	4	2017-07-27 12:45:00	thursday
3245	31	2017-07-21 14:45:00	friday
3246	35	2017-07-27 08:00:00	thursday
3247	23	2017-07-12 13:15:00	wednesday
3248	18	2017-07-28 17:30:00	friday
3249	26	2017-07-25 09:45:00	tuesday
3250	14	2017-07-03 09:15:00	monday
3251	33	2017-07-04 11:45:00	tuesday
3252	4	2017-07-15 11:00:00	saturday
3253	38	2017-07-11 15:15:00	tuesday
3254	18	2017-07-18 16:30:00	tuesday
3255	21	2017-07-05 10:15:00	wednesday
3256	27	2017-07-23 10:15:00	sunday
3257	22	2017-07-06 16:00:00	thursday
3258	33	2017-07-08 10:30:00	saturday
3259	15	2017-07-25 13:00:00	tuesday
3260	3	2017-07-25 17:00:00	tuesday
3261	11	2017-08-03 09:30:00	thursday
3262	30	2017-08-06 17:15:00	sunday
3263	7	2017-08-15 17:45:00	tuesday
3264	22	2017-08-04 11:30:00	friday
3265	9	2017-08-11 08:00:00	friday
3266	28	2017-08-03 15:15:00	thursday
3267	26	2017-08-09 17:15:00	wednesday
3268	30	2017-08-24 10:45:00	thursday
3269	3	2017-08-07 14:15:00	monday
3270	4	2017-08-17 15:45:00	thursday
3271	25	2017-08-25 15:30:00	friday
3272	38	2017-08-19 10:45:00	saturday
3273	10	2017-08-12 10:00:00	saturday
3274	25	2017-08-01 08:45:00	tuesday
3275	6	2017-08-10 17:15:00	thursday
3276	33	2017-08-05 14:00:00	saturday
3277	1	2017-08-23 12:00:00	wednesday
3278	22	2017-08-19 13:30:00	saturday
3279	37	2017-08-15 12:30:00	tuesday
3280	9	2017-08-15 13:30:00	tuesday
3281	26	2017-08-15 11:30:00	tuesday
3282	5	2017-08-19 17:15:00	saturday
3283	40	2017-08-24 16:30:00	thursday
3284	40	2017-08-19 16:30:00	saturday
3285	25	2017-08-09 08:30:00	wednesday
3286	1	2017-08-25 10:45:00	friday
3287	17	2017-08-29 16:00:00	tuesday
3288	9	2017-08-12 17:15:00	saturday
3289	7	2017-08-26 14:15:00	saturday
3290	12	2017-08-22 15:15:00	tuesday
3291	3	2017-08-05 11:30:00	saturday
3292	31	2017-08-27 08:00:00	sunday
3293	8	2017-08-24 14:00:00	thursday
3294	17	2017-08-07 08:00:00	monday
3295	9	2017-08-29 13:45:00	tuesday
3296	3	2017-08-15 16:45:00	tuesday
3297	29	2017-08-08 09:30:00	tuesday
3298	2	2017-08-21 14:45:00	monday
3299	20	2017-08-11 12:45:00	friday
3300	17	2017-08-20 08:45:00	sunday
3301	9	2017-08-09 17:00:00	wednesday
3302	18	2017-08-02 13:15:00	wednesday
3303	23	2017-08-29 14:00:00	tuesday
3304	28	2017-08-06 16:15:00	sunday
3305	14	2017-08-18 16:15:00	friday
3306	3	2017-08-29 17:45:00	tuesday
3307	38	2017-08-30 08:30:00	wednesday
3308	4	2017-08-11 09:15:00	friday
3309	24	2017-08-26 16:00:00	saturday
3310	31	2017-08-25 14:30:00	friday
3311	34	2017-08-01 14:15:00	tuesday
3312	22	2017-08-21 13:45:00	monday
3313	25	2017-08-04 13:30:00	friday
3314	26	2017-08-03 16:15:00	thursday
3315	13	2017-08-24 13:45:00	thursday
3316	3	2017-08-29 08:45:00	tuesday
3317	26	2017-08-12 09:30:00	saturday
3318	14	2017-08-13 10:15:00	sunday
3319	27	2017-08-22 10:00:00	tuesday
3320	22	2017-08-15 13:30:00	tuesday
3321	31	2017-08-13 09:00:00	sunday
3322	5	2017-08-25 17:45:00	friday
3323	22	2017-08-27 15:15:00	sunday
3324	9	2017-08-25 17:45:00	friday
3325	35	2017-08-27 08:15:00	sunday
3326	26	2017-08-25 10:00:00	friday
3327	40	2017-08-06 08:00:00	sunday
3328	40	2017-08-14 10:00:00	monday
3329	6	2017-08-21 09:00:00	monday
3330	38	2017-08-11 13:15:00	friday
3331	29	2017-08-05 09:00:00	saturday
3332	35	2017-08-22 10:30:00	tuesday
3333	37	2017-08-28 16:15:00	monday
3334	14	2017-08-16 09:00:00	wednesday
3335	37	2017-08-10 16:00:00	thursday
3336	7	2017-08-02 17:30:00	wednesday
3337	18	2017-08-14 16:15:00	monday
3338	19	2017-09-18 16:30:00	monday
3339	36	2017-09-09 14:00:00	saturday
3340	38	2017-09-16 11:00:00	saturday
3341	30	2017-09-25 14:45:00	monday
3342	7	2017-09-03 10:45:00	sunday
3343	29	2017-09-18 14:15:00	monday
3344	1	2017-09-20 14:15:00	wednesday
3345	6	2017-09-29 08:30:00	friday
3346	38	2017-09-10 17:15:00	sunday
3347	25	2017-09-27 09:45:00	wednesday
3348	28	2017-09-22 11:15:00	friday
3349	10	2017-09-07 09:00:00	thursday
3350	2	2017-09-09 13:45:00	saturday
3351	20	2017-09-18 08:30:00	monday
3352	9	2017-09-11 17:45:00	monday
3353	14	2017-09-10 11:30:00	sunday
3354	4	2017-09-26 17:15:00	tuesday
3355	24	2017-09-20 16:00:00	wednesday
3356	10	2017-09-23 09:15:00	saturday
3357	28	2017-09-12 13:15:00	tuesday
3358	33	2017-09-21 15:15:00	thursday
3359	23	2017-09-05 08:45:00	tuesday
3360	18	2017-09-18 08:00:00	monday
3361	7	2017-09-10 13:30:00	sunday
3362	17	2017-09-07 16:30:00	thursday
3363	12	2017-09-28 17:30:00	thursday
3364	20	2017-09-28 09:45:00	thursday
3365	16	2017-09-04 16:00:00	monday
3366	9	2017-09-18 16:30:00	monday
3367	33	2017-09-17 17:45:00	sunday
3368	26	2017-09-30 08:45:00	saturday
3369	20	2017-09-09 08:30:00	saturday
3370	18	2017-09-29 12:45:00	friday
3371	25	2017-09-10 14:00:00	sunday
3372	6	2017-09-05 15:30:00	tuesday
3373	3	2017-09-01 11:15:00	friday
3374	6	2017-09-11 14:15:00	monday
3375	38	2017-09-19 09:45:00	tuesday
3376	19	2017-09-03 16:30:00	sunday
3377	1	2017-09-11 14:00:00	monday
3378	40	2017-09-29 13:15:00	friday
3379	4	2017-09-18 15:45:00	monday
3380	28	2017-09-29 10:30:00	friday
3381	40	2017-09-27 09:30:00	wednesday
3382	4	2017-09-25 17:30:00	monday
3383	19	2017-09-18 17:15:00	monday
3384	10	2017-09-08 16:15:00	friday
3385	27	2017-09-24 08:00:00	sunday
3386	34	2017-09-07 12:00:00	thursday
3387	16	2017-09-24 14:45:00	sunday
3388	33	2017-09-02 13:45:00	saturday
3389	36	2017-09-06 12:30:00	wednesday
3390	39	2017-09-09 16:15:00	saturday
3391	20	2017-09-02 16:30:00	saturday
3392	27	2017-09-01 09:00:00	friday
3393	21	2017-09-16 10:00:00	saturday
3394	19	2017-09-24 12:15:00	sunday
3395	25	2017-09-04 14:30:00	monday
3396	27	2017-09-25 12:15:00	monday
3397	2	2017-09-08 16:00:00	friday
3398	2	2017-09-27 14:15:00	wednesday
3399	11	2017-09-05 08:45:00	tuesday
3400	34	2017-09-03 09:30:00	sunday
3401	20	2017-09-23 17:00:00	saturday
3402	23	2017-09-13 11:00:00	wednesday
3403	12	2017-09-04 11:45:00	monday
3404	4	2017-09-19 13:45:00	tuesday
3405	22	2017-09-01 11:45:00	friday
3406	3	2017-09-28 11:00:00	thursday
3407	23	2017-09-25 14:30:00	monday
3408	19	2017-09-08 08:15:00	friday
3409	19	2017-09-23 12:30:00	saturday
3410	9	2017-09-07 11:30:00	thursday
3411	5	2017-09-16 16:45:00	saturday
3412	10	2017-09-17 08:30:00	sunday
3413	5	2017-09-17 15:15:00	sunday
3414	36	2017-09-10 13:45:00	sunday
3415	25	2017-09-20 14:15:00	wednesday
3416	26	2017-09-05 09:15:00	tuesday
3417	15	2017-09-05 11:45:00	tuesday
3418	15	2017-09-05 12:30:00	tuesday
3419	22	2017-09-30 14:30:00	saturday
3420	31	2017-09-20 12:15:00	wednesday
3421	26	2017-09-30 16:45:00	saturday
3422	27	2017-09-04 15:15:00	monday
3423	15	2017-09-02 16:00:00	saturday
3424	27	2017-09-10 08:15:00	sunday
3425	3	2017-09-07 11:15:00	thursday
3426	11	2017-10-24 09:15:00	tuesday
3427	14	2017-10-26 11:30:00	thursday
3428	16	2017-10-01 10:45:00	sunday
3429	26	2017-10-14 11:45:00	saturday
3430	26	2017-10-02 08:30:00	monday
3431	20	2017-10-13 16:15:00	friday
3432	2	2017-10-30 12:30:00	monday
3433	19	2017-10-06 08:00:00	friday
3434	10	2017-10-11 17:30:00	wednesday
3435	30	2017-10-08 17:00:00	sunday
3436	26	2017-10-07 12:45:00	saturday
3437	16	2017-10-14 09:45:00	saturday
3438	6	2017-10-29 16:45:00	sunday
3439	29	2017-10-23 10:00:00	monday
3440	2	2017-10-07 12:30:00	saturday
3441	4	2017-10-04 16:00:00	wednesday
3442	1	2017-10-02 14:30:00	monday
3443	36	2017-10-28 15:45:00	saturday
3444	31	2017-10-06 10:30:00	friday
3445	16	2017-10-24 08:45:00	tuesday
3446	28	2017-10-04 17:30:00	wednesday
3447	13	2017-10-14 16:15:00	saturday
3448	33	2017-10-12 10:15:00	thursday
3449	9	2017-10-01 11:30:00	sunday
3450	10	2017-10-02 14:30:00	monday
3451	35	2017-10-20 08:00:00	friday
3452	4	2017-10-15 13:45:00	sunday
3453	7	2017-10-09 14:30:00	monday
3454	22	2017-10-04 16:45:00	wednesday
3455	33	2017-10-17 13:00:00	tuesday
3456	9	2017-10-12 08:00:00	thursday
3457	6	2017-10-04 11:00:00	wednesday
3458	18	2017-10-25 10:00:00	wednesday
3459	8	2017-10-06 10:00:00	friday
3460	4	2017-10-30 10:15:00	monday
3461	25	2017-10-30 11:45:00	monday
3462	25	2017-10-12 13:00:00	thursday
3463	12	2017-10-03 08:30:00	tuesday
3464	16	2017-10-04 12:30:00	wednesday
3465	24	2017-10-07 12:00:00	saturday
3466	29	2017-10-04 11:30:00	wednesday
3467	22	2017-10-02 16:30:00	monday
3468	29	2017-10-14 09:00:00	saturday
3469	24	2017-10-25 11:00:00	wednesday
3470	40	2017-10-11 12:00:00	wednesday
3471	26	2017-10-14 10:30:00	saturday
3472	40	2017-10-23 09:15:00	monday
3473	27	2017-10-11 16:30:00	wednesday
3474	14	2017-10-25 13:15:00	wednesday
3475	2	2017-10-11 11:45:00	wednesday
3476	10	2017-10-07 12:00:00	saturday
3477	2	2017-10-03 12:00:00	tuesday
3478	1	2017-10-10 16:00:00	tuesday
3479	24	2017-10-19 13:45:00	thursday
3480	22	2017-10-08 15:45:00	sunday
3481	9	2017-10-13 11:00:00	friday
3482	27	2017-10-23 08:30:00	monday
3483	7	2017-10-15 11:30:00	sunday
3484	38	2017-10-08 09:45:00	sunday
3485	35	2017-10-27 09:30:00	friday
3486	15	2017-10-10 12:15:00	tuesday
3487	17	2017-10-24 11:30:00	tuesday
3488	22	2017-10-10 08:15:00	tuesday
3489	9	2017-10-21 13:45:00	saturday
3490	7	2017-10-26 12:45:00	thursday
3491	25	2017-10-23 15:30:00	monday
3492	31	2017-10-29 13:15:00	sunday
3493	6	2017-10-17 14:30:00	tuesday
3494	29	2017-10-02 12:45:00	monday
3495	2	2017-10-14 17:30:00	saturday
3496	20	2017-10-16 16:30:00	monday
3497	20	2017-10-05 13:00:00	thursday
3498	21	2017-10-27 16:30:00	friday
3499	5	2017-10-22 09:30:00	sunday
3500	7	2017-10-05 17:00:00	thursday
3501	23	2017-10-19 10:00:00	thursday
3502	17	2017-10-17 12:00:00	tuesday
3503	30	2017-10-29 13:30:00	sunday
3504	20	2017-10-13 13:00:00	friday
3505	40	2017-10-23 15:00:00	monday
3506	35	2017-10-24 11:45:00	tuesday
3507	38	2017-10-10 17:30:00	tuesday
3508	20	2017-10-22 11:30:00	sunday
3509	35	2017-10-25 16:30:00	wednesday
3510	5	2017-10-08 15:45:00	sunday
3511	17	2017-10-24 14:30:00	tuesday
3512	17	2017-10-29 09:00:00	sunday
3513	33	2017-10-09 12:00:00	monday
3514	27	2017-10-14 11:45:00	saturday
3515	1	2017-10-28 13:30:00	saturday
3516	16	2017-10-11 17:45:00	wednesday
3517	13	2017-10-19 14:00:00	thursday
3518	39	2017-11-10 15:30:00	friday
3519	40	2017-11-07 11:15:00	tuesday
3520	1	2017-11-22 09:00:00	wednesday
3521	25	2017-11-19 13:15:00	sunday
3522	2	2017-11-10 16:15:00	friday
3523	33	2017-11-07 09:45:00	tuesday
3524	8	2017-11-29 15:00:00	wednesday
3525	17	2017-11-23 09:00:00	thursday
3526	33	2017-11-16 09:45:00	thursday
3527	30	2017-11-02 14:45:00	thursday
3528	15	2017-11-21 13:15:00	tuesday
3529	15	2017-11-21 10:45:00	tuesday
3530	13	2017-11-23 09:30:00	thursday
3531	18	2017-11-11 11:30:00	saturday
3532	8	2017-11-01 16:30:00	wednesday
3533	20	2017-11-03 08:15:00	friday
3534	32	2017-11-12 17:15:00	sunday
3535	32	2017-11-19 14:30:00	sunday
3536	38	2017-11-20 11:15:00	monday
3537	12	2017-11-29 17:45:00	wednesday
3538	22	2017-11-10 11:15:00	friday
3539	1	2017-11-02 08:45:00	thursday
3540	4	2017-11-12 09:00:00	sunday
3541	25	2017-11-03 15:15:00	friday
3542	24	2017-11-29 15:30:00	wednesday
3543	9	2017-11-14 11:00:00	tuesday
3544	11	2017-11-14 16:15:00	tuesday
3545	30	2017-11-13 11:15:00	monday
3546	10	2017-11-14 10:30:00	tuesday
3547	10	2017-11-04 10:45:00	saturday
3548	32	2017-11-13 14:15:00	monday
3549	13	2017-11-17 12:30:00	friday
3550	21	2017-11-12 08:30:00	sunday
3551	29	2017-11-25 09:30:00	saturday
3552	11	2017-11-28 08:30:00	tuesday
3553	17	2017-11-06 09:15:00	monday
3554	20	2017-11-18 16:15:00	saturday
3555	7	2017-11-27 16:30:00	monday
3556	7	2017-11-07 16:15:00	tuesday
3557	27	2017-11-18 12:45:00	saturday
3558	11	2017-11-12 16:45:00	sunday
3559	17	2017-11-18 09:30:00	saturday
3560	32	2017-11-20 09:15:00	monday
3561	40	2017-11-19 09:45:00	sunday
3562	2	2017-11-09 09:45:00	thursday
3563	14	2017-11-29 15:45:00	wednesday
3564	15	2017-11-07 11:00:00	tuesday
3565	16	2017-11-25 12:45:00	saturday
3566	22	2017-11-03 14:45:00	friday
3567	1	2017-11-23 16:15:00	thursday
3568	23	2017-11-03 15:30:00	friday
3569	23	2017-11-06 08:45:00	monday
3570	23	2017-11-30 08:45:00	thursday
3571	27	2017-11-28 15:30:00	tuesday
3572	19	2017-11-20 13:45:00	monday
3573	31	2017-11-16 16:45:00	thursday
3574	1	2017-11-16 11:15:00	thursday
3575	23	2017-11-16 11:30:00	thursday
3576	20	2017-11-13 10:45:00	monday
3577	2	2017-11-12 14:45:00	sunday
3578	31	2017-11-17 08:30:00	friday
3579	33	2017-11-05 17:45:00	sunday
3580	30	2017-11-20 11:00:00	monday
3581	20	2017-12-10 12:00:00	sunday
3582	26	2017-12-09 15:00:00	saturday
3583	9	2017-12-09 14:45:00	saturday
3584	35	2017-12-13 14:30:00	wednesday
3585	38	2017-12-23 10:15:00	saturday
3586	13	2017-12-19 09:00:00	tuesday
3587	4	2017-12-11 16:00:00	monday
3588	5	2017-12-06 11:45:00	wednesday
3589	4	2017-12-05 09:45:00	tuesday
3590	35	2017-12-07 16:00:00	thursday
3591	3	2017-12-29 13:15:00	friday
3592	8	2017-12-30 09:30:00	saturday
3593	39	2017-12-25 09:30:00	monday
3594	14	2017-12-26 17:00:00	tuesday
3595	33	2017-12-28 12:00:00	thursday
3596	37	2017-12-12 10:15:00	tuesday
3597	34	2017-12-27 16:15:00	wednesday
3598	26	2017-12-05 14:30:00	tuesday
3599	24	2017-12-10 14:30:00	sunday
3600	22	2017-12-03 12:45:00	sunday
3601	16	2017-12-03 11:15:00	sunday
3602	31	2017-12-13 09:30:00	wednesday
3603	19	2017-12-25 09:45:00	monday
3604	40	2017-12-17 10:00:00	sunday
3605	35	2017-12-21 17:15:00	thursday
3606	25	2017-12-12 08:45:00	tuesday
3607	20	2017-12-21 17:00:00	thursday
3608	19	2017-12-05 10:00:00	tuesday
3609	13	2017-12-21 15:00:00	thursday
3610	18	2017-12-14 11:30:00	thursday
3611	38	2017-12-04 16:00:00	monday
3612	19	2017-12-23 15:00:00	saturday
3613	2	2017-12-01 09:00:00	friday
3614	29	2017-12-19 09:45:00	tuesday
3615	4	2017-12-10 12:00:00	sunday
3616	34	2017-12-21 16:30:00	thursday
3617	19	2017-12-28 15:30:00	thursday
3618	20	2017-12-22 11:15:00	friday
3619	23	2017-12-30 16:15:00	saturday
3620	10	2017-12-01 10:00:00	friday
3621	11	2017-12-22 13:00:00	friday
3622	18	2017-12-02 17:00:00	saturday
3623	11	2017-12-18 10:30:00	monday
3624	22	2017-12-14 11:15:00	thursday
3625	21	2017-12-08 15:15:00	friday
3626	17	2017-12-13 08:30:00	wednesday
3627	33	2017-12-13 13:00:00	wednesday
3628	17	2017-12-26 14:45:00	tuesday
3629	19	2017-12-06 17:45:00	wednesday
3630	36	2017-12-21 16:45:00	thursday
3631	5	2017-12-27 09:15:00	wednesday
3632	28	2017-12-06 10:45:00	wednesday
3633	15	2017-12-17 14:15:00	sunday
3634	29	2017-12-10 13:00:00	sunday
3635	9	2017-12-22 14:15:00	friday
3636	4	2017-12-01 11:00:00	friday
3637	13	2017-12-09 17:00:00	saturday
3638	23	2017-12-07 14:30:00	thursday
3639	31	2017-12-20 10:00:00	wednesday
3640	25	2017-12-07 09:30:00	thursday
3641	14	2017-12-21 17:45:00	thursday
3642	12	2017-12-01 08:30:00	friday
3643	26	2017-12-07 17:30:00	thursday
3644	14	2017-12-30 17:45:00	saturday
3645	13	2017-12-15 14:30:00	friday
3646	31	2017-12-10 12:00:00	sunday
3647	36	2017-12-08 14:15:00	friday
3648	23	2017-12-04 09:15:00	monday
3649	13	2017-12-26 17:30:00	tuesday
3650	26	2017-12-13 11:15:00	wednesday
3651	22	2018-01-17 16:45:00	wednesday
3652	11	2018-01-15 13:15:00	monday
3653	39	2018-01-16 16:45:00	tuesday
3654	28	2018-01-28 12:30:00	sunday
3655	14	2018-01-15 10:30:00	monday
3656	37	2018-01-24 15:00:00	wednesday
3657	40	2018-01-19 09:30:00	friday
3658	10	2018-01-02 13:30:00	tuesday
3659	20	2018-01-12 17:45:00	friday
3660	7	2018-01-27 16:45:00	saturday
3661	20	2018-01-19 11:45:00	friday
3662	18	2018-01-22 10:45:00	monday
3663	18	2018-01-12 12:45:00	friday
3664	34	2018-01-07 16:15:00	sunday
3665	29	2018-01-02 11:45:00	tuesday
3666	20	2018-01-16 16:30:00	tuesday
3667	3	2018-01-23 16:00:00	tuesday
3668	34	2018-01-11 13:45:00	thursday
3669	14	2018-01-26 12:30:00	friday
3670	28	2018-01-26 14:15:00	friday
3671	1	2018-01-14 12:30:00	sunday
3672	9	2018-01-09 09:15:00	tuesday
3673	18	2018-01-03 17:30:00	wednesday
3674	28	2018-01-29 12:45:00	monday
3675	39	2018-01-26 17:00:00	friday
3676	33	2018-01-05 08:00:00	friday
3677	19	2018-01-04 17:00:00	thursday
3678	38	2018-01-30 14:00:00	tuesday
3679	31	2018-01-26 12:15:00	friday
3680	37	2018-01-14 15:00:00	sunday
3681	27	2018-01-01 17:00:00	monday
3682	38	2018-01-12 12:30:00	friday
3683	12	2018-01-04 16:15:00	thursday
3684	31	2018-01-13 11:30:00	saturday
3685	13	2018-01-29 11:15:00	monday
3686	37	2018-01-22 11:00:00	monday
3687	32	2018-01-25 16:15:00	thursday
3688	2	2018-01-26 15:30:00	friday
3689	4	2018-01-25 17:15:00	thursday
3690	15	2018-01-09 11:15:00	tuesday
3691	14	2018-01-27 10:30:00	saturday
3692	40	2018-01-19 14:00:00	friday
3693	33	2018-01-14 16:00:00	sunday
3694	21	2018-01-30 14:00:00	tuesday
3695	8	2018-01-22 10:45:00	monday
3696	29	2018-01-27 16:30:00	saturday
3697	40	2018-01-26 09:30:00	friday
3698	18	2018-01-20 11:30:00	saturday
3699	17	2018-01-17 12:30:00	wednesday
3700	9	2018-01-15 15:30:00	monday
3701	19	2018-01-09 12:30:00	tuesday
3702	25	2018-01-25 09:00:00	thursday
3703	27	2018-01-29 12:45:00	monday
3704	33	2018-01-23 15:00:00	tuesday
3705	37	2018-01-13 16:45:00	saturday
3706	35	2018-01-11 14:15:00	thursday
3707	1	2018-01-11 08:00:00	thursday
3708	37	2018-01-11 09:45:00	thursday
3709	8	2018-01-23 17:30:00	tuesday
3710	13	2018-01-10 13:45:00	wednesday
3711	21	2018-01-19 10:30:00	friday
3712	2	2018-01-16 11:30:00	tuesday
3713	6	2018-01-15 17:15:00	monday
3714	7	2018-01-17 09:15:00	wednesday
3715	33	2018-01-23 14:00:00	tuesday
3716	33	2018-01-15 09:00:00	monday
3717	10	2018-01-10 13:45:00	wednesday
3718	21	2018-01-11 09:45:00	thursday
3719	25	2018-01-28 13:30:00	sunday
3720	5	2018-01-20 15:45:00	saturday
3721	14	2018-01-15 14:00:00	monday
3722	10	2018-01-20 13:30:00	saturday
3723	31	2018-01-05 11:00:00	friday
3724	24	2018-01-25 17:15:00	thursday
3725	21	2018-01-11 14:30:00	thursday
3726	15	2018-01-23 09:45:00	tuesday
3727	37	2018-02-07 11:00:00	wednesday
3728	5	2018-02-16 17:30:00	friday
3729	2	2018-02-22 17:45:00	thursday
3730	22	2018-02-02 17:15:00	friday
3731	13	2018-02-04 15:00:00	sunday
3732	39	2018-02-24 09:45:00	saturday
3733	31	2018-02-09 08:15:00	friday
3734	36	2018-02-24 17:45:00	saturday
3735	11	2018-02-07 16:15:00	wednesday
3736	31	2018-02-02 16:45:00	friday
3737	31	2018-02-04 14:45:00	sunday
3738	18	2018-02-22 09:30:00	thursday
3739	17	2018-02-21 14:45:00	wednesday
3740	16	2018-02-22 14:30:00	thursday
3741	27	2018-02-23 14:30:00	friday
3742	10	2018-02-14 16:45:00	wednesday
3743	1	2018-02-13 10:45:00	tuesday
3744	6	2018-02-05 09:00:00	monday
3745	23	2018-02-24 08:30:00	saturday
3746	39	2018-02-10 09:30:00	saturday
3747	21	2018-02-05 11:00:00	monday
3748	10	2018-02-04 15:45:00	sunday
3749	21	2018-02-06 11:15:00	tuesday
3750	4	2018-02-13 17:45:00	tuesday
3751	9	2018-02-13 16:00:00	tuesday
3752	30	2018-02-03 10:45:00	saturday
3753	7	2018-02-10 10:45:00	saturday
3754	19	2018-02-05 16:00:00	monday
3755	22	2018-02-05 15:00:00	monday
3756	22	2018-02-14 09:30:00	wednesday
3757	16	2018-02-09 12:00:00	friday
3758	31	2018-02-04 08:00:00	sunday
3759	32	2018-02-06 09:30:00	tuesday
3760	36	2018-02-07 15:00:00	wednesday
3761	19	2018-02-20 16:45:00	tuesday
3762	2	2018-02-03 12:00:00	saturday
3763	24	2018-02-12 08:15:00	monday
3764	11	2018-02-05 14:00:00	monday
3765	2	2018-02-13 08:00:00	tuesday
3766	6	2018-02-17 13:15:00	saturday
3767	34	2018-02-21 15:45:00	wednesday
3768	12	2018-02-01 17:30:00	thursday
3769	31	2018-02-23 12:30:00	friday
3770	38	2018-02-04 10:30:00	sunday
3771	31	2018-02-07 08:30:00	wednesday
3772	2	2018-02-19 10:45:00	monday
3773	29	2018-02-10 14:45:00	saturday
3774	29	2018-02-11 11:30:00	sunday
3775	27	2018-02-25 17:30:00	sunday
3776	32	2018-02-21 15:00:00	wednesday
3777	7	2018-02-01 11:00:00	thursday
3778	29	2018-02-24 13:45:00	saturday
3779	39	2018-02-18 10:00:00	sunday
3780	25	2018-02-09 10:45:00	friday
3781	30	2018-02-23 16:15:00	friday
3782	1	2018-02-02 17:45:00	friday
3783	39	2018-02-07 09:45:00	wednesday
3784	22	2018-02-14 14:00:00	wednesday
3785	6	2018-02-06 12:45:00	tuesday
3786	3	2018-02-15 13:00:00	thursday
3787	28	2018-02-04 08:45:00	sunday
3788	11	2018-02-12 09:45:00	monday
3789	1	2018-02-24 11:00:00	saturday
3790	22	2018-02-02 08:45:00	friday
3791	25	2018-02-18 11:00:00	sunday
3792	18	2018-02-22 14:30:00	thursday
3793	2	2018-02-17 11:45:00	saturday
3794	27	2018-02-01 11:45:00	thursday
3795	10	2018-02-25 14:30:00	sunday
3796	13	2018-02-10 17:00:00	saturday
3797	34	2018-02-18 15:30:00	sunday
3798	14	2018-02-04 16:45:00	sunday
3799	15	2018-02-26 10:30:00	monday
3800	7	2018-02-12 13:00:00	monday
3801	29	2018-02-23 16:30:00	friday
3802	33	2018-02-18 13:15:00	sunday
3803	12	2018-02-26 08:30:00	monday
3804	2	2018-02-21 16:00:00	wednesday
3805	5	2018-02-21 10:45:00	wednesday
3806	7	2018-02-14 11:30:00	wednesday
3807	36	2018-02-17 10:15:00	saturday
3808	9	2018-02-08 12:30:00	thursday
3809	5	2018-02-19 13:45:00	monday
3810	34	2018-03-26 14:15:00	monday
3811	40	2018-03-21 12:15:00	wednesday
3812	23	2018-03-07 15:30:00	wednesday
3813	14	2018-03-18 09:45:00	sunday
3814	21	2018-03-21 11:30:00	wednesday
3815	11	2018-03-21 08:00:00	wednesday
3816	21	2018-03-30 14:30:00	friday
3817	28	2018-03-14 09:15:00	wednesday
3818	2	2018-03-22 10:30:00	thursday
3819	16	2018-03-27 11:15:00	tuesday
3820	7	2018-03-06 15:45:00	tuesday
3821	9	2018-03-17 12:45:00	saturday
3822	27	2018-03-17 10:15:00	saturday
3823	18	2018-03-12 14:00:00	monday
3824	6	2018-03-10 15:45:00	saturday
3825	7	2018-03-05 11:15:00	monday
3826	11	2018-03-16 08:00:00	friday
3827	34	2018-03-12 12:00:00	monday
3828	38	2018-03-06 17:15:00	tuesday
3829	26	2018-03-07 14:15:00	wednesday
3830	5	2018-03-14 10:00:00	wednesday
3831	27	2018-03-15 16:30:00	thursday
3832	9	2018-03-08 17:00:00	thursday
3833	34	2018-03-25 09:30:00	sunday
3834	35	2018-03-15 15:00:00	thursday
3835	8	2018-03-01 08:45:00	thursday
3836	17	2018-03-27 17:00:00	tuesday
3837	28	2018-03-04 08:15:00	sunday
3838	24	2018-03-28 14:15:00	wednesday
3839	35	2018-03-19 09:15:00	monday
3840	33	2018-03-29 11:15:00	thursday
3841	17	2018-03-08 17:30:00	thursday
3842	6	2018-03-01 15:00:00	thursday
3843	23	2018-03-06 12:15:00	tuesday
3844	27	2018-03-14 17:45:00	wednesday
3845	29	2018-03-27 09:15:00	tuesday
3846	7	2018-03-26 14:00:00	monday
3847	30	2018-03-25 10:00:00	sunday
3848	34	2018-03-03 14:15:00	saturday
3849	32	2018-03-05 08:45:00	monday
3850	6	2018-03-24 09:15:00	saturday
3851	27	2018-03-22 12:00:00	thursday
3852	1	2018-03-30 14:30:00	friday
3853	31	2018-03-11 14:15:00	sunday
3854	23	2018-03-18 17:30:00	sunday
3855	32	2018-03-04 11:45:00	sunday
3856	33	2018-03-21 10:15:00	wednesday
3857	3	2018-03-16 10:30:00	friday
3858	18	2018-03-01 17:30:00	thursday
3859	24	2018-03-26 14:30:00	monday
3860	14	2018-03-05 09:15:00	monday
3861	15	2018-03-23 14:45:00	friday
3862	27	2018-03-21 16:30:00	wednesday
3863	21	2018-03-19 10:30:00	monday
3864	25	2018-03-13 10:30:00	tuesday
3865	6	2018-03-14 13:45:00	wednesday
3866	27	2018-03-14 09:30:00	wednesday
3867	34	2018-03-19 13:00:00	monday
3868	38	2018-03-18 14:45:00	sunday
3869	18	2018-03-22 14:45:00	thursday
3870	31	2018-03-24 17:15:00	saturday
3871	9	2018-03-28 12:00:00	wednesday
3872	39	2018-03-29 13:15:00	thursday
3873	5	2018-03-07 15:00:00	wednesday
3874	15	2018-03-04 12:15:00	sunday
3875	21	2018-03-26 11:45:00	monday
3876	6	2018-03-06 17:45:00	tuesday
3877	2	2018-03-19 09:15:00	monday
3878	16	2018-03-21 12:00:00	wednesday
3879	24	2018-03-20 09:00:00	tuesday
3880	6	2018-03-20 11:00:00	tuesday
3881	35	2018-03-08 12:00:00	thursday
3882	26	2018-03-06 17:00:00	tuesday
3883	20	2018-03-22 14:45:00	thursday
3884	17	2018-03-03 16:00:00	saturday
3885	36	2018-03-19 16:00:00	monday
3886	9	2018-03-01 10:45:00	thursday
3887	29	2018-03-14 08:00:00	wednesday
3888	10	2018-04-20 10:45:00	friday
3889	14	2018-04-21 08:45:00	saturday
3890	31	2018-04-24 11:30:00	tuesday
3891	37	2018-04-28 09:00:00	saturday
3892	35	2018-04-04 09:45:00	wednesday
3893	4	2018-04-09 08:45:00	monday
3894	22	2018-04-25 14:45:00	wednesday
3895	22	2018-04-03 08:30:00	tuesday
3896	16	2018-04-26 17:30:00	thursday
3897	32	2018-04-01 11:15:00	sunday
3898	2	2018-04-20 14:00:00	friday
3899	18	2018-04-30 14:30:00	monday
3900	9	2018-04-07 16:15:00	saturday
3901	14	2018-04-04 17:15:00	wednesday
3902	20	2018-04-23 08:00:00	monday
3903	13	2018-04-01 12:45:00	sunday
3904	27	2018-04-17 11:15:00	tuesday
3905	30	2018-04-12 14:15:00	thursday
3906	16	2018-04-24 08:00:00	tuesday
3907	17	2018-04-07 15:45:00	saturday
3908	7	2018-04-04 10:30:00	wednesday
3909	13	2018-04-14 15:15:00	saturday
3910	23	2018-04-29 17:45:00	sunday
3911	16	2018-04-18 08:00:00	wednesday
3912	40	2018-04-25 08:15:00	wednesday
3913	29	2018-04-17 14:15:00	tuesday
3914	36	2018-04-30 17:45:00	monday
3915	4	2018-04-27 12:15:00	friday
3916	32	2018-04-17 14:00:00	tuesday
3917	23	2018-04-09 15:30:00	monday
3918	26	2018-04-07 14:30:00	saturday
3919	17	2018-04-15 16:45:00	sunday
3920	26	2018-04-29 11:15:00	sunday
3921	39	2018-04-15 08:00:00	sunday
3922	2	2018-04-30 13:30:00	monday
3923	24	2018-04-03 13:00:00	tuesday
3924	24	2018-04-28 14:30:00	saturday
3925	15	2018-04-02 17:30:00	monday
3926	25	2018-04-13 11:15:00	friday
3927	5	2018-04-10 14:30:00	tuesday
3928	13	2018-04-30 13:30:00	monday
3929	1	2018-04-21 11:00:00	saturday
3930	31	2018-04-12 16:00:00	thursday
3931	9	2018-04-16 10:30:00	monday
3932	4	2018-04-09 14:15:00	monday
3933	24	2018-04-29 11:15:00	sunday
3934	32	2018-04-18 10:45:00	wednesday
3935	8	2018-04-13 12:00:00	friday
3936	38	2018-04-06 16:45:00	friday
3937	23	2018-04-18 10:30:00	wednesday
3938	7	2018-04-05 09:45:00	thursday
3939	19	2018-04-25 11:45:00	wednesday
3940	23	2018-04-22 08:30:00	sunday
3941	23	2018-04-20 12:30:00	friday
3942	20	2018-04-27 10:15:00	friday
3943	6	2018-04-04 17:15:00	wednesday
3944	8	2018-04-29 08:45:00	sunday
3945	29	2018-04-07 09:15:00	saturday
3946	28	2018-04-26 10:00:00	thursday
3947	34	2018-04-18 11:00:00	wednesday
3948	29	2018-04-07 16:15:00	saturday
3949	25	2018-04-13 14:15:00	friday
3950	33	2018-04-24 08:00:00	tuesday
3951	35	2018-04-13 09:30:00	friday
3952	8	2018-04-11 12:00:00	wednesday
3953	14	2018-04-03 12:30:00	tuesday
3954	28	2018-04-13 14:45:00	friday
3955	18	2018-04-24 13:15:00	tuesday
3956	11	2018-04-18 08:00:00	wednesday
3957	32	2018-04-07 09:15:00	saturday
3958	26	2018-04-14 14:00:00	saturday
3959	11	2018-05-05 17:15:00	saturday
3960	1	2018-05-08 11:15:00	tuesday
3961	40	2018-05-29 12:45:00	tuesday
3962	19	2018-05-21 10:30:00	monday
3963	31	2018-05-12 10:45:00	saturday
3964	12	2018-05-19 17:00:00	saturday
3965	17	2018-05-04 12:45:00	friday
3966	35	2018-05-22 11:15:00	tuesday
3967	25	2018-05-16 15:00:00	wednesday
3968	31	2018-05-09 17:15:00	wednesday
3969	29	2018-05-30 10:15:00	wednesday
3970	36	2018-05-25 12:30:00	friday
3971	5	2018-05-03 17:45:00	thursday
3972	37	2018-05-18 10:30:00	friday
3973	24	2018-05-20 10:15:00	sunday
3974	9	2018-05-24 08:30:00	thursday
3975	3	2018-05-30 15:15:00	wednesday
3976	15	2018-05-01 17:00:00	tuesday
3977	27	2018-05-18 08:15:00	friday
3978	19	2018-05-27 17:45:00	sunday
3979	39	2018-05-04 15:00:00	friday
3980	33	2018-05-13 17:15:00	sunday
3981	33	2018-05-04 13:30:00	friday
3982	39	2018-05-01 15:15:00	tuesday
3983	35	2018-05-22 16:30:00	tuesday
3984	12	2018-05-14 12:00:00	monday
3985	4	2018-05-14 08:45:00	monday
3986	37	2018-05-24 17:15:00	thursday
3987	19	2018-05-30 14:00:00	wednesday
3988	4	2018-05-16 16:00:00	wednesday
3989	40	2018-05-19 15:15:00	saturday
3990	1	2018-05-27 12:30:00	sunday
3991	23	2018-05-09 13:00:00	wednesday
3992	35	2018-05-09 12:30:00	wednesday
3993	6	2018-05-28 13:15:00	monday
3994	5	2018-05-02 14:30:00	wednesday
3995	19	2018-05-22 13:45:00	tuesday
3996	11	2018-05-10 12:30:00	thursday
3997	16	2018-05-06 17:30:00	sunday
3998	4	2018-05-22 16:15:00	tuesday
3999	17	2018-05-15 12:45:00	tuesday
4000	7	2018-05-09 09:15:00	wednesday
4001	3	2018-05-23 15:15:00	wednesday
4002	32	2018-05-13 10:45:00	sunday
4003	12	2018-05-07 10:30:00	monday
4004	34	2018-05-07 10:15:00	monday
4005	7	2018-05-30 08:15:00	wednesday
4006	35	2018-05-26 08:45:00	saturday
4007	6	2018-05-15 13:15:00	tuesday
4008	5	2018-05-28 08:45:00	monday
4009	16	2018-05-05 16:45:00	saturday
4010	1	2018-05-03 13:00:00	thursday
4011	2	2018-05-08 15:45:00	tuesday
4012	35	2018-05-10 13:00:00	thursday
4013	24	2018-05-18 14:45:00	friday
4014	19	2018-05-02 12:30:00	wednesday
4015	27	2018-05-29 15:15:00	tuesday
4016	24	2018-05-01 10:15:00	tuesday
4017	33	2018-05-15 17:15:00	tuesday
4018	12	2018-05-20 15:15:00	sunday
4019	17	2018-05-30 09:30:00	wednesday
4020	36	2018-05-17 09:30:00	thursday
4021	38	2018-05-05 15:45:00	saturday
4022	7	2018-05-28 09:45:00	monday
4023	10	2018-05-21 14:15:00	monday
4024	36	2018-05-26 09:30:00	saturday
4025	18	2018-05-21 15:00:00	monday
4026	14	2018-05-21 13:30:00	monday
4027	29	2018-05-28 08:00:00	monday
4028	9	2018-05-15 14:00:00	tuesday
4029	22	2018-05-04 08:15:00	friday
4030	19	2018-05-29 14:00:00	tuesday
4031	16	2018-05-26 08:30:00	saturday
4032	22	2018-05-07 15:00:00	monday
4033	22	2018-05-09 16:45:00	wednesday
4034	26	2018-05-26 12:00:00	saturday
4035	10	2018-05-19 11:15:00	saturday
4036	13	2018-05-30 17:45:00	wednesday
4037	37	2018-05-06 11:45:00	sunday
4038	28	2018-05-27 17:00:00	sunday
4039	40	2018-05-29 08:45:00	tuesday
4040	1	2018-05-22 15:00:00	tuesday
4041	3	2018-05-10 12:45:00	thursday
4042	21	2018-05-29 15:15:00	tuesday
4043	20	2018-05-16 13:45:00	wednesday
4044	28	2018-05-10 15:30:00	thursday
4045	13	2018-05-03 16:30:00	thursday
4046	38	2018-05-16 10:45:00	wednesday
4047	32	2018-05-29 09:00:00	tuesday
4048	17	2018-05-11 12:00:00	friday
4049	36	2018-06-17 14:15:00	sunday
4050	26	2018-06-20 16:15:00	wednesday
4051	7	2018-06-23 15:00:00	saturday
4052	35	2018-06-21 08:00:00	thursday
4053	35	2018-06-10 12:45:00	sunday
4054	27	2018-06-14 08:30:00	thursday
4055	27	2018-06-13 15:30:00	wednesday
4056	3	2018-06-24 11:00:00	sunday
4057	28	2018-06-05 16:45:00	tuesday
4058	13	2018-06-08 17:15:00	friday
4059	30	2018-06-13 16:00:00	wednesday
4060	29	2018-06-05 14:45:00	tuesday
4061	3	2018-06-23 10:30:00	saturday
4062	25	2018-06-16 16:00:00	saturday
4063	36	2018-06-12 12:30:00	tuesday
4064	11	2018-06-01 10:45:00	friday
4065	33	2018-06-23 15:15:00	saturday
4066	27	2018-06-29 08:15:00	friday
4067	15	2018-06-08 17:45:00	friday
4068	39	2018-06-10 08:15:00	sunday
4069	17	2018-06-23 08:15:00	saturday
4070	12	2018-06-12 10:45:00	tuesday
4071	17	2018-06-19 08:00:00	tuesday
4072	27	2018-06-10 13:00:00	sunday
4073	29	2018-06-18 15:15:00	monday
4074	31	2018-06-11 14:30:00	monday
4075	20	2018-06-21 16:45:00	thursday
4076	35	2018-06-22 13:30:00	friday
4077	32	2018-06-26 08:30:00	tuesday
4078	23	2018-06-29 10:00:00	friday
4079	20	2018-06-07 14:45:00	thursday
4080	25	2018-06-01 11:15:00	friday
4081	13	2018-06-11 16:00:00	monday
4082	22	2018-06-02 08:00:00	saturday
4083	35	2018-06-22 09:00:00	friday
4084	8	2018-06-07 10:30:00	thursday
4085	14	2018-06-09 09:30:00	saturday
4086	30	2018-06-23 15:00:00	saturday
4087	26	2018-06-01 11:00:00	friday
4088	1	2018-06-28 17:45:00	thursday
4089	13	2018-06-02 13:00:00	saturday
4090	27	2018-06-22 15:45:00	friday
4091	30	2018-06-14 10:00:00	thursday
4092	24	2018-06-07 13:15:00	thursday
4093	14	2018-06-07 09:45:00	thursday
4094	38	2018-06-22 16:00:00	friday
4095	16	2018-06-30 09:15:00	saturday
4096	14	2018-06-23 15:00:00	saturday
4097	33	2018-06-17 15:15:00	sunday
4098	2	2018-06-22 13:45:00	friday
4099	2	2018-06-04 13:30:00	monday
4100	7	2018-06-06 10:15:00	wednesday
4101	27	2018-06-13 10:45:00	wednesday
4102	2	2018-06-01 13:45:00	friday
4103	8	2018-06-13 10:45:00	wednesday
4104	20	2018-06-22 14:00:00	friday
4105	21	2018-06-05 14:00:00	tuesday
4106	8	2018-06-04 12:45:00	monday
4107	11	2018-06-25 16:45:00	monday
4108	1	2018-06-10 08:00:00	sunday
4109	27	2018-06-08 17:30:00	friday
4110	7	2018-06-28 13:30:00	thursday
4111	39	2018-06-22 09:45:00	friday
4112	16	2018-06-07 17:15:00	thursday
4113	13	2018-06-05 12:45:00	tuesday
4114	40	2018-06-29 10:00:00	friday
4115	21	2018-06-04 17:15:00	monday
4116	27	2018-06-04 16:15:00	monday
4117	40	2018-06-29 13:45:00	friday
4118	24	2018-06-18 17:00:00	monday
4119	9	2018-06-22 13:15:00	friday
4120	29	2018-07-02 17:15:00	monday
4121	37	2018-07-14 08:15:00	saturday
4122	31	2018-07-20 11:15:00	friday
4123	28	2018-07-14 17:00:00	saturday
4124	17	2018-07-27 10:45:00	friday
4125	15	2018-07-23 14:15:00	monday
4126	1	2018-07-02 09:30:00	monday
4127	26	2018-07-15 16:45:00	sunday
4128	16	2018-07-30 15:15:00	monday
4129	1	2018-07-10 16:45:00	tuesday
4130	40	2018-07-19 11:15:00	thursday
4131	4	2018-07-26 14:30:00	thursday
4132	37	2018-07-01 14:30:00	sunday
4133	36	2018-07-21 16:00:00	saturday
4134	39	2018-07-22 08:45:00	sunday
4135	21	2018-07-22 14:45:00	sunday
4136	12	2018-07-05 12:15:00	thursday
4137	4	2018-07-14 10:15:00	saturday
4138	23	2018-07-15 13:15:00	sunday
4139	8	2018-07-03 14:15:00	tuesday
4140	6	2018-07-23 14:30:00	monday
4141	35	2018-07-24 12:45:00	tuesday
4142	29	2018-07-27 16:30:00	friday
4143	8	2018-07-29 17:30:00	sunday
4144	5	2018-07-14 13:00:00	saturday
4145	36	2018-07-17 13:15:00	tuesday
4146	9	2018-07-29 16:45:00	sunday
4147	38	2018-07-26 08:45:00	thursday
4148	13	2018-07-07 16:30:00	saturday
4149	16	2018-07-09 14:30:00	monday
4150	31	2018-07-10 11:00:00	tuesday
4151	37	2018-07-01 14:15:00	sunday
4152	40	2018-07-15 09:15:00	sunday
4153	35	2018-07-04 14:15:00	wednesday
4154	10	2018-07-15 10:15:00	sunday
4155	1	2018-07-18 12:15:00	wednesday
4156	16	2018-07-29 12:45:00	sunday
4157	39	2018-07-21 13:45:00	saturday
4158	26	2018-07-01 11:45:00	sunday
4159	26	2018-07-22 16:00:00	sunday
4160	24	2018-07-21 16:00:00	saturday
4161	38	2018-07-13 15:00:00	friday
4162	4	2018-07-13 09:00:00	friday
4163	12	2018-07-02 16:45:00	monday
4164	35	2018-07-05 15:00:00	thursday
4165	4	2018-07-03 10:45:00	tuesday
4166	10	2018-07-04 12:30:00	wednesday
4167	9	2018-07-04 17:15:00	wednesday
4168	10	2018-07-10 14:45:00	tuesday
4169	34	2018-07-25 14:00:00	wednesday
4170	37	2018-07-17 16:00:00	tuesday
4171	36	2018-07-06 12:00:00	friday
4172	9	2018-07-06 08:30:00	friday
4173	34	2018-07-18 12:30:00	wednesday
4174	26	2018-07-01 08:00:00	sunday
4175	31	2018-07-30 09:30:00	monday
4176	33	2018-07-28 17:15:00	saturday
4177	9	2018-07-14 10:30:00	saturday
4178	33	2018-07-01 10:15:00	sunday
4179	21	2018-07-20 14:00:00	friday
4180	38	2018-07-04 11:45:00	wednesday
4181	7	2018-07-28 12:15:00	saturday
4182	6	2018-07-28 10:15:00	saturday
4183	9	2018-07-01 13:45:00	sunday
4184	17	2018-07-09 14:15:00	monday
4185	32	2018-07-27 17:45:00	friday
4186	35	2018-07-03 08:45:00	tuesday
4187	12	2018-07-09 14:00:00	monday
4188	6	2018-07-30 16:30:00	monday
4189	21	2018-07-18 17:45:00	wednesday
4190	34	2018-07-22 17:00:00	sunday
4191	25	2018-07-26 14:30:00	thursday
4192	31	2018-07-21 12:45:00	saturday
4193	35	2018-07-19 17:00:00	thursday
4194	31	2018-07-09 08:00:00	monday
4195	27	2018-07-29 17:00:00	sunday
4196	30	2018-07-06 15:45:00	friday
4197	26	2018-07-18 16:30:00	wednesday
4198	27	2018-07-04 09:30:00	wednesday
4199	12	2018-07-06 14:30:00	friday
4200	6	2018-07-16 14:45:00	monday
4201	5	2018-07-08 15:00:00	sunday
4202	10	2018-07-08 10:15:00	sunday
4203	22	2018-07-15 17:15:00	sunday
4204	34	2018-07-02 10:30:00	monday
4205	16	2018-08-07 16:15:00	tuesday
4206	29	2018-08-30 16:00:00	thursday
4207	14	2018-08-28 09:00:00	tuesday
4208	11	2018-08-12 17:45:00	sunday
4209	36	2018-08-02 12:00:00	thursday
4210	31	2018-08-19 13:15:00	sunday
4211	3	2018-08-22 14:15:00	wednesday
4212	37	2018-08-02 13:15:00	thursday
4213	4	2018-08-19 10:00:00	sunday
4214	11	2018-08-27 16:00:00	monday
4215	34	2018-08-21 11:00:00	tuesday
4216	25	2018-08-17 16:00:00	friday
4217	35	2018-08-30 14:45:00	thursday
4218	18	2018-08-08 16:15:00	wednesday
4219	5	2018-08-12 16:30:00	sunday
4220	35	2018-08-15 13:45:00	wednesday
4221	34	2018-08-21 12:30:00	tuesday
4222	17	2018-08-14 09:15:00	tuesday
4223	38	2018-08-07 15:15:00	tuesday
4224	5	2018-08-05 16:30:00	sunday
4225	37	2018-08-04 09:00:00	saturday
4226	32	2018-08-20 17:00:00	monday
4227	32	2018-08-08 16:00:00	wednesday
4228	17	2018-08-29 17:00:00	wednesday
4229	14	2018-08-22 13:45:00	wednesday
4230	36	2018-08-03 09:15:00	friday
4231	37	2018-08-08 08:15:00	wednesday
4232	10	2018-08-29 16:45:00	wednesday
4233	16	2018-08-20 12:30:00	monday
4234	21	2018-08-29 08:15:00	wednesday
4235	31	2018-08-24 17:00:00	friday
4236	10	2018-08-07 13:30:00	tuesday
4237	4	2018-08-29 11:00:00	wednesday
4238	23	2018-08-07 15:00:00	tuesday
4239	10	2018-08-07 12:30:00	tuesday
4240	28	2018-08-18 08:15:00	saturday
4241	30	2018-08-25 12:30:00	saturday
4242	20	2018-08-22 10:30:00	wednesday
4243	16	2018-08-17 15:30:00	friday
4244	2	2018-08-19 15:00:00	sunday
4245	8	2018-08-23 10:15:00	thursday
4246	38	2018-08-20 16:00:00	monday
4247	11	2018-08-24 17:00:00	friday
4248	7	2018-08-22 17:45:00	wednesday
4249	28	2018-08-19 17:45:00	sunday
4250	33	2018-08-27 08:30:00	monday
4251	5	2018-08-20 17:30:00	monday
4252	14	2018-08-23 16:30:00	thursday
4253	6	2018-08-05 15:00:00	sunday
4254	14	2018-08-14 12:00:00	tuesday
4255	10	2018-08-02 14:00:00	thursday
4256	25	2018-08-16 12:00:00	thursday
4257	31	2018-08-03 11:00:00	friday
4258	40	2018-08-15 16:30:00	wednesday
4259	3	2018-08-22 15:30:00	wednesday
4260	33	2018-08-26 11:00:00	sunday
4261	33	2018-08-10 17:00:00	friday
4262	26	2018-08-14 11:45:00	tuesday
4263	20	2018-08-09 09:30:00	thursday
4264	11	2018-08-15 17:00:00	wednesday
4265	1	2018-08-09 11:45:00	thursday
4266	30	2018-08-02 09:45:00	thursday
4267	39	2018-08-24 11:30:00	friday
4268	8	2018-08-04 09:30:00	saturday
4269	31	2018-08-09 10:15:00	thursday
4270	7	2018-08-26 12:00:00	sunday
4271	13	2018-08-08 16:00:00	wednesday
4272	19	2018-08-01 14:45:00	wednesday
4273	15	2018-08-08 17:45:00	wednesday
4274	7	2018-08-20 10:45:00	monday
4275	11	2018-08-18 08:00:00	saturday
4276	22	2018-08-10 08:30:00	friday
4277	10	2018-08-07 12:00:00	tuesday
4278	32	2018-08-17 16:30:00	friday
4279	1	2018-09-03 08:15:00	monday
4280	12	2018-09-11 12:00:00	tuesday
4281	5	2018-09-04 17:00:00	tuesday
4282	5	2018-09-11 13:15:00	tuesday
4283	28	2018-09-12 12:15:00	wednesday
4284	16	2018-09-20 14:15:00	thursday
4285	40	2018-09-05 16:45:00	wednesday
4286	25	2018-09-25 10:45:00	tuesday
4287	36	2018-09-21 12:45:00	friday
4288	27	2018-09-13 14:30:00	thursday
4289	22	2018-09-24 10:15:00	monday
4290	7	2018-09-27 09:30:00	thursday
4291	5	2018-09-01 12:45:00	saturday
4292	9	2018-09-17 10:30:00	monday
4293	35	2018-09-30 16:15:00	sunday
4294	39	2018-09-24 10:45:00	monday
4295	34	2018-09-03 08:30:00	monday
4296	27	2018-09-05 09:30:00	wednesday
4297	24	2018-09-03 10:00:00	monday
4298	14	2018-09-10 10:15:00	monday
4299	36	2018-09-07 09:15:00	friday
4300	21	2018-09-19 13:00:00	wednesday
4301	32	2018-09-22 14:30:00	saturday
4302	6	2018-09-24 10:15:00	monday
4303	15	2018-09-22 12:00:00	saturday
4304	1	2018-09-29 15:00:00	saturday
4305	6	2018-09-12 15:15:00	wednesday
4306	32	2018-09-26 12:15:00	wednesday
4307	28	2018-09-22 09:15:00	saturday
4308	9	2018-09-24 11:00:00	monday
4309	3	2018-09-12 15:30:00	wednesday
4310	16	2018-09-13 13:45:00	thursday
4311	30	2018-09-23 15:45:00	sunday
4312	40	2018-09-05 14:00:00	wednesday
4313	3	2018-09-06 15:30:00	thursday
4314	25	2018-09-21 11:00:00	friday
4315	25	2018-09-29 16:30:00	saturday
4316	32	2018-09-26 16:45:00	wednesday
4317	24	2018-09-08 16:00:00	saturday
4318	35	2018-09-30 08:30:00	sunday
4319	37	2018-09-25 10:30:00	tuesday
4320	36	2018-09-13 09:15:00	thursday
4321	29	2018-09-20 16:30:00	thursday
4322	27	2018-09-13 13:15:00	thursday
4323	30	2018-09-06 16:30:00	thursday
4324	30	2018-09-03 17:00:00	monday
4325	35	2018-09-25 17:45:00	tuesday
4326	27	2018-09-13 13:00:00	thursday
4327	30	2018-09-21 17:15:00	friday
4328	26	2018-09-29 13:15:00	saturday
4329	38	2018-09-17 14:30:00	monday
4330	37	2018-09-26 12:45:00	wednesday
4331	1	2018-09-22 08:15:00	saturday
4332	32	2018-09-17 15:45:00	monday
4333	24	2018-09-09 10:30:00	sunday
4334	3	2018-09-19 11:45:00	wednesday
4335	15	2018-09-10 16:15:00	monday
4336	13	2018-09-23 14:00:00	sunday
4337	11	2018-09-26 12:15:00	wednesday
4338	40	2018-09-03 17:00:00	monday
4339	20	2018-09-27 08:00:00	thursday
4340	34	2018-09-06 13:45:00	thursday
4341	2	2018-09-03 14:45:00	monday
4342	15	2018-09-30 12:15:00	sunday
4343	2	2018-09-19 16:45:00	wednesday
4344	9	2018-09-21 08:15:00	friday
4345	32	2018-09-12 12:00:00	wednesday
4346	18	2018-09-18 17:15:00	tuesday
4347	20	2018-09-05 15:30:00	wednesday
4348	6	2018-09-24 13:00:00	monday
4349	15	2018-09-04 17:15:00	tuesday
4350	20	2018-09-12 14:15:00	wednesday
4351	28	2018-09-17 13:00:00	monday
4352	19	2018-09-05 14:15:00	wednesday
4353	25	2018-09-02 16:30:00	sunday
4354	7	2018-09-20 08:30:00	thursday
4355	21	2018-09-11 12:45:00	tuesday
4356	27	2018-09-03 17:15:00	monday
4357	10	2018-09-01 11:00:00	saturday
4358	21	2018-09-10 09:15:00	monday
4359	9	2018-09-27 09:30:00	thursday
4360	7	2018-09-27 17:00:00	thursday
4361	18	2018-09-09 10:15:00	sunday
4362	18	2018-09-17 10:30:00	monday
4363	19	2018-09-29 10:45:00	saturday
4364	2	2018-09-24 16:30:00	monday
4365	38	2018-09-12 15:15:00	wednesday
4366	23	2018-09-18 09:00:00	tuesday
4367	13	2018-09-23 15:15:00	sunday
4368	15	2018-09-01 17:45:00	saturday
4369	7	2018-09-01 11:00:00	saturday
4370	15	2018-10-10 08:15:00	wednesday
4371	18	2018-10-07 12:00:00	sunday
4372	1	2018-10-12 09:15:00	friday
4373	24	2018-10-13 12:15:00	saturday
4374	21	2018-10-09 12:15:00	tuesday
4375	28	2018-10-02 17:00:00	tuesday
4376	26	2018-10-02 11:15:00	tuesday
4377	12	2018-10-17 16:45:00	wednesday
4378	18	2018-10-17 13:30:00	wednesday
4379	14	2018-10-20 13:00:00	saturday
4380	3	2018-10-23 08:15:00	tuesday
4381	36	2018-10-03 10:45:00	wednesday
4382	35	2018-10-04 11:15:00	thursday
4383	2	2018-10-22 11:30:00	monday
4384	17	2018-10-02 14:00:00	tuesday
4385	29	2018-10-05 15:15:00	friday
4386	17	2018-10-01 14:45:00	monday
4387	11	2018-10-29 15:30:00	monday
4388	13	2018-10-14 09:00:00	sunday
4389	15	2018-10-19 09:00:00	friday
4390	30	2018-10-07 11:00:00	sunday
4391	3	2018-10-06 11:00:00	saturday
4392	10	2018-10-30 14:30:00	tuesday
4393	5	2018-10-30 15:45:00	tuesday
4394	37	2018-10-25 13:15:00	thursday
4395	29	2018-10-08 10:45:00	monday
4396	10	2018-10-15 14:45:00	monday
4397	3	2018-10-30 10:15:00	tuesday
4398	9	2018-10-03 17:45:00	wednesday
4399	35	2018-10-10 17:00:00	wednesday
4400	17	2018-10-20 13:15:00	saturday
4401	2	2018-10-14 08:00:00	sunday
4402	36	2018-10-21 14:15:00	sunday
4403	31	2018-10-25 17:00:00	thursday
4404	15	2018-10-09 09:15:00	tuesday
4405	29	2018-10-13 15:00:00	saturday
4406	40	2018-10-17 09:15:00	wednesday
4407	37	2018-10-23 09:45:00	tuesday
4408	16	2018-10-01 12:30:00	monday
4409	38	2018-10-10 10:00:00	wednesday
4410	25	2018-10-11 16:00:00	thursday
4411	31	2018-10-11 17:00:00	thursday
4412	39	2018-10-12 16:00:00	friday
4413	24	2018-10-08 09:15:00	monday
4414	24	2018-10-01 15:45:00	monday
4415	7	2018-10-02 08:15:00	tuesday
4416	14	2018-10-03 10:45:00	wednesday
4417	22	2018-10-15 12:30:00	monday
4418	1	2018-10-17 08:00:00	wednesday
4419	39	2018-10-04 10:15:00	thursday
4420	30	2018-10-01 16:30:00	monday
4421	26	2018-10-13 10:00:00	saturday
4422	5	2018-10-05 17:30:00	friday
4423	27	2018-10-28 16:45:00	sunday
4424	20	2018-10-09 15:45:00	tuesday
4425	15	2018-10-30 09:45:00	tuesday
4426	31	2018-10-13 16:45:00	saturday
4427	12	2018-10-20 16:00:00	saturday
4428	25	2018-10-24 14:45:00	wednesday
4429	30	2018-10-13 16:30:00	saturday
4430	18	2018-10-03 16:45:00	wednesday
4431	38	2018-10-29 15:00:00	monday
4432	40	2018-10-04 16:15:00	thursday
4433	27	2018-10-26 17:45:00	friday
4434	31	2018-10-25 13:00:00	thursday
4435	19	2018-10-18 11:45:00	thursday
4436	12	2018-10-25 08:30:00	thursday
4437	15	2018-10-24 10:30:00	wednesday
4438	27	2018-10-13 12:45:00	saturday
4439	36	2018-10-25 08:30:00	thursday
4440	14	2018-10-10 08:15:00	wednesday
4441	7	2018-10-28 08:45:00	sunday
4442	30	2018-10-07 09:15:00	sunday
4443	38	2018-10-18 14:45:00	thursday
4444	33	2018-10-18 10:00:00	thursday
4445	11	2018-10-11 15:30:00	thursday
4446	12	2018-10-06 09:00:00	saturday
4447	1	2018-10-01 15:45:00	monday
4448	17	2018-10-03 17:00:00	wednesday
4449	39	2018-10-29 17:45:00	monday
4450	40	2018-10-11 09:30:00	thursday
4451	2	2018-10-11 14:45:00	thursday
4452	6	2018-10-03 12:45:00	wednesday
4453	4	2018-10-02 13:45:00	tuesday
4454	2	2018-10-07 11:00:00	sunday
4455	33	2018-10-30 08:45:00	tuesday
4456	29	2018-11-09 09:45:00	friday
4457	30	2018-11-24 08:00:00	saturday
4458	31	2018-11-09 16:00:00	friday
4459	27	2018-11-25 13:00:00	sunday
4460	23	2018-11-18 10:15:00	sunday
4461	23	2018-11-14 14:15:00	wednesday
4462	17	2018-11-18 15:15:00	sunday
4463	32	2018-11-22 13:30:00	thursday
4464	30	2018-11-08 15:00:00	thursday
4465	2	2018-11-16 11:30:00	friday
4466	18	2018-11-18 15:30:00	sunday
4467	4	2018-11-07 11:00:00	wednesday
4468	31	2018-11-01 16:15:00	thursday
4469	33	2018-11-23 17:15:00	friday
4470	36	2018-11-04 15:00:00	sunday
4471	34	2018-11-17 10:00:00	saturday
4472	9	2018-11-18 08:30:00	sunday
4473	6	2018-11-10 15:15:00	saturday
4474	2	2018-11-24 17:45:00	saturday
4475	27	2018-11-15 17:30:00	thursday
4476	26	2018-11-14 13:00:00	wednesday
4477	28	2018-11-28 16:00:00	wednesday
4478	15	2018-11-24 15:00:00	saturday
4479	19	2018-11-16 17:15:00	friday
4480	34	2018-11-03 10:45:00	saturday
4481	13	2018-11-23 13:15:00	friday
4482	21	2018-11-30 12:45:00	friday
4483	11	2018-11-02 13:45:00	friday
4484	4	2018-11-09 10:30:00	friday
4485	21	2018-11-30 16:30:00	friday
4486	31	2018-11-16 12:00:00	friday
4487	6	2018-11-24 12:30:00	saturday
4488	4	2018-11-20 16:15:00	tuesday
4489	29	2018-11-08 09:00:00	thursday
4490	6	2018-11-06 16:45:00	tuesday
4491	23	2018-11-27 09:00:00	tuesday
4492	27	2018-11-03 11:00:00	saturday
4493	40	2018-11-08 13:30:00	thursday
4494	31	2018-11-13 15:15:00	tuesday
4495	1	2018-11-08 15:15:00	thursday
4496	19	2018-11-12 17:15:00	monday
4497	24	2018-11-22 11:30:00	thursday
4498	34	2018-11-19 11:15:00	monday
4499	29	2018-11-09 14:30:00	friday
4500	16	2018-11-14 10:45:00	wednesday
4501	16	2018-11-11 17:45:00	sunday
4502	3	2018-11-11 11:30:00	sunday
4503	14	2018-11-18 16:00:00	sunday
4504	4	2018-11-21 15:00:00	wednesday
4505	3	2018-11-15 13:00:00	thursday
4506	12	2018-11-25 16:30:00	sunday
4507	23	2018-11-27 15:00:00	tuesday
4508	33	2018-11-17 10:30:00	saturday
4509	19	2018-11-08 09:30:00	thursday
4510	16	2018-11-16 09:00:00	friday
4511	3	2018-11-23 11:15:00	friday
4512	34	2018-11-20 08:00:00	tuesday
4513	27	2018-11-20 16:15:00	tuesday
4514	17	2018-11-08 17:00:00	thursday
4515	19	2018-11-14 08:00:00	wednesday
4516	1	2018-11-24 16:15:00	saturday
4517	28	2018-11-02 13:15:00	friday
4518	17	2018-11-11 08:45:00	sunday
4519	26	2018-11-29 12:30:00	thursday
4520	1	2018-11-17 11:15:00	saturday
4521	2	2018-11-03 15:15:00	saturday
4522	28	2018-11-19 13:00:00	monday
4523	35	2018-11-03 11:30:00	saturday
4524	5	2018-11-10 11:30:00	saturday
4525	14	2018-11-06 14:15:00	tuesday
4526	27	2018-11-28 09:30:00	wednesday
4527	16	2018-11-09 10:45:00	friday
4528	30	2018-11-29 17:30:00	thursday
4529	13	2018-11-04 08:00:00	sunday
4530	17	2018-11-16 17:30:00	friday
4531	36	2018-11-03 09:30:00	saturday
4532	8	2018-11-05 09:45:00	monday
4533	31	2018-11-25 09:15:00	sunday
4534	1	2018-11-26 11:00:00	monday
4535	33	2018-11-13 11:15:00	tuesday
4536	37	2018-11-24 16:00:00	saturday
4537	7	2018-11-22 11:00:00	thursday
4538	13	2018-11-02 09:30:00	friday
4539	26	2018-11-07 09:00:00	wednesday
4540	38	2018-11-30 14:15:00	friday
4541	25	2018-11-22 16:45:00	thursday
4542	39	2018-11-07 08:30:00	wednesday
4543	1	2018-11-28 09:30:00	wednesday
4544	32	2018-11-05 08:15:00	monday
4545	14	2018-11-09 15:45:00	friday
4546	27	2018-11-21 17:15:00	wednesday
4547	33	2018-11-30 09:30:00	friday
4548	36	2018-11-18 13:00:00	sunday
4549	1	2018-11-28 09:45:00	wednesday
4550	18	2018-11-19 11:15:00	monday
4551	28	2018-11-01 15:15:00	thursday
4552	5	2018-11-10 10:15:00	saturday
4553	21	2018-11-29 17:00:00	thursday
4554	24	2018-11-17 16:30:00	saturday
4555	4	2018-11-09 13:00:00	friday
4556	22	2018-11-25 11:15:00	sunday
4557	28	2018-11-15 12:30:00	thursday
4558	14	2018-11-08 14:30:00	thursday
4559	13	2018-11-05 12:45:00	monday
4560	24	2018-11-15 17:30:00	thursday
4561	32	2018-12-17 11:30:00	monday
4562	31	2018-12-12 13:45:00	wednesday
4563	25	2018-12-30 08:30:00	sunday
4564	30	2018-12-16 14:15:00	sunday
4565	12	2018-12-09 12:15:00	sunday
4566	13	2018-12-02 10:45:00	sunday
4567	34	2018-12-13 14:00:00	thursday
4568	36	2018-12-22 10:30:00	saturday
4569	34	2018-12-30 11:30:00	sunday
4570	36	2018-12-05 10:45:00	wednesday
4571	27	2018-12-10 10:15:00	monday
4572	27	2018-12-14 10:15:00	friday
4573	6	2018-12-25 14:00:00	tuesday
4574	5	2018-12-17 08:15:00	monday
4575	22	2018-12-18 09:00:00	tuesday
4576	13	2018-12-05 15:00:00	wednesday
4577	8	2018-12-01 11:15:00	saturday
4578	12	2018-12-04 12:15:00	tuesday
4579	29	2018-12-03 13:45:00	monday
4580	30	2018-12-07 12:15:00	friday
4581	37	2018-12-03 16:00:00	monday
4582	2	2018-12-04 08:15:00	tuesday
4583	36	2018-12-25 16:45:00	tuesday
4584	8	2018-12-06 16:30:00	thursday
4585	7	2018-12-07 08:00:00	friday
4586	18	2018-12-12 12:30:00	wednesday
4587	37	2018-12-30 14:15:00	sunday
4588	13	2018-12-21 17:45:00	friday
4589	31	2018-12-06 08:00:00	thursday
4590	39	2018-12-19 13:30:00	wednesday
4591	26	2018-12-21 11:15:00	friday
4592	40	2018-12-05 12:00:00	wednesday
4593	17	2018-12-07 15:00:00	friday
4594	19	2018-12-11 08:30:00	tuesday
4595	29	2018-12-13 12:00:00	thursday
4596	19	2018-12-21 12:00:00	friday
4597	7	2018-12-27 12:45:00	thursday
4598	40	2018-12-21 14:30:00	friday
4599	2	2018-12-17 14:00:00	monday
4600	2	2018-12-16 12:15:00	sunday
4601	35	2018-12-08 16:15:00	saturday
4602	18	2018-12-21 14:45:00	friday
4603	26	2018-12-07 15:15:00	friday
4604	5	2018-12-20 13:30:00	thursday
4605	8	2018-12-02 09:30:00	sunday
4606	34	2018-12-14 13:15:00	friday
4607	25	2018-12-26 16:00:00	wednesday
4608	9	2018-12-27 12:30:00	thursday
4609	25	2018-12-22 17:15:00	saturday
4610	3	2018-12-28 09:45:00	friday
4611	8	2018-12-01 09:45:00	saturday
4612	30	2018-12-18 14:15:00	tuesday
4613	8	2018-12-29 14:15:00	saturday
4614	40	2018-12-25 16:30:00	tuesday
4615	3	2018-12-23 10:30:00	sunday
4616	25	2018-12-12 09:00:00	wednesday
4617	7	2018-12-20 15:00:00	thursday
4618	3	2018-12-17 10:30:00	monday
4619	36	2018-12-04 16:15:00	tuesday
4620	3	2018-12-01 16:30:00	saturday
4621	25	2018-12-01 11:30:00	saturday
4622	23	2018-12-20 10:30:00	thursday
4623	12	2018-12-04 16:00:00	tuesday
4624	31	2018-12-14 08:45:00	friday
4625	17	2018-12-14 09:30:00	friday
4626	5	2018-12-26 13:00:00	wednesday
4627	23	2018-12-01 17:15:00	saturday
4628	15	2018-12-19 14:30:00	wednesday
4629	33	2018-12-02 11:45:00	sunday
4630	34	2018-12-26 09:00:00	wednesday
4631	40	2018-12-02 16:00:00	sunday
4632	14	2018-12-23 12:45:00	sunday
4633	11	2018-12-07 17:00:00	friday
4634	14	2018-12-04 09:45:00	tuesday
4635	16	2018-12-01 11:45:00	saturday
4636	38	2018-12-07 12:15:00	friday
4637	34	2018-12-28 10:00:00	friday
4638	21	2018-12-25 10:30:00	tuesday
4639	35	2018-12-17 17:00:00	monday
4640	18	2018-12-14 10:15:00	friday
4641	8	2018-12-03 17:45:00	monday
4642	1	2018-12-20 09:00:00	thursday
4643	10	2018-12-13 14:45:00	thursday
4644	5	2018-12-07 10:15:00	friday
4645	25	2018-12-22 10:00:00	saturday
4646	37	2018-12-24 10:45:00	monday
4647	25	2018-12-30 13:45:00	sunday
4648	40	2018-12-29 17:00:00	saturday
4649	30	2018-12-25 11:45:00	tuesday
4650	19	2018-12-10 17:30:00	monday
4651	16	2019-01-16 13:30:00	wednesday
4652	14	2019-01-28 11:45:00	monday
4653	1	2019-01-07 12:30:00	monday
4654	30	2019-01-07 12:00:00	monday
4655	20	2019-01-03 13:30:00	thursday
4656	7	2019-01-24 10:30:00	thursday
4657	5	2019-01-09 13:30:00	wednesday
4658	5	2019-01-19 10:45:00	saturday
4659	39	2019-01-14 10:30:00	monday
4660	35	2019-01-08 14:15:00	tuesday
4661	34	2019-01-22 16:00:00	tuesday
4662	27	2019-01-26 15:45:00	saturday
4663	3	2019-01-12 12:15:00	saturday
4664	12	2019-01-02 11:00:00	wednesday
4665	8	2019-01-07 10:45:00	monday
4666	19	2019-01-01 11:00:00	tuesday
4667	35	2019-01-20 12:45:00	sunday
4668	13	2019-01-22 17:45:00	tuesday
4669	20	2019-01-09 15:45:00	wednesday
4670	32	2019-01-28 17:45:00	monday
4671	9	2019-01-24 17:30:00	thursday
4672	31	2019-01-10 08:45:00	thursday
4673	16	2019-01-24 15:00:00	thursday
4674	29	2019-01-27 14:15:00	sunday
4675	25	2019-01-20 08:00:00	sunday
4676	30	2019-01-03 13:15:00	thursday
4677	6	2019-01-26 16:30:00	saturday
4678	3	2019-01-28 09:15:00	monday
4679	3	2019-01-23 09:30:00	wednesday
4680	12	2019-01-07 09:45:00	monday
4681	8	2019-01-22 12:15:00	tuesday
4682	21	2019-01-04 11:45:00	friday
4683	20	2019-01-02 12:00:00	wednesday
4684	27	2019-01-30 11:00:00	wednesday
4685	17	2019-01-04 13:30:00	friday
4686	22	2019-01-10 10:00:00	thursday
4687	21	2019-01-03 16:30:00	thursday
4688	15	2019-01-25 09:45:00	friday
4689	4	2019-01-15 12:00:00	tuesday
4690	24	2019-01-09 13:30:00	wednesday
4691	16	2019-01-04 12:15:00	friday
4692	24	2019-01-24 09:00:00	thursday
4693	19	2019-01-29 10:30:00	tuesday
4694	6	2019-01-19 14:00:00	saturday
4695	17	2019-01-16 15:30:00	wednesday
4696	11	2019-01-20 10:45:00	sunday
4697	25	2019-01-08 12:15:00	tuesday
4698	2	2019-01-14 08:00:00	monday
4699	18	2019-01-18 14:15:00	friday
4700	25	2019-01-13 11:30:00	sunday
4701	16	2019-01-25 10:30:00	friday
4702	39	2019-01-18 17:30:00	friday
4703	6	2019-01-28 11:30:00	monday
4704	22	2019-01-07 14:00:00	monday
4705	18	2019-01-11 08:30:00	friday
4706	32	2019-01-15 16:00:00	tuesday
4707	6	2019-01-26 11:30:00	saturday
4708	26	2019-01-04 10:00:00	friday
4709	19	2019-01-17 14:15:00	thursday
4710	29	2019-01-06 15:30:00	sunday
4711	5	2019-01-05 16:30:00	saturday
4712	26	2019-01-19 10:30:00	saturday
4713	28	2019-01-17 17:15:00	thursday
4714	20	2019-01-05 16:15:00	saturday
4715	30	2019-01-21 11:00:00	monday
4716	31	2019-01-27 12:45:00	sunday
4717	24	2019-01-13 08:00:00	sunday
4718	20	2019-01-07 11:15:00	monday
4719	12	2019-01-22 09:45:00	tuesday
4720	4	2019-01-13 09:15:00	sunday
4721	34	2019-01-10 10:15:00	thursday
4722	34	2019-01-28 15:45:00	monday
4723	33	2019-01-21 13:15:00	monday
4724	36	2019-01-11 15:45:00	friday
4725	28	2019-01-02 09:30:00	wednesday
4726	16	2019-01-25 16:45:00	friday
4727	15	2019-01-16 12:30:00	wednesday
4728	25	2019-01-08 17:30:00	tuesday
4729	40	2019-01-19 17:45:00	saturday
4730	16	2019-01-22 15:15:00	tuesday
4731	8	2019-01-05 16:45:00	saturday
4732	29	2019-02-18 09:00:00	monday
4733	34	2019-02-01 10:30:00	friday
4734	21	2019-02-22 14:45:00	friday
4735	8	2019-02-15 11:30:00	friday
4736	27	2019-02-01 16:30:00	friday
4737	27	2019-02-28 09:30:00	thursday
4738	17	2019-02-22 14:00:00	friday
4739	33	2019-02-11 14:30:00	monday
4740	13	2019-02-23 10:30:00	saturday
4741	22	2019-02-06 09:30:00	wednesday
4742	39	2019-02-16 11:00:00	saturday
4743	38	2019-02-20 08:30:00	wednesday
4744	7	2019-02-19 09:30:00	tuesday
4745	30	2019-02-15 10:00:00	friday
4746	33	2019-02-22 08:00:00	friday
4747	8	2019-02-26 17:45:00	tuesday
4748	34	2019-02-18 10:15:00	monday
4749	13	2019-02-23 12:15:00	saturday
4750	17	2019-02-06 08:15:00	wednesday
4751	34	2019-02-13 11:30:00	wednesday
4752	17	2019-02-25 16:45:00	monday
4753	14	2019-02-06 10:15:00	wednesday
4754	19	2019-02-03 14:45:00	sunday
4755	39	2019-02-10 10:45:00	sunday
4756	22	2019-02-28 09:00:00	thursday
4757	26	2019-02-14 14:45:00	thursday
4758	9	2019-02-11 08:30:00	monday
4759	10	2019-02-18 10:00:00	monday
4760	20	2019-02-20 12:30:00	wednesday
4761	6	2019-02-23 09:00:00	saturday
4762	29	2019-02-10 17:00:00	sunday
4763	29	2019-02-12 12:15:00	tuesday
4764	38	2019-02-21 17:00:00	thursday
4765	34	2019-02-20 10:45:00	wednesday
4766	17	2019-02-12 13:15:00	tuesday
4767	26	2019-02-27 10:15:00	wednesday
4768	38	2019-02-27 12:00:00	wednesday
4769	26	2019-02-16 17:30:00	saturday
4770	9	2019-02-06 11:30:00	wednesday
4771	19	2019-02-09 15:30:00	saturday
4772	23	2019-02-28 16:30:00	thursday
4773	24	2019-02-18 10:45:00	monday
4774	38	2019-02-20 11:00:00	wednesday
4775	4	2019-02-19 08:30:00	tuesday
4776	2	2019-02-23 09:15:00	saturday
4777	7	2019-02-27 12:15:00	wednesday
4778	4	2019-02-08 16:45:00	friday
4779	15	2019-02-27 14:45:00	wednesday
4780	35	2019-02-18 14:45:00	monday
4781	33	2019-02-07 16:45:00	thursday
4782	21	2019-02-20 16:15:00	wednesday
4783	15	2019-02-28 12:45:00	thursday
4784	19	2019-02-16 12:00:00	saturday
4785	24	2019-02-14 13:00:00	thursday
4786	34	2019-02-03 13:15:00	sunday
4787	5	2019-02-04 14:30:00	monday
4788	7	2019-02-06 11:30:00	wednesday
4789	31	2019-02-18 09:00:00	monday
4790	40	2019-02-28 13:30:00	thursday
4791	12	2019-02-17 16:00:00	sunday
4792	23	2019-02-05 16:45:00	tuesday
4793	10	2019-02-07 13:30:00	thursday
4794	31	2019-02-16 13:00:00	saturday
4795	24	2019-02-18 11:30:00	monday
4796	31	2019-02-25 12:15:00	monday
4797	25	2019-02-21 12:15:00	thursday
4798	20	2019-02-19 13:15:00	tuesday
4799	25	2019-02-22 16:45:00	friday
4800	8	2019-02-22 16:45:00	friday
4801	8	2019-02-08 10:45:00	friday
4802	15	2019-02-14 09:45:00	thursday
4803	12	2019-02-07 11:45:00	thursday
4804	30	2019-02-10 13:30:00	sunday
4805	40	2019-02-02 12:30:00	saturday
4806	37	2019-02-21 16:45:00	thursday
4807	26	2019-02-27 10:45:00	wednesday
4808	4	2019-02-01 09:00:00	friday
4809	6	2019-02-27 10:00:00	wednesday
4810	30	2019-02-22 16:30:00	friday
4811	21	2019-02-17 11:45:00	sunday
4812	2	2019-03-28 12:00:00	thursday
4813	35	2019-03-25 11:15:00	monday
4814	23	2019-03-22 14:30:00	friday
4815	26	2019-03-18 10:45:00	monday
4816	13	2019-03-03 08:45:00	sunday
4817	9	2019-03-15 13:15:00	friday
4818	24	2019-03-19 17:30:00	tuesday
4819	17	2019-03-24 08:15:00	sunday
4820	14	2019-03-06 12:15:00	wednesday
4821	11	2019-03-11 11:30:00	monday
4822	13	2019-03-13 16:45:00	wednesday
4823	29	2019-03-16 09:15:00	saturday
4824	16	2019-03-24 17:15:00	sunday
4825	20	2019-03-26 15:15:00	tuesday
4826	9	2019-03-08 16:30:00	friday
4827	9	2019-03-18 14:30:00	monday
4828	13	2019-03-07 14:15:00	thursday
4829	22	2019-03-10 09:00:00	sunday
4830	5	2019-03-20 10:00:00	wednesday
4831	7	2019-03-15 13:15:00	friday
4832	33	2019-03-24 09:15:00	sunday
4833	20	2019-03-03 12:45:00	sunday
4834	12	2019-03-03 10:00:00	sunday
4835	35	2019-03-21 16:30:00	thursday
4836	21	2019-03-23 12:45:00	saturday
4837	7	2019-03-11 12:45:00	monday
4838	33	2019-03-25 12:15:00	monday
4839	30	2019-03-18 15:00:00	monday
4840	20	2019-03-16 12:45:00	saturday
4841	12	2019-03-30 13:30:00	saturday
4842	23	2019-03-26 17:15:00	tuesday
4843	34	2019-03-08 10:15:00	friday
4844	32	2019-03-27 10:15:00	wednesday
4845	27	2019-03-08 09:45:00	friday
4846	39	2019-03-13 08:45:00	wednesday
4847	27	2019-03-27 10:00:00	wednesday
4848	21	2019-03-01 08:15:00	friday
4849	16	2019-03-12 15:45:00	tuesday
4850	12	2019-03-26 13:00:00	tuesday
4851	11	2019-03-12 10:15:00	tuesday
4852	11	2019-03-17 17:30:00	sunday
4853	5	2019-03-18 14:00:00	monday
4854	17	2019-03-17 10:30:00	sunday
4855	12	2019-03-16 14:15:00	saturday
4856	39	2019-03-28 12:15:00	thursday
4857	29	2019-03-13 10:00:00	wednesday
4858	1	2019-03-27 14:30:00	wednesday
4859	9	2019-03-27 14:45:00	wednesday
4860	27	2019-03-30 13:00:00	saturday
4861	26	2019-03-15 11:00:00	friday
4862	37	2019-03-04 16:45:00	monday
4863	28	2019-03-12 10:45:00	tuesday
4864	8	2019-03-02 13:00:00	saturday
4865	22	2019-03-21 12:15:00	thursday
4866	40	2019-03-22 13:15:00	friday
4867	8	2019-03-16 17:15:00	saturday
4868	26	2019-03-30 08:30:00	saturday
4869	21	2019-03-19 15:45:00	tuesday
4870	29	2019-03-11 10:45:00	monday
4871	24	2019-03-17 17:15:00	sunday
4872	26	2019-03-04 17:30:00	monday
4873	40	2019-03-18 15:45:00	monday
4874	14	2019-03-14 13:30:00	thursday
4875	13	2019-03-23 10:15:00	saturday
4876	13	2019-03-22 15:45:00	friday
4877	10	2019-03-02 14:30:00	saturday
4878	38	2019-03-13 15:30:00	wednesday
4879	11	2019-03-26 09:30:00	tuesday
4880	3	2019-03-25 14:15:00	monday
4881	38	2019-03-16 11:30:00	saturday
4882	39	2019-03-29 16:00:00	friday
4883	4	2019-03-24 12:15:00	sunday
4884	16	2019-03-30 13:00:00	saturday
4885	38	2019-03-18 13:30:00	monday
4886	12	2019-03-29 16:30:00	friday
4887	10	2019-03-16 08:30:00	saturday
4888	13	2019-03-10 09:00:00	sunday
4889	37	2019-03-25 08:15:00	monday
4890	23	2019-03-28 13:45:00	thursday
4891	23	2019-03-26 16:15:00	tuesday
4892	30	2019-03-06 14:15:00	wednesday
4893	20	2019-03-09 17:45:00	saturday
4894	27	2019-03-09 14:30:00	saturday
4895	23	2019-03-29 11:15:00	friday
4896	5	2019-03-08 12:45:00	friday
4897	31	2019-03-01 15:30:00	friday
4898	2	2019-03-07 08:45:00	thursday
4899	12	2019-03-19 10:45:00	tuesday
4900	37	2019-03-15 10:15:00	friday
4901	1	2019-03-25 10:00:00	monday
4902	7	2019-04-10 14:30:00	wednesday
4903	33	2019-04-06 11:30:00	saturday
4904	8	2019-04-11 11:45:00	thursday
4905	11	2019-04-06 14:00:00	saturday
4906	4	2019-04-23 13:45:00	tuesday
4907	23	2019-04-12 15:45:00	friday
4908	8	2019-04-03 16:00:00	wednesday
4909	40	2019-04-16 17:30:00	tuesday
4910	35	2019-04-06 11:30:00	saturday
4911	25	2019-04-02 08:00:00	tuesday
4912	24	2019-04-24 09:45:00	wednesday
4913	18	2019-04-26 14:30:00	friday
4914	32	2019-04-17 17:15:00	wednesday
4915	27	2019-04-27 15:30:00	saturday
4916	34	2019-04-10 14:00:00	wednesday
4917	5	2019-04-06 12:15:00	saturday
4918	21	2019-04-14 13:15:00	sunday
4919	6	2019-04-25 16:30:00	thursday
4920	26	2019-04-05 09:15:00	friday
4921	35	2019-04-25 16:15:00	thursday
4922	4	2019-04-24 08:15:00	wednesday
4923	36	2019-04-26 11:45:00	friday
4924	33	2019-04-04 13:45:00	thursday
4925	21	2019-04-05 08:15:00	friday
4926	7	2019-04-28 10:30:00	sunday
4927	25	2019-04-29 08:45:00	monday
4928	25	2019-04-21 13:30:00	sunday
4929	31	2019-04-19 10:15:00	friday
4930	18	2019-04-07 17:15:00	sunday
4931	39	2019-04-27 08:45:00	saturday
4932	39	2019-04-01 15:45:00	monday
4933	35	2019-04-15 16:45:00	monday
4934	39	2019-04-21 17:15:00	sunday
4935	16	2019-04-18 15:00:00	thursday
4936	19	2019-04-14 17:30:00	sunday
4937	20	2019-04-20 09:45:00	saturday
4938	32	2019-04-03 14:15:00	wednesday
4939	23	2019-04-14 14:30:00	sunday
4940	33	2019-04-14 08:30:00	sunday
4941	4	2019-04-22 10:45:00	monday
4942	7	2019-04-25 17:30:00	thursday
4943	38	2019-04-20 09:45:00	saturday
4944	27	2019-04-21 16:15:00	sunday
4945	5	2019-04-26 09:15:00	friday
4946	16	2019-04-17 13:30:00	wednesday
4947	1	2019-04-07 10:00:00	sunday
4948	27	2019-04-29 11:45:00	monday
4949	3	2019-04-23 08:30:00	tuesday
4950	28	2019-04-13 16:45:00	saturday
4951	16	2019-04-07 15:45:00	sunday
4952	13	2019-04-21 12:45:00	sunday
4953	15	2019-04-22 08:30:00	monday
4954	7	2019-04-13 12:00:00	saturday
4955	8	2019-04-14 16:30:00	sunday
4956	1	2019-04-14 12:00:00	sunday
4957	12	2019-04-24 17:15:00	wednesday
4958	27	2019-04-15 08:15:00	monday
4959	25	2019-04-17 14:30:00	wednesday
4960	36	2019-04-25 17:15:00	thursday
4961	5	2019-04-10 12:45:00	wednesday
4962	9	2019-04-18 11:30:00	thursday
4963	16	2019-04-16 14:30:00	tuesday
4964	15	2019-04-08 16:15:00	monday
4965	36	2019-04-28 14:30:00	sunday
4966	14	2019-04-06 14:30:00	saturday
4967	30	2019-04-19 10:00:00	friday
4968	5	2019-04-06 14:00:00	saturday
4969	20	2019-04-25 17:30:00	thursday
4970	18	2019-04-22 17:15:00	monday
4971	38	2019-04-07 14:30:00	sunday
4972	25	2019-04-18 12:15:00	thursday
4973	22	2019-04-27 15:45:00	saturday
4974	18	2019-04-27 08:15:00	saturday
4975	34	2019-04-18 08:30:00	thursday
4976	5	2019-05-23 08:45:00	thursday
4977	39	2019-05-15 09:15:00	wednesday
4978	30	2019-05-06 09:00:00	monday
4979	37	2019-05-16 12:15:00	thursday
4980	3	2019-05-19 08:15:00	sunday
4981	7	2019-05-14 17:30:00	tuesday
4982	34	2019-05-07 14:45:00	tuesday
4983	17	2019-05-02 16:30:00	thursday
4984	30	2019-05-09 09:45:00	thursday
4985	34	2019-05-27 13:45:00	monday
4986	17	2019-05-24 12:30:00	friday
4987	2	2019-05-09 08:15:00	thursday
4988	25	2019-05-05 12:45:00	sunday
4989	10	2019-05-11 10:15:00	saturday
4990	12	2019-05-25 15:00:00	saturday
4991	16	2019-05-14 16:15:00	tuesday
4992	13	2019-05-23 15:15:00	thursday
4993	18	2019-05-13 14:00:00	monday
4994	23	2019-05-21 08:00:00	tuesday
4995	16	2019-05-21 17:00:00	tuesday
4996	38	2019-05-11 10:00:00	saturday
4997	36	2019-05-08 08:30:00	wednesday
4998	3	2019-05-24 14:45:00	friday
4999	2	2019-05-26 10:45:00	sunday
5000	30	2019-05-30 11:45:00	thursday
5001	10	2019-05-07 11:45:00	tuesday
5002	3	2019-05-11 16:30:00	saturday
5003	27	2019-05-16 14:00:00	thursday
5004	8	2019-05-09 15:15:00	thursday
5005	15	2019-05-05 17:15:00	sunday
5006	10	2019-05-05 17:30:00	sunday
5007	12	2019-05-28 14:15:00	tuesday
5008	5	2019-05-03 13:30:00	friday
5009	39	2019-05-17 10:15:00	friday
5010	11	2019-05-25 15:00:00	saturday
5011	32	2019-05-27 09:00:00	monday
5012	33	2019-05-15 16:45:00	wednesday
5013	2	2019-05-09 16:15:00	thursday
5014	23	2019-05-04 14:15:00	saturday
5015	17	2019-05-11 10:00:00	saturday
5016	14	2019-05-11 08:00:00	saturday
5017	28	2019-05-11 11:30:00	saturday
5018	17	2019-05-23 10:30:00	thursday
5019	18	2019-05-19 10:45:00	sunday
5020	6	2019-05-20 15:30:00	monday
5021	22	2019-05-21 14:30:00	tuesday
5022	4	2019-05-30 08:30:00	thursday
5023	37	2019-05-29 13:00:00	wednesday
5024	37	2019-05-15 08:30:00	wednesday
5025	21	2019-05-19 15:45:00	sunday
5026	11	2019-05-02 08:30:00	thursday
5027	38	2019-05-16 11:45:00	thursday
5028	35	2019-05-26 10:00:00	sunday
5029	10	2019-05-15 12:00:00	wednesday
5030	39	2019-05-17 17:30:00	friday
5031	13	2019-05-25 14:30:00	saturday
5032	29	2019-05-20 11:45:00	monday
5033	39	2019-05-05 08:15:00	sunday
5034	19	2019-05-07 10:00:00	tuesday
5035	7	2019-05-19 14:30:00	sunday
5036	21	2019-05-03 12:30:00	friday
5037	23	2019-05-27 13:00:00	monday
5038	10	2019-05-22 11:30:00	wednesday
5039	12	2019-05-21 11:00:00	tuesday
5040	28	2019-05-02 08:15:00	thursday
5041	5	2019-05-05 13:45:00	sunday
5042	6	2019-05-17 09:00:00	friday
5043	33	2019-05-03 11:00:00	friday
5044	14	2019-05-18 09:15:00	saturday
5045	19	2019-05-06 13:30:00	monday
5046	2	2019-05-20 11:15:00	monday
5047	31	2019-05-07 10:15:00	tuesday
5048	20	2019-05-20 10:30:00	monday
5049	28	2019-05-11 11:00:00	saturday
5050	32	2019-05-05 14:00:00	sunday
5051	33	2019-05-02 11:15:00	thursday
5052	19	2019-05-02 15:15:00	thursday
5053	25	2019-06-21 11:30:00	friday
5054	35	2019-06-30 12:45:00	sunday
5055	9	2019-06-17 15:00:00	monday
5056	35	2019-06-24 17:30:00	monday
5057	39	2019-06-07 08:45:00	friday
5058	21	2019-06-20 16:30:00	thursday
5059	2	2019-06-18 15:45:00	tuesday
5060	31	2019-06-08 13:45:00	saturday
5061	6	2019-06-02 13:30:00	sunday
5062	33	2019-06-12 08:45:00	wednesday
5063	23	2019-06-13 16:30:00	thursday
5064	19	2019-06-29 09:30:00	saturday
5065	10	2019-06-11 15:45:00	tuesday
5066	9	2019-06-09 11:00:00	sunday
5067	17	2019-06-09 11:15:00	sunday
5068	40	2019-06-17 08:30:00	monday
5069	21	2019-06-26 08:45:00	wednesday
5070	24	2019-06-11 11:00:00	tuesday
5071	35	2019-06-15 17:30:00	saturday
5072	9	2019-06-27 11:15:00	thursday
5073	34	2019-06-22 08:45:00	saturday
5074	40	2019-06-01 16:45:00	saturday
5075	17	2019-06-19 15:00:00	wednesday
5076	1	2019-06-23 12:30:00	sunday
5077	3	2019-06-24 11:30:00	monday
5078	11	2019-06-20 08:15:00	thursday
5079	20	2019-06-09 09:30:00	sunday
5080	33	2019-06-29 17:45:00	saturday
5081	34	2019-06-14 12:15:00	friday
5082	13	2019-06-25 15:00:00	tuesday
5083	38	2019-06-19 17:00:00	wednesday
5084	37	2019-06-19 17:45:00	wednesday
5085	11	2019-06-18 16:15:00	tuesday
5086	16	2019-06-20 10:45:00	thursday
5087	19	2019-06-27 08:00:00	thursday
5088	31	2019-06-28 12:00:00	friday
5089	15	2019-06-12 11:00:00	wednesday
5090	22	2019-06-07 08:45:00	friday
5091	37	2019-06-22 09:30:00	saturday
5092	26	2019-06-29 12:30:00	saturday
5093	25	2019-06-23 16:45:00	sunday
5094	34	2019-06-16 17:15:00	sunday
5095	22	2019-06-12 17:30:00	wednesday
5096	7	2019-06-25 16:15:00	tuesday
5097	36	2019-06-02 09:00:00	sunday
5098	14	2019-06-28 16:00:00	friday
5099	9	2019-06-24 17:45:00	monday
5100	26	2019-06-24 17:15:00	monday
5101	34	2019-06-27 17:30:00	thursday
5102	4	2019-06-15 15:15:00	saturday
5103	1	2019-06-14 13:30:00	friday
5104	13	2019-06-21 11:30:00	friday
5105	21	2019-06-25 12:30:00	tuesday
5106	8	2019-06-06 16:30:00	thursday
5107	31	2019-06-02 10:00:00	sunday
5108	34	2019-06-27 13:45:00	thursday
5109	9	2019-06-19 09:30:00	wednesday
5110	27	2019-06-14 16:00:00	friday
5111	7	2019-06-20 08:45:00	thursday
5112	21	2019-06-11 14:45:00	tuesday
5113	23	2019-06-09 17:15:00	sunday
5114	33	2019-06-22 12:30:00	saturday
5115	34	2019-06-15 16:00:00	saturday
5116	6	2019-06-25 17:45:00	tuesday
5117	34	2019-06-19 14:30:00	wednesday
5118	20	2019-06-30 15:30:00	sunday
5119	12	2019-06-16 17:30:00	sunday
5120	26	2019-06-10 12:00:00	monday
5121	21	2019-06-16 10:30:00	sunday
5122	37	2019-06-08 12:30:00	saturday
5123	23	2019-06-19 12:30:00	wednesday
5124	11	2019-06-06 10:45:00	thursday
5125	18	2019-06-04 14:00:00	tuesday
5126	17	2019-06-10 15:30:00	monday
5127	21	2019-06-27 15:00:00	thursday
5128	10	2019-06-15 13:00:00	saturday
5129	28	2019-07-14 17:00:00	sunday
5130	33	2019-07-29 11:30:00	monday
5131	33	2019-07-23 15:45:00	tuesday
5132	11	2019-07-21 11:45:00	sunday
5133	37	2019-07-18 15:15:00	thursday
5134	23	2019-07-03 14:15:00	wednesday
5135	21	2019-07-07 10:00:00	sunday
5136	39	2019-07-01 09:00:00	monday
5137	31	2019-07-03 08:00:00	wednesday
5138	7	2019-07-29 11:45:00	monday
5139	20	2019-07-25 13:45:00	thursday
5140	34	2019-07-17 13:15:00	wednesday
5141	14	2019-07-07 08:00:00	sunday
5142	34	2019-07-30 16:15:00	tuesday
5143	16	2019-07-19 16:30:00	friday
5144	31	2019-07-11 11:30:00	thursday
5145	3	2019-07-29 10:00:00	monday
5146	20	2019-07-29 16:00:00	monday
5147	37	2019-07-13 13:30:00	saturday
5148	14	2019-07-25 16:45:00	thursday
5149	9	2019-07-29 16:15:00	monday
5150	6	2019-07-28 13:00:00	sunday
5151	3	2019-07-02 14:30:00	tuesday
5152	28	2019-07-24 17:15:00	wednesday
5153	34	2019-07-20 08:45:00	saturday
5154	27	2019-07-07 17:45:00	sunday
5155	39	2019-07-05 11:45:00	friday
5156	18	2019-07-02 12:00:00	tuesday
5157	26	2019-07-28 10:15:00	sunday
5158	15	2019-07-06 08:15:00	saturday
5159	10	2019-07-26 11:45:00	friday
5160	35	2019-07-02 15:30:00	tuesday
5161	27	2019-07-24 17:45:00	wednesday
5162	18	2019-07-20 11:15:00	saturday
5163	14	2019-07-30 10:45:00	tuesday
5164	26	2019-07-19 11:45:00	friday
5165	38	2019-07-26 10:45:00	friday
5166	16	2019-07-08 10:30:00	monday
5167	23	2019-07-04 13:30:00	thursday
5168	32	2019-07-16 14:15:00	tuesday
5169	31	2019-07-25 11:45:00	thursday
5170	12	2019-07-23 10:15:00	tuesday
5171	31	2019-07-02 15:15:00	tuesday
5172	9	2019-07-17 08:00:00	wednesday
5173	1	2019-07-21 12:15:00	sunday
5174	23	2019-07-17 11:15:00	wednesday
5175	32	2019-07-17 08:15:00	wednesday
5176	7	2019-07-20 15:30:00	saturday
5177	37	2019-07-23 10:45:00	tuesday
5178	12	2019-07-25 12:45:00	thursday
5179	6	2019-07-28 10:30:00	sunday
5180	4	2019-07-17 16:45:00	wednesday
5181	14	2019-07-19 10:45:00	friday
5182	23	2019-07-27 14:45:00	saturday
5183	9	2019-07-09 13:00:00	tuesday
5184	12	2019-07-23 12:15:00	tuesday
5185	30	2019-07-24 11:00:00	wednesday
5186	24	2019-07-09 09:00:00	tuesday
5187	21	2019-07-10 15:15:00	wednesday
5188	24	2019-07-04 08:15:00	thursday
5189	17	2019-07-05 13:00:00	friday
5190	11	2019-07-25 17:45:00	thursday
5191	29	2019-07-04 13:15:00	thursday
5192	27	2019-07-17 15:00:00	wednesday
5193	16	2019-07-02 09:30:00	tuesday
5194	10	2019-07-30 12:15:00	tuesday
5195	10	2019-07-26 15:30:00	friday
5196	7	2019-07-29 13:30:00	monday
5197	14	2019-07-21 08:30:00	sunday
5198	24	2019-07-29 08:15:00	monday
5199	32	2019-07-25 08:30:00	thursday
5200	15	2019-07-27 14:30:00	saturday
5201	30	2019-07-09 11:30:00	tuesday
5202	40	2019-07-17 16:45:00	wednesday
5203	25	2019-07-15 17:00:00	monday
5204	30	2019-07-03 16:15:00	wednesday
5205	18	2019-07-28 10:15:00	sunday
5206	11	2019-07-24 16:30:00	wednesday
5207	7	2019-07-21 09:00:00	sunday
5208	14	2019-07-15 08:30:00	monday
5209	21	2019-07-11 09:30:00	thursday
5210	4	2019-08-16 13:15:00	friday
5211	13	2019-08-17 17:45:00	saturday
5212	33	2019-08-21 08:30:00	wednesday
5213	9	2019-08-24 08:45:00	saturday
5214	30	2019-08-01 09:30:00	thursday
5215	29	2019-08-12 09:45:00	monday
5216	10	2019-08-05 08:00:00	monday
5217	24	2019-08-15 09:45:00	thursday
5218	27	2019-08-14 12:45:00	wednesday
5219	26	2019-08-19 12:30:00	monday
5220	28	2019-08-28 16:00:00	wednesday
5221	30	2019-08-20 14:30:00	tuesday
5222	22	2019-08-09 08:30:00	friday
5223	7	2019-08-26 08:45:00	monday
5224	33	2019-08-16 08:30:00	friday
5225	28	2019-08-21 16:30:00	wednesday
5226	9	2019-08-07 13:00:00	wednesday
5227	37	2019-08-01 08:15:00	thursday
5228	35	2019-08-18 15:00:00	sunday
5229	13	2019-08-22 14:15:00	thursday
5230	31	2019-08-21 13:15:00	wednesday
5231	32	2019-08-25 11:15:00	sunday
5232	37	2019-08-17 13:15:00	saturday
5233	36	2019-08-06 15:30:00	tuesday
5234	2	2019-08-14 14:00:00	wednesday
5235	25	2019-08-17 08:30:00	saturday
5236	26	2019-08-14 14:30:00	wednesday
5237	11	2019-08-21 10:15:00	wednesday
5238	13	2019-08-26 14:45:00	monday
5239	20	2019-08-22 16:45:00	thursday
5240	11	2019-08-29 15:30:00	thursday
5241	36	2019-08-27 12:00:00	tuesday
5242	18	2019-08-15 14:30:00	thursday
5243	27	2019-08-29 09:30:00	thursday
5244	12	2019-08-16 11:30:00	friday
5245	3	2019-08-04 17:30:00	sunday
5246	3	2019-08-17 16:45:00	saturday
5247	40	2019-08-29 09:15:00	thursday
5248	8	2019-08-25 14:00:00	sunday
5249	1	2019-08-12 09:45:00	monday
5250	28	2019-08-07 13:00:00	wednesday
5251	22	2019-08-08 11:15:00	thursday
5252	39	2019-08-27 15:00:00	tuesday
5253	17	2019-08-29 14:00:00	thursday
5254	7	2019-08-11 16:00:00	sunday
5255	23	2019-08-01 12:45:00	thursday
5256	14	2019-08-04 15:00:00	sunday
5257	6	2019-08-07 11:30:00	wednesday
5258	30	2019-08-12 08:00:00	monday
5259	38	2019-08-30 12:45:00	friday
5260	30	2019-08-09 16:15:00	friday
5261	18	2019-08-27 08:45:00	tuesday
5262	20	2019-08-15 16:45:00	thursday
5263	38	2019-08-14 17:00:00	wednesday
5264	33	2019-08-21 08:15:00	wednesday
5265	32	2019-08-06 13:00:00	tuesday
5266	10	2019-08-01 15:15:00	thursday
5267	8	2019-08-22 13:15:00	thursday
5268	28	2019-08-05 14:30:00	monday
5269	25	2019-08-15 09:30:00	thursday
5270	13	2019-08-20 14:15:00	tuesday
5271	8	2019-08-25 08:30:00	sunday
5272	39	2019-08-18 16:30:00	sunday
5273	26	2019-08-16 13:30:00	friday
5274	6	2019-08-30 10:45:00	friday
5275	23	2019-08-21 15:45:00	wednesday
5276	22	2019-08-04 08:15:00	sunday
5277	19	2019-08-05 13:00:00	monday
5278	23	2019-08-25 17:30:00	sunday
5279	17	2019-08-26 10:45:00	monday
5280	27	2019-08-17 11:45:00	saturday
5281	8	2019-08-10 08:15:00	saturday
5282	28	2019-08-26 08:45:00	monday
5283	32	2019-08-29 16:15:00	thursday
5284	16	2019-08-25 14:15:00	sunday
5285	11	2019-08-11 09:00:00	sunday
5286	31	2019-08-02 13:15:00	friday
5287	38	2019-08-11 14:00:00	sunday
5288	1	2019-08-11 15:15:00	sunday
5289	39	2019-08-07 11:30:00	wednesday
5290	34	2019-08-02 09:00:00	friday
5291	30	2019-08-24 13:15:00	saturday
5292	14	2019-08-02 11:30:00	friday
5293	14	2019-08-21 14:00:00	wednesday
5294	39	2019-08-16 15:45:00	friday
5295	26	2019-08-20 10:00:00	tuesday
5296	20	2019-08-30 13:45:00	friday
5297	2	2019-08-02 16:30:00	friday
5298	34	2019-08-27 14:00:00	tuesday
5299	29	2019-08-12 17:00:00	monday
5300	37	2019-08-13 14:00:00	tuesday
5301	14	2019-08-25 09:15:00	sunday
5302	4	2019-08-17 17:00:00	saturday
5303	34	2019-08-09 12:30:00	friday
5304	18	2019-09-11 10:30:00	wednesday
5305	14	2019-09-05 17:45:00	thursday
5306	17	2019-09-14 12:00:00	saturday
5307	26	2019-09-13 12:45:00	friday
5308	38	2019-09-29 15:45:00	sunday
5309	26	2019-09-26 10:15:00	thursday
5310	18	2019-09-24 17:45:00	tuesday
5311	9	2019-09-20 16:30:00	friday
5312	13	2019-09-24 14:15:00	tuesday
5313	22	2019-09-02 09:00:00	monday
5314	35	2019-09-04 13:30:00	wednesday
5315	40	2019-09-29 16:15:00	sunday
5316	8	2019-09-07 10:30:00	saturday
5317	4	2019-09-13 13:45:00	friday
5318	13	2019-09-15 14:00:00	sunday
5319	27	2019-09-05 16:15:00	thursday
5320	2	2019-09-14 17:00:00	saturday
5321	30	2019-09-01 15:15:00	sunday
5322	36	2019-09-12 13:00:00	thursday
5323	28	2019-09-06 12:15:00	friday
5324	38	2019-09-15 09:15:00	sunday
5325	16	2019-09-16 13:00:00	monday
5326	1	2019-09-05 08:00:00	thursday
5327	37	2019-09-18 16:45:00	wednesday
5328	30	2019-09-03 12:15:00	tuesday
5329	3	2019-09-29 09:15:00	sunday
5330	31	2019-09-07 10:15:00	saturday
5331	25	2019-09-30 09:30:00	monday
5332	12	2019-09-17 09:45:00	tuesday
5333	18	2019-09-24 11:30:00	tuesday
5334	2	2019-09-22 10:45:00	sunday
5335	26	2019-09-09 17:15:00	monday
5336	35	2019-09-04 11:45:00	wednesday
5337	32	2019-09-25 12:00:00	wednesday
5338	10	2019-09-30 09:30:00	monday
5339	28	2019-09-27 11:15:00	friday
5340	29	2019-09-26 13:15:00	thursday
5341	39	2019-09-22 09:30:00	sunday
5342	35	2019-09-09 09:30:00	monday
5343	7	2019-09-14 17:00:00	saturday
5344	30	2019-09-22 13:15:00	sunday
5345	26	2019-09-07 13:45:00	saturday
5346	16	2019-09-11 11:45:00	wednesday
5347	7	2019-09-17 15:30:00	tuesday
5348	31	2019-09-27 11:15:00	friday
5349	34	2019-09-04 15:15:00	wednesday
5350	26	2019-09-20 09:45:00	friday
5351	7	2019-09-07 15:00:00	saturday
5352	35	2019-09-22 12:30:00	sunday
5353	28	2019-09-22 08:30:00	sunday
5354	4	2019-09-01 10:15:00	sunday
5355	9	2019-09-26 15:15:00	thursday
5356	36	2019-09-25 11:00:00	wednesday
5357	32	2019-09-21 14:00:00	saturday
5358	25	2019-09-30 12:45:00	monday
5359	23	2019-09-02 16:15:00	monday
5360	21	2019-09-02 14:15:00	monday
5361	34	2019-09-08 15:00:00	sunday
5362	36	2019-09-12 12:30:00	thursday
5363	19	2019-09-19 12:00:00	thursday
5364	25	2019-09-30 15:45:00	monday
5365	20	2019-09-21 13:30:00	saturday
5366	22	2019-09-14 12:45:00	saturday
5367	34	2019-09-16 08:30:00	monday
5368	10	2019-09-10 10:30:00	tuesday
5369	1	2019-09-15 17:15:00	sunday
5370	10	2019-09-01 12:15:00	sunday
5371	11	2019-09-10 17:00:00	tuesday
5372	34	2019-09-19 16:00:00	thursday
5373	27	2019-09-04 15:00:00	wednesday
5374	27	2019-09-21 10:30:00	saturday
5375	4	2019-09-23 14:30:00	monday
5376	5	2019-09-16 12:15:00	monday
5377	4	2019-09-25 09:30:00	wednesday
5378	11	2019-09-30 12:15:00	monday
5379	29	2019-09-16 12:00:00	monday
5380	19	2019-09-10 09:15:00	tuesday
5381	32	2019-09-12 16:00:00	thursday
5382	5	2019-09-20 15:15:00	friday
5383	17	2019-09-12 09:45:00	thursday
5384	25	2019-09-08 11:15:00	sunday
5385	40	2019-09-22 13:00:00	sunday
5386	19	2019-09-24 16:00:00	tuesday
5387	4	2019-10-19 15:15:00	saturday
5388	8	2019-10-20 12:45:00	sunday
5389	7	2019-10-03 14:00:00	thursday
5390	24	2019-10-19 11:45:00	saturday
5391	39	2019-10-24 09:30:00	thursday
5392	28	2019-10-25 16:30:00	friday
5393	40	2019-10-19 10:30:00	saturday
5394	30	2019-10-01 09:45:00	tuesday
5395	4	2019-10-16 09:45:00	wednesday
5396	5	2019-10-27 13:15:00	sunday
5397	37	2019-10-23 16:30:00	wednesday
5398	16	2019-10-16 08:15:00	wednesday
5399	15	2019-10-27 16:30:00	sunday
5400	8	2019-10-12 09:30:00	saturday
5401	1	2019-10-04 16:30:00	friday
5402	16	2019-10-08 14:30:00	tuesday
5403	26	2019-10-17 11:15:00	thursday
5404	14	2019-10-28 15:15:00	monday
5405	5	2019-10-06 15:00:00	sunday
5406	1	2019-10-20 11:15:00	sunday
5407	39	2019-10-28 09:45:00	monday
5408	2	2019-10-26 12:00:00	saturday
5409	21	2019-10-14 09:15:00	monday
5410	37	2019-10-21 11:00:00	monday
5411	1	2019-10-10 13:00:00	thursday
5412	31	2019-10-04 11:00:00	friday
5413	12	2019-10-26 11:15:00	saturday
5414	7	2019-10-15 08:45:00	tuesday
5415	10	2019-10-16 17:15:00	wednesday
5416	30	2019-10-04 11:15:00	friday
5417	27	2019-10-18 17:45:00	friday
5418	17	2019-10-19 12:30:00	saturday
5419	30	2019-10-25 14:30:00	friday
5420	3	2019-10-08 15:45:00	tuesday
5421	37	2019-10-21 08:45:00	monday
5422	38	2019-10-17 15:00:00	thursday
5423	13	2019-10-11 10:45:00	friday
5424	24	2019-10-15 13:15:00	tuesday
5425	5	2019-10-20 12:30:00	sunday
5426	16	2019-10-23 10:30:00	wednesday
5427	27	2019-10-16 16:45:00	wednesday
5428	16	2019-10-29 09:30:00	tuesday
5429	36	2019-10-25 14:15:00	friday
5430	25	2019-10-29 13:45:00	tuesday
5431	19	2019-10-23 10:30:00	wednesday
5432	12	2019-10-01 11:45:00	tuesday
5433	23	2019-10-29 08:00:00	tuesday
5434	5	2019-10-28 08:45:00	monday
5435	15	2019-10-23 10:15:00	wednesday
5436	24	2019-10-30 17:30:00	wednesday
5437	38	2019-10-12 11:00:00	saturday
5438	6	2019-10-21 13:45:00	monday
5439	1	2019-10-06 12:45:00	sunday
5440	14	2019-10-15 15:15:00	tuesday
5441	21	2019-10-29 11:00:00	tuesday
5442	38	2019-10-21 12:45:00	monday
5443	36	2019-10-12 15:15:00	saturday
5444	1	2019-10-12 08:45:00	saturday
5445	6	2019-10-10 15:00:00	thursday
5446	39	2019-10-18 13:45:00	friday
5447	34	2019-10-04 13:30:00	friday
5448	2	2019-10-14 17:00:00	monday
5449	4	2019-10-18 09:45:00	friday
5450	29	2019-10-06 10:00:00	sunday
5451	38	2019-10-09 09:30:00	wednesday
5452	21	2019-10-28 15:00:00	monday
5453	1	2019-10-19 15:15:00	saturday
5454	9	2019-10-30 11:00:00	wednesday
5455	18	2019-10-01 09:00:00	tuesday
5456	20	2019-10-03 17:45:00	thursday
5457	31	2019-10-22 12:15:00	tuesday
5458	31	2019-10-13 15:15:00	sunday
5459	33	2019-10-14 13:15:00	monday
5460	17	2019-10-07 08:30:00	monday
5461	10	2019-10-09 08:30:00	wednesday
5462	25	2019-10-27 16:15:00	sunday
5463	6	2019-10-03 17:00:00	thursday
5464	7	2019-10-16 12:45:00	wednesday
5465	27	2019-10-13 11:30:00	sunday
5466	32	2019-10-05 13:45:00	saturday
5467	18	2019-10-21 17:15:00	monday
5468	33	2019-10-15 17:45:00	tuesday
5469	37	2019-10-01 12:15:00	tuesday
5470	1	2019-10-24 14:45:00	thursday
5471	33	2019-10-08 12:30:00	tuesday
5472	9	2019-10-24 13:45:00	thursday
5473	35	2019-10-02 14:30:00	wednesday
5474	29	2019-10-10 16:00:00	thursday
5475	21	2019-10-04 13:30:00	friday
5476	33	2019-10-02 09:00:00	wednesday
5477	7	2019-11-23 13:00:00	saturday
5478	14	2019-11-01 14:00:00	friday
5479	24	2019-11-14 08:00:00	thursday
5480	36	2019-11-23 08:30:00	saturday
5481	28	2019-11-19 12:30:00	tuesday
5482	8	2019-11-20 09:00:00	wednesday
5483	12	2019-11-03 15:45:00	sunday
5484	37	2019-11-03 14:45:00	sunday
5485	11	2019-11-02 13:30:00	saturday
5486	12	2019-11-10 12:15:00	sunday
5487	22	2019-11-04 10:45:00	monday
5488	14	2019-11-18 09:15:00	monday
5489	25	2019-11-11 16:15:00	monday
5490	29	2019-11-30 16:15:00	saturday
5491	14	2019-11-10 13:30:00	sunday
5492	25	2019-11-28 12:15:00	thursday
5493	14	2019-11-05 14:15:00	tuesday
5494	15	2019-11-24 12:45:00	sunday
5495	31	2019-11-06 12:00:00	wednesday
5496	25	2019-11-10 17:15:00	sunday
5497	38	2019-11-11 14:30:00	monday
5498	10	2019-11-06 09:45:00	wednesday
5499	28	2019-11-16 11:00:00	saturday
5500	16	2019-11-13 11:00:00	wednesday
5501	19	2019-11-16 08:15:00	saturday
5502	18	2019-11-08 09:30:00	friday
5503	24	2019-11-17 08:45:00	sunday
5504	10	2019-11-20 17:30:00	wednesday
5505	32	2019-11-21 10:15:00	thursday
5506	2	2019-11-23 08:30:00	saturday
5507	12	2019-11-19 16:00:00	tuesday
5508	24	2019-11-10 17:30:00	sunday
5509	7	2019-11-24 10:00:00	sunday
5510	3	2019-11-02 12:00:00	saturday
5511	28	2019-11-03 10:15:00	sunday
5512	13	2019-11-13 11:15:00	wednesday
5513	18	2019-11-26 11:15:00	tuesday
5514	25	2019-11-29 09:00:00	friday
5515	26	2019-11-06 13:00:00	wednesday
5516	3	2019-11-04 16:15:00	monday
5517	21	2019-11-06 12:15:00	wednesday
5518	13	2019-11-18 11:00:00	monday
5519	31	2019-11-11 10:00:00	monday
5520	30	2019-11-11 15:00:00	monday
5521	33	2019-11-25 16:15:00	monday
5522	10	2019-11-15 12:45:00	friday
5523	24	2019-11-06 10:30:00	wednesday
5524	7	2019-11-01 10:00:00	friday
5525	9	2019-11-28 17:45:00	thursday
5526	35	2019-11-09 08:30:00	saturday
5527	30	2019-11-19 16:00:00	tuesday
5528	17	2019-11-05 17:15:00	tuesday
5529	40	2019-11-28 13:15:00	thursday
5530	27	2019-11-11 12:45:00	monday
5531	5	2019-11-21 15:30:00	thursday
5532	38	2019-11-11 16:30:00	monday
5533	32	2019-11-10 12:15:00	sunday
5534	3	2019-11-07 14:30:00	thursday
5535	5	2019-11-07 17:00:00	thursday
5536	33	2019-11-29 16:30:00	friday
5537	19	2019-11-11 15:15:00	monday
5538	14	2019-11-08 15:30:00	friday
5539	26	2019-11-20 10:30:00	wednesday
5540	13	2019-11-19 17:15:00	tuesday
5541	21	2019-11-28 09:15:00	thursday
5542	23	2019-11-22 09:15:00	friday
5543	23	2019-11-21 14:15:00	thursday
5544	12	2019-11-04 11:45:00	monday
5545	23	2019-11-14 09:00:00	thursday
5546	24	2019-11-15 09:15:00	friday
5547	5	2019-11-04 13:30:00	monday
5548	24	2019-11-22 16:45:00	friday
5549	20	2019-11-18 13:30:00	monday
5550	36	2019-11-09 14:30:00	saturday
5551	32	2019-11-30 11:30:00	saturday
5552	37	2019-11-25 14:15:00	monday
5553	39	2019-11-17 11:00:00	sunday
5554	37	2019-11-01 15:15:00	friday
5555	26	2019-11-23 10:15:00	saturday
5556	19	2019-11-09 12:45:00	saturday
5557	26	2019-11-22 11:15:00	friday
5558	6	2019-11-26 13:15:00	tuesday
5559	21	2019-11-04 16:15:00	monday
5560	15	2019-11-21 15:00:00	thursday
5561	24	2019-12-03 16:00:00	tuesday
5562	17	2019-12-23 17:00:00	monday
5563	11	2019-12-13 10:30:00	friday
5564	34	2019-12-05 08:45:00	thursday
5565	10	2019-12-26 17:00:00	thursday
5566	1	2019-12-20 12:45:00	friday
5567	17	2019-12-26 15:45:00	thursday
5568	8	2019-12-14 15:15:00	saturday
5569	5	2019-12-01 12:15:00	sunday
5570	8	2019-12-26 11:30:00	thursday
5571	39	2019-12-20 12:30:00	friday
5572	25	2019-12-05 08:30:00	thursday
5573	17	2019-12-01 17:30:00	sunday
5574	25	2019-12-15 14:00:00	sunday
5575	24	2019-12-08 12:45:00	sunday
5576	2	2019-12-19 17:00:00	thursday
5577	10	2019-12-25 15:30:00	wednesday
5578	6	2019-12-11 11:30:00	wednesday
5579	23	2019-12-06 16:15:00	friday
5580	20	2019-12-10 12:15:00	tuesday
5581	10	2019-12-16 10:30:00	monday
5582	34	2019-12-20 14:45:00	friday
5583	15	2019-12-13 11:30:00	friday
5584	34	2019-12-27 13:45:00	friday
5585	36	2019-12-14 10:00:00	saturday
5586	23	2019-12-19 11:15:00	thursday
5587	17	2019-12-15 10:00:00	sunday
5588	15	2019-12-19 11:45:00	thursday
5589	34	2019-12-27 10:15:00	friday
5590	8	2019-12-07 16:15:00	saturday
5591	17	2019-12-29 17:30:00	sunday
5592	36	2019-12-21 13:00:00	saturday
5593	38	2019-12-15 14:00:00	sunday
5594	23	2019-12-13 15:15:00	friday
5595	1	2019-12-17 10:45:00	tuesday
5596	5	2019-12-25 14:00:00	wednesday
5597	4	2019-12-07 16:45:00	saturday
5598	38	2019-12-03 10:45:00	tuesday
5599	27	2019-12-09 08:45:00	monday
5600	12	2019-12-01 11:45:00	sunday
5601	37	2019-12-10 08:45:00	tuesday
5602	9	2019-12-23 09:30:00	monday
5603	18	2019-12-21 12:45:00	saturday
5604	12	2019-12-18 17:15:00	wednesday
5605	28	2019-12-10 13:45:00	tuesday
5606	2	2019-12-13 13:00:00	friday
5607	8	2019-12-07 11:15:00	saturday
5608	14	2019-12-17 16:00:00	tuesday
5609	20	2019-12-28 12:30:00	saturday
5610	11	2019-12-28 09:30:00	saturday
5611	40	2019-12-06 10:15:00	friday
5612	14	2019-12-03 14:45:00	tuesday
5613	23	2019-12-12 09:00:00	thursday
5614	14	2019-12-24 11:00:00	tuesday
5615	12	2019-12-01 11:15:00	sunday
5616	30	2019-12-08 11:45:00	sunday
5617	15	2019-12-05 12:00:00	thursday
5618	7	2019-12-24 09:30:00	tuesday
5619	32	2019-12-30 09:15:00	monday
5620	16	2019-12-28 16:30:00	saturday
5621	24	2019-12-18 11:00:00	wednesday
5622	24	2019-12-01 16:00:00	sunday
5623	28	2019-12-23 10:15:00	monday
5624	24	2019-12-19 10:30:00	thursday
5625	19	2019-12-09 11:30:00	monday
5626	3	2019-12-18 17:30:00	wednesday
5627	29	2019-12-22 17:30:00	sunday
5628	14	2019-12-02 09:45:00	monday
5629	11	2019-12-20 13:30:00	friday
5630	2	2019-12-03 15:00:00	tuesday
5631	36	2019-12-14 11:45:00	saturday
5632	15	2019-12-13 11:30:00	friday
5633	35	2019-12-02 10:45:00	monday
5634	1	2019-12-24 13:00:00	tuesday
5635	35	2019-12-30 13:45:00	monday
5636	4	2019-12-25 13:45:00	wednesday
5637	37	2019-12-05 16:45:00	thursday
5638	9	2019-12-11 11:45:00	wednesday
5639	38	2019-12-22 13:00:00	sunday
5640	33	2019-12-13 17:00:00	friday
5641	28	2019-12-19 17:00:00	thursday
5642	30	2019-12-19 16:30:00	thursday
5643	23	2019-12-19 16:30:00	thursday
5644	6	2019-12-12 13:30:00	thursday
5645	18	2019-12-07 11:00:00	saturday
5646	9	2019-12-04 12:45:00	wednesday
5647	16	2019-12-02 14:15:00	monday
5648	24	2019-12-21 14:45:00	saturday
5649	9	2019-12-14 09:45:00	saturday
5650	30	2019-12-17 16:15:00	tuesday
5651	27	2020-01-12 14:15:00	sunday
5652	10	2020-01-25 14:00:00	saturday
5653	12	2020-01-16 13:45:00	thursday
5654	26	2020-01-28 17:45:00	tuesday
5655	2	2020-01-12 17:30:00	sunday
5656	18	2020-01-07 11:45:00	tuesday
5657	10	2020-01-10 16:15:00	friday
5658	12	2020-01-28 09:00:00	tuesday
5659	11	2020-01-03 09:30:00	friday
5660	13	2020-01-06 09:30:00	monday
5661	15	2020-01-12 17:00:00	sunday
5662	19	2020-01-23 11:15:00	thursday
5663	8	2020-01-18 11:30:00	saturday
5664	31	2020-01-04 13:45:00	saturday
5665	5	2020-01-10 08:30:00	friday
5666	34	2020-01-05 17:15:00	sunday
5667	28	2020-01-18 13:15:00	saturday
5668	8	2020-01-13 09:30:00	monday
5669	23	2020-01-07 16:15:00	tuesday
5670	1	2020-01-05 12:45:00	sunday
5671	1	2020-01-09 13:15:00	thursday
5672	29	2020-01-15 12:30:00	wednesday
5673	32	2020-01-05 13:15:00	sunday
5674	5	2020-01-25 13:15:00	saturday
5675	18	2020-01-18 12:30:00	saturday
5676	31	2020-01-21 15:00:00	tuesday
5677	10	2020-01-09 09:45:00	thursday
5678	32	2020-01-28 17:30:00	tuesday
5679	33	2020-01-25 15:30:00	saturday
5680	9	2020-01-08 09:15:00	wednesday
5681	7	2020-01-30 16:30:00	thursday
5682	20	2020-01-04 16:45:00	saturday
5683	9	2020-01-07 17:00:00	tuesday
5684	21	2020-01-16 09:45:00	thursday
5685	34	2020-01-23 10:15:00	thursday
5686	27	2020-01-12 10:15:00	sunday
5687	4	2020-01-25 17:30:00	saturday
5688	14	2020-01-17 11:30:00	friday
5689	13	2020-01-03 14:15:00	friday
5690	8	2020-01-24 17:00:00	friday
5691	21	2020-01-02 14:00:00	thursday
5692	6	2020-01-09 11:00:00	thursday
5693	28	2020-01-23 16:45:00	thursday
5694	6	2020-01-13 15:45:00	monday
5695	6	2020-01-11 15:30:00	saturday
5696	32	2020-01-01 16:00:00	wednesday
5697	32	2020-01-18 10:30:00	saturday
5698	15	2020-01-29 16:45:00	wednesday
5699	18	2020-01-12 15:15:00	sunday
5700	15	2020-01-17 16:45:00	friday
5701	4	2020-01-28 15:45:00	tuesday
5702	14	2020-01-27 13:00:00	monday
5703	27	2020-01-21 11:30:00	tuesday
5704	12	2020-01-24 12:30:00	friday
5705	11	2020-01-18 08:45:00	saturday
5706	21	2020-01-01 09:45:00	wednesday
5707	35	2020-01-04 17:15:00	saturday
5708	19	2020-01-02 13:45:00	thursday
5709	30	2020-01-17 17:00:00	friday
5710	38	2020-01-18 13:00:00	saturday
5711	30	2020-01-24 15:45:00	friday
5712	22	2020-01-25 08:00:00	saturday
5713	33	2020-01-26 13:45:00	sunday
5714	28	2020-01-20 16:00:00	monday
5715	22	2020-01-06 11:45:00	monday
5716	31	2020-01-20 17:45:00	monday
5717	6	2020-01-26 09:45:00	sunday
5718	2	2020-01-06 11:30:00	monday
5719	5	2020-01-13 13:45:00	monday
5720	8	2020-01-22 09:15:00	wednesday
5721	7	2020-01-10 14:30:00	friday
5722	27	2020-01-02 12:45:00	thursday
5723	13	2020-01-15 09:30:00	wednesday
5724	30	2020-01-03 10:45:00	friday
5725	40	2020-01-26 13:30:00	sunday
5726	31	2020-01-03 17:45:00	friday
5727	10	2020-01-24 17:30:00	friday
5728	9	2020-01-17 11:00:00	friday
5729	10	2020-02-24 16:00:00	monday
5730	27	2020-02-26 10:45:00	wednesday
5731	22	2020-02-04 09:45:00	tuesday
5732	28	2020-02-11 12:45:00	tuesday
5733	23	2020-02-05 08:30:00	wednesday
5734	17	2020-02-26 10:45:00	wednesday
5735	18	2020-02-19 10:45:00	wednesday
5736	18	2020-02-01 12:15:00	saturday
5737	20	2020-02-19 15:45:00	wednesday
5738	26	2020-02-02 17:00:00	sunday
5739	27	2020-02-14 08:30:00	friday
5740	30	2020-02-01 16:15:00	saturday
5741	9	2020-02-09 15:30:00	sunday
5742	2	2020-02-23 15:30:00	sunday
5743	34	2020-02-27 16:45:00	thursday
5744	17	2020-02-20 09:00:00	thursday
5745	18	2020-02-20 09:45:00	thursday
5746	36	2020-02-25 17:00:00	tuesday
5747	25	2020-02-27 08:15:00	thursday
5748	15	2020-02-26 15:00:00	wednesday
5749	16	2020-02-21 14:45:00	friday
5750	17	2020-02-01 08:30:00	saturday
5751	20	2020-02-12 17:30:00	wednesday
5752	33	2020-02-09 11:15:00	sunday
5753	32	2020-02-04 12:15:00	tuesday
5754	12	2020-02-15 08:30:00	saturday
5755	4	2020-02-25 10:00:00	tuesday
5756	19	2020-02-08 11:00:00	saturday
5757	2	2020-02-02 17:15:00	sunday
5758	39	2020-02-16 10:15:00	sunday
5759	21	2020-02-18 14:45:00	tuesday
5760	39	2020-02-16 10:30:00	sunday
5761	18	2020-02-15 14:45:00	saturday
5762	22	2020-02-09 14:15:00	sunday
5763	24	2020-02-25 11:00:00	tuesday
5764	31	2020-02-02 10:45:00	sunday
5765	17	2020-02-11 10:15:00	tuesday
5766	2	2020-02-21 12:45:00	friday
5767	33	2020-02-18 16:15:00	tuesday
5768	22	2020-02-13 17:45:00	thursday
5769	19	2020-02-20 14:45:00	thursday
5770	7	2020-02-17 13:45:00	monday
5771	9	2020-02-13 14:30:00	thursday
5772	15	2020-02-07 13:15:00	friday
5773	10	2020-02-17 08:45:00	monday
5774	5	2020-02-06 10:30:00	thursday
5775	35	2020-02-08 09:45:00	saturday
5776	35	2020-02-20 09:45:00	thursday
5777	1	2020-02-19 08:30:00	wednesday
5778	26	2020-02-04 13:45:00	tuesday
5779	35	2020-02-01 10:30:00	saturday
5780	38	2020-02-09 09:00:00	sunday
5781	10	2020-02-19 11:15:00	wednesday
5782	29	2020-02-12 09:45:00	wednesday
5783	17	2020-02-23 11:00:00	sunday
5784	9	2020-02-18 14:30:00	tuesday
5785	23	2020-02-05 09:30:00	wednesday
5786	27	2020-02-23 13:45:00	sunday
5787	33	2020-02-01 12:45:00	saturday
5788	8	2020-02-19 14:30:00	wednesday
5789	19	2020-02-14 13:15:00	friday
5790	21	2020-02-04 11:45:00	tuesday
5791	22	2020-02-07 10:45:00	friday
5792	12	2020-02-01 14:00:00	saturday
5793	24	2020-02-14 13:45:00	friday
5794	23	2020-02-16 10:00:00	sunday
5795	25	2020-02-15 13:15:00	saturday
5796	1	2020-02-25 11:00:00	tuesday
5797	17	2020-02-17 12:15:00	monday
5798	2	2020-02-04 14:00:00	tuesday
5799	5	2020-02-17 11:15:00	monday
5800	25	2020-02-06 16:15:00	thursday
5801	33	2020-02-25 12:30:00	tuesday
5802	33	2020-02-13 10:45:00	thursday
5803	21	2020-02-26 12:00:00	wednesday
5804	6	2020-02-19 13:30:00	wednesday
5805	2	2020-02-05 12:45:00	wednesday
5806	15	2020-02-22 08:00:00	saturday
5807	20	2020-02-25 11:00:00	tuesday
5808	3	2020-02-18 13:30:00	tuesday
5809	31	2020-02-06 11:30:00	thursday
5810	38	2020-02-28 13:30:00	friday
5811	3	2020-02-12 10:00:00	wednesday
5812	3	2020-02-04 08:45:00	tuesday
5813	25	2020-02-13 13:00:00	thursday
5814	8	2020-02-08 09:45:00	saturday
5815	37	2020-02-10 08:15:00	monday
5816	7	2020-02-23 17:15:00	sunday
5817	4	2020-02-03 08:45:00	monday
5818	9	2020-02-27 14:15:00	thursday
5819	37	2020-02-17 15:45:00	monday
5820	11	2020-02-02 12:15:00	sunday
5821	2	2020-02-02 14:45:00	sunday
5822	26	2020-03-06 13:30:00	friday
5823	13	2020-03-17 12:45:00	tuesday
5824	16	2020-03-01 11:45:00	sunday
5825	37	2020-03-11 12:45:00	wednesday
5826	14	2020-03-06 16:45:00	friday
5827	24	2020-03-16 12:15:00	monday
5828	18	2020-03-24 08:45:00	tuesday
5829	32	2020-03-24 17:45:00	tuesday
5830	8	2020-03-30 11:30:00	monday
5831	32	2020-03-03 14:30:00	tuesday
5832	18	2020-03-06 12:00:00	friday
5833	30	2020-03-27 16:00:00	friday
5834	26	2020-03-15 10:30:00	sunday
5835	8	2020-03-09 11:00:00	monday
5836	4	2020-03-14 17:00:00	saturday
5837	1	2020-03-10 10:15:00	tuesday
5838	23	2020-03-20 10:00:00	friday
5839	35	2020-03-23 12:45:00	monday
5840	2	2020-03-18 10:45:00	wednesday
5841	35	2020-03-12 10:45:00	thursday
5842	9	2020-03-24 12:30:00	tuesday
5843	9	2020-03-07 08:00:00	saturday
5844	30	2020-03-02 09:30:00	monday
5845	39	2020-03-10 12:00:00	tuesday
5846	34	2020-03-05 08:00:00	thursday
5847	15	2020-03-26 10:30:00	thursday
5848	20	2020-03-23 13:00:00	monday
5849	40	2020-03-29 14:30:00	sunday
5850	13	2020-03-15 12:15:00	sunday
5851	15	2020-03-18 12:15:00	wednesday
5852	20	2020-03-02 17:30:00	monday
5853	39	2020-03-28 11:00:00	saturday
5854	29	2020-03-26 11:00:00	thursday
5855	11	2020-03-05 16:45:00	thursday
5856	10	2020-03-19 10:15:00	thursday
5857	1	2020-03-10 14:30:00	tuesday
5858	13	2020-03-17 17:00:00	tuesday
5859	6	2020-03-05 14:30:00	thursday
5860	17	2020-03-30 14:45:00	monday
5861	30	2020-03-05 13:30:00	thursday
5862	21	2020-03-09 15:00:00	monday
5863	26	2020-03-27 14:15:00	friday
5864	34	2020-03-02 08:15:00	monday
5865	9	2020-03-11 09:15:00	wednesday
5866	34	2020-03-05 16:00:00	thursday
5867	18	2020-03-14 10:00:00	saturday
5868	9	2020-03-22 08:45:00	sunday
5869	38	2020-03-21 08:30:00	saturday
5870	13	2020-03-29 14:30:00	sunday
5871	16	2020-03-25 12:45:00	wednesday
5872	32	2020-03-30 17:15:00	monday
5873	22	2020-03-27 17:30:00	friday
5874	18	2020-03-23 15:45:00	monday
5875	7	2020-03-16 16:00:00	monday
5876	17	2020-03-03 17:15:00	tuesday
5877	12	2020-03-16 12:30:00	monday
5878	10	2020-03-27 08:30:00	friday
5879	32	2020-03-13 11:45:00	friday
5880	31	2020-03-07 16:45:00	saturday
5881	2	2020-03-03 11:45:00	tuesday
5882	40	2020-03-02 10:45:00	monday
5883	40	2020-03-16 13:45:00	monday
5884	28	2020-03-03 12:15:00	tuesday
5885	4	2020-03-13 13:30:00	friday
5886	7	2020-03-23 10:15:00	monday
5887	16	2020-03-20 11:45:00	friday
5888	35	2020-03-03 16:00:00	tuesday
5889	3	2020-03-10 10:30:00	tuesday
5890	17	2020-03-12 16:30:00	thursday
5891	3	2020-03-01 11:00:00	sunday
5892	38	2020-03-11 14:15:00	wednesday
5893	1	2020-03-07 13:15:00	saturday
5894	33	2020-03-14 15:15:00	saturday
5895	34	2020-03-06 08:30:00	friday
5896	1	2020-03-25 17:45:00	wednesday
5897	11	2020-03-04 15:45:00	wednesday
5898	8	2020-04-11 08:00:00	saturday
5899	10	2020-04-28 12:00:00	tuesday
5900	12	2020-04-17 13:00:00	friday
5901	25	2020-04-27 15:15:00	monday
5902	35	2020-04-06 13:45:00	monday
5903	4	2020-04-12 12:15:00	sunday
5904	4	2020-04-25 15:30:00	saturday
5905	31	2020-04-04 09:45:00	saturday
5906	2	2020-04-11 14:15:00	saturday
5907	26	2020-04-24 09:15:00	friday
5908	25	2020-04-07 17:30:00	tuesday
5909	7	2020-04-16 14:30:00	thursday
5910	33	2020-04-03 12:30:00	friday
5911	40	2020-04-26 14:15:00	sunday
5912	16	2020-04-28 11:00:00	tuesday
5913	19	2020-04-22 15:15:00	wednesday
5914	26	2020-04-25 11:15:00	saturday
5915	15	2020-04-24 09:15:00	friday
5916	10	2020-04-14 09:00:00	tuesday
5917	14	2020-04-07 09:00:00	tuesday
5918	23	2020-04-13 11:15:00	monday
5919	27	2020-04-05 13:45:00	sunday
5920	26	2020-04-22 10:15:00	wednesday
5921	11	2020-04-29 09:45:00	wednesday
5922	4	2020-04-01 10:45:00	wednesday
5923	37	2020-04-17 12:00:00	friday
5924	10	2020-04-12 16:15:00	sunday
5925	12	2020-04-03 09:45:00	friday
5926	19	2020-04-16 13:15:00	thursday
5927	1	2020-04-07 15:30:00	tuesday
5928	29	2020-04-22 08:00:00	wednesday
5929	3	2020-04-11 17:00:00	saturday
5930	29	2020-04-20 15:00:00	monday
5931	16	2020-04-26 14:30:00	sunday
5932	14	2020-04-30 11:45:00	thursday
5933	27	2020-04-17 13:45:00	friday
5934	38	2020-04-10 09:15:00	friday
5935	14	2020-04-18 15:00:00	saturday
5936	30	2020-04-04 17:30:00	saturday
5937	23	2020-04-15 12:30:00	wednesday
5938	40	2020-04-12 13:00:00	sunday
5939	20	2020-04-19 08:30:00	sunday
5940	9	2020-04-09 16:00:00	thursday
5941	24	2020-04-06 15:00:00	monday
5942	38	2020-04-29 09:15:00	wednesday
5943	14	2020-04-15 11:45:00	wednesday
5944	16	2020-04-30 16:00:00	thursday
5945	10	2020-04-06 17:15:00	monday
5946	2	2020-04-05 16:00:00	sunday
5947	21	2020-04-18 12:15:00	saturday
5948	7	2020-04-11 11:15:00	saturday
5949	7	2020-04-10 10:30:00	friday
5950	6	2020-04-21 11:15:00	tuesday
5951	37	2020-04-20 13:15:00	monday
5952	16	2020-04-02 16:00:00	thursday
5953	10	2020-04-27 14:00:00	monday
5954	22	2020-04-05 12:00:00	sunday
5955	23	2020-04-22 16:45:00	wednesday
5956	13	2020-04-02 17:30:00	thursday
5957	36	2020-04-12 16:15:00	sunday
5958	35	2020-04-24 12:15:00	friday
5959	38	2020-04-09 08:00:00	thursday
5960	25	2020-04-14 10:30:00	tuesday
5961	9	2020-04-27 09:15:00	monday
5962	40	2020-04-13 15:30:00	monday
5963	5	2020-04-13 13:15:00	monday
5964	30	2020-04-04 17:30:00	saturday
5965	19	2020-04-24 09:45:00	friday
5966	24	2020-04-14 13:30:00	tuesday
5967	15	2020-04-05 10:00:00	sunday
5968	39	2020-04-22 08:30:00	wednesday
5969	29	2020-04-27 10:15:00	monday
5970	13	2020-04-03 09:45:00	friday
5971	29	2020-04-25 16:30:00	saturday
5972	22	2020-04-27 10:30:00	monday
5973	32	2020-04-07 14:45:00	tuesday
5974	26	2020-04-21 16:30:00	tuesday
5975	18	2020-04-11 12:00:00	saturday
5976	15	2020-04-16 16:30:00	thursday
5977	16	2020-04-14 12:15:00	tuesday
5978	40	2020-04-14 08:30:00	tuesday
5979	33	2020-04-30 17:15:00	thursday
5980	10	2020-04-03 14:15:00	friday
5981	39	2020-04-27 11:45:00	monday
5982	27	2020-04-03 08:45:00	friday
5983	29	2020-04-05 10:30:00	sunday
5984	12	2020-04-08 11:15:00	wednesday
5985	7	2020-04-17 08:30:00	friday
5986	6	2020-04-16 15:15:00	thursday
5987	39	2020-04-07 16:45:00	tuesday
5988	6	2020-05-16 15:45:00	saturday
5989	20	2020-05-27 17:15:00	wednesday
5990	26	2020-05-06 11:30:00	wednesday
5991	34	2020-05-15 12:45:00	friday
5992	10	2020-05-14 08:30:00	thursday
5993	39	2020-05-27 14:45:00	wednesday
5994	2	2020-05-01 11:45:00	friday
5995	9	2020-05-08 16:30:00	friday
5996	28	2020-05-20 12:15:00	wednesday
5997	26	2020-05-16 12:00:00	saturday
5998	25	2020-05-19 15:00:00	tuesday
5999	30	2020-05-18 17:00:00	monday
6000	38	2020-05-28 08:30:00	thursday
6001	34	2020-05-23 10:15:00	saturday
6002	24	2020-05-21 10:00:00	thursday
6003	12	2020-05-01 11:00:00	friday
6004	3	2020-05-15 08:15:00	friday
6005	23	2020-05-25 14:00:00	monday
6006	4	2020-05-18 14:15:00	monday
6007	29	2020-05-02 14:45:00	saturday
6008	20	2020-05-14 15:00:00	thursday
6009	13	2020-05-24 13:15:00	sunday
6010	37	2020-05-21 12:00:00	thursday
6011	28	2020-05-15 16:45:00	friday
6012	20	2020-05-10 13:30:00	sunday
6013	37	2020-05-05 11:30:00	tuesday
6014	7	2020-05-20 12:15:00	wednesday
6015	19	2020-05-25 11:15:00	monday
6016	15	2020-05-06 17:15:00	wednesday
6017	3	2020-05-22 09:45:00	friday
6018	36	2020-05-09 16:00:00	saturday
6019	13	2020-05-29 10:45:00	friday
6020	21	2020-05-08 15:30:00	friday
6021	2	2020-05-09 11:15:00	saturday
6022	31	2020-05-20 17:00:00	wednesday
6023	36	2020-05-24 14:30:00	sunday
6024	27	2020-05-16 10:00:00	saturday
6025	2	2020-05-12 12:45:00	tuesday
6026	26	2020-05-16 13:45:00	saturday
6027	11	2020-05-04 09:00:00	monday
6028	18	2020-05-01 11:45:00	friday
6029	8	2020-05-06 15:00:00	wednesday
6030	32	2020-05-20 12:45:00	wednesday
6031	36	2020-05-25 16:30:00	monday
6032	20	2020-05-21 13:30:00	thursday
6033	21	2020-05-08 16:00:00	friday
6034	34	2020-05-23 08:15:00	saturday
6035	18	2020-05-11 17:15:00	monday
6036	5	2020-05-12 12:15:00	tuesday
6037	4	2020-05-03 10:45:00	sunday
6038	4	2020-05-21 12:00:00	thursday
6039	31	2020-05-15 17:30:00	friday
6040	31	2020-05-05 13:00:00	tuesday
6041	7	2020-05-11 17:45:00	monday
6042	1	2020-05-24 15:00:00	sunday
6043	21	2020-05-01 12:45:00	friday
6044	29	2020-05-21 08:45:00	thursday
6045	34	2020-05-11 09:15:00	monday
6046	1	2020-05-22 16:30:00	friday
6047	8	2020-05-24 12:30:00	sunday
6048	16	2020-05-25 11:30:00	monday
6049	14	2020-05-15 11:15:00	friday
6050	33	2020-05-05 12:30:00	tuesday
6051	26	2020-05-05 15:45:00	tuesday
6052	3	2020-05-05 08:00:00	tuesday
6053	14	2020-05-15 08:30:00	friday
6054	35	2020-05-15 08:30:00	friday
6055	37	2020-05-28 11:15:00	thursday
6056	25	2020-05-14 10:00:00	thursday
6057	12	2020-05-09 12:30:00	saturday
6058	9	2020-05-14 08:45:00	thursday
6059	20	2020-05-14 10:30:00	thursday
6060	13	2020-05-04 15:45:00	monday
6061	4	2020-05-22 14:30:00	friday
6062	21	2020-05-14 08:15:00	thursday
6063	32	2020-05-10 12:30:00	sunday
6064	17	2020-05-12 16:45:00	tuesday
6065	23	2020-05-24 10:45:00	sunday
6066	10	2020-05-25 16:00:00	monday
6067	38	2020-05-19 09:15:00	tuesday
6068	15	2020-05-23 11:15:00	saturday
6069	31	2020-05-27 10:30:00	wednesday
6070	11	2020-05-01 09:30:00	friday
6071	31	2020-06-24 12:00:00	wednesday
6072	1	2020-06-02 09:30:00	tuesday
6073	33	2020-06-05 11:15:00	friday
6074	35	2020-06-28 16:00:00	sunday
6075	13	2020-06-12 17:45:00	friday
6076	3	2020-06-20 12:15:00	saturday
6077	5	2020-06-13 17:15:00	saturday
6078	2	2020-06-14 17:00:00	sunday
6079	36	2020-06-02 12:15:00	tuesday
6080	31	2020-06-25 15:15:00	thursday
6081	15	2020-06-07 15:45:00	sunday
6082	29	2020-06-03 11:30:00	wednesday
6083	5	2020-06-06 09:45:00	saturday
6084	8	2020-06-15 13:15:00	monday
6085	9	2020-06-08 16:45:00	monday
6086	13	2020-06-21 11:00:00	sunday
6087	4	2020-06-23 08:15:00	tuesday
6088	31	2020-06-17 09:30:00	wednesday
6089	13	2020-06-25 16:00:00	thursday
6090	38	2020-06-16 17:15:00	tuesday
6091	35	2020-06-13 10:45:00	saturday
6092	15	2020-06-30 15:45:00	tuesday
6093	6	2020-06-17 10:45:00	wednesday
6094	17	2020-06-18 12:30:00	thursday
6095	19	2020-06-02 16:15:00	tuesday
6096	28	2020-06-12 16:15:00	friday
6097	23	2020-06-06 13:30:00	saturday
6098	1	2020-06-23 17:30:00	tuesday
6099	1	2020-06-28 11:00:00	sunday
6100	38	2020-06-01 10:45:00	monday
6101	18	2020-06-12 10:45:00	friday
6102	1	2020-06-04 12:15:00	thursday
6103	13	2020-06-10 15:00:00	wednesday
6104	18	2020-06-30 17:15:00	tuesday
6105	1	2020-06-13 08:00:00	saturday
6106	27	2020-06-17 12:30:00	wednesday
6107	27	2020-06-23 16:15:00	tuesday
6108	9	2020-06-10 15:45:00	wednesday
6109	15	2020-06-16 15:15:00	tuesday
6110	33	2020-06-30 08:15:00	tuesday
6111	6	2020-06-10 15:45:00	wednesday
6112	21	2020-06-27 09:30:00	saturday
6113	38	2020-06-23 17:45:00	tuesday
6114	23	2020-06-15 16:45:00	monday
6115	23	2020-06-25 11:30:00	thursday
6116	11	2020-06-17 15:30:00	wednesday
6117	2	2020-06-23 16:30:00	tuesday
6118	6	2020-06-12 14:30:00	friday
6119	26	2020-06-08 09:00:00	monday
6120	11	2020-06-13 14:15:00	saturday
6121	36	2020-06-23 15:15:00	tuesday
6122	34	2020-06-05 13:00:00	friday
6123	16	2020-06-17 12:00:00	wednesday
6124	32	2020-06-16 10:00:00	tuesday
6125	31	2020-06-20 11:00:00	saturday
6126	36	2020-06-25 16:45:00	thursday
6127	21	2020-06-26 13:45:00	friday
6128	21	2020-06-12 16:45:00	friday
6129	30	2020-06-16 13:30:00	tuesday
6130	39	2020-06-14 10:15:00	sunday
6131	18	2020-06-26 15:30:00	friday
6132	21	2020-06-27 16:45:00	saturday
6133	2	2020-06-18 15:45:00	thursday
6134	21	2020-06-06 13:30:00	saturday
6135	18	2020-06-25 11:30:00	thursday
6136	9	2020-06-17 15:15:00	wednesday
6137	39	2020-06-28 11:45:00	sunday
6138	2	2020-06-23 12:45:00	tuesday
6139	16	2020-06-06 15:30:00	saturday
6140	29	2020-06-06 08:45:00	saturday
6141	7	2020-06-10 16:00:00	wednesday
6142	7	2020-06-23 14:15:00	tuesday
6143	39	2020-06-13 16:00:00	saturday
6144	18	2020-06-03 12:00:00	wednesday
6145	28	2020-06-01 09:30:00	monday
6146	32	2020-06-30 15:45:00	tuesday
6147	32	2020-06-27 14:15:00	saturday
6148	36	2020-06-16 11:00:00	tuesday
6149	10	2020-06-03 10:30:00	wednesday
6150	14	2020-06-27 16:00:00	saturday
6151	6	2020-06-30 10:00:00	tuesday
6152	37	2020-06-20 08:15:00	saturday
6153	34	2020-06-22 12:45:00	monday
6154	36	2020-06-18 10:30:00	thursday
6155	20	2020-07-26 15:00:00	sunday
6156	39	2020-07-19 13:00:00	sunday
6157	7	2020-07-20 10:00:00	monday
6158	21	2020-07-24 16:45:00	friday
6159	12	2020-07-05 10:30:00	sunday
6160	37	2020-07-07 10:00:00	tuesday
6161	11	2020-07-01 12:45:00	wednesday
6162	34	2020-07-21 15:00:00	tuesday
6163	9	2020-07-26 14:45:00	sunday
6164	1	2020-07-14 12:30:00	tuesday
6165	33	2020-07-06 15:00:00	monday
6166	8	2020-07-24 13:00:00	friday
6167	14	2020-07-02 09:00:00	thursday
6168	22	2020-07-08 14:45:00	wednesday
6169	4	2020-07-17 15:45:00	friday
6170	31	2020-07-19 15:30:00	sunday
6171	12	2020-07-10 15:15:00	friday
6172	31	2020-07-17 11:15:00	friday
6173	30	2020-07-04 13:45:00	saturday
6174	3	2020-07-23 12:45:00	thursday
6175	38	2020-07-30 17:15:00	thursday
6176	21	2020-07-28 12:00:00	tuesday
6177	25	2020-07-15 16:00:00	wednesday
6178	7	2020-07-22 15:45:00	wednesday
6179	7	2020-07-17 11:00:00	friday
6180	12	2020-07-27 15:00:00	monday
6181	16	2020-07-19 10:45:00	sunday
6182	12	2020-07-25 14:15:00	saturday
6183	33	2020-07-26 12:30:00	sunday
6184	30	2020-07-17 15:00:00	friday
6185	22	2020-07-19 12:30:00	sunday
6186	37	2020-07-12 11:15:00	sunday
6187	31	2020-07-01 08:00:00	wednesday
6188	13	2020-07-06 17:00:00	monday
6189	12	2020-07-18 13:15:00	saturday
6190	20	2020-07-20 11:30:00	monday
6191	3	2020-07-13 16:00:00	monday
6192	19	2020-07-28 12:30:00	tuesday
6193	23	2020-07-06 11:45:00	monday
6194	29	2020-07-13 13:15:00	monday
6195	7	2020-07-10 11:00:00	friday
6196	28	2020-07-07 13:30:00	tuesday
6197	7	2020-07-18 14:30:00	saturday
6198	33	2020-07-22 08:45:00	wednesday
6199	16	2020-07-03 12:00:00	friday
6200	34	2020-07-25 12:45:00	saturday
6201	39	2020-07-20 17:45:00	monday
6202	27	2020-07-29 08:00:00	wednesday
6203	13	2020-07-15 15:00:00	wednesday
6204	16	2020-07-01 13:15:00	wednesday
6205	27	2020-07-11 09:00:00	saturday
6206	30	2020-07-25 14:00:00	saturday
6207	3	2020-07-06 11:45:00	monday
6208	39	2020-07-20 09:45:00	monday
6209	20	2020-07-18 13:30:00	saturday
6210	4	2020-07-12 09:00:00	sunday
6211	12	2020-07-19 15:00:00	sunday
6212	3	2020-07-28 12:00:00	tuesday
6213	37	2020-07-12 13:30:00	sunday
6214	40	2020-07-13 17:00:00	monday
6215	26	2020-07-15 17:15:00	wednesday
6216	5	2020-07-29 15:00:00	wednesday
6217	24	2020-07-11 17:45:00	saturday
6218	28	2020-07-10 08:30:00	friday
6219	40	2020-07-01 16:30:00	wednesday
6220	25	2020-07-10 13:45:00	friday
6221	17	2020-07-03 11:30:00	friday
6222	18	2020-07-04 11:15:00	saturday
6223	8	2020-07-25 14:00:00	saturday
6224	16	2020-07-18 13:00:00	saturday
6225	9	2020-07-10 16:30:00	friday
6226	22	2020-07-11 12:45:00	saturday
6227	20	2020-07-29 17:15:00	wednesday
6228	6	2020-07-15 15:00:00	wednesday
6229	35	2020-07-27 17:00:00	monday
6230	17	2020-08-28 17:15:00	friday
6231	24	2020-08-23 10:45:00	sunday
6232	21	2020-08-03 14:45:00	monday
6233	1	2020-08-18 16:45:00	tuesday
6234	14	2020-08-27 14:00:00	thursday
6235	38	2020-08-20 16:45:00	thursday
6236	39	2020-08-03 14:30:00	monday
6237	7	2020-08-08 11:15:00	saturday
6238	31	2020-08-11 14:45:00	tuesday
6239	31	2020-08-26 08:00:00	wednesday
6240	31	2020-08-02 16:30:00	sunday
6241	13	2020-08-04 11:15:00	tuesday
6242	32	2020-08-20 08:30:00	thursday
6243	24	2020-08-07 17:45:00	friday
6244	31	2020-08-22 08:15:00	saturday
6245	24	2020-08-01 16:15:00	saturday
6246	19	2020-08-25 17:45:00	tuesday
6247	34	2020-08-14 11:00:00	friday
6248	3	2020-08-15 15:30:00	saturday
6249	34	2020-08-13 12:45:00	thursday
6250	25	2020-08-13 12:30:00	thursday
6251	15	2020-08-05 14:30:00	wednesday
6252	35	2020-08-22 12:00:00	saturday
6253	20	2020-08-10 08:45:00	monday
6254	7	2020-08-25 10:15:00	tuesday
6255	27	2020-08-23 15:00:00	sunday
6256	36	2020-08-26 08:45:00	wednesday
6257	34	2020-08-21 12:00:00	friday
6258	29	2020-08-02 13:30:00	sunday
6259	39	2020-08-14 13:30:00	friday
6260	30	2020-08-26 17:30:00	wednesday
6261	21	2020-08-07 17:45:00	friday
6262	31	2020-08-19 09:45:00	wednesday
6263	7	2020-08-16 08:00:00	sunday
6264	38	2020-08-21 14:00:00	friday
6265	26	2020-08-01 15:45:00	saturday
6266	39	2020-08-24 08:15:00	monday
6267	12	2020-08-08 16:15:00	saturday
6268	37	2020-08-29 13:45:00	saturday
6269	1	2020-08-17 08:15:00	monday
6270	39	2020-08-16 15:00:00	sunday
6271	26	2020-08-08 11:45:00	saturday
6272	6	2020-08-24 13:00:00	monday
6273	37	2020-08-09 17:30:00	sunday
6274	19	2020-08-21 09:15:00	friday
6275	18	2020-08-10 11:45:00	monday
6276	27	2020-08-29 10:30:00	saturday
6277	18	2020-08-29 12:15:00	saturday
6278	28	2020-08-23 14:45:00	sunday
6279	32	2020-08-14 15:00:00	friday
6280	31	2020-08-08 10:15:00	saturday
6281	1	2020-08-08 13:30:00	saturday
6282	22	2020-08-08 13:15:00	saturday
6283	13	2020-08-05 15:00:00	wednesday
6284	36	2020-08-05 15:15:00	wednesday
6285	29	2020-08-20 11:30:00	thursday
6286	26	2020-08-16 15:45:00	sunday
6287	21	2020-08-22 08:15:00	saturday
6288	14	2020-08-11 16:45:00	tuesday
6289	25	2020-08-20 11:15:00	thursday
6290	19	2020-08-29 15:30:00	saturday
6291	25	2020-08-08 10:15:00	saturday
6292	5	2020-08-24 13:30:00	monday
6293	38	2020-08-07 13:45:00	friday
6294	19	2020-08-08 13:15:00	saturday
6295	4	2020-08-13 10:45:00	thursday
6296	22	2020-08-08 15:15:00	saturday
6297	40	2020-08-30 11:00:00	sunday
6298	38	2020-08-22 15:30:00	saturday
6299	26	2020-08-22 16:45:00	saturday
6300	25	2020-08-14 14:15:00	friday
6301	17	2020-08-01 13:15:00	saturday
6302	21	2020-08-12 08:30:00	wednesday
6303	35	2020-08-23 13:45:00	sunday
6304	3	2020-08-09 15:15:00	sunday
6305	12	2020-08-26 14:00:00	wednesday
6306	28	2020-08-07 13:45:00	friday
6307	35	2020-08-17 08:30:00	monday
6308	5	2020-08-06 09:45:00	thursday
6309	34	2020-08-27 09:00:00	thursday
6310	36	2020-08-04 13:00:00	tuesday
6311	5	2020-08-02 16:30:00	sunday
6312	10	2020-08-01 17:45:00	saturday
6313	31	2020-08-17 17:15:00	monday
6314	8	2020-08-09 10:30:00	sunday
6315	26	2020-08-05 12:30:00	wednesday
6316	36	2020-08-28 11:15:00	friday
6317	37	2020-08-15 10:30:00	saturday
6318	19	2020-08-18 16:15:00	tuesday
6319	5	2020-08-09 12:00:00	sunday
6320	6	2020-09-12 14:00:00	saturday
6321	31	2020-09-01 14:15:00	tuesday
6322	39	2020-09-23 09:15:00	wednesday
6323	1	2020-09-21 10:30:00	monday
6324	34	2020-09-18 12:30:00	friday
6325	14	2020-09-09 16:00:00	wednesday
6326	6	2020-09-14 12:45:00	monday
6327	8	2020-09-26 09:45:00	saturday
6328	28	2020-09-12 14:15:00	saturday
6329	30	2020-09-23 17:00:00	wednesday
6330	4	2020-09-30 16:15:00	wednesday
6331	37	2020-09-02 14:45:00	wednesday
6332	36	2020-09-22 16:30:00	tuesday
6333	1	2020-09-30 13:45:00	wednesday
6334	34	2020-09-26 12:15:00	saturday
6335	19	2020-09-01 11:00:00	tuesday
6336	15	2020-09-23 14:15:00	wednesday
6337	33	2020-09-16 15:00:00	wednesday
6338	36	2020-09-17 15:30:00	thursday
6339	35	2020-09-13 08:15:00	sunday
6340	21	2020-09-18 16:15:00	friday
6341	33	2020-09-06 10:00:00	sunday
6342	10	2020-09-26 10:45:00	saturday
6343	16	2020-09-25 13:00:00	friday
6344	27	2020-09-18 13:15:00	friday
6345	20	2020-09-09 16:15:00	wednesday
6346	1	2020-09-24 17:30:00	thursday
6347	21	2020-09-08 14:00:00	tuesday
6348	34	2020-09-16 17:00:00	wednesday
6349	28	2020-09-12 16:00:00	saturday
6350	19	2020-09-06 12:45:00	sunday
6351	4	2020-09-25 16:00:00	friday
6352	21	2020-09-20 11:45:00	sunday
6353	27	2020-09-11 10:45:00	friday
6354	34	2020-09-13 17:00:00	sunday
6355	8	2020-09-28 13:00:00	monday
6356	38	2020-09-14 15:30:00	monday
6357	12	2020-09-30 17:45:00	wednesday
6358	16	2020-09-12 15:15:00	saturday
6359	35	2020-09-14 12:45:00	monday
6360	16	2020-09-15 10:00:00	tuesday
6361	10	2020-09-21 08:45:00	monday
6362	16	2020-09-26 12:45:00	saturday
6363	32	2020-09-29 17:30:00	tuesday
6364	6	2020-09-16 09:45:00	wednesday
6365	38	2020-09-11 09:45:00	friday
6366	6	2020-09-20 16:00:00	sunday
6367	25	2020-09-13 13:30:00	sunday
6368	1	2020-09-05 11:30:00	saturday
6369	20	2020-09-04 11:00:00	friday
6370	18	2020-09-16 16:00:00	wednesday
6371	24	2020-09-22 16:15:00	tuesday
6372	20	2020-09-24 08:15:00	thursday
6373	38	2020-09-05 15:45:00	saturday
6374	23	2020-09-09 13:00:00	wednesday
6375	17	2020-09-16 11:15:00	wednesday
6376	27	2020-09-15 11:00:00	tuesday
6377	15	2020-09-04 13:15:00	friday
6378	17	2020-09-12 13:45:00	saturday
6379	30	2020-09-07 12:30:00	monday
6380	39	2020-09-18 14:45:00	friday
6381	25	2020-09-05 09:00:00	saturday
6382	18	2020-09-13 17:15:00	sunday
6383	1	2020-09-25 11:30:00	friday
6384	2	2020-09-12 14:30:00	saturday
6385	38	2020-09-07 16:30:00	monday
6386	3	2020-09-16 08:15:00	wednesday
6387	13	2020-09-05 12:15:00	saturday
6388	40	2020-09-16 13:30:00	wednesday
6389	9	2020-09-08 14:15:00	tuesday
6390	16	2020-09-05 17:00:00	saturday
6391	28	2020-09-17 16:15:00	thursday
6392	35	2020-09-08 11:30:00	tuesday
6393	36	2020-09-06 13:45:00	sunday
6394	35	2020-09-23 16:30:00	wednesday
6395	32	2020-09-09 13:30:00	wednesday
6396	37	2020-09-28 14:15:00	monday
6397	10	2020-09-05 10:30:00	saturday
6398	23	2020-09-27 17:45:00	sunday
6399	21	2020-09-16 08:45:00	wednesday
6400	33	2020-09-13 13:00:00	sunday
6401	22	2020-09-05 12:00:00	saturday
6402	38	2020-09-05 08:00:00	saturday
6403	5	2020-09-06 15:00:00	sunday
6404	18	2020-10-26 08:30:00	monday
6405	34	2020-10-26 09:30:00	monday
6406	19	2020-10-16 09:30:00	friday
6407	26	2020-10-28 09:45:00	wednesday
6408	9	2020-10-23 16:00:00	friday
6409	9	2020-10-24 12:45:00	saturday
6410	39	2020-10-08 08:15:00	thursday
6411	14	2020-10-23 11:00:00	friday
6412	2	2020-10-27 13:30:00	tuesday
6413	36	2020-10-17 14:00:00	saturday
6414	23	2020-10-26 16:30:00	monday
6415	29	2020-10-24 16:45:00	saturday
6416	6	2020-10-11 10:30:00	sunday
6417	7	2020-10-04 14:00:00	sunday
6418	11	2020-10-25 08:45:00	sunday
6419	1	2020-10-27 15:30:00	tuesday
6420	25	2020-10-19 11:45:00	monday
6421	36	2020-10-02 16:00:00	friday
6422	39	2020-10-09 11:30:00	friday
6423	35	2020-10-18 15:15:00	sunday
6424	5	2020-10-27 12:45:00	tuesday
6425	13	2020-10-11 16:45:00	sunday
6426	5	2020-10-04 09:00:00	sunday
6427	16	2020-10-15 17:00:00	thursday
6428	36	2020-10-19 11:30:00	monday
6429	13	2020-10-17 11:15:00	saturday
6430	32	2020-10-15 10:30:00	thursday
6431	24	2020-10-01 08:15:00	thursday
6432	9	2020-10-17 13:00:00	saturday
6433	23	2020-10-02 08:30:00	friday
6434	25	2020-10-04 11:30:00	sunday
6435	32	2020-10-14 12:30:00	wednesday
6436	30	2020-10-05 08:00:00	monday
6437	29	2020-10-25 11:00:00	sunday
6438	13	2020-10-02 14:00:00	friday
6439	24	2020-10-02 08:15:00	friday
6440	30	2020-10-10 11:45:00	saturday
6441	25	2020-10-24 12:00:00	saturday
6442	28	2020-10-25 15:00:00	sunday
6443	21	2020-10-17 08:15:00	saturday
6444	19	2020-10-22 17:30:00	thursday
6445	38	2020-10-17 17:15:00	saturday
6446	10	2020-10-28 11:30:00	wednesday
6447	7	2020-10-24 14:45:00	saturday
6448	17	2020-10-02 10:00:00	friday
6449	30	2020-10-22 17:45:00	thursday
6450	9	2020-10-19 16:30:00	monday
6451	19	2020-10-02 10:30:00	friday
6452	16	2020-10-24 12:30:00	saturday
6453	5	2020-10-26 15:15:00	monday
6454	4	2020-10-15 11:45:00	thursday
6455	1	2020-10-19 14:00:00	monday
6456	29	2020-10-24 17:15:00	saturday
6457	28	2020-10-08 15:15:00	thursday
6458	21	2020-10-30 10:15:00	friday
6459	29	2020-10-10 13:30:00	saturday
6460	25	2020-10-27 09:30:00	tuesday
6461	38	2020-10-29 13:30:00	thursday
6462	38	2020-10-03 08:15:00	saturday
6463	34	2020-10-29 10:30:00	thursday
6464	22	2020-10-28 13:15:00	wednesday
6465	22	2020-10-26 12:15:00	monday
6466	27	2020-10-02 12:45:00	friday
6467	33	2020-10-21 15:45:00	wednesday
6468	24	2020-10-15 16:45:00	thursday
6469	13	2020-10-15 12:00:00	thursday
6470	21	2020-10-08 10:00:00	thursday
6471	22	2020-10-11 09:30:00	sunday
6472	33	2020-10-28 17:30:00	wednesday
6473	39	2020-10-13 08:30:00	tuesday
6474	15	2020-10-19 12:15:00	monday
6475	2	2020-10-28 12:15:00	wednesday
6476	35	2020-10-03 11:15:00	saturday
6477	6	2020-10-16 17:30:00	friday
6478	36	2020-10-26 17:00:00	monday
6479	24	2020-11-26 13:00:00	thursday
6480	10	2020-11-26 13:15:00	thursday
6481	37	2020-11-22 15:45:00	sunday
6482	38	2020-11-08 15:45:00	sunday
6483	3	2020-11-27 12:45:00	friday
6484	38	2020-11-20 14:00:00	friday
6485	5	2020-11-19 12:15:00	thursday
6486	40	2020-11-11 09:00:00	wednesday
6487	6	2020-11-01 17:30:00	sunday
6488	3	2020-11-28 15:00:00	saturday
6489	10	2020-11-26 17:45:00	thursday
6490	27	2020-11-09 12:15:00	monday
6491	26	2020-11-09 14:30:00	monday
6492	20	2020-11-21 14:45:00	saturday
6493	14	2020-11-21 15:00:00	saturday
6494	20	2020-11-05 12:00:00	thursday
6495	2	2020-11-03 12:30:00	tuesday
6496	2	2020-11-30 16:00:00	monday
6497	19	2020-11-12 12:45:00	thursday
6498	3	2020-11-15 13:00:00	sunday
6499	9	2020-11-02 14:45:00	monday
6500	25	2020-11-01 09:30:00	sunday
6501	29	2020-11-25 09:45:00	wednesday
6502	20	2020-11-08 10:00:00	sunday
6503	17	2020-11-06 14:15:00	friday
6504	19	2020-11-04 09:00:00	wednesday
6505	36	2020-11-14 17:45:00	saturday
6506	1	2020-11-30 14:15:00	monday
6507	13	2020-11-09 10:15:00	monday
6508	18	2020-11-02 08:45:00	monday
6509	5	2020-11-13 08:00:00	friday
6510	37	2020-11-05 16:30:00	thursday
6511	32	2020-11-26 11:15:00	thursday
6512	33	2020-11-22 15:00:00	sunday
6513	25	2020-11-26 17:45:00	thursday
6514	33	2020-11-20 12:30:00	friday
6515	10	2020-11-16 14:00:00	monday
6516	34	2020-11-22 10:00:00	sunday
6517	12	2020-11-28 10:45:00	saturday
6518	26	2020-11-22 14:00:00	sunday
6519	1	2020-11-18 09:30:00	wednesday
6520	32	2020-11-20 08:15:00	friday
6521	6	2020-11-29 09:30:00	sunday
6522	24	2020-11-20 12:15:00	friday
6523	20	2020-11-02 14:30:00	monday
6524	22	2020-11-17 11:45:00	tuesday
6525	20	2020-11-08 08:30:00	sunday
6526	15	2020-11-24 13:15:00	tuesday
6527	1	2020-11-05 09:15:00	thursday
6528	29	2020-11-01 12:15:00	sunday
6529	23	2020-11-06 08:45:00	friday
6530	33	2020-11-24 12:00:00	tuesday
6531	23	2020-11-18 10:15:00	wednesday
6532	25	2020-11-20 13:00:00	friday
6533	34	2020-11-18 11:30:00	wednesday
6534	33	2020-11-17 12:45:00	tuesday
6535	28	2020-11-28 09:45:00	saturday
6536	19	2020-11-09 11:00:00	monday
6537	40	2020-11-18 11:30:00	wednesday
6538	1	2020-11-25 17:15:00	wednesday
6539	31	2020-11-25 15:45:00	wednesday
6540	15	2020-11-04 17:45:00	wednesday
6541	35	2020-11-15 11:15:00	sunday
6542	12	2020-11-16 13:45:00	monday
6543	29	2020-11-03 13:30:00	tuesday
6544	15	2020-11-29 16:45:00	sunday
6545	5	2020-11-27 12:30:00	friday
6546	3	2020-11-04 17:15:00	wednesday
6547	32	2020-11-26 13:45:00	thursday
6548	5	2020-11-23 14:15:00	monday
6549	17	2020-11-06 16:15:00	friday
6550	10	2020-11-15 12:15:00	sunday
6551	26	2020-11-17 09:00:00	tuesday
6552	20	2020-11-21 16:15:00	saturday
6553	17	2020-11-24 08:00:00	tuesday
6554	36	2020-12-01 10:15:00	tuesday
6555	22	2020-12-08 12:00:00	tuesday
6556	38	2020-12-20 14:15:00	sunday
6557	17	2020-12-24 09:45:00	thursday
6558	34	2020-12-14 10:30:00	monday
6559	30	2020-12-13 13:45:00	sunday
6560	30	2020-12-26 10:00:00	saturday
6561	26	2020-12-06 17:30:00	sunday
6562	31	2020-12-13 12:45:00	sunday
6563	28	2020-12-24 15:30:00	thursday
6564	31	2020-12-29 12:00:00	tuesday
6565	7	2020-12-21 16:00:00	monday
6566	5	2020-12-29 08:15:00	tuesday
6567	4	2020-12-16 09:30:00	wednesday
6568	18	2020-12-22 11:00:00	tuesday
6569	10	2020-12-04 09:00:00	friday
6570	16	2020-12-25 13:00:00	friday
6571	16	2020-12-02 17:00:00	wednesday
6572	27	2020-12-10 09:30:00	thursday
6573	23	2020-12-24 14:15:00	thursday
6574	9	2020-12-02 16:00:00	wednesday
6575	34	2020-12-06 08:15:00	sunday
6576	19	2020-12-18 13:45:00	friday
6577	30	2020-12-28 13:30:00	monday
6578	11	2020-12-09 09:30:00	wednesday
6579	28	2020-12-08 12:30:00	tuesday
6580	38	2020-12-23 11:15:00	wednesday
6581	36	2020-12-27 11:45:00	sunday
6582	9	2020-12-15 11:45:00	tuesday
6583	26	2020-12-08 12:00:00	tuesday
6584	6	2020-12-07 10:45:00	monday
6585	27	2020-12-28 08:30:00	monday
6586	14	2020-12-15 12:30:00	tuesday
6587	22	2020-12-01 08:45:00	tuesday
6588	29	2020-12-01 08:15:00	tuesday
6589	28	2020-12-19 15:30:00	saturday
6590	2	2020-12-12 14:15:00	saturday
6591	25	2020-12-24 09:00:00	thursday
6592	38	2020-12-27 12:30:00	sunday
6593	19	2020-12-27 10:00:00	sunday
6594	10	2020-12-20 16:30:00	sunday
6595	32	2020-12-11 15:30:00	friday
6596	11	2020-12-04 13:15:00	friday
6597	18	2020-12-05 17:45:00	saturday
6598	15	2020-12-23 11:45:00	wednesday
6599	19	2020-12-03 08:45:00	thursday
6600	31	2020-12-14 14:30:00	monday
6601	19	2020-12-08 09:00:00	tuesday
6602	21	2020-12-19 15:15:00	saturday
6603	23	2020-12-06 10:15:00	sunday
6604	13	2020-12-23 11:45:00	wednesday
6605	1	2020-12-04 16:45:00	friday
6606	29	2020-12-30 12:00:00	wednesday
6607	37	2020-12-20 11:30:00	sunday
6608	14	2020-12-24 17:15:00	thursday
6609	7	2020-12-08 10:45:00	tuesday
6610	26	2020-12-26 12:30:00	saturday
6611	31	2020-12-15 12:00:00	tuesday
6612	14	2020-12-16 08:00:00	wednesday
6613	38	2020-12-06 10:45:00	sunday
6614	31	2020-12-25 12:30:00	friday
6615	32	2020-12-12 14:15:00	saturday
6616	38	2020-12-03 14:30:00	thursday
6617	19	2020-12-22 15:15:00	tuesday
6618	38	2020-12-01 17:15:00	tuesday
6619	20	2020-12-08 11:00:00	tuesday
6620	18	2020-12-15 13:45:00	tuesday
6621	30	2020-12-28 15:45:00	monday
6622	26	2020-12-12 12:30:00	saturday
6623	19	2020-12-12 16:15:00	saturday
6624	36	2020-12-07 14:15:00	monday
6625	26	2020-12-13 16:15:00	sunday
6626	20	2020-12-18 09:15:00	friday
6627	34	2020-12-04 09:30:00	friday
6628	14	2020-12-22 17:45:00	tuesday
6629	19	2020-12-19 14:15:00	saturday
6630	16	2020-12-24 14:30:00	thursday
6631	17	2020-12-30 08:00:00	wednesday
6632	11	2020-12-18 09:45:00	friday
6633	10	2020-12-08 12:00:00	tuesday
6634	17	2020-12-24 13:45:00	thursday
6635	4	2020-12-12 15:15:00	saturday
6636	21	2020-12-14 10:15:00	monday
6637	18	2020-12-28 11:45:00	monday
6638	8	2020-12-17 17:30:00	thursday
6639	22	2020-12-09 13:45:00	wednesday
6640	8	2020-12-06 17:15:00	sunday
6641	21	2020-12-21 10:00:00	monday
6642	8	2020-12-01 15:15:00	tuesday
6643	40	2020-12-07 17:45:00	monday
6644	20	2020-12-21 10:00:00	monday
6645	15	2020-12-21 15:15:00	monday
6646	11	2020-12-10 10:45:00	thursday
6647	29	2020-12-05 14:30:00	saturday
6648	29	2020-12-03 10:00:00	thursday
6649	1	2020-12-30 12:15:00	wednesday
6650	13	2020-12-28 12:15:00	monday
6651	38	2021-01-03 15:15:00	sunday
6652	8	2021-01-30 17:30:00	saturday
6653	13	2021-01-10 13:15:00	sunday
6654	10	2021-01-21 13:30:00	thursday
6655	36	2021-01-09 17:30:00	saturday
6656	37	2021-01-04 08:00:00	monday
6657	3	2021-01-25 16:45:00	monday
6658	21	2021-01-19 14:45:00	tuesday
6659	11	2021-01-17 09:30:00	sunday
6660	9	2021-01-13 16:15:00	wednesday
6661	39	2021-01-24 09:00:00	sunday
6662	32	2021-01-06 14:15:00	wednesday
6663	37	2021-01-10 14:30:00	sunday
6664	30	2021-01-30 11:15:00	saturday
6665	12	2021-01-23 10:45:00	saturday
6666	30	2021-01-17 15:30:00	sunday
6667	30	2021-01-21 14:45:00	thursday
6668	6	2021-01-26 13:45:00	tuesday
6669	13	2021-01-03 12:15:00	sunday
6670	16	2021-01-24 11:30:00	sunday
6671	15	2021-01-19 08:30:00	tuesday
6672	37	2021-01-18 15:15:00	monday
6673	3	2021-01-10 10:45:00	sunday
6674	18	2021-01-03 15:30:00	sunday
6675	34	2021-01-18 11:00:00	monday
6676	12	2021-01-07 09:30:00	thursday
6677	1	2021-01-28 08:45:00	thursday
6678	13	2021-01-21 08:30:00	thursday
6679	4	2021-01-09 15:15:00	saturday
6680	23	2021-01-20 14:15:00	wednesday
6681	34	2021-01-19 14:00:00	tuesday
6682	13	2021-01-01 15:00:00	friday
6683	29	2021-01-12 12:00:00	tuesday
6684	30	2021-01-04 15:45:00	monday
6685	32	2021-01-22 14:45:00	friday
6686	12	2021-01-08 17:45:00	friday
6687	9	2021-01-07 13:45:00	thursday
6688	38	2021-01-20 10:30:00	wednesday
6689	38	2021-01-24 12:30:00	sunday
6690	4	2021-01-17 16:45:00	sunday
6691	25	2021-01-10 17:00:00	sunday
6692	33	2021-01-29 14:45:00	friday
6693	30	2021-01-06 15:00:00	wednesday
6694	23	2021-01-08 17:45:00	friday
6695	2	2021-01-06 13:15:00	wednesday
6696	33	2021-01-30 14:00:00	saturday
6697	11	2021-01-04 15:30:00	monday
6698	18	2021-01-23 14:15:00	saturday
6699	12	2021-01-30 09:00:00	saturday
6700	8	2021-01-26 13:00:00	tuesday
6701	31	2021-01-15 09:30:00	friday
6702	21	2021-01-13 17:15:00	wednesday
6703	2	2021-01-25 09:45:00	monday
6704	26	2021-01-09 12:15:00	saturday
6705	13	2021-01-15 09:15:00	friday
6706	3	2021-02-11 10:15:00	thursday
6707	32	2021-02-23 11:45:00	tuesday
6708	16	2021-02-28 08:30:00	sunday
6709	15	2021-02-02 08:45:00	tuesday
6710	15	2021-02-27 09:15:00	saturday
6711	39	2021-02-23 13:45:00	tuesday
6712	5	2021-02-14 11:45:00	sunday
6713	16	2021-02-22 10:00:00	monday
6714	12	2021-02-25 09:15:00	thursday
6715	18	2021-02-19 15:15:00	friday
6716	19	2021-02-20 15:00:00	saturday
6717	34	2021-02-08 12:30:00	monday
6718	27	2021-02-17 15:15:00	wednesday
6719	12	2021-02-03 08:45:00	wednesday
6720	6	2021-02-03 10:45:00	wednesday
6721	39	2021-02-21 14:45:00	sunday
6722	8	2021-02-11 11:00:00	thursday
6723	6	2021-02-03 09:45:00	wednesday
6724	32	2021-02-22 14:15:00	monday
6725	35	2021-02-24 12:00:00	wednesday
6726	37	2021-02-08 16:15:00	monday
6727	4	2021-02-13 13:45:00	saturday
6728	10	2021-02-03 17:30:00	wednesday
6729	8	2021-02-03 12:30:00	wednesday
6730	4	2021-02-01 08:15:00	monday
6731	16	2021-02-24 17:00:00	wednesday
6732	8	2021-02-25 14:00:00	thursday
6733	16	2021-02-06 09:45:00	saturday
6734	16	2021-02-14 11:00:00	sunday
6735	21	2021-02-09 12:15:00	tuesday
6736	20	2021-02-05 13:30:00	friday
6737	38	2021-02-13 13:00:00	saturday
6738	19	2021-02-23 09:00:00	tuesday
6739	28	2021-02-21 08:30:00	sunday
6740	25	2021-02-25 12:00:00	thursday
6741	28	2021-02-13 17:15:00	saturday
6742	8	2021-02-10 09:45:00	wednesday
6743	1	2021-02-20 11:00:00	saturday
6744	25	2021-02-07 14:30:00	sunday
6745	28	2021-02-02 13:15:00	tuesday
6746	1	2021-02-25 15:30:00	thursday
6747	30	2021-02-03 09:30:00	wednesday
6748	7	2021-02-14 17:30:00	sunday
6749	2	2021-02-21 08:45:00	sunday
6750	18	2021-02-27 12:30:00	saturday
6751	13	2021-02-18 14:30:00	thursday
6752	4	2021-02-28 14:45:00	sunday
6753	8	2021-02-27 09:15:00	saturday
6754	27	2021-02-20 12:30:00	saturday
6755	2	2021-02-09 14:15:00	tuesday
6756	13	2021-02-27 09:45:00	saturday
6757	23	2021-02-23 15:15:00	tuesday
6758	33	2021-02-27 10:30:00	saturday
6759	6	2021-02-02 08:45:00	tuesday
6760	26	2021-02-20 17:00:00	saturday
6761	28	2021-02-23 15:45:00	tuesday
6762	21	2021-02-22 15:00:00	monday
6763	35	2021-02-12 09:45:00	friday
6764	7	2021-02-14 12:00:00	sunday
6765	39	2021-02-03 12:00:00	wednesday
6766	17	2021-02-13 14:45:00	saturday
6767	6	2021-02-16 16:30:00	tuesday
6768	30	2021-03-29 11:15:00	monday
6769	29	2021-03-29 15:00:00	monday
6770	1	2021-03-08 10:45:00	monday
6771	39	2021-03-01 15:30:00	monday
6772	34	2021-03-26 08:45:00	friday
6773	15	2021-03-28 11:45:00	sunday
6774	7	2021-03-13 13:00:00	saturday
6775	34	2021-03-29 10:00:00	monday
6776	36	2021-03-19 16:15:00	friday
6777	23	2021-03-04 10:30:00	thursday
6778	13	2021-03-01 16:30:00	monday
6779	24	2021-03-09 08:00:00	tuesday
6780	33	2021-03-25 15:30:00	thursday
6781	9	2021-03-04 17:15:00	thursday
6782	38	2021-03-04 17:15:00	thursday
6783	37	2021-03-15 13:15:00	monday
6784	17	2021-03-04 09:00:00	thursday
6785	22	2021-03-05 09:45:00	friday
6786	13	2021-03-21 08:00:00	sunday
6787	4	2021-03-03 08:45:00	wednesday
6788	8	2021-03-25 09:00:00	thursday
6789	10	2021-03-11 11:45:00	thursday
6790	3	2021-03-20 15:45:00	saturday
6791	21	2021-03-13 11:15:00	saturday
6792	32	2021-03-20 09:45:00	saturday
6793	6	2021-03-07 12:45:00	sunday
6794	20	2021-03-27 08:30:00	saturday
6795	5	2021-03-18 14:30:00	thursday
6796	4	2021-03-04 17:30:00	thursday
6797	13	2021-03-26 13:00:00	friday
6798	25	2021-03-16 17:30:00	tuesday
6799	13	2021-03-08 16:00:00	monday
6800	38	2021-03-23 08:15:00	tuesday
6801	19	2021-03-01 09:30:00	monday
6802	14	2021-03-22 17:00:00	monday
6803	8	2021-03-02 15:45:00	tuesday
6804	32	2021-03-12 11:15:00	friday
6805	8	2021-03-19 17:30:00	friday
6806	5	2021-03-24 15:30:00	wednesday
6807	1	2021-03-19 11:45:00	friday
6808	38	2021-03-17 13:15:00	wednesday
6809	24	2021-03-03 09:00:00	wednesday
6810	40	2021-03-10 17:00:00	wednesday
6811	1	2021-03-10 13:45:00	wednesday
6812	17	2021-03-29 10:00:00	monday
6813	30	2021-03-18 08:00:00	thursday
6814	2	2021-03-24 17:45:00	wednesday
6815	4	2021-03-05 10:15:00	friday
6816	28	2021-03-24 11:45:00	wednesday
6817	35	2021-03-18 08:45:00	thursday
6818	37	2021-03-23 08:45:00	tuesday
6819	28	2021-03-30 12:30:00	tuesday
6820	2	2021-03-13 13:15:00	saturday
6821	10	2021-03-22 15:30:00	monday
6822	12	2021-03-16 15:15:00	tuesday
6823	28	2021-03-25 14:00:00	thursday
6824	13	2021-03-20 15:30:00	saturday
6825	23	2021-03-12 08:30:00	friday
6826	1	2021-03-07 17:45:00	sunday
6827	13	2021-03-21 11:30:00	sunday
6828	16	2021-03-05 08:30:00	friday
6829	18	2021-04-10 08:45:00	saturday
6830	8	2021-04-18 11:45:00	sunday
6831	11	2021-04-30 13:30:00	friday
6832	36	2021-04-17 16:30:00	saturday
6833	15	2021-04-18 12:30:00	sunday
6834	33	2021-04-26 11:15:00	monday
6835	16	2021-04-19 15:45:00	monday
6836	38	2021-04-25 12:30:00	sunday
6837	24	2021-04-04 09:00:00	sunday
6838	9	2021-04-16 13:30:00	friday
6839	30	2021-04-25 09:00:00	sunday
6840	38	2021-04-27 17:30:00	tuesday
6841	16	2021-04-28 17:00:00	wednesday
6842	25	2021-04-26 10:15:00	monday
6843	24	2021-04-03 12:45:00	saturday
6844	32	2021-04-04 16:45:00	sunday
6845	34	2021-04-28 13:00:00	wednesday
6846	35	2021-04-14 17:45:00	wednesday
6847	33	2021-04-05 17:15:00	monday
6848	30	2021-04-05 15:30:00	monday
6849	39	2021-04-13 09:45:00	tuesday
6850	36	2021-04-21 11:15:00	wednesday
6851	27	2021-04-12 14:15:00	monday
6852	11	2021-04-30 14:15:00	friday
6853	10	2021-04-05 08:30:00	monday
6854	11	2021-04-24 13:45:00	saturday
6855	8	2021-04-13 15:45:00	tuesday
6856	24	2021-04-23 12:15:00	friday
6857	14	2021-04-08 14:15:00	thursday
6858	6	2021-04-01 15:00:00	thursday
6859	35	2021-04-17 10:00:00	saturday
6860	18	2021-04-17 14:45:00	saturday
6861	29	2021-04-01 12:15:00	thursday
6862	21	2021-04-18 16:30:00	sunday
6863	7	2021-04-24 12:00:00	saturday
6864	1	2021-04-24 10:45:00	saturday
6865	34	2021-04-26 16:45:00	monday
6866	35	2021-04-06 10:00:00	tuesday
6867	38	2021-04-30 08:15:00	friday
6868	33	2021-04-16 15:15:00	friday
6869	15	2021-04-18 10:45:00	sunday
6870	36	2021-04-17 16:30:00	saturday
6871	10	2021-04-24 09:45:00	saturday
6872	28	2021-04-28 09:45:00	wednesday
6873	15	2021-04-02 14:00:00	friday
6874	32	2021-04-21 08:45:00	wednesday
6875	6	2021-04-01 10:00:00	thursday
6876	13	2021-04-29 11:00:00	thursday
6877	12	2021-04-03 12:15:00	saturday
6878	12	2021-04-23 08:15:00	friday
6879	29	2021-04-22 10:15:00	thursday
6880	14	2021-05-06 13:45:00	thursday
6881	25	2021-05-27 17:45:00	thursday
6882	1	2021-05-19 10:30:00	wednesday
6883	16	2021-05-19 15:00:00	wednesday
6884	18	2021-05-05 13:15:00	wednesday
6885	24	2021-05-08 14:45:00	saturday
6886	25	2021-05-19 13:00:00	wednesday
6887	35	2021-05-22 09:45:00	saturday
6888	2	2021-05-26 16:15:00	wednesday
6889	11	2021-05-10 11:15:00	monday
6890	40	2021-05-24 11:45:00	monday
6891	1	2021-05-13 14:00:00	thursday
6892	2	2021-05-29 12:00:00	saturday
6893	22	2021-05-06 10:30:00	thursday
6894	40	2021-05-17 15:00:00	monday
6895	10	2021-05-13 16:45:00	thursday
6896	13	2021-05-08 09:00:00	saturday
6897	19	2021-05-14 16:30:00	friday
6898	20	2021-05-17 10:00:00	monday
6899	35	2021-05-09 17:00:00	sunday
6900	4	2021-05-13 10:00:00	thursday
6901	12	2021-05-29 10:00:00	saturday
6902	29	2021-05-20 16:30:00	thursday
6903	5	2021-05-07 12:45:00	friday
6904	18	2021-05-12 11:00:00	wednesday
6905	12	2021-05-14 17:00:00	friday
6906	38	2021-05-28 17:15:00	friday
6907	26	2021-05-25 10:45:00	tuesday
6908	33	2021-05-21 12:45:00	friday
6909	20	2021-05-16 16:15:00	sunday
6910	11	2021-05-20 09:45:00	thursday
6911	39	2021-05-23 12:45:00	sunday
6912	21	2021-05-30 16:15:00	sunday
6913	17	2021-05-03 09:45:00	monday
6914	20	2021-05-17 10:45:00	monday
6915	28	2021-05-28 13:45:00	friday
6916	39	2021-05-23 12:15:00	sunday
6917	20	2021-05-05 09:15:00	wednesday
6918	22	2021-05-18 09:00:00	tuesday
6919	13	2021-05-02 16:45:00	sunday
6920	27	2021-05-24 16:15:00	monday
6921	8	2021-05-10 14:30:00	monday
6922	2	2021-05-28 12:00:00	friday
6923	12	2021-05-15 17:45:00	saturday
6924	26	2021-05-07 15:30:00	friday
6925	14	2021-05-25 11:30:00	tuesday
6926	26	2021-05-27 14:15:00	thursday
6927	35	2021-05-07 16:00:00	friday
6928	15	2021-05-22 10:00:00	saturday
6929	35	2021-05-09 10:30:00	sunday
6930	26	2021-05-16 16:00:00	sunday
6931	6	2021-05-05 13:30:00	wednesday
6932	20	2021-05-11 10:30:00	tuesday
6933	24	2021-05-17 10:45:00	monday
6934	20	2021-06-11 13:30:00	friday
6935	30	2021-06-29 15:30:00	tuesday
6936	37	2021-06-26 09:00:00	saturday
6937	15	2021-06-01 13:00:00	tuesday
6938	3	2021-06-29 12:45:00	tuesday
6939	21	2021-06-22 11:00:00	tuesday
6940	4	2021-06-01 11:15:00	tuesday
6941	4	2021-06-12 13:00:00	saturday
6942	32	2021-06-28 13:45:00	monday
6943	40	2021-06-21 11:45:00	monday
6944	10	2021-06-08 14:30:00	tuesday
6945	40	2021-06-20 16:00:00	sunday
6946	14	2021-06-28 12:30:00	monday
6947	31	2021-06-09 09:30:00	wednesday
6948	27	2021-06-11 16:45:00	friday
6949	23	2021-06-23 14:15:00	wednesday
6950	33	2021-06-18 16:30:00	friday
6951	29	2021-06-28 10:00:00	monday
6952	9	2021-06-10 13:45:00	thursday
6953	2	2021-06-07 12:30:00	monday
6954	9	2021-06-21 15:15:00	monday
6955	30	2021-06-18 12:30:00	friday
6956	7	2021-06-01 16:45:00	tuesday
6957	29	2021-06-05 11:45:00	saturday
6958	11	2021-06-15 08:00:00	tuesday
6959	35	2021-06-23 15:30:00	wednesday
6960	7	2021-06-02 12:15:00	wednesday
6961	25	2021-06-04 13:45:00	friday
6962	8	2021-06-02 10:45:00	wednesday
6963	23	2021-06-04 15:30:00	friday
6964	28	2021-06-02 12:15:00	wednesday
6965	34	2021-06-25 10:45:00	friday
6966	3	2021-06-15 10:00:00	tuesday
6967	5	2021-06-27 11:45:00	sunday
6968	31	2021-06-03 12:15:00	thursday
6969	17	2021-06-16 09:15:00	wednesday
6970	14	2021-06-14 16:30:00	monday
6971	7	2021-06-19 13:30:00	saturday
6972	4	2021-06-27 12:15:00	sunday
6973	25	2021-06-16 15:30:00	wednesday
6974	12	2021-06-02 17:00:00	wednesday
6975	23	2021-06-07 08:45:00	monday
6976	6	2021-07-14 10:00:00	wednesday
6977	22	2021-07-01 17:30:00	thursday
6978	23	2021-07-07 11:45:00	wednesday
6979	16	2021-07-20 13:00:00	tuesday
6980	38	2021-07-30 17:15:00	friday
6981	8	2021-07-09 14:45:00	friday
6982	34	2021-07-30 09:00:00	friday
6983	36	2021-07-16 08:15:00	friday
6984	23	2021-07-11 12:00:00	sunday
6985	35	2021-07-15 09:30:00	thursday
6986	24	2021-07-26 09:00:00	monday
6987	7	2021-07-02 10:15:00	friday
6988	35	2021-07-26 08:45:00	monday
6989	2	2021-07-16 11:30:00	friday
6990	34	2021-07-27 15:15:00	tuesday
6991	18	2021-07-19 16:30:00	monday
6992	14	2021-07-01 08:15:00	thursday
6993	22	2021-07-25 17:30:00	sunday
6994	36	2021-07-25 17:00:00	sunday
6995	32	2021-07-12 12:00:00	monday
6996	17	2021-07-09 11:00:00	friday
6997	10	2021-07-06 14:45:00	tuesday
6998	15	2021-07-14 13:15:00	wednesday
6999	3	2021-07-29 10:45:00	thursday
7000	40	2021-07-22 11:00:00	thursday
7001	17	2021-07-10 08:15:00	saturday
7002	7	2021-07-16 10:15:00	friday
7003	6	2021-07-11 14:45:00	sunday
7004	12	2021-07-07 12:45:00	wednesday
7005	38	2021-07-27 15:30:00	tuesday
7006	38	2021-07-14 15:00:00	wednesday
7007	36	2021-07-08 11:45:00	thursday
7008	16	2021-07-04 16:45:00	sunday
7009	10	2021-07-23 09:00:00	friday
7010	30	2021-07-23 08:15:00	friday
7011	15	2021-07-10 14:00:00	saturday
7012	7	2021-07-23 16:00:00	friday
7013	16	2021-07-26 14:00:00	monday
7014	26	2021-08-19 11:15:00	thursday
7015	33	2021-08-23 10:45:00	monday
7016	18	2021-08-10 11:00:00	tuesday
7017	35	2021-08-15 12:30:00	sunday
7018	4	2021-08-27 12:30:00	friday
7019	6	2021-08-22 08:00:00	sunday
7020	38	2021-08-25 12:00:00	wednesday
7021	37	2021-08-09 13:45:00	monday
7022	31	2021-08-24 17:30:00	tuesday
7023	31	2021-08-27 14:00:00	friday
7024	27	2021-08-02 09:15:00	monday
7025	17	2021-08-03 11:45:00	tuesday
7026	6	2021-08-06 17:15:00	friday
7027	6	2021-08-10 08:15:00	tuesday
7028	6	2021-08-04 12:00:00	wednesday
7029	17	2021-08-01 13:30:00	sunday
7030	26	2021-08-25 09:15:00	wednesday
7031	23	2021-08-05 08:45:00	thursday
7032	39	2021-08-15 15:00:00	sunday
7033	16	2021-08-10 11:00:00	tuesday
7034	39	2021-08-11 17:45:00	wednesday
7035	21	2021-08-03 09:45:00	tuesday
7036	18	2021-08-04 10:00:00	wednesday
7037	24	2021-08-21 16:30:00	saturday
7038	15	2021-08-16 09:30:00	monday
7039	40	2021-08-19 13:00:00	thursday
7040	17	2021-08-01 11:15:00	sunday
7041	36	2021-08-20 11:15:00	friday
7042	4	2021-08-17 10:30:00	tuesday
7043	5	2021-08-02 12:00:00	monday
7044	38	2021-08-25 09:00:00	wednesday
7045	22	2021-08-26 08:00:00	thursday
7046	8	2021-08-30 11:00:00	monday
7047	13	2021-08-30 16:15:00	monday
7048	5	2021-08-20 08:45:00	friday
7049	33	2021-08-21 11:00:00	saturday
7050	32	2021-08-30 09:30:00	monday
7051	11	2021-08-04 11:45:00	wednesday
7052	39	2021-08-01 14:45:00	sunday
7053	15	2021-08-04 14:15:00	wednesday
7054	4	2021-08-25 17:30:00	wednesday
7055	10	2021-08-04 12:30:00	wednesday
7056	23	2021-08-12 10:15:00	thursday
7057	3	2021-08-26 09:30:00	thursday
7058	31	2021-09-27 11:15:00	monday
7059	27	2021-09-13 09:00:00	monday
7060	16	2021-09-04 08:45:00	saturday
7061	7	2021-09-25 17:00:00	saturday
7062	4	2021-09-06 08:00:00	monday
7063	34	2021-09-30 16:30:00	thursday
7064	36	2021-09-07 17:45:00	tuesday
7065	14	2021-09-18 16:45:00	saturday
7066	38	2021-09-23 12:30:00	thursday
7067	34	2021-09-02 10:30:00	thursday
7068	38	2021-09-20 17:30:00	monday
7069	26	2021-09-12 17:15:00	sunday
7070	38	2021-09-01 12:45:00	wednesday
7071	35	2021-09-21 16:00:00	tuesday
7072	8	2021-09-15 09:30:00	wednesday
7073	29	2021-09-20 12:00:00	monday
7074	32	2021-09-10 08:00:00	friday
7075	17	2021-09-19 08:00:00	sunday
7076	20	2021-09-11 15:00:00	saturday
7077	11	2021-09-04 08:15:00	saturday
7078	5	2021-09-12 10:00:00	sunday
7079	31	2021-09-22 17:15:00	wednesday
7080	38	2021-09-09 10:15:00	thursday
7081	22	2021-09-08 13:00:00	wednesday
7082	25	2021-09-20 12:00:00	monday
7083	31	2021-09-29 16:45:00	wednesday
7084	23	2021-09-15 16:30:00	wednesday
7085	16	2021-09-22 13:45:00	wednesday
7086	38	2021-09-07 15:45:00	tuesday
7087	12	2021-09-18 12:15:00	saturday
7088	26	2021-09-25 10:30:00	saturday
7089	11	2021-09-05 14:15:00	sunday
7090	22	2021-09-03 09:00:00	friday
7091	7	2021-09-14 14:45:00	tuesday
7092	18	2021-09-23 08:30:00	thursday
7093	11	2021-09-29 14:15:00	wednesday
7094	36	2021-09-22 11:45:00	wednesday
7095	20	2021-09-14 14:15:00	tuesday
7096	16	2021-09-28 14:00:00	tuesday
7097	33	2021-09-24 08:30:00	friday
7098	27	2021-09-25 13:15:00	saturday
7099	13	2021-09-05 17:45:00	sunday
7100	25	2021-09-17 17:00:00	friday
7101	33	2021-09-15 13:30:00	wednesday
7102	12	2021-09-07 14:30:00	tuesday
7103	20	2021-09-21 11:15:00	tuesday
7104	37	2021-09-18 11:45:00	saturday
7105	21	2021-09-08 15:45:00	wednesday
7106	34	2021-09-04 17:45:00	saturday
7107	36	2021-09-20 08:30:00	monday
7108	33	2021-09-22 16:30:00	wednesday
7109	6	2021-09-06 17:45:00	monday
7110	33	2021-09-23 09:30:00	thursday
7111	8	2021-09-03 17:15:00	friday
7112	5	2021-09-13 15:15:00	monday
7113	25	2021-09-29 11:00:00	wednesday
7114	33	2021-10-28 10:45:00	thursday
7115	34	2021-10-15 15:00:00	friday
7116	5	2021-10-28 17:15:00	thursday
7117	15	2021-10-05 13:15:00	tuesday
7118	39	2021-10-02 15:30:00	saturday
7119	36	2021-10-01 14:45:00	friday
7120	3	2021-10-24 14:00:00	sunday
7121	18	2021-10-23 10:45:00	saturday
7122	36	2021-10-20 08:45:00	wednesday
7123	17	2021-10-23 08:00:00	saturday
7124	17	2021-10-16 17:30:00	saturday
7125	14	2021-10-07 17:15:00	thursday
7126	3	2021-10-29 13:30:00	friday
7127	36	2021-10-11 10:00:00	monday
7128	27	2021-10-09 11:45:00	saturday
7129	28	2021-10-19 17:45:00	tuesday
7130	14	2021-10-17 11:00:00	sunday
7131	31	2021-10-17 13:15:00	sunday
7132	18	2021-10-30 11:15:00	saturday
7133	39	2021-10-29 13:00:00	friday
7134	24	2021-10-22 09:00:00	friday
7135	4	2021-10-08 08:45:00	friday
7136	18	2021-10-11 13:30:00	monday
7137	35	2021-10-20 15:00:00	wednesday
7138	11	2021-10-29 16:15:00	friday
7139	38	2021-10-06 15:15:00	wednesday
7140	4	2021-10-29 09:30:00	friday
7141	32	2021-10-01 14:30:00	friday
7142	27	2021-10-25 15:00:00	monday
7143	31	2021-10-12 10:00:00	tuesday
7144	11	2021-10-17 09:15:00	sunday
7145	19	2021-10-27 14:00:00	wednesday
7146	40	2021-10-15 14:45:00	friday
7147	27	2021-10-07 16:15:00	thursday
7148	33	2021-10-28 09:45:00	thursday
7149	36	2021-10-10 16:15:00	sunday
7150	39	2021-10-25 16:45:00	monday
7151	27	2021-10-02 15:30:00	saturday
7152	18	2021-10-01 15:15:00	friday
7153	15	2021-10-27 14:30:00	wednesday
7154	24	2021-10-07 10:15:00	thursday
7155	10	2021-10-11 12:15:00	monday
7156	24	2021-10-25 16:45:00	monday
7157	15	2021-10-02 14:30:00	saturday
7158	32	2021-10-04 17:15:00	monday
7159	34	2021-10-28 09:45:00	thursday
7160	28	2021-10-26 15:15:00	tuesday
7161	21	2021-10-30 12:45:00	saturday
7162	40	2021-10-21 12:45:00	thursday
7163	15	2021-10-29 17:30:00	friday
7164	2	2021-10-24 13:45:00	sunday
7165	28	2021-10-17 16:15:00	sunday
7166	27	2021-10-09 08:15:00	saturday
7167	18	2021-10-01 16:30:00	friday
7168	12	2021-10-11 10:30:00	monday
7169	23	2021-10-20 17:45:00	wednesday
7170	3	2021-10-26 14:15:00	tuesday
7171	6	2021-11-17 11:45:00	wednesday
7172	37	2021-11-05 10:00:00	friday
7173	9	2021-11-10 08:45:00	wednesday
7174	3	2021-11-15 15:15:00	monday
7175	37	2021-11-01 09:00:00	monday
7176	39	2021-11-30 11:00:00	tuesday
7177	35	2021-11-02 17:30:00	tuesday
7178	13	2021-11-08 13:15:00	monday
7179	26	2021-11-13 12:15:00	saturday
7180	5	2021-11-16 08:00:00	tuesday
7181	40	2021-11-13 17:00:00	saturday
7182	13	2021-11-16 14:00:00	tuesday
7183	16	2021-11-01 08:45:00	monday
7184	32	2021-11-01 14:15:00	monday
7185	11	2021-11-19 14:00:00	friday
7186	3	2021-11-16 16:00:00	tuesday
7187	17	2021-11-28 09:30:00	sunday
7188	12	2021-11-23 10:15:00	tuesday
7189	38	2021-11-12 08:45:00	friday
7190	12	2021-11-29 09:00:00	monday
7191	15	2021-11-28 16:15:00	sunday
7192	36	2021-11-19 16:30:00	friday
7193	12	2021-11-06 12:15:00	saturday
7194	40	2021-11-24 15:00:00	wednesday
7195	38	2021-11-22 10:00:00	monday
7196	33	2021-11-10 14:30:00	wednesday
7197	39	2021-11-26 15:15:00	friday
7198	28	2021-11-11 08:45:00	thursday
7199	38	2021-11-07 14:15:00	sunday
7200	30	2021-11-23 11:15:00	tuesday
7201	10	2021-11-11 10:00:00	thursday
7202	1	2021-11-10 10:15:00	wednesday
7203	20	2021-11-30 09:45:00	tuesday
7204	37	2021-11-29 12:45:00	monday
7205	7	2021-11-12 14:15:00	friday
7206	18	2021-11-24 08:30:00	wednesday
7207	1	2021-11-01 12:00:00	monday
7208	18	2021-11-07 11:15:00	sunday
7209	33	2021-11-21 09:45:00	sunday
7210	17	2021-11-14 10:15:00	sunday
7211	9	2021-11-24 13:30:00	wednesday
7212	6	2021-11-10 09:00:00	wednesday
7213	10	2021-11-01 08:00:00	monday
7214	33	2021-11-24 08:15:00	wednesday
7215	4	2021-11-13 14:00:00	saturday
7216	29	2021-11-27 16:45:00	saturday
7217	13	2021-11-16 15:45:00	tuesday
7218	37	2021-11-02 14:00:00	tuesday
7219	7	2021-11-05 14:15:00	friday
7220	24	2021-11-20 16:45:00	saturday
7221	28	2021-11-04 13:45:00	thursday
7222	14	2021-11-27 14:45:00	saturday
7223	3	2021-11-22 14:00:00	monday
7224	2	2021-11-19 14:00:00	friday
7225	26	2021-11-07 10:15:00	sunday
7226	15	2021-11-06 15:30:00	saturday
7227	27	2021-11-05 16:15:00	friday
7228	5	2021-11-16 11:15:00	tuesday
7229	9	2021-11-11 16:30:00	thursday
7230	36	2021-11-03 12:45:00	wednesday
7231	18	2021-11-21 17:00:00	sunday
7232	13	2021-11-18 09:15:00	thursday
7233	12	2021-11-28 17:15:00	sunday
7234	38	2021-11-08 15:00:00	monday
7235	1	2021-11-01 11:45:00	monday
7236	12	2021-11-14 11:00:00	sunday
7237	29	2021-11-12 17:45:00	friday
7238	15	2021-11-25 13:30:00	thursday
7239	4	2021-11-09 13:00:00	tuesday
7240	3	2021-12-30 17:45:00	thursday
7241	38	2021-12-28 10:00:00	tuesday
7242	11	2021-12-04 12:30:00	saturday
7243	29	2021-12-04 13:00:00	saturday
7244	6	2021-12-19 13:00:00	sunday
7245	35	2021-12-16 14:15:00	thursday
7246	36	2021-12-04 12:45:00	saturday
7247	15	2021-12-14 11:45:00	tuesday
7248	24	2021-12-08 08:45:00	wednesday
7249	30	2021-12-30 17:15:00	thursday
7250	20	2021-12-23 13:45:00	thursday
7251	27	2021-12-27 08:30:00	monday
7252	1	2021-12-13 11:15:00	monday
7253	25	2021-12-13 12:45:00	monday
7254	39	2021-12-06 16:15:00	monday
7255	21	2021-12-25 12:30:00	saturday
7256	14	2021-12-10 12:30:00	friday
7257	14	2021-12-11 08:00:00	saturday
7258	21	2021-12-09 15:45:00	thursday
7259	7	2021-12-24 10:30:00	friday
7260	1	2021-12-17 11:30:00	friday
7261	25	2021-12-09 13:15:00	thursday
7262	10	2021-12-14 09:15:00	tuesday
7263	27	2021-12-14 17:45:00	tuesday
7264	19	2021-12-13 12:00:00	monday
7265	12	2021-12-16 13:30:00	thursday
7266	33	2021-12-21 08:00:00	tuesday
7267	29	2021-12-17 16:15:00	friday
7268	1	2021-12-07 08:15:00	tuesday
7269	25	2021-12-15 16:30:00	wednesday
7270	19	2021-12-29 11:45:00	wednesday
7271	5	2021-12-24 13:15:00	friday
7272	27	2021-12-01 08:00:00	wednesday
7273	2	2021-12-20 14:30:00	monday
7274	36	2021-12-01 15:45:00	wednesday
7275	24	2021-12-30 13:45:00	thursday
7276	13	2021-12-02 13:30:00	thursday
7277	3	2021-12-29 16:00:00	wednesday
7278	30	2021-12-15 11:30:00	wednesday
7279	7	2021-12-25 11:30:00	saturday
7280	17	2021-12-28 17:30:00	tuesday
7281	21	2021-12-24 09:15:00	friday
7282	19	2021-12-04 17:15:00	saturday
7283	38	2021-12-11 16:15:00	saturday
7284	2	2021-12-26 12:00:00	sunday
7285	20	2021-12-14 11:30:00	tuesday
7286	22	2021-12-11 08:45:00	saturday
7287	13	2021-12-06 15:30:00	monday
7288	25	2021-12-22 08:15:00	wednesday
7289	17	2021-12-01 12:15:00	wednesday
7290	9	2021-12-12 10:00:00	sunday
7291	17	2021-12-13 08:00:00	monday
7292	19	2021-12-29 14:30:00	wednesday
7293	32	2021-12-13 15:00:00	monday
7294	39	2021-12-03 16:30:00	friday
7295	3	2021-12-12 13:15:00	sunday
7296	32	2021-12-17 17:30:00	friday
7297	18	2021-12-02 15:00:00	thursday
7298	26	2021-12-12 16:15:00	sunday
7299	38	2021-12-01 16:45:00	wednesday
7300	20	2021-12-05 08:15:00	sunday
\.


--
-- Data for Name: parent; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.parent (student_id, first_name, last_name, person_number, street, city, zip_code, telefon_number, email_address) FROM stdin;
\.


--
-- Data for Name: siblings; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.siblings (id, student_id, sibling_id) FROM stdin;
\.


--
-- Data for Name: stock; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.stock (instrument_id, amount, instrument_rental_fee, rented_instruments) FROM stdin;
2	52	300	25
3	87	418	86
4	82	218	54
5	76	425	42
6	40	306	22
8	78	201	49
10	10	240	10
9	34	110	22
1	29	292	12
7	15	202	14
\.


--
-- Data for Name: student; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student (id, first_name, last_name, person_number, age, skill_level, street, city, zip_code, instrument_kind) FROM stdin;
1	Tuva	Carlsson	8107105655	49	advanced	Liljerum Grenadjärtorpet 54	Sodertalje	12345	Piano
2	Jonathan 	Nyberg	6405261618	56	beginner	Sandviken 23	Hallunda	12343	Violin
3	Kaspar	Jonasson	7010279516	50	intermediate	Skärpinge 25	Stockholm	21352	Piano
4	Matilde	Jansson	9503281827	25	intermediate	Liljerum Grenadjärtorpet 27	Stockholm	23546	Drums
5	Wictor	Nyman	9107253032	29	beginner	Sandviken 56	Nacka	54634	Violin
6	Wilmer	Nordin	8911176512	31	advanced	Liljerum Grenadjärtorpet 34	Nacka	23562	Trumpet
7	Mostafa	Andersson	6503177096	55	intermediate	AddressValue 75	Tumba	67743	Drums
8	Sabrina	Petersson	8012130541	40	beginner	Sandviken 35	Sodertalje	41655	Piano
9	Adis	Löfgren	6501288739	55	advanced	Liljerum Grenadjärtorpet 65	Hallunda	63426	Violin
10	Nova	Nordin	9411144760	26	intermediate	Skärpinge 44	Stockholm	75534	Trumpet
11	Sonia	Magnusson	6305241868	57	beginner	Sandviken 33	Nacka	46325	Clarinet
12	Madeleine	Ekström	6511196468	56	intermediate	Liljerum Grenadjärtorpet 22	Tumba	23595	Saxophone
13	Denis	Jakobsson	9706255834	23	beginner	Hammarvägen 11	Hallunda	12634	Trumpet
14	Nilas	Larsson	8110038430	39	advanced	Skärpinge 66	Sodertalje	83656	Saxophone
15	Marika	Magnusson	6406118304	56	advanced	Sandviken 78	Stockholm	75343	Clarinet
16	Livias	Berggren	8808061520	32	beginner	Liljerum Grenadjärtorpet 87	Nacka	12575	Violin
17	Johan	Fransson	7706272692	43	intermediate	Skärpinge 98	Tumba	86432	Saxophone
18	Elmer	Nyberg	6803200499	52	beginner	Lillesäter 78	Hallunda	64242	Drums
19	Selina	Fransson	8002182742	40	beginner	Sandviken 67	Stockholm	78534	Trumpet
20	Marika	Martinsson	5812066909	62	beginner	Liljerum Grenadjärtorpet 56	Sodertalje	37354	Saxophone
21	Christofer	Berglund	7108242723	49	advanced	Skärpinge 45	Nacka	56736	Drums
22	Daniela	Larsson	8706292391	33	intermediate	Sandviken 34	Stockholm	84543	Violin
23	Sophia	Ström	8804033291	32	beginner	Liljerum Grenadjärtorpet 31	Hallunda	36425	Piano
24	Maya	Persson	8310272664	37	advanced	Hammarvägen 42	Stockholm	32643	Violin
25	Elvin	Karlsson	5912254454	61	intermediate	AddressValue 53	Tumba	56876	Saxophone
26	Ali	Sundberg	5709187974	63	beginner	Hammarvägen 64	Hallunda	43563	Piano
27	Sami	Eliasson	7109182795	49	intermediate	Liljerum Grenadjärtorpet 75	Nacka	46735	Trumpet
28	Elina	Månsson	7001068720	50	beginner	Lillesäter 86	Tumba	68455	Piano
29	Wilma	Dahlberg	9208309907	28	advanced	Sandviken 97	Stockholm	34256	Saxophone
30	Zandra	Samuelsson	7903274806	41	beginner	Liljerum Grenadjärtorpet 79	Hallunda	84343	Piano
\.


--
-- Data for Name: student_application; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_application (id, student_id, enrollment_date) FROM stdin;
\.


--
-- Data for Name: student_contact_info; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_contact_info (student_id, telefon_number, email_address) FROM stdin;
\.


--
-- Data for Name: student_payment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.student_payment (id, student_id, individual_lessons_amount, advanced_lessons_amount, ensembles_amount, group_lessons_amount, weekend_lessons_amount, payment_date) FROM stdin;
\.


--
-- Name: adminstrator_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.adminstrator_id_seq', 2, true);


--
-- Name: ensemble_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ensemble_id_seq', 40, true);


--
-- Name: ensmeble_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.ensmeble_schedule_id_seq', 5550, true);


--
-- Name: instructor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instructor_id_seq', 15, true);


--
-- Name: instrument_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_id_seq', 10, true);


--
-- Name: instrument_rental_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.instrument_rental_id_seq', 432, true);


--
-- Name: lesson_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_id_seq', 40, true);


--
-- Name: lesson_price_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_price_id_seq', 1, false);


--
-- Name: lesson_schedule_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.lesson_schedule_id_seq', 7300, true);


--
-- Name: student_application_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_application_id_seq', 1, false);


--
-- Name: student_payment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_payment_id_seq', 1, false);


--
-- Name: student_student_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_student_id_seq', 30, true);


--
-- Name: adminstrator adminstrator_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adminstrator
    ADD CONSTRAINT adminstrator_pkey PRIMARY KEY (id);


--
-- Name: audition audition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audition
    ADD CONSTRAINT audition_pkey PRIMARY KEY (id);


--
-- Name: ensemble ensemble_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble
    ADD CONSTRAINT ensemble_pkey PRIMARY KEY (id);


--
-- Name: ensemble_schedule ensmeble_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble_schedule
    ADD CONSTRAINT ensmeble_schedule_pkey PRIMARY KEY (id);


--
-- Name: instructor instructor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor
    ADD CONSTRAINT instructor_pkey PRIMARY KEY (id);


--
-- Name: instrument instrument_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument
    ADD CONSTRAINT instrument_pkey PRIMARY KEY (id);


--
-- Name: instrument_rental instrument_rental_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental
    ADD CONSTRAINT instrument_rental_pkey PRIMARY KEY (id);


--
-- Name: lesson lesson_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_pkey PRIMARY KEY (id);


--
-- Name: lesson_price lesson_price_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_price
    ADD CONSTRAINT lesson_price_pkey PRIMARY KEY (id);


--
-- Name: lesson_schedule lesson_schedule_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_schedule
    ADD CONSTRAINT lesson_schedule_pkey PRIMARY KEY (id);


--
-- Name: siblings siblings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siblings
    ADD CONSTRAINT siblings_pkey PRIMARY KEY (id);


--
-- Name: stock stock_instrument_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_instrument_id_key UNIQUE (instrument_id);


--
-- Name: student student_age_check; Type: CHECK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE public.student
    ADD CONSTRAINT student_age_check CHECK ((age > 14)) NOT VALID;


--
-- Name: student_application student_application_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_application
    ADD CONSTRAINT student_application_pkey PRIMARY KEY (id);


--
-- Name: student_contact_info student_contact_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_contact_info
    ADD CONSTRAINT student_contact_info_pkey PRIMARY KEY (student_id);


--
-- Name: student student_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_id_key UNIQUE (id);


--
-- Name: student_payment student_payment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_payment
    ADD CONSTRAINT student_payment_pkey PRIMARY KEY (id);


--
-- Name: student student_person_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_person_number_key UNIQUE (person_number);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (id);


--
-- Name: adminstrator_contact_info adminstrator_contact_info_adminstrator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.adminstrator_contact_info
    ADD CONSTRAINT adminstrator_contact_info_adminstrator_id_fkey FOREIGN KEY (adminstrator_id) REFERENCES public.adminstrator(id) ON DELETE CASCADE;


--
-- Name: audition audition_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audition
    ADD CONSTRAINT audition_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(id);


--
-- Name: audition audition_instrument_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audition
    ADD CONSTRAINT audition_instrument_id_fkey FOREIGN KEY (instrument_id) REFERENCES public.instrument(id);


--
-- Name: audition audition_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audition
    ADD CONSTRAINT audition_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- Name: ensemble ensemble_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble
    ADD CONSTRAINT ensemble_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(id) ON DELETE CASCADE;


--
-- Name: ensemble_schedule ensmeble_schedule_ensemble_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ensemble_schedule
    ADD CONSTRAINT ensmeble_schedule_ensemble_id_fkey FOREIGN KEY (ensemble_id) REFERENCES public.ensemble(id);


--
-- Name: instructor_contact_info instructor_contact_info_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_contact_info
    ADD CONSTRAINT instructor_contact_info_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(id) ON DELETE CASCADE;


--
-- Name: instructor_salary instructor_salary_ensemble_schedule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_salary
    ADD CONSTRAINT instructor_salary_ensemble_schedule_id_fkey FOREIGN KEY (ensemble_schedule_id) REFERENCES public.ensemble_schedule(id);


--
-- Name: instructor_salary instructor_salary_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_salary
    ADD CONSTRAINT instructor_salary_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(id);


--
-- Name: instructor_salary instructor_salary_lesson_schedule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructor_salary
    ADD CONSTRAINT instructor_salary_lesson_schedule_id_fkey FOREIGN KEY (lesson_schedule_id) REFERENCES public.lesson_schedule(id);


--
-- Name: instrument_rental instrument_rental_instrument_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental
    ADD CONSTRAINT instrument_rental_instrument_id_fkey FOREIGN KEY (instrument_id) REFERENCES public.instrument(id);


--
-- Name: instrument_rental instrument_rental_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instrument_rental
    ADD CONSTRAINT instrument_rental_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- Name: lesson lesson_instructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson
    ADD CONSTRAINT lesson_instructor_id_fkey FOREIGN KEY (instructor_id) REFERENCES public.instructor(id) NOT VALID;


--
-- Name: lesson_price lesson_price_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_price
    ADD CONSTRAINT lesson_price_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(id) NOT VALID;


--
-- Name: lesson_schedule lesson_schedule_lesson_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.lesson_schedule
    ADD CONSTRAINT lesson_schedule_lesson_id_fkey FOREIGN KEY (lesson_id) REFERENCES public.lesson(id) NOT VALID;


--
-- Name: parent parent_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.parent
    ADD CONSTRAINT parent_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id) ON DELETE CASCADE;


--
-- Name: siblings siblings_sibling_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siblings
    ADD CONSTRAINT siblings_sibling_id_fkey FOREIGN KEY (sibling_id) REFERENCES public.student(id);


--
-- Name: siblings siblings_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.siblings
    ADD CONSTRAINT siblings_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- Name: stock stock_instrument_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.stock
    ADD CONSTRAINT stock_instrument_id_fkey FOREIGN KEY (instrument_id) REFERENCES public.instrument(id);


--
-- Name: student_application student_application_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_application
    ADD CONSTRAINT student_application_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- Name: student_contact_info student_contact_info_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_contact_info
    ADD CONSTRAINT student_contact_info_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id) ON DELETE CASCADE NOT VALID;


--
-- Name: student_payment student_payment_student_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_payment
    ADD CONSTRAINT student_payment_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);


--
-- Name: instrument_lowest_monthly_fee; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.instrument_lowest_monthly_fee;


--
-- Name: next_week_ensembles_list; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: postgres
--

REFRESH MATERIALIZED VIEW public.next_week_ensembles_list;


--
-- PostgreSQL database dump complete
--

