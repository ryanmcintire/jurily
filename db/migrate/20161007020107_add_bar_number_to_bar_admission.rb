class AddBarNumberToBarAdmission < ActiveRecord::Migration
  def change
    add_column :bar_admissions, :bar_number, :string
  end
end
