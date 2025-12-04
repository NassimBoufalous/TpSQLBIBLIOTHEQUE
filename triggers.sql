create or replace trigger trg_emprunt_check
before insert on emprunt
for each row
begin
    if :new.delais_em <= 0 then
        :new.delais_em := 1;
    end if;
end;
/

create or replace trigger trg_emprunt_stock
after insert on emprunt
for each row
begin
    update exemplaire
    set disponible_ex = 'n'
    where ref_e = :new.ref_e;
end;
/

create or replace trigger trg_retour_histo
after update of date_retour_em on emprunt
for each row
when (new.date_retour_em is not null)
declare
    v_id_histo int;
begin
    update exemplaire
    set disponible_ex = 'o'
    where ref_e = :new.ref_e;

    select nvl(max(id_em_histo), 0) + 1
    into v_id_histo
    from emprunt_histo;

    insert into emprunt_histo (
        id_em_histo, id_em, id_i, ref_e,
        date_em, delais_em, date_retour_em, date_archivage
    ) values (
        v_id_histo,
        :new.id_em,
        :new.id_i,
        :new.ref_e,
        :new.date_em,
        :new.delais_em,
        :new.date_retour_em,
        sysdate
    );
end;
/
