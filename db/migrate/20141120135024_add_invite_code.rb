class AddInviteCode < ActiveRecord::Migration
	def change
	    create_table :invite_codes do |t|
	    	t.timestamps
	    	t.integer :company_id, :default => -1
	    	t.text :invite_code
	    	t.integer :secret1 ,:default => 0
	    	t.integer :secret2, :default => 0
	    	t.integer :secret3, :default => 0
	    	t.string :recipient, :limit=>255, :default=>""
    	end
	end
end
