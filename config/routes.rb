Battlebox::Application.routes.draw do

	resources :users

	root to: "users#new"

	match "/home", to: "static_pages#home"
	match "/signup", to: "users#new"
  match "/about", to: "static_pages#about"
	match "/help", to: "static_pages#help"
	match "/policy", to: "static_pages#policy"

end
