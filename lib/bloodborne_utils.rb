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
      参加いいですか？
      よろしくお願いします
      ありがとう
      ごめんなさい
      間違えました
      さようなら
      落ちます
      少し離席します
    ],
    "ホスト向け" => %w[
      待ちます
      出発します
      待ってください
      迷いました
      案内してください
      先行しないでください
      鐘女は倒さないでください
    ],
    "戦略" => %w[
      走れ！
      見つからないように進みます
      油壷投げてください
      油壷投げます
      敵を倒します
      敵を無視します
      アイテムは無視します
      アイテムは回収します
      手を出さないでください
      交互に殴りましょう
      1体づつ釣りましょう
      突撃しましょう
      走り抜けましょう
    ],
    "ヒント/その他" => %w[
      ショートカットがあります
      アイテムがあります
      罠があります
      敵に注意
      素敵なキャラクリですね
      がんばれ！
      君は正しく、そして幸運だ
      宇宙は空にある
      さすがにおかしいなと(笑)
    ]
  }

  STAMP_LIST = %w[
    banzai_obaasan.png
    pose_ganbarou_man.png
    ok_woman.png
    hand_good.png
    hakusyu.png
    byebye_girl.png
    pose_inoru_woman.png
    pose_kiri_man.png
    sick_panic_man.png
    tehepero3_business_ojisan.png
    message_arigatou.png
    message_gomennasai.png
    message_omedetou.png
    message_otsukaresama.png
    message_yoroshiku.png
    message_tasukarimashita.png
    text_sankasya_bosyu.png
    text_syoshinsya_kangei.png
    mark_shimekiri.png
    text_abunai_h.png
    spiritual_woman.png
    animal_pig_buta.png
    bug_seakagokegumo.png
    character_cthulhu_yog_sothoth.png
    character_cthulhu_shoggoth.png
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
