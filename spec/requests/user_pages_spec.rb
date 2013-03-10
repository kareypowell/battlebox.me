require 'spec_helper'

describe "User pages" do
  
	subject { page }

	describe "signup page" do
		before { visit signup_path }

		# it { should have_selector("h1", text: "Sign up") }
		it { should have_selector("title", text: full_title("Sign up")) }
	end

	describe "signup" do
		before { visit signup_path }

		let(:submit) { "Sign Up" }

		describe "with invalid information" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end

			describe "after submission" do
				before { click_button submit }

				it { should have_selector("title", text: "Sign up") }
				it { should have_content("error") }
				it { should have_no_content("Password digest") }
			end
		end

		describe "with valid information" do
			before do
			  fill_in "user[first_name]", with: "Example"
				fill_in "user[last_name]", 	with: "User"
				fill_in "user[email]", 			with: "example@example.com"
				fill_in "user[password]", 	with: "foobar"
				fill_in "user[password_confirmation]", 	with: "foobar"
				select "Sep", 							from: "user[birthday(2i)]"
				select "1", 								from: "user[birthday(3i)]"
				select "1988", 							from: "user[birthday(1i)]"
				choose "user_gender_m"
			end

			it "should create a user" do
				expect { click_button submit }.to change(User, :count).by(1)
			end

			describe "after saving a user" do
				before { click_button submit }

				let(:user) { User.find_by_email("example@example.com") }

				it { should have_selector("p", text: "#{user.first_name} #{user.last_name}") }
				it { should have_selector("div.alert.alert-success", text: "Thank you") }
			end
		end
	end

end