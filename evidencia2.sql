-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 15-09-2025 a las 06:40:42
-- Versión del servidor: 10.4.27-MariaDB
-- Versión de PHP: 8.0.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `evidencia2`
--

DELIMITER $$
--
-- Procedimientos para crear un docente nuevo
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_docente_create` (IN `p_numero_documento` VARCHAR(20),-- Documento del docente 
  IN `p_nombres` VARCHAR(120),-- Nombre completo del docente
  IN `p_titulo` VARCHAR(120),-- Titulo academico
  IN `p_anios` INT,  -- Años de experiencia
  IN `p_direccion` VARCHAR(180),-- Direccion del docente
  IN `p_tipo` VARCHAR(40),-- Tipo de docente (Planta, catedra, etc.)
  OUT `p_docente_id` INT) -- Variable de salida par obtener el ID insertado
  BEGIN    -- Insertar un nuevo registro en la tabla  docentes
  INSERT INTO docente (numero_documento, nombres, titulo, anios_experiencia, direccion, tipo_docente)
  VALUES (p_numero_documento, p_nombres, p_titulo, p_anios, p_direccion, p_tipo);
-- REtornar el ID generado automaticamente
  SET p_docente_id = LAST_INSERT_ID();
END$$
-- Procedimeinto para eliminar un docente por su ID
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_docente_delete` (IN `p_docente_id` INT)   BEGIN
  DELETE FROM docente WHERE docente_id = p_docente_id;-- Elimina el docente con el ID especifico
  SELECT ROW_COUNT() AS filas_afectadas; -- Retorna cuantas filas fueron afectadas (1 si se elemino, 0 si no se encontro)
END$$
-- Procedimiento para consultar un docente especifico ID
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_docente_read` (IN `p_docente_id` INT)   BEGIN
  SELECT * FROM docente WHERE docente_id = p_docente_id; -- ID docente a consultar
END$$
-- Retorna los datos del docente especifico
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_docente_read_all` (IN `p_offset` INT, IN `p_limit` INT)   BEGIN
-- Listar todos los docentes con paginacion
  SELECT * FROM docente ORDER BY docente_id LIMIT p_limit OFFSET p_offset;  
END$$
 -- Actualizar los datos de un docente
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_docente_update` (IN `p_docente_id` INT, -- ID del docente a actualizar
  IN `p_numero_documento` VARCHAR(20),-- Nuevo numero de documento
  IN `p_nombres` VARCHAR(120),-- Nuevos nombres
  IN `p_titulo` VARCHAR(120),-- Nuevo titulo
  IN `p_anios` INT,-- Nuevos años de experiencia
  IN `p_direccion` VARCHAR(180), -- Direccion nueva 
  IN `p_tipo` VARCHAR(40))  -- Nuevo tipo de docente 
  BEGIN
  -- Actualizar docente con los nuevos  datos
  UPDATE docente
     SET numero_documento  = p_numero_documento,
         nombres           = p_nombres,
         titulo            = p_titulo,
         anios_experiencia = p_anios,
         direccion         = p_direccion,
         tipo_docente      = p_tipo
   WHERE docente_id = p_docente_id;-- clausula para filtrar  datos
-- Retorna cuantas filas fueron afectadas o si no cambia ninguna
  SELECT ROW_COUNT() AS filas_afectadas;
END$$
-- Procedimiento para crear un nuevo proyecto
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proyecto_create` (IN `p_nombre` VARCHAR(120),-- Nombre del proyecto
  IN `p_descripcion` VARCHAR(400),-- Descripcion del proyecto
  IN `p_fecha_inicial` DATE,-- fecha de inicio
  IN `p_fecha_final` DATE,-- fecha de finalizacion 
  IN `p_presupuesto` DECIMAL(12,2),-- presupuesto asignado
  IN `p_horas` INT, -- Horas estimadas
  IN `p_docente_jefe_id` INT,-- ID docente jefe
  OUT `p_proyecto_id` INT)   -- ID del nuevo proyecto insertado
  BEGIN                    -- Inserta un nuevo proyecto en la tabla 
  INSERT INTO proyecto (nombre, descripcion, fecha_inicial, fecha_final, presupuesto, horas, docente_id_jefe)
  VALUES (p_nombre, p_descripcion, p_fecha_inicial, p_fecha_final, p_presupuesto, p_horas, p_docente_jefe_id);
