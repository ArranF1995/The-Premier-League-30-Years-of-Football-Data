# ⚽ Premier League Analytics | SQL Server & Power BI

An interactive football analytics project exploring Premier League team performance, match results, head-to-head records, home advantage, and trends across the **1990s, 2000s, 2010s, and 2020s**.

The project combines **SQL Server**, **Power BI**, and **DAX** to transform historical match data into a report designed for comparison, exploration, and data storytelling.

> **Data coverage:** 1993-2026 (20/09/2026). The report reflects the seasons available in the source data; it may not include every Premier League season.

## Dashboard preview

(06_screenshots/page_1_premier_league_overview.png)

[View the Interactive Power BI Dashboard]((https://app.powerbi.com/view?r=eyJrIjoiMzQ2MWJkNjctMjE1Ny00ZTUxLWFkMWUtYmZhOTIyODNkZGYwIiwidCI6IjViZjI2ZTU2LTUyNDQtNDQ2Zi1iZWQ5LTU1OGM1ZDAwNTk1ZSJ9))




## Project objectives

This project aims to answer questions such as:

- How do team standings and performance change across seasons?
- How do individual clubs compare on points, wins, goals scored, and goals conceded?
- What do historical head-to-head records reveal about two selected clubs?
- Which teams combine strong attacking output with solid defensive performance?
- How do clubs perform at home compared with away?
- How have goals per match, match outcomes, and winning margins changed across Premier League eras?

## Tools and technologies

| Tool | Purpose |
| --- | --- |
| **SQL Server / T-SQL** | Store, prepare, and structure match and team-season data |
| **Power BI** | Data modelling, interactive report development, and visualisation |
| **DAX** | Measures for points per game, goals per game, head-to-head records, and historical comparisons |
| **Power Query** | Data loading and preparation within Power BI, where applicable |

## Data model

The report uses a model centred on match-level and team-season-level data:

| Table | Description |
| --- | --- |
| `fact_match` | Match results, dates, season IDs, home and away team IDs, and goals |
| `fact_team_season` | Aggregated team performance by season, including points, results, and goals |
| `dim_team` | Team identifiers, names, and logo URLs |
| `dim_season` | Season identifiers, names, and era classifications |

The season dimension supports season-level filtering. Team and season dimensions support analysis of the team-season fact table. Match-level comparisons require additional care because **each match has both a home team and an away team**.

![Power BI data model](images/data-model.png)

*Add a screenshot of the actual relationship diagram here. Update this description if your final model includes additional tables or bridges.*

## Dashboard walkthrough

### 1. League Overview

![League Overview](images/league-overview.png)

Provides an overview of league performance for a selected season, including standings and headline team statistics. Season filters allow users to compare different campaigns.

### 2. Team Performance — Season

![Team Performance — Season](images/team-performance-season.png)

Allows users to select a club and season to explore points, wins, goals, goal difference, and performance over the course of that campaign.

### 3. Team Performance — Historical

![Team Performance — Historical](images/team-performance-historical.png)

Explores a selected club's performance across multiple seasons to identify longer-term changes and trends.

### 4. Head-to-Head Analysis

![Head-to-Head Analysis](images/head-to-head.png)

Compares two independently selected clubs using historical fixtures, wins, draws, goals, points per game, and goals per game. Dynamic titles and team logos make the comparison update with the selections.

### 5. Attack vs Defence

![Attack vs Defence](images/attack-vs-defence.png)

Compares attacking and defensive performance using goals scored and conceded per match, helping identify teams with different performance profiles.

### 6. Home vs Away Performance

![Home vs Away Performance](images/home-vs-away.png)

Examines the difference between home and away results, including points earned and points per game. Calculations account for the actual number of completed matches played at each venue.

### 7. Premier League Eras

![Premier League Eras](images/eras-comparison.png)

Groups seasons by their starting year into the **90s**, **00s**, **10s**, and **20s** to compare goals per match, home and away win rates, and average winning margins. This supports fairer historical comparisons than relying only on raw totals.

## Example DAX calculations

### Points per game

```dax
Points Per Game =
DIVIDE(
    SUM('fact_team_season'[points]),
    SUM('fact_team_season'[played])
)
```

### Goals per match

```dax
Matches Played =
CALCULATE(
    COUNTROWS('fact_match'),
    'fact_match'[FTR] IN {"H", "D", "A"}
)

League Goals =
CALCULATE(
    SUMX(
        'fact_match',
        'fact_match'[home_goals] + 'fact_match'[away_goals]
    ),
    'fact_match'[FTR] IN {"H", "D", "A"}
)

League Goals Per Match =
DIVIDE([League Goals], [Matches Played])
```

### Average winning margin

```dax
Average Winning Margin =
AVERAGEX(
    FILTER(
        'fact_match',
        'fact_match'[FTR] IN {"H", "A"}
    ),
    ABS(
        'fact_match'[home_goals] -
        'fact_match'[away_goals]
    )
)
```

The winning-margin measure includes **home and away victories**, while excluding draws.

## Technical challenges and solutions

### Handling home and away teams

**Challenge:** A match has two team IDs, so filtering on only the home-team relationship can accidentally exclude away fixtures. This complicates team-specific match histories and head-to-head analysis.

**Approach:** Use calculations that explicitly account for home and away roles, alongside team and season dimensions. Independent team selectors support comparisons between two clubs without one selection overriding the other.

### Building comparable metrics

**Challenge:** Raw totals can be misleading when seasons have different numbers of matches or when a season is incomplete.

**Approach:** Use normalised measures such as **points per game** and **goals per match**, and calculate home/away points per game from completed fixtures.

### Comparing football eras

**Challenge:** Season labels such as `95/96` and `03/04` need consistent chronological grouping.

**Approach:** Derive the season start year and assign seasons to the 90s, 00s, 10s, or 20s. A separate numeric sort column ensures eras appear in chronological order.

## Key findings

Add **three verified findings** from your completed report. For example:

1. **Scoring trends:** [Insert actual goals-per-match values for two eras and the calculated change].
2. **Home advantage:** [Insert actual home and away win rates and describe the difference].
3. **Winning margins:** [Insert actual average winning margins and the eras compared].

*Do not publish example figures until they have been checked against the final dataset and filters.*

## Data quality and limitations

- **Season coverage:** The dataset may not contain every season since the Premier League began. The earliest available season should be clearly identified.
- **Incomplete campaigns:** Results and aggregates can change for seasons that are still in progress.
- **Historical comparability:** Match totals vary across seasons, so per-match measures are preferred for many era comparisons.
- **Available attributes:** Some historical data sources contain fewer fields than more recent seasons.
- **Data accuracy:** Results and calculations depend on the completeness and consistency of the underlying source files.

## Repository structure

A suggested organisation for the repository:

```text
premier-league-analytics/
├── README.md
├── images/
│   ├── league-overview.png
│   ├── team-performance-season.png
│   ├── team-performance-historical.png
│   ├── head-to-head.png
│   ├── attack-vs-defence.png
│   ├── home-vs-away.png
│   ├── eras-comparison.png
│   └── data-model.png
├── sql/
│   └── [your SQL scripts]
├── powerbi/
│   └── [your Power BI report, if shareable]
└── docs/
    └── [optional project documentation]
```

Only include folders and files that actually exist in your repository.

## How to explore the project

1. Review the dashboard screenshots in the `images/` folder.
2. Open the interactive report using the link above, if public access is enabled.
3. Explore the SQL scripts to understand the data preparation and modelling approach.
4. If the `.pbix` file is shared, open it in Power BI Desktop. A local SQL Server connection may need to be reconfigured before refreshing data.

## Future improvements

- Add additional verified historical seasons where data is available.
- Expand team-level analysis with more detailed statistics where source coverage permits.
- Improve tooltips, navigation, and accessibility throughout the report.
- Automate data refresh if a suitable maintained data source becomes available.

## Data source and acknowledgements

**Data source:** [Add the dataset provider, URL, access date, and any licence or attribution requirements].

**Project:** Personal data analytics portfolio project.

---

*Built with SQL Server, Power BI, and DAX.*
