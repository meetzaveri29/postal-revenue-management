SET SEARCH_PATH TO project_schema;


INSERT INTO supply_chain (
	supply_chain_name,
	supply_chain_type,
	posting_location,
	reg_num)
VALUES
('Insight Advertising', 'R', 'Dallas', '111111'),
('Insight Advertising', 'P', 'Austin', '111111'),
('ThreadTrend Fashion', 'R', 'Austin', '222222'),
('ArtisanCraft Creations', 'R', 'Houston', '333333'),
('Crest Bank', 'R', 'Boston', '444444'),
('DreamEvents', 'R', 'Irving', '555555'),
('ActivePulse Health', 'R', 'Denver', '666666'),
('ActivePulse Health', 'P', 'Los Angeles', '666666'),
('American Express', 'R', 'Boulder', '777777'),
('Spectrum', 'R', 'Frisco', '888888');


--Date format: YYYY-MM-DD
INSERT INTO sales_orders (
	supply_chain_id,
	order_date,
	des_zip_code,
	item_id,
	quantity,
	payment_amount)
VALUES
(100, '2023-10-01', '80204', 1, 5, NULL),
(100, '2023-10-03', '75204', 1, 5, NULL),
(101, '2023-08-02', '73301', 2, 2, NULL),
(102, '2023-08-03', '78705', 3, 1, NULL),
(102, '2023-08-05', '73301', 2, 3, NULL),
(102, '2023-08-07', '78705', 3, 1, NULL),
(103, '2023-06-04', '77017', 1, 4, NULL),
(103, '2023-06-04', '77017', 1, 2, NULL),
(104, '2023-07-05', '02115', 1, 3, NULL),
(104, '2023-07-05', '02115', 1, 5, NULL),
(105, '2023-08-06', '75010', 1, 2, NULL),
(105, '2023-08-06', '75010', 1, 2, NULL),
(105, '2023-09-07', '80204', 2, 4, NULL),
(106, '2023-09-07', '80204', 2, 1, NULL),
(106, '2023-10-08', '90013', 1, 3, NULL),
(107, '2023-10-08', '90013', 1, 2, NULL),
(108, '2023-01-09', '80321', 3, 2, NULL),
(108, '2023-01-09', '80321', 3, 1, NULL),
(109, '2023-07-10', '75068', 2, 2, NULL),
(109, '2023-07-10', '75068', 2, 4, NULL);


INSERT INTO mail_piece_scans (
	mc_location_id,
	bc_supply_chain_id,
    mail_piece_scan_time,
    actual_height,
    actual_length,
    actual_width,
    actual_weight,
    bc_item_id,
    handover_date
)
VALUES
(120, 100, '2023-10-01 08:30:00', 10, 20, 5, 0.5, 1, '2023-10-01'),
(120, 100, '2023-10-01 08:35:00', 12, 20, 5, 0.5, 1, '2023-10-01'),
(120, 100, '2023-10-01 08:40:00', 12, 20, 5, 0.5, 1, '2023-10-01'),
(120, 100, '2023-10-03 08:45:00', 14, 20, 5, 0.5, 1, '2023-10-02'),
(120, 100, '2023-10-03 08:50:00', 11, 20, 5, 0.5, 1, '2023-10-03'),




(101, '2023-01-02 09:15:00', 15, 25, 6, 0.8, 'BC002', '2023-10-02'),
(102, '2023-01-03 10:00:00', 12, 18, 4, 0.6, 'BC003', '2023-04-03'),
(103, '2023-01-04 11:45:00', 8, 22, 7, 0.7, 'BC004', '2023-06-04'),
(104, '2023-01-05 12:30:00', 11, 21, 6, 0.9, 'BC005', '2023-07-05'),
(105, '2023-01-06 13:15:00', 14, 19, 5, 0.4, 'BC006', '2023-08-06'),
(106, '2023-01-07 14:00:00', 9, 23, 4, 0.6, 'BC007', '2023-09-07'),
(107, '2023-01-08 15:45:00', 13, 20, 6, 0.7, 'BC008', '2023-10-08'),
(108, '2023-01-09 16:30:00', 10, 24, 5, 0.8, 'BC009', '2023-01-09'),
(109, '2023-01-10 17:15:00', 12, 22, 7, 0.5, 'BC010', '2023-01-10');

