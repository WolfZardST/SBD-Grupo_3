USE APOYAME;

DROP VIEW IF EXISTS GRUPOS_MIEMBROS;
DROP VIEW IF EXISTS GRUPOS_TEMAS;
DROP VIEW IF EXISTS CATALOGOS_GRUPOS;
DROP VIEW IF EXISTS REUNIONES_GRUPOS;
DROP VIEW IF EXISTS RECURSOS_SECCIONES;

CREATE VIEW GRUPOS_MIEMBROS
AS SELECT G.ID_GRUPO AS ID, G.NOMBRE AS GRUPO, COUNT(M.ID_USUARIO) AS PARTICIPANTES, G.CATEGORIA
FROM GRUPO G
LEFT JOIN MIEMBROGRUPO M
ON G.ID_GRUPO = M.ID_GRUPO
WHERE M.ESTADO = 'ACTIVO'
GROUP BY G.NOMBRE;

CREATE VIEW GRUPOS_TEMAS
AS SELECT G.NOMBRE AS GRUPO, G.CATEGORIA, COUNT(T.ID_GRUPO) AS TEMAS
FROM GRUPO G
LEFT JOIN TEMA T
ON T.ID_GRUPO = G.ID_GRUPO
GROUP BY G.NOMBRE;

CREATE VIEW CATALOGOS_GRUPOS
AS SELECT C.ID_CATALOGO AS ID, C.TITULO_SECCION AS SECCION, G.ID_GRUPO AS GRUPO, G.CATEGORIA
FROM GRUPO G
JOIN CATALOGO C
ON G.ID_GRUPO = C.ID_GRUPO
ORDER BY G.ID_GRUPO;

CREATE VIEW REUNIONES_GRUPOS AS
SELECT G.ID_GRUPO, U.NICKNAME AS ORGANIZADOR, R.ID_REUNION, 'VIRTUAL' AS TIPO, R.FECHA_HORA, R.PLATAFORMA AS PLATAFORMA_UBICACION
FROM REUNIONVIRTUAL R
JOIN TEMA T
ON R.ID_TEMA = T.ID_TEMA
JOIN GRUPO G
ON T.ID_GRUPO = G.ID_GRUPO
JOIN USUARIO U
ON U.ID_USUARIO = R.ID_ORGANIZADOR
UNION ALL
SELECT G.ID_GRUPO, U.NICKNAME AS ORGANIZADOR, R.ID_REUNION, 'PRESENCIAL' AS TIPO, R.FECHA_HORA, R.UBICACION AS PLATAFORMA_UBICACION
FROM REUNIONPRESENCIAL R
JOIN TEMA T
ON R.ID_TEMA = T.ID_TEMA
JOIN GRUPO G
ON T.ID_GRUPO = G.ID_GRUPO
JOIN USUARIO U
ON U.ID_USUARIO = R.ID_ORGANIZADOR
ORDER BY FECHA_HORA;

CREATE VIEW RECURSOS_SECCIONES AS
SELECT C.ID_CATALOGO AS ID_SECCION, 'ARTÍCULO' AS TIPO, A.ID_ARTICULO AS ID_RECURSO, A.TITULO 
FROM CATALOGO C
JOIN ARTICULO A
ON C.ID_CATALOGO = A.ID_CATALOGO
UNION ALL
SELECT C.ID_CATALOGO AS ID_SECCION, 'VÍDEO' AS TIPO, V.ID_VIDEO AS ID_RECURSO, V.TITULO 
FROM CATALOGO C
JOIN VIDEO V
ON C.ID_CATALOGO = V.ID_CATALOGO;