describe Country, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :alpha2_code }
end
