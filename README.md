# Postal Revenue and Mail Management System

## Overview

The **Postal Revenue and Mail Management System** is a relational database project developed for BUAN 6320: Database Foundations for Business Analytics. The system is built for a hypothetical company, **RAMP Postal Services**, and is designed to streamline the process of managing sales orders, deliveries, scanned mail pieces, and postal revenue adjustments. This project emphasizes core database concepts including entity relationships, referential integrity, and automation using triggers and sequences.

---

## Project Objective

The goal of the system is to automate and centralize operations like:

- Managing and tracking mail deliveries.
- Capturing mail scan data from mail centers.
- Calculating adjustments based on actual scanned vs declared mail volume.
- Improving financial and operational accuracy.

This end-to-end database solution supports better decision-making, financial integrity, and operational efficiency for a modern postal business environment.

---

## Entity-Relationship Design

### 1. **Supply Chain**
Represents business customers using postal services.

| Attribute | Description |
|----------|-------------|
| `supply_chain_id` (PK) | Unique customer ID |
| `supply_chain_name` | Name of the business |
| `supply_chain_type` | Type of service (R = Regular, P = Premium) |
| `posting_location` | Source location of mailing |
| `reg_num` | Registered identification number |

---

### 2. **Sales Orders**
Tracks orders raised by businesses.

| Attribute | Description |
|----------|-------------|
| `order_id` (PK) | Unique ID per order |
| `order_date` | Date the order was created |
| `des_zip_code` | Destination zip code |
| `item_id` | Mail item category |
| `quantity` | Volume of mail |
| `payment_amount` | Payment made |
| `supply_chain_id` (FK) | References `Supply Chain` |

---

### 3. **Mail Piece Scans**
Captures data from mail scanning devices at postal centers.

| Attribute | Description |
|----------|-------------|
| `mail_piece_id` (PK) | Unique ID for mail piece |
| `mc_location_id` | Mail center location ID |
| `mail_piece_scan_time` | Scan timestamp |
| `actual_height`, `actual_length`, `actual_width`, `actual_weight` | Physical dimensions |
| `bc_item_id` | Barcode mail item ID |
| `bc_supply_chain_id` (Composite PK) | Supply Chain ID from barcode |
| `handover_date` | Date mail was handed over |

---

### 4. **Delivery**
Details delivery information for each scanned mail piece.

| Attribute | Description |
|----------|-------------|
| `delivery_id` (PK) | Unique ID for each delivery |
| `mail_piece_id`, `bc_supply_chain_id` (FKs) | References `Mail Piece Scans` |
| `delivery_time` | Time of delivery |
| `AddressLine1`, `AddressLine2`, `zip_code`, `city`, `state` | Full delivery address |

---

### 5. **Adjustments**
Calculates penalties/discounts based on declared vs actual scanned volumes.

| Attribute | Description |
|----------|-------------|
| `adj_id` (PK) | Adjustment ID |
| `adj_desc` | Description of the adjustment |
| `adj_code` | Adjustment code |
| `adj_volume`, `declared_volume`, `seen_volume` | Volume details |
| `adj_amount` | Final penalty/discount |
| `supply_chain_id` (FK) | References `Supply Chain` |

---

## Relationships

| Relationship | Cardinality | Description |
|--------------|-------------|-------------|
| Supply Chain → Sales Orders | 1:M | A customer can raise multiple orders |
| Sales Orders → Adjustments | 1:1 | Each order results in one adjustment |
| Mail Piece Scans → Adjustments | M:1 | Many scans contribute to one adjustment |
| Mail Piece Scans → Delivery | M:1 | Multiple scans link to a delivery |
| Supply Chain → Adjustments | 1:M (Optional) | Some customers may incur multiple adjustments |

---

## Schema Implementation

### Schema: `POSTAL_DB`

Includes:

- 5 relational tables
- 5 sequences for auto-incremented IDs
- 5 trigger functions and triggers for automation
- 1 aggregate view (`v_supply_chain_sales_order`) for reporting

---

## Triggers and Sequences

Each entity uses sequences to auto-generate primary keys:

| Sequence | Used In |
|----------|---------|
| `SEQ_Supply_chain_id` | `supply_chain` |
| `SEQ_Order_id` | `sales_orders` |
| `SEQ_Mail_piece_id` | `mail_piece_scans` |
| `SEQ_Delivery_id` | `delivery` |
| `SEQ_Adjustment_id` | `adjustments` |

Trigger logic includes:

- Auto-incrementing IDs before insert.
- Conditional logic to auto-calculate `payment_amount` based on `item_id` in `sales_orders`.

---

## Sample Business Logic

### Sales Order Payment Calculation (via Trigger):
```sql
IF NEW.payment_amount IS NULL THEN
  CASE NEW.item_id
    WHEN 1 THEN NEW.payment_amount := NEW.quantity * 4.5;
    WHEN 2 THEN NEW.payment_amount := NEW.quantity * 8.5;
    WHEN 3 THEN NEW.payment_amount := NEW.quantity * 12.5;
  END CASE;
