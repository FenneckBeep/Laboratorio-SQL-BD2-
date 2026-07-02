-- ============================================================================
-- PRIMARY KEYS
-- ============================================================================

ALTER TABLE Proveedor
ADD CONSTRAINT PK_Proveedor PRIMARY KEY (ID_Proveedor);

ALTER TABLE Moneda
ADD CONSTRAINT PK_Moneda PRIMARY KEY (ID_Moneda);

ALTER TABLE Orden_Compra
ADD CONSTRAINT PK_Orden_Compra PRIMARY KEY (ID_Compra);

ALTER TABLE Tipo_Categoria
ADD CONSTRAINT PK_Tipo_Categoria PRIMARY KEY (ID_Categoria);

ALTER TABLE Materia_Prima
ADD CONSTRAINT PK_Materia_Prima PRIMARY KEY (ID_Materia);

ALTER TABLE Detalle
ADD CONSTRAINT PK_Detalle PRIMARY KEY (ID_Compra, ID_Materia);

ALTER TABLE Recepcion
ADD CONSTRAINT PK_Recepcion PRIMARY KEY (ID_Recepcion);

ALTER TABLE Lote_Materia_Prima
ADD CONSTRAINT PK_Lote_MateriaPrima PRIMARY KEY (ID_Lote);

ALTER TABLE Motivo_Rechazo
ADD CONSTRAINT PK_Motivo_Rechazo PRIMARY KEY (ID_Rechazo);

ALTER TABLE Empleado
ADD CONSTRAINT PK_Empleado PRIMARY KEY (ID_Empleado);

ALTER TABLE Estado
ADD CONSTRAINT PK_Estado PRIMARY KEY (ID_Estado);

ALTER TABLE Tipo_Control
ADD CONSTRAINT PK_Tipo_Control PRIMARY KEY (ID_TipoControl);

ALTER TABLE Cuantitativo
ADD CONSTRAINT PK_Cuantitativo PRIMARY KEY (ID_TipoControl);

ALTER TABLE Integridad_Envase
ADD CONSTRAINT PK_Integridad_Envase PRIMARY KEY (ID_Integridad);

ALTER TABLE Cualitativo
ADD CONSTRAINT PK_Cualitativo PRIMARY KEY (ID_TipoControl);

ALTER TABLE Control_De_Calidad
ADD CONSTRAINT PK_Control_De_Calidad PRIMARY KEY (ID_Control);

ALTER TABLE Lote_Produccion
ADD CONSTRAINT PK_Lote_Produccion PRIMARY KEY (ID_Lote_Produccion);

ALTER TABLE Utiliza
ADD CONSTRAINT PK_Utiliza PRIMARY KEY (ID_Lote_Produccion, ID_Lote);

ALTER TABLE Tiene
ADD CONSTRAINT PK_Tiene PRIMARY KEY (ID_Control, ID_Lote);


-- ============================================================================
-- FOREIGN KEYS
-- ============================================================================

ALTER TABLE Orden_Compra
ADD CONSTRAINT FK_OrdenCompra_Proveedor
FOREIGN KEY (ID_Proveedor)
REFERENCES Proveedor(ID_Proveedor);

ALTER TABLE Orden_Compra
ADD CONSTRAINT FK_OrdenCompra_Moneda
FOREIGN KEY (ID_Moneda)
REFERENCES Moneda(ID_Moneda);


ALTER TABLE Materia_Prima
ADD CONSTRAINT FK_MateriaPrima_Categoria
FOREIGN KEY (ID_Categoria)
REFERENCES Tipo_Categoria(ID_Categoria);


ALTER TABLE Detalle
ADD CONSTRAINT FK_Detalle_Compra
FOREIGN KEY (ID_Compra)
REFERENCES Orden_Compra(ID_Compra);

ALTER TABLE Detalle
ADD CONSTRAINT FK_Detalle_Materia
FOREIGN KEY (ID_Materia)
REFERENCES Materia_Prima(ID_Materia);


ALTER TABLE Lote_Materia_Prima
ADD CONSTRAINT FK_LoteMP_Materia
FOREIGN KEY (ID_Materia)
REFERENCES Materia_Prima(ID_Materia);

ALTER TABLE Lote_Materia_Prima
ADD CONSTRAINT FK_LoteMP_Recepcion
FOREIGN KEY (ID_Recepcion)
REFERENCES Recepcion(ID_Recepcion);

ALTER TABLE Lote_Materia_Prima
ADD CONSTRAINT FK_LoteMP_Compra
FOREIGN KEY (ID_Compra)
REFERENCES Orden_Compra(ID_Compra);


ALTER TABLE Cuantitativo
ADD CONSTRAINT FK_Cuantitativo_TipoControl
FOREIGN KEY (ID_TipoControl)
REFERENCES Tipo_Control(ID_TipoControl);


