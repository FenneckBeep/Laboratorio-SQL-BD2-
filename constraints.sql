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
ALTER TABLE lote_materia_prima ADD FOREIGN KEY (id_rechazo) REFERENCES motivo_rechazo(id_rechazado);

ALTER TABLE control_de_calidad ADD FOREIGN KEY (id_tipo_control) REFERENCES tipo_control(id_tipo_control);
ALTER TABLE control_de_calidad ADD FOREIGN KEY (id_empleado) REFERENCES empleado(id_empleado);
ALTER TABLE control_de_calidad ADD FOREIGN KEY (id_lote) REFERENCES lote_materia_prima(id_lote);
ALTER TABLE control_de_calidad ADD FOREIGN KEY (id_estado) REFERENCES estado(id_estado);

ALTER TABLE tipo_de_control ADD FOREIGN KEY (id_materia) REFERENCES materia_prima(id_materia);
ALTER TABLE tipo_de_control ADD FOREIGN KEY (id_tipo_control) REFERENCES tipo_control(id_tipo_control);

ALTER TABLE utiliza ADD FOREIGN KEY (id_lote_produccion) REFERENCES lote_produccion(id_lote_produccion);
ALTER TABLE utiliza ADD FOREIGN KEY (id_lote) REFERENCES lote_materia_prima(id_lote);