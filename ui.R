# WHO
# ui.R

library(shiny)


choice <- names(WHO.subset)

# For subset2 (scatterplot)
choice2 <- gsub("."," ", colnames(WHO.subset2), fixed=TRUE)


##### shinyUI #####

shinyUI(navbarPage("WHO Data Set Visualization",

	# Tab: Home
	tabPanel("Home",

		# Sidebar: Source code & link to demo video
		sidebarPanel(
			width=3,
			h4("Source Code", style="color:#225ea8"),
			p("The source code of this application is available at ", 
				a("GitHub", href="https://github.com/m1ng/WHO")),
			br(),
			h4("Video", style="color:#225ea8"),
			p("A demo video is available at ", 
				a("Youtube", href="https://www.youtube.com"))
			),

		# Main panel: Application description
		mainPanel(

			# Introduction
			h2("Introduction", style= "color:#253494"),
			p("This application is written to visualize the WHO Data Set obtained from ", 
				a("here", href="http://www.exploredata.net/Downloads/WHO-Data-Set")),
			p("The data set is a csv file with 358 variables and 202 observations."),
			br(),

			# Analysis
			h3("Analysis", style="color:#225ea8"),
			p("The purpose of having this tab is to visualize possible correlation between two variables."),
			p(" There are 4 components in this tab: variables input, correlation test, scatterplot and maps."),
			br(),

			# Analysis: Variables Input
			h4("Variables Input", style="color:#1d91c0"),
			p("Pair of variables selected here will be used in correlation test, scatterplot and maps."),
			div(em("Note: Categorical variables such as 'CountryID', 'Continent' etc are removed from the list."),style="color:grey"),
			br(),

			# Analysis: Correlation Test
			h4("Correlation Test", style="color:#1d91c0"), 
			p("The correlation test is a test for association between paired samples, using Pearson's product moment correlation coefficient."),("It utilizes the function and default parameters of "), code("cor.test()"),(" from the package "), code("stats"), (" version 3.2.0."),
			p("For detail explanation of the method, please click ", 
				a("here", href="https://docs.tibco.com/pub/enterprise-runtime-for-R/3.2.0/doc/html/Language_Reference/stats/cor.test.html")),
			div(em("Note: Null values will be omitted in the test."), style="color:grey"),
			br(),

			# Analysis: Scatterplot
			h4("Scatterplot", style="color:#1d91c0"),
			p("The scatterplot of selected variables, where horizontal axis = Variable1; vertiacal axis = Variable2"),
			div(em("Note: Null values will be omitted in the plot."), style="color:grey"),
			br(),

			# Analysis: Maps
			h4("Maps", style="color:#1d91c0"),
			p("The value of the variables will be mapped to the corresponding country on a world map."),
			div(em("Note: Countries with null value are coloured as grey."),style="color:grey"),
			br(),

			# Correlation Table
			h3("Correlation Table", style="color:#225ea8"),
			p("Shows pairs of possible variables and their correlation coefficients. Method used is identical to 'Correlation Test' in the tab 'Analysis'."),
			p("Sorting the table based on column can be done by clicking the column name. Sorting based on multiple columns can be done by ",
				code("Shift + click"),"the desire columns."),
			div(em("Note: Variables with more than half of the observations are null value and correlation with two identical variables are removed from the table."), style="color:grey"),
			br()
			)
		),

# Tab: Analysis
tabPanel("Analysis",
	fluidRow(
		column(2),
		column(4,

			# Input Variables: Dropdown list for variables selection
			# Wrap text in drop down list is not possible if column names do not have spaces
			selectInput("spVar1", label = "Variable 1", choices = colnames(WHO.subset)), 
			selectInput("spVar2", label = "Variable 2", choices = colnames(WHO.subset)) 
			),

		column(5,

			# Output for correlation test
			verbatimTextOutput("ci.out")
			),

		column(1)
		), 

	# Tab under Analysis tab
	tabsetPanel(

		# subtab: Scatterplot
		tabPanel("Scatterplot",
			br(),
			align="center",
			plotOutput("splot",width="80%")
			), 

		# subtab: Maps
		tabPanel("Maps",
			fluidRow(
				br(),
				br(),

				# Map: Left, Variable1)
				column(6,
					align="center",
					h4(textOutput("labelA")),
					br(),
					htmlOutput("mapA"),
					br()
					),

				# Map: Right, Variable2)
				column(6,
					align="center",
					h4(textOutput("labelB")),
					br(),
					htmlOutput("mapB"),
					br()
					)
				)
			)
		) 
	),  

# Tab: Correlation Table
tabPanel("Correlation Table",
	dataTableOutput("corrtable")
	)
)) 

