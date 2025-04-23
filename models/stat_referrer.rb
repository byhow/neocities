# frozen_string_literal: true
class StatReferrer < Sequel::Model
  many_to_one :site
  RETAINMENT_DAYS = 7

  def self.prune!
    where{created_at < (RETAINMENT_DAYS-2).days.ago.to_date}.delete
  end

  def self.create_or_get(site_id, url)
    opts = {site_id: site_id, url: url}
    stat_referrer = where(opts).where{created_at > RETAINMENT_DAYS.days.ago}.first

    DB[table_name].lock('EXCLUSIVE') {
      stat_referrer = create opts.merge(created_at: Date.today)
    } if stat_referrer.nil?

    stat_referrer
  end
end
