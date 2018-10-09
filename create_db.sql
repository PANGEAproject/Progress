CREATE DATABASE PANGEA_DB;
USE PANGEA_DB;

-- RS

CREATE TABLE RS
(
 rs_id            VARCHAR(15) NOT NULL ,
 reference_allele VARCHAR(1000) NOT NULL ,
 chromosome
ENUM('chr1','chr2','chr3','chr4','chr5','chr6','chr7','chr8','chr9','chr10','chr11','chr12','chr13','chr14','chr15','chr16','chr17','chr18','chr19','chr20','chr21','chrX','chrY') ,
 variation        ENUM('unknown', 'single', 'in-del', 'het', 'microsatellite', 'named', 'mnp', 'insertion', 'deletion', 'Multiallelic_SNP', 'Multiallelic_INDEL', 'Biallelic_SNP', 'Bilallelic_INDEL') NOT NULL ,
 strand           ENUM('+','-') ,
 source           ENUM('SNP138','1000GP','SNP138-1000GP') NOT NULL ,
 start_position   INT unsigned ,

PRIMARY KEY (rs_id)
);

-- FREQUENCY_RS_CONTINENT

CREATE TABLE FREQUENCY_RS_CONTINENT
(
 rs_id        VARCHAR(15) NOT NULL ,
 frequency_id INT unsigned NOT NULL AUTO_INCREMENT,
 AFR          FLOAT unsigned NOT NULL, 
 AMR          FLOAT unsigned NOT NULL, 
 EAS          FLOAT unsigned NOT NULL, 
 EUR          FLOAT unsigned NOT NULL, 
 SAS          FLOAT unsigned NOT NULL,
 GLOBAL       FLOAT unsigned NOT NULL, 

PRIMARY KEY (frequency_id),
KEY `fkIdx_28` (rs_id),
CONSTRAINT `FK_28` FOREIGN KEY `fkIdx_28` (rs_id) REFERENCES RS (rs_id)
);

-- ALTERNATIVE_ALLELE

CREATE TABLE ALTERNATIVE_ALLELE
(
 id_alternative_allele INT NOT NULL AUTO_INCREMENT ,
 rs_id                 VARCHAR(15) NOT NULL ,
 alternative_allele    VARCHAR(1000) NOT NULL ,
 end_position          INT unsigned NOT NULL ,

PRIMARY KEY (id_alternative_allele, rs_id),
KEY `fkIdx_25` (rs_id),
CONSTRAINT `FK_25` FOREIGN KEY `fkIdx_25` (rs_id) REFERENCES RS (rs_id)
);





