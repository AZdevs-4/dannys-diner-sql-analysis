# Customer Lifetime Value (CLV) & Loyalty Program Cohort Analytics (SQL)

## 💼 Business Problem Statement
In the highly competitive hospitality and casual dining sectors, acquiring a customer is significantly more expensive than retaining one. To drive repeat business and increase average order value (AOV), Danny's Diner launched a digital loyalty program. However, the business lacked a centralized analytics engine to measure customer spend patterns, identify core product affinities, and quantify the direct financial impact of the loyalty program.

This database analytics project reverse-engineers transaction logs across a normalized, multi-table relational schema. The objective was to calculate **Customer Lifetime Value (CLV)**, map menu-item popularity, and perform a **Pre vs. Post Loyalty Enrollment Cohort Analysis** to measure the actual lift in customer spend post-activation.

---

## 🛠️ Data Architecture & Analytical Stack
To execute complex transactional tracking and multi-stage customer journey logic, the analytical layer was built using:

* **Engine:** **SQL (MySQL compatible dialect)**
* **Advanced Query Techniques deployed:**
  * **Common Table Expressions (CTEs):** Used for multi-stage data isolation and modular query staging.
  * **Window Functions (`DENSE_RANK()`, `ROW_NUMBER()`):** Implemented to dynamically track purchasing sequences and isolate first/last-mile transactions relative to loyalty enrollment dates.
  * **Conditional Aggregations (`CASE WHEN`):** Deployed to build dynamic, multi-tiered loyalty point calculator engines based on specific product promotional multipliers (e.g., 2x points on high-margin Sushi).
  * **Relational Joins & Date Mathematics:** Engineered multi-key inner and left joins across dimensions, utilizing date boundaries to segment pre-enrollment and post-enrollment behavior.

---

## 📐 Relational Database Schema Structure
The underlying transactional architecture utilizes a highly normalized, 3-table relational schema optimized to eliminate write anomalies and ensure fast transactional processing:

* **`sales` (Transactional Ledger):** Records every single product purchase event, capturing `customer_id`, transaction `order_date`, and the unique `product_id`.
* **`menu` (Product Dimension):** Holds the product registry, mapping `product_id` to `product_name` and transactional unit `price`.
* **`members` (Loyalty Dim Table):** Captures customer-level loyalty metadata, specifically linking the unique `customer_id` to their exact `join_date`.

---

## 📊 Analytical Focus Areas & SQL Core Logic
The SQL script (`solutions.sql`) is engineered to answer high-stakes operational and strategic questions:

### 1. Customer Spend & Visit Frequency (CLV Foundations)
* **Objective:** Aggregate total lifetime spend and quantify physical store visit frequency per customer account.
* **SQL Logic:** Deployed `SUM(price)` paired with `COUNT(DISTINCT order_date)` to isolate active purchasing days, separating true brand champions from casual, one-time diners.

### 2. Product Affinity & Menu Optimization
* **Objective:** Determine the absolute most-purchased item on the menu and calculate individual customer-level product favorites.
* **SQL Logic:** Utilized standard grouping and window-based ranking systems (`DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY COUNT(product_id) DESC)`) to map consumer preference profiles.

### 3. Loyalty Program Cohort Impact (Pre vs. Post Analysis)
* **Objective:** Segment transactional history to analyze user purchasing behaviors directly before and after joining the loyalty program.
* **SQL Logic:** Applied date conditional logic (`order_date >= join_date` vs. `order_date < join_date`) to isolate the exact items ordered on the "Day 1" of membership and calculate cumulative pre-membership expenditures.

---

## 💡 Strategic Business Recommendations
Based on the queries executed across the core database, the following business logic was established for management:
1. **Promotional Multiplier Optimization:** Double down on the "Sushi Multiplier" promotional engine. If SQL diagnostics prove that Sushi drives the highest baseline margin per unit despite lower volume compared to Ramen, keeping the 2x loyalty points multiplier active will incentivize higher-margin cart additions.
2. **First-Week Activation Playbook:** Insights showed that customers make high-frequency purchases immediately after signing up. Implement an automated "First 7 Days" email campaign offering a temporary 2x multiplier on all menu items to solidify the consumer's dining habit loop.
3. **Menu Simplification:** Flag and retire underperforming menu items that rank in the bottom 5% of customer affinity rankings to streamline inventory costs, reduce ingredient waste, and optimize kitchen prep speed.
