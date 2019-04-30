
library(tidyverse)
library(ggplot2)
library(rvest)
library(XML)
library(RCurl)
```

# 1. CLIQUE em "edit" e depois em "replace and find"
# 2. SUBSTITUA o ano por o novo ano
# 3. INSIRA os links dos novos arquivos


## DIESEL

url_diesel_2015 <- "https://gist.githubusercontent.com/gabrielacaesar/41424b4884b2cffed7ddb3b360f35a63/raw/0d7751d0b313811489af168ff7ee7e7b78b25f01/2015-diesel-BR"

file_diesel_2015 <- read_html(url_diesel_2015)
tables_diesel_2015 <- html_nodes(file_diesel_2015, "table")
precos_diesel_2015 <- html_table(tables_diesel_2015[2], fill = TRUE)

df_diesel_2015 <- as.data.frame(precos_diesel_2015)

nome_colunas <- c("uf", "n_postos_pesquisados", "preco_medio_consumidor", "desvio_padrao_consumidor", "preco_min_consumidor", "preco_max_consumidor", "margem_media_consumidor", "preco_medio_distribuidora", "desvio_padrao_distribuidora", "preco_min_distribuidora", "preco_maximo_distribuidora")
names(df_diesel_2015) <- nome_colunas

df_diesel_2015 <- df_diesel_2015 %>% 
  slice(3:29)

head(df_diesel_2015, 10)

length(unique(df_diesel_2015$uf))

df_diesel_2015$combustivel <- "diesel"
df_diesel_2015$ano <- 2015

df_diesel_2015 <- df_diesel_2015 %>% 
  select("uf", "ano", "combustivel", "n_postos_pesquisados", "preco_medio_consumidor", "desvio_padrao_consumidor", "preco_min_consumidor", "preco_max_consumidor", "margem_media_consumidor", "preco_medio_distribuidora", "desvio_padrao_distribuidora", "preco_min_distribuidora", "preco_maximo_distribuidora")

head(df_diesel_2015, 10)


## DIESEL S10


url_diesel_s10_2015 <- "https://gist.githubusercontent.com/gabrielacaesar/7194c40da7e79f9617dc9df88b4da027/raw/0370fc107857b1d6cd311c8c850e0e8975e343c6/2015-diesel-s10-BR"

file_diesel_s10_2015 <- read_html(url_diesel_s10_2015)
tables_diesel_s10_2015 <- html_nodes(file_diesel_s10_2015, "table")
precos_diesel_s10_2015 <- html_table(tables_diesel_s10_2015[2], fill = TRUE)

df_diesel_s10_2015 <- as.data.frame(precos_diesel_s10_2015)

names(df_diesel_s10_2015) <- nome_colunas

df_diesel_s10_2015 <- df_diesel_s10_2015 %>% 
  slice(3:29)

head(df_diesel_s10_2015, 10)



length(unique(df_diesel_s10_2015$uf))

df_diesel_s10_2015$combustivel <- "diesel s10"
df_diesel_s10_2015$ano <- 2015

df_diesel_s10_2015 <- df_diesel_s10_2015 %>% 
  select("uf", "ano", "combustivel", "n_postos_pesquisados", "preco_medio_consumidor", "desvio_padrao_consumidor", "preco_min_consumidor", "preco_max_consumidor", "margem_media_consumidor", "preco_medio_distribuidora", "desvio_padrao_distribuidora", "preco_min_distribuidora", "preco_maximo_distribuidora")

head(df_diesel_s10_2015, 10)



#### ETANOL


url_etanol_2015 <- "https://gist.githubusercontent.com/gabrielacaesar/1dcf8c11c6014b117fc738f292b24ba0/raw/d5a7e2714539c445a57f09833eb4b208b8a3b3a2/2015-etanol-BR"

file_etanol_2015 <- read_html(url_etanol_2015)
tables_etanol_2015 <- html_nodes(file_etanol_2015, "table")
precos_etanol_2015 <- html_table(tables_etanol_2015[2], fill = TRUE)

df_etanol_2015 <- as.data.frame(precos_etanol_2015)

names(df_etanol_2015) <- nome_colunas

df_etanol_2015 <- df_etanol_2015 %>% 
  slice(3:29)

head(df_etanol_2015, 10)


length(unique(df_etanol_2015$uf))


df_etanol_2015$combustivel <- "etanol"
df_etanol_2015$ano <- 2015

df_etanol_2015 <- df_etanol_2015 %>% 
  select("uf", "ano", "combustivel", "n_postos_pesquisados", "preco_medio_consumidor", "desvio_padrao_consumidor", "preco_min_consumidor", "preco_max_consumidor", "margem_media_consumidor", "preco_medio_distribuidora", "desvio_padrao_distribuidora", "preco_min_distribuidora", "preco_maximo_distribuidora")

head(df_etanol_2015, 10)



#### GASOLINA


url_gasolina_2015 <- "https://gist.githubusercontent.com/gabrielacaesar/9ea8e7fe1212826a5d9289eb8b879167/raw/69935920a9cd3c93a30610377a68b228a6b618a7/2015-gasolina-BR"

file_gasolina_2015 <- read_html(url_gasolina_2015)
tables_gasolina_2015 <- html_nodes(file_gasolina_2015, "table")
precos_gasolina_2015 <- html_table(tables_gasolina_2015[2], fill = TRUE)

df_gasolina_2015 <- as.data.frame(precos_gasolina_2015)

names(df_gasolina_2015) <- nome_colunas

df_gasolina_2015 <- df_gasolina_2015 %>% 
  slice(3:29)

head(df_gasolina_2015, 10)



length(unique(df_gasolina_2015$uf))


df_gasolina_2015$combustivel <- "gasolina"
df_gasolina_2015$ano <- 2015

df_gasolina_2015 <- df_gasolina_2015 %>% 
  select("uf", "ano", "combustivel", "n_postos_pesquisados", "preco_medio_consumidor", "desvio_padrao_consumidor", "preco_min_consumidor", "preco_max_consumidor", "margem_media_consumidor", "preco_medio_distribuidora", "desvio_padrao_distribuidora", "preco_min_distribuidora", "preco_maximo_distribuidora")

head(df_gasolina_2015, 10)


#### UNIFICAR

df_combustivel_2015 <- bind_rows(df_diesel_2015, df_diesel_s10_2015, df_etanol_2015, df_gasolina_2015)

df_combustivel_final <- bind_rows(df_combustivel_2019, df_combustivel_2018, df_combustivel_2017, df_combustivel_2016,
                                  df_combustivel_2015)


write.csv(df_combustivel_final, "df_combustivel_final.csv")



## //
## 
## diesel 2019 <- https://gist.githubusercontent.com/gabrielacaesar/1f48e174706cb392d8e0906ab4a22119/raw/02e8ac64e6762debcd3543c95822daaf725125a5/2019-diesel-BR
## 
## diesel s10 2019 <- https://gist.githubusercontent.com/gabrielacaesar/4a6707e1eaea73a1a181b7d2742c7310/raw/c9a4dcdbb08f0f02175b7d738fd6277d2412d427/2019-diesel-s10-BR
## 
## etanol 2019 <- https://gist.githubusercontent.com/gabrielacaesar/55d5240e5e3489107978988a49183646/raw/671995c8ef3a90c87095d7a2bb4b88151a2f8700/2019-etanol-BR
## 
## gasolina 2019 <- https://gist.githubusercontent.com/gabrielacaesar/6db612e2e2d472b1024402f161d64f42/raw/07c7a66d003c5d898046f8d8d6d6db1ea566872e/2019-gasolina-BR
## 
## //
##   
## diesel 2018 <- https://gist.githubusercontent.com/gabrielacaesar/f680085a9e6b1d3734ddb619c7f7cfac/raw/bb4224db0866303616ae8453c2f6e1ae8dcc490f/2018-diesel-BR
## 
## diesel s10 2018 <- https://gist.githubusercontent.com/gabrielacaesar/3ce2fff79e034d39728615b312b7438e/raw/2b328fa75c133e81bc487c4ba07403c0260827a1/2018-diesel-s10-BR
## 
## etanol 2018 <- https://gist.githubusercontent.com/gabrielacaesar/add6d6407cbd0722195891dd615a453a/raw/12e289c47469ef2e2169cddef5f64f51aef40afa/2018-etanol-BR
## 
## gasolina 2018 <- https://gist.githubusercontent.com/gabrielacaesar/addaf9b8f8ab63648ace133112b35ad8/raw/ae083a360c018620516faeaef323bb0059be1531/2018-gasolina-BR
## 
## 
## 
## //
##   
## diesel 2017 <- https://gist.githubusercontent.com/gabrielacaesar/064b31ca67c9507dd193684a1c6631b5/raw/54f614cad96d9cf9472e5fda1b0248fb9f18e48c/2017-diesel-BR
## 
## diesel s10 2017 <- https://gist.githubusercontent.com/gabrielacaesar/ea15549cc734e824d64d517ca0db2334/raw/43a52cbae98c3a3264cb128a5216ef8678a260c0/2017-diesel-s10-BR
## 
## etanol 2017 <- https://gist.githubusercontent.com/gabrielacaesar/3dd6c1920f733c899d35d5847c776f7b/raw/89c78375a64f243b8faf0e066f6b66b1c7c75959/2017-etanol-BR
## 
## gasolina 2017 <- https://gist.githubusercontent.com/gabrielacaesar/448c18b076bb8ad99eb57410ef8395fe/raw/d72c53ebc0f90efcb97c0a8d91177ad244127292/2017-gasolina-BR
## 
## 
## //
##   
## diesel 2016 <- https://gist.githubusercontent.com/gabrielacaesar/8cd68c6cb5bb8e64d5554f9f5022ce98/raw/f4e1a4f6199c4a0e1bb751be4c764a154d78540a/2016-diesel-BR
## 
## diesel s10 2016 <- https://gist.githubusercontent.com/gabrielacaesar/c1e3cfbaf91bf8a2b5dbf355fc40bd34/raw/12b917d1f9b06a3c6477c13675426a0aa10c54a7/2016-diesel-s10-BR
## 
## etanol 2016 <- https://gist.githubusercontent.com/gabrielacaesar/720670799bc5d7e937a58497d3cece4f/raw/888a7c58e7f8e0f09b8dba7d553e773825236a92/2016-etanol-BR
## 
## gasolina 2016 <- https://gist.githubusercontent.com/gabrielacaesar/3b7140f00748899a302e2d6c26d912e0/raw/3bce035614eb0c16d162a6484f1961f00b8775b7/2016-gasolina-BR
## 
## //
##   
## diesel 2015 -> https://gist.githubusercontent.com/gabrielacaesar/41424b4884b2cffed7ddb3b360f35a63/raw/0d7751d0b313811489af168ff7ee7e7b78b25f01/2015-diesel-BR
## 
## diesel s10 2015 -> https://gist.githubusercontent.com/gabrielacaesar/7194c40da7e79f9617dc9df88b4da027/raw/0370fc107857b1d6cd311c8c850e0e8975e343c6/2015-diesel-s10-BR
## 
## etanol -> https://gist.githubusercontent.com/gabrielacaesar/1dcf8c11c6014b117fc738f292b24ba0/raw/d5a7e2714539c445a57f09833eb4b208b8a3b3a2/2015-etanol-BR
## 
## gasolina -> https://gist.githubusercontent.com/gabrielacaesar/9ea8e7fe1212826a5d9289eb8b879167/raw/69935920a9cd3c93a30610377a68b228a6b618a7/2015-gasolina-BR