-- Retorna el ID del proyecto insertado
  SET p_proyecto_id = LAST_INSERT_ID();
END$$
-- procedimiento para eliminar un proyecto por su ID
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proyecto_delete` (IN `p_proyecto_id` INT)   BEGIN
  DELETE FROM proyecto WHERE proyecto_id = p_proyecto_id;-- Elimina el proyecto
  SELECT ROW_COUNT() AS filas_afectadas;-- Retorna cuantas filas fueron afectadas
END$$
-- Procedimientos donde se consulta un proyecto por su ID
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proyecto_read` (IN `p_proyecto_id` INT)   BEGIN
  SELECT * FROM proyecto WHERE proyecto_id = p_proyecto_id; -- Retorna todos los datos del proyecto
END$$
-- Procedimiento para listar todos los proyectos con informacion del docente jefe
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proyecto_read_all` (IN `p_offset` INT, IN `p_limit` INT)   BEGIN
  SELECT p.*, d.nombres AS jefe_nombre  -- lista los proyectos junto con  el nombre del docente jefe, con paginacion
    FROM proyecto p
    JOIN docente  d ON d.docente_id = p.docente_id_jefe
   ORDER BY p.proyecto_id
   LIMIT p_limit OFFSET p_offset;
END$$
-- Procedimiento para actualizar los datos de un proyecto
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_proyecto_update` (IN `p_proyecto_id` INT, IN `p_nombre` VARCHAR(120), IN `p_descripcion` VARCHAR(400), IN `p_fecha_inicial` DATE, IN `p_fecha_final` DATE, IN `p_presupuesto` DECIMAL(12,2), IN `p_horas` INT, IN `p_docente_jefe_id` INT)   BEGIN
  UPDATE proyecto    -- Atualiza los datos del proyecto
     SET nombre          = p_nombre,
         descripcion     = p_descripcion,
         fecha_inicial   = p_fecha_inicial,
         fecha_final     = p_fecha_final,
         presupuesto     = p_presupuesto,
         horas           = p_horas,
         docente_id_jefe = p_docente_jefe_id
   WHERE proyecto_id     = p_proyecto_id;
-- Retorna cuantas filas se actualizaron
  SELECT ROW_COUNT() AS filas_afectadas;
END$$

-- -- Funciones calcula el presupuesto  por hora de un proyecto especifico

CREATE DEFINER=`root`@`localhost` FUNCTION `fn_presupuesto_hora` (`p_proyecto_id` INT) RETURNS DECIMAL(12,2) DETERMINISTIC READS SQL DATA BEGIN
  DECLARE v_pres DECIMAL(12,2);
  DECLARE v_horas INT;
-- obtiene el presuspuesto y las horas del proyecto
  SELECT presupuesto, horas
    INTO v_pres, v_horas
    FROM proyecto
   WHERE proyecto_id = p_proyecto_id;
-- si no hay  datos o las horas son 0 retorna NULL para evitar dividir por 0
  IF v_pres IS NULL OR v_horas IS NULL OR v_horas = 0 THEN
    RETURN NULL;
  END IF;
-- calcula y retorna
  RETURN ROUND(v_pres / v_horas, 2);
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `copia_actualizados_tablauu`
--

CREATE TABLE `copia_actualizados_tablauu` (
  `id_audit` bigint(20) NOT NULL,
  `tabla` varchar(64) NOT NULL,
  `pk_valor` varchar(64) NOT NULL,
  `usuario` varchar(100) NOT NULL DEFAULT current_user(),
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `antes` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`antes`)),
  `despues` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`despues`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `copia_actualizados_tablauu`
