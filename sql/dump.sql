--
-- PostgreSQL database dump
--

\restrict bvaYIEVtnfkmE7D7eyeqxlVSxlEdqHP3vlCPBw0ygOxvSdxFAahuV320A6h4H4Y

-- Dumped from database version 14.19 (Homebrew)
-- Dumped by pg_dump version 14.19 (Homebrew)

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
-- Name: category; Type: TABLE; Schema: public; Owner: rahilshaik
--

CREATE TABLE public.category (
    c_categoryid integer NOT NULL,
    c_categoryname character varying(255) NOT NULL,
    c_categorydescription text
);


ALTER TABLE public.category OWNER TO rahilshaik;

--
-- Name: category_c_categoryid_seq; Type: SEQUENCE; Schema: public; Owner: rahilshaik
--

CREATE SEQUENCE public.category_c_categoryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.category_c_categoryid_seq OWNER TO rahilshaik;

--
-- Name: category_c_categoryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rahilshaik
--

ALTER SEQUENCE public.category_c_categoryid_seq OWNED BY public.category.c_categoryid;


--
-- Name: entry; Type: TABLE; Schema: public; Owner: rahilshaik
--

CREATE TABLE public.entry (
    e_entryid integer NOT NULL,
    e_listid integer NOT NULL,
    e_groceryid integer NOT NULL,
    e_quantity integer NOT NULL
);


ALTER TABLE public.entry OWNER TO rahilshaik;

--
-- Name: entry_e_entryid_seq; Type: SEQUENCE; Schema: public; Owner: rahilshaik
--

CREATE SEQUENCE public.entry_e_entryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.entry_e_entryid_seq OWNER TO rahilshaik;

--
-- Name: entry_e_entryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rahilshaik
--

ALTER SEQUENCE public.entry_e_entryid_seq OWNED BY public.entry.e_entryid;


--
-- Name: groceryitem; Type: TABLE; Schema: public; Owner: rahilshaik
--

CREATE TABLE public.groceryitem (
    g_groceryid integer NOT NULL,
    g_groceryname character varying(255) NOT NULL,
    g_categoryid integer[]
);


ALTER TABLE public.groceryitem OWNER TO rahilshaik;

--
-- Name: groceryitem_g_groceryid_seq; Type: SEQUENCE; Schema: public; Owner: rahilshaik
--

CREATE SEQUENCE public.groceryitem_g_groceryid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groceryitem_g_groceryid_seq OWNER TO rahilshaik;

--
-- Name: groceryitem_g_groceryid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rahilshaik
--

ALTER SEQUENCE public.groceryitem_g_groceryid_seq OWNED BY public.groceryitem.g_groceryid;


--
-- Name: household; Type: TABLE; Schema: public; Owner: rahilshaik
--

CREATE TABLE public.household (
    h_householdid integer NOT NULL,
    h_ownerid integer,
    h_householdname character varying(255) NOT NULL
);


ALTER TABLE public.household OWNER TO rahilshaik;

--
-- Name: household_h_householdid_seq; Type: SEQUENCE; Schema: public; Owner: rahilshaik
--

CREATE SEQUENCE public.household_h_householdid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.household_h_householdid_seq OWNER TO rahilshaik;

--
-- Name: household_h_householdid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rahilshaik
--

ALTER SEQUENCE public.household_h_householdid_seq OWNED BY public.household.h_householdid;


--
-- Name: lists; Type: TABLE; Schema: public; Owner: rahilshaik
--

CREATE TABLE public.lists (
    l_listid integer NOT NULL,
    l_householdid integer NOT NULL,
    l_listname character varying(255),
    l_isstocklist boolean DEFAULT false,
    l_admin integer,
    l_comment text
);


ALTER TABLE public.lists OWNER TO rahilshaik;

--
-- Name: lists_l_listid_seq; Type: SEQUENCE; Schema: public; Owner: rahilshaik
--

CREATE SEQUENCE public.lists_l_listid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lists_l_listid_seq OWNER TO rahilshaik;

--
-- Name: lists_l_listid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rahilshaik
--

ALTER SEQUENCE public.lists_l_listid_seq OWNED BY public.lists.l_listid;


--
-- Name: users; Type: TABLE; Schema: public; Owner: rahilshaik
--

