library(tidyverse)
library(igraph)



autores_ppales <- read_csv("data/principales.csv") %>% 
    select(ID, Autor) %>% 
    mutate(tipo = "principal")

autores_citados <- read_csv("data/citados.csv") %>% 
    select(ID, "Autor" = "Autor citado") %>% 
    mutate(tipo = "citado")


autores_ppales_all <- autores_ppales %>% 
    full_join(autores_ppales, by = c("ID")) %>% 
    select(-ID) %>% 
    filter(Autor.x != Autor.y) %>% 
    unique()

autores_gral <- autores_ppales %>% 
    bind_rows(autores_citados) %>% 
    select(-ID) %>% 
    unique()

autores_gral


autores_ppales_all


autores_ppales_citados <- autores_ppales %>% 
    full_join(autores_citados, by = c("ID")) %>% 
    select(-ID) %>% 
    filter(Autor.x != Autor.y) %>% 
    unique()

autores_ppales_citados

autores_full <- autores_ppales_all %>% 
    bind_rows(autores_ppales_citados)


autores_full



links <- autores_full %>% 
    rename("source" = Autor.x, "target" = Autor.y) %>% 
    select(source, target, tipo)

network <- graph_from_data_frame(d=links, directed = FALSE)

deg <- degree(network, mode="all")
deg

nodes <- tibble::enframe(deg)

nodes_d2 <- nodes %>% 
    filter(value > 1) %>% 
    left_join(autores_gral, by = c("name"="Autor"))


write_csv(nodes, "nodes.csv")
write_csv(nodes_d2, "nodes_d2.csv")

write_csv(links, "links.csv")
