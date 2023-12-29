--
-- PostgreSQL database dump
--

-- Dumped from database version 16.0
-- Dumped by pg_dump version 16.0

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
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    employeeid integer NOT NULL,
    firstname character varying(50),
    lastname character varying(50),
    "position" character varying(50),
    email character varying(100)
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- Name: projects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects (
    projectid integer NOT NULL,
    projectname character varying(100),
    startdate date,
    enddate date,
    projectmanagerid integer
);


ALTER TABLE public.projects OWNER TO postgres;

--
-- Name: tasks; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tasks (
    taskid integer NOT NULL,
    projectid integer,
    taskname character varying(100),
    description text,
    duedate date,
    assignedtoid integer,
    status character varying(20)
);


ALTER TABLE public.tasks OWNER TO postgres;

--
-- Data for Name: employees; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.employees (employeeid, firstname, lastname, "position", email) FROM stdin;
1	John	Doe	Manager	john.doe@example.com
2	Jane	Doe	Developer	jane.doe@example.com
3	Alice	Smith	Designer	alice.smith@example.com
4	Bob	Brown	Analyst	bob.brown@example.com
5	Charlie	Davis	Tester	charlie.davis@example.com
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.projects (projectid, projectname, startdate, enddate, projectmanagerid) FROM stdin;
1	Project Alpha	2021-01-01	2021-12-31	1
2	Project Beta	2021-02-01	2021-08-31	2
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tasks (taskid, projectid, taskname, description, duedate, assignedtoid, status) FROM stdin;
1	1	Task 1	Description for Task 1	2021-03-01	1	Completed
2	1	Task 2	Description for Task 2	2021-04-01	2	In Progress
3	1	Task 3	Description for Task 3	2021-05-01	3	Not Started
4	2	Task A	Description for Task A	2021-06-01	4	Not Started
5	2	Task B	Description for Task B	2021-07-01	5	In Progress
6	2	Task C	Description for Task C	2021-08-01	1	Completed
\.


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (employeeid);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (projectid);


--
-- Name: tasks tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (taskid);


--
-- Name: projects projects_projectmanagerid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_projectmanagerid_fkey FOREIGN KEY (projectmanagerid) REFERENCES public.employees(employeeid);


--
-- Name: tasks tasks_assignedtoid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_assignedtoid_fkey FOREIGN KEY (assignedtoid) REFERENCES public.employees(employeeid);


--
-- Name: tasks tasks_projectid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tasks
    ADD CONSTRAINT tasks_projectid_fkey FOREIGN KEY (projectid) REFERENCES public.projects(projectid);


--
-- PostgreSQL database dump complete
--

