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

-- ============================================================================
-- FUNCION LAB 2: CALCULAR ESTADO AUTOMATICO
-- 1 = Aprobado
-- 2 = Observado
-- 3 = Rechazado
-- ============================================================================
-- Recibe:
--   p_id_lote        -> Lote a controlar
--   p_id_tipocontrol -> Tipo de control aplicado
--   p_valor_medido   -> Valor ingresado por el usuario (texto)
--
-- Retorna:
--   1 = Aprobado
--   2 = Observado
--   3 = Rechazado
--
-- LOGICA:
--
-- 1) Si el tipo de control es CUANTITATIVO:
--      * Se intenta convertir el valor ingresado a numero
--      * Se buscan Valor_Min y Valor_Max en la tabla Cuantitativo
--      * Si el valor esta dentro del rango -> Aprobado (1)
--      * Si esta ligeramente fuera (10% margen) -> Observado (2)
--      * Si esta muy fuera del rango -> Rechazado (3)
--      * Si no puede convertirse a numero -> Observado (2)
--
-- 2) Si el tipo de control es CUALITATIVO:
--      Valores aceptados como Aprobado:
--          'Conforme', 'Negativo', 'Aprobado', 'OK'
--
--      Valores aceptados como Rechazado:
--          'Defectuoso', 'Inaceptable', 'Positivo', 'Rechazado'
--
--      Cualquier otro valor:
--          Observado / Pendiente (2)
-- ============================================================================

CREATE OR REPLACE FUNCTION fn_calcular_estado_lote(
    p_id_lote        INT,
    p_id_tipocontrol INT,
    p_valor_medido   VARCHAR
)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_val_min    NUMERIC(10,4);
    v_val_max    NUMERIC(10,4);
    v_valor_num  NUMERIC(10,4);
    v_margen     NUMERIC(10,4);
    v_es_cuant   BOOLEAN;
BEGIN
    -- Verificar si el tipo de control es cuantitativo
    SELECT EXISTS (
        SELECT 1
        FROM Cuantitativo
        WHERE ID_TipoControl = p_id_tipocontrol
    )
    INTO v_es_cuant;

    -- =====================================================================
    -- CONTROL CUANTITATIVO
    -- =====================================================================
    IF v_es_cuant THEN

        BEGIN
            v_valor_num := REGEXP_REPLACE(
                p_valor_medido,
                '[^0-9\.\-]',
                '',
                'g'
            )::NUMERIC(10,4);

        EXCEPTION WHEN OTHERS THEN
            RETURN 2; -- Observado si no puede convertirse
        END;

       SELECT Valor_Min, Valor_Max
       INTO v_val_min, v_val_max
       FROM Cuantitativo
       WHERE ID_TipoControl = p_id_tipocontrol;

        IF NOT FOUND THEN
            RETURN 2;
        END IF;

        v_margen := (v_val_max - v_val_min) * 0.10;

        IF v_valor_num < v_val_min OR v_valor_num > v_val_max THEN

            IF v_valor_num >= (v_val_min - v_margen)
               AND v_valor_num <= (v_val_max + v_margen) THEN
                RETURN 2; -- Observado
            ELSE
                RETURN 3; -- Rechazado
            END IF;

        ELSE
            RETURN 1; -- Aprobado
        END IF;

    -- =====================================================================
    -- CONTROL CUALITATIVO
    -- =====================================================================
    ELSE
        IF UPPER(TRIM(p_valor_medido))
           IN ('CONFORME', 'NEGATIVO', 'APROBADO', 'OK') THEN
            RETURN 1;

        ELSIF UPPER(TRIM(p_valor_medido))
           IN ('DEFECTUOSO', 'INACEPTABLE', 'POSITIVO', 'RECHAZADO') THEN
            RETURN 3;

        ELSE
            RETURN 2;
        END IF;
    END IF;

END;
$$;


-- ============================================================================
-- PROCEDURE LAB 2: REGISTRAR CONTROL
-- ============================================================================
-- Funcion:
--   Registra un nuevo control de calidad automaticamente.
--
-- Proceso:
--   1) Llama a fn_calcular_estado_lote()
--   2) Determina si el control queda:
--          Aprobado / Observado / Rechazado
--   3) Genera automaticamente un nuevo ID_Control
--   4) Inserta el registro en Control_De_Calidad
--   5) Inserta la relacion correspondiente en Tiene
--
-- Salidas:
--   p_id_control -> ID generado del control
--   p_estado     -> Estado calculado
-- ============================================================================

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
    v_estado := fn_calcular_estado_lote(
        p_id_lote,
        p_id_tipocontrol,
        p_valor_medido
    );

    SELECT COALESCE(MAX(ID_Control), 0) + 1
    INTO v_nuevo_id
    FROM Control_De_Calidad;

    INSERT INTO Control_De_Calidad
    (
        ID_Control,
        Descripcion,
        Hora,
        Fecha,
        Valor_Medido,
        ID_TipoControl,
        ID_Empleado,
        ID_Lote,
        ID_Estado,
        ID_Rechazo
    )
    VALUES
    (
        v_nuevo_id,
        p_descripcion,
        p_hora,
        p_fecha,
        p_valor_medido,
        p_id_tipocontrol,
        p_id_empleado,
        p_id_lote,
        v_estado,
        v_id_rechazo
    );

    INSERT INTO Tiene (ID_Control, ID_Lote)
    VALUES (v_nuevo_id, p_id_lote);

    p_id_control := v_nuevo_id;
    p_estado := v_estado;
END;
$$;
