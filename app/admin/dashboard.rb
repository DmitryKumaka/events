ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: "Resent Events" do
    table_for Event.order("created_at desc").limit(5) do
      column :name
      column :date
      column :created_at
    end
    strong { link_to "View All Events", admin_events_path }

  end
end
