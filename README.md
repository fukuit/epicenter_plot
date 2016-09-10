# epicenter_plot
地震の震源データを気象庁からダウンロードして、日本地図にマッピングする
- get_eqdata.pl
- epicenter_plot.R

http://qiita.com/fukuit/items/70b73785974f7457358c で使用したコード。

## 使い方
以下のように、perl で、引数としてYYYYMMDD形式で日付を与えると、YYYYMMDD.txtというタブ区切り形式の震源データがダウンロードされる。
>	perl get_eqdata.pl 20160901
R上で、epicenter_plot.Rを実行すると、pngファイルとして日本地図に震源がマッピングされた図が作成される。
Rでは、事前にggmapをインストールしておく。
>	install.packages("ggmap")

