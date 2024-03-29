require 'spec_helper'

describe User do
  
	before do 
		@user = User.new(first_name: "Example", last_name: "User", 
										 email: "example@example.com", password: "foobar",
										 password_confirmation: "foobar", birthday: "1900-01-01",
										 gender: "M") 
	end

	subject { @user }

	it { should respond_to(:first_name) }
	it { should respond_to(:last_name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:birthday) }
	it { should respond_to(:gender) }
	it { should respond_to(:authenticate) }

	it { should be_valid }

	describe "when first name is not present" do
		before { @user.first_name = " " }
		it { should_not be_valid }
	end

	describe "when last name is not present" do
		before { @user.last_name = " " }
		it { should_not be_valid }
	end

	describe "when email is not present" do
		before { @user.email = " " }
		it { should_not be_valid }
	end

	describe "when birthday is not present" do
		before { @user.birthday = " " }
		it { should_not be_valid }
	end

	describe "when gender is not present" do
		before { @user.gender = " " }
		it { should_not be_valid }
	end

	describe "when first name is too long" do
		before { @user.first_name = "a" * 26 }
		it { should_not be_valid }
	end

	describe "when first name is too short" do
		before { @user.first_name = "a" }
		it { should_not be_valid }
	end

	describe "when last name is too long" do
		before { @user.last_name = "a" * 26 }
		it { should_not be_valid }
	end

	describe "when last name is too short" do
		before { @user.last_name = "a" }
		it { should_not be_valid }
	end

	describe "when email format is invalid" do
		it "should be valid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo.
										 foo@bar_baz.com foo@bar+baz.com]
			addresses.each do |invalid_address|
				@user.email = invalid_address
				@user.should_not be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				@user.should be_valid
			end
		end
	end

	describe "when an email address is already taken" do
		before do
		  user_with_same_email = @user.dup
		  user_with_same_email.email = @user.email.upcase
		  user_with_same_email.save
		end

		it { should_not be_valid }
	end

	describe "when password is not present" do
		before { @user.password = @user.password_confirmation = " " }
		it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when password comfirmation is nil" do
		before { @user.password_confirmation = nil }
		it { should_not be_valid }
	end

	describe "when password is too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should_not be_valid }
	end

	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email) }

		describe "with valid password" do
			it { should == found_user.authenticate(@user.password) }
		end

		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }
			
			it { should_not == user_for_invalid_password }
			specify { user_for_invalid_password.should be_false }
		end
	end

end