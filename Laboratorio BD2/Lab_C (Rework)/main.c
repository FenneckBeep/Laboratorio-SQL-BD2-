/* Processed by ecpg (18.4 (Ubuntu 18.4-0ubuntu0.26.04.1)) */
/* These include files are added by the preprocessor */
#include <ecpglib.h>
#include <ecpgerrno.h>
#include <sqlca.h>
/* End of automatic include section */

#line 1 "main.pgc"
/*
 * main.pgc - Laboratorio 2 BD2 2026
 *
 * Para compilar haga:
 * ecpg main.pgc -o main.c
 * gcc main.c -o programa_calidad -lecpg
 *
 * Base de datos: lab02
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Area de comunicacion SQL */

#line 1 "/usr/include/postgresql/sqlca.h"
#ifndef POSTGRES_SQLCA_H
#define POSTGRES_SQLCA_H

#ifndef PGDLLIMPORT
#if  defined(WIN32) || defined(__CYGWIN__)
#define PGDLLIMPORT __declspec (dllimport)
#else
#define PGDLLIMPORT
#endif							/* __CYGWIN__ */
#endif							/* PGDLLIMPORT */

#define SQLERRMC_LEN	150

#ifdef __cplusplus
extern "C"
{
#endif

struct sqlca_t
{
	char		sqlcaid[8];
	long		sqlabc;
	long		sqlcode;
	struct
	{
		int			sqlerrml;
		char		sqlerrmc[SQLERRMC_LEN];
	}			sqlerrm;
	char		sqlerrp[8];
	long		sqlerrd[6];
	/* Element 0: empty						*/
	/* 1: OID of processed tuple if applicable			*/
	/* 2: number of rows processed				*/
	/* after an INSERT, UPDATE or				*/
	/* DELETE statement					*/
	/* 3: empty						*/
	/* 4: empty						*/
	/* 5: empty						*/
	char		sqlwarn[8];
	/* Element 0: set to 'W' if at least one other is 'W'	*/
	/* 1: if 'W' at least one character string		*/
	/* value was truncated when it was			*/
	/* stored into a host variable.             */

	/*
	 * 2: if 'W' a (hopefully) non-fatal notice occurred
	 */	/* 3: empty */
	/* 4: empty						*/
	/* 5: empty						*/
	/* 6: empty						*/
	/* 7: empty						*/

	char		sqlstate[5];
};

struct sqlca_t *ECPGget_sqlca(void);

#ifndef POSTGRES_ECPG_INTERNAL
#define sqlca (*ECPGget_sqlca())
#endif

#ifdef __cplusplus
}
#endif

#endif

#line 16 "main.pgc"


/* ================================================================
   DECLARACION DE VARIABLES HOST
   ================================================================ */
/* exec sql begin declare section */ //comienzo a declarar variables

    /* Conexion con la base de dato*/
       
         
         

    /* --- Opcion 1: Listar lotes pendientes --- */
        
       
       

    /* --- Opcion 2: Registrar control de calidad --- */
        
            /* YYYY-MM-DD           */
             /* HH:MM:SS             */
        
        
       
       
        /* excelente/normal/con daños/inaceptable, etc... */
       
        
                     
        
                  

    /* nombre empleado para mostrar */
       

    /* valor minimo/maximo para calcular estado */
     
     
     

    /* motivo rechazo */
       
       

    /* max id control */
        

    /* --- Opcion 3: Reporte por empleado --- */
       
       
        
        
        

    /* indicadores de null para campos opcionales */
           /* -1 = NULL, 0 = valor presente */


#line 24 "main.pgc"
 char db_target [] = "produccion@127.0.0.1:5433" ;
 
#line 25 "main.pgc"
 char db_user [] = "postgres" ;
 
#line 26 "main.pgc"
 char db_pass [] = "1234" ;
 
#line 29 "main.pgc"
 int h_id_lote ;
 
#line 30 "main.pgc"
 char h_nom_proveedor [ 101 ] ;
 
