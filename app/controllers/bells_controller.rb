class BellsController < ApplicationController
  def show
    @bell = Bell.find(params[:id])

    existing_users = @bell.messages.map{|m| m.user}.uniq
    session[@bell.id.to_s] ||= {"user" => generate_hunter_name(existing_users)}

  rescue ActiveRecord::RecordNotFound
    render plain: "err"
  end

  def new
  end

  def create
    @bell = Bell.new(bell_params)

    if @bell.save
      session[@bell.id.to_s] = {"user" => "狩りの主"}

      redirect_to @bell
    else
      render plain: "err"
    end
  end

  def update
    @bell = Bell.find(params[:id])
    @bell.update(bell_params)
    redirect_to @bell
  end

  private

  def bell_params
    params.require(:bell).permit(:place, :password, :note)
  end

  def generate_hunter_name(exclude = [])
    first = %w[烏羽 赤ローブ 血族狩り 聖堂街 連盟 マダラス 血 聖剣 流浪 ヤーナム 漁村 トゥメル 聖杯 星 白痴 聖職者 星界 悪夢 夢 最初 死体 旧主 ローラン 月 罹患者 車椅子 獣狩り 上位者狩り 教会 ヘムウィック 瞳 廃城 カイン メルゴー リボン 彼氏持ち 全裸 右回り 左回り 狂人 上位者 古い上位者 3本目 ノコギリ 火薬 烏 雷光 剣 輝く剣 車輪 星の瞳 撃鉄 葦名 エアプ]
    second = %w[狩人 古狩人 男 女 少女 少年 老婆 老人 人形 助言者 女医 異邦人 蜘蛛男 女王 学長 住人 娘 蜘蛛 教区長 獣 影 魔物 女王殺し 守り人 長 番人 番犬 末裔 異常者 銀獣 黒獣 巨人 豚 大男 人さらい 魔女 狂気者 学徒 苗床 悪霊 召使い 落とし子 脳喰らい 貞子 変態 栗本 地底人]

    100.times do
      name = "#{first.sample}の#{second.sample}"
      break name if exclude.none?(name)
    end
  end
end
