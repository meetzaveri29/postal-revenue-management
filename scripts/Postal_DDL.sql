SET SEARCH_PATH TO project_schema;

-- Triggers
DROP TRIGGER IF EXISTS TRG_Supply_chain ON supply_chain ;
DROP TRIGGER IF EXISTS TRG_Order_id ON sales_orders ;
DROP TRIGGER IF EXISTS TRG_Mail_piece_scans ON mail_piece_scans;
DROP TRIGGER IF EXISTS TRG_Delivery ON delivery;
DROP TRIGGER IF EXISTS TRG_Adjustments on adjustments;

-- Functions
DROP FUNCTION IF EXISTS TRG_Supply_chain();
DROP FUNCTION IF EXISTS TRG_Order_id();
DROP FUNCTION IF EXISTS TRG_Mail_piece_scans();
DROP FUNCTION IF EXISTS TRG_Delivery();
DROP FUNCTION IF EXISTS TRG_Adjustments();

-- Sequences
DROP SEQUENCE IF EXISTS SEQ_Supply_chain_id;
DROP SEQUENCE IF EXISTS SEQ_Order_id;
DROP SEQUENCE IF EXISTS SEQ_Mail_piece_id;
DROP SEQUENCE IF EXISTS SEQ_Delivery_id;
DROP SEQUENCE IF EXISTS SEQ_Adjustment_id;

--Views
DROP VIEW IF EXISTS v_supply_chain_sales_order;

-- Tables
DROP TABLE IF EXISTS adjustments;
DROP TABLE IF EXISTS delivery;
DROP TABLE IF EXISTS mail_piece_scans;
DROP TABLE IF EXISTS sales_orders;
DROP TABLE IF EXISTS supply_chain;

/* Create tables based on entities */
CREATE TABLE supply_chain (
    supply_chain_id         INTEGER         NOT NULL,
    supply_chain_name       VARCHAR(255)   	NOT NULL,
    supply_chain_type       CHAR(5)         NOT NULL,
    posting_location        VARCHAR(255)   	NOT NULL,
    reg_num                 INTEGER         NOT NULL,

    CONSTRAINT PK_SupplyChain PRIMARY KEY (supply_chain_id)
);


CREATE TABLE sales_orders (
    order_id                INTEGER NOT NULL,
    supply_chain_id         INTEGER NOT NULL,
    order_date              DATE    NOT NULL,
    des_zip_code            INTEGER NOT NULL,
    item_id                 INTEGER NOT NULL,
    quantity                INTEGER NOT NULL,
    payment_amount          DECIMAL NOT NULL,

    CONSTRAINT PK_SalesOrders                   PRIMARY KEY (order_id),
    CONSTRAINT FK_SalesOrders_supply_chain_id   FOREIGN KEY (supply_chain_id)   REFERENCES supply_chain
);


CREATE TABLE mail_piece_scans (
    mail_piece_id           INTEGER     NOT NULL,
    mc_location_id          INTEGER     NOT NULL,
    mail_piece_scan_time    TIMESTAMP   NOT NULL,
    actual_height           DECIMAL     NOT NULL,
    actual_length           DECIMAL     NOT NULL,
    actual_width            DECIMAL     NOT NULL,
    actual_weight           DECIMAL     NULL,
    bc_item_id              INTEGER     NOT NULL,
    bc_supply_chain_id      INTEGER     NOT NULL,
    handover_date           DATE 		NOT NULL,

    CONSTRAINT PK_MailPieceScans    PRIMARY KEY (mail_piece_id, bc_supply_chain_id)
);


CREATE TABLE delivery (
    delivery_id             INTEGER         NOT NULL,
	mail_piece_id			INTEGER     	NOT NULL,
    bc_supply_chain_id      INTEGER         NOT NULL,
    delivery_time           TIMESTAMP       NOT NULL,
    AddressLine1            VARCHAR(255)   	NOT NULL,
    AddressLine2            VARCHAR(255)   	NULL,
    zip_code                INTEGER         NOT NULL,
    city                    VARCHAR(255)   	NULL,
    state                   VARCHAR(255)   	NOT NULL,

    CONSTRAINT PK_Delivery                                      PRIMARY KEY (delivery_id),
    CONSTRAINT FK_Delivery_mail_piece_id_bc_supply_chain_id     FOREIGN KEY (mail_piece_id, bc_supply_chain_id)     REFERENCES mail_piece_scans
);


