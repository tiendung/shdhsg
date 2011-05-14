require 'dragonfly'
app = Dragonfly[:images]

app.configure_with(:imagemagick)

app.configure_with(:rails) do |c|
  c.datastore = Dragonfly::DataStorage::MongoDataStore.new :db => Mongoid.database
end

app.define_macro_on_include(Mongoid::Document, :image_accessor)
