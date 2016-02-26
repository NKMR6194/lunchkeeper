# lunchkeeper
RHD Winter Internship 2016 ~Enginier 5days~

# 1. 背景

　　調査によって、多数の人は昼ごはんを選ぶ時、安さを一番重視するため、コンビニで適当に弁当を買うことが多い。また、同じ店や弁当の味を飽きながら、昼ごはんの選びに手間をかけたくない人も少なくありません。現在のオンラインデリバリーサービスとして、楽天デリバリーや出前館がありますが、どのサービスでもユーザーに店舗を選んでもらう必要がありますので、面倒だと思われることもあります。従って、ユーザー対して、オンラインデリバリーの場合、ユーザーに注文できるサービスを提供するだけではなく、注文の内容も決めてあげるサービスが求められています。

##1.1 目的

　　本サービスは、昼ごはんにおける安さと便利さと多種多様さを踏まえて、周辺の店舗メ情報から多数の店舗メニューを含める可能な五日間の昼ごはんプランをユーザーに提供する。

##1.2 設計方法

　　店舗メニューの情報をまとめて、ユーザーに複数のプランを提示するため、店舗をいくつの値段レベルに分けて、値段ごとにプランを作る必要があります。また、一つのプランに含まれる店舗のメニューの値段がと注文を処理する能力もそれぞれ違っているため、メニューを組み合わせて、できるだけユーザーが払った総値段に近づける必要もあります


# 2. 機能

##2.1 開発環境

　　CentOS on Amazon EC2<br /> 
　　Amazon RDS MySQL<br /> 
　　Nginx<br /> 
　　Unicorn<br /> 
　　Ruby on Rails

##2.2 機能

#####ユーザー：

　　１）アカウントの作成と登録・情報編集<br /> 
　　２）選択可能な昼ごはんプランの提示<br /> 
　　３）プランの注文<br /> 
　　４）注文履歴の確認<br /> 

#####店舗：

　　１）アカウントの登録・情報編集<br /> 
　　２）注文の確認

# 3. 実装方法

#####選択可能な昼ごはんプランの提示：

　　店舗をいくつの値段レベルに分けるため、店舗のメニューの平均値段を元にDBSCANというアルゴリズムでクラスターリングを行って、複数のプランと各プランに含まれる店舗を生成します。そのプランの総値段は全ての店舗の平均値段＊天数です。<br /> 
　　それぞれのプランに対して、K−SUMで一番総値段を近づくメニューの組み合わせを探し出します。また、当日の店舗の注文処理能力をマッチするため、N-QUEENで可能な順序をつける。もし適合な順序を見つからないの場合（全ての店舗の注文が既に限界になる）、上記の手続きを沿って、可能な組み合わせと順序を見つけるまで繰り返します。
　　
# 4. 利用シナリオ 
