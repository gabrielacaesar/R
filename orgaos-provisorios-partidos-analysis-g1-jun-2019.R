#install.packages("tidyverse")
#install.packages("dplyr")
#install.packages("data.table")
library(tidyverse)
library(dplyr)
library(data.table)

setwd("~/Downloads/")

df <- fread("orgaos-provisorios-levantamento-extracao-em-6-jun-2019.csv", encoding = "UTF-8")

colnames(df) <- c("esfera", "partido", "tipo_orgao", "uf", "municipio", 
               "inicio_vigencia", "fim_vigencia", "situacao", "situacao_vigencia")


# 1 - Dados municipais + TOTAL
# Um df em que tenhamos as seguintes colunas: 
# partido, número de órgãos definitivos, número de órgãos provisórios,
# número de comissões executivas e número de comissões interventoras.
df_municipio <- df %>%
  dplyr::filter(esfera == "Municipal", 
                situacao_vigencia == "Vigente")

df_municipio_2 <- df_municipio %>%
  group_by(tipo_orgao, partido) %>%
  summarise(int = n()) %>%
  spread(tipo_orgao, int) %>%
  `colnames<-`(c("partido", "comissao_interventora", "orgao_definitivo", "orgao_provisorio"))

df_municipio_2$comissao_interventora[is.na(df_municipio_2$comissao_interventora)] <- 0
df_municipio_2$orgao_definitivo[is.na(df_municipio_2$orgao_definitivo)] <- 0
df_municipio_2$orgao_provisorio[is.na(df_municipio_2$orgao_provisorio)] <- 0

df_municipio_3 <- df_municipio_2 %>%
  mutate(total = comissao_interventora + orgao_definitivo + orgao_provisorio) %>%
  mutate(comissao_interventora_perc = (comissao_interventora / total) * 100) %>%
  mutate(orgao_definitivo_perc = (orgao_definitivo / total) * 100) %>%
  mutate(orgao_provisorio_perc = (orgao_provisorio / total) * 100)


# 1 - representar com GRÁFICO

df_municipio_chart <- df_municipio %>%
  group_by(tipo_orgao, partido) %>%
  summarise(int = n()) %>%
  ungroup() %>%
  arrange(tipo_orgao) %>%
  group_by(partido) %>%
  mutate(n_total = sum(int))

df_municipio_plot <- ggplot(df_municipio_chart, aes(x = reorder(partido, n_total), y = int, fill = tipo_orgao)) + 
  geom_bar(stat = "identity") +
  coord_flip() + 
  scale_fill_manual("tipo_orgao", values = c("Órgão definitivo" = "#0B610B", "Órgão provisório" = "#01A9DB", "Comissão interventora" = "#FE9A2E")) + 
  ggtitle("Diretórios municipais de partidos no Brasil") +
  theme(axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        panel.border = element_blank(),
        plot.title = element_text(size = 14, face="bold"),
        plot.caption = element_text(hjust = 0)) 

df_municipio_plot

ggsave("df_municipio_plot.tiff", units = "in", width = 20, height = 40, units = "cm", res = 300)


# 1 - representar com GRÁFICO 2

df_municipio_plot_2 <- ggplot(df_municipio_chart, aes(x=tipo_orgao, y=int)) +
  geom_col(aes(fill = tipo_orgao)) +
  ggtitle("Diretórios municipais de partidos no Brasil") +
  facet_wrap(~ partido, ncol = 5) +
  scale_fill_manual("tipo_orgao", values = c("Órgão definitivo" = "#0B610B", "Órgão provisório" = "#01A9DB", "Comissão interventora" = "#FE9A2E")) +
  theme(legend.position="bottom",
        axis.text.x = element_blank(),
        axis.text.y = element_blank())

df_municipio_plot_2

ggsave("df_municipio_plot_2.tiff", units = "in", width = 20, height = 60, units = "cm", res = 300)

# 2 - Idem do 1 com dados de UFs (estadual ou regional)

df_estadual <- df %>%
  dplyr::filter(esfera == "Estadual" | esfera == "Regional", 
                situacao_vigencia == "Vigente")

df_estadual_2 <- df_estadual %>%
  group_by(tipo_orgao, partido) %>%
  summarise(int = n()) %>%
  spread(tipo_orgao, int) %>%
  `colnames<-`(c("partido", "comissao_interventora", "orgao_definitivo", "orgao_provisorio"))

df_estadual_2$comissao_interventora[is.na(df_estadual_2$comissao_interventora)] <- 0
df_estadual_2$orgao_definitivo[is.na(df_estadual_2$orgao_definitivo)] <- 0
df_estadual_2$orgao_provisorio[is.na(df_estadual_2$orgao_provisorio)] <- 0