-- if pincode is diff, mc loc id will also be diff, else remains same



INSERT INTO adjustments (
	supply_chain_id,
	adj_desc,
	adj_code,
	adj_volume,
	declared_volume,
	seen_volume,
	adj_amount)
VALUES
(100, 'Letters Adjustments', 'LA1', 0, 0, 0, 0),
(100, 'Small Parcel Adjustments', 'SP2', 0, 0, 0, 0),
(100, 'Large Parcel Adjustments', 'LP3', 0, 0, 0, 0),
(101, 'Letters Adjustments', 'LA1', 0, 0, 0, 0),
(101, 'Small Parcel Adjustments', 'SP2', 0, 0, 0, 0),
(101, 'Large Parcel Adjustments', 'LP3', 0, 0, 0, 0),
(102, 'Letters Adjustments', 'LA1', 0, 0, 0, 0),
(102, 'Small Parcel Adjustments', 'SP2', 0, 0, 0, 0),
(102, 'Large Parcel Adjustments', 'LP3', 0, 0, 0, 0),
(103, 'Letters Adjustments', 'LA1', 0, 0, 0, 0),
(103, 'Small Parcel Adjustments', 'SP2', 0, 0, 0, 0),
(103, 'Large Parcel Adjustments', 'LP3', 0, 0, 0, 0),
(104, 'Letters Adjustments', 'LA1', 0, 0, 0, 0),
(104, 'Small Parcel Adjustments', 'SP2', 0, 0, 0, 0),
(104, 'Large Parcel Adjustments', 'LP3', 0, 0, 0, 0),
(105, 'Letters Adjustments', 'LA1', 0, 0, 0, 0),
(105, 'Small Parcel Adjustments', 'SP2', 0, 0, 0, 0),
(105, 'Large Parcel Adjustments', 'LP3', 0, 0, 0, 0),
(106, 'Letters Adjustments', 'LA1', 0, 0, 0, 0),
(106, 'Small Parcel Adjustments', 'SP2', 0, 0, 0, 0),
(106, 'Large Parcel Adjustments', 'LP3', 0, 0, 0, 0),
(107, 'Letters Adjustments', 'LA1', 0, 0, 0, 0),
(107, 'Small Parcel Adjustments', 'SP2', 0, 0, 0, 0),
(107, 'Large Parcel Adjustments', 'LP3', 0, 0, 0, 0),
(108, 'Letters Adjustments', 'LA1', 0, 0, 0, 0),
(108, 'Small Parcel Adjustments', 'SP2', 0, 0, 0, 0),
(108, 'Large Parcel Adjustments', 'LP3', 0, 0, 0, 0),
(109, 'Letters Adjustments', 'LA1', 0, 0, 0, 0),
(109, 'Small Parcel Adjustments', 'SP2', 0, 0, 0, 0),
(109, 'Large Parcel Adjustments', 'LP3', 0, 0, 0, 0);


/*Updating the Volume counts for declared volume for each customer(supply_chain_id) and item_id*/
UPDATE ADJUSTMENTS ADJ
SET DECLARED_VOLUME = SO.DEC_VOL
FROM (SELECT SUPPLY_CHAIN_ID,ITEM_ID,SUM(QUANTITY)AS DEC_VOL FROM SALES_ORDERS GROUP BY SUPPLY_CHAIN_ID,ITEM_ID) SO
WHERE ADJ.SUPPLY_CHAIN_ID = SO.SUPPLY_CHAIN_ID
AND SO.ITEM_ID = 1
AND ADJ.ADJ_CODE = 'LA1';

