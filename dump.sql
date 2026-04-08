--
-- PostgreSQL database dump
--

\restrict c4r1mkPvI4UPM5E5hxNn2SbsLjHWm56tCtOG41JzO5bDyHfTkOXlrAfVeNdoov8

-- Dumped from database version 18.2
-- Dumped by pg_dump version 18.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- Name: AppointmentStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."AppointmentStatus" AS ENUM (
    'SCHEDULED',
    'INPROGRESS',
    'COMPLETED',
    'CANCELED'
);


--
-- Name: BloodGroup; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."BloodGroup" AS ENUM (
    'A_POSITIVE',
    'B_POSITIVE',
    'O_POSITIVE',
    'AB_POSITIVE',
    'A_NEGATIVE',
    'B_NEGATIVE',
    'O_NEGATIVE',
    'AB_NEGATIVE'
);


--
-- Name: Gender; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."Gender" AS ENUM (
    'MALE',
    'FEMALE'
);


--
-- Name: MaritalStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."MaritalStatus" AS ENUM (
    'MARRIED',
    'UNMARRIED'
);


--
-- Name: PaymentStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."PaymentStatus" AS ENUM (
    'PAID',
    'UNPAID'
);


--
-- Name: UserRole; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."UserRole" AS ENUM (
    'SUPER_ADMIN',
    'ADMIN',
    'DOCTOR',
    'PATIENT'
);


