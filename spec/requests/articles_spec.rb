require 'rails_helper'

RSpec.describe "GET /articles/:id", type: :request do
  before do
    user = User.create(username: 'author')
    user.articles.create(title: 'Article 1', content: "Content 1\nparagraph 1", minutes_to_read: 10)
  end

  context 'with one pageview' do
    it 'returns the correct article' do
      get "/articles/#{Article.first.id}"

      expect(response.body).to include_json({
        id: Article.first.id, title: 'Article 1', minutes_to_read: 10, author: 'author', content: "Content 1\nparagraph 1"
      })
    end

    it 'uses the session to keep track of the number of page views' do
      get "/articles/#{Article.first.id}"

      expect(session[:page_views]).to eq(1)
    end
  end

  context 'with three pageviews' do
    it 'returns the correct article' do
      get "/articles/#{Article.first.id}"
      get "/articles/#{Article.first.id}"
      get "/articles/#{Article.first.id}"

      expect(response.body).to include_json({
        id: Article.first.id, title: 'Article 1', minutes_to_read: 10, author: 'author', content: "Content 1\nparagraph 1"
      })
    end

    it 'uses the session to keep track of the number of page views' do
      get "/articles/#{Article.first.id}"
      get "/articles/#{Article.first.id}"
      get "/articles/#{Article.first.id}"

      expect(session[:page_views]).to eq(3)
    end
  end

  context 'with more than three pageviews' do
    it 'returns an error message' do
      get "/articles/#{Article.first.id}"
      get "/articles/#{Article.first.id}"
      get "/articles/#{Article.first.id}"
      get "/articles/#{Article.first.id}"

      expect(response.body).to include_json({
        error: "Maximum pageview limit reached"
      })
    end

    it 'returns a 401 unauthorized status' do
      get "/articles/#{Article.first.id}"
      get "/articles/#{Article.first.id}"
      get "/articles/#{Article.first.id}"
      get "/articles/#{Article.first.id}"

      expect(response).to have_http_status(:unauthorized)
    end

    it 'uses the session to keep track of the number of page views' do
      get "/articles/#{Article.first.id}"
      get "/articles/#{Article.first.id}"
      get "/articles/#{Article.first.id}"
      get "/articles/#{Article.first.id}"

      expect(session[:page_views]).to eq(4)
    end
  end
end
