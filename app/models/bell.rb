class Bell < ApplicationRecord
  has_many :messages, dependent: :destroy

  # 消されてなくて最後のチャットからn時間前以降または部屋アプデからn時間以降のアイテム
  def self.available

    # av_ids = Message.select(:bell_id).where(updated_at: expiration).distinct.map(&:bell_id)
    # bwm = Bell.where(deleted_at: nil).where(id: av_ids)
    # Bell.where(deleted_at: nil).where(updated_at: expiration).or(bwm)

    expiration = (Time.now - Rails.configuration.x.bell_expiration_date)..Float::INFINITY
    av_bells = Bell.where(deleted_at: nil)
    with_message = av_bells.left_joins(:messages).where.not(messages: {id: nil})
    without_message = av_bells.left_joins(:messages).where(messages: {id: nil})
    ( with_message.where(messages: {updated_at: expiration}).or without_message.where(updated_at: expiration) ).distinct
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
