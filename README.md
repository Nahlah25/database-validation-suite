# Database Validation Suite

## Overview
SQL validation scripts used for backend database 
testing and test data management in QA Automation projects.

## Tech Stack
- Oracle SQL — scott/tiger schema
- MySQL Workbench
- Used alongside Selenium automation framework

## Modules

### joins-validation.sql
- Employee department mapping verification
- Manager relationship validation
- Salary grade mapping checks
- Cross-table data integrity validation

### subquery-validation.sql
- Correlated subquery validations
- Aggregation checks
- Department wise salary analysis

### window-functions-validation.sql
- Ranking and salary distribution checks
- Running total validations
- Department wise top earner verification

### stored-procedures-validation.sql
- Stored procedure execution and output validation
- Transaction rollback testing
- Index performance verification

## How We Used This In Project
These SQL scripts were run after every deployment 
to verify backend data integrity. Results were 
compared against expected UI values to ensure 
end-to-end data accuracy.
