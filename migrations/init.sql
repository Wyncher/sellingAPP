PGDMP     5                    }            selling    15.12    15.12 (    1           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            2           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            3           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            4           1262    24576    selling    DATABASE     {   CREATE DATABASE selling WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE selling;
                postgres    false            �            1255    32941 ?   add_parts(integer, integer, text, text, boolean, text, integer)    FUNCTION     <  CREATE FUNCTION public.add_parts("procurementPriceValue" integer, price integer, namepart text, additional text, new boolean, categoryval text, quantity integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
IF EXISTS(SELECT parts.Name FROM parts WHERE parts.name=namePart limit 1)
  THEN
     return;
   END IF;
INSERT INTO public.parts ("procurementPrice", price, name, additional, new, "categoryID", quantity)
VALUES("procurementPriceValue",Price,namePart,Additional,New,(SELECT category.id
FROM category
where category.val=CategoryVal limit 1),Quantity);
END;
$$;
 �   DROP FUNCTION public.add_parts("procurementPriceValue" integer, price integer, namepart text, additional text, new boolean, categoryval text, quantity integer);
       public          postgres    false            �            1255    33059 u   add_pc(text, text, text, text, text, text, text, text, text, text, text, text, text, text, integer, integer, boolean)    FUNCTION     �	  CREATE FUNCTION public.add_pc(graphicname text, cpuname text, mbname text, ram1name text, ram2name text, ram3name text, ram4name text, powername text, casename text, cpu_fanname text, case_fanname text, ssd1name text, ssd2name text, hddname text, fan_count integer, price integer, volodya boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
   "procurementSalePrice" INT := 0;
    totalSalePrice INT := 0;
	err TEXT := 'OK';
BEGIN
select delete_parts into err from delete_parts(graphicName,1);
IF err<> 'OK'
THEN
RETURN err;
END IF;
select delete_parts into err from  delete_parts(cpuName,1);
IF err<> 'OK'
THEN
RETURN err;
END IF;
select delete_parts into err from  delete_parts(mbName,1);
IF err<> 'OK'
THEN
RETURN err;
END IF;
select delete_parts into err from  delete_parts(ram1Name,1);
IF err<> 'OK'
THEN
RETURN err;
END IF;
select delete_parts into err from  delete_parts(ram2Name,1);
IF err<> 'OK'
THEN
RETURN err;
END IF;
select delete_parts into err from  delete_parts(ram3Name,1);
IF err<> 'OK'
THEN
RETURN err;
END IF;
select delete_parts into err from  delete_parts(ram4Name,1);
IF err<> 'OK'
THEN
RETURN err;
END IF;
select delete_parts into err from  delete_parts(powerName,1);
IF err<> 'OK'
THEN
RETURN err;
END IF;
select delete_parts into err from  delete_parts(caseName,1);
IF err<> 'OK'
THEN
RETURN err;
END IF;
select delete_parts into err from  delete_parts(cpu_fanName,1);
IF err<> 'OK'
THEN
RETURN err;
END IF;
select delete_parts into err from  delete_parts(case_fanName,fan_count);
IF err<> 'OK'
THEN
RETURN err;
END IF;
select delete_parts into err from  delete_parts(ssd1Name,1);
IF err<> 'OK'
THEN
RETURN err;
END IF;
select delete_parts into err from  delete_parts(ssd2Name,1);
IF err<> 'OK'
THEN
RETURN err;
END IF;
select delete_parts into err from  delete_parts(hddName,1);
IF err<> 'OK'
THEN
RETURN err;
END IF;
SELECT COALESCE(procurementsaleprice, 0), COALESCE(pricesale, 0) INTO "procurementSalePrice" , totalSalePrice FROM calc_pc(graphicName, cpuName, mbName, ram1Name, ram2Name, ram3Name, ram4Name, powerName, 
	caseName, cpu_fanName, case_fanName, ssd1Name, ssd2Name, hddName, fan_count) ;
INSERT INTO public.pc(graphic, cpu, mb, ram1, ram2, ram3, ram4, "power", "case", cpu_fan, case_fan, ssd1, ssd2, hdd, fan_count,"procurementPrice", profit, volodya,sold)
	VALUES (graphicName, cpuName, mbName, ram1Name, ram2Name, ram3Name, ram4Name, powerName, 
	caseName, cpu_fanName, case_fanName, ssd1Name, ssd2Name, hddName, fan_count, "procurementSalePrice", totalSalePrice, volodya,false);

END;
$$;
 )  DROP FUNCTION public.add_pc(graphicname text, cpuname text, mbname text, ram1name text, ram2name text, ram3name text, ram4name text, powername text, casename text, cpu_fanname text, case_fanname text, ssd1name text, ssd2name text, hddname text, fan_count integer, price integer, volodya boolean);
       public          postgres    false            �            1255    33045 d   calc_pc(text, text, text, text, text, text, text, text, text, text, text, text, text, text, integer)    FUNCTION       CREATE FUNCTION public.calc_pc(graphicname text, cpuname text, mbname text, ram1name text, ram2name text, ram3name text, ram4name text, powername text, casename text, cpu_fanname text, case_fanname text, ssd1name text, ssd2name text, hddname text, fan_count integer) RETURNS TABLE(procurementsaleprice integer, pricesale integer)
    LANGUAGE plpgsql
    AS $$
DECLARE 
procurementsaleprice INT := 0;
    priceSale INT := 0;
    val1 INT;
    val2 INT;
BEGIN
    SELECT "procurementPrice", price INTO val1, val2 FROM parts WHERE parts.name = graphicName LIMIT 1;
    procurementsaleprice := procurementsaleprice + COALESCE(val1, 0);
    priceSale := priceSale + COALESCE(val2, 0);
    SELECT "procurementPrice", price INTO val1, val2 FROM parts WHERE parts.name = cpuName LIMIT 1;
    procurementsaleprice := procurementsaleprice + COALESCE(val1, 0);
    priceSale := priceSale + COALESCE(val2, 0);
	SELECT "procurementPrice", price INTO val1, val2 FROM parts WHERE parts.name = mbName LIMIT 1;
    procurementsaleprice := procurementsaleprice + COALESCE(val1, 0);
    priceSale := priceSale + COALESCE(val2, 0);
	SELECT "procurementPrice", price INTO val1, val2 FROM parts WHERE parts.name = ram1Name LIMIT 1;
    procurementsaleprice := procurementsaleprice + COALESCE(val1, 0);
    priceSale := priceSale + COALESCE(val2, 0);
	SELECT "procurementPrice", price INTO val1, val2 FROM parts WHERE parts.name = ram2Name LIMIT 1;
    procurementsaleprice := procurementsaleprice + COALESCE(val1, 0);
    priceSale := priceSale + COALESCE(val2, 0);
	SELECT "procurementPrice", price INTO val1, val2 FROM parts WHERE parts.name = ram3Name LIMIT 1;
    procurementsaleprice := procurementsaleprice + COALESCE(val1, 0);
    priceSale := priceSale + COALESCE(val2, 0);
	SELECT "procurementPrice", price INTO val1, val2 FROM parts WHERE parts.name = ram4Name LIMIT 1;
    procurementsaleprice := procurementsaleprice + COALESCE(val1, 0);
    priceSale := priceSale + COALESCE(val2, 0);
	SELECT "procurementPrice", price INTO val1, val2 FROM parts WHERE parts.name = powerName LIMIT 1;
    procurementsaleprice := procurementsaleprice + COALESCE(val1, 0);
    priceSale := priceSale + COALESCE(val2, 0);
	SELECT "procurementPrice", price INTO val1, val2 FROM parts WHERE parts.name = caseName LIMIT 1;
    procurementsaleprice := procurementsaleprice + COALESCE(val1, 0);
    priceSale := priceSale + COALESCE(val2, 0);
	SELECT "procurementPrice", price INTO val1, val2 FROM parts WHERE parts.name = cpu_fanName LIMIT 1;
    procurementsaleprice := procurementsaleprice + COALESCE(val1, 0);
    priceSale := priceSale + COALESCE(val2, 0);
	SELECT "procurementPrice", price INTO val1, val2 FROM parts WHERE parts.name = case_fanName LIMIT 1;
    procurementsaleprice := procurementsaleprice + (COALESCE(val1, 0) * fan_count);
    priceSale := priceSale + (COALESCE(val2, 0) * fan_count);
	SELECT "procurementPrice", price INTO val1, val2 FROM parts WHERE parts.name = ssd1Name LIMIT 1;
    procurementsaleprice := procurementsaleprice + COALESCE(val1, 0);
    priceSale := priceSale + COALESCE(val2, 0);
	SELECT "procurementPrice", price INTO val1, val2 FROM parts WHERE parts.name = ssd2Name LIMIT 1;
    procurementsaleprice:= procurementsaleprice + COALESCE(val1, 0);
    priceSale := priceSale + COALESCE(val2, 0);
	SELECT "procurementPrice", price INTO val1, val2 FROM parts WHERE parts.name = hddName LIMIT 1;
    procurementsaleprice := procurementsaleprice + COALESCE(val1, 0);
    priceSale := priceSale + COALESCE(val2, 0);
	return query select procurementsaleprice , priceSale;
END;
$$;
 
  DROP FUNCTION public.calc_pc(graphicname text, cpuname text, mbname text, ram1name text, ram2name text, ram3name text, ram4name text, powername text, casename text, cpu_fanname text, case_fanname text, ssd1name text, ssd2name text, hddname text, fan_count integer);
       public          postgres    false            �            1255    32922 "   calcsum(integer, integer, integer)    FUNCTION     �   CREATE FUNCTION public.calcsum(quantitypart integer, pricepart integer, discountpart integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE priceSale TEXT;
BEGIN
RETURN quantityPart*pricePart-discountPart;
END;
$$;
 ]   DROP FUNCTION public.calcsum(quantitypart integer, pricepart integer, discountpart integer);
       public          postgres    false            �            1255    33053    delete_parts(text, integer)    FUNCTION     9  CREATE FUNCTION public.delete_parts(namepart text, quantitypart integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS(SELECT parts.name FROM parts WHERE parts.name=namePart limit 1)
  THEN
     RAISE NOTICE 'Найдено комплектующее';
  ELSE
	 RETURN 'Не найдено';
  END IF;
UPDATE parts SET quantity = quantity - quantityPart where parts.name= namePart;
  IF (SELECT parts.quantity FROM parts WHERE parts.name=namePart limit 1) < 1 
  THEN
     DELETE FROM parts WHERE parts.name=namePart;
   END IF;
RETURN 'ОК';
END;
$$;
 H   DROP FUNCTION public.delete_parts(namepart text, quantitypart integer);
       public          postgres    false            �            1255    32942    get_parts()    FUNCTION     �  CREATE FUNCTION public.get_parts() RETURNS TABLE("partId" integer, partname text, quantity integer, namecategory text, price integer, profit integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT parts.ID, parts.name,parts.quantity,category.val,parts.price,parts.price-parts."procurementPrice" FROM public.parts join category on parts."categoryID"=category.id;
END;
$$;
 "   DROP FUNCTION public.get_parts();
       public          postgres    false            �            1255    32943    get_sales_parts()    FUNCTION     o  CREATE FUNCTION public.get_sales_parts() RETURNS TABLE(saleid integer, partname text, saledate date, quantity integer, discount integer, sum integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT sales.id, parts.name,sales."saleDate",sales.quantity,sales.discount,sales."saleSum" FROM public.sales_parts join parts on sales."partId"=parts.id;
END;
$$;
 (   DROP FUNCTION public.get_sales_parts();
       public          postgres    false            �            1255    32923 (   sale_parts(text, integer, integer, date)    FUNCTION     �  CREATE FUNCTION public.sale_parts(partname text, quantitypart integer, discountpart integer, inputsaledate date DEFAULT now()) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE priceSale INT;
BEGIN
priceSale :=(SELECT price from parts where  parts.name = partName limit 1);

INSERT INTO sales_parts("partId",quantity,discount,"saleSum","saleDate") VALUES (
(SELECT id from parts where parts.name=partName),quantityPart,discountPart,(select * from calcSum(quantityPart,priceSale,discountPart) limit 1),inputSaleDate
);
Update parts SET quantity = quantity - quantityPart where parts.name= partName;
  IF (SELECT parts.quantity FROM parts WHERE parts.name=partName limit 1) < 1 
  THEN
     DELETE FROM parts WHERE parts.name=partName;
   END IF;
END;
$$;
 p   DROP FUNCTION public.sale_parts(partname text, quantitypart integer, discountpart integer, inputsaledate date);
       public          postgres    false            �            1255    33061    sale_pc(integer, integer, date)    FUNCTION     i  CREATE FUNCTION public.sale_pc(pcid integer, discountpc integer, inputsaledate date DEFAULT now()) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE 
err TEXT :='OK';
BEGIN
UPDATE pc SET pc.sold = true where pc.id = pcid; 
INSERT INTO public."sales_PC"(
	"pcID", "saleSum", "saleDate","discount")
	VALUES (pcid, discountpc, inputsaledate,discount);

END;
$$;
 T   DROP FUNCTION public.sale_pc(pcid integer, discountpc integer, inputsaledate date);
       public          postgres    false            �            1259    32861    category    TABLE     Q   CREATE TABLE public.category (
    id integer NOT NULL,
    val text NOT NULL
);
    DROP TABLE public.category;
       public         heap    postgres    false            �            1259    32860    category_id_seq    SEQUENCE     �   ALTER TABLE public.category ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    219            �            1259    32777    parts    TABLE     A  CREATE TABLE public.parts (
    id integer NOT NULL,
    price integer NOT NULL,
    name text NOT NULL,
    additional text DEFAULT 'пусто'::text NOT NULL,
    new boolean DEFAULT false NOT NULL,
    "categoryID" integer NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    "procurementPrice" integer NOT NULL
);
    DROP TABLE public.parts;
       public         heap    postgres    false            �            1259    32776    parts_id_seq    SEQUENCE     �   ALTER TABLE public.parts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.parts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    215            �            1259    32799    pc    TABLE     (  CREATE TABLE public.pc (
    id integer NOT NULL,
    graphic text,
    cpu text NOT NULL,
    mb text NOT NULL,
    ram1 text NOT NULL,
    power text NOT NULL,
    "case" text NOT NULL,
    cpu_fan text NOT NULL,
    case_fan text NOT NULL,
    ssd1 text NOT NULL,
    ssd2 text,
    hdd text NOT NULL,
    volodya boolean DEFAULT false NOT NULL,
    fan_count integer NOT NULL,
    ram2 text NOT NULL,
    ram3 text NOT NULL,
    ram4 text NOT NULL,
    "procurementPrice" integer NOT NULL,
    profit integer NOT NULL,
    sold boolean NOT NULL
);
    DROP TABLE public.pc;
       public         heap    postgres    false            �            1259    32798 	   pc_id_seq    SEQUENCE     �   ALTER TABLE public.pc ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.pc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    217            �            1259    32927    sales_PC    TABLE     �   CREATE TABLE public."sales_PC" (
    id integer NOT NULL,
    "pcID" integer NOT NULL,
    "saleSum" integer NOT NULL,
    "saleDate" date DEFAULT now() NOT NULL,
    discount integer NOT NULL
);
    DROP TABLE public."sales_PC";
       public         heap    postgres    false            �            1259    32926    sales_PC_id_seq    SEQUENCE     �   ALTER TABLE public."sales_PC" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public."sales_PC_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    223            �            1259    32887    sales_parts    TABLE     �   CREATE TABLE public.sales_parts (
    id integer NOT NULL,
    "saleDate" date DEFAULT now() NOT NULL,
    "partId" integer NOT NULL,
    discount integer DEFAULT 0 NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    "saleSum" integer NOT NULL
);
    DROP TABLE public.sales_parts;
       public         heap    postgres    false            �            1259    32886    sales_id_seq    SEQUENCE     �   ALTER TABLE public.sales_parts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sales_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);
            public          postgres    false    221            *          0    32861    category 
   TABLE DATA           +   COPY public.category (id, val) FROM stdin;
    public          postgres    false    219   �R       &          0    32777    parts 
   TABLE DATA           m   COPY public.parts (id, price, name, additional, new, "categoryID", quantity, "procurementPrice") FROM stdin;
    public          postgres    false    215   �S       (          0    32799    pc 
   TABLE DATA           �   COPY public.pc (id, graphic, cpu, mb, ram1, power, "case", cpu_fan, case_fan, ssd1, ssd2, hdd, volodya, fan_count, ram2, ram3, ram4, "procurementPrice", profit, sold) FROM stdin;
    public          postgres    false    217   �S       .          0    32927    sales_PC 
   TABLE DATA           Q   COPY public."sales_PC" (id, "pcID", "saleSum", "saleDate", discount) FROM stdin;
    public          postgres    false    223   T       ,          0    32887    sales_parts 
   TABLE DATA           ^   COPY public.sales_parts (id, "saleDate", "partId", discount, quantity, "saleSum") FROM stdin;
    public          postgres    false    221   )T       5           0    0    category_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.category_id_seq', 12, true);
          public          postgres    false    218            6           0    0    parts_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.parts_id_seq', 19, true);
          public          postgres    false    214            7           0    0 	   pc_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('public.pc_id_seq', 11, true);
          public          postgres    false    216            8           0    0    sales_PC_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('public."sales_PC_id_seq"', 1, false);
          public          postgres    false    222            9           0    0    sales_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.sales_id_seq', 24, true);
          public          postgres    false    220            �           2606    32869    category category_id_key 
   CONSTRAINT     Q   ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_id_key UNIQUE (id);
 B   ALTER TABLE ONLY public.category DROP CONSTRAINT category_id_key;
       public            postgres    false    219            �           2606    32867    category category_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.category DROP CONSTRAINT category_pkey;
       public            postgres    false    219            �           2606    32797    parts parts_id_key 
   CONSTRAINT     K   ALTER TABLE ONLY public.parts
    ADD CONSTRAINT parts_id_key UNIQUE (id);
 <   ALTER TABLE ONLY public.parts DROP CONSTRAINT parts_id_key;
       public            postgres    false    215            �           2606    32803 
   pc pc_pkey 
   CONSTRAINT     H   ALTER TABLE ONLY public.pc
    ADD CONSTRAINT pc_pkey PRIMARY KEY (id);
 4   ALTER TABLE ONLY public.pc DROP CONSTRAINT pc_pkey;
       public            postgres    false    217            �           2606    32932    sales_PC sales_PC_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY public."sales_PC"
    ADD CONSTRAINT "sales_PC_pkey" PRIMARY KEY (id);
 D   ALTER TABLE ONLY public."sales_PC" DROP CONSTRAINT "sales_PC_pkey";
       public            postgres    false    223            �           2606    32893    sales_parts sales_pkey 
   CONSTRAINT     T   ALTER TABLE ONLY public.sales_parts
    ADD CONSTRAINT sales_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.sales_parts DROP CONSTRAINT sales_pkey;
       public            postgres    false    221            �           2606    32877    parts category    FK CONSTRAINT        ALTER TABLE ONLY public.parts
    ADD CONSTRAINT category FOREIGN KEY ("categoryID") REFERENCES public.category(id) NOT VALID;
 8   ALTER TABLE ONLY public.parts DROP CONSTRAINT category;
       public          postgres    false    219    215    3217            *   �   x�]P;n�@�wN�Dlz�isc>�,Q�(7X��6Wxs#�lR����z�=ΈpE�Jkyu8"�KD�P��QW��'�C�u��&ѓ��������xӦ�]+Ҷ�TZr�����Ms�qM�y�0�6��i��>SeJ/b�f������6Z뗼�Ţ���(K�;��]W	�GV6�'�YҎ�κ�u�-ې��Fԝx�O�M���2��狈< e�Ӡ      &   $   x�34�4300�,�0N�NS 4
q��qqq c|      (      x������ � �      .      x������ � �      ,   3   x�32�4202�50�50�44�4400�4�44�\F& YS���l� `
[     