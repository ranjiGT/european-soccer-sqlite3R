library(RSQLite)
library(stringr)
library(dplyr)
library(tidyverse)

#-------------------------------------------
con <- dbConnect(SQLite(), dbname = "EuropeanSoccer.sqlite")
con

match <- tbl_df(dbGetQuery(con,"SELECT * FROM Match"))
str(match)
match
summary(match)
head(match, n=10)
tail(match)
#?tbl_df
league <- tbl_df(dbGetQuery(con,"SELECT * FROM League"))
league

#----------------------------------------------------------------------
match_top4 <- league %>%
  filter(name %in% c("Spain LIGA BBVA", 
                     "England Premier League",  
                     "Germany 1. Bundesliga", 
                     "Italy Serie A")) %>%
  select(league_id = id, league_name = name) %>%
  inner_join(match, by = "league_id")
#----------------------------------------------------------------------
#over the top 4 
match_top4 %>%
  group_by(league_name) %>%
  filter(!is.na(home_team_goal) | !is.na(away_team_goal)) %>%
  summarize(avg_match_goals = mean(home_team_goal + away_team_goal)) %>%
  arrange(-avg_match_goals)

#-------------------------------------------------------------------
#Over the entire league

league %>%
  select(league_id = id, league_name = name) %>%
  inner_join(match, by = "league_id") %>%
  group_by(league_name) %>%
  filter(!is.na(home_team_goal) | !is.na(away_team_goal)) %>%
  summarize(avg_match_goals = mean(home_team_goal + away_team_goal)) %>%
  arrange(-avg_match_goals) %>%
  slice(c(1:5, (n()-4):n()))

#----------------------------------------------------------------------
league %>%
  mutate(name = fct_collapse(name, 
                             top4 = c("Spain LIGA BBVA", 
                                      "England Premier League",  
                                      "Germany 1. Bundesliga", 
                                      "Italy Serie A"))) %>%
  mutate(name = fct_other(name, keep = "top4", other_level = "rest")) %>%
  select(league_id = id, league_name = name) %>%
  inner_join(match, by = "league_id") %>%
  group_by(league_name) %>%
  mutate(match_goals = home_team_goal + away_team_goal) %>%
  summarise(
    avg_match_goals = mean(match_goals),
    median_match_goals = median(match_goals),
    sd_match_goals = sd(match_goals),
    var_match_goals = var(match_goals),
    min_match_goals = min(match_goals),
    max_match_goals = max(match_goals),
    iqr_match_goals = IQR(match_goals)
  ) %>% knitr::kable()

?sd()
?kable()
#-------------------------------------------------
match %>%
  gather(key = side, value = goals_scored, c(home_team_goal, away_team_goal)) %>%
  ggplot(aes(x = side, y = goals_scored)) + geom_boxplot() +
  stat_summary(geom = "point", fun = mean, pch = 23)


?gather()


match_top4 %>%
  mutate(match_month = month(as_date(date), label = T)) %>%
  group_by(match_month) %>%
  filter(!is.na(home_team_goal) | !is.na(away_team_goal)) %>%
  summarize(avg_match_goals = mean(home_team_goal + away_team_goal)) %>%
  ggplot(aes(x = match_month, y = avg_match_goals, group = 1)) +
  geom_point() +
  geom_line() +
  scale_y_continuous(limits = c(0,4))


match_top4 %>%
  mutate(match_year = year(as_date(date))) %>%
  group_by(league_name, match_year) %>%
  filter(!is.na(home_team_goal) | !is.na(away_team_goal)) %>%
  summarize(avg_match_goals = mean(home_team_goal + away_team_goal)) %>%
  ggplot(aes(x = match_year, y = avg_match_goals)) +
  geom_line(aes(color = league_name))


match %>%
  ggplot(aes(x = home_team_possession)) +
  geom_density()


# Option 2
#ps <- seq(0, 100, 0.5)/100
#qs <- quantile(match$home_team_possession, ps, na.rm = T)
#normalqs <- qnorm(ps, mean = mean(match$home_team_possession, na.rm = T),
#sd = sd(match$home_team_possession, na.rm = T))
#plot(normalqs, qs, xlab="Normal percentiles", ylab="Data percentiles")
#abline(0,1) ##identity line
# Option 3
#qqnorm(match$home_team_possession)

match %>%
  filter(!is.na(home_team_possession)) %>%
  mutate(home_team_possession_categ =
           cut(home_team_possession, breaks = seq(0,100,25))) %>%
  ggplot(aes(x = home_team_possession_categ, y = home_team_goal)) +
  geom_boxplot() +
  stat_summary(geom = "point", pch = 23, fun = "mean")