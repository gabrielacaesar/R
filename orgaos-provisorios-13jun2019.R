install.packages("tidyverse")
install.packages("dplyr")
install.packages("data.table")
install.packages("scales")

library(tidyverse)
library(dplyr)
library(data.table)
library(scales)

getwd()

# reading file
df <- fread("orgaos-provisorios-levantamento-extracao-em-13jun2019.csv", encoding = "UTF-8")

# renaming columns
colnames(df) <- c("esfera", "partido", "tipo_orgao", "uf", "municipio", 
                  "inicio_vigencia", "fim_vigencia", "situacao", "situacao_vigencia")

#################################
# 1a - Dados totais

# filtering for valid rows
df_total <- df %>%
  dplyr::filter(situacao_vigencia == "Vigente") %>%
  separate(partido, c("nome_partido", "sigla_partido"), sep = " - ")

# renaming parties
df_total$nome_partido[df_total$nome_partido == "NOVO"] <- "Novo"
df_total$nome_partido[df_total$nome_partido == "PATRIOTA"] <- "Patriota"
df_total$nome_partido[df_total$nome_partido == "AVANTE"] <- "Avante"
df_total$nome_partido[df_total$nome_partido == "SOLIDARIEDADE"] <- "SD"
df_total$nome_partido[df_total$nome_partido == "PCDOB"] <- "PCdoB"
df_total$nome_partido[df_total$nome_partido == "REDE"] <- "Rede"
df_total$nome_partido[df_total$nome_partido == "PPS"] <- "Cidadania"

# renaming orgaos
df_total$tipo_orgao[df_total$tipo_orgao == "Órgão provisório"] <- "Comissões provisórias"
df_total$tipo_orgao[df_total$tipo_orgao == "Órgão definitivo"] <- "Diretórios permanentes"
df_total$tipo_orgao[df_total$tipo_orgao == "Comissão interventora"] <- "Comissões interventoras"
df_total$tipo_orgao[df_total$tipo_orgao == "Comissão executiva"] <- "Comissões executivas"

# tidying df
df_total_2 <- df_total %>%
  group_by(tipo_orgao, nome_partido) %>%
  summarise(int = n()) %>%
  spread(tipo_orgao, int) %>%
  `colnames<-`(c("nome_partido", "comissao_executiva", "comissao_interventora", "orgao_provisorio", "orgao_definitivo"))

# adding 0 instead of NA
df_total_2$comissao_executiva[is.na(df_total_2$comissao_executiva)] <- 0
df_total_2$comissao_interventora[is.na(df_total_2$comissao_interventora)] <- 0
df_total_2$orgao_definitivo[is.na(df_total_2$orgao_definitivo)] <- 0
df_total_2$orgao_provisorio[is.na(df_total_2$orgao_provisorio)] <- 0

# creating columns for perc
df_total_3 <- df_total_2 %>%
  mutate(total = comissao_executiva + comissao_interventora + orgao_definitivo + orgao_provisorio) %>%
  mutate(comissao_executiva_perc = (comissao_executiva / total) * 100) %>%
  mutate(comissao_interventora_perc = (comissao_interventora / total) * 100) %>%
  mutate(orgao_definitivo_perc = (orgao_definitivo / total) * 100) %>%
  mutate(orgao_provisorio_perc = (orgao_provisorio / total) * 100)


# 1b - Gráfico com dados totais
df_total_chart <- df_total %>%
  #filter(tipo_orgao != "Comissão executiva", tipo_orgao != "Comissão interventora") %>%
  group_by(tipo_orgao, nome_partido) %>%
  summarise(int = n()) %>%
  ungroup() %>%
  arrange(tipo_orgao) %>%
  group_by(nome_partido) %>%
  mutate(n_total = sum(int))

df_total_plot <- ggplot(df_total_chart, aes(x = reorder(nome_partido, n_total), y = int, fill = tipo_orgao, width = 0.8)) + 
  geom_bar(stat = "identity") +
  coord_flip() + 
  scale_fill_manual("tipo_orgao", values = c("Comissões executivas" = "#D8D8D8", "Comissões interventoras" = "#9398B8", 
                                             "Diretórios permanentes" = "#CB6666", "Comissões provisórias" = "#DC9999")) + 
  scale_y_continuous(labels=function(x) format(x, big.mark = ".", scientific = FALSE)) +
  #labs(title = "Nº de diretórios definitivos e comissões provisórias",
  #     subtitle = "Estrutura temporária é predominante em xx partidos; especiali stas 
  #     dizem que comissões provisórias são 'menos democráticas'",
  #     caption = "Fonte: TSE") +
  theme(axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        legend.title = element_blank(),
        legend.text = element_blank(),
        legend.position="none",
        legend.key.size = unit(0.8, "line"),
        plot.title = element_text(size = 16, face="bold"),
        plot.subtitle = element_blank(),
        plot.caption = element_text()) 

