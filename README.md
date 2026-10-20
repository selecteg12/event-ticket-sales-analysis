# Event Ticket Sales Analysis

![Event Ticket Sales Analysis](assets/cover.svg)

An end-to-end analysis of event ticket orders from **June to October 2024**, combining SQL extracts, Python exploration, and an interactive dashboard.

**PostgreSQL · Python · pandas · DataLens**

[Notebook](research.ipynb) · [SQL queries](analysis.sql) · [Interactive dashboard](https://datalens.yandex/l4t1anvif4bm5?tab=mg)

## Objective

Explore seasonal changes in demand, identify the main regions and ticket partners, and compare ordering patterns across device types.

## Work completed

- Prepared SQL extracts and calculated revenue, orders, buyers, and weekly trends.
- Joined order records with event information and exchange rates.
- Compared event categories, regions, ticket partners, and devices.
- Built a dashboard with filters and key business indicators.

## Key findings

- Theatre and sports accounted for a larger share of orders in autumn, while the concert share declined in the processed sample.
- Around **53% of orders** in that sample came from the three largest regions.
- Mobile devices accounted for most orders.

These findings describe the supplied platform data. They do not establish the causes of changes in demand or represent shares of the entire ticket market.

## Files

- `research.ipynb` — data preparation, exploratory analysis, and statistical comparisons.
- `analysis.sql` — SQL calculations and extracts.
- The linked dashboard provides an interactive view of the business indicators.

## Data

The source extract contains **290,849 orders**; the processed Python sample contains **214,408**. Findings depend on the cleaning and duplicate-handling rules. The SQL dashboard and Python notebook use different slices of the data.

The notebook requires the original order, event, and exchange-rate CSV exports under `/datasets`. Source data and a live PostgreSQL connection are not included. Notebook outputs have been cleared for the English version; a complete rerun has not been performed.