ALTER TABLE Cualitativo
ADD CONSTRAINT FK_Cualitativo_TipoControl
FOREIGN KEY (ID_TipoControl)
REFERENCES Tipo_Control(ID_TipoControl);

ALTER TABLE Cualitativo
ADD CONSTRAINT FK_Cualitativo_Integridad
FOREIGN KEY (ID_Integridad)
REFERENCES Integridad_Envase(ID_Integridad);


ALTER TABLE Control_De_Calidad
ADD CONSTRAINT FK_Control_TipoControl
FOREIGN KEY (ID_TipoControl)
REFERENCES Tipo_Control(ID_TipoControl);

ALTER TABLE Control_De_Calidad
ADD CONSTRAINT FK_Control_Empleado
FOREIGN KEY (ID_Empleado)
REFERENCES Empleado(ID_Empleado);

ALTER TABLE Control_De_Calidad
ADD CONSTRAINT FK_Control_Lote
FOREIGN KEY (ID_Lote)
REFERENCES Lote_Materia_Prima(ID_Lote);

ALTER TABLE Control_De_Calidad
ADD CONSTRAINT FK_Control_Estado
FOREIGN KEY (ID_Estado)
REFERENCES Estado(ID_Estado);

ALTER TABLE Control_De_Calidad
ADD CONSTRAINT FK_Control_Rechazo
FOREIGN KEY (ID_Rechazo)
REFERENCES Motivo_Rechazo(ID_Rechazo);


ALTER TABLE Utiliza
ADD CONSTRAINT FK_Utiliza_LoteProduccion
FOREIGN KEY (ID_Lote_Produccion)
REFERENCES Lote_Produccion(ID_Lote_Produccion);

ALTER TABLE Utiliza
ADD CONSTRAINT FK_Utiliza_LoteMP
FOREIGN KEY (ID_Lote)
REFERENCES Lote_Materia_Prima(ID_Lote);


ALTER TABLE Tiene
ADD CONSTRAINT FK_Tiene_Control
FOREIGN KEY (ID_Control)
REFERENCES Control_De_Calidad(ID_Control);

ALTER TABLE Tiene
ADD CONSTRAINT FK_Tiene_Lote
FOREIGN KEY (ID_Lote)
REFERENCES Lote_Materia_Prima(ID_Lote);


-- ============================================================================
-- TRIGGER LAB 1
-- Solo lotes aprobados pueden entrar a producción
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_check_lote_aprobado()
RETURNS TRIGGER AS $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Control_De_Calidad c
        WHERE c.ID_Lote = NEW.ID_Lote
          AND c.ID_Control = (
              SELECT MAX(c2.ID_Control)
              FROM Control_De_Calidad c2
              WHERE c2.ID_Lote = NEW.ID_Lote
          )
          AND c.ID_Estado = 1
    ) THEN
        RAISE EXCEPTION
        'El lote % no está aprobado en su último control',
        NEW.ID_Lote;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_validar_uso_lote
BEFORE INSERT OR UPDATE ON Utiliza
FOR EACH ROW
EXECUTE FUNCTION fn_check_lote_aprobado();

-- 
-- FUNCION: fn_calcular_estado_lote
--
-- Recibe: id_lote, id_tipo_control, valor_medido (como texto)
-- Retorna: INTEGER y esto puede retornar
--   1 = Aprobado
--   2 = Observado 
--   3 = Rechazado
--

--  - Si el tipo de control es CUANTITATIVO:
--       * Se intenta convertir valor_medido a numero
--       * Se compara con Umbral_Control para la materia prima del lote
--       * Si no hay umbral definido, devuelve Observado (2) por precaucion y porque me da la gana
--  - Si el tipo de control es CUALITATIVO:
--       * Si el valor es 'Conforme' o 'Negativo' -> Aprobado (1)
--       * Si el valor es 'Defectuoso' o esta en la 'Miseria (como Mexico)' -> Rechazado (3)
--       * Por cualquier otro cosa va -> Observado/enrevision (2)
-- 