df_total_plot

# 1c - Gráfico com dados totais
# considerando percentuais


df_total_4 <- df_total %>%
  group_by(tipo_orgao, nome_partido) %>%
  summarise(int = n()) %>%
  ungroup() %>%
  arrange(tipo_orgao) %>%
  group_by(nome_partido) %>%
  mutate(n_total = sum(int)) %>%
  mutate(int_perc = int / n_total) %>%
  ungroup() %>%
  add_row(tipo_orgao = "Comissões provisórias", nome_partido = "Novo", int = 0, n_total = 0, int_perc = 0) %>%
  mutate(nome_partido = factor(nome_partido),
         valor_prov = ifelse(tipo_orgao == "Comissões provisórias", int_perc, NA)) %>%
  group_by(nome_partido) %>%
  mutate(valor_prov = mean(valor_prov, na.rm=T)) %>%
  ungroup() %>%
  mutate(nome_partido = fct_reorder(nome_partido, valor_prov)) %>%
  mutate(diretorio_permanente_perc = ifelse(tipo_orgao == "Diretórios permanentes", int_perc, NA)) %>%



df_total_plot_perc <- ggplot(df_total_4, aes(x = nome_partido, y = int_perc, fill = tipo_orgao, width = 0.8)) +
  geom_bar(stat = "identity") +
  #geom_text(aes(label = round(comissao_provisoria_perc, digits = 2)),
  #          hjust = -0.5, size = 3,
  #          position = position_dodge(width = 1),
  #         inherit.aes = TRUE) +
  coord_flip() + 
  scale_fill_manual("tipo_orgao", values =  c("Comissões executivas" = "#D8D8D8", "Comissões interventoras" = "#9398B8", 
                                              "Diretórios permanentes" = "#CB6666", "Comissões provisórias" = "#DC9999"),
                    guide = guide_legend(reverse = TRUE)) +
  scale_y_continuous(labels = percent) +
  #labs(title = "Percentual de cada órgão partidário no Brasil",
  #     subtitle = "xx partidos têm mais de xx% de comissões provisórias, 
  #consideradas por especialistas como 'menos democráticas'",
  #       caption = "Fonte: TSE") +
  theme(axis.title.y = element_blank(),
        axis.title.x = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        legend.title = element_blank(),
        legend.key.size = unit(0.8, "line")) 

df_total_plot_perc

ggsave("test.jpg", units="in", dpi=900)

# 1d - Gráficos do tipo facet_wrap()
# considerando percentuais

# chart below still show 4 variables
df_total_5 <- df_total_4 %>%
  filter(tipo_orgao != "Comissão interventora", tipo_orgao != "Comissão executiva")

df_total_plot_facet_wrap_perc <- ggplot(df_total_5, aes(x = tipo_orgao, y = int_perc, fill = tipo_orgao, width = 0.8)) +
  geom_bar(stat = "identity") +
  facet_grid(~nome_partido, ncol = 5) +
  scale_fill_manual("tipo_orgao", values = c("Órgão definitivo" = "#CB6666", "Órgão provisório" = "#A80000"),
                    guide = guide_legend(reverse = TRUE)) +
  labs(title = "Percentual de cada órgão partidário no Brasil",
       subtitle = "xx partidos têm mais de xx% de comissões provisórias, 
       consideradas por especialistas como 'menos democráticas'",
       caption = "Fonte: TSE") +
  theme(text = element_text(),
        axis.text.y = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks.x = element_blank(),
        axis.ticks.y = element_blank(),
        panel.border = element_blank(),
        panel.background = element_blank(),
        legend.title = element_blank(),
        legend.key.size = unit(0.8, "line"),
        plot.title = element_text(size = 16, face="bold"),
        plot.subtitle = element_text(size = 13),
        plot.caption = element_text(),
        legend.position = "top",
        legend.justification = "left",
        legend.direction = "horizontal") 

df_total_plot_facet_wrap_perc



####################################################################################
####################################################################################
####################################################################################
#                                                                                  #
# 1 - Dados municipais + TOTAL                                                     #
# Um df em que tenhamos as seguintes colunas:                                      #
# partido, número de órgãos definitivos, número de órgãos provisórios,             #
# número de comissões executivas e número de comissões interventoras.              #
#                                                                                  # 
####################################################################################
####################################################################################
####################################################################################

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