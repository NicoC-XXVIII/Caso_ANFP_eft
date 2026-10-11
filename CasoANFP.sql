/*  ========================================================

    -Modelo BD Asociación Nacional de Fútbol Profesional (ANFP).-
        
        
                                        Oracle SQL Developer                                   
        
    --------------------------------------------------------
    Fase 1: Implementación del Modelo Relacional
    -------------------------------------------------------- 

    ======================================================== */
    
/*  ========================================================
    1.1:
    •   Uso de DROP TABLE para hacer limpieza de tablas y objetos.
    •   Uso de CASCADE CONSTRAINS para hacer hacer limpieza de las 
        relaciones y restricciones.
    •   Orden de eliminación en tablas:
        Tablas hijas -> tablas padre.
    ======================================================== */ 
    
DROP TABLE PERSONAL_PLANTA CASCADE CONSTRAINTS;
DROP TABLE JUGADOR_FUTBOL CASCADE CONSTRAINTS;
DROP TABLE CLUB_FUTBOL CASCADE CONSTRAINTS;
DROP TABLE IDIOMA CASCADE CONSTRAINTS;
DROP TABLE ASOCIACION CASCADE CONSTRAINTS;
DROP TABLE ESCUELA CASCADE CONSTRAINTS;
DROP TABLE TRABAJADOR CASCADE CONSTRAINTS;
DROP TABLE GENERO CASCADE CONSTRAINTS;
DROP TABLE ESTADO_CIVIL CASCADE CONSTRAINTS;
DROP TABLE COMUNA CASCADE CONSTRAINTS;
DROP TABLE REGION CASCADE CONSTRAINTS;
DROP TABLE NACIONALIDAD CASCADE CONSTRAINTS;

DROP SEQUENCE SEQ_CLUB;

/*  ========================================================
    1.2:
    Creación de tablas:
    ======================================================== */

--Tabla Nacionalidad: 
--• La clave primaria de la tabla NACIONALIDAD debe generarse mediante una
--  columna IDENTITY, comenzar en 210 e incrementarse de 2 en 2. 
CREATE TABLE NACIONALIDAD
(
    id_nacion NUMBER(3) GENERATED ALWAYS AS IDENTITY
    (START WITH 210 INCREMENT BY 2),
    descripcion VARCHAR2(20) NOT NULL,

CONSTRAINT PK_NACIONALIDAD PRIMARY KEY (id_nacion)
);
    
-- Tabla Región:
CREATE TABLE REGION 
(
    id_region NUMBER(2) NOT NULL,
    nombre VARCHAR2(40) NOT NULL,

CONSTRAINT PK_REGION PRIMARY KEY (id_region)
);

--Tabla Comuna:
CREATE TABLE COMUNA
(
    id_comuna NUMBER(3) NOT NULL,
    cod_region NUMBER(2) NOT NULL,
    nombre VARCHAR2(40) NOT NULL,

CONSTRAINT PK_COMUNA PRIMARY KEY (id_comuna),
CONSTRAINT COMUNA_FK_REGION FOREIGN KEY (cod_region)
REFERENCES REGION (id_region)
);

-- Tabla Estado_Civil:
CREATE TABLE ESTADO_CIVIL
(
    id_estadocivil NUMBER(2) NOT NULL,
    descripcion VARCHAR2(20) DEFAULT 'Soltero/a',

CONSTRAINT PK_ESTADO_CIVIL PRIMARY KEY (id_estadocivil)
);

-- Tabla Genero:
CREATE TABLE GENERO
(
    id_genero CHAR(1) NOT NULL,
    descripcion VARCHAR2(20) NOT NULL,

CONSTRAINT PK_GENERO PRIMARY KEY (id_genero)
);

-- Tabla Trabajador:
CREATE TABLE TRABAJADOR 
(
    id_inscripcion NUMBER(9) NOT NULL,
    rut NUMBER(8) NOT NULL,
    dv VARCHAR2(1) NOT NULL,
    pri_nombre VARCHAR2(20) NOT NULL,
    seg_nombre VARCHAR2(20) DEFAULT 'No tiene',
    ap_paterno VARCHAR2(20) NOT NULL,
    ap_materno VARCHAR2(20) NOT NULL,
    sueldo_base NUMBER(7),
    fech_nac DATE NOT NULL,
    cod_genero CHAR(1) NOT NULL,
    cod_estadocivil NUMBER(2),
    email VARCHAR2(50) DEFAULT 'No tiene',
    telefono VARCHAR2(20) DEFAULT 'No tiene',
    direccion VARCHAR2(50) NOT NULL,
    cod_comuna NUMBER(3) NOT NULL,
    cod_nacion NUMBER(3) NOT NULL,

CONSTRAINT PK_TRABAJADOR PRIMARY KEY (id_inscripcion),
CONSTRAINT TRABAJADOR_EMAIL_UN UNIQUE (email),
CONSTRAINT TRABAJADOR_FK_COMUNA FOREIGN KEY (cod_comuna)
REFERENCES COMUNA (id_comuna),
CONSTRAINT TRABAJADOR_FK_NACIONALIDAD FOREIGN KEY (cod_nacion)
REFERENCES NACIONALIDAD (id_nacion),
CONSTRAINT TRABAJADOR_FK_ESTADO_CIVIL FOREIGN KEY (cod_estadocivil)
REFERENCES ESTADO_CIVIL (id_estadocivil),
CONSTRAINT TRABAJADOR_FK_GENERO FOREIGN KEY (cod_genero)
REFERENCES GENERO (id_genero)
);

