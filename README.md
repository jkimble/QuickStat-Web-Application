# QuickStat web app: college senior project

________________________________________________________________

QuickStat is a simple web application that retrieves career statistics of athletes in the NBA and the NFL. The application is made using a combination of R and Python, with RStudio and Shiny as my working environment. The retrieved statistics are stored in an easy-to-read data table, and the user has the option to create a graph for a chosen statistic. 

The application was created with a 2015 MacBook Pro on macOS Catalina but will be able to run on Microsoft and Linux devices. It will run on popular web browsers Safari and Chrome (I have not tested the application on other browsers such as Firefox. Shiny has its own UI-styling  languages known as RHTML and RCSS. Similar to standard HTML and CSS, RHTML/RCSS are used to create and design the frontend of web pages. This may cause issues on some systems.)


Uses multiple APIs for data sources.

Designer Guide:

1.	Background: Shiny has a function called setBackgroundColor which can include many parameters. I used the “colors”, “gradient”, and “direction” parameters to set the image.

2.	Packages necessary for application: shiny, shinyWidgets, Reticulate, ballr, nflscrapR, shinyBS, DT

3.	Input textbox and Dropdown menus: These are simple (R)HTML elements, named as textInput() and pickerInput() respectively. Shiny can dynamically adjust the sizes of these elements; I set the ‘width’ parameter for the dropdown menus (pickerInput) to ‘auto’ to allow this. The dropdown elements are used for selecting which API to use and which statistic to graph. 

4.	Buttons: The buttons are made with a Shiny widget called “actionBttn”. Action buttons are much more diverse than normal button objects; I was able to add icons to the buttons, using fontawesome.com for the images. With the ‘style’ parameter, you can add animations to the buttons.

5.	Data table: Data sets in R can be made into a neat display with relative ease. With Shiny, you must use a function called “dataTableOutput” in the UI code, with a parameter being the name of the desired date set. On the server-side code, I created the data frame from sending the user’s input into the selected API. The input is first sent through a Python script using Reticulate in order to manipulate the input into the proper link syntax. After I retrieve the data table, I store it into a temporary variable and begin to format it, removing unnecessary data and omitting NA values. To create the table, you must use a function called renderDataTable, which has many useful parameters. One of these parameters is “options”, where you can select page separation, search functionality and more. Finally, to display the table, you must set the output option for the dataTableInput function to the table (e.g. output$table <- renderDataTable(tableDisplay)).

6.	Button Popups: Shiny allows use of small popups, made using Shiny modal. When the user clicks “help”, “about”, or “graph” a function triggers the modal. 


Currently, the application is not live. I do have a Shiny server in which I can deploy the application, but it would only be to local internet connections. I plan on eventually publishing the application whenever I can add more popular professional sports such as soccer. I will also likely remake the application from the ground-up, mainly using HTML/CSS, JavaScript (React, Angular), and Python or R for graphing.