#line 31 "main.pgc"
 char h_fecha_recepcion [ 20 ] ;
 
#line 34 "main.pgc"
 int h_id_control ;
 
#line 35 "main.pgc"
 char h_fecha_control [ 20 ] ;
 
#line 36 "main.pgc"
 char h_hora_control [ 10 ] ;
 
#line 37 "main.pgc"
 int h_id_materia ;
 
#line 38 "main.pgc"
 int h_id_tipo_control ;
 
#line 39 "main.pgc"
 char h_valor_medido [ 51 ] ;
 
#line 40 "main.pgc"
 char h_unidad_medida [ 21 ] ;
 
#line 41 "main.pgc"
 char h_integridad_envase [ 30 ] ;
 
#line 42 "main.pgc"
 char h_descripcion [ 256 ] ;
 
#line 43 "main.pgc"
 int h_id_empleado ;
 
#line 44 "main.pgc"
 int h_id_estado ;
 
#line 45 "main.pgc"
 int h_id_rechazo ;
 
#line 46 "main.pgc"
 int h_hay_rechazo ;
 
#line 49 "main.pgc"
 char h_nom_empleado [ 101 ] ;
 
#line 52 "main.pgc"
 double h_val_min ;
 
#line 53 "main.pgc"
 double h_val_max ;
 
#line 54 "main.pgc"
 double h_val_num ;
 
#line 57 "main.pgc"
 char h_desc_rechazo [ 256 ] ;
 
#line 58 "main.pgc"
 char h_destino_rechazo [ 101 ] ;
 
#line 61 "main.pgc"
 int h_max_id_control ;
 
#line 64 "main.pgc"
 char h_fecha_desde [ 20 ] ;
 
#line 65 "main.pgc"
 char h_fecha_hasta [ 20 ] ;
 
#line 66 "main.pgc"
 int h_cant_aprobados ;
 
#line 67 "main.pgc"
 int h_cant_rechazados ;
 
#line 68 "main.pgc"
 int h_cant_observados ;
 
#line 71 "main.pgc"
 int h_ind_rechazo ;
/* exec sql end declare section */
#line 73 "main.pgc"
 //fin de declarar variables

/* ================================================================
   PROTOTIPOS
   ================================================================ */
void listarLotesPendientes();
void registrarControlCalidad();
void reporteControlesEmpleado();
int  limpiarBuffer();

/* ================================================================
   MAIN
   ================================================================ */
int main() {
    int opcion;

    /* Conectar a la base de datos lab02 */
    { ECPGconnect(__LINE__, 0, db_target , db_user , db_pass , NULL, 0); }
#line 90 "main.pgc"


    if (sqlca.sqlcode < 0) {
        fprintf(stderr, "Error al conectar a la base de datos '%s': %s\n",
                db_target, sqlca.sqlerrm.sqlerrmc);
        return EXIT_FAILURE;
    }

    printf("Conexion exitosa a la base de datos '%s'\n", db_target);

    /* Activar autocommit desactivado para manejar transacciones */
    { ECPGsetcommit(__LINE__, "off", NULL);}
#line 101 "main.pgc"


    /* Menu principal */
    while (1) {
        printf("\n============================================================\n");
        printf("         SISTEMA DE CONTROL DE CALIDAD - LAB 02            \n");
        printf("============================================================\n");
        printf("  1. Listar lotes para inspeccion / reinspeccion\n");
        printf("  2. Registrar control de calidad de un lote\n");
        printf("  3. Reporte de controles por empleado\n");
        printf("  4. Salir\n");
        printf("============================================================\n");
        printf("Seleccione una opcion: ");

        if (scanf("%d", &opcion) != 1) {
            printf("Ingrese un numero valido.\n");
            limpiarBuffer();
            continue;
        }
        limpiarBuffer();

        switch (opcion) {
            case 1:
                listarLotesPendientes();
                break;
            case 2:
                registrarControlCalidad();
                break;
            case 3:
                reporteControlesEmpleado();
                break;
            case 4:
                printf("Desconectando... OSTIA TIO FUNCIONO!\n");
                { ECPGdisconnect(__LINE__, "CURRENT");}
#line 134 "main.pgc"

                return EXIT_SUCCESS;
            default:
                printf("Opcion invalida. Intente de nuevo.\n");
        }
    }

    return 0;
}