-- Tabla Escuela:
CREATE TABLE ESCUELA 
(
    id_escuela NUMBER(4) NOT NULL,
    nombre VARCHAR2(20) NOT NULL,
    capacidad NUMBER(4) NOT NULL,
    fech_fundacion DATE NOT NULL,

CONSTRAINT PK_ESCUELA PRIMARY KEY (id_escuela)
);

-- Tabla Asociación:
CREATE TABLE ASOCIACION
(
    id_asociacion NUMBER(4) NOT NULL,
    nombre VARCHAR2(40)NOT NULL,
    fech_creacion DATE,
    tipo_asociacion CHAR(1),

CONSTRAINT PK_ASOCIACION PRIMARY KEY (id_asociacion),
--• La fecha de creación registrada en la tabla ASOCIACION debe ser igual
--  o posterior al 31 de diciembre de 1980. 
CONSTRAINT ASOCIACION_FECH_CREACION_CK
CHECK (fech_creacion >= DATE '1980-12-31')
);

--Tabla Idioma:
CREATE TABLE IDIOMA
(
    id_idioma NUMBER(2),
    nombre VARCHAR2(20),

CONSTRAINT PK_IDIOMA PRIMARY KEY (id_idioma)
);

--• El código de la tabla CLUB_FUTBOL debe generarse mediante una
--  secuencia que comience en 703 y se incremente de 4 en 4.
CREATE SEQUENCE SEQ_CLUB
START WITH 703
INCREMENT BY 4;

-- Tabla Club_Futbol:
CREATE TABLE CLUB_FUTBOL
(
    id_club NUMBER(10) NOT NULL,
    nombre VARCHAR2(20) NOT NULL,
    patrimonio_clp NUMBER (10) NOT NULL,
    direccion VARCHAR2(50),
    tipo_club VARCHAR2(20),
    
CONSTRAINT PK_CLUB_FUTBOL PRIMARY KEY (id_club),
--• El nombre del club registrado en la tabla CLUB_FUTBOL debe ser único.
CONSTRAINT CLUB_F_NOMBRE_UN UNIQUE (nombre)
);

-- Tabla Jugador_Futbol:
CREATE TABLE JUGADOR_FUTBOL
(
    cod_trabajador NUMBER(9) NOT NULL,
    posicion VARCHAR2(20) NOT NULL,
    total_premios NUMBER(3) NOT NULL,
    cod_club NUMBER(10) NOT NULL,
    nro_idiomas NUMBER(1) NOT NULL,
    dominio VARCHAR2(20) NOT NULL,
    cod_idioma NUMBER(2) NOT NULL,
    fech_contratacion DATE NOT NULL,
    fech_termino_cont DATE NOT NULL,
    cod_asociacion NUMBER(4) NOT NULL,
    cod_escuela NUMBER(4),
    
CONSTRAINT PK_JUGADOR_FUTBOL PRIMARY KEY (cod_trabajador),
CONSTRAINT JUGADOR_FK_TRABAJADOR FOREIGN KEY (cod_trabajador)
REFERENCES TRABAJADOR (id_inscripcion),
CONSTRAINT JUGADOR_FK_ASOCIACION FOREIGN KEY (cod_asociacion)
REFERENCES ASOCIACION (id_asociacion),
CONSTRAINT JUGADOR_FK_ESCUELA FOREIGN KEY (cod_escuela)
REFERENCES ESCUELA (id_escuela),
CONSTRAINT JUGADOR_FK_CLUB FOREIGN KEY (cod_club)
REFERENCES CLUB_FUTBOL (id_club)
);