CREATE TABLE public.users (
    u_userid integer NOT NULL,
    u_username character varying(255) NOT NULL,
    u_householdid integer NOT NULL,
    u_isadmin boolean DEFAULT false,
    u_password character varying(255)
);


ALTER TABLE public.users OWNER TO rahilshaik;

--
-- Name: users_u_userid_seq; Type: SEQUENCE; Schema: public; Owner: rahilshaik
--

CREATE SEQUENCE public.users_u_userid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_u_userid_seq OWNER TO rahilshaik;

--
-- Name: users_u_userid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: rahilshaik
--

ALTER SEQUENCE public.users_u_userid_seq OWNED BY public.users.u_userid;


--
-- Name: category c_categoryid; Type: DEFAULT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.category ALTER COLUMN c_categoryid SET DEFAULT nextval('public.category_c_categoryid_seq'::regclass);


--
-- Name: entry e_entryid; Type: DEFAULT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.entry ALTER COLUMN e_entryid SET DEFAULT nextval('public.entry_e_entryid_seq'::regclass);


--
-- Name: groceryitem g_groceryid; Type: DEFAULT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.groceryitem ALTER COLUMN g_groceryid SET DEFAULT nextval('public.groceryitem_g_groceryid_seq'::regclass);


--
-- Name: household h_householdid; Type: DEFAULT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.household ALTER COLUMN h_householdid SET DEFAULT nextval('public.household_h_householdid_seq'::regclass);


--
-- Name: lists l_listid; Type: DEFAULT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.lists ALTER COLUMN l_listid SET DEFAULT nextval('public.lists_l_listid_seq'::regclass);


--
-- Name: users u_userid; Type: DEFAULT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.users ALTER COLUMN u_userid SET DEFAULT nextval('public.users_u_userid_seq'::regclass);


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: rahilshaik
--

COPY public.category (c_categoryid, c_categoryname, c_categorydescription) FROM stdin;
0	Fruits	All items containing fruits
1	Vegetables	All items containing vegetables
2	Meat	All items containing meat
3	Seafood	All items containing seafood
4	Dairy	All items containing dairy
6	Baking	Items used in baking. Flour, baking soda etc
7	Pasta/Rice	Pastas and Rice, premade or dried.
8	Baked Goods	Baked goods. Bread, cake etc
9	Snacks	Snack and candy items. 
10	Seasonings	Ground and fresh seasonings. 
11	Canned/Jarred Goods	Canned or jarred goods. Soups, jams, etc
12	Drinks	All drink items
13	Breakfast	Breakfast items. Cereal, oatmeal, etc
14	Personal Care	Personal care items. Toothbrush, soap, deodorant, etc
15	Other	Misc. items
5	Frozen	newcategory description
\.


--
-- Data for Name: entry; Type: TABLE DATA; Schema: public; Owner: rahilshaik
--

COPY public.entry (e_entryid, e_listid, e_groceryid, e_quantity) FROM stdin;
0	17	31	8
1	9	43	6
2	10	34	3
3	12	6	10
4	24	0	9
5	15	1	10
6	21	9	9
7	6	30	10
8	1	25	8
9	25	19	7
10	22	4	5
11	24	19	6
12	18	2	2
13	12	44	10
14	14	9	3
15	10	40	4
16	26	44	10
17	3	46	0
19	25	46	2
21	13	38	4
22	1	23	0
23	17	30	5
24	9	5	2
25	5	33	8
26	6	17	6
27	28	31	1
28	29	38	5
29	10	10	0
30	15	15	0
31	3	48	6
32	9	46	9
33	17	20	7
34	5	8	2
35	3	27	7
36	24	13	2
37	22	48	0
38	28	2	5
39	26	41	6
40	11	11	3
41	5	3	10
42	3	21	5
43	9	15	4
44	4	5	0
45	13	47	3
46	11	25	8
47	29	16	7
48	8	24	7
49	25	9	1
50	22	14	3
51	8	5	6
52	25	14	5
53	13	44	9
54	26	17	7
55	16	19	1
56	2	31	7
57	0	12	7
58	27	9	7
62	0	6	10
67	2	6	1
\.


--
-- Data for Name: groceryitem; Type: TABLE DATA; Schema: public; Owner: rahilshaik
--

