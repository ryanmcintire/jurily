require 'rails_helper'

describe Question do

  it 'has title, body, jurisdiction' do
    expect(build(:question)).to be_valid
  end

  it 'is invalid without title' do
    expect(build(:question, title: nil)).to_not be_valid
  end

  it 'is invalid with short title' do
    expect(build(:question, title: '12345')).to_not be_valid
  end

  it 'is invalid with excessive title' do
    expect(build(:question, title: FFaker::Lorem.characters(251))).to_not be_valid
  end

end