/* ================================================================
   FUNCION AUXILIAR: limpiar buffer de entrada
   ================================================================ */
int limpiarBuffer() {
    int c;
    while ((c = getchar()) != '\n' && c != EOF);
    return 0;
}

/* ================================================================
   FUNCION 1: Listar lotes pendientes de inspeccion o reinspeccion
   
   Un lote requiere inspeccion si:
     a) Nunca tuvo un control de calidad (lote nuevo sin control)
     b) Su ultimo control quedo en estado 'Observado' (ID_Estado = 2)
        y necesita reinspeccion
   ================================================================ */
void listarLotesPendientes() {

    printf("\n--- Lotes que requieren inspeccion o reinspeccion ---\n");
    printf("%-10s | %-35s | %-15s\n", "ID Lote", "Proveedor", "Fecha Recepcion");
    printf("--------------------------------------------------------------------------\n");

    /* Nunca fue controlado *//* Ultimo control fue Observado (id_estado = 2) *//* declare cur_lotes_pendientes cursor for select l . id_lote , p . nombre , r . fecha_recepcion from lote_materia_prima l join recepcion r on l . id_recepcion = r . id_recepcion join orden_compra oc on l . id_compra = oc . id_compra join proveedor p on oc . id_proveedor = p . id_proveedor where not exists ( select 1 from control_de_calidad c where c . id_lote = l . id_lote ) or ( select c2 . id_estado from control_de_calidad c2 where c2 . id_lote = l . id_lote order by c2 . id_control desc limit 1 ) = 2 order by r . fecha_recepcion asc */
#line 192 "main.pgc"


    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "declare cur_lotes_pendientes cursor for select l . id_lote , p . nombre , r . fecha_recepcion from lote_materia_prima l join recepcion r on l . id_recepcion = r . id_recepcion join orden_compra oc on l . id_compra = oc . id_compra join proveedor p on oc . id_proveedor = p . id_proveedor where not exists ( select 1 from control_de_calidad c where c . id_lote = l . id_lote ) or ( select c2 . id_estado from control_de_calidad c2 where c2 . id_lote = l . id_lote order by c2 . id_control desc limit 1 ) = 2 order by r . fecha_recepcion asc", ECPGt_EOIT, ECPGt_EORT);}
#line 194 "main.pgc"


    if (sqlca.sqlcode < 0) {
        printf("Error al abrir cursor: %s\n", sqlca.sqlerrm.sqlerrmc);
        return;
    }

    int encontrados = 0;

    while (1) {
        { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "fetch cur_lotes_pendientes", ECPGt_EOIT, 
	ECPGt_int,&(h_id_lote),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,(h_nom_proveedor),(long)101,(long)1,(101)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,(h_fecha_recepcion),(long)20,(long)1,(20)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);}
#line 207 "main.pgc"


        if (sqlca.sqlcode == 100) break;  /* No hay mas filas */

        if (sqlca.sqlcode < 0) {
            printf("Error al leer datos: %s\n", sqlca.sqlerrm.sqlerrmc);
            break;
        }

        printf("%-10d | %-35s | %-15s\n",
               h_id_lote,
               h_nom_proveedor,
               h_fecha_recepcion);
        encontrados++;
    }

    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "close cur_lotes_pendientes", ECPGt_EOIT, ECPGt_EORT);}
#line 223 "main.pgc"


    if (encontrados == 0) {
        printf("No hay lotes pendientes de inspeccion.\n");
    } else {
        printf("--------------------------------------------------------------------------\n");
        printf("Total de lotes pendientes: %d\n", encontrados);
    }
}

