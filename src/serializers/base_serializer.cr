abstract class BaseSerializer < Lucky::Serializer
  alias ResultValue = Int16 | Int32 | String | Float64 | Bool | Nil |
      Lucky::Serializer | Array(Lucky::Serializer)

  def self.for_collection(collection : Enumerable, *args, **named_args)
    collection.map do |object|
      new(object, *args, **named_args).as(Lucky::Serializer)
    end
  end
end
