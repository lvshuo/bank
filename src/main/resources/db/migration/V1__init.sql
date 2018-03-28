/*
 Navicat Premium Data Transfer

 Source Server         : test
 Source Server Type    : MySQL
 Source Server Version : 50717
 Source Host           : 172.17.2.94
 Source Database       : eirene

 Target Server Type    : MySQL
 Target Server Version : 50717
 File Encoding         : utf-8

 Date: 09/22/2017 15:17:51 PM
*/
SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE department
(
  dept_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name    VARCHAR(20)       NOT NULL,
  CONSTRAINT pk_department PRIMARY KEY (dept_id)
)
  ENGINE = InnoDB
  DEFAULT CHARSET = utf8
  COMMENT ='职员表';

CREATE TABLE branch
(
  branch_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  name      VARCHAR(20)       NOT NULL,
  address   VARCHAR(30),
  city      VARCHAR(20),
  state     VARCHAR(2),
  zip       VARCHAR(12),
  CONSTRAINT pk_branch PRIMARY KEY (branch_id)
);

CREATE TABLE employee
(
  emp_id             SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  fname              VARCHAR(20)       NOT NULL,
  lname              VARCHAR(20)       NOT NULL,
  start_date         DATE              NOT NULL,
  end_date           DATE,
  superior_emp_id    SMALLINT UNSIGNED,
  dept_id            SMALLINT UNSIGNED,
  title              VARCHAR(20),
  assigned_branch_id SMALLINT UNSIGNED,
  CONSTRAINT fk_e_emp_id
  FOREIGN KEY (superior_emp_id) REFERENCES employee (emp_id),
  CONSTRAINT fk_dept_id
  FOREIGN KEY (dept_id) REFERENCES department (dept_id),
  CONSTRAINT fk_e_branch_id
  FOREIGN KEY (assigned_branch_id) REFERENCES branch (branch_id),
  CONSTRAINT pk_employee PRIMARY KEY (emp_id)
);

CREATE TABLE product_type
(
  product_type_cd VARCHAR(10) NOT NULL,
  name            VARCHAR(50) NOT NULL,
  CONSTRAINT pk_product_type PRIMARY KEY (product_type_cd)
);

CREATE TABLE product
(
  product_cd      VARCHAR(10) NOT NULL,
  name            VARCHAR(50) NOT NULL,
  product_type_cd VARCHAR(10) NOT NULL,
  date_offered    DATE,
  date_retired    DATE,
  CONSTRAINT fk_product_type_cd FOREIGN KEY (product_type_cd)
  REFERENCES product_type (product_type_cd),
  CONSTRAINT pk_product PRIMARY KEY (product_cd)
);

CREATE TABLE customer
(
  cust_id      INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  fed_id       VARCHAR(12)      NOT NULL,
  cust_type_cd ENUM ('I', 'B')  NOT NULL,
  address      VARCHAR(30),
  city         VARCHAR(20),
  state        VARCHAR(20),
  postal_code  VARCHAR(10),
  CONSTRAINT pk_customer PRIMARY KEY (cust_id)
);

CREATE TABLE individual
(
  cust_id    INTEGER UNSIGNED NOT NULL,
  fname      VARCHAR(30)      NOT NULL,
  lname      VARCHAR(30)      NOT NULL,
  birth_date DATE,
  CONSTRAINT fk_i_cust_id FOREIGN KEY (cust_id)
  REFERENCES customer (cust_id),
  CONSTRAINT pk_individual PRIMARY KEY (cust_id)
);

CREATE TABLE business
(
  cust_id     INTEGER UNSIGNED NOT NULL,
  name        VARCHAR(40)      NOT NULL,
  state_id    VARCHAR(10)      NOT NULL,
  incorp_date DATE,
  CONSTRAINT fk_b_cust_id FOREIGN KEY (cust_id)
  REFERENCES customer (cust_id),
  CONSTRAINT pk_business PRIMARY KEY (cust_id)
);

CREATE TABLE officer
(
  officer_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  cust_id    INTEGER UNSIGNED  NOT NULL,
  fname      VARCHAR(30)       NOT NULL,
  lname      VARCHAR(30)       NOT NULL,
  title      VARCHAR(20),
  start_date DATE              NOT NULL,
  end_date   DATE,
  CONSTRAINT fk_o_cust_id FOREIGN KEY (cust_id)
  REFERENCES business (cust_id),
  CONSTRAINT pk_officer PRIMARY KEY (officer_id)
);

CREATE TABLE account
(
  account_id         INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  product_cd         VARCHAR(10)      NOT NULL,
  cust_id            INTEGER UNSIGNED NOT NULL,
  open_date          DATE             NOT NULL,
  close_date         DATE,
  last_activity_date DATE,
  status             ENUM ('ACTIVE', 'CLOSED', 'FROZEN'),
  open_branch_id     SMALLINT UNSIGNED,
  open_emp_id        SMALLINT UNSIGNED,
  avail_balance      FLOAT(10, 2),
  pending_balance    FLOAT(10, 2),
  CONSTRAINT fk_product_cd FOREIGN KEY (product_cd)
  REFERENCES product (product_cd),
  CONSTRAINT fk_a_cust_id FOREIGN KEY (cust_id)
  REFERENCES customer (cust_id),
  CONSTRAINT fk_a_branch_id FOREIGN KEY (open_branch_id)
  REFERENCES branch (branch_id),
  CONSTRAINT fk_a_emp_id FOREIGN KEY (open_emp_id)
  REFERENCES employee (emp_id),
  CONSTRAINT pk_account PRIMARY KEY (account_id)
);

CREATE TABLE transaction
(
  txn_id              INTEGER UNSIGNED NOT NULL AUTO_INCREMENT,
  txn_date            DATETIME         NOT NULL,
  account_id          INTEGER UNSIGNED NOT NULL,
  txn_type_cd         ENUM ('DBT', 'CDT'),
  amount              DOUBLE(10, 2)    NOT NULL,
  teller_emp_id       SMALLINT UNSIGNED,
  execution_branch_id SMALLINT UNSIGNED,
  funds_avail_date    DATETIME,
  CONSTRAINT fk_t_account_id FOREIGN KEY (account_id)
  REFERENCES account (account_id),
  CONSTRAINT fk_teller_emp_id FOREIGN KEY (teller_emp_id)
  REFERENCES employee (emp_id),
  CONSTRAINT fk_exec_branch_id FOREIGN KEY (execution_branch_id)
  REFERENCES branch (branch_id),
  CONSTRAINT pk_transaction PRIMARY KEY (txn_id)
);

