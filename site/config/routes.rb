ActionController::Routing::Routes.draw do |map|
  map.resources :blurbs

  map.root :controller => "Greeter"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
