class Bell < ApplicationRecord
  has_many :messages, dependent: :destroy

  def Bell.availables
    # 消されてなくて最後のチャットからn時間前以降または部屋アプデからn時間以降
    expiration = (Time.now - Rails.configuration.x.bell_expiration_date)..Float::INFINITY

    av_ids = Message.select(:bell_id).where(updated_at: expiration).distinct.map(&:bell_id)
    bwm = Bell.where(deleted_at: nil).where(id: av_ids)
    Bell.where(deleted_at: nil).where(updated_at: expiration).or(bwm)
  end

  def delete_logical
    update({deleted_at: Time.now})
  end
end
