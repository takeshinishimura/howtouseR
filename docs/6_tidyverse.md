# tidyverse {#ch6}

これまでは base R を使ってきました。
しかし，近年，Rの中でも [tidyverse](https://www.tidyverse.org){target="_blank"} を使うケースが一般的になりました。

伝統的な R の使い方である base R に対して，tidyverse は R 3.x あたりで登場しました。
tidyverse が登場して以降，これまでの伝統的な R のコードは base R と呼ばれるようになりました。
それでは，base R とは何でしょうか，tidyverse とは何でしょうか。
これらを説明するのはやや難しいです。
しかし，感覚的な違いがありますので，この感覚を身に付けることを目指しましょう。

ここでは，base R と tidyverse の違いについて，実践的に学びます。

## base R

まず，次のようなデータがあるとします。

``` r
year <- 1990:2025
x1 <- 100 * 1:length(year)
x2 <- 100 * length(year):1
df　<- data.frame(year = year, 南 = x1, 北 = x2)
```

このデータフレーム `df` の中から2000年代以降のデータを取り出して，`南` 列の平均を計算する場合，次のようなコードになります。

``` r
minami2000 <- df[df$year >= 2000, "南"]
mean(minami2000)
```

```
## [1] 2350
```
また，同じことは次のようにしても実行できます。

``` r
minami2000 <- df$南[df$year >= 2000]
mean(minami2000)
```

```
## [1] 2350
```

もしこの後に，`北` 列の合計を計算したい場合は，次のようなコードにした方がいいかもしれません。

``` r
df2000 <- df[df$year >= 2000, ]
mean(df2000$南)
```

```
## [1] 2350
```

``` r
sum(df2000$北)
```

```
## [1] 35100
```

上に示したコードのいずれにも共通するのが，新たな変数を作成している点です。
コードを書くようになると，作業途中に必要な変数の名前を考えるのが面倒になってきます。
こうした変数が少ない場合は特に問題となりませんが，多くなってくると意味のある変数名がなかなか思い浮かびません。
どうすればよいか正解があるわけではないし，いちいち考えるのが面倒なので，`tmp` とか `df2` や `df3` といった変数名にしがちですが，どの場合も後々に見て意味が分かりにくいです。

そこで，例えば，次のようにすることもあります。

``` r
mean(df[df$year >= 2000, "南"])
```

```
## [1] 2350
```

``` r
sum(df[df$year >= 2000, "北"])
```

```
## [1] 35100
```
ただし，これらのコードの問題は，人間が見て分かりにくいということです。
これは，右から左に解釈していくためです。
右から左ではなく，左から右に処理が進む方が人間（日本語や英語話者）にとって理解しやすいです。
そこで，他の多くの言語にあるパイプ演算子の機能が R にも備わるようになりました。


## tidyverse

パイプ演算 `%>%` は `magrittr` パッケージをロードすると使えるようになります。

``` r
library(magrittr)
library(dplyr)
library(tidyr)

df %>%
  filter(year >= 2000) %>%
  pull(南) %>%
  mean()
```

```
## [1] 2350
```
`filter()` と `pull()` は `dplyr` パッケージの関数です。
ここでは，`library(tidyr)` は関係ありませんが，後で出てくるため，ここでロードしています。

パイプ演算子があまりにも便利なため，R は 4.1.0 で公式にパイプ演算子を採用しました。
R 公式のパイプ演算子は `|>` です。

``` r
df |>
  filter(year >= 2000) |>
  pull(南) |>
  mean()
```

```
## [1] 2350
```
`%>%` と `|>` はどちらを使っても同じ場合が多いですが，`%>%` の方が機能が多いため，完全に同じではありません。
大きな違いはプレイスホルダー `.` の扱いです。
置き換え可能な場合は，`|>` を使うことをおすすめします。

パイプ演算子は base R の関数と組み合わせて使うことができます。

``` r
df |>
  filter(year >= 2000) |>
  head()
```

```
##   year   南   北
## 1 2000 1100 2600
## 2 2001 1200 2500
## 3 2002 1300 2400
## 4 2003 1400 2300
## 5 2004 1500 2200
## 6 2005 1600 2100
```

**パイプ演算子を使うと，その前のデータが次に書く関数の最初の引数として自動的に渡されます。**
この文章の意味が理解できるまで，知っている関数をいろいろ使ってみてください。

処理結果を新しい変数に代入する場合は，base R の作法に従います。

``` r
df2000 <- df |>
  filter(year >= 2000)
```
ちなみに，次のようにすることもできますが，このようなコードはあまり見ません。

``` r
df |>
  filter(year >= 2000) -> df2000
```

tidyverse とは `dplyr` のような，パイプ演算子を使うことを前提に考えられた（正確には少し違う）パッケージ群のことです。
tidyverse を構成するパッケージは[ここ](https://www.tidyverse.org/packages/){target="_blank"}から確認できます。

### データフレーム

tidyverse で使われるデータフレームは [tibble](https://tibble.tidyverse.org/){target="_blank"} です。
普通のデータフレームと `tibble` は互換性がありますので，特に意識する必要はありません。
どちらもデータフレームと呼びます。

ただし，データフレームの形には，ワイドとロングがあり，これらの違いを意識する必要があります。
ワイドはMicrosoft Excelでよく見る，複数の列がある表のようなデータフレームのことです。
一方，ロングは縦に長いデータフレームです。

ロングとワイドは [tidyr](https://tidyr.tidyverse.org/){target="_blank"} の関数を使って簡単に変換することができます。
まず，ワイドは次のようなデータフレームです。

``` r
head(df)
```

```
##   year  南   北
## 1 1990 100 3600
## 2 1991 200 3500
## 3 1992 300 3400
## 4 1993 400 3300
## 5 1994 500 3200
## 6 1995 600 3100
```

``` r
dim(df)
```

```
## [1] 36  3
```
これをロングに変換すると次のようなデータフレームになります。

``` r
df_long <- tidyr::pivot_longer(df, cols = -year)
df_long
```

```
## # A tibble: 72 × 3
##     year name  value
##    <int> <chr> <dbl>
##  1  1990 南      100
##  2  1990 北     3600
##  3  1991 南      200
##  4  1991 北     3500
##  5  1992 南      300
##  6  1992 北     3400
##  7  1993 南      400
##  8  1993 北     3300
##  9  1994 南      500
## 10  1994 北     3200
## # ℹ 62 more rows
```
関数 `pivot_longer()` の引数 `cols` では，ピボットする列を指定します。
ここでは，`year` を除く列を使ってロングにしたいため，`year` にマイナスを付けて `-year` としています。

上のコードは次のようにしても同じ結果が得られます。

``` r
df_long <- tidyr::pivot_longer(df, cols = c(南, 北))
df_long <- tidyr::pivot_longer(df, cols = 南:北)
```
このように，tidyverse で列名を指定するときは，`""` は必要ありません。
ただし，付けてもエラーにはなりません。

なお，tidyverse で作成したデータフレームは `tibble` になります。
`tibble` の便利な点は，`head()` や `dim()` をわざわざ実行しなくても，データフレームの概要が分かることです。

`ggplot2` パッケージの `ggplot()` で図を描く場合，ロングの方がデータを扱いやすいです。
一方，`lm()` などの回帰分析にはワイドのデータが向いています。

ロングからワイドへの変換は次のようにします。

``` r
df_wide <- tidyr::pivot_wider(df_long, names_from = name)
df_wide
```

```
## # A tibble: 36 × 3
##     year    南    北
##    <int> <dbl> <dbl>
##  1  1990   100  3600
##  2  1991   200  3500
##  3  1992   300  3400
##  4  1993   400  3300
##  5  1994   500  3200
##  6  1995   600  3100
##  7  1996   700  3000
##  8  1997   800  2900
##  9  1998   900  2800
## 10  1999  1000  2700
## # ℹ 26 more rows
```
なお，Google検索したり，古い文献を見ると，ロングとワイドの変換に `tidyr::spread()` や `tidyr::gather()` などが使用されているケースがあります。
これらの関数は `superseded` になっています。
古い関数ですので，覚える必要はありません。


### よく使う関数

次に `iris` を使って base R と tidyverse の違いを確認しておきます。
以下では名前空間（`dplyr::` の部分）をわざわざ書いていますが，実際にコードを書くときは書かなくてもよいです。
ここでは，分かりやすさを優先して書いています。

#### filter()

`filter()` で条件を満たす列を抽出します。

``` r
iris[iris$Sepal.Length > 7, ]
```

```
##     Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
## 103          7.1         3.0          5.9         2.1 virginica
## 106          7.6         3.0          6.6         2.1 virginica
## 108          7.3         2.9          6.3         1.8 virginica
## 110          7.2         3.6          6.1         2.5 virginica
## 118          7.7         3.8          6.7         2.2 virginica
## 119          7.7         2.6          6.9         2.3 virginica
## 123          7.7         2.8          6.7         2.0 virginica
## 126          7.2         3.2          6.0         1.8 virginica
## 130          7.2         3.0          5.8         1.6 virginica
## 131          7.4         2.8          6.1         1.9 virginica
## 132          7.9         3.8          6.4         2.0 virginica
## 136          7.7         3.0          6.1         2.3 virginica
```

``` r
iris |>
  dplyr::filter(Sepal.Length > 7)
```

```
##    Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
## 1           7.1         3.0          5.9         2.1 virginica
## 2           7.6         3.0          6.6         2.1 virginica
## 3           7.3         2.9          6.3         1.8 virginica
## 4           7.2         3.6          6.1         2.5 virginica
## 5           7.7         3.8          6.7         2.2 virginica
## 6           7.7         2.6          6.9         2.3 virginica
## 7           7.7         2.8          6.7         2.0 virginica
## 8           7.2         3.2          6.0         1.8 virginica
## 9           7.2         3.0          5.8         1.6 virginica
## 10          7.4         2.8          6.1         1.9 virginica
## 11          7.9         3.8          6.4         2.0 virginica
## 12          7.7         3.0          6.1         2.3 virginica
```

``` r
head(iris[iris$Species == "setosa", ])
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```

``` r
iris |>
  dplyr::filter(Species == "setosa") |>
  head()
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          5.1         3.5          1.4         0.2  setosa
## 2          4.9         3.0          1.4         0.2  setosa
## 3          4.7         3.2          1.3         0.2  setosa
## 4          4.6         3.1          1.5         0.2  setosa
## 5          5.0         3.6          1.4         0.2  setosa
## 6          5.4         3.9          1.7         0.4  setosa
```

tidyverse が常に分かりやすいとは限りません。
例えば，次の2つのコードを比較してみてください。

``` r
head(iris[iris$Sepal.Length > mean(iris$Sepal.Length), ])
```

```
##    Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
## 51          7.0         3.2          4.7         1.4 versicolor
## 52          6.4         3.2          4.5         1.5 versicolor
## 53          6.9         3.1          4.9         1.5 versicolor
## 55          6.5         2.8          4.6         1.5 versicolor
## 57          6.3         3.3          4.7         1.6 versicolor
## 59          6.6         2.9          4.6         1.3 versicolor
```

``` r
iris |>
  dplyr::filter(Sepal.Length > iris |>
                  dplyr::summarise(mean_length = mean(Sepal.Length)) |>
                  dplyr::pull(mean_length)) |>
  head()
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
## 1          7.0         3.2          4.7         1.4 versicolor
## 2          6.4         3.2          4.5         1.5 versicolor
## 3          6.9         3.1          4.9         1.5 versicolor
## 4          6.5         2.8          4.6         1.5 versicolor
## 5          6.3         3.3          4.7         1.6 versicolor
## 6          6.6         2.9          4.6         1.3 versicolor
```
後者のようなコードを書きたい場合は，次のように，tidyverse と base R を組み合わせるのがよいでしょう。

``` r
iris |>
  dplyr::filter(Sepal.Length > mean(Sepal.Length)) |>
  head()
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width    Species
## 1          7.0         3.2          4.7         1.4 versicolor
## 2          6.4         3.2          4.5         1.5 versicolor
## 3          6.9         3.1          4.9         1.5 versicolor
## 4          6.5         2.8          4.6         1.5 versicolor
## 5          6.3         3.3          4.7         1.6 versicolor
## 6          6.6         2.9          4.6         1.3 versicolor
```

#### select()

`select()` で必要な列のみを取り出します。

``` r
head(iris["Species"])
```

```
##   Species
## 1  setosa
## 2  setosa
## 3  setosa
## 4  setosa
## 5  setosa
## 6  setosa
```

``` r
iris |>
  dplyr::select(Species) |>
  head()
```

```
##   Species
## 1  setosa
## 2  setosa
## 3  setosa
## 4  setosa
## 5  setosa
## 6  setosa
```

#### pull()

列をベクトルで取り出したい場合は，`pull()` を使います。

``` r
head(iris$Species)
```

```
## [1] setosa setosa setosa setosa setosa setosa
## Levels: setosa versicolor virginica
```

``` r
iris |>
  dplyr::pull(Species) |>
  head()
```

```
## [1] setosa setosa setosa setosa setosa setosa
## Levels: setosa versicolor virginica
```

#### mutate()

`mutate()` で新しい列を作成します。
その前に，`iris` を変更したくないので，`iris` のコピーを作成して，それをいじることにします。

``` r
iris2 <- iris
iris2$new_species <- iris2$Species
head(iris2)
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species new_species
## 1          5.1         3.5          1.4         0.2  setosa      setosa
## 2          4.9         3.0          1.4         0.2  setosa      setosa
## 3          4.7         3.2          1.3         0.2  setosa      setosa
## 4          4.6         3.1          1.5         0.2  setosa      setosa
## 5          5.0         3.6          1.4         0.2  setosa      setosa
## 6          5.4         3.9          1.7         0.4  setosa      setosa
```

``` r
iris |>
  dplyr::mutate(new_species = Species) |>
  head()
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species new_species
## 1          5.1         3.5          1.4         0.2  setosa      setosa
## 2          4.9         3.0          1.4         0.2  setosa      setosa
## 3          4.7         3.2          1.3         0.2  setosa      setosa
## 4          4.6         3.1          1.5         0.2  setosa      setosa
## 5          5.0         3.6          1.4         0.2  setosa      setosa
## 6          5.4         3.9          1.7         0.4  setosa      setosa
```

また，既存の列を修正するのにも `mutate()` を使用します。

``` r
iris2$Sepal.Length <- iris2$Sepal.Length * 100
head(iris2)
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species new_species
## 1          510         3.5          1.4         0.2  setosa      setosa
## 2          490         3.0          1.4         0.2  setosa      setosa
## 3          470         3.2          1.3         0.2  setosa      setosa
## 4          460         3.1          1.5         0.2  setosa      setosa
## 5          500         3.6          1.4         0.2  setosa      setosa
## 6          540         3.9          1.7         0.4  setosa      setosa
```

``` r
iris |>
  dplyr::mutate(Sepal.Length = Sepal.Length * 100) |>
  head()
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width Species
## 1          510         3.5          1.4         0.2  setosa
## 2          490         3.0          1.4         0.2  setosa
## 3          470         3.2          1.3         0.2  setosa
## 4          460         3.1          1.5         0.2  setosa
## 5          500         3.6          1.4         0.2  setosa
## 6          540         3.9          1.7         0.4  setosa
```

#### count()


``` r
table(iris$Species)
```

```
## 
##     setosa versicolor  virginica 
##         50         50         50
```

``` r
iris |>
  dplyr::count(Species)
```

```
##      Species  n
## 1     setosa 50
## 2 versicolor 50
## 3  virginica 50
```

#### arrange()


``` r
iris2 <- iris[order(iris$Sepal.Length, decreasing = TRUE), ]
head(iris2)
```

```
##     Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
## 132          7.9         3.8          6.4         2.0 virginica
## 118          7.7         3.8          6.7         2.2 virginica
## 119          7.7         2.6          6.9         2.3 virginica
## 123          7.7         2.8          6.7         2.0 virginica
## 136          7.7         3.0          6.1         2.3 virginica
## 106          7.6         3.0          6.6         2.1 virginica
```

``` r
iris |>
  dplyr::arrange(dplyr::desc(Sepal.Length)) |>
  head()
```

```
##   Sepal.Length Sepal.Width Petal.Length Petal.Width   Species
## 1          7.9         3.8          6.4         2.0 virginica
## 2          7.7         3.8          6.7         2.2 virginica
## 3          7.7         2.6          6.9         2.3 virginica
## 4          7.7         2.8          6.7         2.0 virginica
## 5          7.7         3.0          6.1         2.3 virginica
## 6          7.6         3.0          6.6         2.1 virginica
```

#### summarise()


``` r
sapply(split(iris$Sepal.Length, iris$Species), mean)
```

```
##     setosa versicolor  virginica 
##      5.006      5.936      6.588
```

``` r
iris |>
  dplyr::summarize(value = mean(Sepal.Length), .by = Species)
```

```
##      Species value
## 1     setosa 5.006
## 2 versicolor 5.936
## 3  virginica 6.588
```


### どちらを使えばよいのか

base R と tidyverse の違いが分かったところで，次に考えるべきは「どちらを使うべきか」という問題です。
結論から言えば，「自分にとって使いやすい方を選ぶ」のが適切です。

ここで「使いやすい」という言葉には，次の2つの側面が含まれています。

1. 自分がコードを理解しやすいこと。
2. 他人がコードを理解しやすいこと。

個人的な印象として，tidyverse は操作が直感的で，コードが簡潔かつ読みやすくなることが多いです。
一方で，常に最適とは限りません。
例えば、`map()` 関数を使用するケースでは，base R で書いた方が分かりやすくなることもあります。

コードの可読性には重要な意味があります。
理解しにくいコードはバグが発生しやすくなる一方で，可読性の高いコードは必ずしも処理速度が最速ではない場合があります。
このトレードオフを考慮して選択する必要があります。

また，個人的な感覚としては，tidyverse は柔軟性が高くモダンなイメージがあり，base R には伝統的で安定感のあるイメージがあります。
ただし，いずれを選ぶ場合でも，冗長で無駄の多いコードは避けるべきです。
効率的で簡潔な記述を心がけることが大切です。


## 練習問題

1. 次のデータフレーム `z` があるとする。`z` を使って，2000年以降の `value` の値の平均を求めなさい。ただし，ここでは tidyverse を用いなさい。

``` r
x <- 1990:2021
y <- seq(5000, 5030, 2)
z <- data.frame(year = x, value = y)
```

2. ポケモンの中から，tidyverse を用いて，water タイプのポケモンをすべて挙げなさい。
ただし，ポケモンのデータセットは，`d3po` パッケージの `pokemon` を使いなさい。

