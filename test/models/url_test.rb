require "test_helper"

class UrlTest < ActiveSupport::TestCase
  test "should be valid with valid original_url" do
    url = Url.new(original_url: "http://www.example.com")
    assert url.valid?
  end

  test "should be invalid with invalid original_url" do
    url = Url.new(original_url: "invalid_url")
    assert_not url.valid?
    assert_equal ["is invalid"], url.errors[:original_url]
  end

  test "should generate a short url" do
    url = Url.create(original_url: "http://www.example.com")
    assert_not_nil url.short_url
  end

  test "should generate unique short urls" do
    url1 = Url.create(original_url: "http://www.example.com")
    url2 = Url.create(original_url: "http://www.example.net")
    assert_not_equal url1.short_url, url2.short_url
  end

  test "should generate short url with length six" do
    url = Url.create(original_url: "http://www.example.com")
    assert_equal 6, url.short_url.length
  end

  test "should generate different short urls for different original urls" do
    url1 = Url.create(original_url: "http://www.example.com")
    url2 = Url.create(original_url: "http://www.example.net")
    assert_not_equal url1.short_url, url2.short_url
  end
end