df_estadual_2 <- df_estadual_2 %>%
  mutate(total = comissao_interventora + orgao_definitivo + orgao_provisorio) %>%
  mutate(comissao_interventora_perc = (comissao_interventora / total) * 100) %>%
  mutate(orgao_definitivo_perc = (orgao_definitivo / total) * 100) %>%
  mutate(orgao_provisorio_perc = (orgao_provisorio / total) * 100)

# 1 - representar com GRÁFICO

df_estadual_chart <- df_estadual %>%
  group_by(tipo_orgao, partido) %>%
  summarise(int = n()) %>%
  ungroup() %>%
  mutate(n_total = sum(int))

df_estadual_plot <- df_estadual_chart %>%
  ggplot(aes(x = reorder(partido, n_total), y = int, fill = tipo_orgao)) + 
  geom_bar(stat = "identity") +
  coord_flip() + 
  scale_fill_manual("tipo_orgao", values = c("Órgão definitivo" = "#0B610B", 
                                             "Órgão provisório" = "#01A9DB", 
                                             "Comissão interventora" = "#FE9A2E")) +
  ggtitle("Diretórios estaduais de partidos no Brasil")

df_estadual_plot


# 3 - E suspenso no geral? Quais são os motivos?
# São em quais partidos? 
# A falta de prestação de contas é o principal motivo?

df_situacao <- df %>%
  filter(situacao != "Anotado") %>%
  group_by(partido, situacao) %>%
  summarise(int = n()) %>%
  spread(situacao, int) %>%
  `colnames<-`(c("partido", "inativado_por_decisao_do_partido", 
                 "inativado_por_ser_orgao_provisorio_anotado_ha_mais_de_120_dias", 
                 "restabelecido_por_decisao_do_partido", "restabelecido_por_decisao_judicial", 
                 "situacao", "sub_judice", "suspenso_por_falta_de_prestacao_de_contas", 
                 "suspenso_por_nao_informar_o_numero_de_cnpj_no_prazo_de_30_dias_da_anotacao"))
  

df_situacao$inativado_por_decisao_do_partido[is.na(df_situacao$inativado_por_decisao_do_partido)] <- 0
df_situacao$inativado_por_ser_orgao_provisorio_anotado_ha_mais_de_120_dias[is.na(df_situacao$inativado_por_ser_orgao_provisorio_anotado_ha_mais_de_120_dias)] <- 0
df_situacao$restabelecido_por_decisao_do_partido[is.na(df_situacao$restabelecido_por_decisao_do_partido)] <- 0
df_situacao$restabelecido_por_decisao_judicial[is.na(df_situacao$restabelecido_por_decisao_judicial)] <- 0
df_situacao$situacao <- NULL
df_situacao$sub_judice[is.na(df_situacao$sub_judice)] <- 0
df_situacao$suspenso_por_falta_de_prestacao_de_contas[is.na(df_situacao$suspenso_por_falta_de_prestacao_de_contas)] <- 0
df_situacao$suspenso_por_nao_informar_o_numero_de_cnpj_no_prazo_de_30_dias_da_anotacao[is.na(df_situacao$suspenso_por_nao_informar_o_numero_de_cnpj_no_prazo_de_30_dias_da_anotacao)] <- 0

df_situacao <- df_situacao %>%
  mutate(total = inativado_por_decisao_do_partido + 
           inativado_por_ser_orgao_provisorio_anotado_ha_mais_de_120_dias +
           restabelecido_por_decisao_do_partido + 
           restabelecido_por_decisao_judicial +
           sub_judice +
           suspenso_por_falta_de_prestacao_de_contas +
           suspenso_por_nao_informar_o_numero_de_cnpj_no_prazo_de_30_dias_da_anotacao) %>%
  mutate(inativado_por_decisao_do_partido_perc = (inativado_por_decisao_do_partido / total) * 100) %>%
  mutate(inativado_por_ser_orgao_provisorio_anotado_ha_mais_de_120_dias_perc = (inativado_por_ser_orgao_provisorio_anotado_ha_mais_de_120_dias / total) * 100) %>%
  mutate(restabelecido_por_decisao_do_partido_perc = (restabelecido_por_decisao_do_partido/ total) * 100) %>%
  mutate(restabelecido_por_decisao_judicial_perc = (restabelecido_por_decisao_judicial / total) * 100) %>%
  mutate(sub_judice_perc = (sub_judice / total) * 100) %>%
  mutate(suspenso_por_falta_de_prestacao_de_contas_perc = (suspenso_por_falta_de_prestacao_de_contas / total) * 100) %>%
  mutate(suspenso_por_nao_informar_o_numero_de_cnpj_no_prazo_de_30_dias_da_anotacao_perc = (suspenso_por_nao_informar_o_numero_de_cnpj_no_prazo_de_30_dias_da_anotacao / total) * 100)


# 4 - 


