library(ggplot2)
library(patchwork)
library(igraph)
library(ggraph)
library(ggdag)
library(dplyr)
library(scales)

################################################################################################################################################
################################################################--- FIGURE 1 ---################################################################
################################################################################################################################################

#### graph A 
edges_mass_diet <- data.frame(from = c("AD", "AD", "AD",
                                       "FS", "FS", "FS",
                                       "M", "M", "B"),
                              
                              to   = c("M", "MR", "FS",
                                       "M", "B", "MR",
                                       "B", "MR", "MR"))

vertices_mass_diet <- data.frame(name = c("M", "B", "MR", "AD", "FS"))

g_mass_diet <- graph_from_data_frame(edges_mass_diet, vertices = vertices_mass_diet, directed = TRUE)

graph_A <- ggraph(g_mass_diet, layout = "tree") + 
  geom_node_point(colour = c("#ffb062","#ffb062", "#ffb062","#9cd49a","#9cd49a"), size =10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0,0,0,0.3,0,0,0,0,0)) + 
  theme_dag() + 
  coord_cartesian(clip = "off") +
  theme(plot.margin = margin(1,1,1,1, "cm"))

graph_A

#### graph R1
edges_repr_sh <- data.frame(from = c("FM", "GS", "WA", "II", "NO"),
                            
                            to   = c("GS", "WA", "II", "NO", "GL"))

vertices_repr_sh <- data.frame(name = c("FM", "GS", "WA", "II", "NO", "GL"))

g_repr_sh <- graph_from_data_frame(edges_repr_sh, vertices = vertices_repr_sh, directed = TRUE)

