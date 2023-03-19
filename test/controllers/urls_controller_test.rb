require "test_helper"

class UrlsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @url = urls(:one)
  end

  test "should redirect to original url" do
    get '', params: { id: @url.short_url }
    assert_redirected_to @url.original_url
  end

  test "should return error when short url not found" do
    get '', params: { id: "invalid_id" }
    assert_response :not_found
    assert_equal "Short URL not found", JSON.parse(@response.body)["error"]
  end

  test "should create url with valid params" do
    assert_difference("Url.count") do
      post '/api/encode', params: { original_url: "http://www.example.com/testencode" }, headers: { "Accept" => "application/json" }
    end

    assert_response :success
    assert_equal "http://www.example.com/#{Url.last.short_url}", JSON.parse(@response.body)["short_url"]
  end

  test "should return errors with invalid params" do
    assert_no_difference("Url.count") do
      post '/api/encode', params: { original_url: "invalid_url" }, headers: { "Accept": "application/json" }
    end

    assert_response :unprocessable_entity
    assert_equal ["Original url is invalid"], JSON.parse(@response.body)["errors"]
  end

  test "should decode short url" do
    get '/api/decode', params: { short_url: "http://www.example.com/#{@url.short_url}" }, headers: { "Accept" => "application/json" }
    assert_response :success
    assert_equal @url.original_url, JSON.parse(@response.body)["original_url"]
  end

  test "should return error when short url not found when decode" do
    get '/api/decode', params: { short_url:  "http://www.example.com/invalid_short_url"}
    assert_response :not_found
    assert_equal "Short URL not found", JSON.parse(@response.body)["error"]
  end
end