UPDATE ADJUSTMENTS ADJ
SET DECLARED_VOLUME = SO.DEC_VOL
FROM (SELECT SUPPLY_CHAIN_ID,ITEM_ID,SUM(QUANTITY)AS DEC_VOL FROM SALES_ORDERS GROUP BY SUPPLY_CHAIN_ID,ITEM_ID) SO
WHERE ADJ.SUPPLY_CHAIN_ID = SO.SUPPLY_CHAIN_ID
AND SO.ITEM_ID = 2
AND ADJ.ADJ_CODE = 'SP2';

UPDATE ADJUSTMENTS ADJ
SET DECLARED_VOLUME = SO.DEC_VOL
FROM (SELECT SUPPLY_CHAIN_ID,ITEM_ID,SUM(QUANTITY)AS DEC_VOL FROM SALES_ORDERS GROUP BY SUPPLY_CHAIN_ID,ITEM_ID) SO
WHERE ADJ.SUPPLY_CHAIN_ID = SO.SUPPLY_CHAIN_ID
AND SO.ITEM_ID = 3
AND ADJ.ADJ_CODE = 'LP3';


/*Updating the Volume counts for seen volume for each customer(bc_supply_chain_id) and bc_item_id*/
UPDATE ADJUSTMENTS ADJ
SET SEEN_VOLUME = MPC.SEEN_VOL
FROM (SELECT BC_SUPPLY_CHAIN_ID,BC_ITEM_ID,COUNT(MAIL_PIECE_ID)AS SEEN_VOL FROM MAIL_PIECE_SCANS GROUP BY BC_SUPPLY_CHAIN_ID,BC_ITEM_ID) MPC
WHERE ADJ.SUPPLY_CHAIN_ID = MPC.BC_SUPPLY_CHAIN_ID
AND MPC.BC_ITEM_ID = 1
AND ADJ.ADJ_CODE = 'LA1';

UPDATE ADJUSTMENTS ADJ
SET SEEN_VOLUME = MPC.SEEN_VOL
FROM (SELECT BC_SUPPLY_CHAIN_ID,BC_ITEM_ID,COUNT(MAIL_PIECE_ID)AS SEEN_VOL FROM MAIL_PIECE_SCANS GROUP BY BC_SUPPLY_CHAIN_ID,BC_ITEM_ID) MPC
WHERE ADJ.SUPPLY_CHAIN_ID = MPC.BC_SUPPLY_CHAIN_ID
AND MPC.BC_ITEM_ID = 2
AND ADJ.ADJ_CODE = 'SP2';

UPDATE ADJUSTMENTS ADJ
SET SEEN_VOLUME = MPC.SEEN_VOL
FROM (SELECT BC_SUPPLY_CHAIN_ID,BC_ITEM_ID,COUNT(MAIL_PIECE_ID)AS SEEN_VOL FROM MAIL_PIECE_SCANS GROUP BY BC_SUPPLY_CHAIN_ID,BC_ITEM_ID) MPC
WHERE ADJ.SUPPLY_CHAIN_ID = MPC.BC_SUPPLY_CHAIN_ID
AND MPC.BC_ITEM_ID = 3
AND ADJ.ADJ_CODE = 'LP3';


/*Updating the Adjustments volume and amount for all adjustments where positive amount indicates penalties and negative amount indicates dicounts for each customer*/
UPDATE ADJUSTMENTS
SET ADJ_VOLUME = SEEN_VOLUME - DECLARED_VOLUME;

UPDATE ADJUSTMENTS
SET ADJ_AMOUNT = ADJ_VOLUME*1.5
WHERE ADJ_VOLUME > 0;

UPDATE ADJUSTMENTS
SET ADJ_AMOUNT = 0
WHERE ADJ_VOLUME = 0;

UPDATE ADJUSTMENTS
SET ADJ_AMOUNT = ADJ_VOLUME*0.75
WHERE ADJ_VOLUME < 0;
