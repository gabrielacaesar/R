library(tidyverse)

df <- readr::read_csv2("~/Downloads/Ano-2020 2.csv")

# 1) Quais foram os deputados com mais despesas na cota parlamentar (considerando a coluna vlrDocumento)? 

df %>%
  mutate(vlrDocumento = as.numeric(vlrDocumento)) %>%
  #mutate_at(vars(vlrDocumento, vlrGlosa, vlrLiquido),
  #          as.numeric) %>%
  group_by(txNomeParlamentar) %>%
  summarise(total_gasto = sum(vlrDocumento)) %>%
  arrange(desc(total_gasto))

# 2) Quais foram as 5 empresas mais contratadas (considerando a coluna txtCNPJCPF)?

df %>%
  mutate(vlrDocumento = as.numeric(vlrDocumento)) %>%
  group_by(txtCNPJCPF) %>%
  summarise(total_gasto = sum(vlrDocumento)) %>%
  arrange(desc(total_gasto)) %>%
  head(5) 

df %>%
  distinct(txtCNPJCPF, txtFornecedor) %>%
  filter(txtCNPJCPF %in% c("075.756.510/0015-9", "020.128.620/0016-0",
                           "073.193.230/0019-1", "025.581.570/0016-2",
                           "000.000.000/0000-7"))
  
# 3) Qual foi o gasto médio dos deputados, por UF, com a cota parlamentar (considerando a coluna vlrDocumento)?
dep_exercicio <- readxl::read_xls("~/Downloads/deputado.xls")

dep_qt <- dep_exercicio %>%
  group_by(UF) %>%
  summarise(contagem = n()) %>%
  arrange(desc(contagem))

df %>% 
  filter(!str_detect(txNomeParlamentar, "LIDERANÇA")) %>%
  #select(txNomeParlamentar) %>%
  #unique()
  mutate(vlrDocumento = as.numeric(vlrDocumento)) %>%
  group_by(sgUF, txNomeParlamentar) %>%
  summarise(total_gasto = sum(vlrDocumento)) %>%
  arrange(desc(total_gasto))

df %>% 
  filter(!str_detect(txNomeParlamentar, "LIDERANÇA")) %>%
  mutate(vlrDocumento = as.numeric(vlrDocumento)) %>%
  group_by(sgUF) %>%
  summarise(total_gasto = sum(vlrDocumento)) %>%
  arrange(desc(total_gasto)) %>%
  left_join(dep_qt, by = c("sgUF" = "UF")) %>%
  mutate(gasto_medio = total_gasto / contagem) %>%
  arrange(desc(gasto_medio)) 

# 4) Quais categorias de gastos registraram mais despesas nas lideranças (considerando a coluna txtDescricao)?

df %>% 
  filter(str_detect(txNomeParlamentar, "LIDERANÇA")) %>%
  mutate(vlrDocumento = as.numeric(vlrDocumento)) %>%
  group_by(txNomeParlamentar, txtDescricao) %>%
  summarise(total_gasto = sum(vlrDocumento)) %>%
  arrange(desc(total_gasto))

#5) Quantas linhas da coluna com o PDF da nota fiscal estão com NA (considerando a coluna urlDocumento)?

df %>%
  filter(is.na(urlDocumento)) %>%
  count()

#6) Qual foi o mês com menos gastos (considerando a coluna numMes)?

df %>%
  mutate(vlrDocumento = as.numeric(vlrDocumento)) %>%
  group_by(numMes) %>%
  summarise(total_gasto = sum(vlrDocumento)) %>%
  arrange(total_gasto)
