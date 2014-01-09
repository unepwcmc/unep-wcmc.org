UnepWcmcOrg::Application.routes.draw do
  namespace :admin do
  end

  namespace :admin do
    resources :employees do
      collection do
        put :reorder
      end
    end

    resources :programmes, except: [:show]

    resources :featured_projects do
      collection do
        put :reorder
      end
    end

    resources :datasets do
      collection do
        put :reorder
      end
    end

    resources :vacancies do
      collection do
        put :reorder
      end
    end

  end

  resources :forms, only: [] do
    resources :submissions, path: "applications", except: [:index]
  end

  comfy_route :cms_admin, :path => '/admin'
  comfy_route :cms, :path => '/', :sitemap => false
end
