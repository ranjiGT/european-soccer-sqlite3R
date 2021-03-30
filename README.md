# Preface
The European Soccer Database contains data on more than 25.000 national football matches from the best European leagues. The aim of this exercise is to present interesting relationships in R using explorative data analysis and visualization.

# Case description
First you need to access some tables in the database. Note: You can use the RSQLite::dbConnect() function to do this. To access a particular
database table and convert it to a ```data.frame``` , you can use the ```tbl_df(dbGetQuery(connection, 'SELECT * FROM table_xyz'))``` command.

# Task description
The first leagues of Spain, England, Germany and Italy are considered the four most attractive football leagues in Europe.
- In which of the four leagues do on average score the most or the fewest goals per game?
- Compare the average, median, standard deviation, variance, range and interquartile distance of goals scored per match between the four most attractive European leagues and the remaining leagues.
- Is there really a home advantage? Use a box plot to show the number of goals scored by home and away teams.
![](https://github.com/ranjiGT/european-soccer-sqlite3R/blob/main/Box%20plot%20Soccer.png)

- *“All soccer players are fair-weather players!”* Check the assertion with a line chart: Do on average more goals fall per game in the summer months than in the rest of the year?

![](https://github.com/ranjiGT/european-soccer-sqlite3R/blob/main/lubridate_lineplot.png)
- Display the average goals scored per game for the top 4 leagues per year from 2008 to 2016.

![](https://github.com/ranjiGT/european-soccer-sqlite3R/blob/main/lubridate_linechart.png)
- Use an estimated density function curve AND a QQ-Plots to check whether the home_team_possession variable is (approximately) normally distributed.

![](https://github.com/ranjiGT/european-soccer-sqlite3R/blob/main/Normal%20distribution.png)
- Use a box plot to show whether there is a correlation between ball ownership (```home_team_possession```) and the number of goals
(```home_team_goals```) scored per game for home teams. Create four categories of ball ownership shares: very low (<=25%), low (25%<x<=50%), high (50%<x<=75%) and very high (x>75%).
![](https://github.com/ranjiGT/european-soccer-sqlite3R/blob/main/Home%20teams%20box%20plot.png)
Dataset: https://www.kaggle.com/hugomathien/soccer