--

INSERT INTO `copia_actualizados_tablauu` (`id_audit`, `tabla`, `pk_valor`, `usuario`, `fecha`, `antes`, `despues`) VALUES
(1, 'docente', '1', 'root@localhost', '2025-09-15 04:35:40', '{\"docente_id\": 1, \"numero_documento\": \"CC3001\", \"nombres\": \"Ana Pérez\", \"titulo\": \"MSc. Sistemas\", \"anios_experiencia\": 1, \"direccion\": \"Calle 10 #1-10\", \"tipo_docente\": \"Planta\"}', '{\"docente_id\": 1, \"numero_documento\": \"CC3001\", \"nombres\": \"Ana Pérez\", \"titulo\": \"MSc. Sistemas\", \"anios_experiencia\": 2, \"direccion\": \"Calle 10 #1-10\", \"tipo_docente\": \"Planta\"}');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `copia_eliminados_tabladd`
--

CREATE TABLE `copia_eliminados_tabladd` (
  `id_audit` bigint(20) NOT NULL,
  `tabla` varchar(64) NOT NULL,
  `pk_valor` varchar(64) NOT NULL,
  `usuario` varchar(100) NOT NULL DEFAULT current_user(),
  `fecha` timestamp NOT NULL DEFAULT current_timestamp(),
  `registro` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL CHECK (json_valid(`registro`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docente`  Esta tabla almacena los docentes de la institucion
--

CREATE TABLE `docente` (
  `docente_id` int(11) NOT NULL,
  `numero_documento` varchar(20) NOT NULL,
  `nombres` varchar(120) NOT NULL,
  `titulo` varchar(120) DEFAULT NULL,
  `anios_experiencia` int(11) NOT NULL DEFAULT 0,
  `direccion` varchar(180) DEFAULT NULL,
  `tipo_docente` varchar(40) DEFAULT NULL
) ;

--
-- Volcado de datos para la tabla `docente`
--

INSERT INTO `docente` (`docente_id`, `numero_documento`, `nombres`, `titulo`, `anios_experiencia`, `direccion`, `tipo_docente`) VALUES
(1, 'CC3001', 'Ana Pérez', 'MSc. Sistemas', 2, 'Calle 10 #1-10', 'Planta'),
(2, 'CC3002', 'Luis Gómez', 'Ing. Sistemas', 4, 'Cra 11 #2-11', 'Catedra'),
(3, 'CC3003', 'Carla Ríos', 'PhD. Computación', 7, 'Calle 12 #3-12', 'Planta'),
(4, 'CC3004', 'Juan Toro', 'MSc. Datos', 10, 'Cra 13 #4-13', 'Catedra'),
(5, 'CC3005', 'Marta López', 'Lic. Matemáticas', 13, 'Calle 14 #5-14', 'Planta'),
(6, 'CC3006', 'Pedro Ramírez', 'MSc. Software', 16, 'Cra 15 #6-15', 'Catedra'),
(7, 'CC3007', 'Lucía Hernández', 'PhD. Educación', 19, 'Calle 16 #7-16', 'Planta'),
(8, 'CC3008', 'Sergio Martínez', 'Esp. Analítica', 22, 'Cra 17 #8-17', 'Catedra'),
(9, 'CC3009', 'Elena Vargas', 'MSc. Estadística', 25, 'Calle 18 #9-18', 'Planta'),
(10, 'CC3010', 'Andrés Castro', 'Ing. Electrónica', 3, 'Cra 19 #10-19', 'Catedra'),
(11, 'CC3011', 'Paula Suárez', 'MSc. Sistemas', 6, 'Calle 20 #1-20', 'Planta'),
(12, 'CC3012', 'Diego Moreno', 'Ing. Sistemas', 9, 'Cra 21 #2-21', 'Catedra'),
(13, 'CC3013', 'Sofía Santos', 'PhD. Computación', 12, 'Calle 22 #3-22', 'Planta'),
(14, 'CC3014', 'Javier León', 'MSc. Datos', 15, 'Cra 23 #4-23', 'Catedra'),
(15, 'CC3015', 'Valeria Rodríguez', 'Lic. Matemáticas', 18, 'Calle 24 #5-24', 'Planta'),
(16, 'CC3016', 'Camilo Salazar', 'MSc. Software', 21, 'Cra 25 #6-25', 'Catedra'),
(17, 'CC3017', 'Daniela Acosta', 'PhD. Educación', 24, 'Calle 26 #7-26', 'Planta'),
(18, 'CC3018', 'Héctor Rojas', 'Esp. Analítica', 2, 'Cra 27 #8-27', 'Catedra'),
(19, 'CC3019', 'Nadia Navarro', 'MSc. Estadística', 5, 'Calle 28 #9-28', 'Planta'),
(20, 'CC3020', 'Felipe Campos', 'Ing. Electrónica', 8, 'Cra 29 #10-29', 'Catedra'),
(21, 'CC3021', 'Laura Méndez', 'MSc. Sistemas', 11, 'Calle 30 #1-30', 'Planta'),
(22, 'CC3022', 'Miguel Guerrero', 'Ing. Sistemas', 14, 'Cra 31 #2-31', 'Catedra'),
(23, 'CC3023', 'Carolina Vega', 'PhD. Computación', 17, 'Calle 32 #3-32', 'Planta'),
(24, 'CC3024', 'Tomás Lara', 'MSc. Datos', 20, 'Cra 33 #4-33', 'Catedra'),
(25, 'CC3025', 'Gabriela Romero', 'Lic. Matemáticas', 23, 'Calle 34 #5-34', 'Planta'),
(26, 'CC3026', 'Ricardo Ibarra', 'MSc. Software', 1, 'Cra 35 #6-35', 'Catedra'),
(27, 'CC3027', 'Sara Patiño', 'PhD. Educación', 4, 'Calle 36 #7-36', 'Planta'),
(28, 'CC3028', 'Mauricio Nieto', 'Esp. Analítica', 7, 'Cra 37 #8-37', 'Catedra'),
(29, 'CC3029', 'Isabel Cano', 'MSc. Estadística', 10, 'Calle 38 #9-38', 'Planta'),
(30, 'CC3030', 'Oscar Fuentes', 'Ing. Electrónica', 13, 'Cra 39 #10-39', 'Catedra'),
(31, 'CC3031', 'Verónica Pineda', 'MSc. Sistemas', 16, 'Calle 40 #1-40', 'Planta'),
(32, 'CC3032', 'Esteban Quintero', 'Ing. Sistemas', 19, 'Cra 41 #2-41', 'Catedra'),
(33, 'CC3033', 'Patricia Mejía', 'PhD. Computación', 22, 'Calle 42 #3-42', 'Planta'),
(34, 'CC3034', 'Gustavo Gutiérrez', 'MSc. Datos', 25, 'Cra 43 #4-43', 'Catedra'),
(35, 'CC3035', 'Mariana Serrano', 'Lic. Matemáticas', 3, 'Calle 44 #5-44', 'Planta'),
(36, 'CC3036', 'Roberto Ortega', 'MSc. Software', 6, 'Cra 45 #6-45', 'Catedra'),
(37, 'CC3037', 'Natalia Paz', 'PhD. Educación', 9, 'Calle 46 #7-46', 'Planta'),
(38, 'CC3038', 'Iván Barrios', 'Esp. Analítica', 12, 'Cra 47 #8-47', 'Catedra'),
(39, 'CC3039', 'Claudia Miranda', 'MSc. Estadística', 15, 'Calle 48 #9-48', 'Planta'),
(40, 'CC3040', 'Edgar Valdez', 'Ing. Electrónica', 18, 'Cra 49 #10-49', 'Catedra'),
(41, 'CC3041', 'Gloria Delgado', 'MSc. Sistemas', 21, 'Calle 50 #1-50', 'Planta'),
(42, 'CC3042', 'Víctor Aguilar', 'Ing. Sistemas', 24, 'Cra 51 #2-51', 'Catedra'),
(43, 'CC3043', 'Diana Córdoba', 'PhD. Computación', 2, 'Calle 52 #3-52', 'Planta'),
(44, 'CC3044', 'César Fajardo', 'MSc. Datos', 5, 'Cra 53 #4-53', 'Catedra'),
(45, 'CC3045', 'Rocío Forero', 'Lic. Matemáticas', 8, 'Calle 54 #5-54', 'Planta'),
(46, 'CC3046', 'Julio Cárdenas', 'MSc. Software', 11, 'Cra 55 #6-55', 'Catedra'),
(47, 'CC3047', 'Noelia Blanco', 'PhD. Educación', 14, 'Calle 56 #7-56', 'Planta'),
(48, 'CC3048', 'Emilio Bravo', 'Esp. Analítica', 17, 'Cra 57 #8-57', 'Catedra'),
(49, 'CC3049', 'Fabián Cortés', 'MSc. Estadística', 20, 'Calle 58 #9-58', 'Planta'),
(50, 'CC3050', 'Pilar Mora', 'Ing. Electrónica', 23, 'Cra 59 #10-59', 'Catedra');

--
-- Disparadores `docente`
-- Tigger  que se ejecuten despues de eliminar un registro de la tabla docente 
DELIMITER $$
CREATE TRIGGER `trg_docente_after_delete` AFTER DELETE ON `docente` FOR EACH ROW BEGIN
  INSERT INTO copia_eliminados_tablaDD(tabla, pk_valor, registro)-- Inserta un registro en la tabla de auditoria para eliminar , con la informacion eliminada como JSON
  VALUES(
    'docente', -- Nombre de la tabla
    CAST(OLD.docente_id AS CHAR),-- Valor de la llave primaria eliminada
    JSON_OBJECT( -- Registro eliminado convertido a JSON
      'docente_id', OLD.docente_id,
      'numero_documento', OLD.numero_documento,
      'nombres', OLD.nombres,
      'titulo', OLD.titulo,
      'anios_experiencia', OLD.anios_experiencia,
      'direccion', OLD.direccion,
      'tipo_docente', OLD.tipo_docente
    )
  );
END
$$
DELIMITER ;
DELIMITER $$
  -- Tigger que se ejecuta antes de actualizar un registro de la tabla docente
CREATE TRIGGER `trg_docente_before_update` BEFORE UPDATE ON `docente` FOR EACH ROW BEGIN
  INSERT INTO copia_actualizados_tablaUU(tabla, pk_valor, antes, despues) -- Insertar un registro en la tabla de auditoria para actualizaciones, con los datos anteriores y los nuevos con JSON
  VALUES(
    'docente',-- Nombre de la tabla
    CAST(OLD.docente_id AS CHAR),-- valor de la llave primaria
    JSON_OBJECT( -- valores anteriores
      'docente_id', OLD.docente_id,
      'numero_documento', OLD.numero_documento,
      'nombres', OLD.nombres,
      'titulo', OLD.titulo,
      'anios_experiencia', OLD.anios_experiencia,
      'direccion', OLD.direccion,
      'tipo_docente', OLD.tipo_docente
    ),
    JSON_OBJECT(-- Valores nuevos
      'docente_id', NEW.docente_id,
      'numero_documento', NEW.numero_documento,
      'nombres', NEW.nombres,
      'titulo', NEW.titulo,
      'anios_experiencia', NEW.anios_experiencia,
      'direccion', NEW.direccion,
      'tipo_docente', NEW.tipo_docente
    )
  );
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `proyecto`
--

CREATE TABLE `proyecto` (
  `proyecto_id` int(11) NOT NULL,
  `nombre` varchar(120) NOT NULL,
  `descripcion` varchar(400) DEFAULT NULL,
  `fecha_inicial` date NOT NULL,
  `fecha_final` date DEFAULT NULL,
  `presupuesto` decimal(12,2) NOT NULL DEFAULT 0.00,
  `horas` int(11) NOT NULL DEFAULT 0,
  `docente_id_jefe` int(11) NOT NULL
) ;

--
-- Disparadores proyecto
--Tigger que se ejecutan despues de eliminar un proyecto
DELIMITER $$
CREATE TRIGGER `trg_proyecto_after_delete` AFTER DELETE ON `proyecto` FOR EACH ROW BEGIN
  INSERT INTO copia_eliminados_tablaDD(tabla, pk_valor, registro) -- Inserta en la tabla de auditoria los datos del proyecto eliminado
  VALUES(
    'proyecto',
    CAST(OLD.proyecto_id AS CHAR),
    JSON_OBJECT(
      'proyecto_id', OLD.proyecto_id,
      'nombre', OLD.nombre,
      'descripcion', OLD.descripcion,
      'fecha_inicial', OLD.fecha_inicial,
      'fecha_final', OLD.fecha_final,
      'presupuesto', OLD.presupuesto,
      'horas', OLD.horas,
      'docente_id_jefe', OLD.docente_id_jefe
    )
  );
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `trg_proyecto_before_update` -- Tigger que se ejecuten antes de actualizar un proyecto
  BEFORE UPDATE ON `proyecto` FOR EACH ROW BEGIN
  INSERT INTO copia_actualizados_tablaUU(tabla, pk_valor, antes, despues)-- Insertar los valores anteriores  y los nuemeros nuevos del proyecto en la tabla auditoria
  VALUES(
    'proyecto',
    CAST(OLD.proyecto_id AS CHAR),
    JSON_OBJECT(
      'proyecto_id', OLD.proyecto_id,
      'nombre', OLD.nombre,
      'descripcion', OLD.descripcion,
      'fecha_inicial', OLD.fecha_inicial,
      'fecha_final', OLD.fecha_final,
      'presupuesto', OLD.presupuesto,
      'horas', OLD.horas,
      'docente_id_jefe', OLD.docente_id_jefe
    ),
    JSON_OBJECT(
      'proyecto_id', NEW.proyecto_id,
      'nombre', NEW.nombre,
      'descripcion', NEW.descripcion,
      'fecha_inicial', NEW.fecha_inicial,
      'fecha_final', NEW.fecha_final,
      'presupuesto', NEW.presupuesto,
      'horas', NEW.horas,
      'docente_id_jefe', NEW.docente_id_jefe
    )
  );

END
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `copia_actualizados_tablauu`
--
ALTER TABLE `copia_actualizados_tablauu`
  ADD PRIMARY KEY (`id_audit`);

--
-- Indices de la tabla `copia_eliminados_tabladd`
--
ALTER TABLE `copia_eliminados_tabladd`
  ADD PRIMARY KEY (`id_audit`);

--
-- Indices de la tabla `docente`
--
ALTER TABLE `docente`
  ADD PRIMARY KEY (`docente_id`),
  ADD UNIQUE KEY `uq_docente_documento` (`numero_documento`);

--
-- Indices de la tabla `proyecto`
--
ALTER TABLE `proyecto`
  ADD PRIMARY KEY (`proyecto_id`),
  ADD KEY `fk_proyecto_docente` (`docente_id_jefe`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `copia_actualizados_tablauu`
--
ALTER TABLE `copia_actualizados_tablauu`
  MODIFY `id_audit` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT de la tabla `copia_eliminados_tabladd`
--
ALTER TABLE `copia_eliminados_tabladd`
  MODIFY `id_audit` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `docente`
--
ALTER TABLE `docente`
  MODIFY `docente_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `proyecto`
--
ALTER TABLE `proyecto`
  MODIFY `proyecto_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `proyecto`
--
ALTER TABLE `proyecto`
  ADD CONSTRAINT `fk_proyecto_docente` FOREIGN KEY (`docente_id_jefe`) REFERENCES `docente` (`docente_id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
