number <- 1

another_number <- 4

number <- 3

number * another_number

(number + another_number) / 2 - 1

string <- "Introduction to R"

string <- Introduction to R

number_as_string <- "4"
number_as_string^2

3.14 > pi
3.14 != pi

factorial(4)
log(x = 1024, base = 2)

as.numeric(number_as_string)
as.numeric(number_as_string)^2
as.character(number)

vector <- c(-2, 4, -6, 8, -10)

paste("Introduction to", c("R", "Julia", "Python", "Stata", "MATLAB", "SAS"))

for(i in 1:length(vector)) {
  vector[i] <- vector[i] + 1
  rm(i)
}

vector + 1

mean(vector)


vector_abs <- abs(vector)
vector_root <- sqrt(vector_abs)
vector_rounded <- round(vector_root)
vector_fac <- factorial(vector_rounded)
vector_fac

vector <- abs(vector)
vector <- sqrt(vector)
vector <- round(vector)
vector <- factorial(vector)

factorial(round(sqrt(abs(vector))))

library(tidyverse)

abs(vector) |> sqrt() |> round() |> factorial()

abs(vector) %>% sqrt() %>% round() %>% factorial()

setwd("~/Desktop/GitHub/teaching/intro_r")

destfile_name <- "ess_intro_r_maliniak_2013.dta"

download.file("https://tinyurl.com/ycu95adr", destfile_name)

data <- read_dta(destfile_name)

data <- rename(data, n_cite = sscie_count) 

data <- mutate(data,
               yr_since_pub = 2013 - Year,
               yr_since_pub_sq = yr_since_pub^2,
               us_r1 = if_else(R1 == 1 & A0Institution_Country == "United States", 1, 0),
               top3 = if_else(Journal %in% c("APSR", "AJPS", "JOP"), 1, 0)
               )

data <- filter(data, !c(issue_pos == 1 | issue_other == 1 | issue_political_theory == 1))
data <- filter(data, issue_pos == 0 & issue_other == 0 & issue_political_theory == 0)
filter(data, !is.na(n_cite))
data <- drop_na(data, n_cite)

data <- select(data, id, Title, Journal, Year, Vol, Number, n_cite, us_r1, yr_since_pub, yr_since_pub_sq, top3, gender_comp)
data <- select(data, !c(A0First_Name:A9US_News_Type))
data <- select(data, !starts_with("A"))


ggplot(data) + geom_histogram(aes(n_cite), bins = 40, fill = "grey", alpha = 0.50, color = "black") +
  labs(x = "Number of Citations", y = "Frequency", caption = "Source: Maliniak, Powers, & Walter (2013)", title = "Histogram of Outcome Variable") +
  theme_minimal() +
  theme(text = element_text(family = "Palatino"))

ggplot(filter(data, n_cite <= 100)) + geom_boxplot(aes(x = as.character(gender_comp), y = n_cite)) +
  facet_grid(rows = vars(us_r1), cols = vars(top3))

stargazer::stargazer(as.data.frame(select(data, Year)), type = "text")


lm(n_cite ~ all_female + mixed_gender + yr_since_pub + yr_since_pub_sq + top3 + us_r1, data = data) %>% summary()

glm(n_cite ~ all_female + mixed_gender + yr_since_pub + yr_since_pub_sq + top3 + us_r1, data = data, family = poisson) %>% summary()




stargazer::stargazer(
  lm(n_cite ~ all_female + mixed_gender + yr_since_pub + yr_since_pub_sq + top3 + us_r1, data = data), 
  glm(n_cite ~ all_female + mixed_gender + yr_since_pub + yr_since_pub_sq + top3 + us_r1, data = data, family = poisson),
  type = "text"
  )




coefplot::coefplot(lm(n_cite ~ all_female + mixed_gender + yr_since_pub + yr_since_pub_sq + top3 + us_r1, data = data)) + 
  labs(x = "test")




















