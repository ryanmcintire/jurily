class AddJurisdictionToBarAdmission < ActiveRecord::Migration
  def change
    add_column :bar_admissions, :jurisdiction, :integer
  end
end
