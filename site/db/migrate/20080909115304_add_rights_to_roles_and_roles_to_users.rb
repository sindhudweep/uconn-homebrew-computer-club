class AddRightsToRolesAndRolesToUsers < ActiveRecord::Migration
  def self.up
    create_table :roles_users, :id => false, :force => true do |t|
      t.integer :role_id, :user_id
    end
    
    create_table :rights_roles, :id => false, :force => true do |t|
      t.integer :right_id, :role_id
    end

  end

  def self.down
    drop_table :rights_roles, :roles_users
  end
end
