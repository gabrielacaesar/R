## checagem de ids e nomes 
## do plenário da legislatura anterior
## agrupamento por nome e id
## verificação se há repetição de id


library(tidyverse)

plenarioCamarasDosDeputados_votos 
plenarioCamarasDosDeputados_politicos
plenarioSenadoFederal_politicos
plenarioSenadoFederal_votos

########################
# CÂMARA DOS DEPUTADOS #
########################

#### VOTOS
cd <- plenarioCamarasDosDeputados_votos %>% 
  group_by(nome_politico, id_politico) %>% 
  summarise(int = n()) %>% 
  arrange(id_politico)

# id_politico
cd_df <- data.frame(table(cd$id_politico))
cd_df[cd_df$Freq > 1,]

# nome_politico
cd_df2 <- data.frame(table(cd$nome_politico))
cd_df2[cd_df2$Freq > 1,]

#### IDs
cd_pol <- plenarioCamarasDosDeputados_politicos %>% 
  group_by(nome, id) %>% 
  summarise() %>% 
  arrange(id)

# id
cd_pol2 <- data.frame(table(cd_pol$id))
cd_pol2[cd_pol2$Freq > 1,]

# nome_politico
cd_pol3 <- data.frame(table(cd_pol$nome))
cd_pol3[cd_pol3$Freq > 1,]


#####################
## SENADO FEDERAL  ##
#####################

#### VOTOS
sf <- plenarioSenadoFederal_votos %>% 
  group_by(nome_politico, id_politico) %>% 
  summarise(int = n()) %>% 
  arrange(id_politico)

# id_politico
sf_df <- data.frame(table(sf$id_politico))
sf_df[sf_df$Freq > 1,]

# nome_politico
sf_df2 <- data.frame(table(sf$nome_politico))
sf_df2[sf_df2$Freq > 1,]

#### IDs
sf_pol <- plenarioSenadoFederal_politicos %>% 
  group_by(nome, id) %>% 
  summarise() %>% 
  arrange(id)

# id
sf_pol2 <- data.frame(table(sf_pol$id))
sf_pol2[sf_pol2$Freq > 1,]

# nome_politico
sf_pol3 <- data.frame(table(sf_pol$nome))
sf_pol3[sf_pol3$Freq > 1,]
