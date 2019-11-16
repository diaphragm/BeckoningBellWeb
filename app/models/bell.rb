class Bell < ApplicationRecord
  has_many :messages, dependent: :destroy

  # 消されてないアイテム
  def self.available
    Bell.where(deleted_at: nil)
  end

  # 消されてなくて最後のチャットからn時間前以降または部屋アプデからn時間以前のアイテム
  def self.expired
    expiration = (Time.now - Rails.configuration.x.bell_expiration_date)..Float::INFINITY
    av_bells = Bell.where(deleted_at: nil)
    with_message = av_bells.left_joins(:messages).where.not(messages: {id: nil})
    without_message = av_bells.left_joins(:messages).where(messages: {id: nil})
    (with_message.where.not(messages: {updated_at: expiration}).or without_message.where.not(updated_at: expiration)).distinct
  end

  def delete_logical
    update({deleted_at: Time.now})
  end
end
