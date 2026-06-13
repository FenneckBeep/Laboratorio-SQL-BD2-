CREATE USER adminadmin WITH PASSWORD '1234';

CREATE USER gerente_calidad WITH PASSWORD '1234';

CREATE USER inspector WITH PASSWORD '1234';

CREATE USER compras WITH PASSWORD '1234';

CREATE USER auditor WITH PASSWORD '1234';

-- Permisos de conexión
GRANT CONNECT ON DATABASE produccion TO gerente_calidad;
GRANT CONNECT ON DATABASE produccion TO inspector;
GRANT CONNECT ON DATABASE produccion TO compras;
GRANT CONNECT ON DATABASE produccion TO auditor;

-- Uso del esquema public
GRANT USAGE ON SCHEMA public TO gerente_calidad;
GRANT USAGE ON SCHEMA public TO inspector;
GRANT USAGE ON SCHEMA public TO compras;
GRANT USAGE ON SCHEMA public TO auditor;

-- Gerente calidad: acceso total
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO gerente_calidad;

GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO gerente_calidad;

-- Inspector
GRANT SELECT, INSERT ON control_de_calidad TO inspector;

GRANT SELECT ON lote_materia_prima, materia_prima TO inspector;

-- Compras
GRANT SELECT, INSERT ON proveedor, orden_compra, lote_materia_prima, recepcion TO compras;

-- Auditor
GRANT SELECT ON informe_2025 TO auditor;
