insert into fact_match
(season_id,
date,
home_team_id,
away_team_id,
home_goals,
away_goals,
full_time_result,
half_time_home_goals,
half_time_away_goals,
half_time_result,
home_shots,
away_shots,
home_shots_on_target,
away_shots_on_target,
home_corners,
away_corners,
home_fouls,
away_fouls,
home_yellows,
away_yellows,
home_reds,
away_reds)



select 

ds.season_id,
COALESCE(TRY_CONVERT(date, stg.Date, 103), TRY_CONVERT(date, stg.Date, 3)),
ht.teamid,
at.teamid,
fthg,
ftag,
ftr,
hthg,
htag,
htr, 
hs,
ASH ,
hst,
AST ,
HC ,
ac ,
HF ,
AF,
HY ,
AY ,
hr ,
ar 
from stg_AllMatchData stg
left join dim_season ds on stg.Div = ds.identifier
left join dim_team ht on stg.HomeTeam = ht.team_name
left join dim_team at on stg.AwayTeam = at.team_name

order by 1