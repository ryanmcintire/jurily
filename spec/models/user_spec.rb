require 'rails_helper'

describe User do

  it 'has email and password' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without email' do
    expect(build(:user, email: nil)).to_not be_valid
  end

  it 'is invalid without valid email' do
    expect(build(:user, email: 'not_an_email')).to_not be_valid
  end

  it 'is invalid without password' do
    expect(build(:user, password: nil)).to_not be_valid
  end

  it 'is invalid with short password' do
    expect(build(:user, password: FFaker::Internet.password(1,6))).to_not be_valid
  end

  subject { create(:user) }

  describe '#question_score' do
    it 'returns 0 if there are no questions' do
      expect(subject.question_score).to eq(0)
    end
  end

  describe '#answer_score' do
    it 'returns 0 if there are no answers' do
      expect(subject.answer_score).to eq(0)
    end
  end
end