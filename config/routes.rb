UnepWcmcOrg::Application.routes.draw do

  as :user do
    patch '/users/confirmation' => 'confirmations#update', via: :patch, as: :update_user_confirmation
    get 'users/edit' => 'registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'registrations#update', :as => 'user_registration'
  end

  devise_for :users, :controllers => { :confirmations => "confirmations" }, skip: [:registrations]

  get "/about-us/news-archive" => redirect("/news")

  namespace :admin do
    resources :employees do
      collection do
        put :reorder
      end
    end

    resources :aboutus_pages, except: [:new, :destroy]

    resources :expertise_pages

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

  resources :job_applications, only: [:index, :show, :destroy]

  get '/download_all_applications_zip/:id', controller: :job_applications, action: :download_all_applications_zip, as: 'download_all_applications_zip'
  get '/download_all_applications_csv/:id', controller: :job_applications, action: :download_all_applications_csv, as: 'download_all_applications_csv'
  get '/download_application_zip/:id', controller: :job_applications, action: :download_application_zip, as: 'download_application_zip'

  namespace :api do
    resources :geoip, only: [:index]
    resources :countries, only: [:index]
    resources :employees, only: [:index]
  end

  get 'test_exception_notifier', controller: :application, action: :test_exception_notifier

  comfy_route :cms_admin, :path => '/admin'
  comfy_route :cms, :path => '/', :sitemap => true
end