-- Tabla Personal_Planta:
CREATE TABLE PERSONAL_PLANTA
(
    cod_trabajador NUMBER(9) NOT NULL,
    hrs_trabajadas NUMBER (3),
    valor_hrs_extras NUMBER(6),
    
CONSTRAINT PK_PERSONAL_PLANTA PRIMARY KEY (cod_trabajador),
CONSTRAINT PERSONAL_PLANTA_FK_TRABAJADOR FOREIGN KEY (cod_trabajador)
REFERENCES TRABAJADOR (id_inscripcion)
);



/*  ========================================================
                                      ↑↑ FIN DE LA FASE 1 ↑↑  
                                      
                                      
                                      
    --------------------------------------------------------
    Fase 2: Poblamiento de las tablas
    -------------------------------------------------------- 

    ======================================================== */
/*  ========================================================
    2.1:
    •   Se pueblan únicamente las siguientes tablas, en el siguiente
        orden para respetar sus dependencias:
    -NACIONALIDAD 
    -REGION 
    -COMUNA 
    -ASOCIACION 
    -CLUB_FUTBOL
    ======================================================== */
    
-- Tabla Nacionalidad:
INSERT INTO NACIONALIDAD (descripcion)
VALUES ('Chilena');
INSERT INTO NACIONALIDAD (descripcion)
VALUES ('Argentina');
INSERT INTO NACIONALIDAD (descripcion)
VALUES ('Peruana');
INSERT INTO NACIONALIDAD (descripcion)
VALUES ('Boliviana');
INSERT INTO NACIONALIDAD (descripcion)
VALUES ('Brasileña');

/*
Mostrar datos de nacionalidades:
SELECT * FROM NACIONALIDAD;
*/



-- Tabla Región:
INSERT INTO REGION (id_region, nombre)
VALUES(1, 'ARICA Y PARINACOTA Y TARAPACA');
INSERT INTO REGION (id_region, nombre)
VALUES(2, 'ANTOFAGASTA');
INSERT INTO REGION (id_region, nombre)
VALUES(3, 'ATACAMA Y COQUIMBO');
INSERT INTO REGION (id_region, nombre)
VALUES(5, 'VALPARAISO');
INSERT INTO REGION
VALUES (8, 'BIOBIO');
INSERT INTO REGION (id_region, nombre)
VALUES(13, 'METROPOLITANA');
INSERT INTO REGION
VALUES (16, 'NUBLE');

/*
Mostrar datos de regiones:
SELECT * FROM REGION;
*/



-- Tabla Comuna:
INSERT INTO COMUNA (id_comuna, cod_region, nombre)
VALUES(101, 13, 'Santiago');
INSERT INTO COMUNA (id_comuna, cod_region, nombre)
VALUES(102, 5, 'Valparaíso');
INSERT INTO COMUNA (id_comuna, cod_region, nombre)
VALUES(103, 8, 'Concepción');
INSERT INTO COMUNA (id_comuna, cod_region, nombre)
VALUES(104, 2, 'Antofagasta');
INSERT INTO COMUNA (id_comuna, cod_region, nombre)
VALUES(105, 13, 'Chillán');

/*
Mostrar datos de comunas:
SELECT * FROM COMUNA;
*/



-- Tabla Asociación:
INSERT INTO ASOCIACION (id_asociacion, nombre, fech_creacion, tipo_asociacion)
VALUES(25, 'Asociación de Fútbol de Santiago', '15-05-2001', 'P');
INSERT INTO ASOCIACION (id_asociacion, nombre, fech_creacion, tipo_asociacion)
VALUES(26, 'Asociación Nacional de Fútbol Amateur', '10-03-1998', 'A');
INSERT INTO ASOCIACION (id_asociacion, nombre, fech_creacion, tipo_asociacion)
VALUES(27, 'Asociación de Fútbol de Valparaíso', '21-07-1987', 'P');
INSERT INTO ASOCIACION (id_asociacion, nombre, fech_creacion, tipo_asociacion)
VALUES(28, 'Asociación de Fútbol de Concepción', '30-11-1995', 'A');
INSERT INTO ASOCIACION (id_asociacion, nombre, fech_creacion, tipo_asociacion)
VALUES(29, 'Asociación de Fútbol de Antofagasta', '25-06-2003', 'P');
INSERT INTO ASOCIACION (id_asociacion, nombre, fech_creacion, tipo_asociacion)
VALUES(30, 'Asociación de Fútbol de Temuco', '12-01-2010', 'A');
INSERT INTO ASOCIACION (id_asociacion, nombre, fech_creacion, tipo_asociacion)
VALUES(31, 'Asociación de Fútbol de Rancagua', '08-09-1999', 'P');
INSERT INTO ASOCIACION (id_asociacion, nombre, fech_creacion, tipo_asociacion)
VALUES(32, 'Asociación de Fútbol de Puerto Montt', '20-04-2005', 'A');
INSERT INTO ASOCIACION (id_asociacion, nombre, fech_creacion, tipo_asociacion)
VALUES(33, 'Asociación de Fútbol de La Serena', '14-08-2012', 'P');
INSERT INTO ASOCIACION (id_asociacion, nombre, fech_creacion, tipo_asociacion)
VALUES(34, 'Asociación de Fútbol de Chillán', '01-12-2018', 'A');

