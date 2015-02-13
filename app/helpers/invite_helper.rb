module InviteHelper
  # Returns the new invite ID
  def self.invite(to, from, company_id)
    invite_code = SecureRandom.hex

    new_invite_id = store_new_invite(invite_code, to, company_id)
    ArbitraryMailer.invite_email(to, from, invite_code).deliver

    new_invite_id
  end

  def self.store_new_invite(code, recipient, company_id)
    params = {
      :company_id  => company_id,
      :created     => DateTime.now,
      :invite_code => code,
      :recipient   => recipient
    }

    remove_duplicate_invites(recipient, company_id)

    invite = Invite.new(params)
    invite.save

    return invite.id
  end

  def self.remove_duplicate_invites(recipient, company_id)
    Invite.where({
      :recipient => recipient, :company_id => company_id
    }).destroy_all
  end
end
