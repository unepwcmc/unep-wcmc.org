UnepWcmcOrg::Application.routes.draw do

  as :user do
    patch '/user/confirmation' => 'confirmations#update', via: :patch, as: :update_user_confirmation
    get 'users/edit' => 'registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'registrations#update', :as => 'user_registration'
  end

  devise_for :users, :controllers => { :confirmations => "confirmations" }, skip: [:registrations]

  namespace :admin do
    resources :employees do
      collection do
        put :reorder
      end
    end

    resources :aboutus_pages, except: [:new, :destroy]

    resources :expertise_pages, except: [:new, :destroy]

    resources :news_items do
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

    resources :policies do
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
