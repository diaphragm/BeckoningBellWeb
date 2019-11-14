module BloodborneUtils
  module_function

  NAME_FIRST = %w[烏羽 赤ローブ 血族狩り 聖堂街 連盟 マダラス 血 聖剣 流浪 ヤーナム 漁村 トゥメル 聖杯 星 白痴 聖職者 星界 悪夢 夢 最初 死体 旧主 ローラン 月 罹患者 車椅子 獣狩り 上位者狩り 教会 ヘムウィック 瞳 廃城 カイン メルゴー リボン 彼氏持ち 全裸 右回り 左回り 狂人 上位者 古い上位者 3本目 ノコギリ 火薬 烏 雷光 剣 輝く剣 車輪 星の瞳 撃鉄 葦名 エアプ]
  NAME_SECOND = %w[狩人 古狩人 男 女 少女 少年 老婆 老人 人形 助言者 女医 異邦人 蜘蛛男 女王 学長 住人 娘 蜘蛛 教区長 獣 影 魔物 女王殺し 守り人 長 番人 番犬 末裔 異常者 銀獣 黒獣 巨人 豚 大男 人さらい 魔女 狂気者 学徒 苗床 悪霊 召使い 落とし子 脳喰らい 貞子 変態 栗本 地底人]

  PLACE_LIST = %w[
    一階病室 ヤーナム市街 大橋 オドンの地下墓 ヤーナム聖堂街 大聖堂 聖堂街 上層
    星輪草の庭 嘆きの祭壇 ヤーナム旧市街 聖杯教会 黒獣の墓地 ヘムウィックの墓地街 魔女の館
    禁域の森 禁域の墓 ビルゲンワース 月前の湖 隠し街ヤハグル ヤハグル教会 再誕の広場 地下牢
    廃城カインハースト ローゲリウスの座 血の女王の間 捨てられた古工房 教室棟 教室棟2F 悪夢の辺境
    アメンドーズの寝所 メンシスの悪夢 メルゴーの高楼 ふもと メルゴーの高楼 中腹 乳母の月見台
    狩人の悪夢 悪夢の教会 地下死体溜り 悪夢の大聖堂 実験棟 星輪樹の庭 時計塔 漁村 灯台脇の小屋 海岸
    聖職者の獣霧前 ガスコイン神父霧前 血に渇いた獣霧前 ヘムウィックの魔女霧前 教区長エミーリア霧前
    ヤーナムの影霧前 黒獣パール霧前 アメンドーズ霧前 殉教者ローゲリウス霧前 白痴の蜘蛛、ロマ霧前
    再誕者霧前 星界からの使者霧前 星の娘、エーブリエタース霧前 悪夢の主、ミコラーシュ霧前
    メルゴーの乳母霧前 最初の狩人、ゲールマン霧前 月の魔物霧前 醜い獣、ルドウイーク霧前
    初代教区長ローレンス霧前 失敗作たち霧前 時計塔のマリア霧前 ゴースの遺子霧前 聖杯ダンジョン
  ]

  MESSAGE_LIST = {
    "返答/挨拶" => %w[
      OK
      はい
      いいえ
      よろしくお願いします
      間違えました
      ごめんなさい
      ありがとう
      さようなら
      落ちます
    ],
    "ホスト向け" => %w[
      待ちます
      出発します
      待ってください
      迷いました
      案内してください
      先行しないでください
      鐘女は倒さないでください
      見つからないように進みます
      敵は無視します
      敵は倒します
      アイテムは回収します
      アイテムは無視します
    ],
    "ゲスト向け" => %w[
      参加いいですか？
      案内しましょうか？
      待ってください
      少し離席します
      どこにいますか？
    ],
    "聖杯" => %w[
      レバーを引いてください
      扉を開けてください
      上の方にいます
      下の方にいます
      灯りの近くにいます
      宝箱の近くにいます
      灯り前横道にいます
      レバーの近くにいます
      ボス前横道にいます
    ],
    "その他" => %w[
      合流しましょう
      油壷投げてください
      油壷投げます
      素敵なキャラクリですね
      宇宙は空にある
      さすがにおかしいなと(笑)
    ]
  }

  STAMP_LIST = %w[
    banzai_obaasan.png
    byebye_girl.png
    job_shitsuji_oldman.png
    omairi_girl.png
    medical_touchukasou_semi.png
  ]

  def generate_hunter_name(exclude = [])
    100.times do
      name = "#{NAME_FIRST.sample}の#{NAME_SECOND.sample}"
      break name if exclude.none?(name)
    end
  end

  def place_list
    PLACE_LIST.map.with_index{|x, i| [x, i]}
  end

  def find_place(index)
    PLACE_LIST[index.to_i]
  end

  def message_list
    id = 0
    list = {}
    MESSAGE_LIST.each do |k, a|
      list[k] = []
      a.each do |x|
        list[k].push({id: id, text: x})
        id += 1
      end
    end
    list
  end

  def find_message(index)
    MESSAGE_LIST.values.flatten[index.to_i]
  end

  def stamp_list
    STAMP_LIST.map.with_index{|x, i| {id: i, text: x}}
  end

  def find_stamp(index)
    STAMP_LIST[index.to_i]
  end

  def host_name
    "狩りの主"
  end

end