--
-- Name: UserStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."UserStatus" AS ENUM (
    'ACTIVE',
    'BLOCKED',
    'DELETED'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- Name: admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.admins (
    id text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    "profilePhoto" text,
    "contactNumber" text NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: appointments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.appointments (
    id text NOT NULL,
    "patientId" text NOT NULL,
    "doctorId" text NOT NULL,
    "scheduleId" text NOT NULL,
    "videoCallingId" text NOT NULL,
    status public."AppointmentStatus" DEFAULT 'SCHEDULED'::public."AppointmentStatus" NOT NULL,
    "paymentStatus" public."PaymentStatus" DEFAULT 'UNPAID'::public."PaymentStatus" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: doctor_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.doctor_schedules (
    "doctorId" text NOT NULL,
    "scheduleId" text NOT NULL,
    "isBooked" boolean DEFAULT false NOT NULL,
    "appointmentId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: doctor_specialties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.doctor_specialties (
    "specialitiesId" text NOT NULL,
    "doctorId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: doctors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.doctors (
    id text NOT NULL,
    name text NOT NULL,
    email text NOT NULL,
    "profilePhoto" text,
    "contactNumber" text NOT NULL,
    address text,
    "registrationNumber" text NOT NULL,
    experience integer DEFAULT 0 NOT NULL,
    gender public."Gender" NOT NULL,
    "appointmentFee" integer NOT NULL,
    qualification text NOT NULL,
    "currentWorkingPlace" text NOT NULL,
    designation text NOT NULL,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "averageRating" double precision DEFAULT 0.0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: medical_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.medical_reports (
    id text NOT NULL,
    "patientId" text NOT NULL,
    "reportName" text NOT NULL,
    "reportLink" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: patient_health_datas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.patient_health_datas (
    id text NOT NULL,
    "patientId" text NOT NULL,
    gender public."Gender" NOT NULL,
    "dateOfBirth" text NOT NULL,
    "bloodGroup" public."BloodGroup" NOT NULL,
    "hasAllergies" boolean DEFAULT false,
    "hasDiabetes" boolean DEFAULT false,
    height text NOT NULL,
    weight text NOT NULL,
    "smokingStatus" boolean DEFAULT false,
    "dietaryPreferences" text,
    "pregnancyStatus" boolean DEFAULT false,
    "mentalHealthHistory" text,
    "immunizationStatus" text,
    "hasPastSurgeries" boolean DEFAULT false,
    "recentAnxiety" boolean DEFAULT false,
    "recentDepression" boolean DEFAULT false,
    "maritalStatus" public."MaritalStatus" DEFAULT 'UNMARRIED'::public."MaritalStatus" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: patients; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.patients (
    id text NOT NULL,
    email text NOT NULL,
    name text NOT NULL,
    "profilePhoto" text,
    "contactNumber" text,
    address text,
    "isDeleted" boolean DEFAULT false NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id text NOT NULL,
    "appointmentId" text NOT NULL,
    amount double precision NOT NULL,
    "transactionId" text NOT NULL,
    status public."PaymentStatus" DEFAULT 'UNPAID'::public."PaymentStatus" NOT NULL,
    "paymentGatewayData" jsonb,
    "stripeEventId" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: prescriptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.prescriptions (
    id text NOT NULL,
    "appointmentId" text NOT NULL,
    "doctorId" text NOT NULL,
    "patientId" text NOT NULL,
    instructions text NOT NULL,
    "followUpDate" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reviews (
    id text NOT NULL,
    "patientId" text NOT NULL,
    "doctorId" text NOT NULL,
    "appointmentId" text NOT NULL,
    rating double precision NOT NULL,
    comment text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schedules (
    id text NOT NULL,
    "startDateTime" timestamp(3) without time zone NOT NULL,
    "endDateTime" timestamp(3) without time zone NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: specialties; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.specialties (
    id text NOT NULL,
    title text NOT NULL,
    icon text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id text NOT NULL,
    email text NOT NULL,
    password text NOT NULL,
    role public."UserRole" NOT NULL,
    "needPasswordChange" boolean DEFAULT true NOT NULL,
    status public."UserStatus" DEFAULT 'ACTIVE'::public."UserStatus" NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
608e1f36-b600-4108-8e0d-7cbfe5116925	16074e49be94abc46feb0a70646cb1121e7a181e0b105cf8620a34806b38584a	2026-04-06 08:30:14.314199+06	20260406023013_init	\N	\N	2026-04-06 08:30:14.097768+06	1
\.


--
-- Data for Name: admins; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.admins (id, name, email, "profilePhoto", "contactNumber", "isDeleted", "createdAt", "updatedAt") FROM stdin;
ae6f64f8-2461-42ce-8c5d-e9c53edaab90	Admin	admin@gmail.com	\N	01234567890	f	2026-04-06 02:37:12.505	2026-04-06 02:37:12.505
f7b70dab-3f94-41d4-b9c5-53b07737c16d	Shafin Ahmed	shafin.rmedu@gmail.com	\N	83838648	f	2026-04-06 02:39:10.494	2026-04-06 02:39:10.494
\.


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.appointments (id, "patientId", "doctorId", "scheduleId", "videoCallingId", status, "paymentStatus", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: doctor_schedules; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.doctor_schedules ("doctorId", "scheduleId", "isBooked", "appointmentId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: doctor_specialties; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.doctor_specialties ("specialitiesId", "doctorId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: doctors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.doctors (id, name, email, "profilePhoto", "contactNumber", address, "registrationNumber", experience, gender, "appointmentFee", qualification, "currentWorkingPlace", designation, "isDeleted", "averageRating", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: medical_reports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.medical_reports (id, "patientId", "reportName", "reportLink", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: patient_health_datas; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.patient_health_datas (id, "patientId", gender, "dateOfBirth", "bloodGroup", "hasAllergies", "hasDiabetes", height, weight, "smokingStatus", "dietaryPreferences", "pregnancyStatus", "mentalHealthHistory", "immunizationStatus", "hasPastSurgeries", "recentAnxiety", "recentDepression", "maritalStatus", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: patients; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.patients (id, email, name, "profilePhoto", "contactNumber", address, "isDeleted", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payments (id, "appointmentId", amount, "transactionId", status, "paymentGatewayData", "stripeEventId", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: prescriptions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.prescriptions (id, "appointmentId", "doctorId", "patientId", instructions, "followUpDate", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reviews (id, "patientId", "doctorId", "appointmentId", rating, comment, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: schedules; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.schedules (id, "startDateTime", "endDateTime", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: specialties; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.specialties (id, title, icon, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, email, password, role, "needPasswordChange", status, "createdAt", "updatedAt") FROM stdin;
441c0762-4eea-4c35-acc3-6ee6c2f390cc	admin@gmail.com	$2b$10$rNkBC6/Z.ZT1I8iAYvnFFOd6u4RYEqXx8ZC.0aqL2xqGs/Ihcv72S	ADMIN	t	ACTIVE	2026-04-06 02:37:12.505	2026-04-06 02:37:12.505
a9ac2682-46e7-459d-8b2a-af5552129225	shafin.rmedu@gmail.com	$2b$10$MBkl3ccmZBDvONHMHLolp.N9EypRWWwMkoED3vqi.I431kIqQD92.	ADMIN	f	ACTIVE	2026-04-06 02:39:10.482	2026-04-06 15:05:42.786
\.


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: admins admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_pkey PRIMARY KEY (id);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: doctor_schedules doctor_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctor_schedules
    ADD CONSTRAINT doctor_schedules_pkey PRIMARY KEY ("doctorId", "scheduleId");


--
-- Name: doctor_specialties doctor_specialties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctor_specialties
    ADD CONSTRAINT doctor_specialties_pkey PRIMARY KEY ("specialitiesId", "doctorId");


--
-- Name: doctors doctors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_pkey PRIMARY KEY (id);


--
-- Name: medical_reports medical_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medical_reports
    ADD CONSTRAINT medical_reports_pkey PRIMARY KEY (id);


--
-- Name: patient_health_datas patient_health_datas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patient_health_datas
    ADD CONSTRAINT patient_health_datas_pkey PRIMARY KEY (id);


--
-- Name: patients patients_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: prescriptions prescriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT prescriptions_pkey PRIMARY KEY (id);


--
-- Name: reviews reviews_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT reviews_pkey PRIMARY KEY (id);


--
-- Name: schedules schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schedules
    ADD CONSTRAINT schedules_pkey PRIMARY KEY (id);


--
-- Name: specialties specialties_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.specialties
    ADD CONSTRAINT specialties_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: admins_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX admins_email_key ON public.admins USING btree (email);


--
-- Name: appointments_scheduleId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "appointments_scheduleId_key" ON public.appointments USING btree ("scheduleId");


--
-- Name: doctor_schedules_appointmentId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "doctor_schedules_appointmentId_key" ON public.doctor_schedules USING btree ("appointmentId");


--
-- Name: doctors_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX doctors_email_key ON public.doctors USING btree (email);


--
-- Name: patient_health_datas_patientId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "patient_health_datas_patientId_key" ON public.patient_health_datas USING btree ("patientId");


--
-- Name: patients_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX patients_email_key ON public.patients USING btree (email);


--
-- Name: patients_id_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX patients_id_key ON public.patients USING btree (id);


--
-- Name: payments_appointmentId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "payments_appointmentId_key" ON public.payments USING btree ("appointmentId");


--
-- Name: payments_stripeEventId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "payments_stripeEventId_key" ON public.payments USING btree ("stripeEventId");


--
-- Name: payments_transactionId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "payments_transactionId_key" ON public.payments USING btree ("transactionId");


--
-- Name: prescriptions_appointmentId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "prescriptions_appointmentId_key" ON public.prescriptions USING btree ("appointmentId");


--
-- Name: reviews_appointmentId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "reviews_appointmentId_key" ON public.reviews USING btree ("appointmentId");


--
-- Name: users_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX users_email_key ON public.users USING btree (email);


--
-- Name: admins admins_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.admins
    ADD CONSTRAINT admins_email_fkey FOREIGN KEY (email) REFERENCES public.users(email) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: appointments appointments_doctorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT "appointments_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES public.doctors(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: appointments appointments_patientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT "appointments_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES public.patients(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: appointments appointments_scheduleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT "appointments_scheduleId_fkey" FOREIGN KEY ("scheduleId") REFERENCES public.schedules(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: doctor_schedules doctor_schedules_appointmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctor_schedules
    ADD CONSTRAINT "doctor_schedules_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES public.appointments(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: doctor_schedules doctor_schedules_doctorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctor_schedules
    ADD CONSTRAINT "doctor_schedules_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES public.doctors(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: doctor_schedules doctor_schedules_scheduleId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctor_schedules
    ADD CONSTRAINT "doctor_schedules_scheduleId_fkey" FOREIGN KEY ("scheduleId") REFERENCES public.schedules(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: doctor_specialties doctor_specialties_doctorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctor_specialties
    ADD CONSTRAINT "doctor_specialties_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES public.doctors(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: doctor_specialties doctor_specialties_specialitiesId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctor_specialties
    ADD CONSTRAINT "doctor_specialties_specialitiesId_fkey" FOREIGN KEY ("specialitiesId") REFERENCES public.specialties(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: doctors doctors_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.doctors
    ADD CONSTRAINT doctors_email_fkey FOREIGN KEY (email) REFERENCES public.users(email) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: medical_reports medical_reports_patientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.medical_reports
    ADD CONSTRAINT "medical_reports_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES public.patients(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: patient_health_datas patient_health_datas_patientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patient_health_datas
    ADD CONSTRAINT "patient_health_datas_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES public.patients(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: patients patients_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.patients
    ADD CONSTRAINT patients_email_fkey FOREIGN KEY (email) REFERENCES public.users(email) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: payments payments_appointmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT "payments_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES public.appointments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: prescriptions prescriptions_appointmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT "prescriptions_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES public.appointments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: prescriptions prescriptions_doctorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT "prescriptions_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES public.doctors(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: prescriptions prescriptions_patientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.prescriptions
    ADD CONSTRAINT "prescriptions_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES public.patients(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: reviews reviews_appointmentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "reviews_appointmentId_fkey" FOREIGN KEY ("appointmentId") REFERENCES public.appointments(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: reviews reviews_doctorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "reviews_doctorId_fkey" FOREIGN KEY ("doctorId") REFERENCES public.doctors(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: reviews reviews_patientId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT "reviews_patientId_fkey" FOREIGN KEY ("patientId") REFERENCES public.patients(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


--
-- PostgreSQL database dump complete
--

\unrestrict c4r1mkPvI4UPM5E5hxNn2SbsLjHWm56tCtOG41JzO5bDyHfTkOXlrAfVeNdoov8

