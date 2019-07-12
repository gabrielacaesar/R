# 1. carregar e instalar bibliotecas
library(tidyverse)
library(data.table)

# 2. definir o diretório
setwd("~/Downloads/merge-votacao-nominal-11jul2019/consulta_cand_2018")

# 3. importar arquivo dos candidatos
# selecionar colunas que queremos
# filtrar por deputados federais
# filtrar por suplentes e eleitos
# criar coluna com nome de urna em UPPER, sem acento
consulta_cand <- fread("consulta_cand_2018_BRASIL.csv")

consulta_cand_df <- consulta_cand  %>%
  select("SG_UF",
         "DS_CARGO",
         "SQ_CANDIDATO",
         "NM_CANDIDATO",
         "NM_URNA_CANDIDATO",
         "NR_CPF_CANDIDATO",
         "SG_PARTIDO",
         "DT_NASCIMENTO",
         "NR_TITULO_ELEITORAL_CANDIDATO",
         "DS_GENERO",
         "DS_GRAU_INSTRUCAO",
         "DS_ESTADO_CIVIL",
         "DS_COR_RACA",
         "DS_OCUPACAO",
         "DS_SIT_TOT_TURNO",
         "ST_REELEICAO",
         "ST_DECLARAR_BENS") %>%
  filter(DS_CARGO == "DEPUTADO FEDERAL",
         DS_SIT_TOT_TURNO != "NÃO ELEITO", 
         DS_SIT_TOT_TURNO != "#NULO#") %>%
  mutate(nome_upper = iconv(
    str_to_upper(NM_CANDIDATO),
    from = "UTF-8",
    to = "ascii//translit"))

write.csv(consulta_cand_df, "consulta_cand_df_11jul2019.csv")

##

dep_56leg_cd <- fread("deputados-56-leg-camara-deputados.csv")

dep_56leg_cd <- dep_56leg_cd %>%
  mutate(nome_upper = iconv(str_to_upper(nome_civil),
    from = "UTF-8", to = "ascii//translit")) %>%
  mutate(nome_camara_upper = iconv(str_to_upper(nome),
    from = "UTF-8", to = "ascii//translit"))

dep_56leg_cd_completo <- dep_56leg_cd %>%
  left_join(consulta_cand_df, by = "nome_upper") %>%
  select("nome",
         "nome_camara_upper",
         "nome_civil",
         "nome_upper",
         "NM_CANDIDATO",
         "NM_URNA_CANDIDATO",
         "SG_UF",
         "SQ_CANDIDATO",
         "legislatura",
         "votos",
         "NR_CPF_CANDIDATO",
         "SG_PARTIDO",
         "DT_NASCIMENTO",
         "NR_TITULO_ELEITORAL_CANDIDATO",
         "DS_GENERO",
         "DS_GRAU_INSTRUCAO",
         "DS_ESTADO_CIVIL",
         "DS_COR_RACA",
         "DS_OCUPACAO",
         "DS_SIT_TOT_TURNO",
         "ST_REELEICAO",
         "ST_DECLARAR_BENS") %>%
  rename(nome_cd = nome,
         nome_cd_upper = nome_camara_upper,
         nome_completo = nome_civil,
         nome_completo_upper = nome_upper,
         nome_tse = NM_CANDIDATO,
         nome_urna_tse = NM_URNA_CANDIDATO,
         uf = SG_UF,
         sq_cand = SQ_CANDIDATO,
         legislatura = legislatura,
         votos = votos,
         cpf_cand = NR_CPF_CANDIDATO,
         partido = SG_PARTIDO,
         data_nascimento = DT_NASCIMENTO,
         titulo_eleitoral = NR_TITULO_ELEITORAL_CANDIDATO,
         genero = DS_GENERO,
         instrucao = DS_GRAU_INSTRUCAO,
         estado_civil = DS_ESTADO_CIVIL,
         cor_raca = DS_COR_RACA,
         ocupacao = DS_OCUPACAO,
         situacao = DS_SIT_TOT_TURNO,
         reeleicao = ST_REELEICAO,
         declarou_bens = ST_DECLARAR_BENS)

##


dep_cadastrados <- fread("plenario2019_CD_politicos_9jul2019.csv", encoding = "UTF-8")

dep_cadastrados_df <- dep_cadastrados %>%
  select("nome_upper",
         "nome",
         "id",
         "partido",
         "uf",
         "exercicio") %>%
  rename(nome_cd_upper = nome_upper)

# correcoes para padronizar
dep_cadastrados_df$nome_cd_upper[dep_cadastrados_df$nome_cd_upper == "ALENCAR SANTANA BRAGA"] <- "ALENCAR SANTANA"
dep_cadastrados_df$nome_cd_upper[dep_cadastrados_df$nome_cd_upper == "ALEXIS FONTEYNE"] <- "ALEXIS"
dep_cadastrados_df$nome_cd_upper[dep_cadastrados_df$nome_cd_upper == "ARTHUR OLIVEIRA MAIA"] <- "ARTHUR MAIA"

# correcoes para padronizar
dep_56leg_cd_completo$nome_cd_upper[dep_56leg_cd_completo$nome_cd_upper == "PASTOR ABILIO SANTANA"] <- "ABILIO SANTANA"
dep_56leg_cd_completo$nome_cd_upper[dep_56leg_cd_completo$nome_cd_upper == "AUREO"] <- "AUREO RIBEIRO"

# merging
merged_df <- dep_cadastrados_df %>%
  left_join(dep_56leg_cd_completo, by = "nome_cd_upper")


merged_missing <- merged_df %>%
  filter(is.na(SG_UF))

##



