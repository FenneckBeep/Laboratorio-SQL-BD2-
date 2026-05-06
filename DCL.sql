CREATE USER adminadmin WITH PASSWORD '1234';

CREATE USER gerente_calidad WITH PASSWORD '1234';

CREATE USER inspector WITH PASSWORD '1234';

CREATE USER compras WITH PASSWORD '1234';

CREATE USER auditor WITH PASSWORD '1234';

GRANT ALL ON produccion TO gerente_calidad;

GRANT SELECT, INSERT ON control_calidad TO inspector,
      SELECT ON lotes, materias_primas TO inspector;

GRANT SELECT, INSERT ON proveedores, orden_compra, lote_materia_prima, recepcion TO compras;

GRANT SELECT ON vista.lista TO auditor; 
