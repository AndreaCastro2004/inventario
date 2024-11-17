drop table if exists categorias cascade;
drop table if exists categorias_unidad_medida cascade;
drop table if exists unidades_medida cascade;
drop table if exists producto cascade;
drop table if exists tipo_documentos cascade;
drop table if exists proveedores cascade;
drop table if exists estados_pedido cascade;
drop table if exists cabecera_pedido cascade;
drop table if exists detalle_pedido ;
drop table if exists historial_stock;
drop table if exists cabecera_ventas cascade;
drop table if exists detalle_ventas;
create table categorias(
	codigo_cat serial not null,
	nombre varchar(100) not null,
	categoria_padre int,
	constraint categorias_pk primary key (codigo_cat),
	constraint categorias_FK foreign key (categoria_padre)
	references categorias(codigo_cat)
);
---	inserto categorias
insert into categorias(nombre,categoria_padre)
values('Materia Prima',null);
insert into categorias(nombre,categoria_padre)
values('Proteina',1);
insert into categorias(nombre,categoria_padre)
values('Salsas',1);
insert into categorias(nombre,categoria_padre)
values('Punto de Venta',null);
insert into categorias(nombre,categoria_padre)
values('Bebidas',4);
insert into categorias(nombre,categoria_padre)
values('Con Alcohol',5);
insert into categorias(nombre,categoria_padre)
values('Sin Alcohol',5);
create table categorias_unidad_medida(
	codigo_udm char(1) not null,
	nombre varchar(100) not null,
	constraint categorias_unidad_medida_pk primary key (codigo_udm)
);
--insert categorias_unidad medida
insert into categorias_unidad_medida(codigo_udm,nombre)
values('U','Unidades');
insert into categorias_unidad_medida(codigo_udm,nombre)
values('V','Volumen');
insert into categorias_unidad_medida(codigo_udm,nombre)
values('P','Peso');
create table unidades_medida(
	codigo_udm char(2) not null,
	descripcion varchar(100) not null,
	categoria_udm char(1) not null,
	constraint unidades_medida_pk primary key (codigo_udm),
	constraint unidades_medida_fk foreign key (categoria_udm)
	references categorias_unidad_medida(codigo_udm)
);
--insert unidades medida
insert into unidades_medida(codigo_udm,descripcion,categoria_udm)
values('Ml','Mililitros','V');
insert into unidades_medida(codigo_udm,descripcion,categoria_udm)
values('L','Litros','V');
insert into unidades_medida(codigo_udm,descripcion,categoria_udm)
values('U','Unidad','U');
insert into unidades_medida(codigo_udm,descripcion,categoria_udm)
values('D','Docena','U');
insert into unidades_medida(codigo_udm,descripcion,categoria_udm)
values('G','Gramos','P');
insert into unidades_medida(codigo_udm,descripcion,categoria_udm)
values('Kg','Kilogramos','P');
insert into unidades_medida(codigo_udm,descripcion,categoria_udm)
values('Lb','Libras','P');
create table producto(
	codigo_producto serial not null,
	nombre varchar(100) not null,
	udm char(2) not null,
	precio_venta money not null,
	tiene_iva boolean not null,
	coste money not null,
	categoria int not null,
	stock int not null,
	constraint producto_pk primary key (codigo_producto),
	constraint producto_udm_fk foreign key (udm)
	references unidades_medida(codigo_udm),
	constraint producto_categorias_fk foreign key (categoria)
	references categorias(codigo_cat)
);
--insertar tabla producto
insert into producto(nombre,udm,precio_venta,tiene_iva,coste,categoria,stock)
values('Coca Cola pequeña','U',0.5804,true,0.3729,7,110);
insert into producto(nombre,udm,precio_venta,tiene_iva,coste,categoria,stock)
values('Salsa de tomate','Kg',0.95,true,0.8736,3,0);
insert into producto(nombre,udm,precio_venta,tiene_iva,coste,categoria,stock)
values('Mostaza','Kg',0.95,true,0.89,3,0);
insert into producto(nombre,udm,precio_venta,tiene_iva,coste,categoria,stock)
values('Fuze tea','U',1.1,true,0.9,7,50);

create table tipo_documentos(
	codigo_documentos char(1) not null,
	descripcion varchar(100) not null,
	constraint tipo_documentos_pk primary key (codigo_documentos)
);
--insertar tipo_documentos
insert into tipo_documentos(codigo_documentos,descripcion)
values('C','Cedula');
insert into tipo_documentos(codigo_documentos,descripcion)
values('R','Ruc');

create table proveedores(
	identificador int not null,
	tipo_documento char(1) not null,
	nombre varchar(100) not null,
	telefono int not null,
	correo varchar(100)not null,
	direccion varchar(100) not null,
	constraint proveedores_pk primary key (identificador),
	constraint proveedores_fk foreign key (tipo_documento)
	references tipo_documentos(codigo_documentos)
);
--insertar provvedores
insert into proveedores(identificador,tipo_documento,nombre,telefono,correo,direccion)
values(1234567890,'C','Tony',0987880877,'sandy@gmail','Santa monica');
insert into proveedores(identificador,tipo_documento,nombre,telefono,correo,direccion)
values(00001234,'R','Inalesa',0983210873,'pop@gmail','San Fernando');

