--Top scorer in world cup from 1930 till 2022:
select a.[Player Full Name],count(*) "Total Goals in Wordl Cup"
from (select case
when given_name = 'not applicable' then family_name
when family_name = 'not applicable' then given_name 
else given_name + ' ' + family_name
end "Player Full Name"
from Fifa_Goals) a
group by a.[Player Full Name]
order by 2 desc;


--Ranking of Goal Scorers by Country:
select a.player_team_name "Country Name", a.[Player Full Name], COUNT(*) "Total Goals",
COUNT(*) over(partition by a.player_team_name) "Total Goals of Country"
from (select player_team_name,case
when given_name = 'not applicable' then family_name
when family_name = 'not applicable' then given_name 
else given_name + ' ' + family_name
end "Player Full Name"
from Fifa_Goals) a
group by a.player_team_name,a.[Player Full Name]
order by 1,3 desc;


--World Cup Top Scorer by Country:
select b.player_team_name, b.[Player Full Name], b.Total_Goals
from (select a.*,row_number()
over (partition by player_team_name order by Total_Goals desc) Top_Scorer 
from (select distinct player_team_name,case
when given_name = 'not applicable' then family_name
when family_name = 'not applicable' then given_name 
else given_name + ' ' + family_name
end "Player Full Name",
count(*)
over (partition by player_id) Total_Goals
from Fifa_Goals)a)b
where Top_Scorer=1
order by 3 desc;


--Most Goals in World Cup by Year
select tournament_name "Tournament Name", COUNT(goal_id) "Total Goals"
from Fifa_Goals
group by tournament_name
order by COUNT(goal_id) desc;


--Most Own Goals in World Cup by Year
select tournament_name, COUNT(goal_id) "Total Own Goals"
from Fifa_Goals
where own_goal = 1
group by tournament_name
order by 2 desc;


--No Own Goals in World Cup by Year
select tournament_name
from Fifa_Goals
group by tournament_name
having sum(own_goal)=0;


--Total Penalty Goals in World Cup by Year
select tournament_name,count(penalty) "Total Penalty Goals"
from Fifa_Goals
where penalty>=1
group by tournament_name
order by 2 desc;


--Countries with the most goals in the world cup
select player_team_name, COUNT(goal_id) "Total Goal"
from Fifa_Goals
group by player_team_name
order by 2 desc;


--Countries with the most goals in the group stage and after group stage of the World Cup
select a.*, b.[Total Goals after Group Stage]
from (select player_team_name, count(goal_id) "Total Goals in Group Stage"
from Fifa_Goals
where stage_name = 'group stage' 
group by player_team_name) a
left join (select player_team_name, count(goal_id) "Total Goals after Group Stage" 
from Fifa_Goals 
where stage_name != 'group stage'
group by player_team_name) b
on a.player_team_name = b.player_team_name
order by 2 desc,3 desc;

select tournament_name
from Fifa_Goals
where stage_name = 'final' 
group by tournament_name;

select *
from Fifa_Goals
where stage_name = 'final' or stage_name = 'final round'
order by 4;  