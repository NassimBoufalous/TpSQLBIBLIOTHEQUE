create table pays (
    id_p int not null,
    nom_p varchar(255),
    constraint pk_pays primary key (id_p)
);

create table auteur (
    id_a int not null,
    nom_a varchar(255),
    prenom_a varchar(255),
    date_naissance_a date,
    id_p int not null,
    constraint pk_auteur primary key (id_a),
    constraint fk_auteur_pays foreign key (id_p)
        references pays(id_p)
);

create table typelivre (
    id_t int not null,
    libelle_t varchar(255),
    constraint pk_typelivre primary key (id_t)
);

create table livre (
    id_l int not null,
    titre_l varchar(255),
    annee_l varchar(255),
    resume_l varchar(255),
    id_t int not null,
    constraint pk_livre primary key (id_l),
    constraint fk_livre_typelivre foreign key (id_t)
        references typelivre(id_t)
);

create table rediger (
    id_a int not null,
    id_l int not null,
    constraint pk_rediger primary key (id_a, id_l),
    constraint fk_rediger_auteur foreign key (id_a)
        references auteur(id_a),
    constraint fk_rediger_livre foreign key (id_l)
        references livre(id_l)
);

create table edition (
    id_ed int not null,
    nom_ed varchar(255),
    constraint pk_edition primary key (id_ed)
);

create table exemplaire (
    ref_e varchar(255) not null,
    id_ed int not null,
    id_l int not null,
    disponible_ex char(1) default 'o',
    constraint pk_exemplaire primary key (ref_e),
    constraint fk_exemplaire_edition foreign key (id_ed)
        references edition(id_ed),
    constraint fk_exemplaire_livre foreign key (id_l)
        references livre(id_l),
    constraint ck_dispo_exemplaire check (disponible_ex in ('o','n'))
);

create table inscrit (
    id_i int not null,
    nom_i varchar(255),
    prenom_i varchar(255),
    date_naissance_i date,
    tel_portable_i varchar(255),
    email_i varchar(255),
    constraint pk_inscrit primary key (id_i)
);

create table emprunt (
    id_em int not null,
    date_em date,
    delais_em int default 0,
    id_i int not null,
    ref_e varchar(255) not null,
    date_retour_em date,
    constraint pk_emprunt primary key (id_em),
    constraint fk_emprunt_inscrit foreign key (id_i)
        references inscrit(id_i),
    constraint fk_emprunt_exemplaire foreign key (ref_e)
        references exemplaire(ref_e)
);

create table emprunt_histo (
    id_em_histo int not null,
    id_em int not null,
    id_i int not null,
    ref_e varchar(255) not null,
    date_em date not null,
    delais_em int not null,
    date_retour_em date not null,
    date_archivage date default sysdate,
    constraint pk_emprunt_histo primary key (id_em_histo)
);