/*
Mostradr datos de asociación:
SELECT id_asociacion,
       nombre AS NOMBRE ASOCIACION,
       fech_creacion AS FECHA CREACION,
       tipo_asociacion AS TIPO ASOCIACION
FROM ASOCIACION;
*/



--Tabla Club_Futbol:
INSERT INTO CLUB_FUTBOL (id_club, nombre, patrimonio_clp, direccion, tipo_club)
VALUES(SEQ_CLUB.NEXTVAL, 
'Colo-Colo', 500000000, 'Av. Marathon 5300', 'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre, patrimonio_clp, direccion, tipo_club)
VALUES(SEQ_CLUB.NEXTVAL, 
'Universidad de Chile', 450000000, 'Av. El Parrón 0931', 'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre, patrimonio_clp, direccion, tipo_club)
VALUES(SEQ_CLUB.NEXTVAL, 
'Deportes Antofagasta', 180000000, 'Avenida Angamos 01606', 'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre, patrimonio_clp, direccion, tipo_club)
VALUES(SEQ_CLUB.NEXTVAL, 
'Huachipato', 220000000, 'Avenida Desiderio García 909', 'Profesional');
INSERT INTO CLUB_FUTBOL (id_club, nombre, patrimonio_clp, direccion, tipo_club)
VALUES(SEQ_CLUB.NEXTVAL, 
'Ñublense', 170000000, 'Avenida Pedro Aguirre Cerda 1003', 'Profesional');

/*Mostrar datos de clubes:
SELECT id_club,
       nombre AS NOMBRE CLUB,
       patrimonio_clp,
       direccion AS UBICACION CALLE,
       tipo_club
FROM CLUB_FUTBOL;      
*/



/*  ========================================================
                                      ↑↑ FIN DE LA FASE 2 ↑↑  
                                      
                                      
                                      
    --------------------------------------------------------
    Fase 3: Recuperación de datos
    -------------------------------------------------------- 

    ======================================================== */
/*  ========================================================
    INFORME 1: Asociaciones de fútbol profesional
    
    Listar las asociaciones que cumplan con las siguientes condiciones:
    •   Sean de tipo profesional (P). 
    •	Hayan sido creadas después del año 2000. 
    •	Se ordenen de manera descendente según su fecha de creación.
    ======================================================== */
SELECT
    'ID: ' || id_asociacion || ' * ' || nombre AS ASOCIACION,
    TO_CHAR (fech_creacion, 'DD-MM-YYYY') AS CREADA,
    tipo_asociacion AS TIPO
FROM ASOCIACION
WHERE tipo_asociacion = 'P'
AND (fech_creacion > DATE '2000-01-01')
ORDER BY fech_creacion DESC;

/*  ========================================================
                                  ↑↑ INFORME 1 FINALIZADO ↑↑ 
    ======================================================== */
    
/*  ========================================================
    4. INFORME 2: Patrimonio de clubes de fútbol
    
    Generar un informe con el patrimonio de los clubes expresado en pesos
    chilenos y su conversión a dólares, considerando un tipo de cambio de
    $955 por dólar.
    Incluir únicamente los clubes que cumplan con las siguientes condiciones:
    •	Su nombre contenga la letra a. 
    •	Su patrimonio sea superior a $200.000.000. 
    •	Sean de tipo profesional. 
    •	Los resultados se ordenen de manera descendente según el código del club.
    ======================================================== */

SELECT
    c.id_club AS "CLUB",
    c.nombre AS "NOMBRE CLUB",
    c.patrimonio_clp AS "PATRIMONIO EN PESOS",
    c.patrimonio_clp / 955 AS "PATRIMONIO EN DOLARES"
FROM CLUB_FUTBOL c
WHERE c.nombre LIKE '%a%'
  AND c.patrimonio_clp > 200000000
  AND c.tipo_club = 'Profesional'
ORDER BY c.id_club DESC;




/*  ========================================================
                                  ↑↑ INFORME 2 FINALIZADO ↑↑
                                  
                                  
                                  
                                      ↑↑ FIN DE LA FASE 3 ↑↑                                  

    ======================================================== */
    
/*  ========================================================
                      FIN DEL SCRIPT
    ======================================================== */