CREATE OR REPLACE FUNCTION fn_calcular_estado_lote(
    p_id_lote        INT,
    p_id_tipocontrol INT,
    p_valor_medido   VARCHAR
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_id_materia   INT;
    v_val_min      NUMERIC(10,4);
    v_val_max      NUMERIC(10,4);
    v_valor_num    NUMERIC(10,4);
    v_margen       NUMERIC(10,4);
    v_es_cuant     BOOLEAN;
BEGIN
    -- Obtener la materia prima del lote
    SELECT id_materia INTO v_id_materia
    FROM lote_materia_prima
    WHERE id_lote = p_id_lote;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El lote % no existe', p_id_lote;
    END IF;

    -- Verificar si el tipo de control es cuantitativo
    SELECT EXISTS (
        SELECT 1 FROM cuantitativo WHERE id_tipocontrol = p_id_tipocontrol
    ) INTO v_es_cuant;

    -- -------------------------------------------------------
    -- CONTROL CUANTITATIVO
    -- -------------------------------------------------------
    IF v_es_cuant THEN

        -- Intentar convertir el valor a numero
        BEGIN
            -- Quitar posibles sufijos como '%' o letras
            v_valor_num := REGEXP_REPLACE(p_valor_medido, '[^0-9\.\-]', '', 'g')::NUMERIC(10,4);
        EXCEPTION WHEN OTHERS THEN
            -- No se pudo convertir -> Observado
            RETURN 2;
        END;

        -- Buscar umbral para esta materia prima y tipo de control
        SELECT valor_min, valor_max
        INTO v_val_min, v_val_max
        FROM umbral_control
        WHERE id_materia    = v_id_materia
          AND id_tipocontrol = p_id_tipocontrol;

        IF NOT FOUND THEN
            -- Sin umbral definido -> Observado por precaucion
            RETURN 2;
        END IF;

        -- Calcular margen del 10% del rango para zona "observada"
        v_margen := (v_val_max - v_val_min) * 0.10;

        -- Fuera del rango -> Rechazado
        IF v_valor_num < v_val_min OR v_valor_num > v_val_max THEN
            -- Dentro de la zona limítrofe (10% del margen) -> Observado
            IF v_valor_num >= (v_val_min - v_margen) AND v_valor_num <= (v_val_max + v_margen) THEN
                RETURN 2; -- Observado
            ELSE
                RETURN 3; -- Rechazado
            END IF;
        ELSE
            RETURN 1; -- Aprobado
        END IF;

    -- -------------------------------------------------------
    -- CONTROL CUALITATIVO
    -- -------------------------------------------------------
    ELSE
        IF UPPER(TRIM(p_valor_medido)) IN ('CONFORME', 'NEGATIVO', 'APROBADO', 'OK') THEN
            RETURN 1; -- Aprobado
        ELSIF UPPER(TRIM(p_valor_medido)) IN ('DEFECTUOSO', 'INACEPTABLE', 'POSITIVO', 'RECHAZADO') THEN
            RETURN 3; -- Rechazado
        ELSE
            RETURN 2; -- Observado / Pendiente
        END IF;
    END IF;

END;
$$;

-- ============================================================
-- TRIGGER: Verificar que lote en produccion este Aprobado
-- (ya existia en el lab 1, se mantiene / actualiza)
-- ============================================================

CREATE OR REPLACE FUNCTION fn_check_lote_aprobado()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar que el ultimo estado del lote sea Aprobado (1)
    IF NOT EXISTS (
        SELECT 1
        FROM control_de_calidad c
        WHERE c.id_lote = NEW.id_lote
          AND c.id_estado = 1
          AND c.id_control = (
              SELECT MAX(c2.id_control)
              FROM control_de_calidad c2
              WHERE c2.id_lote = NEW.id_lote
          )
    ) THEN
        RAISE EXCEPTION
            'El lote % no esta en estado Aprobado. No puede ser usado en produccion.',
            NEW.id_lote;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_uso_lote
BEFORE INSERT OR UPDATE ON utiliza
FOR EACH ROW
EXECUTE FUNCTION fn_check_lote_aprobado();

CREATE OR REPLACE PROCEDURE sp_registrar_control(
    p_id_lote          INT,
    p_fecha            DATE,
    p_hora             TIME,
    p_id_tipocontrol   INT,
    p_id_empleado      INT,
    p_valor_medido     VARCHAR,
    p_descripcion      TEXT,
    OUT p_id_control   INT,
    OUT p_estado       INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_nuevo_id   INT;
    v_estado     INT;
    v_id_rechazo INT := NULL;
BEGIN
    -- Calcular estado
    v_estado := fn_calcular_estado_lote(p_id_lote, p_id_tipocontrol, p_valor_medido);

    -- Obtener siguiente ID
    SELECT COALESCE(MAX(id_control), 0) + 1
    INTO v_nuevo_id
    FROM control_de_calidad;

    -- Insertar control
    INSERT INTO control_de_calidad
        (id_control, descripcion, hora, fecha, valor_medido,
         id_tipocontrol, id_empleado, id_lote, id_estado, id_rechazo)
    VALUES
        (v_nuevo_id, p_descripcion, p_hora, p_fecha, p_valor_medido,
         p_id_tipocontrol, p_id_empleado, p_id_lote, v_estado, v_id_rechazo);

    -- Insertar en tabla TIENE
    INSERT INTO tiene (id_control, id_lote)
    VALUES (v_nuevo_id, p_id_lote);

    p_id_control := v_nuevo_id;
    p_estado     := v_estado;
END;
$$;
