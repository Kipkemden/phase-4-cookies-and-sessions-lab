class ArticleListSerializer < ActiveModel::Serializer
  attributes :id, :title, :minutes_to_read, :author, :preview

  def author
    object.user.username
  end

  def preview
    object.content.split("\n").first
  end
end
