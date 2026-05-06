CREATE USER adminadmin WITH PASSWORD '1234';

CREATE USER gerente_calidad WITH PASSWORD '1234';

CREATE USER inspector WITH PASSWORD '1234';

CREATE USER compras WITH PASSWORD '1234';

CREATE USER auditor WITH PASSWORD '1234';

GRANT CONNECT ON DATABASE produccion TO gerente_calidad;

GRANT USAGE ON SCHEMA public TO gerente_calidad;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO gerente_calidad;

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO gerente_calidad;

GRANT SELECT, INSERT ON control_de_calidad TO inspector;

GRANT SELECT ON lote_materia_prima, materia_prima TO inspector;

GRANT SELECT, INSERT ON proveedor, orden_compra, lote_materia_prima, recepcion TO compras;

GRANT SELECT ON vista.lista TO auditor; 
