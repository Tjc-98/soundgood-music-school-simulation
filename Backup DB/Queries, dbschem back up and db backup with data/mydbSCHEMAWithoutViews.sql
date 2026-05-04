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
-- Name: siblings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.siblings (
    id integer NOT NULL,
    student_id integer NOT NULL,
    sibling_id integer NOT NULL
);


ALTER TABLE public.siblings OWNER TO postgres;

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
-- PostgreSQL database dump complete
--

