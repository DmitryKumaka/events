ActiveAdmin.register Event do
  menu priority: 2

  index do
    column :id
    column :name
    column :date
    column :visited_flag
    column "Users" do |event|
      event.users.map { |user| user.email }
    end
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :date
  filter :visited_flag
  filter :created_at
  filter :updated_at
  filter :users, collection: -> { User.all.map { |user| [user.email, user.id] } }
end
