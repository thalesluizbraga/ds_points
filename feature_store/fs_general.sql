with tb_rfv as (

select
   idCustomer,
   cast(julianday('2024-06-04') -  max(julianday(dtTransaction)) as integer) + 1 as recencia,
   count(distinct date(dtTransaction)) as frequencia_dias,
   sum (case
            when pointsTransaction > 0 then pointsTransaction else 0 
        end ) as valor_points
from
    transactions
where
    1=1 
    and dtTransaction < '2024-06-04'
    and dtTransaction >= date('2024-06-04', '-21 day') 
group by 
    idCustomer

),

tb_idade as (

select 
    rfv.idCustomer,
    cast(julianday('2024-06-04') -  min(julianday(dtTransaction)) as integer) + 1 as idade_base_dias
from 
    tb_rfv as rfv
left join 
    transactions as t on rfv.idCustomer = t.idCustomer
group by 
    rfv.idCustomer

)

select 
    '2024-06-04' as dt_ref,
    r.idCustomer,
    r.recencia,
    r.frequencia_dias,
    r.valor_points,
    i.idade_base_dias,
    c.flEmail
from 
    tb_rfv as r
left join 
    tb_idade as i on r.idCustomer = i.idCustomer
left join 
    customers as c on r.idCustomer = c.idCustomer



-- falta colocar o placeholder {date} nas datas da query pro etl do python