/* ================================================================
   FUNCION 2: Registrar control de calidad de un lote

   El calculo del estado (Aprobado/Rechazado/Observado) se delega
   a la funcion almacenada fn_calcular_estado_lote(id_lote, id_tipo_control, valor_medido)
   que fue implementada en la base de datos con PL/pgSQL.

   Logica:
     - Aprobado  (1): valor dentro del rango [min, max] del tipo de control
     - Observado (2): valor cercano al limite (dentro de un 10% del margen)
     - Rechazado (3): valor fuera del rango
   ================================================================ */
void registrarControlCalidad() {
    /* exec sql begin declare section */
       
    
#line 247 "main.pgc"
 int existe_lote = 0 ;
/* exec sql end declare section */
#line 248 "main.pgc"

    
    char confirmacion[4];

    printf("\n--- Registrar Control de Calidad ---\n");

    /* 1. Pedir ID del lote */
    printf("ID del Lote a inspeccionar: ");
    if (scanf("%d", &h_id_lote) != 1) {
        printf("ID invalido.\n");
        limpiarBuffer();
        return;
    }
    limpiarBuffer();

    /* Verificar que el lote existe */
    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "select count ( 1 ) from lote_materia_prima where id_lote = $1 ", 
	ECPGt_int,&(h_id_lote),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, 
	ECPGt_int,&(existe_lote),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);}
#line 267 "main.pgc"


    if (existe_lote == 0) {
        printf("El lote %d no existe en la base de datos.\n", h_id_lote);
        return;
    }

    /* 2. Fecha y hora del control */
    printf("Fecha del control (YYYY-MM-DD): ");
    if (scanf("%19s", h_fecha_control) != 1) {
        printf("Fecha invalida.\n");
        limpiarBuffer();
        return;
    }
    limpiarBuffer();

    printf("Hora del control (HH:MM:SS): ");
    if (scanf("%9s", h_hora_control) != 1) {
        printf("Hora invalida.\n");
        limpiarBuffer();
        return;
    }
    limpiarBuffer();

    /* 3. Materia prima controlada */
    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "select id_materia from lote_materia_prima where id_lote = $1 ", 
	ECPGt_int,&(h_id_lote),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, 
	ECPGt_int,&(h_id_materia),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);}
#line 294 "main.pgc"


    /* Mostrar la materia prima del lote */
    {
        /* exec sql begin declare section */
         
        
#line 299 "main.pgc"
 char nom_mp [ 101 ] ;
/* exec sql end declare section */
#line 300 "main.pgc"

        
        { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "select nombre from materia_prima where id_materia = $1 ", 
	ECPGt_int,&(h_id_materia),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, 
	ECPGt_char,(nom_mp),(long)101,(long)1,(101)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);}
#line 304 "main.pgc"

        printf("Materia prima del lote: %s (ID: %d)\n", nom_mp, h_id_materia);
    }

    /* 4. Tipo de control */
    printf("ID Tipo de Control: ");
    if (scanf("%d", &h_id_tipo_control) != 1) {
        printf("Tipo invalido.\n");
        limpiarBuffer();
        return;
    }
    limpiarBuffer();

    /* 5. Valor observado */
    printf("Valor observado: ");
    if (scanf("%50s", h_valor_medido) != 1) {
        printf("Valor invalido.\n");
        limpiarBuffer();
        return;
    }
    limpiarBuffer();

    /* 6. Unidad de medida */
    h_ind_rechazo = -1; 
    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "select coalesce ( cu . unidad_de_medida , 'N/A' ) from tipo_control tc left join cuantitativo cu on tc . id_tipocontrol = cu . id_tipocontrol where tc . id_tipocontrol = $1 ", 
	ECPGt_int,&(h_id_tipo_control),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, 
	ECPGt_char,(h_unidad_medida),(long)21,(long)1,(21)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);}
