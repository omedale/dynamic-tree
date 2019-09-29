require 'net/http'
class TreesController < ApplicationController
  before_action :build_tree_data, only: %i[parents childs tree]
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def create
    uri = URI.parse('https://random-tree.herokuapp.com/')
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(
                              uri.host,
                              uri.port,
                              :use_ssl => uri.scheme == 'https'
                            ) { |http| http.request request}

    tree = Tree.new(data: response.body)
    if tree.save
      render json: { tree_id: tree.id, tree: JSON.parse(tree.data) }, status: :ok
    else
      render json:  { message: 'Ops!!, please try again' }, status: 400
    end
  end

  def tree
    render json: @obj.tree, status: :ok
  end

  def parents
    render json: @obj.get_parants(params[:id]), status: :ok
  end

  def childs
    render json: @obj.get_child(params[:id]), status: :ok
  end

  private

  def build_tree_data
    tree = Tree.find(params[:tree_id])
    data = JSON.parse(tree.data).deep_symbolize_keys!
    @obj = TreeService.new(data)
  end

  def handle_record_not_found
    render json: { message: 'Not found' }, status: 404
  end
end
