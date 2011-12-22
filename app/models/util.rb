class Util

  def self.status_updater
    while
      lawyers = User.where("user_type='LAWYER' and is_approved=true and last_online is not null")
      puts lawyers.count
      i = 0
      lawyers.each {|lawyer|
        puts i.to_s
        status = (Time.now - lawyer.last_online.to_time)/60 < 2 ? true : false
        lawyer.update_attribute(:is_online, status)
        if !status && lawyer.is_busy?
          lawyer.update_attribute(:is_busy, false)
        end
        i+=1
      }
      sleep(120)
    end
  end

end
