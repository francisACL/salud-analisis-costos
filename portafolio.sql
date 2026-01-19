select * from atenciones;
select * from pacientes;
select * from centros_salud;

#1.Obtener el gasto total por centro de salud, considerando solo atenciones realizadas,
#ordenado de mayor a menor gasto.

select cs.nombre_centro, sum(coalesce(a.costo, 0)) as gasto_total
from atenciones a
join centros_salud cs
on a.centro_id = cs.centro_id
where a.estado = 'realizada'
group by cs.nombre_centro
order by gasto_total desc;
#Sumé el costo de todas las atenciones realizadas por cada centro,
#descartando cancelaciones y asegurando que valores faltantes no distorsionen el gasto total.



#2. ¿Qué especialidades generan más gasto total?
select especialidad, sum(coalesce(costo,0)) as gasto_total
from atenciones
where estado = 'realizada'
and especialidad is not null
group by especialidad
order by gasto_total desc;

#Calculé el gasto total por especialidad considerando solo atenciones efectivamente realizadas,
#excluyendo registros incompletos para evitar distorsiones en el ranking.

#3.¿Qué pacientes concentran el MAYOR gasto total?
select p.nombre, sum(coalesce(a.costo,0)) as gasto_total
from pacientes p
join atenciones a
on p.paciente_id = a.paciente_id
where a.estado = 'realizada'
and p.nombre is not null
group by p.nombre
order by gasto_total desc;

#Identifiqué a los pacientes con mayor gasto total, considerando solo atenciones realizadas y 
#controlando valores nulos para evitar distorsiones.

#4.Centros cuyo gasto total es MAYOR que el promedio general de gasto
select nombre_centro, sum(coalesce(a.costo,0)) as gasto_total
from centros_salud cs
join atenciones a
on a.centro_id = cs.centro_id
where estado = 'realizada'
group by nombre_centro
having gasto_total > (select avg(coalesce(costo,0))
 as promedio from atenciones where estado = 'realizada');

#5.Mostrar TODOS los centros de salud, incluso los que no tienen atenciones, con:
#Nombre del centro
#Gasto total (0 si no tiene atenciones)

select cs.nombre_centro, sum(coalesce(a.costo,0)) as gasto_total
from centros_salud cs
left join atenciones a
on cs.centro_id = a.centro_id
and estado = 'realizada'
group by cs.nombre_centro
order by gasto_total desc;

#Uso LEFT JOIN para mantener todos los centros, y coloco el filtro de 
#estado en el ON para no eliminar los centros sin atenciones.