COPY public.groceryitem (g_groceryid, g_groceryname, g_categoryid) FROM stdin;
0	Apple	{0}
1	Banana	{0}
2	Watermelon	{0}
3	Cabbage	{1}
4	Tomatos	{1}
5	Onion	{1}
6	Cereal	{13}
7	Oatmeal	{13}
8	Groud Beef	{2}
9	Turkey Slices	{2}
10	Frozen Shrimp	{2,3,5}
11	Flour	{6}
12	Sugar	{6}
13	Pie Crust	{6,8}
14	Cookies	{8,9}
15	Popcorn	{9}
16	Bagels	{8,13}
17	Bread	{8}
18	Mac & Cheese	{4,7}
19	Brown Rice	{7}
20	Chicken Soup	{2,11}
21	Basil	{1,10}
22	Garlic Salt	{10}
23	Sour Cream	{4}
24	Deodorant	{14}
25	Toothpaste	{14}
26	Shampoo	{14}
27	Chips	{9}
28	Crackers	{9}
29	Milk	{4,12}
30	Ice Cream	{4,5,9}
31	Frozen Pizza	{4,5}
32	Hot Dogs	{2}
33	Tortilla Chips	{9}
34	Carrots	{1}
35	Granola	{8,13}
36	Frozen Blueberries	{0,5}
37	Pickles	{1,11}
38	Cumin	{10}
39	Wax Paper	{15}
40	Batteries	{15}
41	Laundry Detergent	{14}
42	Coffee	{12}
43	Tea	{12}
44	Honey	{6,11}
45	Sugar	{6}
46	Brown Sugar	{6}
47	Pepper	{10}
48	Yogurt	{4,13}
49	Cilantro	{1,10}
\.


--
-- Data for Name: household; Type: TABLE DATA; Schema: public; Owner: rahilshaik
--

COPY public.household (h_householdid, h_ownerid, h_householdname) FROM stdin;
0	0	household0
1	3	household1
2	6	household2
3	9	household3
4	12	household4
5	15	household5
6	18	household6
7	21	household7
8	24	household8
9	27	household9
\.


--
-- Data for Name: lists; Type: TABLE DATA; Schema: public; Owner: rahilshaik
--

COPY public.lists (l_listid, l_householdid, l_listname, l_isstocklist, l_admin, l_comment) FROM stdin;
0	0	list0	f	2	FHELexkdlZ
1	0	list1	f	1	nGSRfLWMAr
2	0	list2	t	1	mDCZEXIDKV
3	1	list3	f	3	tObBEMrovn
4	1	list4	t	3	GzJGrrIQFo
5	1	list5	t	5	IdiXZXXKDQ
6	2	list6	f	7	ClPbQJZAsK
7	2	list7	t	8	KRvBFsWnAc
8	2	list8	f	8	JRgdgWHzoj
9	3	list9	f	11	gPKiBNufZV
10	3	list10	f	10	olJFYHwAyH
11	3	list11	t	9	SzwyahsbHL
12	4	list12	t	12	xhdbrpWaNK
13	4	list13	f	12	eIdPRpDebf
14	4	list14	f	14	mYgkVxfbsL
15	5	list15	t	17	eHrfNQOUrk
16	5	list16	f	15	iYiXfMUske
17	5	list17	t	15	qGWDLEZnJE
18	6	list18	f	19	bVeCIRJiwg
19	6	list19	f	20	LsKNRKkxWi
20	6	list20	f	20	CwhOBpQQIi
21	7	list21	t	23	aZUGRrLPrM
22	7	list22	f	22	VwYiLscBVR
23	7	list23	f	23	bYsYMvrijq
24	8	list24	t	25	MovNEVHPmJ
25	8	list25	t	25	XVSFbLYtJZ
26	8	list26	f	25	JORgIjrOrb
27	9	list27	t	29	OgqbcYffoN
28	9	list28	f	29	KfxaXTrMGI
29	9	list29	t	27	YWnBafyIEt
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: rahilshaik
--