graph_R1 <- ggraph(g_repr_sh, layout = "circle") + 
  geom_node_point(colour = c("#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size =10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = -0.1) + 
  theme_dag() + 
  coord_cartesian(clip = "off") +
  theme(plot.margin = margin(1,1,1,1, "cm"))

graph_R1

#### graph R2
edges_repr_fh <- data.frame(from = c("FM", "FM", "FM", "FM", "FM",
                                     "GS", "GS", "GS", "GS",
                                     "WA", "WA", "WA", 
                                     "II", "II",
                                     "NO"),
                              
                              to   = c("GS", "WA", "II", "NO", "GL",
                                       "WA", "II", "NO", "GL",
                                       "II", "NO", "GL",
                                       "NO", "GL",
                                       "GL"))

vertices_repr_fh <- data.frame(name = c("FM", "GS", "WA", "II", "NO", "GL"))

g_repr_fh <- graph_from_data_frame(edges_repr_fh, vertices = vertices_repr_fh, directed = TRUE)

graph_R2 <- ggraph(g_repr_fh, layout = "tree") + 
  geom_node_point(colour = c("#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size =10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = c(0, 0, 0, 0, 0, 0, 0.2, 0.2, 0.2, 0, 0.2, 0.2, 0, 0.2, 0)) + 
  theme_dag() + 
  theme(legend.position = "none") + 
  coord_cartesian(clip = "off") +
  theme(plot.margin = margin(1,1,1,1, "cm"))#,

graph_R2

#### graph C0
edges_repr_m_independent <- data.frame(from = c("M"),
                                       to   = c("FM"))

vertices_repr_m_independent <- data.frame(name = c("M", "FM"))

g_repr_m_independent <- graph_from_data_frame(edges_repr_m_independent, vertices = vertices_repr_m_independent, directed = TRUE)

graph_C0 <- ggraph(g_repr_m_independent, layout = "sugiyama") + # layout: stress, graphopt
  geom_node_point(colour = c("#ffb062", "#f7b8b8"), size =10)+
  theme_dag() + 
  coord_cartesian(clip = "off") +
  theme(plot.margin = margin(1,1,1,1, "cm"))

graph_C0

#### graph C1
edges_repr_m_fm_onlyr <- data.frame(from = c("M"),
                                    to   = c("FM"))

vertices_repr_m_fm_onlyr <- data.frame(name = c("M", "FM"))

g_repr_m_fm_onlyr <- graph_from_data_frame(edges_repr_m_fm_onlyr, vertices = vertices_repr_m_fm_onlyr, directed = TRUE)

graph_C1 <- ggraph(g_repr_m_fm_onlyr, layout = "sugiyama") + 
  geom_node_point(colour = c("#ffb062", "#f7b8b8"), size =10)+
  geom_node_text(aes(label = name))+
  geom_edge_fan(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = 0) + 
  theme_dag() + 
  coord_cartesian(clip = "off") +
  theme(plot.margin = margin(1,1,1,1, "cm"))

graph_C1

#### graph C2
edges_repr_mb_fm_onlyr <- data.frame(from = c("M", "B"),
                                     to   = c("FM","FM"))

vertices_repr_mb_fm_onlyr <- data.frame(name = c("M", "B", "FM"))

g_repr_mb_fm_onlyr <- graph_from_data_frame(edges_repr_mb_fm_onlyr, vertices = vertices_repr_mb_fm_onlyr, directed = TRUE)

graph_C2 <- ggraph(g_repr_mb_fm_onlyr, layout = "sugiyama") + 
  geom_node_point(colour = c("#ffb062","#ffb062", "#f7b8b8"), size =10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = 0) + 
  theme_dag() + 
  coord_cartesian(clip = "off") +
  theme(plot.margin = margin(1,1,1,1, "cm"))#,

graph_C2

#### graph C3
edges_repr_mmr_fm_onlyr <- data.frame(from = c("M", "MR"),
                                      to   = c("FM","FM"))

vertices_repr_mmr_fm_onlyr <- data.frame(name = c("M", "MR", "FM"))

g_repr_mmr_fm_onlyr <- graph_from_data_frame(edges_repr_mmr_fm_onlyr, vertices = vertices_repr_mmr_fm_onlyr, directed = TRUE)

graph_C3 <- ggraph(g_repr_mmr_fm_onlyr, layout = "sugiyama") + 
  geom_node_point(colour = c("#ffb062","#ffb062", "#f7b8b8"), size =10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = 0) + 
  theme_dag() + 
  coord_cartesian(clip = "off") +
  theme(plot.margin = margin(1,1,1,1, "cm"))

graph_C3

#### graph C4
edges_repr_mbmr_fm_onlyr <- data.frame(from = c("M", "B", "MR"),
                                       to   = c("FM","FM","FM"))

vertices_repr_mbmr_fm_onlyr <- data.frame(name = c("M","B", "MR", "FM"))

g_repr_mbmr_fm_onlyr <- graph_from_data_frame(edges_repr_mbmr_fm_onlyr, vertices = vertices_repr_mbmr_fm_onlyr, directed = TRUE)

graph_C4 <- ggraph(g_repr_mbmr_fm_onlyr, layout = "sugiyama") + 
  geom_node_point(colour = c("#ffb062", "#ffb062", "#ffb062", "#f7b8b8"), size =10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = 0) + 
  theme_dag() + 
  coord_cartesian(clip = "off") +
  theme(plot.margin = margin(1,1,1,1, "cm"))

graph_C4

#### graph C5
edges_repr_m_onlyr <- data.frame(from = c("M", "M", "M", "M", "M", "M"),
                                 to   = c("FM", "GS", "WA", "II", "NO", "GL"))

vertices_repr_m_onlyr <- data.frame(name = c("M", "FM", "GS", "WA", "II", "NO", "GL"))

g_repr_m_onlyr <- graph_from_data_frame(edges_repr_m_onlyr, vertices = vertices_repr_m_onlyr, directed = TRUE)

graph_C5 <- ggraph(g_repr_m_onlyr, layout = "sugiyama") + 
  geom_node_point(colour = c("#ffb062", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size =10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = 0) + 
  theme_dag() + 
  coord_cartesian(clip = "off") +
  theme(plot.margin = margin(1,1,1,1, "cm"))

graph_C5

#### graph C6
edges_repr_mbr <- data.frame(from = c("M", "M", "M", "M", "M", "M",
                                      "B", "B", "B", "B", "B", "B"),
                             to   = c("FM", "GS", "WA", "II", "NO", "GL",
                                      "FM", "GS", "WA", "II", "NO", "GL"))

vertices_repr_mbr <- data.frame(name = c("M", "B", "FM", "GS", "WA", "II", "NO", "GL"))

g_repr_mbr <- graph_from_data_frame(edges_repr_mbr, vertices = vertices_repr_mbr, directed = TRUE)

graph_C6 <- ggraph(g_repr_mbr, layout = "sugiyama") + 
  geom_node_point(colour = c("#ffb062","#ffb062", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size =10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = 0) +
  theme_dag() + 
  coord_cartesian(clip = "off") +
  theme(plot.margin = margin(1,1,1,1, "cm"))

graph_C6

#### graph C7
edges_repr_mmrr <- data.frame(from = c("M", "M", "M", "M", "M", "M",
                                       "MR", "MR", "MR", "MR", "MR", "MR"),
                              to   = c("FM", "GS", "WA", "II", "NO", "GL",
                                       "FM", "GS", "WA", "II", "NO", "GL"))

vertices_repr_mmrr <- data.frame(name = c("M", "MR", "FM", "GS", "WA", "II", "NO", "GL"), id = 1:8)

g_repr_mmrr <- graph_from_data_frame(edges_repr_mmrr, vertices = vertices_repr_mmrr, directed = TRUE)

graph_C7 <- ggraph(g_repr_mmrr, layout = "sugiyama") + 
  geom_node_point(colour = c("#ffb062","#ffb062", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size =10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = 0) + 
  theme_dag() + 
  coord_cartesian(clip = "off") +
  theme(plot.margin = margin(1,1,1,1, "cm"))

graph_C7

#### graph C8
edges_repr_mr <- data.frame(from = c("M", "M", "M", "M", "M", "M",
                                     "B", "B", "B", "B", "B", "B",
                                     "MR", "MR", "MR", "MR", "MR", "MR"),
                            to   = c("FM", "GS", "WA", "II", "NO", "GL",
                                     "FM", "GS", "WA", "II", "NO", "GL",
                                     "FM", "GS", "WA", "II", "NO", "GL"))

vertices_repr_mr <- data.frame(name = c("M", "B", "MR", "FM", "GS", "WA", "II", "NO", "GL"))

g_repr_mr <- graph_from_data_frame(edges_repr_mr, vertices = vertices_repr_mr, directed = TRUE)

graph_C8 <- ggraph(g_repr_mr, layout = "sugiyama") +
  geom_node_point(colour = c("#ffb062","#ffb062", "#ffb062", "#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8"), size =10)+
  geom_node_text(aes(label = name))+
  geom_edge_fan(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = 0) + 
  theme_dag() + 
  coord_cartesian(clip = "off") +
  theme(plot.margin = margin(1,1,1,1, "cm"))

graph_C8

#### graph M3
edges_m3 <- data.frame(from = c("FS", "M", "MR", "FM", "GS", "WA", "II", "NO", "GL"),
                       to   = c("Y","Y","Y","Y","Y","Y","Y","Y","Y"))

vertices_m3 <- data.frame(name = c("FS", "M", "MR", "FM", "GS", "WA", "II", "NO", "GL", "Y"))

g_edges_m3 <- graph_from_data_frame(edges_m3, vertices = vertices_m3, directed = TRUE)

graph_M3 <- ggraph(g_edges_m3, layout = "sugiyama") + 
  geom_node_point(colour = c("#9cd49a", "#ffb062", "#ffb062","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","skyblue"), size =10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = 0) + 
  theme_dag() + 
  coord_cartesian(clip = "off") +
  theme(plot.margin = margin(1,1,1,1, "cm"))

graph_M3

#### graph M8
edges_m8 <- data.frame(from = c("AD", "FS", "B", "MR", "FM", "GS", "WA", "II", "NO", "GL"),
                       to   = c("Y", "Y","Y","Y","Y","Y","Y","Y","Y","Y"))

vertices_m8 <- data.frame(name = c("AD", "FS", "B", "MR", "FM", "GS", "WA", "II", "NO", "GL", "Y"))

g_edges_m8 <- graph_from_data_frame(edges_m8, vertices = vertices_m8, directed = TRUE)

graph_M8 <- ggraph(g_edges_m8, layout = "sugiyama") + 
  
  geom_node_point(colour = c("#9cd49a","#9cd49a", "#ffb062", "#ffb062","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","skyblue"), size =10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = 0) + 
  theme_dag() + 
  coord_cartesian(clip = "off") +
  theme(plot.margin = margin(1,1,1,1, "cm"))

graph_M8

#### graph M12
edges_m12 <- data.frame(from = c("AD", "FS", "M", "B", "MR", "FM", "GS", "WA", "II", "NO", "GL"),
                        to   = c("Y","Y","Y","Y","Y","Y","Y","Y","Y","Y","Y"))

vertices_m12 <- data.frame(name = c("AD", "FS", "M", "B", "MR", "FM", "GS", "WA", "II", "NO", "GL", "Y"))

g_edges_m12 <- graph_from_data_frame(edges_m12, vertices = vertices_m12, directed = TRUE)

graph_M12 <- ggraph(g_edges_m12, layout = "sugiyama") + 
  geom_node_point(colour = c("#9cd49a","#9cd49a", "#ffb062", "#ffb062", "#ffb062","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","#f7b8b8","skyblue"), size =10)+
  geom_node_text(aes(label = name))+
  geom_edge_arc(aes(start_cap = circle(0.5, 'cm'), end_cap = circle(0.5, 'cm')),
                angle_calc = "along", arrow = arrow(type="closed", length = unit(2, 'mm')),
                strength = 0) + 
  theme_dag() + 
  coord_cartesian(clip = "off") +
  theme(plot.margin = margin(1,1,1,1, "cm"))

graph_M12

#### full plot
fig_1 <- ((graph_A|graph_R1|graph_R2|graph_C0)/
         (graph_C1|graph_C2|graph_C3|graph_C4)/
         (graph_C5|graph_C6|graph_C7|graph_C8)/
         (graph_M3|graph_M8|graph_M12)+plot_layout(widths = c(1,1,1,1)))
fig_1
ggsave("~/fig_1.pdf", fig_1, width = 13, height = 10)


