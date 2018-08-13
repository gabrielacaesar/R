#curso knight center
# módulo 10

install.packages("jsonlite")
library(jsonlite)

json_url <- "http://sbgi.net/resources/assets/sbgi/MetaverseStationData.json?1534190843866"

stations <- fromJSON(json_url)

# módulo 11

library(tibble)
library(datapasta)

# copiei uma tabela do html
# cliquei em ctrl + shift + t (atalho que criamos)
# depois de vermos que funcionou
# colocamos a variável na frente

df1 <- tibble::tribble(
    ~Week.Ending,       ~Gross, ~Perc.Gross.Pot., ~Attendance, ~Perc.Capacity, ~Perc.Previews, ~Perc.Perf.,
  "May 21, 2017", "$3,133,555",        "108%",       10755,      "102%",          0L,       8L,
  "May 14, 2017", "$2,823,183",        "107%",       10734,      "102%",          0L,       8L,
   "May 7, 2017", "$3,141,642",        "108%",       10754,      "102%",          0L,       8L,
  "Apr 30, 2017", "$2,786,938",        "106%",       10736,      "102%",          0L,       8L,
  "Apr 23, 2017", "$3,130,197",        "108%",       10754,      "102%",          0L,       8L,
  "Apr 16, 2017", "$3,117,682",        "107%",       10753,      "102%",          0L,       8L,
   "Apr 9, 2017", "$2,978,761",        "103%",       10754,      "102%",          0L,       8L,
   "Apr 2, 2017", "$2,814,628",        "107%",       10736,      "102%",          0L,       8L,
  "Mar 26, 2017", "$3,095,696",        "107%",       10754,      "102%",          0L,       8L,
  "Mar 19, 2017", "$2,865,344",        "109%",       10736,      "102%",          0L,       8L,
  "Mar 12, 2017", "$3,145,636",        "108%",       10755,      "102%",          0L,       8L,
   "Mar 5, 2017", "$2,835,099",        "108%",       10735,      "102%",          0L,       8L,
  "Feb 26, 2017", "$3,133,415",        "108%",       10754,      "102%",          0L,       8L,
  "Feb 19, 2017", "$2,866,806",        "109%",       10733,      "102%",          0L,       8L,
  "Feb 12, 2017", "$2,903,693",        "110%",       10733,      "102%",          0L,       8L,
   "Feb 5, 2017", "$3,214,897",        "111%",       10755,      "102%",          0L,       8L,
  "Jan 29, 2017", "$2,465,369",        "104%",       10758,      "102%",          0L,       8L,
  "Jan 22, 2017", "$2,451,721",        "104%",       10754,      "102%",          0L,       8L,
  "Jan 15, 2017", "$2,451,260",        "103%",       10756,      "102%",          0L,       8L,
   "Jan 8, 2017", "$2,456,491",        "103%",       10754,      "102%",          0L,       8L,
   "Jan 1, 2017", "$3,335,430",        "106%",       10755,      "102%",          0L,       8L,
  "Dec 25, 2016", "$3,303,538",        "105%",       10755,      "102%",          0L,       8L,
  "Dec 18, 2016", "$2,240,488",        "103%",       10738,      "102%",          0L,       8L,
  "Dec 11, 2016", "$2,443,438",        "103%",       10753,      "102%",          0L,       8L,
   "Dec 4, 2016", "$2,233,259",        "103%",       10732,      "102%",          0L,       8L,
  "Nov 27, 2016", "$3,260,089",        "103%",       10752,      "102%",          0L,       8L,
  "Nov 20, 2016", "$2,454,656",        "126%",       10752,      "102%",          0L,       8L,
  "Nov 13, 2016", "$2,452,746",        "126%",       10756,      "102%",          0L,       8L,
   "Nov 6, 2016", "$2,227,546",        "115%",       10732,      "102%",          0L,       8L,
  "Oct 30, 2016", "$2,215,641",        "114%",       10754,      "102%",          0L,       8L,
  "Oct 23, 2016", "$1,993,088",        "103%",       10733,      "102%",          0L,       8L,
  "Oct 16, 2016", "$2,163,855",        "111%",       10754,      "102%",          0L,       8L,
   "Oct 9, 2016", "$2,214,118",        "114%",       10755,      "102%",          0L,       8L,
   "Oct 2, 2016", "$2,174,750",        "112%",       10754,      "102%",          0L,       8L,
  "Sep 25, 2016", "$2,419,442",        "111%",       12100,      "102%",          0L,       9L,
  "Sep 18, 2016", "$2,159,038",        "111%",       10755,      "102%",          0L,       8L,
  "Sep 11, 2016", "$2,150,229",        "111%",       10753,      "102%",          0L,       8L,
   "Sep 4, 2016", "$2,091,791",        "108%",       10752,      "102%",          0L,       8L,
  "Aug 28, 2016", "$2,054,058",        "106%",       10753,      "102%",          0L,       8L,
  "Aug 21, 2016", "$2,065,377",        "106%",       10753,      "102%",          0L,       8L,
  "Aug 14, 2016", "$2,045,095",        "105%",       10756,      "102%",          0L,       8L,
   "Aug 7, 2016", "$2,062,862",        "106%",       10756,      "102%",          0L,       8L,
  "Jul 31, 2016", "$2,041,865",        "105%",       10755,      "102%",          0L,       8L,
  "Jul 24, 2016", "$2,046,711",        "105%",       10754,      "102%",          0L,       8L,
  "Jul 17, 2016", "$2,282,207",        "104%",       12053,      "101%",          0L,       9L,
  "Jul 10, 2016", "$2,053,263",        "106%",       10753,      "102%",          0L,       8L,
   "Jul 3, 2016", "$2,022,790",        "104%",       10739,      "102%",          0L,       8L,
  "Jun 26, 2016", "$2,007,222",        "103%",       10732,      "102%",          0L,       8L,
  "Jun 19, 2016", "$2,026,838",        "122%",       10752,      "102%",          0L,       8L,
  "Jun 12, 2016", "$2,028,208",        "152%",       10754,      "102%",          0L,       8L,
   "Jun 5, 2016", "$1,854,989",        "139%",       10756,      "102%",          0L,       8L,
  "May 29, 2016", "$1,917,923",        "144%",       10752,      "102%",          0L,       8L
  )