#line 332 "main.pgc"


    printf("Unidad de medida detectada: %s\n", h_unidad_medida);

    /* 7. Integridad del envase/empaquetado */
    printf("Integridad del envase (excelente/normal/con danos/inaceptable): ");
    if (scanf("%29s", h_integridad_envase) != 1) {
        printf("Valor invalido.\n");
        limpiarBuffer();
        return;
    }
    limpiarBuffer();

    /* 8. Observaciones */
    printf("Observaciones: ");
    if (fgets(h_descripcion, sizeof(h_descripcion), stdin) == NULL) {
        strcpy(h_descripcion, "Sin observaciones");
    }
    h_descripcion[strcspn(h_descripcion, "\n")] = '\0';
    if (strlen(h_descripcion) == 0) {
        strcpy(h_descripcion, "Sin observaciones");
    }

    /* 9. Funcionario que realiza el control */
    printf("ID del Empleado/Funcionario: ");
    if (scanf("%d", &h_id_empleado) != 1) {
        printf("ID invalido.\n");
        limpiarBuffer();
        return;
    }
    limpiarBuffer();

    /* Verificar que el empleado existe */
    {
        /* exec sql begin declare section */
           
        
#line 367 "main.pgc"
 int existe_emp = 0 ;
/* exec sql end declare section */
#line 368 "main.pgc"

        
        { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "select count ( 1 ) from empleado where id_empleado = $1 ", 
	ECPGt_int,&(h_id_empleado),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, 
	ECPGt_int,&(existe_emp),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);}
#line 371 "main.pgc"

        if (existe_emp == 0) {
            printf("El empleado %d no existe.\n", h_id_empleado);
            return;
        }
        { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "select nombre1 || ' ' || apellido1 from empleado where id_empleado = $1 ", 
	ECPGt_int,&(h_id_empleado),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, 
	ECPGt_char,(h_nom_empleado),(long)101,(long)1,(101)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);}
#line 377 "main.pgc"

        printf("Funcionario: %s\n", h_nom_empleado);
    }

    /* Calcular estado */
    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "select fn_calcular_estado_lote ( $1  , $2  , $3  )", 
	ECPGt_int,&(h_id_lote),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(h_id_tipo_control),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,(h_valor_medido),(long)51,(long)1,(51)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, 
	ECPGt_int,&(h_id_estado),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);}
#line 383 "main.pgc"


    if (sqlca.sqlcode < 0) {
        printf("Error al calcular estado: %s\n", sqlca.sqlerrm.sqlerrmc);
        return;
    }

    printf("\n--- Resultado del calculo ---\n");
    if (h_id_estado == 1) {
        printf("Estado calculado: APROBADO\n");
    } else if (h_id_estado == 2) {
        printf("Estado calculado: OBSERVADO (requiere reinspeccion posterior)\n");
    } else {
        printf("Estado calculado: RECHAZADO\n");
    }

    /* Manejo del rechazo */
    h_id_rechazo  = 0;
    h_ind_rechazo = -1; 

    if (h_id_estado == 3) {
        printf("\nLote RECHAZADO. Debe registrar el motivo.\n");
        printf("Descripcion del motivo de rechazo: ");
        if (fgets(h_desc_rechazo, sizeof(h_desc_rechazo), stdin) == NULL) {
            strcpy(h_desc_rechazo, "Sin descripcion");
        }
        h_desc_rechazo[strcspn(h_desc_rechazo, "\n")] = '\0';

        printf("Destino del lote rechazado (devuelto al proveedor / descartado): ");
        if (scanf("%100s", h_destino_rechazo) != 1) {
            strcpy(h_destino_rechazo, "descartado");
        }
        limpiarBuffer();

        { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "select coalesce ( MAX ( id_rechazo ) , 0 ) + 1 from motivo_rechazo", ECPGt_EOIT, 
	ECPGt_int,&(h_id_rechazo),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);}
#line 419 "main.pgc"


        { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "insert into motivo_rechazo ( id_rechazo , descripcion_rechazo , destino ) values ( $1  , $2  , $3  )", 
	ECPGt_int,&(h_id_rechazo),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,(h_desc_rechazo),(long)256,(long)1,(256)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,(h_destino_rechazo),(long)101,(long)1,(101)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, ECPGt_EORT);}
