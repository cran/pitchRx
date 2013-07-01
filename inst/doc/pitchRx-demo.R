
## @knitr setup, include=FALSE
options(CBoundsCheck=TRUE)
library(knitr)
opts_chunk$set(fig.path="figure/", cache.path="cache/", fig.align="center", warning=FALSE, message=FALSE, fig.height=7, fig.width=5)
opts_knit$set(animation.fun = hook_r2swf)
library(pitchRx)


## @knitr basic_scraping, eval=FALSE
## data <- scrapeFX(start="2011-01-01", end="2011-12-31")
## #RMySQL is preferred for data storage
## library(RMySQL)
## drv <- dbDriver("MySQL")
## MLB <- dbConnect(drv, user="your_user_name", password="your_password", port=your_port, dbname="your_database_name", host="your_host")
## dbWriteTable(MLB, value = data$pitch, name = "pitch", row.names = FALSE, append = TRUE)
## dbWriteTable(MLB, value = data$atbat, name = "atbat", row.names = FALSE, append = TRUE)
## rm(data) #clear workspace so you can repeat for other year(s)


## @knitr advanced_scraping, eval=FALSE
## data <- scrapeFX(start="2011-01-01", end="2011-12-31",
##                 tables=list(atbat = fields$atbat,
##                 pitch = fields$pitch, game = fields$game,
##                 player = fields$player, runner = NULL,
##                 umpire = NULL, coach = NULL))


## @knitr joining, eval=FALSE
## names <- c("Mariano Rivera", "Phil Hughes")
## atbats <- subset(data$atbat, pitcher_name == name)
## pitchFX <- join(atbats, data$pitch, by=c("num", "url"), type="inner")
## pitches <- subset(pitchFX, pitch_type == c("FF", "FC"))


## @knitr sql, eval=FALSE
## pitches <- dbGetQuery(MLB, "SELECT * FROM atbat INNER JOIN pitch ON (atbat.num = pitch.num AND atbat.url = pitch.url) WHERE atbat.pitcher_name = 'Mariano Rivera' or atbat.pitcher_name = 'Phil Hughes'")


## @knitr urls, eval=FALSE
## data(urls)
## dir <- gsub("players.xml", "batters/",
##             urls$url_player[1000])
## doc <- htmlParse(dir)
## nodes <- getNodeSet(doc, "//a")
## values <- gsub(" ", "",
##               sapply(nodes, xmlValue))
## ids <- values[grep("[0-9]+", values)]
## filenames <- paste(dir, ids, sep="")
## stats <- urlsToDataFrame(filenames,
##   tables=list(Player=NULL),
##   add.children=TRUE)


## @knitr load_pitches, echo=FALSE, dev="CairoPNG"
data(pitches)


## @knitr ani, fig.show="animate", interval=0.1, cache=TRUE, dev="CairoPNG", fig.width=10
animateFX(pitches, point.size=5, interval=0.1, layer=facet_grid(.~stand, labeller = label_both))


## @knitr ani2, fig.show="animate", interval=0.5, cache=TRUE, fig.height=14, fig.width=14,dev="CairoPNG"
animateFX(pitches, point.size=5, interval=0.1, layer=list(facet_grid(pitcher_name~stand, labeller = label_both), coord_fixed(), theme_bw()))


## @knitr demo, eval=FALSE
## Rivera <- subset(pitches, pitcher_name=="Mariano Rivera")
## interactiveFX(Rivera)


## @knitr strike, fig.height=14, fig.width=10, dev="CairoPNG"
strikes <- subset(pitches, des == "Called Strike")
strikeFX(strikes, geom="tile", layer=facet_grid(.~stand))


## @knitr strike2, eval=FALSE
## strikeFX(pitches, geom="tile", density1=list(des="Called Strike"), density2=list(des="Called Strike"), layer=facet_grid(.~stand))


## @knitr strike3, fig.height=14, fig.width=10, dev="CairoPNG"
strikeFX(pitches, geom="tile", density1=list(des="Called Strike"), density2=list(des="Ball"), layer=facet_grid(.~stand))


## @knitr sub, echo=FALSE
Rivera <- subset(pitches, pitcher_name=="Mariano Rivera")


## @knitr strike4, fig.height=10, fig.width=8, dev="CairoPNG"
library(ggsubplot) #required for subplot2d option
Rivera.R <- subset(Rivera, stand=="R")
strikeFX(Rivera.R, geom="subplot2d", fill="type")


## @knitr mgcv, fig.height=14, fig.width=10, dev="CairoPNG"
noswing <- subset(pitches, des %in% c("Ball", "Called Strike"))
noswing$strike <- as.numeric(noswing$des %in% "Called Strike")
strikeFX(noswing, model=gam(strike ~ s(px)+s(pz), family = binomial(link='logit')), layer=facet_grid(.~stand))


