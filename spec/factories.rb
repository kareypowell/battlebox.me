FactoryGirl.define do
	factory :user do
		first_name 	"Karey"
		last_name 	"Powell"
		email 			"kpowell@example.com"
		password 		"foobar"
		password_confirmation "foobar"
		birthday 		"1988-09-01"
		gender 			"M"
	end
end