View(df1)
str(df1)

# outra opcao seria ctrl v direto

# modulo 12

# spss é parecido com excel
# é um pacote caro e fechado
# mas vc pode usar spss no R

install.packages("foreign")
library(foreign)

getwd()
setwd("~/Downloads")
data_labels <- read.spss("SHR76_16.sav", to.data.frame=TRUE)

View(data_labels)

data_only <- read.spss("SHR76_16.sav", use.value.labels=F, to.data.frame=TRUE)

View(data_only)

library(dplyr)

colnames(data_labels)
colnames(data_only)

new_labels <- select(data_labels,
                     ID, CNTYFIPS, Ori, State, Agency, AGENCY_A,
                     Agentype_label=Agentype,
                     Source_label=Source,
                     Solved_label=Solved,
                     Year,
                     Month_label=Month,
                     Incident, ActionType,
                     Homicide_label=Homicide,
                     Situation_label=Situation,
                     VicAge,
                     VicSex_label=VicSex,
                     VicRace_label=VicRace,
                     VicEthnic, OffAge,
                     OffSex_label=OffSex,
                     OffRace_label=OffRace,
                     OffEthnic,
                     Weapon_label=Weapon,
                     Relationship_label=Relationship,
                     Circumstance_label=Circumstance,
                     Subcircum, VicCount, OffCount, FileDate,
                     fstate_label=fstate,
                     MSA_label=MSA)

new_data_only <- select(data_only,
                        Agentype_value=Agentype,
                        Source_value=Source,
                        Solved_value=Solved,
                        Month_value=Month,
                        Homicide_value=Homicide,
                        Situation_value=Situation,
                        VicSex_value=VicSex,
                        VicRace_value=VicRace,
                        OffSex_value=OffSex,
                        OffRace_value=OffRace,
                        Weapon_value=Weapon,
                        Relationship_value=Relationship,
                        Circumstance_value=Circumstance,
                        fstate_value=fstate,
                        MSA_value=MSA)


new_data <- cbind(new_labels, new_data_only)

new_data <- select(new_data,
                   ID, CNTYFIPS, Ori, State, Agency, AGENCY_A,
                   Agentype_label, Agentype_value,
                   Source_label, Source_value,
                   Solved_label, Solved_value,
                   Year,
                   Month_label, Month_value,
                   Incident, ActionType,
                   Homicide_label, Homicide_value,
                   Situation_label, Situation_value,
                   VicAge,
                   VicSex_label, VicSex_value,
                   VicRace_label, VicRace_value,
                   VicEthnic, OffAge,
                   OffSex_label, OffSex_value,
                   OffRace_label, OffRace_value, 
                   OffEthnic, 
                   Weapon_label, Weapon_value,
                   Relationship_label, Relationship_value,
                   Circumstance_label, Circumstance_value,
                   Subcircum, VicCount, OffCount, FileDate,
                   fstate_label, fstate_value,
                   MSA_label, MSA_value)

View(new_data)

# abaixo apagamos os DF
# porque nao queremos ocupar espaço
rm(data_labels)
rm(data_only)
rm(new_labels)
rm(new_data_only)