# 🍜 Case Study: Danny's Diner SQL Business Intelligence Project

📊 1. Executive Project Overview
In competitive hospitality management, data-driven strategy forms the operational core of sustainable business growth. Danny's Diner is a specialized Japanese restaurant capturing data across core customer touchpoints, but it lacks a centralized, analytical overview to synthesize user behavior, spending habits, visit distributions, and loyalty member engagement.

This project serves as a structured business intelligence case study designed to reverse-engineer restaurant transaction patterns. By analyzing individual financial metrics, food affinity hierarchies, and timeline milestones before and after loyalty program enrollment, these queries provide actionable insights to optimize the menu, improve customer experiences, and scale high-margin offerings.

🛠️ 2. Technical Stack & Skills Demonstrated
Database Management System: MySQL Dialect

Core Concepts: Multi-table relational joins (JOIN, LEFT JOIN), aggregate metrics, data filtering logic, nested table/scalar subqueries, and Common Table Expressions (CTEs) for intermediate query staging.

Architecture Design: Separate modular implementation—this document establishes the conceptual overview, while the underlying algorithmic source code is housed independently in the companion solutions.sql file.

🎯 3. Core Analytical Focus Areas
The project script processes the underlying database schema to solve crucial operational and strategic questions:

Customer Value Metrics: Aggregating exact customer lifetime expenditure to uncover key revenue-driving segments.

Operational Rhythms: Measuring physical store visibility and frequency of repeat business via unique transaction count analytics.

Menu Affinity Diagnostics: Isolating customer favorites and tracking individual item popularity for inventory and recipe optimization.

Loyalty Program Impact: Evaluating performance timelines by tracking specific purchase activities immediately before and after members activate their digital accounts.

🗺️ 4. Relational Database Schema Structure
The underlying database architecture utilizes a normalized 3-table star schema designed to minimize data redundancy while maintaining optimal execution speeds.
