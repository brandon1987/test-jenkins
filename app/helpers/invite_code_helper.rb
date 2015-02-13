module InviteCodeHelper
    # Returns the new invite code
    def self.invite(recipient, company_id,secret_1,secret_2,secret_3)
      invite_code = get_invite_code()
      new_invite_id = store_new_invite_code(invite_code, recipient, company_id,secret_1,secret_2,secret_3)
      return invite_code  #return invite code
    end

    def self.store_new_invite_code(code, recipient, company_id,secret_1,secret_2,secret_3)
      params = {
        :company_id  => company_id,
        :invite_code => code,
        :recipient   => recipient,
        :secret1    => secret_1,
        :secret2    => secret_2,
        :secret3    => secret_3,
      }


      invite = InviteCode.new(params)
      invite.save

      return invite.id
    end

    def self.get_invite_code()
      invite_code=""
    	loop do 
    	  invite_code=SecureRandom.hex
    	  existingcodes=InviteCode.where(:invite_code=>invite_code)
    	  break if existingcodes.count==0
    	end 



    	return invite_code
    end
    
end