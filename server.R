#imported packages
{library(shiny)
library(reticulate) #Load python source
library(ballr) #NBA api
library(RCurl) #Test URL
library(xlsx) #Read NFL database
library(ggplot2)} #Make plot
# use python source in file
source_python("pythonSource.py")

shinyServer(function(input, output, session) {
  
# on "Go" button click  
  observeEvent(input$go, {
    if (input$sport == "NBA") { 
      #sends full name to python source, gets manipulated link for player stats
      nameHolder <- input$playerName
      apiLink <- getNBAName(nameHolder)
      testURL <- 'https://www.basketball-reference.com'

      checkURL <- sub(' ', '', paste(testURL, apiLink)) #concat link without space caused by paste
      if (!url.exists(checkURL)) {showModal(modalDialog(title = "Error", HTML("Player not found 
                                                                                  in NBA database.<br>Click 'Help' for assistance."), size = "s", easyClose = T))}
      else {
      #enters link into API. New DT "temp" removes unnecessary stats. rename columns in stats. Save table in new var
      final <- NBAPlayerPerGameStats(apiLink)
      keep <- c("season", "age", "tm", "g", "gs", "mp", "fg", "fga", "fgpercent", "x3p", "x3pa", "x3ppercent",
                "ft", "fta", "ftpercent", "orb", "drb", "trb", "ast", "stl", "blk", "tov", "pf", "pts")
      tempTable <- final[keep]
      colnames(tempTable) <- c("Season", "Age", "Team", "GP", "GS", "MP", "FG", "FGA", "FG%", "3P", "3PA", "3P%",
                                "FT", "FTA", "FT%", "OREB", "DREB", "REB", "AST", "STL", "BLK", "TO", "PF", "PTS")
      finalTable <- na.omit(tempTable)
  
      #styling: adds "- current team" after user input (nameHolder). Concatenates string together for output.
      hl <- finalTable$Team[length(finalTable$Team)]
      nameHolder <- paste(nameHolder, " - ")
      
      #output name and data table
      dataHold <- data.frame(finalTable)
      output$fullName <- renderText({paste(nameHolder, hl)})
      output$StatTable <- renderDataTable(finalTable, options = list(pageLength = 5, scrollCollapse = T, destroy = T))
      }
    }
      
    if (input$sport == "NFL") {
      nameHolder <- input$playerName #next two lines read from excel database into data frame
      QBstats <- read.xlsx("nflstats2019.xlsx", sheetName = "nflQBstats2019", startRow = 1, as.data.frame = T)
      WRstats <- read.xlsx("nflstats2019.xlsx", sheetName = "nflWRstats2019", startRow = 1, as.data.frame = T)

      if (nrow(QBstats[QBstats$Player == nameHolder, ]) > 0) { #searches data table "player" column for input name
        output$fullName <- renderText({paste(nameHolder, " - 2019-2020")})
        output$StatTable <- renderDataTable(QBstats[QBstats$Player == nameHolder, ], options = list(pageLength = 1))
      }
      else if (nrow(WRstats[WRstats$Player == nameHolder, ]) > 0) {
        output$fullName <- renderText({paste(nameHolder, " - 2019-2020")})
        output$StatTable <- renderDataTable(WRstats[WRstats$Player == nameHolder, ], options = list(pageLength = 1))
      }
      else { #catch exceptions, display popup
        showModal(modalDialog(title = "Error", HTML("Player not found
                                                    in NFL database.<br>Click 'Help' for assistance."), size = "s", easyClose = T))
      }
    }
})
  
  observeEvent(input$graph, {
    if (input$sport == 'NFL'){
      showModal(modalDialog(title = "Coming Soon", HTML("<i>Due to statistic diversity and financial constraints,
                                                         NFL statistics cannot currently be graphed.</i><br>
                                                        Select an NBA statistic to graph."), size = "m", easyClose = T))}
    
    else { #test URL before creating graph. PNG so it's kind of slow.
      testURL <- 'https://www.basketball-reference.com'
      checkURL <- sub(' ', '', paste(testURL, getNBAName(input$playerName)))
      
      if (!url.exists(checkURL)) {showModal(modalDialog(title = "Error", HTML("Player not found in NBA database.<br>Click 'Help' for assistance."), size = "s", easyClose = T))}
      
      else {
        stats2 <- NBAPlayerPerGameStats(getNBAName(input$playerName))
        keep <- c("season", "age", "tm", "g", "gs", "mp", "fg", "fga", "fgpercent", "x3p", "x3pa", "x3ppercent",
                "ft", "fta", "ftpercent", "orb", "drb", "trb", "ast", "stl", "blk", "tov", "pf", "pts")
        temp <- stats2[keep]
        colnames(temp) <- c("Season", "Age", "Team", "GP", "GS", "MP", "FG", "FGA", "FG%", "3P", "3PA", "3P%",
                               "FT", "FTA", "FT%", "OREB", "DREB", "REB", "AST", "STL", "BLK", "TO", "PF", "PTS")
        finalStats <- na.omit(temp)
        #NEED TO GET BELOW SECTION TO WORK DYNAMICALLY W INPUT.
        if (input$stat == "g") {
          dataG <- data.frame(Season = finalStats$Season, GamesPlayed = finalStats$GP)
          pl <- ggplot(dataG, aes(Season, GamesPlayed, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Games Played", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == "gs") {
          dataGS <- data.frame(Season = finalStats$Season, GamesStarted = finalStats$GS)
          pl <- ggplot(dataGS, aes(Season, GamesStarted, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Games Started", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == "PTS") {
          dataPTS <- data.frame(Season = finalStats$Season, Points = finalStats$PTS)
          pl <- ggplot(dataPTS, aes(Season, Points, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Points per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == "fg") {
          dataFG <- data.frame(Season = finalStats$Season, FieldGoals = finalStats$FG)
          pl <- ggplot(dataFG, aes(Season, FieldGoals, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Field Goals Made per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == 'fga') {
          dataFGA <- data.frame(Season = finalStats$Season, FieldGoalAttempts = finalStats$"FGA")
          pl <- ggplot(dataFGA, aes(Season, FieldGoalAttempts, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Field Goal Attempts per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == 'fgpercent') {
          dataFGP <- data.frame(Season = finalStats$Season, FieldGoalPercentage = finalStats$"FG%")
          pl <- ggplot(dataFGP, aes(Season, FieldGoalPercentage, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Field Goal Percentage per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == "3p") {
          data3P <- data.frame(Season = finalStats$Season, ThreePointers = finalStats$"3P")
          pl <- ggplot(data3P, aes(Season, ThreePointers, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Three Pointers Made per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
 
        if (input$stat == "x3pa") {
          data3PA <- data.frame(Season = finalStats$Season, ThreePointAttempts = finalStats$"3PA")
          pl <- ggplot(data3PA, aes(Season, ThreePointAttempts, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Three Point Attempts per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == "x3ppercent") {
          data3PP <- data.frame(Season = finalStats$Season, ThreePointPercentage = finalStats$"3P%")
          pl <- ggplot(data3PP, aes(Season, ThreePointPercentage, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Three Point Percentage per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
      
        if (input$stat == "ft") {
          dataFT <- data.frame(Season = finalStats$Season, FreeThrows = finalStats$FT)
          pl <- ggplot(dataFT, aes(Season, FreeThrows, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Free Throws per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == "fta") {
          dataFTA <- data.frame(Season = finalStats$Season, FreeThrowAttempts = finalStats$FTA)
          pl <- ggplot(dataFTA, aes(Season, FreeThrowAttempts, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Free Throws Attempts per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == 'ftpercent') {
          dataFTP <- data.frame(Season = finalStats$Season, FreeThrowPercentage = finalStats$"FT%")
          pl <- ggplot(dataFTP, aes(Season, FreeThrowPercentage, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Free Throw Percentage per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == "orb") {
          dataOREB <- data.frame(Season = finalStats$Season, Off.Rebounds = finalStats$OREB)
          pl <- ggplot(dataOREB, aes(Season, Off.Rebounds, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Offensive Rebounds per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == "drb") {
          dataDREB <- data.frame(Season = finalStats$Season, Def.Rebounds = finalStats$DREB)
          pl <- ggplot(dataDREB, aes(Season, Def.Rebounds, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Defensive Rebounds per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == "trb") {
          dataREB <- data.frame(Season = finalStats$Season, Rebounds = finalStats$REB)
          pl <- ggplot(dataREB, aes(Season, Rebounds, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Rebounds per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == "ast") {
          dataAST <- data.frame(Season = finalStats$Season, Assists = finalStats$AST)
          pl <- ggplot(dataAST, aes(Season, Assists, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Assists per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == "stl") {
          dataSTL <- data.frame(Season = finalStats$Season, Steals = finalStats$STL)
          pl <- ggplot(dataSTL, aes(Season, Steals, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Steals per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == "blk") {
          dataBLK <- data.frame(Season = finalStats$Season, Blocks = finalStats$BLK)
          pl <- ggplot(dataBLK, aes(Season, Blocks, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Blocks per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == "tov") {
          dataTOV <- data.frame(Season = finalStats$Season, Turnovers = finalStats$TO)
          pl <- ggplot(dataTOV, aes(Season, Turnovers, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Turnovers per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
        }
        
        if (input$stat == "pf") {
          dataPF <- data.frame(Season = finalStats$Season, PersonalFouls = finalStats$PF)
          pl <- ggplot(dataPF, aes(Season, PersonalFouls, group = 1)) + geom_line(color = 'pink', size = 1, linetype = 'solid') + geom_point(color = 'aquamarine')
          showModal(modalDialog(title = "Personal Fouls per Game", output$graphFinal <- renderPlot(pl, width = "auto", height = "auto", res = 100), size = "l", easyClose = T))
      }
      } #end nested else
  } #end outer else
}) #end graph function
  
  observeEvent(input$help, {
    showModal(modalDialog(title = "Instructions", HTML(
      "<h1>NBA Stats:</h1>
      <p>Can search for any player in NBA history.</p>
      <ol>
      <li>Enter any player's first and last name separated by a space. <i>Nicknames not supported. Not case-sensitive.</i></li>
      <li>Interactive data table will dislay below. Can search for team, year, etc. in the data table.</li>
      <li><i>Optional:</i> Select a statistic from the dropdown menu (right of NBA) and click 'Graph'. Displays line graph of statistic's progress throughout the player's career.</li>
      </ol>
      
      <h1>NFL Stats:</h1>
      <p>Can search for any current player (played in 2019-2020 season) and most recent season.</p>
      <i><b><p>NFL Stats currently CANNOT be graphed; there is no free API for them and I have no money.</p></b></i>
      <ol>
      <li>Enter any player's first and last name separated by a space. <i>Nicknames not supported. This <b>is</b> case-sensitive.</i></li>
      <li>Data table below will only display the most recent NFL season.</li>
      </ol>
      "
    ), size = 'l', easyClose = T))
  }) #end "help" function
  
  observeEvent(input$about, {
    showModal(modalDialog(title = "Credits", HTML(
      "<p>Third-Party Packages and APIs used include:
      <ul>
      <i><li>ballR - <a href = 'https://cran.r-project.org/web/packages/ballr/ballr.pdf'>Documentation</a><br></i>Ryan Elmore, Peter DeWitt</li>
      <i><li>ggplot2 - <a href = 'https://cran.r-project.org/web/packages/ggplot2/ggplot2.pdf'>Documentation</a><br></i>Tidyverse Team</li>
      <i><li>RCurl - <a href = 'https://cran.r-project.org/web/packages/RCurl/RCurl.pdf'>Documentation</a><br></i>CRAN Team</li>
      </ul>
      <p>Button icons from <a href = 'https://fontawesome.com/icons?d=gallery'>fontawesome.com</a>.</p>
      <p>NBA statistics used in ballR provided by <a href = 'https://www.basketball-reference.com'>basketball-reference.com</a>.</p>
      <p>NFL statistics provided by <a href = 'https://www.pro-football-reference.com'>pro-football-reference.com</a>.</p>
      <i><p>This is just a proof-of-concept.</p></i>
      <i><b><p>Application created by:<br>Justin Kimble</p></b></i>"), size = 'm', easyClose = T))
  }) #end "about" function
  
} # <-- end of server function
) # <-- end of server


### THINGS I MIGHT NEED LATER ###
# Clears textbox 
# updateTextInput(session, "playerName", value = paste(""), placeholder = "Ex. Kyrie Irving")

#Benchmark timer
#startTime <- Sys.time() 
#endTime <- Sys.time()
#print(endTime - startTime)

#makes histogram
#pl <- ggplot(data = dataF, mapping = aes(x=Season, y=Points)) + geom_bar(stat="identity") 