COPY public.users (u_userid, u_username, u_householdid, u_isadmin, u_password) FROM stdin;
10	user10	3	f	pass10
4	user4	0	f	pass4
0	user0	0	t	pass0
1	user1	0	f	pass1
2	user2	0	f	pass2
3	user3	1	t	pass3
5	user5	1	f	pass5
6	user6	2	t	pass6
7	user7	2	f	pass7
8	user8	2	f	pass8
9	user9	3	t	pass9
11	user11	3	f	pass11
12	user12	4	t	pass12
13	user13	4	f	pass13
14	user14	4	f	pass14
15	user15	5	t	pass15
16	user16	5	f	pass16
17	user17	5	f	pass17
18	user18	6	t	pass18
19	user19	6	f	pass19
20	user20	6	f	pass20
21	user21	7	t	pass21
22	user22	7	f	pass22
23	user23	7	f	pass23
24	user24	8	t	pass24
25	user25	8	f	pass25
26	user26	8	f	pass26
27	user27	9	t	pass27
28	user28	9	f	pass28
29	user29	9	f	pass29
\.


--
-- Name: category_c_categoryid_seq; Type: SEQUENCE SET; Schema: public; Owner: rahilshaik
--

SELECT pg_catalog.setval('public.category_c_categoryid_seq', 16, true);


--
-- Name: entry_e_entryid_seq; Type: SEQUENCE SET; Schema: public; Owner: rahilshaik
--

SELECT pg_catalog.setval('public.entry_e_entryid_seq', 67, true);


--
-- Name: groceryitem_g_groceryid_seq; Type: SEQUENCE SET; Schema: public; Owner: rahilshaik
--

SELECT pg_catalog.setval('public.groceryitem_g_groceryid_seq', 50, false);


--
-- Name: household_h_householdid_seq; Type: SEQUENCE SET; Schema: public; Owner: rahilshaik
--

SELECT pg_catalog.setval('public.household_h_householdid_seq', 10, true);


--
-- Name: lists_l_listid_seq; Type: SEQUENCE SET; Schema: public; Owner: rahilshaik
--

SELECT pg_catalog.setval('public.lists_l_listid_seq', 36, true);


--
-- Name: users_u_userid_seq; Type: SEQUENCE SET; Schema: public; Owner: rahilshaik
--

SELECT pg_catalog.setval('public.users_u_userid_seq', 30, true);


--
-- Name: category category_c_categoryname_key; Type: CONSTRAINT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_c_categoryname_key UNIQUE (c_categoryname);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (c_categoryid);


--
-- Name: entry entry_pkey; Type: CONSTRAINT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.entry
    ADD CONSTRAINT entry_pkey PRIMARY KEY (e_entryid);


--
-- Name: groceryitem groceryitem_pkey; Type: CONSTRAINT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.groceryitem
    ADD CONSTRAINT groceryitem_pkey PRIMARY KEY (g_groceryid);


--
-- Name: household household_pkey; Type: CONSTRAINT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.household
    ADD CONSTRAINT household_pkey PRIMARY KEY (h_householdid);


--
-- Name: lists lists_pkey; Type: CONSTRAINT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (l_listid);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (u_userid);


--
-- Name: entry entry_e_groceryid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.entry
    ADD CONSTRAINT entry_e_groceryid_fkey FOREIGN KEY (e_groceryid) REFERENCES public.groceryitem(g_groceryid);


--
-- Name: entry entry_e_listid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.entry
    ADD CONSTRAINT entry_e_listid_fkey FOREIGN KEY (e_listid) REFERENCES public.lists(l_listid) ON DELETE CASCADE;


--
-- Name: household h_owner; Type: FK CONSTRAINT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.household
    ADD CONSTRAINT h_owner FOREIGN KEY (h_ownerid) REFERENCES public.users(u_userid);


--
-- Name: lists lists_l_admin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT lists_l_admin_fkey FOREIGN KEY (l_admin) REFERENCES public.users(u_userid);


--
-- Name: lists lists_l_householdid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.lists
    ADD CONSTRAINT lists_l_householdid_fkey FOREIGN KEY (l_householdid) REFERENCES public.household(h_householdid);


--
-- Name: users users_u_householdid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: rahilshaik
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_u_householdid_fkey FOREIGN KEY (u_householdid) REFERENCES public.household(h_householdid);


--
-- PostgreSQL database dump complete
--

\unrestrict bvaYIEVtnfkmE7D7eyeqxlVSxlEdqHP3vlCPBw0ygOxvSdxFAahuV320A6h4H4Y

