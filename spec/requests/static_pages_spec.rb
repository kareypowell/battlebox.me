require 'spec_helper'

describe "Static pages" do

	subject { page }
  
	describe "Home page" do
		before { visit home_path }

		it { should have_selector("h1", text: "The BattleBox.Me App") }
		it { should have_selector("title", text: full_title('')) }
		it { should have_no_selector("title", text: "| Home") }
	end

	describe "About page" do
		before { visit about_path }

		it { should have_selector("h1", text: "About Us") }
		it { should have_selector("title", text: full_title("About Us")) }
	end

	describe "Help page" do
		before { visit help_path }

		it { should have_selector("h1", text: "Help") }
		it { should have_selector("title", text: full_title("Help")) }
	end

	describe "Policy page" do
		before { visit policy_path }

		it { should have_selector("h1", text: "Our Policy") }
		it { should have_selector("title", text: full_title("Our Policy")) }
	end

	# it "should have the right links on the layout" do
	# 	visit root_path
	# 	click_link "About"
	# 	page.shoud have_selector("title", text: full_title("About Us"))
	# 	click_link "Help"
	# 	page.shoud have_selector("title", text: full_title("Help"))
	# 	click_link "Policy"
	# 	page.shoud have_selector("title", text: full_title("Our Policy"))
	# end

end