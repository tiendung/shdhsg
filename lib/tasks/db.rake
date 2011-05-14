namespace :db do
  task :remake => %w[db:drop db:create db:seed] do
  end
end
