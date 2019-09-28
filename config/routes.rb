Rails.application.routes.draw do
  get '/', to: 'trees#create'
  get '/:tree_id', to: 'trees#tree'
  get '/:tree_id/parent/:id', to: 'trees#parents'
  get '/:tree_id/child/:id', to: 'trees#childs'
end