#line 422 "main.pgc"


        if (sqlca.sqlcode < 0) {
            printf("Error al registrar motivo de rechazo: %s\n", sqlca.sqlerrm.sqlerrmc);
            return;
        }

        h_ind_rechazo = 0; 
        printf("Motivo de rechazo registrado (ID: %d).\n", h_id_rechazo);
    }

    /* Obtener siguiente ID de control */
    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "select coalesce ( MAX ( id_control ) , 0 ) + 1 from control_de_calidad", ECPGt_EOIT, 
	ECPGt_int,&(h_max_id_control),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);}
#line 436 "main.pgc"


    /* Insertar el control de calidad */
    {
        /* exec sql begin declare section */
         
        
#line 441 "main.pgc"
 char desc_completa [ 512 ] ;
/* exec sql end declare section */
#line 442 "main.pgc"


        snprintf(desc_completa, sizeof(desc_completa),
                 "Integridad envase: %s. %s",
                 h_integridad_envase,
                 h_descripcion);

        if (h_ind_rechazo == -1) {
            { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "insert into control_de_calidad ( id_control , descripcion , hora , fecha , valor_medido , id_tipocontrol , id_empleado , id_lote , id_estado , id_rechazo ) values ( $1  , $2  , $3  , $4  , $5  , $6  , $7  , $8  , $9  , null )", 
	ECPGt_int,&(h_max_id_control),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,(desc_completa),(long)512,(long)1,(512)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,(h_hora_control),(long)10,(long)1,(10)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,(h_fecha_control),(long)20,(long)1,(20)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,(h_valor_medido),(long)51,(long)1,(51)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(h_id_tipo_control),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(h_id_empleado),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(h_id_lote),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(h_id_estado),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, ECPGt_EORT);}
#line 456 "main.pgc"

        } else {
            { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "insert into control_de_calidad ( id_control , descripcion , hora , fecha , valor_medido , id_tipocontrol , id_empleado , id_lote , id_estado , id_rechazo ) values ( $1  , $2  , $3  , $4  , $5  , $6  , $7  , $8  , $9  , $10  )", 
	ECPGt_int,&(h_max_id_control),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,(desc_completa),(long)512,(long)1,(512)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,(h_hora_control),(long)10,(long)1,(10)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,(h_fecha_control),(long)20,(long)1,(20)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,(h_valor_medido),(long)51,(long)1,(51)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(h_id_tipo_control),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(h_id_empleado),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(h_id_lote),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(h_id_estado),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(h_id_rechazo),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, ECPGt_EORT);}
#line 464 "main.pgc"

        }
    }

    if (sqlca.sqlcode < 0) {
        printf("Error al registrar control: %s\n", sqlca.sqlerrm.sqlerrmc);
        { ECPGtrans(__LINE__, NULL, "rollback");}
#line 470 "main.pgc"

        return;
    }

    /* Insertar en la tabla TIENE */
    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "insert into tiene ( id_control , id_lote ) values ( $1  , $2  )", 
	ECPGt_int,&(h_max_id_control),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(h_id_lote),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, ECPGt_EORT);}
#line 476 "main.pgc"


    if (sqlca.sqlcode < 0) {
        printf("Error al registrar relacion tiene: %s\n", sqlca.sqlerrm.sqlerrmc);
        { ECPGtrans(__LINE__, NULL, "rollback");}
#line 480 "main.pgc"

        return;
    }

    { ECPGtrans(__LINE__, NULL, "commit");}
#line 484 "main.pgc"


    printf("\n¡Control de calidad registrado exitosamente! (ID Control: %d)\n",
           h_max_id_control);

    if (h_id_estado == 2) {
        printf("AVISO: El lote quedo en estado OBSERVADO y requerira una reinspeccion.\n");
    }
}

/* ================================================================
   FUNCION 3: Reporte de controles por empleado en rango de fechas

   Muestra funcionarios que realizaron controles entre dos fechas,
   con cantidad de: Aprobados, Rechazados, Observados.
   ================================================================ */
