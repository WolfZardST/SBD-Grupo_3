USE APOYAME;

DROP TRIGGER IF EXISTS usuarioAgregaEntrada;
DROP TRIGGER IF EXISTS usuarioEliminaEntrada;
DROP TRIGGER IF EXISTS usuarioAbandonaGrupo;

DELIMITER //

CREATE TRIGGER usuarioAgregaEntrada 
AFTER INSERT ON ENTRADA 
FOR EACH ROW

BEGIN
	UPDATE TEMA
		SET NUM_ENTRADAS = NUM_ENTRADAS + 1
	WHERE ID_TEMA = NEW.ID_TEMA;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER usuarioEliminaEntrada
AFTER DELETE ON ENTRADA
FOR EACH ROW

BEGIN
	UPDATE TEMA
		SET NUM_ENTRADAS = NUM_ENTRADAS - 1
	WHERE ID_TEMA = OLD.ID_TEMA;
END //

DELIMITER ;

DELIMITER //

CREATE TRIGGER usuarioAbandonaGrupo
AFTER UPDATE ON MIEMBROGRUPO
FOR EACH ROW

BEGIN
	IF NEW.ESTADO = 'INACTIVO'
    THEN
		
        DELETE FROM ASISTENCIAREUNIONVIRTUAL
        WHERE ID_REUNION IN 
			(SELECT ID_REUNION 
             FROM REUNIONVIRTUAL
             JOIN TEMA ON TEMA.ID_TEMA = REUNIONVIRTUAL.ID_TEMA
             JOIN GRUPO ON GRUPO.ID_GRUPO = TEMA.ID_GRUPO
             WHERE GRUPO.ID_GRUPO = NEW.ID_GRUPO 
             AND ID_ASISTENTE = NEW.ID_USUARIO);
        
        DELETE FROM ASISTENCIAREUNIONPRESENCIAL
        WHERE ID_REUNION IN 
			(SELECT ID_REUNION 
             FROM REUNIONPRESENCIAL
             JOIN TEMA ON TEMA.ID_TEMA = REUNIONPRESENCIAL.ID_TEMA
             JOIN GRUPO ON GRUPO.ID_GRUPO = TEMA.ID_GRUPO
             WHERE GRUPO.ID_GRUPO = NEW.ID_GRUPO 
             AND ID_ASISTENTE = NEW.ID_USUARIO);
        
	END IF;
    
END //

DELIMITER ;

-- SHOW TRIGGERS;