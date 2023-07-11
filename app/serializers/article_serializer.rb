class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :minutes_to_read, :author, :content

  def author
    object.user.username
  end
end