void reporteControlesEmpleado() {
    int encontrados = 0;

    printf("\n--- Reporte de Controles por Empleado ---\n");

    printf("Fecha de inicio (YYYY-MM-DD): ");
    if (scanf("%19s", h_fecha_desde) != 1) {
        printf("Fecha invalida.\n");
        limpiarBuffer();
        return;
    }
    limpiarBuffer();

    printf("Fecha de fin   (YYYY-MM-DD): ");
    if (scanf("%19s", h_fecha_hasta) != 1) {
        printf("Fecha invalida.\n");
        limpiarBuffer();
        return;
    }
    limpiarBuffer();

    printf("\nRango: %s  a  %s\n", h_fecha_desde, h_fecha_hasta);
    printf("\n%-30s | %-10s | %-10s | %-10s\n",
           "Funcionario", "Aprobados", "Rechazados", "Observados");
    printf("--------------------------------------------------------------------\n");

    /*
     * Consulta que agrupa controles por empleado en el rango dado.
     * Usa los IDs de estado: 1=Aprobado, 2=Observado, 3=Rechazado
     */
    /* declare cur_reporte cursor for select e . nombre1 || ' ' || e . apellido1 as nombre_completo , count ( case when c . id_estado = 1 then 1 end ) as aprobados , count ( case when c . id_estado = 3 then 1 end ) as rechazados , count ( case when c . id_estado = 2 then 1 end ) as observados from empleado e join control_de_calidad c on e . id_empleado = c . id_empleado where c . fecha between $1  and $2  group by e . id_empleado , e . nombre1 , e . apellido1 order by nombre_completo asc */
#line 540 "main.pgc"


    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "declare cur_reporte cursor for select e . nombre1 || ' ' || e . apellido1 as nombre_completo , count ( case when c . id_estado = 1 then 1 end ) as aprobados , count ( case when c . id_estado = 3 then 1 end ) as rechazados , count ( case when c . id_estado = 2 then 1 end ) as observados from empleado e join control_de_calidad c on e . id_empleado = c . id_empleado where c . fecha between $1  and $2  group by e . id_empleado , e . nombre1 , e . apellido1 order by nombre_completo asc", 
	ECPGt_char,(h_fecha_desde),(long)20,(long)1,(20)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_char,(h_fecha_hasta),(long)20,(long)1,(20)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EOIT, ECPGt_EORT);}
#line 542 "main.pgc"


    if (sqlca.sqlcode < 0) {
        printf("Error al generar reporte: %s\n", sqlca.sqlerrm.sqlerrmc);
        return;
    }

    while (1) {
        { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "fetch cur_reporte", ECPGt_EOIT, 
	ECPGt_char,(h_nom_empleado),(long)101,(long)1,(101)*sizeof(char), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(h_cant_aprobados),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(h_cant_rechazados),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, 
	ECPGt_int,&(h_cant_observados),(long)1,(long)1,sizeof(int), 
	ECPGt_NO_INDICATOR, NULL , 0L, 0L, 0L, ECPGt_EORT);}
#line 554 "main.pgc"


        if (sqlca.sqlcode == 100) break;

        if (sqlca.sqlcode < 0) {
            printf("Error al leer reporte: %s\n", sqlca.sqlerrm.sqlerrmc);
            break;
        }

        printf("%-30s | %-10d | %-10d | %-10d\n",
               h_nom_empleado,
               h_cant_aprobados,
               h_cant_rechazados,
               h_cant_observados);
        encontrados++;
    }

    { ECPGdo(__LINE__, 0, 1, NULL, 0, ECPGst_normal, "close cur_reporte", ECPGt_EOIT, ECPGt_EORT);}
#line 571 "main.pgc"


    if (encontrados == 0) {
        printf("No se encontraron controles en ese rango de fechas.\n");
    } else {
        printf("--------------------------------------------------------------------\n");
        printf("Total de empleados con controles en el periodo: %d\n", encontrados);
    }
}