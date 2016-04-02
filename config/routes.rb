Rails.application.routes.draw do
  devise_for :users
  resources :operations
  resources :workers
  resources :workshops
  resources :actions
  get 'actions/addCustomAction', to: 'actions#addCustomAction', as: :addCustomAction
  resources 'operation_costs'

  get 'sprav/chooseOrg'
  post 'sprav/chooseOrg'
  post 'sprav/chooseOperation'
  get 'sprav/chooseOperation'
  post 'sprav/createAction'
  get 'sprav/chooseLinkedOperation'
  get 'sprav/selectLinkedOper'
  get 'sprav/selectLinkedWorker'
  get 'sprav/printTicket', to: 'sprav#printTicket', as: :sprav_Print
  get 'sprav/printTicket/:id', to: 'sprav#printTicket'

  post 'actions/:id/updateCnt', to: 'actions#updateCnt', as: :updateCnt
  post 'actions/:id/updateCost', to: 'actions#updateCost', as: :updateCost
  get 'report/refreshWorkerStat'
  get 'x/updateAddCustomActionInfo/:workshop_id', to: 'report#refreshModalOpList', as: :refreshModalOpList
  get 'x/updateAddCustomActionInfo', to: 'report#refreshModalOpList'


  root 'navigate#startPage'
  get 'navigate/startPage'
  post '/'=>'navigate#startPage'
  get 'sprav/createAction'
  get 'navigate/sprav/chooseOrg'=>'sprav/chooseOrg'
  post 'sprav/registerAction'
  get '/admin', :to => redirect('/admin.html')
  get '/report' => 'report#index'
  get 'report/showstat1'
  get 'report/refreshStat1'
  get 'report/getWorkerStatPDF'
  get 'report/stat1'
  get 'report/showModalWorkerStat', as: :modalWorkerStat
  get 'report/showModalEditAction', as: :modalEditAction
  get '/workers/:id/month/:month', to: 'workers#showstat'
  get '/workers/:id/period/:period', to: 'workers#period'
  post 'actions/saveCustomAction', as: :saveCustomAction
  get 'report/selectWorkerForCustomAction'
#  get 'operation_costs/new', controller: 'operation_costs', action: :new
      
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
