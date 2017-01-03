describe Request, type: :model do
  it { should validate_presence_of :from }
  it { should validate_presence_of :subject }
  it { should validate_presence_of :content }
end
