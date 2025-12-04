CREATE OR REPLACE PACKAGE gestion_bibliotheque AS

    PROCEDURE emprunter_livre (
        p_id_inscrit     IN inscrit.id_i%TYPE,
        p_ref_exemplaire IN exemplaire.ref_e%TYPE,
        p_delais_emprunt IN emprunt.delais_em%TYPE DEFAULT 15
    );

    PROCEDURE retourner_livre (
        p_ref_exemplaire IN exemplaire.ref_e%TYPE
    );

END gestion_bibliotheque;
/


CREATE OR REPLACE PACKAGE BODY gestion_bibliotheque AS

    FUNCTION get_next_emprunt_id RETURN NUMBER IS
        v_next_id NUMBER;
    BEGIN
        SELECT NVL(MAX(id_em), 0) + 1
        INTO v_next_id
        FROM emprunt;
        RETURN v_next_id;
    END;

    PROCEDURE emprunter_livre (
        p_id_inscrit     IN inscrit.id_i%TYPE,
        p_ref_exemplaire IN exemplaire.ref_e%TYPE,
        p_delais_emprunt IN emprunt.delais_em%TYPE DEFAULT 15
    )
    IS
        v_emprunt_actif_count NUMBER;
    BEGIN
        SELECT COUNT(*)
        INTO v_emprunt_actif_count
        FROM emprunt
        WHERE ref_e = p_ref_exemplaire
          AND date_retour_em IS NULL;

        IF v_emprunt_actif_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'exemplaire déjà emprunté');
        END IF;

        INSERT INTO emprunt (id_em, date_em, delais_em, id_i, ref_e, date_retour_em)
        VALUES (get_next_emprunt_id(), SYSDATE, p_delais_emprunt, p_id_inscrit, p_ref_exemplaire, NULL);

        COMMIT;
    END;

    PROCEDURE retourner_livre (
        p_ref_exemplaire IN exemplaire.ref_e%TYPE
    )
    IS
        v_emprunt_id emprunt.id_em%TYPE;
    BEGIN
        SELECT id_em
        INTO v_emprunt_id
        FROM emprunt
        WHERE ref_e = p_ref_exemplaire
          AND date_retour_em IS NULL;

        UPDATE emprunt
        SET date_retour_em = SYSDATE
        WHERE id_em = v_emprunt_id;

        COMMIT;
    END;

END gestion_bibliotheque;
/
