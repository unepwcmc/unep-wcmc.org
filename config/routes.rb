UnepWcmcOrg::Application.routes.draw do
  comfy_route :cms_admin, :path => '/admin'
  comfy_route :cms, :path => '/', :sitemap => false
end
