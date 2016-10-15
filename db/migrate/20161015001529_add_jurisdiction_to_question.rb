class AddJurisdictionToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :jurisdiction, :integer
  end
end
