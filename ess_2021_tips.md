R Tips for the 2021 Essex Summer School
================

<style type="text/css">
.scroll-200 {
  max-height: 200px;
  overflow-y: auto;
  background-color: inherit;
}
</style>

``` r
library(cowplot)
library(estimatr)
library(extrafont)
library(haven)
library(lubridate)
library(magrittr)
library(tidyverse)
```

    ## [1] "R version 4.1.0 (2021-05-18)" "macOS Big Sur 10.16"

## Reshape

This section introduces the `tidyverse` way of reshaping rectangular
data.

We use the [Apple Mobility Trends
Reports](https://covid19.apple.com/mobility) to see how travel frequency
changes during the Covid-19 pandemic across the UK. After loading the
package, we import the CSV file using its URL and subset the data to
cities in the UK only.

``` r
uk_mobility_raw <- read_csv("https://covid19-static.cdn-apple.com/covid19-mobility-data/2114HotfixDev8/v3/en-us/applemobilitytrends-2021-08-06.csv") %>%
  filter(country == "United Kingdom", geo_type == "city") %>%
  transmute(region, transportation_type, across(c(`2020-01-13`:ncol(.))))
```

``` scroll-200
## # A tibble: 48 x 574
##    region    transportation_ty… `2020-01-13` `2020-01-14` `2020-01-15` `2020-01-16` `2020-01-17` `2020-01-18` `2020-01-19` `2020-01-20` `2020-01-21` `2020-01-22` `2020-01-23` `2020-01-24` `2020-01-25`
##    <chr>     <chr>                     <dbl>        <dbl>        <dbl>        <dbl>        <dbl>        <dbl>        <dbl>        <dbl>        <dbl>        <dbl>        <dbl>        <dbl>        <dbl>
##  1 Belfast   driving                     100         108.         112.        124.         126.         121.          81.2        106.          111.         117.         111.        124.         121. 
##  2 Belfast   transit                     100         100.         104.        118.         114.         104.          92.7        104.          102.         107.         100.        111.         106. 
##  3 Belfast   walking                     100         117.         123.        128.         148.         179.          93.0        122.          127.         129.         120.        152.         166. 
##  4 Birmingh… driving                     100         104.         103.        104.         105.         103.          85.8        104.          108.         106.         107.        110.         106. 
##  5 Birmingh… transit                     100         102.         104.        101.          97.5         87.2         83.1        102.          103.         107.         101.         99.9         90.5
##  6 Birmingh… walking                     100         108.         116.        111.         125.         161.          98.3        113.          121.         126.         124.        146.         192. 
##  7 Bradford  driving                     100         106.         108.        104.         108.         106.          92.6        100.          104          116.         106.        113.         106. 
##  8 Bradford  transit                     100         107.         109.        112.         102.          98.5        101.         109.          116.         118.         113.        101.          96.4
##  9 Bradford  walking                     100         110.         111.         99.7        119.         120.          91.9         94.8         100.         112.         103.        107.         120. 
## 10 Bristol   driving                     100         104.         101.        102.         105.         104.          85.8         98.1         103.         104.         103.        112.         113. 
## # … with 38 more rows, and 559 more variables: 2020-01-26 <dbl>, 2020-01-27 <dbl>, 2020-01-28 <dbl>, 2020-01-29 <dbl>, 2020-01-30 <dbl>, 2020-01-31 <dbl>, 2020-02-01 <dbl>, 2020-02-02 <dbl>,
## #   2020-02-03 <dbl>, 2020-02-04 <dbl>, 2020-02-05 <dbl>, 2020-02-06 <dbl>, 2020-02-07 <dbl>, 2020-02-08 <dbl>, 2020-02-09 <dbl>, 2020-02-10 <dbl>, 2020-02-11 <dbl>, 2020-02-12 <dbl>,
## #   2020-02-13 <dbl>, 2020-02-14 <dbl>, 2020-02-15 <dbl>, 2020-02-16 <dbl>, 2020-02-17 <dbl>, 2020-02-18 <dbl>, 2020-02-19 <dbl>, 2020-02-20 <dbl>, 2020-02-21 <dbl>, 2020-02-22 <dbl>,
## #   2020-02-23 <dbl>, 2020-02-24 <dbl>, 2020-02-25 <dbl>, 2020-02-26 <dbl>, 2020-02-27 <dbl>, 2020-02-28 <dbl>, 2020-02-29 <dbl>, 2020-03-01 <dbl>, 2020-03-02 <dbl>, 2020-03-03 <dbl>,
## #   2020-03-04 <dbl>, 2020-03-05 <dbl>, 2020-03-06 <dbl>, 2020-03-07 <dbl>, 2020-03-08 <dbl>, 2020-03-09 <dbl>, 2020-03-10 <dbl>, 2020-03-11 <dbl>, 2020-03-12 <dbl>, 2020-03-13 <dbl>,
## #   2020-03-14 <dbl>, 2020-03-15 <dbl>, 2020-03-16 <dbl>, 2020-03-17 <dbl>, 2020-03-18 <dbl>, 2020-03-19 <dbl>, 2020-03-20 <dbl>, 2020-03-21 <dbl>, 2020-03-22 <dbl>, 2020-03-23 <dbl>,
## #   2020-03-24 <dbl>, 2020-03-25 <dbl>, 2020-03-26 <dbl>, 2020-03-27 <dbl>, 2020-03-28 <dbl>, 2020-03-29 <dbl>, 2020-03-30 <dbl>, 2020-03-31 <dbl>, 2020-04-01 <dbl>, 2020-04-02 <dbl>,
## #   2020-04-03 <dbl>, 2020-04-04 <dbl>, 2020-04-05 <dbl>, 2020-04-06 <dbl>, 2020-04-07 <dbl>, 2020-04-08 <dbl>, 2020-04-09 <dbl>, 2020-04-10 <dbl>, 2020-04-11 <dbl>, 2020-04-12 <dbl>,
## #   2020-04-13 <dbl>, 2020-04-14 <dbl>, 2020-04-15 <dbl>, 2020-04-16 <dbl>, 2020-04-17 <dbl>, 2020-04-18 <dbl>, 2020-04-19 <dbl>, 2020-04-20 <dbl>, 2020-04-21 <dbl>, 2020-04-22 <dbl>,
## #   2020-04-23 <dbl>, 2020-04-24 <dbl>, 2020-04-25 <dbl>, 2020-04-26 <dbl>, 2020-04-27 <dbl>, 2020-04-28 <dbl>, 2020-04-29 <dbl>, 2020-04-30 <dbl>, 2020-05-01 <dbl>, 2020-05-02 <dbl>,
## #   2020-05-03 <dbl>, 2020-05-04 <dbl>, …
```

### `pivot_longer`

The data is in wide format––many columns represent variable values
measured at different times. But data analysis oftentimes requires long
format––repeatedly measured (over time) variable values are stacked
along time while a dedicated column stores the time information.

`tidyr::pivot_longer()` converts rectangular data from wide to long
format. When using this function, we generally need to specify the
columns that are about to be stacked.

``` r
uk_mobility_by_type <- uk_mobility_raw %>%
  pivot_longer(`2020-01-13`:ncol(.))
```

``` scroll-200
## # A tibble: 27,456 x 4
##    region  transportation_type name       value
##    <chr>   <chr>               <chr>      <dbl>
##  1 Belfast driving             2020-01-13 100  
##  2 Belfast driving             2020-01-14 108. 
##  3 Belfast driving             2020-01-15 112. 
##  4 Belfast driving             2020-01-16 124. 
##  5 Belfast driving             2020-01-17 126. 
##  6 Belfast driving             2020-01-18 121. 
##  7 Belfast driving             2020-01-19  81.2
##  8 Belfast driving             2020-01-20 106. 
##  9 Belfast driving             2020-01-21 111. 
## 10 Belfast driving             2020-01-22 117. 
## # … with 27,446 more rows
```

We can specify the names of new columns (`name` and `value`) by using
two additional arguments. They further imply how the function works: it
temporally expands each row in the wide data to *T* rows in the long
data and uses the column names to identify which rows correspond to
which column.

``` r
uk_mobility_by_type <- uk_mobility_raw %>%
  pivot_longer(`2020-01-13`:ncol(.), names_to = "date", values_to = "traffic")
```

We can use [selection
helpers](https://dplyr.tidyverse.org/reference/select.html) to specify
the columns to stack.

``` r
uk_mobility_raw %>% pivot_longer(starts_with("20"))
uk_mobility_raw %>% pivot_longer(contains("20"))
```

### `pivot_wider`

Although the data is now stacked temporally, the unit of observation is
`city`-`transportation_type`-`date`, so we want to have three separate
variables (columns) for three specific types of transportation (driving,
transit, and walking). `pivot_wider` does the opposite of what
`pivot_longer` does.

``` r
uk_mobility_panel <- uk_mobility_by_type %>%  
  pivot_wider(names_from = "transportation_type", values_from = "traffic")
```

``` scroll-200
## # A tibble: 9,152 x 5
##    region  date       driving transit walking
##    <chr>   <chr>        <dbl>   <dbl>   <dbl>
##  1 Belfast 2020-01-13   100     100     100  
##  2 Belfast 2020-01-14   108.    100.    117. 
##  3 Belfast 2020-01-15   112.    104.    123. 
##  4 Belfast 2020-01-16   124.    118.    128. 
##  5 Belfast 2020-01-17   126.    114.    148. 
##  6 Belfast 2020-01-18   121.    104.    179. 
##  7 Belfast 2020-01-19    81.2    92.7    93.0
##  8 Belfast 2020-01-20   106.    104.    122. 
##  9 Belfast 2020-01-21   111.    102.    127. 
## 10 Belfast 2020-01-22   117.    107.    129. 
## # … with 9,142 more rows
```

The data finally has a typical panel structure––an *NT* × *K* matrix, in
which *N* refers to cross-sectional sample size (16 cities), *T* refers
to time-series sample size (572 days), and *K* refers to the number of
variables, which is identical to the number of columns. Importantly,
neither multiple columns represent one variable (`pivot_longer`) nor
does a single column represent more than one variable (`pivot_wider`).

## Date and String

This section introduces the `tidyverse` way of working with date and
string. Although `uk_mobility_panel` is how typical social science panel
data looks like, we use `uk_mobility_by_type` from now on for convenient
Grouped Visualization (5th section).

### `lubridate`

Working with date in `numeric` or `character` type when we only have
yearly data is oftentimes fine. But it is better to set date as `date`
when our data’s temporal frequency becomes higher. Doing so ensures
time-series operations are done correctly and enables us to easily
extract additional time information. We see that our `date` column’s
format is YYYY-MM-DD, so we use `lubridate::ymd()` to transform `date`
from `character` to `date`.

``` r
# %<>% from magrittr (not recommended by many) is used to save space
uk_mobility_by_type %<>% mutate(date = ymd(date))
```

Likewise, we also have `mdy()` and `dmy()`. These functions handles both
`numeric` and `character` objects and are versatile to detailed format
differences, such as whether month is spelled out, leading zero is
included, and so on.

``` r
mdy(8102021); mdy("Jan 13 01"); dmy("1/07/1935"); dmy("1st in September in the year of 2021")
```

    ## [1] "2021-08-10"

    ## [1] "2001-01-13"

    ## [1] "1935-07-01"

    ## [1] "2021-09-01"

We may suspect that daily travel frequency is correlated with whether a
day is during weekend and whether daylight saving is effective. The
following two functions extract such information and create two new
variables accordingly.

``` r
uk_mobility_by_type %>% mutate(
  which_day = wday(date, label = TRUE),
  daylight_saving = dst(date)
  )
```

    ## # A tibble: 27,456 x 6
    ##    region  transportation_type date       traffic which_day daylight_saving
    ##    <chr>   <chr>               <date>       <dbl> <ord>     <lgl>          
    ##  1 Belfast driving             2020-01-13   100   Mon       FALSE          
    ##  2 Belfast driving             2020-01-14   108.  Tue       FALSE          
    ##  3 Belfast driving             2020-01-15   112.  Wed       FALSE          
    ##  4 Belfast driving             2020-01-16   124.  Thu       FALSE          
    ##  5 Belfast driving             2020-01-17   126.  Fri       FALSE          
    ##  6 Belfast driving             2020-01-18   121.  Sat       FALSE          
    ##  7 Belfast driving             2020-01-19    81.2 Sun       FALSE          
    ##  8 Belfast driving             2020-01-20   106.  Mon       FALSE          
    ##  9 Belfast driving             2020-01-21   111.  Tue       FALSE          
    ## 10 Belfast driving             2020-01-22   117.  Wed       FALSE          
    ## # … with 27,446 more rows

### `stringr`

With `uk_mobility_by_type` on hand, we now want to join it with UK’s
Covid-19 data. Specifically, we want an CSV file for *New Cases by
Publish Date* in Upper Tier Local Authorities (UTLA).

``` r
uk_covid <- read_csv("https://api.coronavirus.data.gov.uk/v2/data?areaType=utla&metric=newCasesByPublishDate&format=csv")
```

``` scroll-200
## # A tibble: 97,093 x 5
##    areaCode  areaName                  areaType date       newCasesByPublishDate
##    <chr>     <chr>                     <chr>    <date>                     <dbl>
##  1 E06000003 Redcar and Cleveland      utla     2021-08-10                    60
##  2 E06000014 York                      utla     2021-08-10                    71
##  3 E06000050 Cheshire West and Chester utla     2021-08-10                   110
##  4 E08000001 Bolton                    utla     2021-08-10                    69
##  5 E08000016 Barnsley                  utla     2021-08-10                   125
##  6 E08000031 Wolverhampton             utla     2021-08-10                    94
##  7 E08000032 Bradford                  utla     2021-08-10                   193
##  8 E09000018 Hounslow                  utla     2021-08-10                   110
##  9 E09000032 Wandsworth                utla     2021-08-10                   124
## 10 E09000033 Westminster               utla     2021-08-10                    69
## # … with 97,083 more rows
```

To join data, identical row(s)-unique identifiers have to be in the two
datasets. `uk_mobility_by_type` does not have any standardized,
code-based identifier, so we have to use city names instead. However, in
`uk_covid`, Bristol is named as “Bristol, City of”, Edinburgh is named
as “City of Edinburgh”, and Glasgow is named as “Glasgow City.” The code
below uses `stringr::str_detect()` to modify `areaName` (to be matched
to `region` in `uk_mobility_by_type` later) in `uk_covid` according to
the following rule: for the observations whose `areaName` is detected to
have the string `"Bristol"`, then just name their `areaName` as Bristol;
for the observations whose `areaName` is detected to have the string
`"Edinburgh"`, then just name their `areaName` as Edinburgh; for the
observations whose `areaName` is detected to have the string
`"Glasgow"`, then just name their `areaName` as Glasgow; for the
observations that do not meet any of these aforementioned conditions,
keep their `areaName` unchanged.

``` r
uk_covid %<>% mutate(areaName = case_when(
  str_detect(areaName, "Bristol") ~ "Bristol",
  str_detect(areaName, "Edinburgh") ~ "Edinburgh",
  str_detect(areaName, "Glasgow") ~ "Glasgow",
  TRUE ~ areaName
  ))
```

London is a single statistical unit in `uk_mobility_by_type`, but
`uk_covid` provides data separately for London’s 32 boroughs plus the
City of London. These 33 London districts have one thing in common,
though–their `areaCode` all starts with the string `"E09"`. The code
below does the following: for the observations whose `areaCode` starts
with the string `"E09"`, name their `areaName` as London; for the else
observations, keep their `areaName` unchanged. Compared to the last
chunk which changed `areaName` conditional on itself (`areaName`), this
one changes `areaName` conditional on another column (`areaCode`).

``` r
uk_covid %<>% mutate(areaName = if_else(str_starts(areaCode, "E09"), "London", areaName))
```

The `stringr` package also have four style changers.

``` r
example_str <- "The `stringr` package also have four style changers"
str_to_lower(example_str); str_to_title(example_str); str_to_upper(example_str); str_to_upper(example_str) %>% str_to_sentence()
```

    ## [1] "the `stringr` package also have four style changers"

    ## [1] "The `Stringr` Package Also Have Four Style Changers"

    ## [1] "THE `STRINGR` PACKAGE ALSO HAVE FOUR STYLE CHANGERS"

    ## [1] "The `stringr` package also have four style changers"

``` r
uk_mobility_by_type %<>% mutate(transportation_type = str_to_title(transportation_type))
```

<!-- ## Within-Group Operation -->
<!-- Our data is substantively hierarchical (city-date panel) and organizationally grouped (each city's three `transportation_type` stored along rows). This section introduces the `tidyverse` way of doing within-group operations. -->
<!-- ### `group_by` -->
<!-- `uk_mobility_type` does not have data for three days. -->
<!-- Given we only have a few missing values relative to our large temporal sample size, we decide to simply carry past values forward to impute the missing values. But unless `uk_mobility_by_type` is well grouped, we may incorrectly use London's value at *t-1* for Glasgow's missing value at *t* or use *Walking* at *t-1* for the missing *Driving* at *t*. `uk_mobility_by_type` has three levels (`region`, `transportation_type`, `date`), while to fill the missing values (with `tidyr::fill()`), we only need to operate along the temporal dimension. So, we group `uk_mobility_by_type` by `region` and `transportation_type` to `fill()` within each `transportation_type` of each `city`. -->
<!-- A section of the filled data is shown below.-->
<!-- Although we can apply time-series operators during estimation (using `plm::plm()`, for example), sometimes we may want to temporally transform our variables prior to it. `dplyr` is able to perform basic time-series operations, provided that we `group_by()` correctly. -->
<!-- ### `group_by` and `summarize` -->
<!-- We can further use `dplyr::summarize()` after `group_by()` to aggregate our data, according to some a certain aggregation method, to the levels we specify. In other words, we collapse all observations within the unspecified level(s) to a single one. In last section, although we renamed 33 London districts as London in `uk_covid`, London in each `date` still has 33 observations for its 33 districts. The code below adds 33 `newCasesByPublishDate` for London's 33 districts together for everyday. After that, London only has a single value for itself as a whole, just like all other cities do. -->
<!-- If we `group_by(areaName)` and then `summarize()`, we can easily have cumulative statistics of `newCasesByPublishDate` for each area. The code below lets us to have a look of 10 UK areas with most and least total Covid-19 cases. -->
<!-- ## Join Data by Rows -->
<!-- ### `left_join` -->
<!-- ### `right_join` -->
<!-- ### `full_join` -->
<!-- ## Grouped Visualization -->
<!-- ### `group and facet_wrap` -->
<!-- ### `facet_grid` -->
<!-- ## Automation -->
