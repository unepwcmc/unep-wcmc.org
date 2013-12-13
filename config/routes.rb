UnepWcmcOrg::Application.routes.draw do
  namespace :admin do
    resources :featured_projects do
      collection do
        put :reorder
      end
    end
  end

  comfy_route :cms_admin, :path => '/admin'
  comfy_route :cms, :path => '/', :sitemap => false
end
