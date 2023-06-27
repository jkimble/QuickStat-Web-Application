#imported packages
{
library(shiny)
library(shinyWidgets)
library(reticulate)
library(ballr)
library(DT)
}

# Define UI for application
shinyUI(fluidPage(
    
    
# makes title in browser
    titlePanel("", windowTitle = "Fast Stat: Quick Statistics"),
    tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "flexboxgrid.css"),
    ),
    
# sets background color to gradient
    setBackgroundColor(
        color = c("pink", "aquamarine"),
        gradient = c("linear","radial"),
        direction = c("bottom", "top", "left", "right"),
        shinydashboard = F),
    
# Application title & label
    tags$i(titlePanel(h1("FastStat", align="center", style = "color: aquamarine; font-size: 125px"))),
    div(style="text-align: center; font-size: 15px",tags$i(tags$b(tags$p("Justin Kimble")))),

# Input textbox: use reticulate, send data to server & manipulate w/ python
    div(style="display: inline-block", textInput("playerName", "", "",placeholder = "Ex. Kyrie Irving")),
    
# Dropdown menus to select sport and stats to use for graph.
    div(style = "display: inline-block;", pickerInput("sport", "", c("NBA" = "NBA", "NFL" = "NFL"), width = "auto")),
    div(style = "display: inline-block;", pickerInput("stat", "",c("Games"="g", "Games Started"="gs", "Points" = "PTS", "Field Goals" = "fg",
                                                                  "FG Attempts" = "fga", "FG Percentage" = "fgpercent", "3 Pointers" = "3p",
                                                                  "3pt Attempts" = "x3pa", "3pt Percentage" = "x3ppercent", "Free Throws" = "ft",
                                                                  "Free Throw Attempts" = "fta", "Free Throw Percentage" = "ftpercent",
                                                                  "Off. Rebounds" = "orb", "Def. Rebounds" = "drb", "Rebounds" = "trb",
                                                                  "Assists" = "ast", "Steals" = "stl", "Blocks" = "blk", "Turnovers" = "tov",
                                                                  "Fouls" = "pf"), width = "auto")),
    
# create 4 action buttons for search, graph, help and info. Button click reactions in server.R. 2 divs for formatting
    div(style = "padding-bottom: 5px",
        actionBttn("go", "Go!", icon("arrow-right"), style = "pill", color = "success", size = "sm"),
        actionBttn("graph", "Graph", icon("chart-line"), style="pill", color = "success", size = "sm"),
        actionBttn("help", "Help", icon("question"), style = "gradient", color = "danger", size = "sm"), #add reaction
        actionBttn("about", "About", icon("info"), style= "unite", color = "success", size = "sm")),

# Body of page displays statistics
    mainPanel(
        div(tags$i(textOutput("fullName"), style="font-size: 40px; color: black;")), 
        dataTableOutput("StatTable"),
        )

    )
)


#THINGS I MIGHT NEED LATER#
# shinyWidgets just in case I make it work: div(style="float:left; display: inline;", align="center", searchInput("playerName", "", "",placeholder = "Ex. Kyrie Irving", width = 150)),

#    div(style="display: inline-block;", selectInput("sport", "", c("NBA"="NBA", 
#                  "NFL"="NFL"), width = 90)), 

#    div(style="display:inline-block", selectInput("stat", "", c("Games"="g", "Games Started"="gs", "Points" = "pts", "Field Goals" = "fg",
#                                "FG Attempts" = "fga", "FG Percentage" = "fgpercent", "3 Pointers" = "x3p",
#                                  "3pt Attempts" = "x3pa", "3pt Percentage" = "x3ppercent", "Free Throws" = "ft",
#                                  "Free Throw Attempts" = "fta", "Free Throw Percentage" = "ftpercent",
#                                  "Off. Rebounds" = "orb", "Def. Rebounds" = "drb", "Rebounds" = "trb",
#                                  "Assists" = "ast", "Steals" = "stl", "Blocks" = "blk", "Turnovers" = "tov",
#                                  "Fouls" = "pf"), width = 150)),

# tooltip to explain "stat" dropdown. Does not work with shiny widgets. keep for later.
# bsTooltip("stat", "If you want to create a graph, select the desired statistic.", placement = "right", trigger = "hover"),