CREATE TABLE adjustments (
    adj_id              INTEGER         NOT NULL,
    supply_chain_id     INTEGER         NOT NULL,
    adj_desc            VARCHAR(255)    NOT NULL,
    adj_code            VARCHAR(3)      NOT NULL,
    adj_volume          INTEGER         NOT NULL,
    declared_volume     INTEGER         NOT NULL,
    seen_volume         INTEGER         NOT NULL,
    adj_amount          DECIMAL         NOT NULL,
 
    CONSTRAINT PK_Adjustments                   PRIMARY KEY (adj_id),
    CONSTRAINT FK_Adjustments_supply_chain_id   FOREIGN KEY (supply_chain_id)   REFERENCES supply_chain
);

/* Create Sequences */
CREATE SEQUENCE SEQ_Supply_chain_id
    INCREMENT BY 1
    START WITH 100
    MINVALUE 0;

CREATE SEQUENCE SEQ_Order_id
    INCREMENT BY 1
    START WITH 12300
    MINVALUE 0;

CREATE SEQUENCE SEQ_Mail_piece_id
    INCREMENT BY 1
    START WITH 5000
    MINVALUE 0;

CREATE SEQUENCE SEQ_Delivery_id
    INCREMENT BY 1
    START WITH 25000
    MINVALUE 0;

CREATE SEQUENCE SEQ_Adjustment_id
    INCREMENT BY 1
    START WITH 10500
    MINVALUE 0;


/* Create Functions and Triggers */
/* Business purpose: The TRG_Supply_chain trigger automatically assigns a sequential supply chain ID to a newly-inserted row in the Supply_chain table.*/
CREATE OR REPLACE FUNCTION TRG_Supply_chain()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.supply_chain_id IS NULL THEN
            NEW.supply_chain_id := NEXTVAL('SEQ_supply_chain_id');
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_Supply_chain
BEFORE INSERT OR UPDATE ON supply_chain
FOR EACH ROW
EXECUTE FUNCTION TRG_Supply_chain();

/* Business purpose: The TRG_Order_id trigger automatically assigns a sequential order ID to a newly-inserted row in the sales_orders table.
Also if payment amount is null then have a specific charge depending on the quantity , else calculate the payment amount depending on the item id and quantity.*/
CREATE OR REPLACE FUNCTION TRG_Order_id()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.order_id IS NULL THEN
            NEW.order_id := NEXTVAL('SEQ_order_id');
        END IF;

        IF NEW.payment_amount IS NULL THEN
            IF NEW.item_id IS NULL THEN
                NEW.payment_amount := NEW.quantity * 4.5;
            ELSIF NEW.item_id = 1 THEN
                NEW.payment_amount := NEW.quantity * 4.5;
            ELSIF NEW.item_id = 2 THEN
                NEW.payment_amount := NEW.quantity * 8.5;
            ELSIF NEW.item_id = 3 THEN
                NEW.payment_amount := NEW.quantity * 12.5;
            END IF;
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_Order_id
BEFORE INSERT OR UPDATE ON sales_orders
FOR EACH ROW
EXECUTE FUNCTION TRG_Order_id();

/* Business purpose: The TRG_Mail_piece_scans trigger automatically assigns a sequential mail piece ID to a newly-inserted row in the mail piece scans table.*/
CREATE OR REPLACE FUNCTION TRG_Mail_piece_scans()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.mail_piece_id IS NULL THEN
            NEW.mail_piece_id := NEXTVAL('SEQ_Mail_piece_id');
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_Mail_piece_scans
BEFORE INSERT OR UPDATE ON mail_piece_scans
FOR EACH ROW
EXECUTE FUNCTION TRG_Mail_piece_scans();

/* Business purpose: The TRG_Delivery trigger automatically assigns a sequential delivery ID to a newly-inserted row in the delivery table.*/
CREATE OR REPLACE FUNCTION TRG_Delivery()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.delivery_id IS NULL THEN
            NEW.delivery_id := NEXTVAL('SEQ_Delivery_id');
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_Delivery
BEFORE INSERT OR UPDATE ON delivery
FOR EACH ROW
EXECUTE FUNCTION TRG_Delivery();

/* Business purpose: The TRG_Adjustments trigger automatically assigns a sequential adjustment ID to a newly-inserted row in the adjustments table.*/
CREATE OR REPLACE FUNCTION TRG_Adjustments()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        IF NEW.adj_id IS NULL THEN
            NEW.adj_id := NEXTVAL('SEQ_Adjustment_id');
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TRG_Adjustments
BEFORE INSERT OR UPDATE ON adjustments
FOR EACH ROW
EXECUTE FUNCTION TRG_Adjustments();


/* Create View */
CREATE VIEW v_supply_chain_sales_order AS
  SELECT sc.supply_chain_name, so.order_date, sc.posting_location as source_location, so.des_zip_code as destination_location, 
  sum(payment_amount) as initial_payment_amount
  FROM supply_chain sc left join sales_orders so
  on sc.supply_chain_id = so.supply_chain_id
  group by sc.supply_chain_name, so.order_date, sc.posting_location,so.des_zip_code;
