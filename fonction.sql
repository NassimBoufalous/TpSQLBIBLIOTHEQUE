create or replace function fn_nb_emprunts_inscrit (p_id_i int)
return number
is
    v_nb number;
begin
    select count(*) into v_nb
    from emprunt
    where id_i = p_id_i;
    return v_nb;
end;
/

create or replace function fn_nb_emprunts_livre (p_id_l int)
return number
is
    v_nb number;
begin
    select count(*) into v_nb
    from emprunt e
    join exemplaire ex on e.ref_e = ex.ref_e
    where ex.id_l = p_id_l;
    return v_nb;
end;
/

create or replace function fn_nb_emprunts_en_retard
return number
is
    v_nb number;
begin
    select count(*) into v_nb
    from emprunt
    where date_retour_em is null
      and date_em + delais_em < sysdate;
    return v_nb;
end;
/