create table estados_pedido(
	codigo_estados char(1) not null,
	descripcion varchar(100) not null,
	constraint estados_pedido_pk primary key(codigo_estados)
);
---insertar estados_pedido
insert into estados_pedido (codigo_estados,descripcion)
values('S','Solicitado');
insert into estados_pedido (codigo_estados,descripcion)
values('R','Recibido');

create table cabecera_pedido(
	codigo_numero serial not null,
	proveedor int not null,
	fecha date not null,
	estado char(1) not null,
	constraint cabecera_pedido_pk primary key (codigo_numero),
	constraint cabecera_pedido_provedores_fk foreign key (proveedor)
	references proveedores(identificador),
	constraint cabecera_estado_pedido_fk foreign key (estado)
	references estados_pedido(codigo_estados)
);
--insertar cabecera_pedido
insert into cabecera_pedido(proveedor,fecha,estado)
values(00001234,'17/11/2024','R');
insert into cabecera_pedido(proveedor,fecha,estado)
values(00001234,'17/11/2024','R');

create table detalle_pedido(
	codigo_pedido serial not null,
	cabecera_pedidos int not null,
	producto int not null,
	cantidad int not null,
	subtotal money not null,
	cantidad_recibida int not null,
	constraint detalle_pedido_pk primary key (codigo_pedido),
	constraint detalle_cabecera_pedidos_fk foreign key (cabecera_pedidos)
	references cabecera_pedido(codigo_numero),
	constraint detalle_pedido_producto_fk foreign key (producto)
	references producto(codigo_producto)
);
---insertar detalle_pedido
insert into detalle_pedido (cabecera_pedidos,producto,cantidad,subtotal,cantidad_recibida)
values(1,1,100,37.29,100);
insert into detalle_pedido (cabecera_pedidos,producto,cantidad,subtotal,cantidad_recibida)
values(1,4,50,11.8,50);
insert into detalle_pedido (cabecera_pedidos,producto,cantidad,subtotal,cantidad_recibida)
values(2,1,10,3.73,10);

create table historial_stock(
	codigo_historial serial not null,
	fecha timestamp with time zone not null,
	referencia varchar(100) not null,
	producto int not null,
	cantidad int not null,
	constraint historial_stock_pk primary key (codigo_historial),
	constraint historial_stock_fk foreign key (producto)
	references producto(codigo_producto)
);
--insertar historial_stock
insert into historial_stock(fecha,referencia,producto,cantidad)
values('11/11/2024 10:32:00','Pedido 1',1,100);
insert into historial_stock(fecha,referencia,producto,cantidad)
values('11/11/2024 10:33:00','Pedido 1',4,50);
insert into historial_stock(fecha,referencia,producto,cantidad)
values('11/11/2024 10:34:00','Pedido 2',1,10);
insert into historial_stock(fecha,referencia,producto,cantidad)
values('11/11/2024 10:36:00','Venta 1',1,-5);
insert into historial_stock(fecha,referencia,producto,cantidad)
values('11/11/2024 10:38:00','Venta 1',4,1);

create table cabecera_ventas(
	codigo_cabecera serial not null,
	fecha timestamp with time zone not null,
	total_sin_iva money not null,
	iva int,
	total money not null,
	constraint cabecera_ventas_pk primary key (codigo_cabecera)
);
--insertar cabecera_ventas
insert into cabecera_ventas(fecha,total_sin_iva,iva,total)
values('11/11/2024 8:00:00',3.26,0.39,3.65);

create table detalle_ventas(
	codigo_detalle serial not null,
	cabecera_ventas int not null,
	producto int not null,
	cantidad int not null,
	precio_venta money not null,
	subtotal money not null,
	subtotal_con_iva money not null,
	constraint detalle_ventas_pk primary key (codigo_detalle),
	constraint detalle_cabecera_ventas_fk foreign key (cabecera_ventas)
	references cabecera_ventas(codigo_cabecera),
	constraint detalle_ventas_producto_fk foreign key (producto)
	references producto(codigo_producto)
);
--inserta detalle_ventas
insert into detalle_ventas(cabecera_ventas,producto,cantidad,precio_venta,subtotal,subtotal_con_iva)
values(1,1,5,0.58,2.9,3.25);
insert into detalle_ventas(cabecera_ventas,producto,cantidad,precio_venta,subtotal,subtotal_con_iva)
values(1,4,1,0.36,0.36,0.4);

select * from categorias ;
select * from categorias_unidad_medida ;
select * from unidades_medida ;
select * from producto ;
select * from tipo_documentos;
select * from proveedores;
select * from estados_pedido;
select * from cabecera_pedido;
select * from detalle_pedido;
select * from historial_stock;
select * from cabecera_ventas;
select * from detalle_ventas;