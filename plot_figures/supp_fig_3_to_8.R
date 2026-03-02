library(ggplot2)
library(patchwork)
library(igraph)
library(ggraph)
library(ggdag)
library(tidygraph)
library(dplyr)
library(scales)

#### C8_R2_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "B", "B", "B", "B", "B", "B",
                                  "MR", "MR", "MR", "MR", "MR", "MR",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c8_r2_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)

c8_r2_m12 <- ggraph(c8_r2_m12_full, layout = "tree") + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0.1,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c8_r2_m12

c8_layout <- create_layout(as_tbl_graph(c8_r2_m12_full), layout = "tree") ## get layout of this graph so that it can be reused for all other graphs

pos <- as.data.frame(c8_layout) %>%
  select(name, x, y)

#### C7_R2_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "MR", "MR", "MR", "MR", "MR", "MR",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c7_r2_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c7_r2_m12_tbl <- as_tbl_graph(c7_r2_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c7_r2_m12 <- ggraph(c7_r2_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c7_r2_m12

#### C6_R2_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "B", "B", "B", "B", "B", "B",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c6_r2_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c6_r2_m12_tbl <- as_tbl_graph(c6_r2_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c6_r2_m12 <- ggraph(c6_r2_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0.1,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c6_r2_m12


#### C5_R2_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c5_r2_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c5_r2_m12_tbl <- as_tbl_graph(c5_r2_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c5_r2_m12 <- ggraph(c5_r2_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c5_r2_m12

