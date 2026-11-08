**English** | [Русский](README.ru.md)

# Event Ticket Sales Analysis

![Event Ticket Sales Analysis](assets/cover.svg)

An analysis of ticket orders from **June to October 2024** using PostgreSQL, Python and DataLens. It looks at seasonal demand, customer activity, regions, ticket partners and devices.

[Notebook](research.ipynb) · [SQL queries](analysis.sql) · [Interactive dashboard](https://datalens.yandex/l4t1anvif4bm5?tab=mg)

## Dashboard

![Revenue, orders, buyers, weekly trends, devices and event categories](assets/dashboard-overview.jpg)

The dashboard screenshot shows **281,578 orders** with the date filter set to **10 June–1 November 2024**. No region, currency, or event filters are selected.

## What I analysed

- Revenue, orders, buyers and weekly trends from SQL extracts.
- Order records joined with event information and exchange rates.
- Differences between event categories, regions, ticket partners and devices.

In the processed sample, theatre and sports took a larger share of orders in autumn while the concert share declined. Around **53% of orders** came from the three largest regions, and most orders were placed on mobile devices.

These findings describe the supplied platform data. They do not show why demand changed or estimate shares of the entire ticket market.

## Data and reproduction

| Source | Orders | Scope |
| --- | ---: | --- |
| DataLens dashboard | 281,578 | Orders shown with the filters in the screenshot. |
| CSV for the Python analysis | 290,849 | Orders from mobile and desktop devices before cleaning. |
| Cleaned Python sample | 214,408 | Orders remaining after revenue filtering, removal of potential duplicates, and the join with event data. |

The dashboard and notebook use different slices of the data. The decrease from 290,849 to 214,408 comes from the Python cleaning steps.

`research.ipynb` contains preparation, exploration and statistical comparisons. It needs the original order, event and exchange-rate CSV exports under `/datasets`. `analysis.sql` contains the SQL extracts and calculations. Source data and a live PostgreSQL connection are not included.

The notebook has no saved cell outputs. It has not been rerun in full since translation.
