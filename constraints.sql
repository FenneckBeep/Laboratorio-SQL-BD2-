-- 1. Definición de Primary Keys
ALTER TABLE proveedor ADD PRIMARY KEY (id_proveedor);
ALTER TABLE tipo_categoria ADD PRIMARY KEY (id_categoria);
ALTER TABLE recepcion ADD PRIMARY KEY (id_recepcion);
ALTER TABLE motivo_rechazo ADD PRIMARY KEY (id_rechazado);
ALTER TABLE empleado ADD PRIMARY KEY (id_empleado);
ALTER TABLE estado ADD PRIMARY KEY (id_estado);
ALTER TABLE tipo_control ADD PRIMARY KEY (id_tipo_control);
ALTER TABLE lote_produccion ADD PRIMARY KEY (id_lote_produccion);
ALTER TABLE orden_compra ADD PRIMARY KEY (id_compra);
ALTER TABLE materia_prima ADD PRIMARY KEY (id_materia);
ALTER TABLE detalle ADD PRIMARY KEY (id_compra, id_materia);
ALTER TABLE lote_materia_prima ADD PRIMARY KEY (id_lote);
ALTER TABLE control_de_calidad ADD PRIMARY KEY (id_control);
ALTER TABLE tipo_de_control ADD PRIMARY KEY (id_materia, id_tipo_control);
ALTER TABLE utiliza ADD PRIMARY KEY (id_lote_produccion, id_lote);

-- 2. Definición de Foreign Keys
ALTER TABLE orden_compra ADD FOREIGN KEY (id_proveedor) REFERENCES proveedor(id_proveedor);

ALTER TABLE materia_prima ADD FOREIGN KEY (id_categoria) REFERENCES tipo_categoria(id_categoria);

ALTER TABLE detalle ADD FOREIGN KEY (id_compra) REFERENCES orden_compra(id_compra);
ALTER TABLE detalle ADD FOREIGN KEY (id_materia) REFERENCES materia_prima(id_materia);

ALTER TABLE lote_materia_prima ADD FOREIGN KEY (id_materia) REFERENCES materia_prima(id_materia);
ALTER TABLE lote_materia_prima ADD FOREIGN KEY (id_recepcion) REFERENCES recepcion(id_recepcion);
ALTER TABLE lote_materia_prima ADD FOREIGN KEY (id_compra) REFERENCES orden_compra(id_compra);
ALTER TABLE lote_materia_prima ADD FOREIGN KEY (id_rechazado) REFERENCES motivo_rechazo(id_rechazado);

ALTER TABLE control_de_calidad ADD FOREIGN KEY (id_tipo_control) REFERENCES tipo_control(id_tipo_control);
ALTER TABLE control_de_calidad ADD FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado);
ALTER TABLE control_de_calidad ADD FOREIGN KEY (id_lote) REFERENCES lote_materia_prima(id_lote);
ALTER TABLE control_de_calidad ADD FOREIGN KEY (id_estado) REFERENCES estado(id_estado);

ALTER TABLE tipo_de_control ADD FOREIGN KEY (id_materia) REFERENCES materia_prima(id_materia);
ALTER TABLE tipo_de_control ADD FOREIGN KEY (id_tipo_control) REFERENCES tipo_control(id_tipo_control);

ALTER TABLE utiliza ADD FOREIGN KEY (id_lote_produccion) REFERENCES lote_produccion(id_lote_produccion);
ALTER TABLE utiliza ADD FOREIGN KEY (id_lote) REFERENCES lote_materia_prima(id_lote);

-- Not Null

ALTER TABLE proveedor
ALTER COLUMN nombre SET NOT NULL;

ALTER TABLE proveedor
ALTER COLUMN pais SET NOT NULL;

ALTER TABLE tipo_categoria
ALTER COLUMN nombre SET NOT NULL;

ALTER TABLE recepcion
ALTER COLUMN fecha_recepcion SET NOT NULL;

ALTER TABLE motivo_rechazo
ALTER COLUMN descripcion SET NOT NULL;

ALTER TABLE estado
ALTER COLUMN nombre_estado SET NOT NULL;

ALTER TABLE tipo_control
ALTER COLUMN nombre SET NOT NULL;

ALTER TABLE lote_produccion
ALTER COLUMN fecha_elab SET NOT NULL;

ALTER TABLE orden_compra
ALTER COLUMN fecha SET NOT NULL;

ALTER TABLE orden_compra
ALTER COLUMN metodo_pago SET NOT NULL;

ALTER TABLE orden_compra
ALTER COLUMN total SET NOT NULL;

ALTER TABLE orden_compra
ALTER COLUMN id_proveedor SET NOT NULL;

ALTER TABLE materia_prima
ALTER COLUMN nombre SET NOT NULL;

ALTER TABLE materia_prima
ALTER COLUMN id_categoria SET NOT NULL;

ALTER TABLE detalle
ALTER COLUMN unidad_de_medida SET NOT NULL;

ALTER TABLE detalle
ALTER COLUMN cantidad SET NOT NULL;

ALTER TABLE detalle
ALTER COLUMN precio_unitario SET NOT NULL;

ALTER TABLE lote_materia_prima
ALTER COLUMN cantidad SET NOT NULL;

ALTER TABLE lote_materia_prima
ALTER COLUMN pais SET NOT NULL;

ALTER TABLE lote_materia_prima
ALTER COLUMN id_materia SET NOT NULL;

ALTER TABLE lote_materia_prima
ALTER COLUMN id_recepcion SET NOT NULL;

ALTER TABLE lote_materia_prima
ALTER COLUMN id_compra SET NOT NULL;

ALTER TABLE control_de_calidad
ALTER COLUMN hora SET NOT NULL;

ALTER TABLE control_de_calidad
ALTER COLUMN fecha SET NOT NULL;

ALTER TABLE control_de_calidad
ALTER COLUMN aprobado SET NOT NULL;

ALTER TABLE control_de_calidad
ALTER COLUMN id_tipo_control SET NOT NULL;

ALTER TABLE control_de_calidad
ALTER COLUMN id_empleado SET NOT NULL;

ALTER TABLE control_de_calidad
ALTER COLUMN id_lote SET NOT NULL;

ALTER TABLE utiliza
ALTER COLUMN cantidad SET NOT NULL;
