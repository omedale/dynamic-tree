require 'test_helper'
require 'json'
TREE = {
  "id": 1,
  "child": [
      {
          "id": 1891,
          "child": [
              {
                  "id": 2745,
                  "child": []
              },
              {
                  "id": 6941,
                  "child": [
                      {
                          "id": 6049,
                          "child": []
                      },
                      {
                          "id": 7388,
                          "child": []
                      }
                  ]
              },
              {
                  "id": 9894,
                  "child": [
                      {
                          "id": 7583,
                          "child": []
                      },
                      {
                          "id": 7925,
                          "child": []
                      }
                  ]
              }
          ]
      },
      {
          "id": 8211,
          "child": [
              {
                  "id": 6936,
                  "child": []
              },
              {
                  "id": 648,
                  "child": [
                      {
                          "id": 1928,
                          "child": []
                      },
                      {
                          "id": 9980,
                          "child": []
                      }
                  ]
              }
          ]
      }
  ]
}
class TreesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tree = Tree.new
    @tree.data = JSON.generate(TREE)
    @tree.save
  end
  test "test the saved structure" do
    get "/#{@tree.id}"

    assert_equal 200, @response.status
    assert_equal @tree.data, @response.body
  end

  test "test the list of parents IDs" do
    get "/#{@tree.id}/parent/#{6049}"

    assert_equal 200, @response.status
    assert_equal "[6941]", @response.body
  end

  test "test empty parents" do
    get "/#{@tree.id}/parent/#{00000}"

    assert_equal 200, @response.status
    assert_equal "null", @response.body
  end

  test "test the list of childs" do
    get "/#{@tree.id}/child/#{648}"
    childs =  [
                {
                    "id": 1928,
                },
                {
                    "id": 9980,
                }
            ]

    assert_equal 200, @response.status
    assert_equal JSON.generate(childs), @response.body
  end

  test "test empty childs" do
    get "/#{@tree.id}/child/#{000}"

    assert_equal 200, @response.status
    assert_equal "null", @response.body
  end
end
