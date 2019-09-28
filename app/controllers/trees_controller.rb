require 'net/http'
class TreesController < ApplicationController
  before_action :build_tree_data, only: %i[parents childs tree]

  def create
    uri = URI.parse('https://random-tree.herokuapp.com/')
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(
                              uri.host,
                              uri.port,
                              :use_ssl => uri.scheme == 'https'
                            ) { |http| http.request request}

    Tree.create(data: response.body)
    render nothing: true, status: :ok
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
end
