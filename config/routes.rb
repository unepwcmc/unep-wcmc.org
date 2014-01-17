UnepWcmcOrg::Application.routes.draw do

  as :user do
    patch '/user/confirmation' => 'confirmations#update', via: :patch, as: :update_user_confirmation
  end

  devise_for :users, :controllers => { :confirmations => "confirmations" }

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

    resources :users
  end

  resources :forms, only: [] do
    resources :submissions, path: "applications", except: [:index]
  end

  comfy_route :cms_admin, :path => '/admin'
  comfy_route :cms, :path => '/', :sitemap => false
end