#### C4_R2_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "B",
                                  "MR",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c4_r2_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c4_r2_m12_tbl <- as_tbl_graph(c4_r2_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c4_r2_m12 <- ggraph(c4_r2_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c4_r2_m12

#### C3_R2_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "MR",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c3_r2_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c3_r2_m12_tbl <- as_tbl_graph(c3_r2_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c3_r2_m12 <- ggraph(c3_r2_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c3_r2_m12

#### C2_R2_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "B",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c2_r2_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c2_r2_m12_tbl <- as_tbl_graph(c2_r2_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c2_r2_m12 <- ggraph(c2_r2_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c2_r2_m12

#### C1_R2_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c1_r2_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c1_r2_m12_tbl <- as_tbl_graph(c1_r2_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c1_r2_m12 <- ggraph(c1_r2_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c1_r2_m12

#### C0_R2_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c0_r2_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c0_r2_m12_tbl <- as_tbl_graph(c0_r2_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c0_r2_m12 <- ggraph(c0_r2_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c0_r2_m12

#### C8_R1_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "B", "B", "B", "B", "B", "B",
                                  "MR", "MR", "MR", "MR", "MR", "MR",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c8_r1_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c8_r1_m12_tbl <- as_tbl_graph(c8_r1_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c8_r1_m12 <- ggraph(c8_r1_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0.1,
                             0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c8_r1_m12

#### C7_R1_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "MR", "MR", "MR", "MR", "MR", "MR",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c7_r1_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c7_r1_m12_tbl <- as_tbl_graph(c7_r1_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c7_r1_m12 <- ggraph(c7_r1_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c7_r1_m12

#### C6_R1_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "B", "B", "B", "B", "B", "B",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c6_r1_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c6_r1_m12_tbl <- as_tbl_graph(c6_r1_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c6_r1_m12 <- ggraph(c6_r1_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0.1,
                             0, 0, 0, 0, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c6_r1_m12


#### C5_R1_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c5_r1_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c5_r1_m12_tbl <- as_tbl_graph(c5_r1_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c5_r1_m12 <- ggraph(c5_r1_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c5_r1_m12

#### C4_R1_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "B",
                                  "MR",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c4_r1_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c4_r1_m12_tbl <- as_tbl_graph(c4_r1_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c4_r1_m12 <- ggraph(c4_r1_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0,
                             0, 0, 0, 0, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c4_r1_m12

#### C3_R1_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "MR",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c3_r1_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c3_r1_m12_tbl <- as_tbl_graph(c3_r1_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c3_r1_m12 <- ggraph(c3_r1_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0, 0, 0, 0, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c3_r1_m12

#### C2_R1_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "B",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c2_r1_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c2_r1_m12_tbl <- as_tbl_graph(c2_r1_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c2_r1_m12 <- ggraph(c2_r1_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0, 0, 0, 0, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c2_r1_m12

#### C1_R1_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c1_r1_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c1_r1_m12_tbl <- as_tbl_graph(c1_r1_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c1_r1_m12 <- ggraph(c1_r1_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0, 0, 0, 0, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c1_r1_m12

#### C0_R1_M12
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c0_r1_m12_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c0_r1_m12_tbl <- as_tbl_graph(c0_r1_m12_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c0_r1_m12 <- ggraph(c0_r1_m12_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0,
                             0, 0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c0_r1_m12

#### C8_R2_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "B", "B", "B", "B", "B", "B",
                                  "MR", "MR", "MR", "MR", "MR", "MR",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c8_r2_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c8_r2_m8_tbl <- as_tbl_graph(c8_r2_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c8_r2_m8 <- ggraph(c8_r2_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0.1,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c8_r2_m8

#### C7_R2_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "MR", "MR", "MR", "MR", "MR", "MR",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c7_r2_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c7_r2_m8_tbl <- as_tbl_graph(c7_r2_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c7_r2_m8 <- ggraph(c7_r2_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c7_r2_m8

#### C6_R2_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "B", "B", "B", "B", "B", "B",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c6_r2_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c6_r2_m8_tbl <- as_tbl_graph(c6_r2_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c6_r2_m8 <- ggraph(c6_r2_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0.1,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c6_r2_m8


#### C5_R2_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c5_r2_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c5_r2_m8_tbl <- as_tbl_graph(c5_r2_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c5_r2_m8 <- ggraph(c5_r2_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c5_r2_m8

#### C4_R2_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "B",
                                  "MR",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c4_r2_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c4_r2_m8_tbl <- as_tbl_graph(c4_r2_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c4_r2_m8 <- ggraph(c4_r2_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c4_r2_m8

#### C3_R2_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "MR",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c3_r2_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c3_r2_m8_tbl <- as_tbl_graph(c3_r2_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c3_r2_m8 <- ggraph(c3_r2_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c3_r2_m8

#### C2_R2_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "B",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c2_r2_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c2_r2_m8_tbl <- as_tbl_graph(c2_r2_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c2_r2_m8 <- ggraph(c2_r2_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c2_r2_m8

#### C1_R2_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c1_r2_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c1_r2_m8_tbl <- as_tbl_graph(c1_r2_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c1_r2_m8 <- ggraph(c1_r2_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c1_r2_m8

#### C0_R2_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c0_r2_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c0_r2_m8_tbl <- as_tbl_graph(c0_r2_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c0_r2_m8 <- ggraph(c0_r2_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c0_r2_m8

#### C8_R1_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "B", "B", "B", "B", "B", "B",
                                  "MR", "MR", "MR", "MR", "MR", "MR",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c8_r1_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c8_r1_m8_tbl <- as_tbl_graph(c8_r1_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c8_r1_m8 <- ggraph(c8_r1_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0.1,
                             0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c8_r1_m8

#### C7_R1_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "MR", "MR", "MR", "MR", "MR", "MR",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c7_r1_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c7_r1_m8_tbl <- as_tbl_graph(c7_r1_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c7_r1_m8 <- ggraph(c7_r1_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c7_r1_m8

#### C6_R1_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "B", "B", "B", "B", "B", "B",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c6_r1_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c6_r1_m8_tbl <- as_tbl_graph(c6_r1_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c6_r1_m8 <- ggraph(c6_r1_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0.1,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c6_r1_m8


#### C5_R1_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c5_r1_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c5_r1_m8_tbl <- as_tbl_graph(c5_r1_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c5_r1_m8 <- ggraph(c5_r1_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c5_r1_m8

#### C4_R1_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "B",
                                  "MR",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c4_r1_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c4_r1_m8_tbl <- as_tbl_graph(c4_r1_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c4_r1_m8 <- ggraph(c4_r1_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c4_r1_m8

#### C3_R1_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "MR",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c3_r1_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c3_r1_m8_tbl <- as_tbl_graph(c3_r1_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c3_r1_m8 <- ggraph(c3_r1_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c3_r1_m8

#### C2_R1_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "B",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c2_r1_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c2_r1_m8_tbl <- as_tbl_graph(c2_r1_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c2_r1_m8 <- ggraph(c2_r1_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c2_r1_m8

#### C1_R1_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c1_r1_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c1_r1_m8_tbl <- as_tbl_graph(c1_r1_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c1_r1_m8 <- ggraph(c1_r1_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0, 0, 0, 0, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c1_r1_m8

#### C0_R1_M8
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c0_r1_m8_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c0_r1_m8_tbl <- as_tbl_graph(c0_r1_m8_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c0_r1_m8 <- ggraph(c0_r1_m8_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c0_r1_m8

#### C8_R2_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "B", "B", "B", "B", "B", "B",
                                  "MR", "MR", "MR", "MR", "MR", "MR",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c8_r2_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c8_r2_m3_tbl <- as_tbl_graph(c8_r2_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c8_r2_m3 <- ggraph(c8_r2_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0.1,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c8_r2_m3

#### C7_R2_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "MR", "MR", "MR", "MR", "MR", "MR",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c7_r2_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c7_r2_m3_tbl <- as_tbl_graph(c7_r2_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c7_r2_m3 <- ggraph(c7_r2_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c7_r2_m3

#### C6_R2_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "B", "B", "B", "B", "B", "B",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c6_r2_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c6_r2_m3_tbl <- as_tbl_graph(c6_r2_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c6_r2_m3 <- ggraph(c6_r2_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0.1,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c6_r2_m3

#### C5_R2_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c5_r2_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c5_r2_m3_tbl <- as_tbl_graph(c5_r2_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c5_r2_m3 <- ggraph(c5_r2_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c5_r2_m3

#### C4_R2_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "B",
                                  "MR",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c4_r2_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c4_r2_m3_tbl <- as_tbl_graph(c4_r2_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c4_r2_m3 <- ggraph(c4_r2_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c4_r2_m3

#### C3_R2_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "MR",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c3_r2_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c3_r2_m3_tbl <- as_tbl_graph(c3_r2_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c3_r2_m3 <- ggraph(c3_r2_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c3_r2_m3

#### C2_R2_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "B",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c2_r2_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c2_r2_m3_tbl <- as_tbl_graph(c2_r2_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c2_r2_m3 <- ggraph(c2_r2_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c2_r2_m3

#### C1_R2_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c1_r2_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c1_r2_m3_tbl <- as_tbl_graph(c1_r2_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c1_r2_m3 <- ggraph(c1_r2_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c1_r2_m3

#### C0_R2_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "FM", "FM", "FM", "FM", "FM", "GS", "GS", "GS", "GS", "WA", "WA", "WA", "II", "II", "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "GS", "WA", "II", "NO", "GL", "WA", "II", "NO", "GL", "II", "NO", "GL",  "NO", "GL", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c0_r2_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c0_r2_m3_tbl <- as_tbl_graph(c0_r2_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c0_r2_m3 <- ggraph(c0_r2_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0.1, 0, 0.1, 0.1, 0, 0.1, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c0_r2_m3

#### C8_R1_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "B", "B", "B", "B", "B", "B",
                                  "MR", "MR", "MR", "MR", "MR", "MR",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c8_r1_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c8_r1_m3_tbl <- as_tbl_graph(c8_r1_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c8_r1_m3 <- ggraph(c8_r1_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0.1,
                             0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c8_r1_m3

#### C7_R1_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "MR", "MR", "MR", "MR", "MR", "MR",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c7_r1_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c7_r1_m3_tbl <- as_tbl_graph(c7_r1_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c7_r1_m3 <- ggraph(c7_r1_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c7_r1_m3

#### C6_R1_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "B", "B", "B", "B", "B", "B",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c6_r1_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c6_r1_m3_tbl <- as_tbl_graph(c6_r1_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c6_r1_m3 <- ggraph(c6_r1_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0.1, 0.1, 0.1,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c6_r1_m3


#### C5_R1_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M", "M", "M", "M", "M", "M",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM", "GS", "WA", "II", "NO", "GL",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c5_r1_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c5_r1_m3_tbl <- as_tbl_graph(c5_r1_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c5_r1_m3 <- ggraph(c5_r1_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c5_r1_m3

#### C4_R1_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "B",
                                  "MR",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c4_r1_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c4_r1_m3_tbl <- as_tbl_graph(c4_r1_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c4_r1_m3 <- ggraph(c4_r1_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c4_r1_m3

#### C3_R1_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "MR",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c3_r1_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c3_r1_m3_tbl <- as_tbl_graph(c3_r1_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c3_r1_m3 <- ggraph(c3_r1_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c3_r1_m3

#### C2_R1_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "B",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "FM",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c2_r1_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c2_r1_m3_tbl <- as_tbl_graph(c2_r1_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c2_r1_m3 <- ggraph(c2_r1_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c2_r1_m3

#### C1_R1_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "M",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "FM",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c1_r1_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c1_r1_m3_tbl <- as_tbl_graph(c1_r1_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c1_r1_m3 <- ggraph(c1_r1_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 
                             0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c1_r1_m3

#### C0_R1_M3
edges_full <- data.frame(from = c("AD", "AD", "AD", "FS", "FS", "FS", "M", "M", "B",
                                  "FM", "GS", "WA", "II",  "NO",
                                  "M", "MR", "FS", "FM", "GS", "WA", "II", "NO", "GL"),
                         
                         to = c("M", "MR", "FS", "M", "B", "MR", "B", "MR", "MR",
                                "GS", "WA", "II", "NO", "GL",
                                "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y", "Y"))

vertices_full <- data.frame(name = c("Y", "M", "B", "MR", "AD", "FS", "FM", "GS", "WA", "II", "NO", "GL"))

c0_r1_m3_full <- graph_from_data_frame(edges_full, vertices = vertices_full, directed = TRUE)
c0_r1_m3_tbl <- as_tbl_graph(c0_r1_m3_full) %>% activate(nodes) %>% left_join(pos, by = "name")

c0_r1_m3 <- ggraph(c0_r1_m3_tbl, layout = "manual", x = x, y = y) + 
  geom_node_point(colour = c("skyblue","#ffb062","#ffb062","#ffb062","#9cd49a","#9cd49a", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size = 10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0.1, 0, 0, 0, 0, 0,
                             0, 0, 0, 0, 0,
                             0, 0.1, 0.1, 0, 0, 0, 0, 0, 0)) +
  theme_dag() 

c0_r1_m3

################################################################################################################################################
##################################################--- ORGANIZE INTO SUPPLEMENTARY FIGURES ---###################################################
################################################################################################################################################
graphs_R1_M3 <- ((c0_r1_m3|c1_r1_m3|c2_r1_m3)/
                   (c3_r1_m3|c4_r1_m3|c5_r1_m3)/
                   (c6_r1_m3|c7_r1_m3|c8_r1_m3)+
                   plot_layout(widths = c(1,1,1)) +
                   plot_annotation(tag_levels = "A") &
                   theme(
                     plot.tag = element_text(size = 16, face = "bold"),
                     plot.tag.position = c(0, 1)
                   ))
graphs_R1_M3
ggsave("~/supp_fig_graphs_3.pdf", graphs_R1_M3, width = 17, height = 14)

graphs_R2_M3 <- ((c0_r2_m3|c1_r2_m3|c2_r2_m3)/
                   (c3_r2_m3|c4_r2_m3|c5_r2_m3)/
                   (c6_r2_m3|c7_r2_m3|c8_r2_m3)+
                   plot_layout(widths = c(1,1,1)) +
                   plot_annotation(tag_levels = "A") &
                   theme(
                     plot.tag = element_text(size = 16, face = "bold"),
                     plot.tag.position = c(0, 1)
                   ))
graphs_R2_M3
ggsave("~/supp_fig_graphs_4.pdf", graphs_R2_M3, width = 17, height = 14)

graphs_R1_M8 <- ((c0_r1_m8|c1_r1_m8|c2_r1_m8)/
                   (c3_r1_m8|c4_r1_m8|c5_r1_m8)/
                   (c6_r1_m8|c7_r1_m8|c8_r1_m8)+
                   plot_layout(widths = c(1,1,1)) +
                   plot_annotation(tag_levels = "A") &
                   theme(
                     plot.tag = element_text(size = 16, face = "bold"),
                     plot.tag.position = c(0, 1)
                   ))
graphs_R1_M8
ggsave("~/supp_fig_graphs_5.pdf", graphs_R1_M8, width = 17, height = 14)

graphs_R2_M8 <- ((c0_r2_m8|c1_r2_m8|c2_r2_m8)/
                   (c3_r2_m8|c4_r2_m8|c5_r2_m8)/
                   (c6_r2_m8|c7_r2_m8|c8_r2_m8)+
                   plot_layout(widths = c(1,1,1)) +
                   plot_annotation(tag_levels = "A") &
                   theme(
                     plot.tag = element_text(size = 16, face = "bold"),
                     plot.tag.position = c(0, 1)
                   ))
graphs_R2_M8
ggsave("~/supp_fig_graphs_6.pdf", graphs_R2_M8, width = 17, height = 14)

graphs_R1_M12 <- ((c0_r1_m12|c1_r1_m12|c2_r1_m12)/
                    (c3_r1_m12|c4_r1_m12|c5_r1_m12)/
                    (c6_r1_m12|c7_r1_m12|c8_r1_m12)+
                    plot_layout(widths = c(1,1,1)) +
                    plot_annotation(tag_levels = "A") &
                    theme(
                      plot.tag = element_text(size = 16, face = "bold"),
                      plot.tag.position = c(0, 1)
                    ))
graphs_R1_M12
ggsave("~/supp_fig_7.pdf", graphs_R1_M12, width = 17, height = 14)

graphs_R2_M12 <- ((c0_r2_m12|c1_r2_m12|c2_r2_m12)/
                    (c3_r2_m12|c4_r2_m12|c5_r2_m12)/
                    (c6_r2_m12|c7_r2_m12|c8_r2_m12)+
                    plot_layout(widths = c(1,1,1)) +
                    plot_annotation(tag_levels = "A") &
                    theme(
                      plot.tag = element_text(size = 16, face = "bold"),
                      plot.tag.position = c(0, 1)
                    ))
graphs_R2_M12
ggsave("~/supp_fig_8.pdf", graphs_R2_M12, width = 17, height = 14)
