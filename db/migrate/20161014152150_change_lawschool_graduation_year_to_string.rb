class ChangeLawschoolGraduationYearToString < ActiveRecord::Migration
  def change
    change_column :lawschool_details, :year_graduated, :string
  end
end
