library(sf)
library(ggplot2)
library(mapview)

d1 <- sf::st_read("2022_382019.json") # 松山市以外の場合はファイル名を変更

# 地図を描いてみる
ggplot(d1) +
  geom_sf(aes(fill = issue_year)) +
  theme(legend.position = "none")

# 耕地の種類（田と畑）をファクターに変換
d1$land_type <- factor(d1$land_type, levels = c(100, 200), labels = c("田", "畑"))

# 耕地の種類を区別する
g <- ggplot(d1) +
  geom_sf(aes(fill = land_type)) +
  guides(fill = guide_legend(title = "耕地の種類")) +
  theme_void()
g

# 画像を保存する
ggsave(g, file = "Matsuyama_land_type.png")

# インタラクティブな地図
mapview::mapview(d1)

# 耕地の種類を区別する
mapview::mapview(d1, zcol = "land_type")


# 練習問題
1. これらの地図を使って，何をやってみたいか，5つ以上考えなさい（例：耕地の種類に従って色分けしたい）。
2. 1で考えたことを実行するためのRのコードを考えなさい。
